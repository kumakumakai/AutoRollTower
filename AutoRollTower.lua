local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

--==================================================
-- SETTINGS
--==================================================

local SETTINGS_FILE = "AutoRollTower_Settings.json"

local settings = {
    AutoRoll = false,
    AutoTower = false,
    TowerPause = false,
    TowerEnd = false,
    PrestigeTower = false,
    AutoHideBattle = false
}

--==================================================
-- SAVE / LOAD
--==================================================

local function saveSettings()
    if not writefile then
        return
    end

    pcall(function()
        writefile(
            SETTINGS_FILE,
            HttpService:JSONEncode(settings)
        )
    end)
end

local function loadSettings()
    if not isfile or not readfile then
        return
    end

    if not isfile(SETTINGS_FILE) then
        return
    end

    pcall(function()
        local data = HttpService:JSONDecode(
            readfile(SETTINGS_FILE)
        )

        if type(data) == "table" then
            for key, value in pairs(settings) do
                if data[key] ~= nil then
                    settings[key] = data[key]
                end
            end
        end
    end)
end

loadSettings()

--==================================================
-- REMOTES
--==================================================

local RollRequest =
    ReplicatedStorage:WaitForChild("RollRequest")

local RunInfTower =
    ReplicatedStorage:WaitForChild("runInfTower")

local FloorPromptEvent =
    ReplicatedStorage:WaitForChild("floorPromptEvent")

local InfinityTowerAction =
    ReplicatedStorage:WaitForChild("infinityTowerAction")

local RunPrestigeTower =
    ReplicatedStorage:WaitForChild("runPrestigeTower")

--==================================================
-- GUI
--==================================================

local oldGui = player.PlayerGui:FindFirstChild("AutoRollTowerGUI")

if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "AutoRollTowerGUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 335)
frame.Position = UDim2.new(0.5, -110, 0.5, -167)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

--==================================================
-- TITLE
--==================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Auto Roll / Tower"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 17
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

--==================================================
-- DRAGGING
--==================================================

local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--==================================================
-- TOGGLE CREATOR
--==================================================

local function createToggle(text, y)
    local button = Instance.new("TextButton")

    button.Size = UDim2.new(1, -20, 0, 35)
    button.Position = UDim2.new(0, 10, 0, y)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.BorderSizePixel = 0
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 15
    button.Font = Enum.Font.SourceSans
    button.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    return button
end

local function updateButton(button, name, enabled)
    if enabled then
        button.Text = name .. ": ON"
        button.BackgroundColor3 = Color3.fromRGB(40, 110, 55)
    else
        button.Text = name .. ": OFF"
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end

--==================================================
-- BUTTONS
--==================================================

local rollToggle =
    createToggle("Auto Roll", 40)

local towerToggle =
    createToggle("Auto Tower", 85)

local pauseToggle =
    createToggle("Tower Pause", 130)

local endToggle =
    createToggle("Tower End", 175)

local prestigeToggle =
    createToggle("Prestige Tower", 220)

local hideBattleToggle =
    createToggle("Auto Hide Battle", 265)

--==================================================
-- INITIAL BUTTON STATE
--==================================================

updateButton(
    rollToggle,
    "Auto Roll",
    settings.AutoRoll
)

updateButton(
    towerToggle,
    "Auto Tower",
    settings.AutoTower
)

updateButton(
    pauseToggle,
    "Tower Pause",
    settings.TowerPause
)

updateButton(
    endToggle,
    "Tower End",
    settings.TowerEnd
)

updateButton(
    prestigeToggle,
    "Prestige Tower",
    settings.PrestigeTower
)

updateButton(
    hideBattleToggle,
    "Auto Hide Battle",
    settings.AutoHideBattle
)

--==================================================
-- TOGGLE CONNECTIONS
--==================================================

rollToggle.MouseButton1Click:Connect(function()
    settings.AutoRoll = not settings.AutoRoll

    updateButton(
        rollToggle,
        "Auto Roll",
        settings.AutoRoll
    )

    saveSettings()
end)

towerToggle.MouseButton1Click:Connect(function()
    settings.AutoTower = not settings.AutoTower

    updateButton(
        towerToggle,
        "Auto Tower",
        settings.AutoTower
    )

    saveSettings()
end)

pauseToggle.MouseButton1Click:Connect(function()
    settings.TowerPause = not settings.TowerPause

    updateButton(
        pauseToggle,
        "Tower Pause",
        settings.TowerPause
    )

    saveSettings()
end)

endToggle.MouseButton1Click:Connect(function()
    settings.TowerEnd = not settings.TowerEnd

    updateButton(
        endToggle,
        "Tower End",
        settings.TowerEnd
    )

    saveSettings()
end)

prestigeToggle.MouseButton1Click:Connect(function()
    settings.PrestigeTower = not settings.PrestigeTower

    updateButton(
        prestigeToggle,
        "Prestige Tower",
        settings.PrestigeTower
    )

    saveSettings()
end)

