----------------------------------------------------------------------------------------------------
-- Dependencies

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

----------------------------------------------------------------------------------------------------
-- Variables

local player = Players.LocalPlayer
local currentCamera = workspace.CurrentCamera

local stretch = 1
local squash = 1

----------------------------------------------------------------------------------------------------
-- Private Methods

local function lerp(a, b, t)
	return a + (b - a) * t
end

local function renderEffect()
	task.spawn(function()
		local direction = Enum.EasingDirection.Out
		local easing = Enum.EasingStyle.Quart
		local start = os.clock()
		
		while true do
			local alpha = math.min(1, (os.clock() - start) / 2)
			if alpha >= 1 then
				break
			end
			
			local a = TweenService:GetValue(alpha, easing, direction)
			stretch = lerp(0.8, 1, a)
			squash = lerp(0.6, 1, a)
			
			task.wait()
		end
	end)
	
	stretch = 0.8
	squash = 0.6
end

local function onRenderStep(dt: number)
	local x = stretch
	local y = squash
	
	currentCamera.CFrame *= CFrame.new(
		0, 0, 0,
		x, 0, 0, -- stretch
		0, y, 0, -- squash
		0, 0, 1
	)
end

local function onInputBegan(input: InputObject, processed: boolean)
	if processed then
		return
	end
	
	if input.KeyCode == Enum.KeyCode.R then
		renderEffect()
	end
end

----------------------------------------------------------------------------------------------------
-- Connections

RunService:BindToRenderStep("ViewportSkewer", Enum.RenderPriority.Camera.Value + 1, onRenderStep)

UserInputService.InputBegan:Connect(onInputBegan)
player.CharacterAdded:Connect(renderEffect)
