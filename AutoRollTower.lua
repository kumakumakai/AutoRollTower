--==================================================
-- AUTO ROLL & TOWER GUI
--==================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

--==================================================
-- SETTINGS
--==================================================

local CONFIG_FILE = "AutoRollTower_Settings.json"

local settings = {
    AutoRoll = false,
    AutoTower = false,
    TowerPause = false,
    TowerEnd = false,
    PrestigeTower = false,
    AutoHideBattle = false
}

--==================================================
-- LOAD SAVED SETTINGS
--==================================================

if isfile and readfile and isfile(CONFIG_FILE) then

    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG_FILE))
    end)

    if success and type(data) == "table" then
        for key, value in pairs(data) do
            if settings[key] ~= nil and type(value) == "boolean" then
                settings[key] = value
            end
        end
    end
end

--==================================================
-- SAVE SETTINGS
--==================================================

local function saveSettings()

    if writefile then
        pcall(function()
            writefile(
                CONFIG_FILE,
                HttpService:JSONEncode(settings)
            )
        end)
    end

end

--==================================================
-- AUTO REJOIN
--==================================================

local REJOIN_TIME = 8 * 60

local SCRIPT_URL =
    "https://raw.githubusercontent.com/kumakumakai/AutoRollTower/refs/heads/main/AutoRollTower.lua"

--==================================================
-- QUEUE SCRIPT FOR NEXT SERVER
--==================================================

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

--==================================================
-- REMOVE OLD GUI
--==================================================

local oldGui =
    player.PlayerGui:FindFirstChild("AutoRollTowerGUI")

if oldGui then
    oldGui:Destroy()
end

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")

gui.Name = "AutoRollTowerGUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")

frame.Size = UDim2.new(0, 220, 0, 335)

frame.Position =
    UDim2.new(0.5, -110, 0.5, -167)

frame.BackgroundColor3 =
    Color3.fromRGB(25, 25, 25)

frame.BorderSizePixel = 0

frame.Parent = gui

local corner = Instance.new("UICorner")

corner.CornerRadius =
    UDim.new(0, 10)

corner.Parent = frame

--==================================================
-- TITLE
--==================================================

local title = Instance.new("TextLabel")

title.Size =
    UDim2.new(1, 0, 0, 35)

title.BackgroundTransparency = 1

title.Text = "Roll & Tower"

title.TextColor3 =
    Color3.fromRGB(255, 255, 255)

title.TextSize = 18

title.Font =
    Enum.Font.GothamBold

title.Parent = frame

--==================================================
-- TOGGLE CREATOR
--==================================================

local function createToggle(text, yPosition)

    local button = Instance.new("TextButton")

    button.Size =
        UDim2.new(0, 180, 0, 40)

    button.Position =
        UDim2.new(0.5, -90, 0, yPosition)

    button.BackgroundColor3 =
        Color3.fromRGB(60, 60, 60)

    button.Text =
        text .. ": OFF"

    button.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    button.TextSize = 15

    button.Font =
        Enum.Font.GothamBold

    button.BorderSizePixel = 0

    button.Parent = frame

    local buttonCorner = Instance.new("UICorner")

    buttonCorner.CornerRadius =
        UDim.new(0, 8)

    buttonCorner.Parent = button

    return button

end

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
-- UPDATE TOGGLE
--==================================================

local function updateToggle(button, name, enabled)

    if enabled then

        button.Text =
            name .. ": ON"

        button.BackgroundColor3 =
            Color3.fromRGB(40, 150, 70)

    else

        button.Text =
            name .. ": OFF"

        button.BackgroundColor3 =
            Color3.fromRGB(60, 60, 60)

    end

end

--==================================================
-- APPLY SAVED STATES
--==================================================

updateToggle(
    rollToggle,
    "Auto Roll",
    settings.AutoRoll
)

updateToggle(
    towerToggle,
    "Auto Tower",
    settings.AutoTower
)

updateToggle(
    pauseToggle,
    "Tower Pause",
    settings.TowerPause
)

updateToggle(
    endToggle,
    "Tower End",
    settings.TowerEnd
)

updateToggle(
    prestigeToggle,
    "Prestige Tower",
    settings.PrestigeTower
)

updateToggle(
    hideBattleToggle,
    "Auto Hide Battle",
    settings.AutoHideBattle
)

