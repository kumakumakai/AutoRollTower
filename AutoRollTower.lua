local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

local SETTINGS_FILE = "AutoRollTower_Settings.json"

local settings = {
    AutoRoll = false,
    AutoTower = false,
    PrestigeTower = false,
    AutoHideBattle = false,
    WeatherPotion = false,
    FiveWeatherPotion = false,

    BossFarming = {
        symbolic_man = { Hard = false, Extreme = false, Nightmare = false },
        crimson_crow = { Hard = false, Extreme = false, Nightmare = false },
        thriller_king = { Hard = false, Extreme = false, Nightmare = false },
        drunk_dragon = { Hard = false, Extreme = false, Nightmare = false },
        curse_tyrant = { Hard = false, Extreme = false, Nightmare = false }
    },

    Crafting = {
        ["Luck Potion I"] = false,
        ["Luck Potion II"] = false,
        ["Luck Potion III"] = false,

        ["Battle Potion I"] = false,
        ["Battle Potion II"] = false,
        ["Battle Potion III"] = false,

        ["Speed Potion I"] = false,
        ["Speed Potion II"] = false,
        ["Speed Potion III"] = false,

        ["Weather Reroll"] = false
    }
}

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

        if type(data) ~= "table" then
            return
        end

        for key in pairs(settings) do

            if key ~= "Crafting"
                and data[key] ~= nil then

                settings[key] = data[key]
            end
        end

        if type(data.BossFarming) == "table" then
            for bossName in pairs(settings.BossFarming) do
                if type(data.BossFarming[bossName]) == "table" then
                    for difficulty in pairs(settings.BossFarming[bossName]) do
                        if data.BossFarming[bossName][difficulty] ~= nil then
                            settings.BossFarming[bossName][difficulty] = data.BossFarming[bossName][difficulty]
                        end
                    end
                end
            end
        end

        if type(data.Crafting) == "table" then

            for potionName in pairs(settings.Crafting) do

                if data.Crafting[potionName] ~= nil then

                    settings.Crafting[potionName] =
                        data.Crafting[potionName]
                end
            end
        end
    end)
end

loadSettings()

local RollRequest =
    ReplicatedStorage:WaitForChild("RollRequest")

local RunInfTower =
    ReplicatedStorage:WaitForChild("runInfTower")

local RunPrestigeTower =
    ReplicatedStorage:WaitForChild("runPrestigeTower")

local CraftItem =
    ReplicatedStorage:WaitForChild("craftItem")

local UseItem =
    ReplicatedStorage:WaitForChild("useItem")

local ChallengeBoss =
    ReplicatedStorage:WaitForChild("challengeBoss")

local oldGui =
    player.PlayerGui:FindFirstChild("AutoRollTowerGUI")

if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")

gui.Name = "AutoRollTowerGUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")

frame.Size =
    UDim2.new(0, 240, 0, 480)

frame.Position =
    UDim2.new(0.5, -120, 0.5, -230)

frame.BackgroundColor3 =
    Color3.fromRGB(25, 25, 25)

frame.BorderSizePixel = 0
frame.Parent = gui

local frameCorner = Instance.new("UICorner")

frameCorner.CornerRadius =
    UDim.new(0, 8)

frameCorner.Parent = frame

local title = Instance.new("TextLabel")

title.Size =
    UDim2.new(1, 0, 0, 35)

title.BackgroundTransparency = 1

title.Text =
    "Auto Roll / Tower"

title.TextColor3 =
    Color3.fromRGB(255, 255, 255)

title.TextSize = 17
title.Font = Enum.Font.SourceSansBold

title.Parent = frame

local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1 then

        dragging = true
        dragStart = input.Position
        startPos = frame.Position
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

        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

local function createToggle(text, y)

    local button =
        Instance.new("TextButton")

    button.Size =
        UDim2.new(1, -20, 0, 35)

    button.Position =
        UDim2.new(0, 10, 0, y)

    button.BackgroundColor3 =
        Color3.fromRGB(45, 45, 45)

    button.BorderSizePixel = 0

    button.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    button.TextSize = 15
    button.Font = Enum.Font.SourceSans

    button.Text = text
    button.Parent = frame

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 6)

    corner.Parent = button

    return button
