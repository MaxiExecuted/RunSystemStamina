--[[
    RunSystemClient.lua
    This script handles the running mechanic for players, consuming stamina when running and resetting speed when stamina is depleted.
]]


local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Event = game.ReplicatedStorage:WaitForChild("RunEvent")
local UserInputService = game:GetService("UserInputService")
local canRun = true
local isRunning = false
local runLoop = nil

Event.OnClientEvent:Connect(function(stamina)
    if stamina <= 0 then
        canRun = false
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = 16
        end
        print("Stamina depleted. Cannot run.")
    else
        canRun = true
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode.LeftShift and canRun and not isRunning then
        isRunning = true
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = 32
        end
        Event:FireServer(true) -- Notify server running started
        runLoop = task.spawn(function()
            while isRunning and canRun do
                Event:FireServer(true)
                task.wait(0.1)
            end
        end)
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode.LeftShift and isRunning then
        isRunning = false
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = 16
        end
        Event:FireServer(false) -- Notify server running stopped
    end
end)