hideBattleToggle.MouseButton1Click:Connect(function()
    settings.AutoHideBattle = not settings.AutoHideBattle

    updateButton(
        hideBattleToggle,
        "Auto Hide Battle",
        settings.AutoHideBattle
    )

    saveSettings()
end)

--==================================================
-- AUTO ROLL
--==================================================

task.spawn(function()
    while gui.Parent do
        if settings.AutoRoll then
            pcall(function()
                RollRequest:FireServer()
            end)

            task.wait(0.01)
        else
            task.wait(0.1)
        end
    end
end)

--==================================================
-- AUTO TOWER
-- 0.02 SECOND INTERVAL
--==================================================

task.spawn(function()
    while gui.Parent do
        if settings.AutoTower then
            pcall(function()
                RunInfTower:FireServer()
            end)

            task.wait(0.02)
        else
            task.wait(0.1)
        end
    end
end)

--==================================================
-- TOWER PAUSE
--==================================================

task.spawn(function()
    while gui.Parent do
        if settings.TowerPause then
            pcall(function()
                FloorPromptEvent:FireServer("pause")
            end)

            task.wait(0.1)
        else
            task.wait(0.1)
        end
    end
end)

--==================================================
-- TOWER END
--==================================================

task.spawn(function()
    while gui.Parent do
        if settings.TowerEnd then
            pcall(function()
                InfinityTowerAction:FireServer("end")
            end)

            task.wait(0.1)
        else
            task.wait(0.1)
        end
    end
end)

--==================================================
-- PRESTIGE TOWER
--==================================================

task.spawn(function()
    while gui.Parent do
        if settings.PrestigeTower then
            pcall(function()
                RunPrestigeTower:FireServer()
            end)

            task.wait(0.1)
        else
            task.wait(0.1)
        end
    end
end)

--==================================================
-- AUTO HIDE BATTLE
-- Hides card-fight UI elements while keeping
-- the floor counter and normal GUI visible.
--==================================================

local hiddenBattleObjects = {}

local function isFloorCounterObject(object)
    local current = object

    while current do
        if current.Name == "floorCount" then
            return true
        end

        current = current.Parent
    end

    return false
end

local function hideBattleObject(object)
    if not object:IsA("GuiObject") then
        return
    end

    -- Keep floor counter visible
    if isFloorCounterObject(object) then
        return
    end

    -- Never hide our own GUI
    if object:IsDescendantOf(gui) then
        return
    end

    if hiddenBattleObjects[object] == nil then
        hiddenBattleObjects[object] = object.Visible
    end

    object.Visible = false
end

local function restoreBattleObjects()
    for object, originalVisible in pairs(hiddenBattleObjects) do
        if object and object.Parent then
            pcall(function()
                object.Visible = originalVisible
            end)
        end
    end

    table.clear(hiddenBattleObjects)
end

local function hideCardBattle()
    local playerGui = player:FindFirstChild("PlayerGui")

    if not playerGui then
        return
    end

    local battleUI = playerGui:FindFirstChild("BattleUI")

    if not battleUI then
        return
    end

    for _, object in ipairs(battleUI:GetDescendants()) do
        hideBattleObject(object)
    end
end

task.spawn(function()
    while gui.Parent do
        if settings.AutoHideBattle then
            hideCardBattle()
        else
            restoreBattleObjects()
        end

        task.wait(0.25)
    end
end)

--==================================================
-- B KEY = SHOW / HIDE GUI
--==================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.B then
        frame.Visible = not frame.Visible
    end
end)

--==================================================
-- AUTO REJOIN
--==================================================

local REJOIN_TIME = 8 * 60

local SCRIPT_URL =
    "https://raw.githubusercontent.com/kumakumakai/AutoRollTower/refs/heads/main/AutoRollTower.lua"

local function queueTeleportScript()
    local queueFunction =
        queue_on_teleport
        or queueonteleport

    if not queueFunction then
        warn("queue_on_teleport is not available.")
        return
    end

    local queuedCode = [[
        task.wait(5)

        loadstring(game:HttpGet("https://raw.githubusercontent.com/kumakumakai/AutoRollTower/refs/heads/main/AutoRollTower.lua"))()
    ]]

    pcall(function()
        queueFunction(queuedCode)
    end)
end

task.spawn(function()
    queueTeleportScript()

    task.wait(REJOIN_TIME)

    saveSettings()

    pcall(function()
        TeleportService:Teleport(
            game.PlaceId,
            player
        )
    end)
end)

--==================================================
-- DONE
--==================================================

print("Auto Roll / Tower GUI loaded.")
print("Auto Tower interval: 0.02 seconds")
print("Press B to hide/show the GUI.")
print("Auto Hide Battle only hides the card-fight UI.")
