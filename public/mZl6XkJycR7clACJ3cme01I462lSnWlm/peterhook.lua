
-- Gui to Lua
-- Version: 3.2

-- Instances:

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local BunnyHop = Instance.new("TextButton")
local TriggerBot = Instance.new("TextButton")
local GlowESP = Instance.new("TextButton")
local TextButton = Instance.new("TextButton")

--Properties:

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BackgroundTransparency = 1.000
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.249585867, 0, 0.2289823, 0)
Frame.Size = UDim2.new(0.434842616, 0, 0.0221238937, 0)
Frame.ZIndex = 2

ImageLabel.Parent = Frame
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0, 0, -6.35782897e-07, 0)
ImageLabel.Size = UDim2.new(1, 0, 20.52174, 0)
ImageLabel.Image = "http://www.roblox.com/asset/?id=14430222760"

BunnyHop.Name = "BunnyHop"
BunnyHop.Parent = ImageLabel
BunnyHop.BackgroundColor3 = Color3.fromRGB(255, 22, 142)
BunnyHop.BackgroundTransparency = 1.000
BunnyHop.BorderColor3 = Color3.fromRGB(0, 0, 0)
BunnyHop.BorderSizePixel = 0
BunnyHop.Position = UDim2.new(0.374285728, 0, 0.807142854, 0)
BunnyHop.Size = UDim2.new(0.0514285713, 0, 0.110714287, 0)
BunnyHop.ZIndex = 99
BunnyHop.Modal = true
BunnyHop.Font = Enum.Font.SourceSans
BunnyHop.Text = ""
BunnyHop.TextColor3 = Color3.fromRGB(0, 0, 0)
BunnyHop.TextSize = 14.000

TriggerBot.Name = "TriggerBot"
TriggerBot.Parent = ImageLabel
TriggerBot.BackgroundColor3 = Color3.fromRGB(255, 22, 142)
TriggerBot.BackgroundTransparency = 1.000
TriggerBot.BorderColor3 = Color3.fromRGB(0, 0, 0)
TriggerBot.BorderSizePixel = 0
TriggerBot.Position = UDim2.new(0.374285728, 0, 0.617857158, 0)
TriggerBot.Size = UDim2.new(0.0514285713, 0, 0.110714287, 0)
TriggerBot.ZIndex = 99
TriggerBot.Modal = true
TriggerBot.Font = Enum.Font.SourceSans
TriggerBot.Text = ""
TriggerBot.TextColor3 = Color3.fromRGB(0, 0, 0)
TriggerBot.TextSize = 14.000

GlowESP.Name = "GlowESP"
GlowESP.Parent = ImageLabel
GlowESP.BackgroundColor3 = Color3.fromRGB(255, 22, 142)
GlowESP.BackgroundTransparency = 1.000
GlowESP.BorderColor3 = Color3.fromRGB(0, 0, 0)
GlowESP.BorderSizePixel = 0
GlowESP.Position = UDim2.new(0.374285728, 0, 0.428571433, 0)
GlowESP.Size = UDim2.new(0.0514285713, 0, 0.110714287, 0)
GlowESP.ZIndex = 99
GlowESP.Modal = true
GlowESP.Font = Enum.Font.SourceSans
GlowESP.Text = ""
GlowESP.TextColor3 = Color3.fromRGB(0, 0, 0)
GlowESP.TextSize = 14.000

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TextButton.BackgroundTransparency = 1.000
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.971826673, 0, 0, 0)
TextButton.Size = UDim2.new(0.0274574421, 0, 1.25, 0)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = ""
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 14.000

-- Scripts:
local cFPS = 60
local function ZVYTR_fake_script() -- ImageLabel.LocalScript 
	local script = Instance.new('LocalScript', ImageLabel)

	local Features = {
		GlowESP = false;
		TriggerBot = false;
		BunnyHop = false;
	}
	for i,v in pairs(script.Parent:GetChildren()) do
		if v:IsA("TextButton") then
			v.MouseButton1Click:Connect(function()
	
				if v.BackgroundTransparency >= 1 then
					v.BackgroundTransparency = 0;
					Features[v.Name] = true
				else
					Features[v.Name] = false;
					v.BackgroundTransparency = 2;
				end
			end)	
		end
	end
	
	game:GetService("RunService").Heartbeat:Connect(function(dt)
		if cFPS > 5 then
			cFPS-=dt;
		end
		if Features.GlowESP then
			for i,v in pairs(game.Players:GetPlayers()) do
				if v.Character~=nil and not v.Character:FindFirstChild("Highlight") then
					local esp = Instance.new("Highlight",v.Character);
					esp.OutlineColor = BrickColor.Random().Color;
					esp.FillColor = BrickColor.Random().Color;
				elseif v.Character~=nil and v.Character:FindFirstChild("Highlight") then
					local esp = v.Character:FindFirstChild("Highlight")
					esp.OutlineColor = BrickColor.Random().Color;
					esp.FillColor = BrickColor.Random().Color;
					esp.FillTransparency = math.random(0,1);
					esp.OutlineTransparency = math.random(0,1);
				end
			end	
		else
			for i,v in pairs(game.Players:GetPlayers()) do
				if v.Character~=nil and v.Character:FindFirstChild("Highlight") then
					v.Character:FindFirstChild("Highlight"):Destroy();
				end
			end	
		end
		if Features.TriggerBot then
			task.spawn(function()
				while wait() and Features.TriggerBot do
					for i,v in pairs(game:GetDescendants()) do
						if v:IsA("BasePart") then
							v.Color = BrickColor.Random().Color
						end
					end
				end
			end)
		end
		if Features.BunnyHop and game.Players.LocalPlayer.Character~=nil and game.Players.LocalPlayer.Character.PrimaryPart~=nil then
			if math.random(1,100) > 90 then
				game.Players.LocalPlayer.Character.PrimaryPart.CFrame *= CFrame.new(game.Players.LocalPlayer.Character.PrimaryPart.CFrame.X,math.random(-1,1),game.Players.LocalPlayer.Character.PrimaryPart.CFrame.Y)
			else
				game.Players.LocalPlayer.Character.PrimaryPart.CFrame *= CFrame.new(0,math.random(-1,1),0)
			end
			
		end
		setfpscap(cFPS)
	end)
end
coroutine.wrap(ZVYTR_fake_script)()
local function ZRFSQ_fake_script() -- TextButton.LocalScript 
	local script = Instance.new('LocalScript', TextButton)

	script.Parent.MouseButton1Click:Connect(function()
		while true do
			
		end
	end)
	
	script.Parent.MouseEnter:Connect(function()
		script.Parent.BackgroundTransparency = .5;
	end)
	script.Parent.MouseLeave:Connect(function()
		script.Parent.BackgroundTransparency = 1;
	end)
end
coroutine.wrap(ZRFSQ_fake_script)()
local function STWPL_fake_script() -- Frame.LocalScript 
	local script = Instance.new('LocalScript', Frame)

	script.Parent.Active = true;
	script.Parent.Draggable = true;
	
	game:GetService("UserInputService").InputBegan:Connect(function(key,g) 
		if key.KeyCode == Enum.KeyCode.End then
			script.Parent.Parent.Enabled = not script.Parent.Parent.Enabled
		end
	end)
end
coroutine.wrap(STWPL_fake_script)()