end

local function updateButton(
    button,
    name,
    enabled
)

    if enabled then

        button.Text =
            name .. ": ON"

        button.BackgroundColor3 =
            Color3.fromRGB(40, 110, 55)

    else

        button.Text =
            name .. ": OFF"

        button.BackgroundColor3 =
            Color3.fromRGB(45, 45, 45)
    end
end

local rollToggle =
    createToggle("Auto Roll", 80)

local towerToggle =
    createToggle("Auto Tower", 125)

local prestigeToggle =
    createToggle("Prestige Tower", 260)

local hideBattleToggle =
    createToggle("Auto Hide Battle", 305)

local weatherToggle =
    createToggle("Weather Potion", 350)

local fiveWeatherToggle =
    createToggle("5 Weather Potion", 395)

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
    prestigeToggle,
    "Prestige Tower",
    settings.PrestigeTower
)

updateButton(
    hideBattleToggle,
    "Auto Hide Battle",
    settings.AutoHideBattle
)

updateButton(
    weatherToggle,
    "Weather Potion",
    settings.WeatherPotion
)

updateButton(
    fiveWeatherToggle,
    "5 Weather Potion",
    settings.FiveWeatherPotion
)

rollToggle.MouseButton1Click:Connect(function()

    settings.AutoRoll =
        not settings.AutoRoll

    updateButton(
        rollToggle,
        "Auto Roll",
        settings.AutoRoll
    )

    saveSettings()
end)

towerToggle.MouseButton1Click:Connect(function()

    settings.AutoTower =
        not settings.AutoTower

    updateButton(
        towerToggle,
        "Auto Tower",
        settings.AutoTower
    )

    saveSettings()
end)

prestigeToggle.MouseButton1Click:Connect(function()

    settings.PrestigeTower =
        not settings.PrestigeTower

    updateButton(
        prestigeToggle,
        "Prestige Tower",
        settings.PrestigeTower
    )

    saveSettings()
end)

hideBattleToggle.MouseButton1Click:Connect(function()

    settings.AutoHideBattle =
        not settings.AutoHideBattle

    updateButton(
        hideBattleToggle,
        "Auto Hide Battle",
        settings.AutoHideBattle
    )

    saveSettings()
end)

weatherToggle.MouseButton1Click:Connect(function()

    settings.WeatherPotion =
        not settings.WeatherPotion

    updateButton(
        weatherToggle,
        "Weather Potion",
        settings.WeatherPotion
    )

    saveSettings()
end)

fiveWeatherToggle.MouseButton1Click:Connect(function()

    settings.FiveWeatherPotion =
        not settings.FiveWeatherPotion

    updateButton(
        fiveWeatherToggle,
        "5 Weather Potion",
        settings.FiveWeatherPotion
    )

    saveSettings()
end)

task.spawn(function()

    while gui.Parent do

        if settings.AutoRoll then

            pcall(function()
                RollRequest:FireServer()
            end)

            task.wait(0.001)

        else

            task.wait(0.1)
        end
    end
end)

task.spawn(function()

    while gui.Parent do

        if settings.AutoTower then

            pcall(function()
                RunInfTower:FireServer()
            end)

            task.wait(0.001)

        else

            task.wait(0.1)
        end
    end
end)

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

task.spawn(function()

    while gui.Parent do

        if settings.WeatherPotion then

            pcall(function()

                UseItem:FireServer(
                    "Weather Reroll",
                    1
                )

            end)

            task.wait(0.5)

        else

            task.wait(0.1)
        end
    end
end)

task.spawn(function()

    while gui.Parent do

        if settings.FiveWeatherPotion then

            pcall(function()

                UseItem:FireServer(
                    "Weather Reroll",
                    5
                )

            end)

            task.wait(0.5)

        else

            task.wait(0.1)
        end
    end
end)

