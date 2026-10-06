local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

--==================================================
-- ANTI AFK
--==================================================

Players.LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

--==================================================
-- SETTINGS FILE
--==================================================

local SettingsFile = "AutoBossGUI_Settings.json"

local Settings = {
    BossEnabled = false,
    RollEnabled = false,
    TowerEnabled = false,
    WeatherEnabled = false,

    SelectedBoss = "thriller_king",
    SelectedDifficulty = "Hard",

    PositionXScale = 0.5,
    PositionXOffset = -140,
    PositionYScale = 0.5,
    PositionYOffset = -177
}

--==================================================
-- LOAD SETTINGS
--==================================================

pcall(function()
    if isfile and isfile(SettingsFile) then
        local Saved = HttpService:JSONDecode(readfile(SettingsFile))

        for key, value in pairs(Saved) do
            if Settings[key] ~= nil then
                Settings[key] = value
            end
        end
    end
end)

local function SaveSettings()
    pcall(function()
        if writefile then
            writefile(
                SettingsFile,
                HttpService:JSONEncode(Settings)
            )
        end
    end)
end

--==================================================
-- VARIABLES
--==================================================

local BossEnabled = Settings.BossEnabled
local RollEnabled = Settings.RollEnabled
local TowerEnabled = Settings.TowerEnabled
local WeatherEnabled = Settings.WeatherEnabled

local GuiVisible = true

local SelectedBoss = Settings.SelectedBoss
local SelectedDifficulty = Settings.SelectedDifficulty

local Bosses = {
    "thriller_king",
    "dragon_emperor",
    "curse_tyrant"
}

local Difficulties = {
    "Hard",
    "Extreme",
    "Nightmare"
}

-- Make sure saved selections are still valid
if not table.find(Bosses, SelectedBoss) then
    SelectedBoss = "thriller_king"
    Settings.SelectedBoss = SelectedBoss
end

if not table.find(Difficulties, SelectedDifficulty) then
    SelectedDifficulty = "Hard"
    Settings.SelectedDifficulty = SelectedDifficulty
end

SaveSettings()

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BossChallengeGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, 355)

Main.Position = UDim2.new(
    Settings.PositionXScale,
    Settings.PositionXOffset,
    Settings.PositionYScale,
    Settings.PositionYOffset
)

Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Boss Challenge"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

--==================================================
-- BOSS LABEL
--==================================================

local BossLabel = Instance.new("TextLabel")
BossLabel.Position = UDim2.new(0, 15, 0, 48)
BossLabel.Size = UDim2.new(1, -30, 0, 25)
BossLabel.BackgroundTransparency = 1
BossLabel.Text = "Boss"
BossLabel.TextColor3 = Color3.new(1, 1, 1)
BossLabel.TextSize = 14
BossLabel.Font = Enum.Font.Gotham
BossLabel.TextXAlignment = Enum.TextXAlignment.Left
BossLabel.Parent = Main

--==================================================
-- BOSS DROPDOWN
--==================================================

local BossButton = Instance.new("TextButton")
BossButton.Position = UDim2.new(0, 15, 0, 75)
BossButton.Size = UDim2.new(1, -30, 0, 35)
BossButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BossButton.Text = SelectedBoss
BossButton.TextColor3 = Color3.new(1, 1, 1)
BossButton.TextSize = 13
BossButton.Font = Enum.Font.Gotham
BossButton.Parent = Main

local BossCorner = Instance.new("UICorner")
BossCorner.CornerRadius = UDim.new(0, 6)
BossCorner.Parent = BossButton

--==================================================
-- DIFFICULTY LABEL
--==================================================

local DifficultyLabel = Instance.new("TextLabel")
DifficultyLabel.Position = UDim2.new(0, 15, 0, 115)
DifficultyLabel.Size = UDim2.new(1, -30, 0, 25)
DifficultyLabel.BackgroundTransparency = 1
DifficultyLabel.Text = "Difficulty"
DifficultyLabel.TextColor3 = Color3.new(1, 1, 1)
DifficultyLabel.TextSize = 14
DifficultyLabel.Font = Enum.Font.Gotham
DifficultyLabel.TextXAlignment = Enum.TextXAlignment.Left
DifficultyLabel.Parent = Main

--==================================================
-- DIFFICULTY DROPDOWN
--==================================================

