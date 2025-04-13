-- All possible airport-to-airport connections
local cities = {
    "Littleton", "Littlesis", "Jackville", "Bigton", "Kastenville", 
    "Dangen", "Mono", "Kuma", "Gristown", "Mayfield", "Bristol",
    "Redrock", "Oakvale", "Silverport", "Westfield", "Riverdale", 
    "Pinehaven", "Meadowbrook", "Sunnydale", "Frostpeak"
}

local city_data = {
    ["Littleton"] = {pos = {300,300}, category = 1},
    ["Littlesis"] = {pos = {350,250}, category = 1},
    ["Jackville"] = {pos = {500,500}, category = 1},
    ["Bigton"] = {pos = {200,500}, category = 2},
    ["Kastenville"] = {pos = {1200,400}, category = 3},
    ["Dangen"] = {pos = {1250,300}, category = 2},
    ["Mono"] = {pos = {1130,345}, category = 1},
    ["Kuma"] = {pos = {1280,360}, category = 1},
    ["Gristown"] = {pos = {1000,500}, category = 3},
    ["Mayfield"] = {pos = {400,600}, category = 3},
    ["Bristol"] = {pos = {650,200}, category = 3},
    ["Redrock"] = {pos = {820,450}, category = 2},
    ["Oakvale"] = {pos = {550,350}, category = 1},
    ["Silverport"] = {pos = {900,150}, category = 3},
    ["Westfield"] = {pos = {750,620}, category = 2},
    ["Riverdale"] = {pos = {150,180}, category = 1},
    ["Pinehaven"] = {pos = {1100,600}, category = 2},
    ["Meadowbrook"] = {pos = {480,180}, category = 1},
    ["Sunnydale"] = {pos = {950,400}, category = 3},
    ["Frostpeak"] = {pos = {300,100}, category = 2}
}

-- Function to calculate base passenger demand based on airport categories and distance
local function calculate_base_demand(from_category, to_category, distance)
    -- Calculate based on the provided criteria
    if from_category == 3 and to_category == 3 then
        if distance < 500 then
            return 3000
        elseif distance < 3000 then
            return 1500
        else
            return 500
        end
    elseif (from_category == 3 and to_category == 2) or (from_category == 2 and to_category == 3) then
        if distance < 500 then
            return 500
        elseif distance < 3000 then
            return 250
        else
            return 100
        end
    elseif (from_category == 3 and to_category == 1) or (from_category == 1 and to_category == 3) then
        if distance < 500 then
            return 100
        elseif distance < 3000 then
            return 50
        else
            return 15
        end
    elseif from_category == 2 and to_category == 2 then
        if distance < 500 then
            return 200
        elseif distance < 3000 then
            return 100
        else
            return 30
        end
    elseif (from_category == 2 and to_category == 1) or (from_category == 1 and to_category == 2) then
        if distance < 500 then
            return 60
        elseif distance < 3000 then
            return 30
        else
            return 10
        end
    elseif from_category == 1 and to_category == 1 then
        if distance < 500 then
            return 20
        elseif distance < 3000 then
            return 10
        else
            return 5
        end
    end
    
    -- Fallback (should never reach here)
    return 10
end

-- Function to calculate ticket price based on distance
local function calculate_ticket_price(distance)
    if distance < 500 then
        return 100
    elseif distance < 3000 then
        return 250
    else
        return 500
    end
end

-- Generate all possible routes (each city can connect to every other city)
local routes = {}
local route_index = 1

for i = 1, #cities do
    local from_city = cities[i]
    local from_data = city_data[from_city]
    
    for j = 1, #cities do
        if i ~= j then -- Don't connect a city to itself
            local to_city = cities[j]
            local to_data = city_data[to_city]
            
            -- Calculate distance between cities
            local dx = from_data.pos[1] - to_data.pos[1]
            local dy = from_data.pos[2] - to_data.pos[2]
            local pixel_distance = math.sqrt(dx*dx + dy*dy)
            local distance = pixel_distance * 10 -- Each pixel is 10km
            
            -- Calculate base passenger demand based on airport categories and distance
            local base_demand = calculate_base_demand(from_data.category, to_data.category, distance)
            
            -- Calculate ticket price based on distance
            local ticket_price = calculate_ticket_price(distance)
            
            -- Create route entry
            routes[route_index] = {
                id = route_index,
                from = from_city,
                to = to_city,
                from_category = from_data.category,
                to_category = to_data.category,
                distance = distance,
                base_passenger_demand = base_demand,
                current_passenger_demand = base_demand, -- Initialize current demand to base demand
                ticket_price = ticket_price, -- Add ticket price
                player_planes = {}, -- Array to track which players have planes on this route
                total_passenger_capacity = 0, -- Total passenger capacity across all planes
                -- Add additional fields here as needed
            }
            
            route_index = route_index + 1
        end
    end
end

-- Return both cities and routes
return {
    cities = {
        {name = "Littleton", pos = {300,300}, category = 1},
        {name = "Littlesis", pos = {350,250}, category = 1},
        {name = "Jackville", pos = {500,500}, category = 1},
        {name = "Bigton", pos = {200,500}, category = 2},
        {name = "Kastenville", pos = {1200,400}, category = 3},
        {name = "Dangen", pos = {1250,300}, category = 2},
        {name = "Mono", pos = {1130,345}, category = 1},
        {name = "Kuma", pos = {1280,360}, category = 1},
        {name = "Gristown", pos = {1000,500}, category = 3},
        {name = "Mayfield", pos = {400,600}, category = 3},
        {name = "Bristol", pos = {650,200}, category = 3},
        {name = "Redrock", pos = {820,450}, category = 2},
        {name = "Oakvale", pos = {550,350}, category = 1},
        {name = "Silverport", pos = {900,150}, category = 3},
        {name = "Westfield", pos = {750,620}, category = 2},
        {name = "Riverdale", pos = {150,180}, category = 1},
        {name = "Pinehaven", pos = {1100,600}, category = 2},
        {name = "Meadowbrook", pos = {480,180}, category = 1},
        {name = "Sunnydale", pos = {950,400}, category = 3},
        {name = "Frostpeak", pos = {300,100}, category = 2},
    },
    routes = routes
}