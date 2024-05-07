local function Aim()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function findNearestPlayer()
    local nearestPlayer = nil
    local nearestDistance = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestPlayer = player.Character.HumanoidRootPart.Position
            end
        end
    end
    
    return nearestPlayer
end

local function aimTowardsNearestPlayer()
    local nearestPlayerPos = findNearestPlayer()
    if nearestPlayerPos then
        local direction = (nearestPlayerPos - LocalPlayer.Character.HumanoidRootPart.Position).unit
        LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, LocalPlayer.Character.HumanoidRootPart.Position + direction))
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        aimTowardsNearestPlayer()
    end
end)
end

local function InfJump()
    _G.infinjump = not _G.infinjump

if _G.infinJumpStarted == nil then
	_G.infinJumpStarted = true
	
	game.StarterGui:SetCore("SendNotification", {Title="|  By Zexus  |"; Text="$ Infinite Jump $"; Duration=5;})

	local plr = game:GetService('Players').LocalPlayer
	local m = plr:GetMouse()
	m.KeyDown:connect(function(k)
		if _G.infinjump then
			if k:byte() == 32 then
			humanoid = game:GetService'Players'.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
			humanoid:ChangeState('Jumping')
			wait()
			humanoid:ChangeState('Seated')
			end
		end
	end)
end
end

local function Tracer()
    local lplr = game.Players.LocalPlayer
    local camera = game.Workspace.CurrentCamera
    
    _G.TeamCheck = false
    
    local function CreateTracer(player, isLocalPlayer)
        local Tracer = Drawing.new("Line")
        Tracer.Color = Color3.new(0.333333, 0.047059, 0.372549)
        Tracer.Thickness = 2
        Tracer.Transparency = 0.5
    
        local function UpdateTracer()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local position = rootPart.Position
                local _, onScreen = camera:WorldToViewportPoint(position)
    
                if onScreen then
                    local screenPosition = camera:WorldToViewportPoint(position)
                    Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    Tracer.To = Vector2.new(screenPosition.X, screenPosition.Y)
                    Tracer.Visible = true
                else
                    Tracer.Visible = false
                end
            else
                Tracer.Visible = false
            end
        end
    
        UpdateTracer()
        game:GetService("RunService").RenderStepped:Connect(UpdateTracer)
    
        return Tracer
    end
    
    local localPlayerTracer = CreateTracer(lplr, true)
    
    -- Создаем обводку для других игроков
    local otherPlayerTracers = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= lplr then
            otherPlayerTracers[player] = CreateTracer(player, false)
        end
    end
    
    game:GetService("RunService").RenderStepped:Connect(function()
        for player, tracer in pairs(otherPlayerTracers) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local position = rootPart.Position
                local _, onScreen = camera:WorldToViewportPoint(position)
    
                if onScreen then
                    local screenPosition = camera:WorldToViewportPoint(position)
                    local distance = (screenPosition - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)).Magnitude
                    if distance < 300 then
                        tracer.Visible = true
                    else
                        tracer.Visible = false
                    end
                else
                    tracer.Visible = false
                end
            else
                tracer.Visible = false
            end
        end
    end)
    
    game.Players.PlayerAdded:Connect(function(player)
        if player ~= lplr then
            otherPlayerTracers[player] = CreateTracer(player, false)
        end
    end)
    
    game.Players.PlayerRemoving:Connect(function(player)
        if otherPlayerTracers[player] then
            otherPlayerTracers[player]:Remove()
            otherPlayerTracers[player] = nil
        end
    end)
end

Tracer()
InfJump()
Aim()