local craftingOpen = false
local craftingHeader
local craftingScroll

local mainTab = Instance.new("TextButton")
mainTab.Size = UDim2.new(0, 105, 0, 32)
mainTab.Position = UDim2.new(0, 10, 0, 40)
mainTab.BackgroundColor3 = Color3.fromRGB(40, 110, 55)
mainTab.BorderSizePixel = 0
mainTab.TextColor3 = Color3.fromRGB(255, 255, 255)
mainTab.TextSize = 14
mainTab.Font = Enum.Font.SourceSansBold
mainTab.Text = "Main"
mainTab.Parent = frame

local bossTab = Instance.new("TextButton")
bossTab.Size = UDim2.new(0, 105, 0, 32)
bossTab.Position = UDim2.new(0, 125, 0, 40)
bossTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
bossTab.BorderSizePixel = 0
bossTab.TextColor3 = Color3.fromRGB(255, 255, 255)
bossTab.TextSize = 14
bossTab.Font = Enum.Font.SourceSansBold
bossTab.Text = "Boss Farming"
bossTab.Parent = frame

for _, button in ipairs({mainTab, bossTab}) do
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
end

local mainContent = {
    rollToggle,
    towerToggle,
    prestigeToggle,
    hideBattleToggle,
    weatherToggle
}

local bossScroll = Instance.new("ScrollingFrame")
bossScroll.Size = UDim2.new(1, -20, 0, 380)
bossScroll.Position = UDim2.new(0, 10, 0, 80)
bossScroll.BackgroundTransparency = 1
bossScroll.BorderSizePixel = 0
bossScroll.ScrollBarThickness = 5
bossScroll.CanvasSize = UDim2.new(0, 0, 0, 15 * 42)
bossScroll.ScrollingDirection = Enum.ScrollingDirection.Y
bossScroll.Visible = false
bossScroll.Parent = frame

local bossList = {
    {"symbolic_man", "symbolic_man"},
    {"crimson_crow", "crimson_crow"},
    {"thriller_king", "thriller_king"},
    {"drunk_dragon", "drunk_dragon"},
    {"curse_tyrant", "curse_tyrant"}
}

local difficulties = {"Hard", "Extreme", "Nightmare"}
local bossButtons = {}

for bossIndex, bossInfo in ipairs(bossList) do
    local bossName = bossInfo[1]
    local bossKey = bossInfo[2]

    for difficultyIndex, difficulty in ipairs(difficulties) do
        local index = (bossIndex - 1) * 3 + difficultyIndex
        local button = createToggle(
            bossName .. " - " .. difficulty,
            0
        )

        button.Parent = bossScroll
        button.Size = UDim2.new(1, -5, 0, 35)
        button.Position = UDim2.new(0, 0, 0, (index - 1) * 42)

        updateButton(
            button,
            bossName .. " - " .. difficulty,
            settings.BossFarming[bossKey][difficulty]
        )

        bossButtons[bossKey .. difficulty] = button

        button.MouseButton1Click:Connect(function()
            settings.BossFarming[bossKey][difficulty] =
                not settings.BossFarming[bossKey][difficulty]

            updateButton(
                button,
                bossName .. " - " .. difficulty,
                settings.BossFarming[bossKey][difficulty]
            )

            saveSettings()
        end)
    end
end

local function setTab(tab)
    local bossVisible = tab == "Boss"

    for _, object in ipairs(mainContent) do
        object.Visible = not bossVisible
    end

    craftingHeader.Visible = not bossVisible
    craftingScroll.Visible = not bossVisible and craftingOpen
    bossScroll.Visible = bossVisible

    mainTab.BackgroundColor3 = bossVisible
        and Color3.fromRGB(45, 45, 45)
        or Color3.fromRGB(40, 110, 55)

    bossTab.BackgroundColor3 = bossVisible
        and Color3.fromRGB(40, 110, 55)
        or Color3.fromRGB(45, 45, 45)

    frame.Size = bossVisible
        and UDim2.new(0, 240, 0, 480)
        or UDim2.new(0, 240, 0, craftingOpen and 820 or 480)
