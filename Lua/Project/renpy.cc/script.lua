if Settings['ENABLE_FPS_UNLOCKER'] == true then
    setfpscap(Settings['FPS_Amount'])
end

local UIS = game:GetService('UserInputService')

if Settings.Macro['Enable'] == true then
	local Player = game:GetService("Players").LocalPlayer
	local Mouse = Player:GetMouse()
	local SpeedGlitch = false
	Mouse.KeyDown:Connect(function(Key)
		if Key == Settings.Macro['Keybind'] then
			SpeedGlitch = not SpeedGlitch
			if SpeedGlitch == true then
				repeat game:GetService("VirtualInputManager"):SendMouseWheelEvent("0", "0", true, game)
					wait()
					game:GetService("VirtualInputManager"):SendMouseWheelEvent("0", "0", false, game)
					wait()
				until SpeedGlitch == false
			end
		end
	end)
end

rconsoleclear()
rconsolename("Renpy.cc")
rconsoleprint('@@CYAN@@')
rconsoleprint([[

    $$$$$$$\                                                                 
    $$  __$$\                                                                
    $$ |  $$ | $$$$$$\  $$$$$$$\   $$$$$$\  $$\   $$\     $$$$$$$\  $$$$$$$\ 
    $$$$$$$  |$$  __$$\ $$  __$$\ $$  __$$\ $$ |  $$ |   $$  _____|$$  _____|
    $$  __$$< $$$$$$$$ |$$ |  $$ |$$ /  $$ |$$ |  $$ |   $$ /      $$ /      
    $$ |  $$ |$$   ____|$$ |  $$ |$$ |  $$ |$$ |  $$ |   $$ |      $$ |      
    $$ |  $$ |\$$$$$$$\ $$ |  $$ |$$$$$$$  |\$$$$$$$ |$$\\$$$$$$$\ \$$$$$$$\ 
    \__|  \__| \_______|\__|  \__|$$  ____/  \____$$ |\__|\_______| \_______|
                                  $$ |      $$\   $$ |                       
                                  $$ |      \$$$$$$  |                       
                                  \__|       \______/                        
                                  
]])
wait(2)

rconsoleprint('@@WHITE@@')
rconsoleprint(' Thanks For Using Renpy Script! | FREE Version \n')
wait(2)

rconsoleprint('@@RED@@')
rconsoleprint(" renpy !#8410 \n")
wait(2)

rconsoleprint(" Also Thanks to Halal Gaming(Eshakur#2263) For Showcasing My Script \n")
rconsoleprint('@@WHITE@@')
wait(2)

rconsoleinfo('DM Me For Ideas!')
rconsoleinfo("Mind Donating? - https://www.roblox.com/game-pass/69457458/Roblox")
wait(2)
    
rconsoleprint(" Loading. | Anti Cheat Bypass \n")
wait(2)

rconsoleprint(" Loading.. | Checking User \n")
wait(2)

rconsoleprint(" Loading... | Anti Mod \n")
wait(1.5)

local OldAimPart = "HumanoidRootPart"
local AimPart = "UpperTorso"  
local AimlockKey = "x"
local AimRadius = 30
local ThirdPerson = true 
local FirstPerson = true
local TeamCheck = false
local PredictMovement = false
local PredictionVelocity = 0
local CheckIfJumped = false
local Smoothness = false
local SmoothnessAmount = 0.015

local Players, Uis, RService, SGui = game:GetService"Players", game:GetService"UserInputService", game:GetService"RunService", game:GetService"StarterGui";
local Client, Mouse, Camera, CF, RNew, Vec3, Vec2 = Players.LocalPlayer, Players.LocalPlayer:GetMouse(), workspace.CurrentCamera, CFrame.new, Ray.new, Vector3.new, Vector2.new;
local Aimlock, MousePressed, CanNotify = false, false, false;
local AimlockTarget;
local OldPre;

local WorldToViewportPoint = function(P)
	return Camera:WorldToViewportPoint(P)
end

local WorldToScreenPoint = function(P)
	return Camera.WorldToScreenPoint(Camera, P)
end

local GetObscuringObjects = function(T)
	if T and T:FindFirstChild(AimPart) and Client and Client.Character:FindFirstChild("Head") then 
		local RayPos = workspace:FindPartOnRay(RNew(
			T[AimPart].Position, Client.Character.Head.Position)
		)
		if RayPos then return RayPos:IsDescendantOf(T) end
	end
end

local GetNearestTarget = function()
	local players = {}
	local PLAYER_HOLD  = {}
	local DISTANCES = {}
	for i, v in pairs(Players:GetPlayers()) do
		if v ~= Client then
			table.insert(players, v)
		end
	end
	for i, v in pairs(players) do
		if v.Character ~= nil then
			local AIM = v.Character:FindFirstChild("Head")
			if TeamCheck == true and v.Team ~= Client.Team then
				local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
				local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
				local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
				local DIFF = math.floor((POS - AIM.Position).magnitude)
				PLAYER_HOLD[v.Name .. i] = {}
				PLAYER_HOLD[v.Name .. i].dist= DISTANCE
				PLAYER_HOLD[v.Name .. i].plr = v
				PLAYER_HOLD[v.Name .. i].diff = DIFF
				table.insert(DISTANCES, DIFF)
			elseif TeamCheck == false and v.Team == Client.Team then 
				local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
				local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
				local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
				local DIFF = math.floor((POS - AIM.Position).magnitude)
				PLAYER_HOLD[v.Name .. i] = {}
				PLAYER_HOLD[v.Name .. i].dist= DISTANCE
				PLAYER_HOLD[v.Name .. i].plr = v
				PLAYER_HOLD[v.Name .. i].diff = DIFF
				table.insert(DISTANCES, DIFF)
			end
		end
	end

	if unpack(DISTANCES) == nil then
		return nil
	end

	local L_DISTANCE = math.floor(math.min(unpack(DISTANCES)))
	if L_DISTANCE > AimRadius then
		return nil
	end

	for i, v in pairs(PLAYER_HOLD) do
		if v.diff == L_DISTANCE then
			return v.plr
		end
	end
	return nil