--==================================================
-- TOGGLES
--==================================================

rollToggle.MouseButton1Click:Connect(function()

    settings.AutoRoll =
        not settings.AutoRoll

    updateToggle(
        rollToggle,
        "Auto Roll",
        settings.AutoRoll
    )

    saveSettings()

end)

towerToggle.MouseButton1Click:Connect(function()

    settings.AutoTower =
        not settings.AutoTower

    updateToggle(
        towerToggle,
        "Auto Tower",
        settings.AutoTower
    )

    saveSettings()

end)

pauseToggle.MouseButton1Click:Connect(function()

    settings.TowerPause =
        not settings.TowerPause

    updateToggle(
        pauseToggle,
        "Tower Pause",
        settings.TowerPause
    )

    saveSettings()

end)

endToggle.MouseButton1Click:Connect(function()

    settings.TowerEnd =
        not settings.TowerEnd

    updateToggle(
        endToggle,
        "Tower End",
        settings.TowerEnd
    )

    saveSettings()

end)

prestigeToggle.MouseButton1Click:Connect(function()

    settings.PrestigeTower =
        not settings.PrestigeTower

    updateToggle(
        prestigeToggle,
        "Prestige Tower",
        settings.PrestigeTower
    )

    saveSettings()

end)

hideBattleToggle.MouseButton1Click:Connect(function()

    settings.AutoHideBattle =
        not settings.AutoHideBattle

    updateToggle(
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

            ReplicatedStorage
                :WaitForChild("RollRequest")
                :FireServer()

        end

        task.wait(0.01)

    end

end)

--==================================================
-- AUTO TOWER
--==================================================

task.spawn(function()

    while gui.Parent do

        if settings.AutoTower then

            ReplicatedStorage
                :WaitForChild("runInfTower")
                :FireServer()

        end

        task.wait(0.02)

    end

end)

--==================================================
-- TOWER PAUSE
--==================================================

task.spawn(function()

    while gui.Parent do

        if settings.TowerPause then

            ReplicatedStorage
                :WaitForChild("floorPromptEvent")
                :FireServer("pause")

        end

        task.wait(0.1)

    end

end)

--==================================================
-- TOWER END
--==================================================

task.spawn(function()

    while gui.Parent do

        if settings.TowerEnd then

            ReplicatedStorage
                :WaitForChild("infinityTowerAction")
                :FireServer("end")

        end

        task.wait(0.1)

    end

end)

--==================================================
-- PRESTIGE TOWER
--==================================================

task.spawn(function()

    while gui.Parent do

        if settings.PrestigeTower then

            ReplicatedStorage
                :WaitForChild("runPrestigeTower")
                :FireServer()

        end

        task.wait(0.1)

    end

end)

--==================================================
-- AUTO HIDE BATTLE
--==================================================

task.spawn(function()

    while gui.Parent do

        local battleUI =
            player.PlayerGui:FindFirstChild("BattleUI")

        if battleUI then

            if settings.AutoHideBattle then
                battleUI.Enabled = false
            else
                battleUI.Enabled = true
            end

        end

        task.wait(0.5)

    end

end)

--==================================================
-- G = SHOW / HIDE GUI
--==================================================

UserInputService.InputBegan:Connect(
    function(input, gameProcessed)

        if gameProcessed then
            return
        end

        if input.KeyCode == Enum.KeyCode.G then

            frame.Visible =
                not frame.Visible

        end

    end
)

--==================================================
-- DRAGGABLE GUI
--==================================================

local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1 then

        dragging = true

        dragStart =
            input.Position

        startPos =
            frame.Position

    end

end)

title.InputEnded:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1 then

        dragging = false

    end

end)

UserInputService.InputChanged:Connect(function(input)

    if dragging
        and input.UserInputType ==
        Enum.UserInputType.MouseMovement then

        local delta =
            input.Position - dragStart

        frame.Position =
            UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )

    end

end)

--==================================================
-- AUTO REJOIN
--==================================================

task.spawn(function()

    -- Queue the script for the next server.
    queueTeleportScript()

    -- Wait 8 minutes.
    task.wait(REJOIN_TIME)

    -- Save current settings.
    saveSettings()

    -- Rejoin the same experience.
    pcall(function()

        TeleportService:Teleport(
            game.PlaceId,
            player
        )

    end)

end)