local DifficultyButton = Instance.new("TextButton")
DifficultyButton.Position = UDim2.new(0, 15, 0, 142)
DifficultyButton.Size = UDim2.new(1, -30, 0, 35)
DifficultyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DifficultyButton.Text = SelectedDifficulty
DifficultyButton.TextColor3 = Color3.new(1, 1, 1)
DifficultyButton.TextSize = 13
DifficultyButton.Font = Enum.Font.Gotham
DifficultyButton.Parent = Main

local DifficultyCorner = Instance.new("UICorner")
DifficultyCorner.CornerRadius = UDim.new(0, 6)
DifficultyCorner.Parent = DifficultyButton

--==================================================
-- BOSS TOGGLE
--==================================================

local BossToggle = Instance.new("TextButton")
BossToggle.Position = UDim2.new(0, 15, 0, 187)
BossToggle.Size = UDim2.new(1, -30, 0, 32)
BossToggle.TextColor3 = Color3.new(1, 1, 1)
BossToggle.TextSize = 14
BossToggle.Font = Enum.Font.GothamBold
BossToggle.Parent = Main

local BossToggleCorner = Instance.new("UICorner")
BossToggleCorner.CornerRadius = UDim.new(0, 6)
BossToggleCorner.Parent = BossToggle

--==================================================
-- AUTO ROLL
--==================================================

local RollToggle = Instance.new("TextButton")
RollToggle.Position = UDim2.new(0, 15, 0, 227)
RollToggle.Size = UDim2.new(1, -30, 0, 32)
RollToggle.TextColor3 = Color3.new(1, 1, 1)
RollToggle.TextSize = 14
RollToggle.Font = Enum.Font.GothamBold
RollToggle.Parent = Main

local RollCorner = Instance.new("UICorner")
RollCorner.CornerRadius = UDim.new(0, 6)
RollCorner.Parent = RollToggle

--==================================================
-- AUTO TOWER
--==================================================

local TowerToggle = Instance.new("TextButton")
TowerToggle.Position = UDim2.new(0, 15, 0, 267)
TowerToggle.Size = UDim2.new(1, -30, 0, 32)
TowerToggle.TextColor3 = Color3.new(1, 1, 1)
TowerToggle.TextSize = 14
TowerToggle.Font = Enum.Font.GothamBold
TowerToggle.Parent = Main

local TowerCorner = Instance.new("UICorner")
TowerCorner.CornerRadius = UDim.new(0, 6)
TowerCorner.Parent = TowerToggle

--==================================================
-- 5 WEATHER REROLL
--==================================================

local WeatherToggle = Instance.new("TextButton")
WeatherToggle.Position = UDim2.new(0, 15, 0, 307)
WeatherToggle.Size = UDim2.new(1, -30, 0, 32)
WeatherToggle.TextColor3 = Color3.new(1, 1, 1)
WeatherToggle.TextSize = 14
WeatherToggle.Font = Enum.Font.GothamBold
WeatherToggle.Parent = Main

local WeatherCorner = Instance.new("UICorner")
WeatherCorner.CornerRadius = UDim.new(0, 6)
WeatherCorner.Parent = WeatherToggle

--==================================================
-- UPDATE TOGGLE APPEARANCE
--==================================================

local function UpdateToggle(button, name, enabled)
    if enabled then
        button.Text = name .. ": ON"
        button.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
    else
        button.Text = name .. ": OFF"
        button.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
    end
end

UpdateToggle(BossToggle, "Boss Challenge", BossEnabled)
UpdateToggle(RollToggle, "Auto Roll", RollEnabled)
UpdateToggle(TowerToggle, "Auto Tower", TowerEnabled)
UpdateToggle(WeatherToggle, "5 Weather Reroll", WeatherEnabled)

--==================================================
-- DROPDOWN FUNCTION
--==================================================