end

Mouse.KeyDown:Connect(function(a)
	if not (Uis:GetFocusedTextBox()) then 
		if a == AimlockKey and AimlockTarget == nil then
			pcall(function()
				if MousePressed ~= true then MousePressed = true end 
				local Target;Target = GetNearestTarget()
				if Target ~= nil then 
					AimlockTarget = Target
				end
			end)
		elseif a == AimlockKey and AimlockTarget ~= nil then
			if AimlockTarget ~= nil then AimlockTarget = nil end
			if MousePressed ~= false then 
				MousePressed = false 
			end
		end
	end
end)

RService.RenderStepped:Connect(function()
	if ThirdPerson == true and FirstPerson == true then 
		if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 or (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
			CanNotify = true 
		else 
			CanNotify = false 
		end
	elseif ThirdPerson == true and FirstPerson == false then 
		if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 then 
			CanNotify = true 
		else 
			CanNotify = false 
		end
	elseif ThirdPerson == false and FirstPerson == true then 
		if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
			CanNotify = true 
		else 
			CanNotify = false 
		end
	end
	if Aimlock == true and MousePressed == true then 
		if AimlockTarget and AimlockTarget.Character and AimlockTarget.Character:FindFirstChild(AimPart) then 
			if FirstPerson == true then
				if CanNotify == true then
					if PredictMovement == true then
						if Smoothness == true then
							local Main = CF(Camera.CFrame.p, AimlockTarget.Character[AimPart].Position + AimlockTarget.Character[AimPart].Velocity * PredictionVelocity)
							Camera.CFrame = Camera.CFrame:Lerp(Main, SmoothnessAmount, Enum.EasingStyle.Bounce, Enum.EasingDirection.InOut)
						else
							Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[AimPart].Position + AimlockTarget.Character[AimPart].Velocity * PredictionVelocity)
						end
					elseif PredictMovement == false then 
						if Smoothness == true then
							local Main = CF(Camera.CFrame.p, AimlockTarget.Character[AimPart].Position)
							Camera.CFrame = Camera.CFrame:Lerp(Main, SmoothnessAmount, Enum.EasingStyle.Bounce, Enum.EasingDirection.InOut)
						else
							Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[AimPart].Position)
						end
					end
				end
			end
		end
	end
	if CheckIfJumped == true then
		if AimlockTarget.Character.Humanoid.FloorMaterial == Enum.Material.Air then
			AimPart = "RightFeet"
		else
			AimPart = OldAimPart
		end
	end
end)

local renpycc = Instance.new("ScreenGui")
local F1 = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Line = Instance.new("Frame")
local UIGradient = Instance.new("UIGradient")
local Title = Instance.new("TextLabel")
local aimbotText = Instance.new("TextLabel")
local toggleFrame1 = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local UIStroke_2 = Instance.new("UIStroke")
local Toggle1 = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local enablepredictionText = Instance.new("TextLabel")
local toggleFrame2 = Instance.new("Frame")
local UICorner_4 = Instance.new("UICorner")
local UIStroke_3 = Instance.new("UIStroke")
local Toggle2 = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")
local smoothText = Instance.new("TextLabel")
local toggleFrame3 = Instance.new("Frame")
local UICorner_6 = Instance.new("UICorner")
local UIStroke_4 = Instance.new("UIStroke")
local Toggle3 = Instance.new("TextButton")
local UICorner_7 = Instance.new("UICorner")
local predictionText = Instance.new("TextLabel")
local predictionBox = Instance.new("TextBox")
local UICorner_8 = Instance.new("UICorner")
local UIStroke_5 = Instance.new("UIStroke")
local keybindText = Instance.new("TextLabel")
local keybindBox = Instance.new("TextBox")
local UICorner_9 = Instance.new("UICorner")
local UIStroke_6 = Instance.new("UIStroke")
local smoothnessText = Instance.new("TextLabel")
local smoothnessBox = Instance.new("TextBox")
local UICorner_10 = Instance.new("UICorner")
local UIStroke_7 = Instance.new("UIStroke")
local dropdown = Instance.new("TextButton")
local UICorner_11 = Instance.new("UICorner")
local UIStroke_8 = Instance.new("UIStroke")
local dropdownFrame = Instance.new("Frame")
local UICorner_12 = Instance.new("UICorner")
local UIStroke_9 = Instance.new("UIStroke")
local headPart = Instance.new("TextButton")
local UICorner_13 = Instance.new("UICorner")
local UIStroke_10 = Instance.new("UIStroke")
local torsoPart = Instance.new("TextButton")
local UICorner_14 = Instance.new("UICorner")
local UIStroke_11 = Instance.new("UIStroke")
local lowerPart = Instance.new("TextButton")
local UICorner_15 = Instance.new("UICorner")
local UIStroke_12 = Instance.new("UIStroke")
local feetPart = Instance.new("TextButton")
local UICorner_16 = Instance.new("UICorner")
local UIStroke_13 = Instance.new("UIStroke")
local dropdown1 = Instance.new("TextButton")
local UICorner_17 = Instance.new("UICorner")
local UIStroke_14 = Instance.new("UIStroke")
local dropdownFrame1 = Instance.new("Frame")
local UICorner_18 = Instance.new("UICorner")
local UIStroke_15 = Instance.new("UIStroke")
local Toggle4 = Instance.new("TextButton")
local UICorner_19 = Instance.new("UICorner")
local UIStroke_16 = Instance.new("UIStroke")
local Toggle5 = Instance.new("TextButton")
local UICorner_20 = Instance.new("UICorner")
local UIStroke_17 = Instance.new("UIStroke")
local Line1 = Instance.new("Frame")
local UIGradient_2 = Instance.new("UIGradient")
local Title1 = Instance.new("TextLabel")
local teamcheckText = Instance.new("TextLabel")
local toggleFrame4 = Instance.new("Frame")
local UICorner_21 = Instance.new("UICorner")
local UIStroke_18 = Instance.new("UIStroke")
local Toggle6 = Instance.new("TextButton")
local UICorner_22 = Instance.new("UICorner")

