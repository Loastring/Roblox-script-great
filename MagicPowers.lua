--[[
  Script Name: Magic Powers GUI
  Description: Adds Noclip & Fly buttons to all players.
  Author: YourName
--]]

loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/YourRepo/main/YourScript.lua", true))()
-- استبدل الرابط بالرابط الخاص بك بعد رفع السكربت على GitHub

local function createGUI(player)
    local gui = Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "MagicPowersGUI"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0.2, 0, 0.1, 0)
    frame.Position = UDim2.new(0.4, 0, 0.05, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)

    -- زر Noclip
    local noclipButton = Instance.new("TextButton", frame)
    noclipButton.Size = UDim2.new(0.45, 0, 0.9, 0)
    noclipButton.Position = UDim2.new(0.025, 0, 0.05, 0)
    noclipButton.Text = "Noclip"
    noclipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- زر Fly
    local flyButton = Instance.new("TextButton", frame)
    flyButton.Size = UDim2.new(0.45, 0, 0.9, 0)
    flyButton.Position = UDim2.new(0.525, 0, 0.05, 0)
    flyButton.Text = "Fly"
    flyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Noclip Logic
    local noclipActive = false
    noclipButton.MouseButton1Click:Connect(function()
        noclipActive = not noclipActive
        noclipButton.BackgroundColor3 = noclipActive and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(70, 70, 70)
        
        while noclipActive and player.Character do
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            game:GetService("RunService").Stepped:wait()
        end
    end)

    -- Fly Logic
    local flyActive = false
    local bodyGyro, bodyVelocity

    flyButton.MouseButton1Click:Connect(function()
        flyActive = not flyActive
        flyButton.BackgroundColor3 = flyActive and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(70, 70, 70)
        
        if flyActive then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                bodyGyro = Instance.new("BodyGyro", player.Character.HumanoidRootPart)
                bodyGyro.P = 10000
                bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
                
                bodyVelocity = Instance.new("BodyVelocity", player.Character.HumanoidRootPart)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
                
                player.Character.Humanoid.PlatformStand = true
                
                -- Flight Controls
                local connection
                connection = game:GetService("UserInputService").InputBegan:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.Space then
                        bodyVelocity.Velocity = Vector3.new(0, 50, 0)
                    elseif input.KeyCode == Enum.KeyCode.LeftShift then
                        bodyVelocity.Velocity = Vector3.new(0, -50, 0)
                    end
                end)
                
                -- Disconnect on button click again
                flyButton.MouseButton1Click:Connect(function()
                    connection:Disconnect()
                end)
            end
        else
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVelocity then bodyVelocity:Destroy() end
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.PlatformStand = false
            end
        end
    end)
end

-- Apply GUI to all players
game.Players.PlayerAdded:Connect(createGUI)
for _, player in ipairs(game.Players:GetPlayers()) do
    createGUI(player)
end
