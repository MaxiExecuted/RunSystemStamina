--[[
    RunSystemServer.lua
    This script manages the running mechanic on the server side, handling stamina consumption and regeneration for players.
]]

local Players = game:GetService("Players")
local Event = Instance.new("RemoteEvent")
Event.Name = "RunEvent"
Event.Parent = game.ReplicatedStorage

-- Table to track if a player is running
local runningPlayers = {}


local function onPlayerAdded(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local stamina = Instance.new("IntValue")
    stamina.Name = "Stamina"
    stamina.Value = 100
    stamina.Parent = leaderstats

    runningPlayers[player] = false

    -- Regenerate stamina over time only if not running
    task.spawn(function()
        while player and player.Parent do
            if stamina.Value < 100 and not runningPlayers[player] then
                stamina.Value += 1
            end
            task.wait(0.05)
        end
    end)

    player.AncestryChanged:Connect(function(_, parent)
        if not parent then
            runningPlayers[player] = nil
        end
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)


Event.OnServerEvent:Connect(function(player, isRunning)
    local stamina = player:WaitForChild("leaderstats"):WaitForChild("Stamina")

    -- Update running state
    if typeof(isRunning) == "boolean" then
        runningPlayers[player] = isRunning
    end

    if runningPlayers[player] then
        if stamina.Value > 0 then
            stamina.Value -= 1
            print(player.Name .. " is running. Stamina left: " .. stamina.Value)
        else
            print(player.Name .. " has no stamina left to run.")
            runningPlayers[player] = false -- Stop running if stamina is depleted
            isRunning = false -- Ensure running state is updated
        end
    end

    Event:FireClient(player, stamina.Value) -- Notify the client about the stamina change
end)