--Properties:

renpycc.Name = "renpy.cc"
renpycc.Parent = game.CoreGui
renpycc.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

F1.Name = "F1"
F1.Parent = renpycc
F1.AnchorPoint = Vector2.new(0.5, 0.5)
F1.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
F1.Position = UDim2.new(0.499973089, 0, 0.49948594, 0)
F1.Size = UDim2.new(0, 479, 0, 516)

UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = F1

UIStroke.Parent = F1
UIStroke.Color = Color3.fromRGB(63, 63, 63)

Line.Name = "Line"
Line.Parent = F1
Line.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Line.BorderSizePixel = 0
Line.Position = UDim2.new(0.0166862011, 0, 0.0370230228, 0)
Line.Size = UDim2.new(0, 452, 0, 1)

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
UIGradient.Offset = Vector2.new(0, 5)
UIGradient.Parent = Line

Title.Name = "Title"
Title.Parent = F1
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.Position = UDim2.new(0.435523123, 0, 0.012987013, 0)
Title.Size = UDim2.new(0, 52, 0, 6)
Title.Font = Enum.Font.Jura
Title.Text = "renpy.cc"
Title.TextColor3 = Color3.fromRGB(202, 202, 202)
Title.TextSize = 13.000
Title.TextStrokeTransparency = 0.000

aimbotText.Name = "aimbotText"
aimbotText.Parent = F1
aimbotText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
aimbotText.BackgroundTransparency = 1.000
aimbotText.Position = UDim2.new(0.0125110438, 0, 0.0496577024, 0)
aimbotText.Size = UDim2.new(0, 110, 0, 17)
aimbotText.Font = Enum.Font.Jura
aimbotText.Text = "Enable AImbot"
aimbotText.TextColor3 = Color3.fromRGB(202, 202, 202)
aimbotText.TextSize = 14.000
aimbotText.TextStrokeTransparency = 0.000
aimbotText.TextXAlignment = Enum.TextXAlignment.Left

toggleFrame1.Name = "toggleFrame1"
toggleFrame1.Parent = aimbotText
toggleFrame1.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
toggleFrame1.BorderSizePixel = 0
toggleFrame1.Position = UDim2.new(1.05547452, 0, 0.0360326171, 0)
toggleFrame1.Size = UDim2.new(0, 39, 0, 15)

UICorner_2.CornerRadius = UDim.new(0, 100)
UICorner_2.Parent = toggleFrame1

UIStroke_2.Parent = toggleFrame1
UIStroke_2.Color = Color3.fromRGB(63, 63, 63)

Toggle1.Name = "Toggle1"
Toggle1.Parent = toggleFrame1
Toggle1.BackgroundColor3 = Color3.fromRGB(202, 202, 202)
Toggle1.BorderSizePixel = 0
Toggle1.Position = UDim2.new(0.487179518, 0, -0.199999809, 0)
Toggle1.Size = UDim2.new(0, 20, 0, 20)
Toggle1.Font = Enum.Font.SourceSans
Toggle1.Text = ""
Toggle1.TextColor3 = Color3.fromRGB(0, 0, 0)
Toggle1.TextSize = 14.000

UICorner_3.CornerRadius = UDim.new(0, 100)
UICorner_3.Parent = Toggle1

enablepredictionText.Name = "enablepredictionText"
enablepredictionText.Parent = F1
enablepredictionText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
enablepredictionText.BackgroundTransparency = 1.000
enablepredictionText.Position = UDim2.new(0.0125110438, 0, 0.0957918167, 0)
enablepredictionText.Size = UDim2.new(0, 110, 0, 17)
enablepredictionText.Font = Enum.Font.Jura
enablepredictionText.Text = "Enable Prediction"
enablepredictionText.TextColor3 = Color3.fromRGB(202, 202, 202)
enablepredictionText.TextSize = 14.000
enablepredictionText.TextStrokeTransparency = 0.000
enablepredictionText.TextXAlignment = Enum.TextXAlignment.Left

toggleFrame2.Name = "toggleFrame2"
toggleFrame2.Parent = enablepredictionText
toggleFrame2.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
toggleFrame2.BorderSizePixel = 0
toggleFrame2.Position = UDim2.new(1.05547452, 0, -0.0227909125, 0)
toggleFrame2.Size = UDim2.new(0, 39, 0, 15)

UICorner_4.CornerRadius = UDim.new(0, 100)
UICorner_4.Parent = toggleFrame2

UIStroke_3.Parent = toggleFrame2
UIStroke_3.Color = Color3.fromRGB(63, 63, 63)

