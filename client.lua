local debug = false

local allowed_vehicles = {
    [1] = "1177543287" -- dubsta
}

local banned_terrains = {
    [1] = "1333033863", --grass
    [2] = "-1885547121", -- desert and rock
    [3] = "-1907520769", -- desert
    [4] = "-1595148316", -- desert & beach sand
    [5] = "-1286696947", -- sand mixed grass
    [6] = "-840216541", -- desert
    [7] = "1288448767", -- wet beach sand
    [8] = "-1942898710", -- desert mixed grass
    [9] = "951832588", -- 2d grass
    [10] = "-461750719" -- grass mountain
}

Citizen.CreateThread(
    function()
        while true do
            local ped = GetPlayerPed(-1)

            if GetVehiclePedIsIn(ped) then
                CheckVehicleGround(ped)
            end

            Citizen.Wait(300)
        end
    end
)

local isVehicleinBannedTerrain = false

function CheckVehicleGround(ped)
    local veh = GetVehiclePedIsUsing(ped)

    local material = GetGroundHash(veh)

    if debug == true then
        print(material)
    end

    if veh ~= 0 then
        local speed = GetEntitySpeed(veh)
        local maxSpeed = GetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveMaxFlatVel")

        for i, v in pairs(banned_terrains) do
            if tostring(material) == tostring(banned_terrains[i]) then
                isVehicleinBannedTerrain = true
            else
                isVehicleinBannedTerrain = false
            end
        end

        if isVehicleinBannedTerrain then
            for i, v in pairs(allowed_vehicles) do
                if tostring(allowed_vehicles[i]) ~= tostring(GetEntityModel(veh)) then
                    --print("Wrong car, wrong terrain."..speed)
                    if tonumber(speed) > 1 then
                        cruise = GetEntitySpeed(veh)
                        if cruise > 60 then
                            cruise = 30
                        end
                        SetEntityMaxSpeed(veh, cruise - 1)
                    end
                end
            end
        else
            SetEntityMaxSpeed(veh, maxSpeed)
        end
    end
end

function GetGroundHash(veh)
    local coords = GetEntityCoords(veh)
    local num =
        StartShapeTestCapsule(coords.x, coords.y, coords.z + 4, coords.x, coords.y, coords.z - 2.0, 1, 1, veh, 7)
    local arg1, arg2, arg3, arg4, arg5 = GetShapeTestResultEx(num)
    return arg5
end
