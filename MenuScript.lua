--Connected Discord-GitHub
-----------------------------------------Configs---------------------------------------
local loadingImageIDs = {
	{
		["ImageID"] = 12601114424,
		["Title"] = "Image",
		["Caption"] = "An Image"
	},
	{
		["ImageID"] = 6403436054,
		["Title"] = "Rick Astley",
		["Caption"] = "Get rickrolled lol"
	}
}

local tips = {
	"This is the 1st tip. Isn't that cool?",
	"This is the 2nd tip, this thing can choose randomised tips.",
	"This is the 3rd tip, I don't have anything more to say.",
	"I forgot which tip this is, deal with it."
}

local cameraMovementScale = 100 --Lower values mean more movement

local imagePrefix = "http://www.roblox.com/asset/?id="

-----------------------------------------Services--------------------------------------
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local contentProvider = game:GetService("ContentProvider")
local players = game:GetService("Players")
local replicatedFirst = game:GetService("ReplicatedFirst")
local starterGui = game:GetService("StarterGui")

local buttonEffects = require(script:WaitForChild("ButtonEffects"))


-----------------------------------------Variables-------------------------------------
local localPlayer = players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local gui = script:WaitForChild("StartupGui")
gui.Parent = playerGui
local sounds = gui:WaitForChild("Sounds")
local cameraParts = script:WaitForChild("CameraParts")
local cameraLook = cameraParts:WaitForChild("CameraLook")
local cameraPosition = cameraParts:WaitForChild("CameraPosition")
local backgroundDark = gui:WaitForChild("BackgroundDark")
local loadingScreen = gui:WaitForChild("LoadingScreen")
local loadingTips = loadingScreen:WaitForChild("Tips")
local loadingBarArea = loadingScreen:WaitForChild("LoadingBarArea")
local loadingBarSpinnyImage = loadingBarArea:WaitForChild("ImageLabel")
local loadingBar = loadingBarArea:WaitForChild("LoadingBar")
local loadingFilled = loadingBar:WaitForChild("LoadingFilled")
local imageArea = loadingScreen:WaitForChild("ImageArea")
local skipHolder = imageArea:WaitForChild("SkipHolder")
local skipButton = skipHolder:WaitForChild("SkipButton")
local loadingImage1 = imageArea:WaitForChild("LoadingImage1")
local loadingImage2 = imageArea:WaitForChild("LoadingImage2")
local imageCaptions = imageArea:WaitForChild("ImageCaptions")
local imageTitle = imageCaptions:WaitForChild("Title")
local imageCaption = imageCaptions:WaitForChild("Caption")
local mainMenuStuff = gui:WaitForChild("MainMenuStuff")
local creditsHolder = mainMenuStuff:WaitForChild("CreditsHolder")
local creditsButton = creditsHolder:WaitForChild("Button")
local playHolder = mainMenuStuff:WaitForChild("PlayHolder")
local playButton = playHolder:WaitForChild("Button")
local settingsHolder = mainMenuStuff:WaitForChild("SettingsHolder")
local settingsButton = settingsHolder:WaitForChild("Button")
local playLoadingScreen = gui:WaitForChild("PlayLoading")
local spinnyImage2 = playLoadingScreen:WaitForChild("SpinnyImage2")
local settingsWindow = gui:WaitForChild("SettingsWindow")
local creditsWindow = gui:WaitForChild("CreditsWindow")
local screenDark = gui:WaitForChild("ScreenDark")





-------------------------------------------Main----------------------------------------
local imagesToLoad = {}
for i, v in loadingImageIDs do
	imagesToLoad[i] = imagePrefix..loadingImageIDs[i].ImageID
end

local spinnyImageTween = tweenService:Create(loadingBarSpinnyImage, TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut, 10000, false, 0), {["Rotation"] = 720})
local imageFadeOutTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)
local imageMovementTweenInfo = TweenInfo.new(10, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)
local transparencyTable = {["ImageTransparency"] = 1}
local image1FadeOut = tweenService:Create(loadingImage1, imageFadeOutTweenInfo, transparencyTable)
local image2FadeOut = tweenService:Create(loadingImage2, imageFadeOutTweenInfo, transparencyTable)
local image1Move = tweenService:Create(loadingImage1, imageMovementTweenInfo, {["Position"] = UDim2.new(0, 0, 0, 0)})
local image2Move = tweenService:Create(loadingImage2, imageMovementTweenInfo, {["Position"] = UDim2.new(-0.1, 0, 0, 0)})

contentProvider:PreloadAsync(imagesToLoad)

replicatedFirst:RemoveDefaultLoadingScreen()

local workspaceLoadables = workspace:GetDescendants()
local guiLoadables = playerGui:GetDescendants()

local allLoadables = {}
for i, v in ipairs(workspaceLoadables) do
	table.insert(allLoadables, workspaceLoadables[i])
end

for i, v in ipairs(guiLoadables) do
	table.insert(allLoadables, guiLoadables[i])