Toggle2.Name = "Toggle2"
Toggle2.Parent = toggleFrame2
Toggle2.BackgroundColor3 = Color3.fromRGB(202, 202, 202)
Toggle2.BorderSizePixel = 0
Toggle2.Position = UDim2.new(0.487179518, 0, -0.199999809, 0)
Toggle2.Size = UDim2.new(0, 20, 0, 20)
Toggle2.Font = Enum.Font.SourceSans
Toggle2.Text = ""
Toggle2.TextColor3 = Color3.fromRGB(0, 0, 0)
Toggle2.TextSize = 14.000

UICorner_5.CornerRadius = UDim.new(0, 100)
UICorner_5.Parent = Toggle2

smoothText.Name = "smoothText"
smoothText.Parent = F1
smoothText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
smoothText.BackgroundTransparency = 1.000
smoothText.Position = UDim2.new(0.0125109246, 0, 0.141925871, 0)
smoothText.Size = UDim2.new(0, 110, 0, 17)
smoothText.Font = Enum.Font.Jura
smoothText.Text = "Enable Smooth"
smoothText.TextColor3 = Color3.fromRGB(202, 202, 202)
smoothText.TextSize = 14.000
smoothText.TextStrokeTransparency = 0.000
smoothText.TextXAlignment = Enum.TextXAlignment.Left

toggleFrame3.Name = "toggleFrame3"
toggleFrame3.Parent = smoothText
toggleFrame3.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
toggleFrame3.BorderSizePixel = 0
toggleFrame3.Position = UDim2.new(1.05547452, 0, -0.0227909125, 0)
toggleFrame3.Size = UDim2.new(0, 39, 0, 15)

UICorner_6.CornerRadius = UDim.new(0, 100)
UICorner_6.Parent = toggleFrame3

UIStroke_4.Parent = toggleFrame3
UIStroke_4.Color = Color3.fromRGB(63, 63, 63)

Toggle3.Name = "Toggle3"
Toggle3.Parent = toggleFrame3
Toggle3.BackgroundColor3 = Color3.fromRGB(202, 202, 202)
Toggle3.BorderSizePixel = 0
Toggle3.Position = UDim2.new(0.487179518, 0, -0.199999809, 0)
Toggle3.Size = UDim2.new(0, 20, 0, 20)
Toggle3.Font = Enum.Font.SourceSans
Toggle3.Text = ""
Toggle3.TextColor3 = Color3.fromRGB(0, 0, 0)
Toggle3.TextSize = 14.000

UICorner_7.CornerRadius = UDim.new(0, 100)
UICorner_7.Parent = Toggle3

predictionText.Name = "predictionText"
predictionText.Parent = F1
predictionText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
predictionText.BackgroundTransparency = 1.000
predictionText.Position = UDim2.new(0.0149439555, 0, 0.280974507, 0)
predictionText.Size = UDim2.new(0, 110, 0, 17)
predictionText.Font = Enum.Font.Jura
predictionText.Text = "Prediction :"
predictionText.TextColor3 = Color3.fromRGB(202, 202, 202)
predictionText.TextSize = 14.000
predictionText.TextStrokeTransparency = 0.000
predictionText.TextXAlignment = Enum.TextXAlignment.Left

predictionBox.Name = "predictionBox"
predictionBox.Parent = predictionText
predictionBox.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
predictionBox.Position = UDim2.new(0.99683696, 0, -0.0870893896, 0)
predictionBox.Size = UDim2.new(0, 109, 0, 18)
predictionBox.Font = Enum.Font.Jura
predictionBox.Text = ""
predictionBox.TextColor3 = Color3.fromRGB(202, 202, 202)
predictionBox.TextSize = 13.000
predictionBox.TextStrokeTransparency = 0.000

UICorner_8.CornerRadius = UDim.new(0, 5)
UICorner_8.Parent = predictionBox

UIStroke_5.Parent = predictionBox
UIStroke_5.Color = Color3.fromRGB(63, 63, 63)
UIStroke_5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

keybindText.Name = "keybindText"
keybindText.Parent = F1
keybindText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
keybindText.BackgroundTransparency = 1.000
keybindText.Position = UDim2.new(0.0149439555, 0, 0.326882064, 0)
keybindText.Size = UDim2.new(0, 110, 0, 17)
keybindText.Font = Enum.Font.Jura
keybindText.Text = "Keybind :"
keybindText.TextColor3 = Color3.fromRGB(202, 202, 202)
keybindText.TextSize = 14.000
keybindText.TextStrokeTransparency = 0.000
keybindText.TextXAlignment = Enum.TextXAlignment.Left

keybindBox.Name = "keybindBox"
keybindBox.Parent = keybindText
keybindBox.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
keybindBox.Position = UDim2.new(0.99683696, 0, -0.0870893896, 0)
keybindBox.Size = UDim2.new(0, 109, 0, 18)
keybindBox.Font = Enum.Font.Jura
keybindBox.Text = ""
keybindBox.TextColor3 = Color3.fromRGB(202, 202, 202)
keybindBox.TextSize = 13.000
keybindBox.TextStrokeTransparency = 0.000

UICorner_9.CornerRadius = UDim.new(0, 5)
UICorner_9.Parent = keybindBox

UIStroke_6.Parent = keybindBox
UIStroke_6.Color = Color3.fromRGB(63, 63, 63)
UIStroke_6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

smoothnessText.Name = "smoothnessText"
smoothnessText.Parent = F1
smoothnessText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
smoothnessText.BackgroundTransparency = 1.000
smoothnessText.Position = UDim2.new(0.0149439555, 0, 0.374727666, 0)
smoothnessText.Size = UDim2.new(0, 110, 0, 17)
smoothnessText.Font = Enum.Font.Jura
smoothnessText.Text = "Smoothness :"
smoothnessText.TextColor3 = Color3.fromRGB(202, 202, 202)
smoothnessText.TextSize = 14.000
smoothnessText.TextStrokeTransparency = 0.000
smoothnessText.TextXAlignment = Enum.TextXAlignment.Left

