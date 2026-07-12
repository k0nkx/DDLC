-- DDLC-LOVE Roblox (Minimal Working Version)
-- Starts at Title with working menu buttons

local env = {}
getgenv().ddlc = env

local BASE = "https://raw.githubusercontent.com/k0nkx/DDLC/main/"
local DIR = "DDLC/"

-- ========== IMAGE LOADER ==========
local imgCache = {}
local function tryGCA(path)
  local ok, id = pcall(getcustomasset, path)
  if ok and type(id) == "string" and #id > 0 then return id end
  return nil
end
function loadImg(path)
  if imgCache[path] then return imgCache[path] end
  local fullpath = DIR .. "assets/" .. path
  if not isfile(fullpath) then return nil end
  local id = tryGCA(fullpath) or tryGCA(fullpath:gsub("/", "\\"))
  if id then imgCache[path] = id; return id end
  return nil
end

-- ========== GUI SETUP ==========
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local vp = workspace.CurrentCamera.ViewportSize

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DDLCGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = gui

-- Main frame (transparent)
local mainFrm = Instance.new("Frame")
mainFrm.Name = "Main"
mainFrm.BackgroundTransparency = 1
mainFrm.Size = UDim2.fromOffset(1280, 720)
mainFrm.Position = UDim2.fromScale(0.5, 0.5)
mainFrm.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrm.ClipsDescendants = true
mainFrm.Parent = screenGui

-- Helpers
local function newImg(name, pos, size, parent)
  local img = Instance.new("ImageLabel")
  img.Name = name; img.BackgroundTransparency = 1
  img.Position = pos or UDim2.fromOffset(0,0)
  img.Size = size or UDim2.fromOffset(1280, 720)
  img.Visible = false; img.Parent = parent or mainFrm
  return img
end
local function newTxt(name, pos, size, parent)
  local txt = Instance.new("TextLabel")
  txt.Name = name; txt.BackgroundTransparency = 1
  txt.Position = pos or UDim2.fromOffset(0,0)
  txt.Size = size or UDim2.fromOffset(1280, 720)
  txt.Text = ""; txt.TextColor3 = Color3.new(1,1,1)
  txt.Font = Enum.Font.GothamMedium; txt.TextSize = 20
  txt.TextXAlignment = Enum.TextXAlignment.Left
  txt.TextYAlignment = Enum.TextYAlignment.Top
  txt.Visible = false; txt.Parent = parent or mainFrm
  return txt
end
local function newFrm(name, pos, size, color, parent)
  local f = Instance.new("Frame")
  f.Name = name; f.BackgroundColor3 = color or Color3.new(0,0,0)
  f.BackgroundTransparency = 0; f.BorderSizePixel = 0
  f.Position = pos or UDim2.fromOffset(0,0)
  f.Size = size or UDim2.fromOffset(1280, 720)
  f.Visible = false; f.Parent = parent or mainFrm
  return f
end
local function newBtn(name, pos, size, text, parent)
  local b = Instance.new("TextButton")
  b.Name = name; b.BackgroundColor3 = Color3.fromRGB(40,20,60)
  b.BorderSizePixel = 2; b.BorderColor3 = Color3.fromRGB(100,50,150)
  b.Position = pos; b.Size = size
  b.Text = text; b.TextColor3 = Color3.new(1,1,1)
  b.Font = Enum.Font.GothamBold; b.TextSize = 24
  b.Visible = false; b.Parent = parent or mainFrm
  return b
end

-- Layers (ZIndex on frames)
local bgLayer = newFrm("BgLayer", UDim2.fromOffset(0,0), UDim2.fromOffset(1280,720), Color3.fromRGB(30,15,40), mainFrm)
bgLayer.Visible = true; bgLayer.ZIndex = 1
local bgImg = newImg("BgImg", UDim2.fromOffset(0,0), UDim2.fromOffset(1280,720), bgLayer); bgImg.ZIndex = 1

local cgLayer = newFrm("CgLayer", UDim2.fromOffset(0,0), UDim2.fromOffset(1280,720), Color3.new(0,0,0.5), mainFrm); cgLayer.ZIndex = 2
local cgImg = newImg("CgImg", UDim2.fromOffset(0,0), UDim2.fromOffset(1280,720), cgLayer); cgImg.ZIndex = 2