end

local totalAssets = #allLoadables
local assetsLoaded = 0

loadingFilled.Size = UDim2.new(0, 0, 1, 0)


camera.CameraType = Enum.CameraType.Scriptable
local cameraSubject = Instance.new("Part")
cameraSubject.Transparency = 1
cameraSubject.Anchored = true
cameraSubject.CanCollide = false
cameraSubject.Position = cameraPosition.Position
cameraSubject.Parent = workspace
camera.CameraSubject = cameraSubject
camera.CFrame = CFrame.lookAt(cameraPosition.Position, cameraLook.Position)

local loadingBarThread = coroutine.create(function()
	for i = 1, #allLoadables do
		pcall(function()
			contentProvider:PreloadAsync({allLoadables[i]})
		end)
		assetsLoaded = i
		loadingFilled.Size = UDim2.new(assetsLoaded / totalAssets, 0, 1, 0)
	end
end)

local tipsThread = coroutine.create(function()
	while true do
		local num = math.random(1, #tips)
		loadingTips.Text = tips[num]
		task.wait(7)
	end
end)

local imageThread = coroutine.create(function()
	local prevImage
	while true do
		local num = math.random(1, #loadingImageIDs)
		while num == prevImage do
			num = math.random(1, #loadingImageIDs)
		end
		prevImage = num
		loadingImage1.Image = imagePrefix..loadingImageIDs[num].ImageID
		imageTitle.Text = loadingImageIDs[num].Title
		imageCaption.Text = loadingImageIDs[num].Caption
		loadingImage1.ImageTransparency = 0
		image1Move:Play()
		task.wait(1)
		imageTitle.Text = loadingImageIDs[num].Title
		imageCaption.Text = loadingImageIDs[num].Caption
		loadingImage2.ZIndex = 1
		task.wait(8)
		local num = math.random(1, #loadingImageIDs)
		while num == prevImage do
			num = math.random(1, #loadingImageIDs)
		end
		prevImage = num
		loadingImage2.Image = imagePrefix..loadingImageIDs[num].ImageID
		loadingImage2.ImageTransparency = 0
		loadingImage2.Position = UDim2.new(0, 0, 0, 0)
		image2Move:Play()
		image1FadeOut:Play()
		task.wait(1)
		imageTitle.Text = loadingImageIDs[num].Title
		imageCaption.Text = loadingImageIDs[num].Caption
		loadingImage1.Position = UDim2.new(-0.1, 0, 0, 0)
		loadingImage2.ZIndex = 6
		task.wait(8)
		image2FadeOut:Play()
	end
end)
starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
--Initiate
sounds.waveSFX:Play()
sounds.rainSFX:Play()
loadingScreen.Visible = true
spinnyImageTween:Play()
coroutine.resume(loadingBarThread)
coroutine.resume(tipsThread)
coroutine.resume(imageThread)

local screenDarkenTween = tweenService:Create(screenDark, TweenInfo.new(2, Enum.EasingStyle.Linear), {["BackgroundTransparency"] = 0})
local screenLightenTween = tweenService:Create(screenDark, TweenInfo.new(2, Enum.EasingStyle.Linear), {["BackgroundTransparency"] = 1})
local skipAppearTween = tweenService:Create(skipButton, TweenInfo.new(1, Enum.EasingStyle.Linear), {["BackgroundTransparency"] = 0, ["TextTransparency"] = 0})

local loadingComplete = false

task.delay(15, function()
	skipButton.Visible = true
	skipButton.BackgroundTransparency = 1
	skipButton.TextTransparency = 1
	skipAppearTween:Play()
	skipButton.Activated:Connect(function()
		loadingComplete = true
		skipButton.Visible = false
	end)
end)

local startTime = os.time()

while not loadingComplete do
	if assetsLoaded >= totalAssets then -- and (os.time() - startTime) > 30
		loadingComplete = true
	end
	task.wait(1)
end

--Terminate loading sequence
sounds.NotiSFX:Play()
screenDarkenTween:Play()
task.wait(2)
coroutine.close(loadingBarThread)
coroutine.close(tipsThread)
coroutine.close(imageThread)
loadingScreen:Destroy()
screenLightenTween:Play()
sounds.ThemeSFX:Play()

--Loading Screen: TERMINATED
--ok now what

buttonEffects.RegularEffects.AllEffects(playHolder)
buttonEffects.RegularEffects.AllEffects(settingsHolder)
buttonEffects.RegularEffects.AllEffects(creditsHolder)

local currentWindow = nil

local settingsWindowInTween = tweenService:Create(settingsWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {["GroupTransparency"] = 0, ["Position"] = UDim2.new(0.9, 0, 0.5, 0)})
local settingsWindowOutTween = tweenService:Create(settingsWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {["GroupTransparency"] = 1, ["Position"] = UDim2.new(0.9, 0, 0.4, 0)})
local creditsWindowInTween = tweenService:Create(creditsWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {["GroupTransparency"] = 0, ["Position"] = UDim2.new(0.9, 0, 0.5, 0)})
local creditsWindowOutTween = tweenService:Create(creditsWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {["GroupTransparency"] = 1, ["Position"] = UDim2.new(0.9, 0, 0.4, 0)})

settingsButton.MouseButton1Up:Connect(function()
	sounds.clickSFX:Play()
	if currentWindow == nil then
		currentWindow = "Settings"
		settingsWindow.Visible = true
		settingsWindowInTween:Play()
	elseif currentWindow == "Settings" then
		currentWindow = nil
		settingsWindowOutTween:Play()
		settingsWindowOutTween.Completed:Wait()
		if currentWindow ~= "Settings" then
			settingsWindow.Visible = false
		end
	elseif currentWindow == "Credits" then
		currentWindow = "Settings"
		creditsWindowOutTween:Play()
		settingsWindow.Visible = true
		settingsWindowInTween:Play()
		creditsWindowOutTween.Completed:Wait()
		if currentWindow ~= "Credits" then
			creditsWindow.Visible = false
		end
	end
end)

creditsButton.MouseButton1Up:Connect(function()
	sounds.clickSFX:Play()
	if currentWindow == nil then
		currentWindow = "Credits"
		creditsWindow.Visible = true
		creditsWindowInTween:Play()
	elseif currentWindow == "Credits" then
		currentWindow = nil
		creditsWindowOutTween:Play()
		creditsWindowOutTween.Completed:Wait()
		if currentWindow ~= "Credits" then
			creditsWindow.Visible = false
		end
	elseif currentWindow == "Settings" then
		currentWindow = "Credits"
		settingsWindowOutTween:Play()
		creditsWindow.Visible = true
		creditsWindowInTween:Play()
		settingsWindowOutTween.Completed:Wait()
		if currentWindow ~= "Settings" then
			settingsWindow.Visible = false
		end
	end
end)

settingsButton.MouseEnter:Connect(function()
	sounds.hoverSFX:Play()
end)
creditsButton.MouseEnter:Connect(function()
	sounds.hoverSFX:Play()
end)
playButton.MouseEnter:Connect(function()
	sounds.hoverSFX:Play()
end)

local mouse = localPlayer:GetMouse()
local defaultCFrame = camera.CFrame

local cameraPanConnection = runService.Heartbeat:Connect(function()
	local Center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
	local MoveVector = Vector3.new((mouse.X-Center.X), (mouse.Y-Center.Y), 0) / cameraMovementScale
	camera.CFrame = defaultCFrame * CFrame.Angles(math.rad(-MoveVector.Y), math.rad(-MoveVector.X), math.rad(MoveVector.Z))
end)


local spinnyImage2Tween = tweenService:Create(spinnyImage2, TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut, 10000, false, 0), {["Rotation"] = 720})
local playLoadingStart = tweenService:Create(playLoadingScreen, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {["GroupTransparency"] = 0})
local playLoadingEnd = tweenService:Create(playLoadingScreen, TweenInfo.new(3, Enum.EasingStyle.Linear), {["GroupTransparency"] = 1})

local loadingScreenFinished = false

task.spawn(function()
	while not loadingScreenFinished do
		sounds.boatSFX:Play()
		sounds.boatSFX.Ended:Wait()
		task.wait(math.random(15, 30))
	end
end)

local soundFadeTweenInfo = TweenInfo.new(6, Enum.EasingStyle.Linear)
function fadeSounds()
	local themeFade = tweenService:Create(sounds.ThemeSFX, soundFadeTweenInfo, {["Volume"] = 0})
	local boatFade = tweenService:Create(sounds.boatSFX, soundFadeTweenInfo, {["Volume"] = 0})
	local rainFade = tweenService:Create(sounds.rainSFX, soundFadeTweenInfo, {["Volume"] = 0})
	local wavesFade = tweenService:Create(sounds.waveSFX, soundFadeTweenInfo, {["Volume"] = 0})
	themeFade:Play()
	boatFade:Play()
	rainFade:Play()
	wavesFade:Play()
	wavesFade.Completed:Wait()
	sounds:Destroy() -- :)
end

playButton.MouseButton1Up:Connect(function()
	loadingScreenFinished = true
	playButton.Active = false
	sounds.BoomSFX:Play()
	playLoadingStart:Play()
	spinnyImage2Tween:Play()
	cameraPanConnection:Disconnect()
	task.wait(3)
	sounds.afterSFX:Play()
	task.wait(7)
	camera.CameraType = Enum.CameraType.Custom
	camera.CameraSubject = localPlayer.Character.Humanoid
	sounds.spawnSFX:Play()
	--Happy time :)
	settingsWindow:Destroy()
	creditsWindow:Destroy()
	backgroundDark:Destroy()
	screenDark:Destroy()
	mainMenuStuff:Destroy()
	playLoadingEnd:Play()
	starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
	starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
	starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
	fadeSounds()
end)