smoothnessBox.Name = "smoothnessBox"
smoothnessBox.Parent = smoothnessText
smoothnessBox.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
smoothnessBox.Position = UDim2.new(0.99683696, 0, -0.0870893896, 0)
smoothnessBox.Size = UDim2.new(0, 109, 0, 18)
smoothnessBox.Font = Enum.Font.Jura
smoothnessBox.Text = ""
smoothnessBox.TextColor3 = Color3.fromRGB(202, 202, 202)
smoothnessBox.TextSize = 13.000
smoothnessBox.TextStrokeTransparency = 0.000

UICorner_10.CornerRadius = UDim.new(0, 5)
UICorner_10.Parent = smoothnessBox

UIStroke_7.Parent = smoothnessBox
UIStroke_7.Color = Color3.fromRGB(63, 63, 63)
UIStroke_7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

dropdown.Name = "dropdown"
dropdown.Parent = F1
dropdown.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
dropdown.BorderSizePixel = 0
dropdown.Position = UDim2.new(0.607957602, 0, 0.0498842001, 0)
dropdown.Size = UDim2.new(0, 168, 0, 14)
dropdown.Font = Enum.Font.Jura
dropdown.Text = "Aimpart"
dropdown.TextColor3 = Color3.fromRGB(202, 202, 202)
dropdown.TextSize = 13.000
dropdown.TextStrokeTransparency = 0.000

UICorner_11.CornerRadius = UDim.new(0, 4)
UICorner_11.Parent = dropdown

UIStroke_8.Parent = dropdown
UIStroke_8.Color = Color3.fromRGB(63, 63, 63)
UIStroke_8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

dropdownFrame.Name = "dropdownFrame"
dropdownFrame.Parent = F1
dropdownFrame.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
dropdownFrame.BorderColor3 = Color3.fromRGB(63, 63, 63)
dropdownFrame.ClipsDescendants = true
dropdownFrame.Position = UDim2.new(0.607957602, 0, 0.0910097361, 0)
dropdownFrame.Size = UDim2.new(0, 168, 0, 0)

UICorner_12.CornerRadius = UDim.new(0, 4)
UICorner_12.Parent = dropdownFrame

UIStroke_9.Parent = dropdownFrame
UIStroke_9.Color = Color3.fromRGB(63, 63, 63)
UIStroke_9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

headPart.Name = "headPart"
headPart.Parent = dropdownFrame
headPart.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
headPart.Position = UDim2.new(0.0357142873, 0, 0.0857142881, 0)
headPart.Size = UDim2.new(0, 156, 0, 17)
headPart.Font = Enum.Font.Jura
headPart.Text = "Head"
headPart.TextColor3 = Color3.fromRGB(202, 202, 202)
headPart.TextSize = 14.000
headPart.TextStrokeTransparency = 0.000

UICorner_13.CornerRadius = UDim.new(0, 4)
UICorner_13.Parent = headPart

UIStroke_10.Parent = headPart
UIStroke_10.Color = Color3.fromRGB(63, 63, 63)
UIStroke_10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

torsoPart.Name = "torsoPart"
torsoPart.Parent = dropdownFrame
torsoPart.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
torsoPart.Position = UDim2.new(0.0357142873, 0, 0.304761916, 0)
torsoPart.Size = UDim2.new(0, 156, 0, 17)
torsoPart.Font = Enum.Font.Jura
torsoPart.Text = "HumanoidRootPart"
torsoPart.TextColor3 = Color3.fromRGB(202, 202, 202)
torsoPart.TextSize = 14.000
torsoPart.TextStrokeTransparency = 0.000

UICorner_14.CornerRadius = UDim.new(0, 4)
UICorner_14.Parent = torsoPart

UIStroke_11.Parent = torsoPart
UIStroke_11.Color = Color3.fromRGB(63, 63, 63)
UIStroke_11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

lowerPart.Name = "lowerPart"
lowerPart.Parent = dropdownFrame
lowerPart.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
lowerPart.Position = UDim2.new(0.0357142873, 0, 0.523809552, 0)
lowerPart.Size = UDim2.new(0, 156, 0, 17)
lowerPart.Font = Enum.Font.Jura
lowerPart.Text = "LowerTorso"
lowerPart.TextColor3 = Color3.fromRGB(202, 202, 202)
lowerPart.TextSize = 14.000
lowerPart.TextStrokeTransparency = 0.000

UICorner_15.CornerRadius = UDim.new(0, 4)
UICorner_15.Parent = lowerPart

UIStroke_12.Parent = lowerPart
UIStroke_12.Color = Color3.fromRGB(63, 63, 63)
UIStroke_12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

feetPart.Name = "feetPart"
feetPart.Parent = dropdownFrame
feetPart.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
feetPart.Position = UDim2.new(0.0357142873, 0, 0.742857158, 0)
feetPart.Size = UDim2.new(0, 156, 0, 17)
feetPart.Font = Enum.Font.Jura
feetPart.Text = "Feet"
feetPart.TextColor3 = Color3.fromRGB(202, 202, 202)
feetPart.TextSize = 14.000
feetPart.TextStrokeTransparency = 0.000

UICorner_16.CornerRadius = UDim.new(0, 4)
UICorner_16.Parent = feetPart

UIStroke_13.Parent = feetPart
UIStroke_13.Color = Color3.fromRGB(63, 63, 63)
UIStroke_13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

