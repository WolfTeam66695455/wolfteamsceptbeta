--// Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HiddenDeltaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

--// Main Frame (хаб)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 200)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false -- хаб изначально скрыт
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

--// Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "WFteambeta"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

--// Example button 1
local Button1 = Instance.new("TextButton")
Button1.Size = UDim2.new(1, -20, 0, 40)
Button1.Position = UDim2.new(0, 10, 0, 60)
Button1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Button1.Text = "Auto Farm [OFF]"
Button1.TextColor3 = Color3.fromRGB(255, 255, 255)
Button1.Font = Enum.Font.Gotham
Button1.TextSize = 16
Button1.Parent = MainFrame
Instance.new("UICorner", Button1)

local AutoFarm = false
Button1.MouseButton1Click:Connect(function()
    AutoFarm = not AutoFarm
    Button1.Text = AutoFarm and "Auto Farm [ON]" or "Auto Farm [OFF]"
end)

--// Example button 2
local Button2 = Instance.new("TextButton")
Button2.Size = UDim2.new(1, -20, 0, 40)
Button2.Position = UDim2.new(0, 10, 0, 110)
Button2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Button2.Text = "Auto Stats"
Button2.TextColor3 = Color3.fromRGB(255, 255, 255)
Button2.Font = Enum.Font.Gotham
Button2.TextSize = 16
Button2.Parent = MainFrame
Instance.new("UICorner", Button2)

Button2.MouseButton1Click:Connect(function()
    print("Auto Stats clicked")
end)

--// Hidden Hub Icon (кружок с картинкой)
local IconButton = Instance.new("ImageButton")
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0, 10, 0, 10) -- левый верхний угол
IconButton.BackgroundTransparency = 1
IconButton.Image = "rbxassetid://YOUR_ASSET_ID_HERE" -- вставь сюда свой Asset ID
IconButton.Parent = ScreenGui

--// Логика скрытия/открытия хаба
IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--// Optional: hover effect на иконке
IconButton.MouseEnter:Connect(function()
    IconButton.ImageTransparency = 0.2
end)
IconButton.MouseLeave:Connect(function()
    IconButton.ImageTransparency = 0
end)