local function CreateDropdown(button, options, callback)

    local Open = false
    local Dropdown

    button.MouseButton1Click:Connect(function()

        if Open then
            if Dropdown then
                Dropdown:Destroy()
            end

            Open = false
            return
        end

        Open = true

        Dropdown = Instance.new("Frame")
        Dropdown.Size = UDim2.new(1, 0, 0, #options * 30)
        Dropdown.Position = UDim2.new(0, 0, 1, 2)
        Dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Dropdown.BorderSizePixel = 0
        Dropdown.ZIndex = 20
        Dropdown.Parent = button

        local Layout = Instance.new("UIListLayout")
        Layout.Parent = Dropdown

        for _, option in ipairs(options) do

            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            OptionButton.BorderSizePixel = 0
            OptionButton.Text = option
            OptionButton.TextColor3 = Color3.new(1, 1, 1)
            OptionButton.TextSize = 12
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.ZIndex = 21
            OptionButton.Parent = Dropdown

            OptionButton.MouseButton1Click:Connect(function()

                button.Text = option
                callback(option)

                if Dropdown then
                    Dropdown:Destroy()
                end

                Open = false

            end)
        end
    end)
end

CreateDropdown(BossButton, Bosses, function(value)

    SelectedBoss = value
    Settings.SelectedBoss = value
    SaveSettings()

end)

CreateDropdown(DifficultyButton, Difficulties, function(value)

    SelectedDifficulty = value
    Settings.SelectedDifficulty = value
    SaveSettings()

end)

--==================================================
-- TOGGLES
--==================================================

BossToggle.MouseButton1Click:Connect(function()

    BossEnabled = not BossEnabled
    Settings.BossEnabled = BossEnabled

    UpdateToggle(
        BossToggle,
        "Boss Challenge",
        BossEnabled
    )

    SaveSettings()

end)

RollToggle.MouseButton1Click:Connect(function()

    RollEnabled = not RollEnabled
    Settings.RollEnabled = RollEnabled

    UpdateToggle(
        RollToggle,
        "Auto Roll",
        RollEnabled
    )

    SaveSettings()

end)

TowerToggle.MouseButton1Click:Connect(function()

    TowerEnabled = not TowerEnabled
    Settings.TowerEnabled = TowerEnabled

    UpdateToggle(
        TowerToggle,
        "Auto Tower",
        TowerEnabled
    )

    SaveSettings()

end)

WeatherToggle.MouseButton1Click:Connect(function()

    WeatherEnabled = not WeatherEnabled
    Settings.WeatherEnabled = WeatherEnabled

    UpdateToggle(
        WeatherToggle,
        "5 Weather Reroll",
        WeatherEnabled
    )

    SaveSettings()

end)

--==================================================
-- BOSS LOOP
--==================================================

task.spawn(function()

    while true do

        if BossEnabled then

            pcall(function()

                ReplicatedStorage
                    :WaitForChild("challengeBoss")
                    :FireServer(
                        SelectedBoss,
                        SelectedDifficulty
                    )

            end)

        end

        task.wait(0.1)

    end

end)

--==================================================
-- AUTO ROLL LOOP
--==================================================

task.spawn(function()

    while true do

        if RollEnabled then

            pcall(function()

                ReplicatedStorage
                    :WaitForChild("RollRequest")
                    :FireServer()

            end)

        end

        task.wait(0.002)

    end

end)

--==================================================
-- AUTO TOWER LOOP
--==================================================

task.spawn(function()

    while true do

        if TowerEnabled then

            pcall(function()

                ReplicatedStorage
                    :WaitForChild("runInfTower")
                    :FireServer()

            end)

        end

        task.wait(0.001)

    end

end)

--==================================================
-- WEATHER LOOP
--==================================================

task.spawn(function()

    while true do

        if WeatherEnabled then

            pcall(function()

                local args = {
                    "Weather Reroll",
                    5
                }

                ReplicatedStorage
                    :WaitForChild("useItem")
                    :FireServer(unpack(args))

            end)

        end

        task.wait(0.5)

    end

end)

--==================================================
-- B KEY GUI TOGGLE
--==================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)

    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.B then

        GuiVisible = not GuiVisible
        Main.Visible = GuiVisible

    end

end)

--==================================================
-- DRAGGING + SAVE POSITION
--==================================================

local Dragging = false
local DragStart
local StartPosition

Main.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 then

        Dragging = true
        DragStart = input.Position
        StartPosition = Main.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then

                Dragging = false

                Settings.PositionXScale = Main.Position.X.Scale
                Settings.PositionXOffset = Main.Position.X.Offset
                Settings.PositionYScale = Main.Position.Y.Scale
                Settings.PositionYOffset = Main.Position.Y.Offset

                SaveSettings()

            end

        end)

    end

end)

UserInputService.InputChanged:Connect(function(input)

    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

        local Delta = input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )

    end

end)