end

mainTab.MouseButton1Click:Connect(function()
    setTab("Main")
end)

bossTab.MouseButton1Click:Connect(function()
    setTab("Boss")
end)

local potionNames = {

    "Luck Potion I",
    "Luck Potion II",
    "Luck Potion III",

    "Battle Potion I",
    "Battle Potion II",
    "Battle Potion III",

    "Speed Potion I",
    "Speed Potion II",
    "Speed Potion III",

    "Weather Reroll"
}

craftingHeader =
    Instance.new("TextButton")

craftingHeader.Size =
    UDim2.new(1, -20, 0, 35)

craftingHeader.Position =
    UDim2.new(0, 10, 0, 440)

craftingHeader.BackgroundColor3 =
    Color3.fromRGB(45, 45, 45)

craftingHeader.BorderSizePixel = 0

craftingHeader.TextColor3 =
    Color3.fromRGB(255, 255, 255)

craftingHeader.TextSize = 15
craftingHeader.Font = Enum.Font.SourceSansBold

craftingHeader.Text =
    "Crafting ▼"

craftingHeader.Parent = frame

local craftingCorner =
    Instance.new("UICorner")

craftingCorner.CornerRadius =
    UDim.new(0, 6)

craftingCorner.Parent =
    craftingHeader

craftingScroll =
    Instance.new("ScrollingFrame")

craftingScroll.Size =
    UDim2.new(1, -20, 0, 330)

craftingScroll.Position =
    UDim2.new(0, 10, 0, 480)

craftingScroll.BackgroundTransparency = 1
craftingScroll.BorderSizePixel = 0

craftingScroll.ScrollBarThickness = 5

craftingScroll.CanvasSize =
    UDim2.new(0, 0, 0, 10 * 37)

craftingScroll.Visible = false
craftingScroll.Parent = frame

for index, potionName
    in ipairs(potionNames) do

    local button =
        Instance.new("TextButton")

    button.Size =
        UDim2.new(1, -5, 0, 32)

    button.Position =
        UDim2.new(
            0,
            0,
            0,
            (index - 1) * 37
        )

    button.BackgroundColor3 =
        Color3.fromRGB(45, 45, 45)

    button.BorderSizePixel = 0

    button.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    button.TextSize = 14
    button.Font = Enum.Font.SourceSans

    updateButton(
        button,
        potionName,
        settings.Crafting[potionName]
    )

    button.Parent =
        craftingScroll

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 6)

    corner.Parent = button

    button.MouseButton1Click:Connect(function()

        settings.Crafting[potionName] =
            not settings.Crafting[potionName]

        updateButton(
            button,
            potionName,
            settings.Crafting[potionName]
        )

        saveSettings()
    end)
end

craftingHeader.MouseButton1Click:Connect(function()

    craftingOpen =
        not craftingOpen

    if craftingOpen then

        craftingHeader.Text =
            "Crafting ▲"

        craftingScroll.Visible = true

        frame.Size =
            UDim2.new(0, 240, 0, 820)

    else

        craftingHeader.Text =
            "Crafting ▼"

        craftingScroll.Visible = false

        frame.Size =
            UDim2.new(0, 240, 0, 480)
    end
end)

task.spawn(function()
    while gui.Parent do
        for bossName, difficultiesForBoss in pairs(settings.BossFarming) do
            for difficulty, enabled in pairs(difficultiesForBoss) do
                if enabled then
                    pcall(function()
                        ChallengeBoss:FireServer(bossName, difficulty)
                    end)
                    task.wait(0.1)
                end
            end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()

    while gui.Parent do

        for potionName, enabled
            in pairs(settings.Crafting) do

            if enabled then

                pcall(function()

                    CraftItem:FireServer(
                        "craft",
                        potionName
                    )

                end)
            end
        end

        task.wait(0.1)
    end
end)

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

    if isFloorCounterObject(object) then
        return
    end

    if object:IsDescendantOf(gui) then
        return
    end

    if hiddenBattleObjects[object] == nil then

        hiddenBattleObjects[object] =
            object.Visible
    end

    object.Visible = false
