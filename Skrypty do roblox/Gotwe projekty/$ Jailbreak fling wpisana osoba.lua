players = game:GetService("Players")
lp = players.LocalPlayer
heli = lp.Character.HumanoidRootPart.Weld.Part1.Parent
grabber = heli.Preset.RopePull
car = grabber.BallSocketConstraint.Attachment1.Parent

grabber.CanCollide = false

for i,v in pairs(car.Parent:GetDescendants()) do
	if v:IsA("BasePart") then
		v.CanCollide = false
	end
end

-- Wprowadź nazwę gracza, którego chcesz obserwować.
playerName = "NazwaGracza"

targetPlayer = players:FindFirstChild(playerName)
if targetPlayer then
	target = targetPlayer.Character:WaitForChild("HumanoidRootPart")
else
	print("Nie znaleziono gracza o nazwie " .. playerName)
	return
end

speed = 15
range = 100
LastPosition = target.Position
c = game:GetService("RunService").Heartbeat:Connect(function()

	if math.floor(LastPosition.X*100) == math.floor(target.Position.X*100) and math.floor(LastPosition.Y*100) == math.floor(target.Position.Y*100) and math.floor(LastPosition.Z*100) == math.floor(target.Position.Z*100) then do
			car.CFrame = target.CFrame
		end else
		local BackAndForth = math.sin(tick()*speed)*range/2+range/2
		car.CFrame = target.CFrame + CFrame.lookAt(LastPosition, target.Position).LookVector*BackAndForth
	end
	
	LastPosition = target.Position
	
	car.Velocity = Vector3.new(0,1000,0)
	for i,v in pairs(heli:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Velocity = Vector3.new(0,0,0)
		end
	end
	
	grabber.CFrame = heli.BoundingBox.CFrame
end)

workspace.CurrentCamera.CameraSubject = targetPlayer.Character.Humanoid -- Obserwuj wybranego gracza.

while car:FindFirstAncestorOfClass("Workspace") and lp.Character.Humanoid.Health ~= 0 do
task.wait()
end

c:Disconnect()
workspace.CurrentCamera.CameraSubject = lp.Character.Humanoid -- Wróć do obserwowania oryginalnego gracza.
