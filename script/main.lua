-- === НАСТРОЙКИ ДЛЯ ТЕЛЕФОНА ===
local ScreenSize = UDim2.fromOffset(550, 400) 
local MinimizeKey = Enum.KeyCode.LeftControl 

-- === ЗАГРУЗКА БИБЛИОТЕКИ ===
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Troll Hub Mobile",
    SubTitle = "Delta / Blox Fruits",
    TabWidth = 140,
    Size = ScreenSize,
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = MinimizeKey
})

local Tabs = {
    Main = Window:AddTab({ Title = "Фарм", Icon = "swords" }),
    Troll = Window:AddTab({ Title = "Троллинг", Icon = "smile" }), 
    Stats = Window:AddTab({ Title = "Статы", Icon = "user" }),
    Settings = Window:AddTab({ Title = "Настройки", Icon = "settings" })
}

local Options = Fluent.Options
local Player = game.Players.LocalPlayer

-- === ФУНКЦИИ ТРОЛЛИНГА ===

-- Обновление списка игроков
local function GetPlayerNames()
    local list = {}
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player then table.insert(list, v.Name) end
    end
    return list
end

-- Fling (Крутилка)
local function Fling(TargetName)
    local Target = game.Players:FindFirstChild(TargetName)
    if not Target or not Target.Character then return end
    
    local TChar = Target.Character
    local MyChar = Player.Character
    local THead = TChar:FindFirstChild("Head")
    local MyRoot = MyChar:FindFirstChild("HumanoidRootPart")
    
    if THead and MyRoot then
        -- Телепорт и вращение
        local bambam = Instance.new("BodyAngularVelocity")
        bambam.Name = "FlingForce"
        bambam.Parent = MyRoot
        bambam.AngularVelocity = Vector3.new(0,99999,0)
        bambam.MaxTorque = Vector3.new(0,math.huge,0)
        bambam.P = math.huge
        
        -- Прилепляемся к жертве
        local connection
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            if not getgenv().Flinging or not TChar or not MyChar then 
                bambam:Destroy()
                connection:Disconnect()
                return 
            end
            MyRoot.CFrame = THead.CFrame * CFrame.new(0,-2,0)
            MyRoot.Velocity = Vector3.new(9999,9999,9999)
        end)
    end
end

-- === ВКЛАДКА ТРОЛЛИНГ ===

Tabs.Troll:AddParagraph({
    Title = "Как работает Fling?",
    Content = "Включи God Mode (Неуязвимость) в игре если есть, выбери жертву и нажми Fling. Ты начнешь бешено вращаться и толкать игрока. \nВАЖНО: Работает только ВНЕ безопасной зоны (PVP On)."
})

-- Выпадающий список игроков
local PlayerDropdown = Tabs.Troll:AddDropdown("TargetPlayer", {
    Title = "Выбери жертву",
    Values = GetPlayerNames(),
    Multi = false,
    Default = 1,
})

Tabs.Troll:AddButton({
    Title = "Обновить список игроков",
    Description = "Нажми, если кто-то зашел/вышел",
    Callback = function()
        PlayerDropdown:SetValues(GetPlayerNames())
        PlayerDropdown:SetValue(nil)
    end
})

-- Телепорт к игроку
Tabs.Troll:AddButton({
    Title = "Телепорт к жертве",
    Callback = function()
        local tName = Options.TargetPlayer.Value
        local tPlayer = game.Players:FindFirstChild(tName)
        if tPlayer and tPlayer.Character and tPlayer.Character:FindFirstChild("HumanoidRootPart") and Player.Character then
            Player.Character.HumanoidRootPart.CFrame = tPlayer.Character.HumanoidRootPart.CFrame
        else
            Fluent:Notify({Title = "Ошибка", Content = "Игрок не найден или мертв", Duration = 3})
        end
    end
})

-- Наблюдение
Tabs.Troll:AddToggle("SpectateToggle", {Title = "Следить за жертвой", Default = false })
Options.SpectateToggle:OnChanged(function()
    local tName = Options.TargetPlayer.Value
    local tPlayer = game.Players:FindFirstChild(tName)
    if Options.SpectateToggle.Value and tPlayer then
        workspace.CurrentCamera.CameraSubject = tPlayer.Character.Humanoid
    else
        workspace.CurrentCamera.CameraSubject = Player.Character.Humanoid
    end
end)

-- FLING
Tabs.Troll:AddToggle("FlingToggle", {Title = "FLING (ВЫКИНУТЬ ИГРОКА)", Default = false })
Options.FlingToggle:OnChanged(function()
    getgenv().Flinging = Options.FlingToggle.Value
    if getgenv().Flinging then
        Fling(Options.TargetPlayer.Value)
    else
        -- Остановка флинга, восстанавливаем скорость
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
             Player.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
             Player.Character.HumanoidRootPart.RotVelocity = Vector3.new(0,0,0)
             for _, v in pairs(Player.Character.HumanoidRootPart:GetChildren()) do
                 if v.Name == "FlingForce" then v:Destroy() end
             end
        end
    end
end)

-- СПАМ ЧАТ
Tabs.Troll:AddInput("SpamText", {
    Title = "Текст для спама",
    Default = "EZZZZZ Delta User on Top",
    Placeholder = "Введи текст",
    Numeric = false,
    Finished = false,
})

Tabs.Troll:AddToggle("SpamToggle", {Title = "Включить Спам Чата", Default = false })
Options.SpamToggle:OnChanged(function()
    getgenv().ChatSpam = Options.SpamToggle.Value
    task.spawn(function()
        while getgenv().ChatSpam do
            wait(2) -- Задержка чтобы не забанили чат
            local msg = Options.SpamText.Value
            local args = {
                [1] = msg,
                [2] = "All"
            }
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
        end
    end)
end)


-- === ВКЛАДКА ФАРМ (БАЗА) ===
-- (Оставляем тот же простой фарм, что и был, чтобы скрипт был полезным)

local FarmToggle = Tabs.Main:AddToggle("FarmToggle", {Title = "Автофарм Мобов", Default = false })
FarmToggle:OnChanged(function()
    getgenv().AutoFarm = Options.FarmToggle.Value
    task.spawn(function()
        while getgenv().AutoFarm do
            task.wait()
            pcall(function()
                -- Простой код атаки
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(1280, 672))
                
                -- Простой код полета к мобам (урезанный для примера)
                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and Player.Character then
                        if (enemy.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude < 1000 then
                             Player.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0,5,0)
                             break -- Бьем первого попавшегося
                        end
                    end
                end
            end)
        end
    end)
end)


-- === СТАТЫ ===
Tabs.Stats:AddSlider("Speed", {Title = "Скорость", Default = 16, Min = 16, Max = 500, Callback = function(v) pcall(function() Player.Character.Humanoid.WalkSpeed = v end) end})
Tabs.Stats:AddButton({Title = "Невидимка (Только тело)", Callback = function() 
    if Player.Character then 
        for _,v in pairs(Player.Character:GetChildren()) do 
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end 
        end 
    end 
end})

-- Финал
InterfaceManager:SetFolder("TrollHubMobile")
SaveManager:SetFolder("TrollHubMobile/Config")
Window:SelectTab(2) -- Сразу открываем вкладку Троллинга
