```lua
-- [[ ---------------------------------------------------------------------------------------------------------------- ]]
-- [[                                                                                                                  ]]
-- [[                                         WOLFTEAM HUB V10 - GOD SLAYER                                            ]]
-- [[                                      THE BIGGEST MOBILE SCRIPT FOR DELTA                                         ]]
-- [[                                                                                                                  ]]
-- [[                                      BUILD VERSION: 10.0.0 (ULTIMATE)                                            ]]
-- [[                                      LINES OF CODE: MAXIMIZED                                                    ]]
-- [[                                      STATUS: UNDETECTED                                                          ]]
-- [[                                                                                                                  ]]
-- [[ ---------------------------------------------------------------------------------------------------------------- ]]

-- [[ SECTION 1: SYSTEM CONFIGURATION & VARIABLES ]]
local ScreenSize = UDim2.fromOffset(620, 450)
local MinimizeKey = Enum.KeyCode.LeftControl
local ThemeColor = Color3.fromRGB(255, 0, 0)
local ScriptLoaded = false
local StartTime = tick()

-- [[ SECTION 2: LIBRARY LOADER ]]
-- We are using the Fluent Library because it provides the best UI experience for mobile users.
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- [[ SECTION 3: WINDOW CREATION ]]
local Window = Fluent:CreateWindow({
    Title = "WolfTeam V10 GOD SLAYER",
    SubTitle = "Delta Extreme",
    TabWidth = 130,
    Size = ScreenSize,
    Acrylic = false, 
    Theme = "Darker",
    MinimizeKey = MinimizeKey
})

-- [[ SECTION 4: TABS GENERATION ]]
-- Creating individual tabs for maximum content organization
local Tabs = {
    Main = Window:AddTab({ Title = "Auto Farm", Icon = "swords" }),
    Stats = Window:AddTab({ Title = "Auto Stats", Icon = "bar-chart-2" }),
    Sea1 = Window:AddTab({ Title = "Teleport Sea 1", Icon = "map" }),
    Sea2 = Window:AddTab({ Title = "Teleport Sea 2", Icon = "map-pin" }),
    Sea3 = Window:AddTab({ Title = "Teleport Sea 3", Icon = "navigation" }),
    Raid = Window:AddTab({ Title = "Auto Raid", Icon = "flame" }),
    Shop = Window:AddTab({ Title = "Item Shop", Icon = "shopping-cart" }),
    Fruit = Window:AddTab({ Title = "Fruit Sniper", Icon = "apple" }),
    Visuals = Window:AddTab({ Title = "ESP & Visuals", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options
local Player = game.Players.LocalPlayer
local Remotes = game:GetService("ReplicatedStorage").Remotes.CommF_
local PlaceID = game.PlaceId

-- [[ SECTION 5: MOBILE TOGGLE UI ]]
-- Detailed construction of the floating button
task.spawn(function()
    pcall(function()
        if game.CoreGui:FindFirstChild("ToggleUI") then
            game.CoreGui.ToggleUI:Destroy()
        end
    end)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ToggleUI"
    ScreenGui.Parent = game.CoreGui
    
    local MainFrame = Instance.new("ImageButton")
    MainFrame.Name = "MainButton"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BackgroundTransparency = 0
    MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    MainFrame.BorderSizePixel = 2
    MainFrame.Position = UDim2.new(0.9, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 50, 0, 50)
    MainFrame.Image = "rbxassetid://16022833003"
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = MainFrame
    
    local dragging = false
    local dragInput, dragStart, startPos
    
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    
    MainFrame.MouseButton1Click:Connect(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
    end)
end)

-- [[ SECTION 6: HELPER FUNCTIONS ]]
-- Explicit functions for clarity and size

local function EquipMelee()
    pcall(function()
        if game.Players.LocalPlayer.Backpack then
            for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if item:IsA("Tool") and item.ToolTip == "Melee" then
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(item)
                end
            end
        end
    end)
end

local function FastAttack()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(1280, 672))
end

local function TweenTeleport(TargetCFrame)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = game.Players.LocalPlayer.Character.HumanoidRootPart
        local Distance = (HRP.Position - TargetCFrame.Position).Magnitude
        local Speed = 350
        local Time = Distance / Speed
        
        local TweenService = game:GetService("TweenService")
        local TweenInfoData = TweenInfo.new(Time, Enum.EasingStyle.Linear)
        local Tween = TweenService:Create(HRP, TweenInfoData, {CFrame = TargetCFrame})
        
        local BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Parent = HRP
        BodyVelocity.Velocity = Vector3.new(0,0,0)
        BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        -- Disable Collisions
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        Tween:Play()
        Tween.Completed:Connect(function()
            BodyVelocity:Destroy()
        end)
    end
end

-- [[ SECTION 7: AUTO LEVEL DATABASE ]]
-- A massive function to check every single level
local function GetQuestData()
    local Level = game.Players.LocalPlayer.Data.Level.Value
    
    -- SEA 1 CONFIGURATION
    if PlaceID == 2753915549 then
        if Level >= 1 and Level < 10 then
            return "BanditQuest1", "Bandit", CFrame.new(1060, 16, 1547), 1
        elseif Level >= 10 and Level < 15 then
            return "JungleQuest", "Monkey", CFrame.new(-1600, 36, 150), 1
        elseif Level >= 15 and Level < 30 then
            return "JungleQuest", "Gorilla", CFrame.new(-1240, 6, -480), 2
        elseif Level >= 30 and Level < 40 then
            return "BuggyQuest1", "Pirate", CFrame.new(-1115, 13, 3938), 1
        elseif Level >= 40 and Level < 60 then
            return "BuggyQuest1", "Brute", CFrame.new(-1145, 13, 4180), 2
        elseif Level >= 60 and Level < 75 then
            return "DesertQuest", "Desert Bandit", CFrame.new(900, 15, 4400), 1
        elseif Level >= 75 and Level < 90 then
            return "DesertQuest", "Desert Officer", CFrame.new(900, 15, 4800), 2
        elseif Level >= 90 and Level < 105 then
            return "SnowQuest", "Snow Bandit", CFrame.new(1385, 87, -1300), 1
        elseif Level >= 105 and Level < 120 then
            return "SnowQuest", "Snowman", CFrame.new(1385, 87, -1300), 2
        elseif Level >= 120 and Level < 150 then
            return "MarineQuest2", "Chief Petty Officer", CFrame.new(-4850, 20, 4250), 1
        elseif Level >= 150 and Level < 175 then
            return "SkyQuest", "Sky Bandit", CFrame.new(-4950, 720, -2600), 1
        elseif Level >= 175 and Level < 190 then
            return "SkyQuest", "Dark Master", CFrame.new(-5250, 720, -2250), 2
        elseif Level >= 190 and Level < 210 then
            return "PrisonQuest", "Prisoner", CFrame.new(5300, 10, 750), 1
        elseif Level >= 210 and Level < 230 then
            return "PrisonQuest", "Dangerous Prisoner", CFrame.new(5300, 10, 750), 2
        elseif Level >= 230 and Level < 250 then
            return "PrisonQuest", "Warden", CFrame.new(5300, 10, 750), 3
        elseif Level >= 250 and Level < 300 then
            return "ColosseumQuest", "Toga Warrior", CFrame.new(-1580, 10, -2980), 1
        elseif Level >= 300 and Level < 330 then
            return "MagmaQuest", "Military Soldier", CFrame.new(-5400, 10, 8500), 1
        elseif Level >= 330 and Level < 350 then
            return "MagmaQuest", "Military Spy", CFrame.new(-5800, 10, 8700), 2
        elseif Level >= 350 and Level < 375 then
            return "FishmanQuest", "Fishman Warrior", CFrame.new(61163, 11, 1819), 1
        elseif Level >= 375 and Level < 450 then
            return "FishmanQuest", "Fishman Commando", CFrame.new(61163, 11, 1819), 2
        elseif Level >= 450 and Level < 475 then
            return "SkyQuest", "God's Guard", CFrame.new(-4700, 850, -1950), 3
        elseif Level >= 475 and Level < 525 then
            return "SkyQuest", "Shanda", CFrame.new(-7650, 5550, -480), 4
        elseif Level >= 525 and Level < 625 then
            return "SkyQuest", "Royal Squad", CFrame.new(-7800, 5550, -2400), 5
        elseif Level >= 625 and Level <= 700 then
            return "FountainQuest", "Galley Pirate", CFrame.new(5580, 5, 3980), 1
        end
    end
    
    -- SEA 2 CONFIGURATION
    if PlaceID == 4442272183 then
        if Level >= 700 and Level < 725 then
            return "Area1Quest", "Raider", CFrame.new(-425, 73, 1835), 1
        elseif Level >= 725 and Level < 775 then
            return "Area1Quest", "Mercenary", CFrame.new(-425, 73, 1835), 2
        elseif Level >= 775 and Level < 800 then
            return "Area2Quest", "Swan Pirate", CFrame.new(635, 73, 918), 1
        elseif Level >= 800 and Level < 875 then
            return "Area2Quest", "Factory Staff", CFrame.new(635, 73, 918), 2
        elseif Level >= 875 and Level < 900 then
            return "MarineQuest3", "Marine Lieutenant", CFrame.new(-2440, 73, -3216), 1
        elseif Level >= 900 and Level < 950 then
            return "MarineQuest3", "Marine Captain", CFrame.new(-2440, 73, -3216), 2
        elseif Level >= 950 and Level < 1000 then
            return "ZombieQuest", "Zombie", CFrame.new(-5490, 48, -795), 1
        elseif Level >= 1000 and Level < 1050 then
            return "SnowMountainQuest", "Snow Trooper", CFrame.new(610, 400, -5350), 1
        elseif Level >= 1050 and Level < 1100 then
            return "SnowMountainQuest", "Winter Warrior", CFrame.new(610, 400, -5350), 2
        elseif Level >= 1100 and Level < 1175 then
            return "IceSideQuest", "Lab Subordinate", CFrame.new(-6060, 15, -1300), 1
        elseif Level >= 1175 and Level < 1250 then
            return "IceSideQuest", "Horned Warrior", CFrame.new(-6060, 15, -1300), 2
        elseif Level >= 1250 and Level < 1275 then
            return "FireSideQuest", "Magma Ninja", CFrame.new(-5420, 15, -450), 1
        elseif Level >= 1275 and Level < 1300 then
            return "FireSideQuest", "Lava Pirate", CFrame.new(-5420, 15, -450), 2
        elseif Level >= 1300 and Level < 1350 then
            return "ShipQuest1", "Ship Deckhand", CFrame.new(920, 125, 32800), 1
        elseif Level >= 1350 and Level < 1400 then
            return "ShipQuest1", "Ship Engineer", CFrame.new(920, 125, 32800), 2
        elseif Level >= 1400 and Level < 1425 then
            return "ArcticQuest", "Arctic Warrior", CFrame.new(6030, 27, -6220), 1
        elseif Level >= 1425 and Level < 1475 then
            return "ArcticQuest", "Snow Lurker", CFrame.new(6030, 27, -6220), 2
        elseif Level >= 1475 and Level <= 1500 then
            return "ForgottenQuest", "Sea Soldier", CFrame.new(-3050, 235, -10150), 1
        end
    end

    -- SEA 3 CONFIGURATION
    if PlaceID == 7449423635 then
        if Level >= 1500 and Level < 1575 then
            return "PortTownQuest", "Pirate Millionaire", CFrame.new(-300, 40, 5500), 1
        elseif Level >= 1575 and Level < 1625 then
            return "PortTownQuest", "Pistol Billionaire", CFrame.new(-300, 40, 5500), 2
        elseif Level >= 1625 and Level < 1700 then
            return "HydraIslandQuest", "Dragon Crew Warrior", CFrame.new(5200, 600, 200), 1
        elseif Level >= 1700 and Level < 1725 then
            return "HydraIslandQuest", "Dragon Crew Archer", CFrame.new(5200, 600, 200), 2
        elseif Level >= 1725 and Level < 1775 then
            return "GreatTreeQuest", "Marine Commodore", CFrame.new(2450, 70, -7350), 1
        elseif Level >= 1775 and Level < 1825 then
            return "GreatTreeQuest", "Marine Rear Admiral", CFrame.new(2450, 70, -7350), 2
        elseif Level >= 1825 and Level < 1850 then
            return "FloatingTurtleQuest", "Fishman Raider", CFrame.new(-10500, 330, -8500), 1
        elseif Level >= 1850 and Level < 1900 then
            return "FloatingTurtleQuest", "Fishman Captain", CFrame.new(-10500, 330, -8500), 2
        elseif Level >= 1900 and Level < 1975 then
            return "HauntedQuest", "Reborn Skeleton", CFrame.new(-8750, 140, 5500), 1
        elseif Level >= 1975 and Level < 2075 then
            return "HauntedQuest", "Living Zombie", CFrame.new(-8750, 140, 5500), 2
        elseif Level >= 2075 and Level < 2125 then
            return "NutsIslandQuest", "Peanut Scout", CFrame.new(-2000, 50, -12900), 1
        elseif Level >= 2125 and Level < 2200 then
            return "IceCreamIslandQuest", "Ice Cream Chef", CFrame.new(-900, 65, -16500), 1
        elseif Level >= 2200 and Level < 2275 then
            return "CakeQuest1", "Cookie Crafter", CFrame.new(-2000, 70, -12000), 1
        elseif Level >= 2275 and Level < 2350 then
            return "CakeQuest2", "Head Baker", CFrame.new(-1950, 60, -12450), 1
        elseif Level >= 2350 and Level < 2425 then
            return "TikiQuest", "Isle Outlaw", CFrame.new(-16000, 10, 1000), 1
        elseif Level >= 2425 and Level <= 2550 then
            return "TikiQuest", "Island Boy", CFrame.new(-16000, 10, 1000), 2
        end
    end
    
    return "None", "Error", CFrame.new(0,0,0), 0
end

-- [[ SECTION 8: MAIN FARM UI & LOGIC ]]

Tabs.Main:AddParagraph({
    Title = "Auto Farm Status",
    Content = "Redz Hub Logic (1-2550)"
})

Tabs.Main:AddToggle("AutoFarm", {Title = "🔥 AUTO FARM LEVEL", Default = false })
Options.AutoFarm:OnChanged(function()
    getgenv().AutoFarmLevel = Options.AutoFarm.Value
    
    -- Sub-Thread: NoClip
    task.spawn(function()
        while getgenv().AutoFarmLevel do
            task.wait()
            if game.Players.LocalPlayer.Character then
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end
    end)
    
    -- Sub-Thread: Main Logic
    task.spawn(function()
        while getgenv().AutoFarmLevel do
            task.wait()
            pcall(function()
                local QuestName, MobName, MobCFrame, QuestID = GetQuestData()
                
                if QuestName == "None" then
                    Fluent:Notify({Title = "Error", Content = "Check Level / Sea", Duration = 3})
                    return
                end
                
                -- Check if we have quest
                if game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    -- 1. Take Quest
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", QuestName, QuestID)
                    
                    -- 2. Teleport to Mob
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MobCFrame.Position).Magnitude > 500 then
                        TweenTeleport(MobCFrame)
                        task.wait(2)
                    end
                else
                    -- 3. Kill Mob
                    EquipMelee()
                    local TargetMob = nil
                    
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if enemy.Name == MobName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            TargetMob = enemy
                            break
                        end
                    end
                    
                    if TargetMob then
                        -- TP Above Mob
                        local AttackPos = TargetMob.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = AttackPos
                        game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                        
                        -- Look Down
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, TargetMob.HumanoidRootPart.Position)
                        
                        -- Attack
                        FastAttack()
                    else
                        -- Wait at Spawn
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MobCFrame.Position).Magnitude > 50 then
                            TweenTeleport(MobCFrame)
                        end
                    end
                end
            end)
        end
    end)
end)

-- [[ SECTION 9: TELEPORTS - MASSIVE UNPACKED LIST ]]

-- SEA 1
Tabs.Sea1:AddButton({Title = "Starter Pirate", Callback = function() TweenTeleport(CFrame.new(1000, 10, 4500)) end})
Tabs.Sea1:AddButton({Title = "Starter Marine", Callback = function() TweenTeleport(CFrame.new(-2800, 10, 2500)) end})
Tabs.Sea1:AddButton({Title = "Jungle", Callback = function() TweenTeleport(CFrame.new(-1437, 24, 25)) end})
Tabs.Sea1:AddButton({Title = "Pirate Village", Callback = function() TweenTeleport(CFrame.new(-100, 20, 100)) end})
Tabs.Sea1:AddButton({Title = "Desert", Callback = function() TweenTeleport(CFrame.new(900, 10, 4000)) end})
Tabs.Sea1:AddButton({Title = "Middle Town", Callback = function() TweenTeleport(CFrame.new(-650, 10, 1500)) end})
Tabs.Sea1:AddButton({Title = "Frozen Village", Callback = function() TweenTeleport(CFrame.new(1150, 10, -1150)) end})
Tabs.Sea1:AddButton({Title = "Marine Fortress", Callback = function() TweenTeleport(CFrame.new(-5000, 20, 5000)) end})
Tabs.Sea1:AddButton({Title = "Skylands", Callback = function() TweenTeleport(CFrame.new(-4800, 720, -2500)) end})
Tabs.Sea1:AddButton({Title = "Prison", Callback = function() TweenTeleport(CFrame.new(1500, 10, 1500)) end})
Tabs.Sea1:AddButton({Title = "Colosseum", Callback = function() TweenTeleport(CFrame.new(-1500, 10, -3000)) end})
Tabs.Sea1:AddButton({Title = "Magma Village", Callback = function() TweenTeleport(CFrame.new(-5300, 10, 8500)) end})
Tabs.Sea1:AddButton({Title = "Underwater City", Callback = function() TweenTeleport(CFrame.new(61163, 11, 1819)) end})
Tabs.Sea1:AddButton({Title = "Fountain City", Callback = function() TweenTeleport(CFrame.new(5250, 5, 4100)) end})

-- SEA 2
Tabs.Sea2:AddButton({Title = "Kingdom of Rose", Callback = function() TweenTeleport(CFrame.new(-400, 75, 300)) end})
Tabs.Sea2:AddButton({Title = "Cafe", Callback = function() TweenTeleport(CFrame.new(-400, 75, 300)) end})
Tabs.Sea2:AddButton({Title = "Green Zone", Callback = function() TweenTeleport(CFrame.new(-2500, 75, -3000)) end})
Tabs.Sea2:AddButton({Title = "Graveyard", Callback = function() TweenTeleport(CFrame.new(-5500, 10, -50)) end})
Tabs.Sea2:AddButton({Title = "Snow Mountain", Callback = function() TweenTeleport(CFrame.new(500, 400, -5500)) end})
Tabs.Sea2:AddButton({Title = "Hot and Cold", Callback = function() TweenTeleport(CFrame.new(-6000, 15, -1000)) end})
Tabs.Sea2:AddButton({Title = "Cursed Ship", Callback = function() TweenTeleport(CFrame.new(900, 100, 33000)) end})
Tabs.Sea2:AddButton({Title = "Ice Castle", Callback = function() TweenTeleport(CFrame.new(6000, 50, -6000)) end})
Tabs.Sea2:AddButton({Title = "Forgotten Island", Callback = function() TweenTeleport(CFrame.new(-3000, 200, -10000)) end})
Tabs.Sea2:AddButton({Title = "Dark Arena", Callback = function() TweenTeleport(CFrame.new(3800, 15, -3500)) end})

-- SEA 3
Tabs.Sea3:AddButton({Title = "Port Town", Callback = function() TweenTeleport(CFrame.new(-290, 10, 5300)) end})
Tabs.Sea3:AddButton({Title = "Hydra Island", Callback = function() TweenTeleport(CFrame.new(5300, 600, 500)) end})
Tabs.Sea3:AddButton({Title = "Great Tree", Callback = function() TweenTeleport(CFrame.new(2500, 50, -12000)) end})
Tabs.Sea3:AddButton({Title = "Floating Turtle", Callback = function() TweenTeleport(CFrame.new(-12000, 350, -7500)) end})
Tabs.Sea3:AddButton({Title = "Castle on the Sea", Callback = function() TweenTeleport(CFrame.new(-5000, 300, -3000)) end})
Tabs.Sea3:AddButton({Title = "Haunted Castle", Callback = function() TweenTeleport(CFrame.new(-9500, 150, 5500)) end})
Tabs.Sea3:AddButton({Title = "Sea of Treats", Callback = function() TweenTeleport(CFrame.new(-2000, 50, -13000)) end})

-- [[ SECTION 10: EXTENSIVE SHOP ]]
Tabs.Shop:AddParagraph({Title = "Combat Styles", Content = "Fragments & Money"})
Tabs.Shop:AddButton({Title = "Buy Black Leg", Callback = function() Remotes:InvokeServer("BuyBlackLeg") end})
Tabs.Shop:AddButton({Title = "Buy Electro", Callback = function() Remotes:InvokeServer("BuyElectro") end})
Tabs.Shop:AddButton({Title = "Buy Fishman Karate", Callback = function() Remotes:InvokeServer("BuyFishmanKarate") end})
Tabs.Shop:AddButton({Title = "Buy Dragon Breath", Callback = function() Remotes:InvokeServer("BuyDragonBreath") end})
Tabs.Shop:AddButton({Title = "Buy Superhuman", Callback = function() Remotes:InvokeServer("BuySuperhuman") end})
Tabs.Shop:AddButton({Title = "Buy Death Step", Callback = function() Remotes:InvokeServer("BuyDeathStep") end})
Tabs.Shop:AddButton({Title = "Buy Sharkman Karate", Callback = function() Remotes:InvokeServer("BuySharkmanKarate") end})
Tabs.Shop:AddButton({Title = "Buy Electric Claw", Callback = function() Remotes:InvokeServer("BuyElectricClaw") end})
Tabs.Shop:AddButton({Title = "Buy Dragon Talon", Callback = function() Remotes:InvokeServer("BuyDragonTalon") end})
Tabs.Shop:AddButton({Title = "Buy Godhuman", Callback = function() Remotes:InvokeServer("BuyGodhuman") end})

Tabs.Shop:AddParagraph({Title = "Legendary Swords", Content = "Weapons"})
Tabs.Shop:AddButton({Title = "Buy Katana", Callback = function() Remotes:InvokeServer("BuyKatana") end})
Tabs.Shop:AddButton({Title = "Buy Cutlass", Callback = function() Remotes:InvokeServer("BuyCutlass") end})
Tabs.Shop:AddButton({Title = "Buy Dual Katana", Callback = function() Remotes:InvokeServer("BuyDualKatana") end})
Tabs.Shop:AddButton({Title = "Buy Iron Mace", Callback = function() Remotes:InvokeServer("BuyIronMace") end})
Tabs.Shop:AddButton({Title = "Buy Shark Saw", Callback = function() Remotes:InvokeServer("BuySharkSaw") end})
Tabs.Shop:AddButton({Title = "Buy Triple Katana", Callback = function() Remotes:InvokeServer("BuyTripleKatana") end})
Tabs.Shop:AddButton({Title = "Buy Pipe", Callback = function() Remotes:InvokeServer("BuyPipe") end})
Tabs.Shop:AddButton({Title = "Buy Dual Headed Blade", Callback = function() Remotes:InvokeServer("BuyDualHeadedBlade") end})
Tabs.Shop:AddButton({Title = "Buy Soul Cane", Callback = function() Remotes:InvokeServer("BuySoulCane") end})
Tabs.Shop:AddButton({Title = "Buy Bisento", Callback = function() Remotes:InvokeServer("BuyBisento") end})

-- [[ SECTION 11: AUTO RAID ]]
local RaidChips = {"Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha", "Sand", "Phoenix", "Dough"}
Tabs.Raid:AddDropdown("ChipSelector", {Title = "Select Chip", Values = RaidChips, Multi = false, Default = 1 })
Tabs.Raid:AddButton({Title = "Buy Chip", Callback = function() Remotes:InvokeServer("RaidsNpc", "Select", Options.ChipSelector.Value) end})
Tabs.Raid:AddButton({Title = "Start Raid", Callback = function() Remotes:InvokeServer("RaidsNpc", "Start") end})
Tabs.Raid:AddToggle("RaidAura", {Title = "Dungeon Kill Aura", Default = false })
Options.RaidAura:OnChanged(function()
    getgenv().RaidAuraBool = Options.RaidAura.Value
    task.spawn(function()
        while getgenv().RaidAuraBool do
            task.wait(0.1)
            pcall(function()
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude < 70 then
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                        end
                    end
                end
            end)
        end
    end)
end)
Tabs.Raid:AddButton({Title = "Awaken Fruit", Callback = function() 
    Remotes:InvokeServer("Awakener", "Check")
    Remotes:InvokeServer("Awakener", "Awaken")
end})

-- [[ SECTION 12: FRUIT SNIPER ]]
Tabs.Fruit:AddButton({Title = "Random Fruit (Gacha)", Callback = function() Remotes:InvokeServer("Cousin", "Buy") end})
Tabs.Fruit:AddToggle("AutoStore", {Title = "Auto Store Fruits", Default = true })
Options.AutoStore:OnChanged(function()
    getgenv().AutoStore = Options.AutoStore.Value
    task.spawn(function()
        while getgenv().AutoStore do
            task.wait(1)
            pcall(function()
                for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if string.find(item.Name, "Fruit") then
                        Remotes:InvokeServer("StoreFruit", item.Name)
                    end
                end
                for _, item in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                    if string.find(item.Name, "Fruit") then
                        Remotes:InvokeServer("StoreFruit", item.Name)
                    end
                end
            end)
        end
    end)
end)

-- [[ SECTION 13: VISUALS ]]
Tabs.Visuals:AddToggle("PlayerESP", {Title = "Player ESP", Default = false })
Options.PlayerESP:OnChanged(function()
    getgenv().ESP = Options.PlayerESP.Value
    while getgenv().ESP do
        task.wait(1)
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and not v.Character:FindFirstChild("ESP_Highlight") then
                local Highlight = Instance.new("Highlight", v.Character)
                Highlight.Name = "ESP_Highlight"
                Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
        if not getgenv().ESP then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("ESP_Highlight") then
                    v.Character.ESP_Highlight:Destroy()
                end
            end
        end
    end
end)

-- [[ SECTION 14: MISCELLANEOUS ]]
Tabs.Misc:AddButton({Title = "Redeem All Codes", Callback = function()
    local Codes = {
        "NEWTROLL", "KITT_RESET", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy",
        "fudd10_v2", "Fudd10", "BIGNEWS", "THEGREATACE", "SUB2GAMERROBOT_RESET1", "SUB2GAMERROBOT_EXP1"
    }
    for _, code in pairs(Codes) do
        Remotes:InvokeServer("RedeemCode", code)
        task.wait(0.1)
    end
end})

Tabs.Misc:AddButton({Title = "Server Hop", Callback = function()
    local Http = game:GetService("HttpService")
    local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(Servers.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, Player)
            break
        end
    end
end})

-- [[ FINALIZATION ]]
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("WolfTeamV10")
SaveManager:SetFolder("WolfTeamV10/Config")

InterfaceManager:BuildInterfaceSection(Tabs.Misc)
Window:SelectTab(1)

Fluent:Notify({
    Title = "WolfTeam V10",
    Content = "GOD SLAYER EDITION LOADED",
    Duration = 5
})
```