end

local function restoreBattleObjects()

    for object, originalVisible
        in pairs(hiddenBattleObjects) do

        if object and object.Parent then

            pcall(function()

                object.Visible =
                    originalVisible

            end)
        end
    end

    table.clear(hiddenBattleObjects)
end

local function hideCardBattle()

    local playerGui =
        player:FindFirstChild("PlayerGui")

    if not playerGui then
        return
    end

    local battleUI =
        playerGui:FindFirstChild("BattleUI")

    if not battleUI then
        return
    end

    for _, object
        in ipairs(battleUI:GetDescendants()) do

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

UserInputService.InputBegan:Connect(function(
    input,
    gameProcessed
)

    if gameProcessed then
        return
    end

    if input.KeyCode ==
        Enum.KeyCode.B then

        frame.Visible =
            not frame.Visible
    end
end)

local REJOIN_TIME =
    10 * 60

local teleporting = false
local teleportMode = "same"

local function queueTeleportScript()

    local queueFunction =
        queue_on_teleport
        or queueonteleport

    if not queueFunction then
        warn("queue_on_teleport is not available.")
        return false
    end

    local queuedCode = [[
        task.wait(10)

        local success, err = pcall(function()
            loadstring(game:HttpGet(
                "https://raw.githubusercontent.com/kumakumakai/AutoRollTower/refs/heads/main/AutoRollTower.lua"
            ))()
        end)

        if not success then
            warn("AutoRollTower loader failed:", err)
        end
    ]]

    local success, err = pcall(function()
        queueFunction(queuedCode)
    end)

    if not success then
        warn("Failed to queue teleport script:", err)
        return false
    end

    return true
end

local function doRejoin(mode)

    if teleporting then
        return
    end

    teleporting = true
    teleportMode = mode or "same"

    queueTeleportScript()

    task.wait(1)

    local targetJobId = game.JobId

    local success, err = pcall(function()

        if teleportMode == "same"
            and targetJobId
            and targetJobId ~= "" then

            -- Try to return to the exact server first.
            TeleportService:TeleportToPlaceInstance(
                game.PlaceId,
                targetJobId,
                player
            )

        else

            -- If the original server is unavailable/full,
            -- join any available server.
            TeleportService:Teleport(
                game.PlaceId,
                player
            )
        end
    end)

    if not success then

        warn(
            "Teleport failed:",
            tostring(err)
        )

        if teleportMode == "same" then

            -- Same-server teleport failed, so immediately
            -- fall back to a different available server.
            teleporting = false
            doRejoin("different")

        else

            teleporting = false

            task.delay(10, function()
                if player and player.Parent then
                    doRejoin("different")
                end
            end)
        end
    end
end

pcall(function()

    TeleportService.TeleportInitFailed:Connect(
        function(
            failedPlayer,
            teleportResult,
            errorMessage
        )

            if failedPlayer ~= player then
                return
            end

            warn(
                "TeleportInitFailed:",
                tostring(teleportResult),
                tostring(errorMessage)
            )

            if teleportMode == "same" then

                -- The exact server could not be joined
                -- (for example, it may be full/unavailable).
                teleporting = false
                task.delay(1, function()
                    if player and player.Parent then
                        doRejoin("different")
                    end
                end)

            else

                -- Different-server teleport also failed;
                -- retry after a short delay.
                teleporting = false
                task.delay(10, function()
                    if player and player.Parent then
                        doRejoin("different")
                    end
                end)
            end
        end
    )

end)

task.spawn(function()

    while gui.Parent do

        task.wait(REJOIN_TIME)

        if not gui.Parent then
            break
        end

        saveSettings()

        -- Always try the exact current server first.
        doRejoin("same")

        break
    end
end)
