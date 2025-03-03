local UserInputService = game:GetService("UserInputService")

-- Створюємо ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Створюємо Frame для перетягування
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 50)
frame.Position = UDim2.new(0.5, -100, 0.5, -25)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.Active = true
frame.Parent = screenGui

-- Створюємо кнопку для польоту
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.Text = "step"
button.Parent = frame

local flying = false
local speed = 50

-- Функція для ввімкнення/вимкнення польоту
local function toggleFly()
	local player = game.Players.LocalPlayer
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local hrp = character.HumanoidRootPart
		if flying then
			hrp.Anchored = false
			button.Text = "step"
		else
			hrp.Anchored = true
			task.spawn(function()
				while flying do
					hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * speed * 0.01
					task.wait()
				end
			end)
			button.Text = "dont step"
		end
		flying = not flying
	end
end

-- Додаємо подію натискання кнопки
button.MouseButton1Click:Connect(toggleFly)

-- Логіка перетягування вікна мишею
local dragging
local dragInput
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