dropdown1.Name = "dropdown1"
dropdown1.Parent = F1
dropdown1.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
dropdown1.BorderSizePixel = 0
dropdown1.Position = UDim2.new(0.605885267, 0, 0.225083053, 0)
dropdown1.Size = UDim2.new(0, 168, 0, 14)
dropdown1.ZIndex = 0
dropdown1.Font = Enum.Font.Jura
dropdown1.Text = "Resolver Type"
dropdown1.TextColor3 = Color3.fromRGB(202, 202, 202)
dropdown1.TextSize = 13.000
dropdown1.TextStrokeTransparency = 0.000

UICorner_17.CornerRadius = UDim.new(0, 4)
UICorner_17.Parent = dropdown1

UIStroke_14.Parent = dropdown1
UIStroke_14.Color = Color3.fromRGB(63, 63, 63)
UIStroke_14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

dropdownFrame1.Name = "dropdownFrame1"
dropdownFrame1.Parent = F1
dropdownFrame1.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
dropdownFrame1.ClipsDescendants = true
dropdownFrame1.Position = UDim2.new(0.605885267, 0, 0.268373102, 0)
dropdownFrame1.Size = UDim2.new(0, 168, 0, 0)
dropdownFrame1.ZIndex = 0

UICorner_18.CornerRadius = UDim.new(0, 4)
UICorner_18.Parent = dropdownFrame1

UIStroke_15.Parent = dropdownFrame1
UIStroke_15.Color = Color3.fromRGB(63, 63, 63)
UIStroke_15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

Toggle4.Name = "Toggle4"
Toggle4.Parent = dropdownFrame1
Toggle4.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
Toggle4.BorderSizePixel = 0
Toggle4.Position = UDim2.new(0.0357142873, 0, 0.119594641, 0)
Toggle4.Size = UDim2.new(0, 156, 0, 17)
Toggle4.Font = Enum.Font.Jura
Toggle4.Text = "Prediction Resolver : OFF"
Toggle4.TextColor3 = Color3.fromRGB(202, 202, 202)
Toggle4.TextSize = 14.000
Toggle4.TextStrokeTransparency = 0.000

UICorner_19.CornerRadius = UDim.new(0, 4)
UICorner_19.Parent = Toggle4

UIStroke_16.Parent = Toggle4
UIStroke_16.Color = Color3.fromRGB(63, 63, 63)
UIStroke_16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

Toggle5.Name = "Toggle5"
Toggle5.Parent = dropdownFrame1
Toggle5.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
Toggle5.BorderSizePixel = 0
Toggle5.Position = UDim2.new(0.0357142873, 0, 0.574095607, 0)
Toggle5.Size = UDim2.new(0, 156, 0, 17)
Toggle5.Font = Enum.Font.Jura
Toggle5.Text = "Zero Prediction : OFF"
Toggle5.TextColor3 = Color3.fromRGB(202, 202, 202)
Toggle5.TextSize = 14.000
Toggle5.TextStrokeTransparency = 0.000

UICorner_20.CornerRadius = UDim.new(0, 4)
UICorner_20.Parent = Toggle5

UIStroke_17.Parent = Toggle5
UIStroke_17.Color = Color3.fromRGB(63, 63, 63)
UIStroke_17.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

Line1.Name = "Line1"
Line1.Parent = F1
Line1.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Line1.BorderSizePixel = 0
Line1.Position = UDim2.new(0.0831466094, 0, 0.215745464, 0)
Line1.Size = UDim2.new(0, 399, 0, 1)
Line1.ZIndex = 0

UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
UIGradient_2.Offset = Vector2.new(0, 5)
UIGradient_2.Parent = Line1

Title1.Name = "Title1"
Title1.Parent = F1
Title1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title1.BackgroundTransparency = 1.000
Title1.Position = UDim2.new(0.445616186, 0, 0.191709444, 0)
Title1.Size = UDim2.new(0, 52, 0, 6)
Title1.Font = Enum.Font.Jura
Title1.Text = "Aimlock Settings"
Title1.TextColor3 = Color3.fromRGB(202, 202, 202)
Title1.TextSize = 13.000
Title1.TextStrokeTransparency = 0.000

teamcheckText.Name = "teamcheckText"
teamcheckText.Parent = F1
teamcheckText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
teamcheckText.BackgroundTransparency = 1.000
teamcheckText.Position = UDim2.new(0.010423271, 0, 0.23374103, 0)
teamcheckText.Size = UDim2.new(0, 110, 0, 17)
teamcheckText.Font = Enum.Font.Jura
teamcheckText.Text = "Team Check"
teamcheckText.TextColor3 = Color3.fromRGB(202, 202, 202)
teamcheckText.TextSize = 14.000
teamcheckText.TextStrokeTransparency = 0.000
teamcheckText.TextXAlignment = Enum.TextXAlignment.Left

toggleFrame4.Name = "toggleFrame4"
toggleFrame4.Parent = teamcheckText
toggleFrame4.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
toggleFrame4.BorderSizePixel = 0
toggleFrame4.Position = UDim2.new(1.05547452, 0, -0.0227909125, 0)
toggleFrame4.Size = UDim2.new(0, 39, 0, 15)

UICorner_21.CornerRadius = UDim.new(0, 100)
UICorner_21.Parent = toggleFrame4

UIStroke_18.Parent = toggleFrame4
UIStroke_18.Color = Color3.fromRGB(63, 63, 63)