local charLayer = newFrm("CharLayer", UDim2.fromOffset(0,0), UDim2.fromOffset(1280,720), Color3.new(0,0,0), mainFrm); charLayer.ZIndex = 3
local uiLayer = newFrm("UiLayer", UDim2.fromOffset(0,0), UDim2.fromOffset(1280,720), Color3.new(0,0,0), mainFrm); uiLayer.ZIndex = 4
local fadeLayer = newFrm("FadeLayer", UDim2.fromOffset(0,0), UDim2.fromOffset(1280,720), Color3.new(0,0,0), mainFrm); fadeLayer.ZIndex = 5

local fadeImg = newImg("FadeImg", UDim2.fromOffset(0,0), UDim2.fromOffset(1280,720), fadeLayer)
fadeImg.BackgroundColor3 = Color3.new(0,0,0); fadeImg.BackgroundTransparency = 0; fadeImg.ZIndex = 5

-- UI elements
local textboxBg = newFrm("TextBoxBg", UDim2.fromOffset(0,560), UDim2.fromOffset(1280,160), Color3.new(0,0,0), uiLayer)
textboxBg.BackgroundTransparency = 0.2
local nameboxFrm = newFrm("NameBox", UDim2.fromOffset(40,520), UDim2.fromOffset(260,36), Color3.fromRGB(186,84,153), uiLayer)
local nameTxt = newTxt("NameTxt", UDim2.fromOffset(10,4), UDim2.fromOffset(240,28), nameboxFrm)
nameTxt.TextSize = 20; nameTxt.Font = Enum.Font.GothamBold
local diaTxt = newTxt("DiaTxt", UDim2.fromOffset(50,580), UDim2.fromOffset(1180,130), uiLayer)
diaTxt.TextSize = 19; diaTxt.TextWrapped = true

-- Character images
local charImgs = {}
for _, name in ipairs({"sayori","yuri","natsuki","monika"}) do
  local ci = newImg(name, UDim2.fromScale(0,0), UDim2.fromOffset(400,600), charLayer)
  ci.SizeConstraint = Enum.SizeConstraint.RelativeXX
  ci.ResampleMode = Enum.ResamplerMode.Pixelated
  charImgs[name] = ci
end

-- Title Menu Buttons
local menuLayer = newFrm("MenuLayer", UDim2.fromOffset(0,0), UDim2.fromOffset(1280,720), Color3.new(0,0,0), mainFrm)
menuLayer.ZIndex = 6; menuLayer.Visible = true

local titleLabel = newTxt("TitleLabel", UDim2.fromOffset(40,80), UDim2.fromOffset(1200,100), menuLayer)
titleLabel.Text = "DDLC-LOVE"; titleLabel.TextSize = 72; titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(255,200,100); titleLabel.Visible = true

local btnNewGame = newBtn("BtnNewGame", UDim2.fromOffset(440,250), UDim2.fromOffset(400,60), "NEW GAME", menuLayer)
btnNewGame.Visible = true
local btnLoad = newBtn("BtnLoad", UDim2.fromOffset(440,330), UDim2.fromOffset(400,60), "LOAD", menuLayer)
btnLoad.Visible = true
local btnSettings = newBtn("BtnSettings", UDim2.fromOffset(440,410), UDim2.fromOffset(400,60), "SETTINGS", menuLayer)
btnSettings.Visible = true
local btnExit = newBtn("BtnExit", UDim2.fromOffset(440,490), UDim2.fromOffset(400,60), "EXIT", menuLayer)
btnExit.Visible = true

-- Sound
local soundService = game:GetService("SoundService")
local bgmSound = Instance.new("Sound"); bgmSound.Name="DDLCBGM"; bgmSound.Volume=0.5; bgmSound.Parent=soundService
local sfxSound = Instance.new("Sound"); sfxSound.Name="DDLCSFX"; sfxSound.Volume=0.7; sfxSound.Parent=soundService

-- Game state
local state = "title"
local alpha, bg1, cl, chapter = 255, "menu_bg", 1, 0
local running = true

-- Helpers
local function showTitleMenu()
  state = "title"
  menuLayer.Visible = true
  fadeLayer.Visible = true; fadeImg.BackgroundTransparency = 0
  local id = loadImg("images/gui/menu_bg.jpg")
  if id then bgImg.Image = id; bgImg.Visible = true; bgLayer.Visible = true end
