```lua
-- [[ ---------------------------------------------------------------------------------------------------------------- ]]
-- [[                                         WOLFTEAM HUB V13 - TITAN FINAL                                           ]]
-- [[                                      FIXED LOADING ERROR + MAX CONTENT                                           ]]
-- [[ ---------------------------------------------------------------------------------------------------------------- ]]

local ScreenSize = UDim2.fromOffset(600, 420)
local MinimizeKey = Enum.KeyCode.LeftControl

-- [[ 1. SAFE LIBRARY LOADER (FIX FOR NIL VALUE ERROR) ]]
local Fluent = nil
local success, result = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success or not result then
    -- Backup Link if Github fails
    success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua"))()
    end)
end

if not success then
    -- Emergency basic loader (if internet is very bad)
    game.StarterGui:SetCore("SendNotification", {Title = "WolfTeam Error", Text = "Check Internet Connection!", Duration = 5})
    return
end

Fluent = result
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- [[ 2. WINDOW CREATION ]]
local Window = Fluent:CreateWindow({
    Title = "WolfTeam V13 TITAN",
    SubTitle = "Delta Mobile Fixed",
    TabWidth = 130,
    Size = ScreenSize,
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = MinimizeKey
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Farm", Icon = "swords" }),
    Stats = Window:AddTab({ Title = "Upgrades", Icon = "bar-chart-2" }),
    Sea1 = Window:AddTab({ Title = "Sea 1 TP", Icon = "map" }),
    Sea2 = Window:AddTab({ Title = "Sea 2 TP", Icon = "map-pin" }),
    Sea3 = Window:AddTab({ Title = "Sea 3 TP", Icon = "navigation" }),
    Raid = Window:AddTab({ Title = "Dungeons", Icon = "flame" }),
    Shop = Window:AddTab({ Title = "Shop Items", Icon = "shopping-cart" }),
    Fruit = Window:AddTab({ Title = "Fruits", Icon = "apple" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options
local Player = game.Players.LocalPlayer
local Remotes = game:GetService("ReplicatedStorage").Remotes.CommF_
local PlaceID = game.PlaceId

-- [[ 3. MOBILE BUTTON ]]
task.spawn(function()
    pcall(function() if game.CoreGui:FindFirstChild("ToggleUI") then game.CoreGui.ToggleUI:Destroy() end end)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    local Btn = Instance.new("ImageButton", ScreenGui)
    Btn.Position = UDim2.new(0.9, 0, 0.5, 0); Btn.Size = UDim2.new(0, 50, 0, 50)
    Btn.Image = "rbxassetid://16022833003"; Btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1,0)
    local dragging, dragStart, startPos
    Btn.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; dragStart=input.Position; startPos=Btn.Position end end)
    Btn.InputChanged:Connect(function(input) if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then local delta=input.Position-dragStart; Btn.Position=UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y) end end)
    Btn.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
    Btn.MouseButton1Click:Connect(function() game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game) end)
end)

-- [[ 4. HELPERS ]]
local function FastAttack()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
end

local function TP(cf)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart
        local dist = (hrp.Position - cf.Position).Magnitude
        local tween = game:GetService("TweenService"):Create(hrp, TweenInfo.new(dist/350, Enum.EasingStyle.Linear), {CFrame=cf})
        local bv = Instance.new("BodyVelocity", hrp); bv.Velocity = Vector3.zero; bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        for _,v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end
        tween:Play()
        tween.Completed:Connect(function() bv:Destroy() end)
    end
end

-- [[ 5. LEVEL LOGIC ]]
local function GetQuestData()
    local Level = Player.Data.Level.Value
    
    if PlaceID == 2753915549 then -- SEA 1
        if Level < 10 then return "BanditQuest1", "Bandit", CFrame.new(1060,16,1547), 1
        elseif Level < 15 then return "JungleQuest", "Monkey", CFrame.new(-1600,36,150), 1
        elseif Level < 30 then return "JungleQuest", "Gorilla", CFrame.new(-1240,6,-480), 2
        elseif Level < 40 then return "BuggyQuest1", "Pirate", CFrame.new(-1115,13,3938), 1
        elseif Level < 60 then return "BuggyQuest1", "Brute", CFrame.new(-1145,13,4180), 2
        elseif Level < 75 then return "DesertQuest", "Desert Bandit", CFrame.new(900,15,4400), 1
        elseif Level < 90 then return "DesertQuest", "Desert Officer", CFrame.new(900,15,4800), 2
        elseif Level < 105 then return "SnowQuest", "Snow Bandit", CFrame.new(1385,87,-1300), 1
        elseif Level < 120 then return "SnowQuest", "Snowman", CFrame.new(1385,87,-1300), 2
        elseif Level < 150 then return "MarineQuest2", "Chief Petty Officer", CFrame.new(-4850,20,4250), 1
        elseif Level < 175 then return "SkyQuest", "Sky Bandit", CFrame.new(-4950,720,-2600), 1
        elseif Level < 190 then return "SkyQuest", "Dark Master", CFrame.new(-5250,720,-2250), 2
        elseif Level < 210 then return "PrisonQuest", "Prisoner", CFrame.new(5300,10,750), 1
        elseif Level < 230 then return "PrisonQuest", "Dangerous Prisoner", CFrame.new(5300,10,750), 2
        elseif Level < 250 then return "PrisonQuest", "Warden", CFrame.new(5300,10,750), 3
        elseif Level < 300 then return "ColosseumQuest", "Toga Warrior", CFrame.new(-1580,10,-2980), 1
        elseif Level < 330 then return "MagmaQuest", "Military Soldier", CFrame.new(-5400,10,8500), 1
        elseif Level < 350 then return "MagmaQuest", "Military Spy", CFrame.new(-5800,10,8700), 2
        elseif Level < 375 then return "FishmanQuest", "Fishman Warrior", CFrame.new(61163,11,1819), 1
        elseif Level < 450 then return "FishmanQuest", "Fishman Commando", CFrame.new(61163,11,1819), 2
        elseif Level < 475 then return "SkyQuest", "God's Guard", CFrame.new(-4700,850,-1950), 3
        elseif Level < 525 then return "SkyQuest", "Shanda", CFrame.new(-7650,5550,-480), 4
        elseif Level < 625 then return "SkyQuest", "Royal Squad", CFrame.new(-7800,5550,-2400), 5
        elseif Level <= 700 then return "FountainQuest", "Galley Pirate", CFrame.new(5580,5,3980), 1
        end
    elseif PlaceID == 4442272183 then -- SEA 2
        if Level < 725 then return "Area1Quest", "Raider", CFrame.new(-425,73,1835), 1
        elseif Level < 775 then return "Area1Quest", "Mercenary", CFrame.new(-425,73,1835), 2
        elseif Level < 800 then return "Area2Quest", "Swan Pirate", CFrame.new(635,73,918), 1
        elseif Level < 875 then return "Area2Quest", "Factory Staff", CFrame.new(635,73,918), 2
        elseif Level < 900 then return "MarineQuest3", "Marine Lieutenant", CFrame.new(-2440,73,-3216), 1
        elseif Level < 950 then return "MarineQuest3", "Marine Captain", CFrame.new(-2440,73,-3216), 2
        elseif Level < 1000 then return "ZombieQuest", "Zombie", CFrame.new(-5490,48,-795), 1
        elseif Level < 1050 then return "SnowMountainQuest", "Snow Trooper", CFrame.new(610,400,-5350), 1
        elseif Level < 1100 then return "SnowMountainQuest", "Winter Warrior", CFrame.new(610,400,-5350), 2
        elseif Level < 1175 then return "IceSideQuest", "Lab Subordinate", CFrame.new(-6060,15,-1300), 1
        elseif Level < 1250 then return "IceSideQuest", "Horned Warrior", CFrame.new(-6060,15,-1300), 2
        elseif Level < 1275 then return "FireSideQuest", "Magma Ninja", CFrame.new(-5420,15,-450), 1
        elseif Level < 1300 then return "FireSideQuest", "Lava Pirate", CFrame.new(-5420,15,-450), 2
        elseif Level < 1350 then return "ShipQuest1", "Ship Deckhand", CFrame.new(920,125,32800), 1
        elseif Level < 1400 then return "ShipQuest1", "Ship Engineer", CFrame.new(920,125,32800), 2
        elseif Level < 1425 then return "ArcticQuest", "Arctic Warrior", CFrame.new(6030,27,-6220), 1
        elseif Level < 1475 then return "ArcticQuest", "Snow Lurker", CFrame.new(6030,27,-6220), 2
        elseif Level <= 1500 then return "ForgottenQuest", "Sea Soldier", CFrame.new(-3050,235,-10150), 1
        end
    elseif PlaceID == 7449423635 then -- SEA 3
        if Level < 1575 then return "PortTownQuest", "Pirate Millionaire", CFrame.new(-300,40,5500), 1
        elseif Level < 1625 then return "PortTownQuest", "Pistol Billionaire", CFrame.new(-300,40,5500), 2
        elseif Level < 1700 then return "HydraIslandQuest", "Dragon Crew Warrior", CFrame.new(5200,600,200), 1
        elseif Level < 1725 then return "HydraIslandQuest", "Dragon Crew Archer", CFrame.new(5200,600,200), 2
        elseif Level < 1775 then return "GreatTreeQuest", "Marine Commodore", CFrame.new(2450,70,-7350), 1
        elseif Level < 1825 then return "GreatTreeQuest", "Marine Rear Admiral", CFrame.new(2450,70,-7350), 2
        elseif Level < 1850 then return "FloatingTurtleQuest", "Fishman Raider", CFrame.new(-10500,330,-8500), 1
        elseif Level < 1900 then return "FloatingTurtleQuest", "Fishman Captain", CFrame.new(-10500,330,-8500), 2
        elseif Level < 1975 then return "HauntedQuest", "Reborn Skeleton", CFrame.new(-8750,140,5500), 1
        elseif Level < 2075 then return "HauntedQuest", "Living Zombie", CFrame.new(-8750,140,5500), 2
        elseif Level < 2125 then return "NutsIslandQuest", "Peanut Scout", CFrame.new(-2000,50,-12900), 1
        elseif Level < 2200 then return "IceCreamIslandQuest", "Ice Cream Chef", CFrame.new(-900,65,-16500), 1
        elseif Level < 2275 then return "CakeQuest1", "Cookie Crafter", CFrame.new(-2000,70,-12000), 1
        elseif Level < 2350 then return "CakeQuest2", "Head Baker", CFrame.new(-1950,60,-12450), 1
        elseif Level < 2425 then return "TikiQuest", "Isle Outlaw", CFrame.new(-16000,10,1000), 1
        elseif Level <= 2550 then return "TikiQuest", "Island Boy", CFrame.new(-16000,10,1000), 2
        end
    end
    return "None", "Max", CFrame.new(0,0,0), 0
end

-- [[ 6. MAIN AUTO FARM UI ]]
Tabs.Main:AddParagraph({Title = "Redz Logic", Content = "Auto Level 1-2550"})
Tabs.Main:AddToggle("AutoFarm", {Title = "🔥 AUTO FARM LEVEL", Default = false })
Options.AutoFarm:OnChanged(function()
    getgenv().AF = Options.AutoFarm.Value
    
    -- Sub 1: NoClip
    task.spawn(function()
        while getgenv().AF do
            task.wait()
            pcall(function()
                if Player.Character then
                    for _,v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end
                end
            end)
        end
    end)
    
    -- Sub 2: Logic
    task.spawn(function()
        while getgenv().AF do
            task.wait()
            pcall(function()
                local Q, M, P, ID = GetQuestData()
                
                if Q == "None" then
                    Fluent:Notify({Title="Complete", Content="Max Level or Error", Duration=5})
                    return
                end
                
                if Player.PlayerGui.Main.Quest.Visible == false then
                    Remotes:InvokeServer("StartQuest", Q, ID)
                    if (Player.Character.HumanoidRootPart.Position - P.Position).Magnitude > 500 then
                        TP(P)
                        task.wait(2)
                    end
                else
                    pcall(function()
                        for _,t in pairs(Player.Backpack:GetChildren()) do if t:IsA("Tool") and t.ToolTip=="Melee" then Player.Character.Humanoid:EquipTool(t) end end
                    end)
                    
                    local Target = nil
                    for _,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == M and v.Humanoid.Health > 0 then
                            Target = v
                            break
                        end
                    end
                    
                    if Target then
                        Player.Character.HumanoidRootPart.CFrame = Target.HumanoidRootPart.CFrame * CFrame.new(0,7,0)
                        Player.Character.HumanoidRootPart.Velocity = Vector3.zero
                        Player.Character.HumanoidRootPart.CFrame = CFrame.new(Player.Character.HumanoidRootPart.Position, Target.HumanoidRootPart.Position)
                        FastAttack()
                    else
                        if (Player.Character.HumanoidRootPart.Position - P.Position).Magnitude > 50 then
                            Player.Character.HumanoidRootPart.CFrame = P
                        end
                    end
                end
            end)
        end
    end)
end)

-- [[ 7. AUTO BOSS ]]
Tabs.Main:AddParagraph({Title="Boss Farm", Content="Farm Drops"})
local BList = {"Saber Expert", "Fishman Lord", "Thunder God", "Wysper", "Chief Warden"}
Tabs.Main:AddDropdown("BossSel", {Title="Select Boss", Values=BList, Default=1})
Tabs.Main:AddToggle("AB", {Title="Auto Farm Boss", Default=false})
Options.AB:OnChanged(function()
    getgenv().AB = Options.AB.Value
    task.spawn(function()
        while getgenv().AB do
            task.wait()
            pcall(function()
                local BN = Options.BossSel.Value
                local T = nil
                for _,v in pairs(workspace.Enemies:GetChildren()) do if v.Name == BN and v.Humanoid.Health > 0 then T = v break end end
                if T then
                    Player.Character.HumanoidRootPart.CFrame = T.HumanoidRootPart.CFrame * CFrame.new(0,5,0)
                    FastAttack()
                end
            end)
        end
    end)
end)

-- [[ 8. TELEPORTS (UNPACKED) ]]
Tabs.Sea1:AddButton({Title = "Starter Pirate", Callback = function() TP(CFrame.new(1000, 10, 4500)) end})
Tabs.Sea1:AddButton({Title = "Starter Marine", Callback = function() TP(CFrame.new(-2800, 10, 2500)) end})
Tabs.Sea1:AddButton({Title = "Jungle", Callback = function() TP(CFrame.new(-1437, 24, 25)) end})
Tabs.Sea1:AddButton({Title = "Pirate Village", Callback = function() TP(CFrame.new(-100, 20, 100)) end})
Tabs.Sea1:AddButton({Title = "Desert", Callback = function() TP(CFrame.new(900, 10, 4000)) end})
Tabs.Sea1:AddButton({Title = "Middle Town", Callback = function() TP(CFrame.new(-650, 10, 1500)) end})
Tabs.Sea1:AddButton({Title = "Frozen Village", Callback = function() TP(CFrame.new(1150, 10, -1150)) end})
Tabs.Sea1:AddButton({Title = "Marine Fortress", Callback = function() TP(CFrame.new(-5000, 20, 5000)) end})
Tabs.Sea1:AddButton({Title = "Skylands", Callback = function() TP(CFrame.new(-4800, 720, -2500)) end})
Tabs.Sea1:AddButton({Title = "Prison", Callback = function() TP(CFrame.new(1500, 10, 1500)) end})
Tabs.Sea1:AddButton({Title = "Colosseum", Callback = function() TP(CFrame.new(-1500, 10, -3000)) end})
Tabs.Sea1:AddButton({Title = "Magma Village", Callback = function() TP(CFrame.new(-5300, 10, 8500)) end})
Tabs.Sea1:AddButton({Title = "Underwater City", Callback = function() TP(CFrame.new(61163, 11, 1819)) end})
Tabs.Sea1:AddButton({Title = "Fountain City", Callback = function() TP(CFrame.new(5250, 5, 4100)) end})

Tabs.Sea2:AddButton({Title = "Kingdom of Rose", Callback = function() TP(CFrame.new(-400, 75, 300)) end})
Tabs.Sea2:AddButton({Title = "Cafe", Callback = function() TP(CFrame.new(-400, 75, 300)) end})
Tabs.Sea2:AddButton({Title = "Green Zone", Callback = function() TP(CFrame.new(-2500, 75, -3000)) end})
Tabs.Sea2:AddButton({Title = "Graveyard", Callback = function() TP(CFrame.new(-5500, 10, -50)) end})
Tabs.Sea2:AddButton({Title = "Snow Mountain", Callback = function() TP(CFrame.new(500, 400, -5500)) end})
Tabs.Sea2:AddButton({Title = "Hot and Cold", Callback = function() TP(CFrame.new(-6000, 15, -1000)) end})
Tabs.Sea2:AddButton({Title = "Cursed Ship", Callback = function() TP(CFrame.new(900, 100, 33000)) end})
Tabs.Sea2:AddButton({Title = "Ice Castle", Callback = function() TP(CFrame.new(6000, 50, -6000)) end})
Tabs.Sea2:AddButton({Title = "Forgotten Island", Callback = function() TP(CFrame.new(-3000, 200, -10000)) end})

Tabs.Sea3:AddButton({Title = "Port Town", Callback = function() TP(CFrame.new(-290, 10, 5300)) end})
Tabs.Sea3:AddButton({Title = "Hydra Island", Callback = function() TP(CFrame.new(5300, 600, 500)) end})
Tabs.Sea3:AddButton({Title = "Great Tree", Callback = function() TP(CFrame.new(2500, 50, -12000)) end})
Tabs.Sea3:AddButton({Title = "Floating Turtle", Callback = function() TP(CFrame.new(-12000, 350, -7500)) end})
Tabs.Sea3:AddButton({Title = "Castle on the Sea", Callback = function() TP(CFrame.new(-5000, 300, -3000)) end})
Tabs.Sea3:AddButton({Title = "Haunted Castle", Callback = function() TP(CFrame.new(-9500, 150, 5500)) end})
Tabs.Sea3:AddButton({Title = "Sea of Treats", Callback = function() TP(CFrame.new(-2000, 50, -13000)) end})

-- [[ 9. SHOP ]]
Tabs.Shop:AddParagraph({Title="Combat Styles", Content="Basic & Advanced"})
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

Tabs.Shop:AddParagraph({Title="Swords", Content="Common & Rare"})
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

-- [[ 10. RAID ]]
local Chips = {"Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha", "Sand", "Phoenix", "Dough"}
Tabs.Raid:AddDropdown("ChipSelector", {Title = "Select Chip", Values = Chips, Multi = false, Default = 1 })
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
                        if (Player.Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude < 70 then
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                        end
                    end
                end
            end)
        end
    end)
end)

-- [[ 11. FRUITS ]]
Tabs.Fruit:AddButton({Title = "Random Fruit", Callback = function() Remotes:InvokeServer("Cousin", "Buy") end})
Tabs.Fruit:AddToggle("AutoStore", {Title = "Auto Store Fruits", Default = true })
Options.AutoStore:OnChanged(function()
    getgenv().AutoStore = Options.AutoStore.Value
    task.spawn(function()
        while getgenv().AutoStore do
            task.wait(1)
            pcall(function()
                for _, item in pairs(Player.Backpack:GetChildren()) do if string.find(item.Name, "Fruit") then Remotes:InvokeServer("StoreFruit", item.Name) end end
                for _, item in pairs(Player.Character:GetChildren()) do if string.find(item.Name, "Fruit") then Remotes:InvokeServer("StoreFruit", item.Name) end end
            end)
        end
    end)
end)

-- [[ 12. MISC ]]
Tabs.Misc:AddButton({Title = "Redeem All Codes", Callback = function()
    local Codes = {"NEWTROLL", "KITT_RESET", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "fudd10_v2", "Fudd10", "BIGNEWS", "THEGREATACE", "SUB2GAMERROBOT_RESET1", "SUB2GAMERROBOT_EXP1"}
    for _, code in pairs(Codes) do Remotes:InvokeServer("RedeemCode", code) task.wait(0.1) end
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

-- [[ FINAL ]]
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("WolfTeamV13")
SaveManager:SetFolder("WolfTeamV13/Config")
InterfaceManager:BuildInterfaceSection(Tabs.Misc)
Window:SelectTab(1)

Fluent:Notify({Title = "WolfTeam V13", Content = "LOADED SUCCESSFULLY", Duration = 5})
```