Toggle6.Name = "Toggle6"
Toggle6.Parent = toggleFrame4
Toggle6.BackgroundColor3 = Color3.fromRGB(202, 202, 202)
Toggle6.BorderSizePixel = 0
Toggle6.Position = UDim2.new(0.487179518, 0, -0.199999809, 0)
Toggle6.Size = UDim2.new(0, 20, 0, 20)
Toggle6.Font = Enum.Font.SourceSans
Toggle6.Text = ""
Toggle6.TextColor3 = Color3.fromRGB(0, 0, 0)
Toggle6.TextSize = 14.000

UICorner_22.CornerRadius = UDim.new(0, 100)
UICorner_22.Parent = Toggle6

-- Scripts:

local function UBJR_script() -- Title.LocalScript 
	local script = Instance.new('LocalScript', Title)

	script.Parent.Parent.Title.Text = 'renpy.cc | '..game.Players.LocalPlayer.Name
end
coroutine.wrap(UBJR_script)()
local function FENNVXH_script() -- Toggle1.LocalScript 
	local script = Instance.new('LocalScript', Toggle1)

	local aimbotToggle = false
	
	script.Parent.MouseButton1Down:Connect(function()
		if aimbotToggle == false then
			aimbotToggle = true
		else
			aimbotToggle = false
		end
		
		if aimbotToggle == true then
			Aimlock = true
			script.Parent.Parent.Toggle1.Position = UDim2.new(0, 0,-0.2, 0)
			script.Parent.Parent.Toggle1.BackgroundColor3 = Color3.fromRGB(132, 84, 213)
		end
		
		if aimbotToggle == false then
			Aimlock = false
			script.Parent.Parent.Toggle1.Position = UDim2.new(0.487, 0,-0.2, 0)
			script.Parent.Parent.Toggle1.BackgroundColor3 = Color3.fromRGB(202, 202, 202)
		end
	end)
end
coroutine.wrap(FENNVXH_script)()
local function VTQPL_script() -- Toggle2.LocalScript 
	local script = Instance.new('LocalScript', Toggle2)

	local enableprediction = false
	
	script.Parent.MouseButton1Down:Connect(function()
		if enableprediction == false then
			enableprediction = true
		else
			enableprediction = false
		end
		
		if enableprediction == true then
			PredictMovement = true
			script.Parent.Parent.Toggle2.Position = UDim2.new(0, 0,-0.2, 0)
			script.Parent.Parent.Toggle2.BackgroundColor3 = Color3.fromRGB(132, 84, 213)
		end
		
		if enableprediction == false then
			PredictMovement = false
			script.Parent.Parent.Toggle2.Position = UDim2.new(0.487, 0,-0.2, 0)
			script.Parent.Parent.Toggle2.BackgroundColor3 = Color3.fromRGB(202, 202, 202)
		end
	end)
end
coroutine.wrap(VTQPL_script)()
local function IBJBII_script() -- Toggle3.LocalScript 
	local script = Instance.new('LocalScript', Toggle3)

	local smoothToggle = false
	
	script.Parent.MouseButton1Down:Connect(function()
		if smoothToggle == false then
			smoothToggle = true
		else
			smoothToggle = false
		end
		
		if smoothToggle == true then
			Smoothness = true
			script.Parent.Parent.Toggle3.Position = UDim2.new(0, 0,-0.2, 0)
			script.Parent.Parent.Toggle3.BackgroundColor3 = Color3.fromRGB(132, 84, 213)
		end
		
		if smoothToggle == false then
			Smoothness = false
			script.Parent.Parent.Toggle3.Position = UDim2.new(0.487, 0,-0.2, 0)
			script.Parent.Parent.Toggle3.BackgroundColor3 = Color3.fromRGB(202, 202, 202)
		end
	end)
end
coroutine.wrap(IBJBII_script)()
local function ROJJJBY_script() -- predictionBox.LocalScript 
	local script = Instance.new('LocalScript', predictionBox)

	script.Parent.FocusLost:Connect(function(e)
		if e then
			PredictionVelocity = tonumber(script.Parent.Parent.predictionBox.Text)
		end
	end)
end
coroutine.wrap(ROJJJBY_script)()
local function JJFCNE_script() -- keybindBox.LocalScript 
	local script = Instance.new('LocalScript', keybindBox)

	script.Parent.FocusLost:Connect(function(e)
		if e then
			AimlockKey = script.Parent.Parent.keybindBox.Text
		end
	end)
end
coroutine.wrap(JJFCNE_script)()
local function WIAOV_script() -- smoothnessBox.LocalScript 
	local script = Instance.new('LocalScript', smoothnessBox)

	script.Parent.FocusLost:Connect(function(e)
		if e then
			SmoothnessAmount = tonumber(script.Parent.Parent.smoothnessBox.Text)
		end
	end)
end
coroutine.wrap(WIAOV_script)()
local function BKOUVR_script() -- dropdown.LocalScript 
	local script = Instance.new('LocalScript', dropdown)

	script.Parent.MouseButton1Down:Connect(function()
		if script.Parent.Parent.dropdownFrame.Size == UDim2.new(0, 168,0, 0) then
			script.Parent.Parent.dropdownFrame.Size = UDim2.new(0, 168,0, 105)
		else
			script.Parent.Parent.dropdownFrame.Size = UDim2.new(0, 168,0, 0)
		end
	end)
end
coroutine.wrap(BKOUVR_script)()
local function CIDXU_script() -- headPart.LocalScript 
	local script = Instance.new('LocalScript', headPart)

	script.Parent.MouseButton1Down:Connect(function()
		OldAimPart = "Head"
		AimPart = "Head"  
	end)
end
coroutine.wrap(CIDXU_script)()
local function CJWWZLL_script() -- torsoPart.LocalScript 
	local script = Instance.new('LocalScript', torsoPart)

	script.Parent.MouseButton1Down:Connect(function()
		OldAimPart = "HumanoidRootPart"
		AimPart = "HumanoidRootPart"  
	end)