end

local function hideTitleMenu()
  menuLayer.Visible = false
  fadeLayer.Visible = true; fadeImg.BackgroundTransparency = 0
end

local function startGame()
  hideTitleMenu()
  state = "game"
  bgLayer.Visible = true; cgLayer.Visible = true; charLayer.Visible = true
  uiLayer.Visible = true; fadeLayer.Visible = true
  fadeImg.BackgroundTransparency = 1
  loadChapter(0)
end

local function loadChapter(ch)
  chapter = ch; cl = 1
  local code = loadScript("scripts/eng/script-ch"..ch..".lua")
  if code then pcall(loadstring(code)) end
  local fn = _G["ch"..ch.."script"]; if fn then pcall(fn) end
end

local function loadScript(relpath)
  local full = DIR..relpath
  if isfile(full) then return readfile(full) end
  local ok,resp = pcall(request,{Url=BASE..relpath,Method="GET"})
  if ok and resp and resp.Body then
    local parts={}; for p in relpath:gmatch("[^/]+") do table.insert(parts,p) end
    if #parts>1 then local dp=DIR; for j=1,#parts-1 do dp=dp..parts[j].."/"; if not isfolder(dp) then makefolder(dp) end end end
    writefile(full,resp.Body); return resp.Body
  end
end

local function bgUpdate(bgx)
  local id = loadImg("images/bg/"..bgx..".jpg")
  if id then bgImg.Image=id; bgImg.Visible=true; bg1=bgx else bgImg.Visible=false; bg1="black" end
end

local function cgUpdate(cgx)
  local id = loadImg("images/cg/"..cgx..".png")
  if id then cgImg.Image=id; cgImg.Visible=true end
end

local charMap = {s="sayori",n="natsuki",y="yuri",m="monika"}
function loadCharacter(chr)
  local cn = charMap[chr]; if not cn then return end
  local id = loadImg("images/"..cn.."/1l.png")
  if id then charImgs[cn].Image=id; charImgs[cn].Visible=true end
end
function hideAll() for _,img in pairs(charImgs) do img.Visible=false end end

local function say(char, text)
  local names={s="Sayori",n="Natsuki",y="Yuri",m="Monika"}
  nameTxt.Text = names[char] or char; diaTxt.Text = text
  textboxBg.Visible = true; nameboxFrm.Visible = true; nameTxt.Visible = true; diaTxt.Visible = true
end

-- Button Events
btnNewGame.MouseButton1Click:Connect(function()
  print("[DDLC] NEW GAME clicked")
  startGame()
end)
btnLoad.MouseButton1Click:Connect(function() print("Load clicked") end)
btnSettings.MouseButton1Click:Connect(function() print("Settings clicked") end)
btnExit.MouseButton1Click:Connect(function() env.stop() end)

-- Main Loop
local conn
game:GetService("RunService").RenderStepped:Connect(function(dt)
  if not running then return end
  if state == "title" and alpha > 0 then
    alpha = math.max(alpha - 5*dt*60, 0)
    fadeImg.BackgroundTransparency = alpha/255
  end
end)

-- Input
game:GetService("UserInputService").InputBegan:Connect(function(inp, gpe)
  if gpe or not running then return end
  if inp.KeyCode == Enum.KeyCode.Escape then env.stop() end
  if inp.KeyCode == Enum.KeyCode.Space or inp.KeyCode == Enum.KeyCode.Return then
    if state == "title" then startGame()
    elseif state == "game" then print("Advance") end
  end
end)

function env.start()
  print("[DDLC] Starting...")
  showTitleMenu()
  task.spawn(function()
    local ok,resp = pcall(request,{Url=BASE.."scripts/eng/text.lua",Method="GET"})
    if ok and resp and resp.Body then
      local p=DIR.."scripts/eng/text.lua"; writefile(p,resp.Body); pcall(loadstring(resp.Body))
    end
  end)
end

function env.stop()
  running = false
  for _,g in pairs(gui:GetChildren()) do if g.Name:match("DDLC") then g:Destroy() end end
end

print("DDLC-LOVE loaded! Run: ddlc.start()")