end
coroutine.wrap(CJWWZLL_script)()
local function XOAYR_script() -- lowerPart.LocalScript 
	local script = Instance.new('LocalScript', lowerPart)

	script.Parent.MouseButton1Down:Connect(function()
		OldAimPart = "LowerTorso"
		AimPart = "LowerTorso"  
	end)
end
coroutine.wrap(XOAYR_script)()
local function GIKJSCT_script() -- feetPart.LocalScript 
	local script = Instance.new('LocalScript', feetPart)

	script.Parent.MouseButton1Down:Connect(function()
		OldAimPart = "RightFoot"
		AimPart = "RightFoot"  
	end)
end
coroutine.wrap(GIKJSCT_script)()
local function YVQH_script() -- F1.LocalScript 
	local script = Instance.new('LocalScript', F1)

	local UIS = game:GetService('UserInputService')
	local frame = script.Parent
	local dragToggle = nil
	local dragSpeed = 0.25
	local dragStart = nil
	local startPos = nil
	
	local function updateInput(input)
		local delta = input.Position - dragStart
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		game:GetService('TweenService'):Create(frame, TweenInfo.new(dragSpeed), {Position = position}):Play()
	end
	
	frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)
	
	UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end)
end
coroutine.wrap(YVQH_script)()
local function AIMLQYE_script() -- dropdown1.LocalScript 
	local script = Instance.new('LocalScript', dropdown1)

	script.Parent.MouseButton1Down:Connect(function()
		if script.Parent.Parent.dropdownFrame1.Size == UDim2.new(0, 168,0, 0) then
			script.Parent.Parent.dropdownFrame1.Size = UDim2.new(0, 168,0, 55)
		else
			script.Parent.Parent.dropdownFrame1.Size = UDim2.new(0, 168,0, 0)
		end
	end)
end
coroutine.wrap(AIMLQYE_script)()
local function GMZK_script() -- Toggle4.LocalScript 
	local script = Instance.new('LocalScript', Toggle4)

	local players = game:GetService("Players")
	local player = players.LocalPlayer
	
	script.Parent.MouseButton1Down:Connect(function()
		if script.Parent.Parent.Toggle4.Text == 'Prediction Resolver : OFF' then
			script.Parent.Parent.Toggle4.Text = 'Prediction Resolver : ON'
			game:GetService('RunService'):BindToRenderStep("PredictionResolver", 0 , function()
				for i,v in pairs(game.Players:GetChildren()) do
					if v.Name ~= game.Players.LocalPlayer.Name then
						local hrp = v.Character.HumanoidRootPart
						hrp.Velocity = v.Character.Humanoid.MoveDirection * 16
						hrp.AssemblyLinearVelocity = v.Character.Humanoid.MoveDirection * 16  
					end
				end
			end)
		else
			game:GetService('RunService'):UnbindFromRenderStep("PredictionResolver")
			script.Parent.Parent.Toggle4.Text = 'Prediction Resolver : OFF'
		end
	end)
end
coroutine.wrap(GMZK_script)()
local function YTXEFAW_script() -- Toggle5.LocalScript 
	local script = Instance.new('LocalScript', Toggle5)

	script.Parent.MouseButton1Down:Connect(function()
		if script.Parent.Parent.Toggle5.Text == 'Zero Prediction : OFF' then
			script.Parent.Parent.Toggle5.Text = 'Zero Prediction : ON'
			game:GetService('RunService'):BindToRenderStep("Zero_prediction", 0 , function()
				pcall(function()
					for i,v in pairs(game.Players:GetChildren()) do
						if v.Name ~= game.Players.LocalPlayer.Name then
							local hrp = v.Character.HumanoidRootPart
							hrp.Velocity = Vector3.new(0, 0, 0)    
							hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)   
						end
					end
				end)
			end)
		else
			game:GetService('RunService'):UnbindFromRenderStep("Zero_prediction")
			script.Parent.Parent.Toggle5.Text = 'Zero Prediction : OFF'
		end
	end)
end
coroutine.wrap(YTXEFAW_script)()
local function FXFWMZA_script() -- Toggle6.LocalScript 
	local script = Instance.new('LocalScript', Toggle6)

	local teamcheckToggle = false
	
	script.Parent.MouseButton1Down:Connect(function()
		if teamcheckToggle == false then
			teamcheckToggle = true
		else
			teamcheckToggle = false
		end
		
		if teamcheckToggle == true then
			TeamCheck = true
			script.Parent.Parent.Toggle6.Position = UDim2.new(0, 0,-0.2, 0)
			script.Parent.Parent.Toggle6.BackgroundColor3 = Color3.fromRGB(132, 84, 213)
		end
		
		if teamcheckToggle == false then
			TeamCheck = false
			script.Parent.Parent.Toggle6.Position = UDim2.new(0.487, 0,-0.2, 0)
			script.Parent.Parent.Toggle6.BackgroundColor3 = Color3.fromRGB(202, 202, 202)
		end
	end)
end
coroutine.wrap(FXFWMZA_script)()
local function FHHQEN_script() -- F1.LocalScript 
	local script = Instance.new('LocalScript', F1)

	local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
	local Toggled = true
	
	Mouse.KeyDown:Connect(function(Key)
		if Key == Settings['KeybindGui'] then
			if Toggled then
				Toggled = false
				script.Parent.Parent.F1.Visible = false
			else
				Toggled = true
				script.Parent.Parent.F1.Visible = true
			end
		end
	end)
end
coroutine.wrap(FHHQEN_script)()
