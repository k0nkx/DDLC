--[[
  DDLC-LOVE for Roblox Executor - Complete Game Conversion
  Xeno v1.3.55 | Instance-based, PlayerGui only
  Assets downloaded from GitHub to DDLC/ folder
  Auto-starts on execution
]]

local env = {}
getgenv().ddlc = env

-- CONFIG
local BASE = "https://raw.githubusercontent.com/k0nkx/DDLC/main/"
local DIR = "DDLC/"
local VERSION = "v1.2.2"
local assetsToDownload = {}

-- ASSET CACHE
local imgCache = {}
local audioCache = {}
local scriptCache = {}

-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local ss = game:GetService("SoundService")

-- ============================================================
-- ASSET MANAGER
-- ============================================================

local function ensureDir(relpath)
  local parts = {}
  for p in relpath:gmatch("[^/]+") do table.insert(parts, p) end
  local dp = DIR
  for i = 1, #parts - 1 do
    dp = dp .. parts[i] .. "/"
    if not isfolder(dp) then
      makefolder(dp)
      print("[DDLC-DL] Created folder: " .. dp)
    end
  end
end

function env.downloadFile(relpath)
  local full = DIR .. relpath
  if isfile(full) then return full end
  local ok, resp = pcall(request, { Url = BASE .. relpath, Method = "GET" })
  if ok and resp and resp.Body then
    ensureDir(relpath)
    writefile(full, resp.Body)
    print("[DDLC-DL] " .. relpath)
    return full
  end
  return nil
end

function env.loadImg(path)
  if imgCache[path] then return imgCache[path] end
  local ap = "assets/" .. path
  local full = env.downloadFile(ap)
  if not full then return nil end
  local ok, id = pcall(getcustomasset, full)
  if ok and id and type(id) == "string" and #id > 0 then
    imgCache[path] = id
    return id
  end
  return nil
end

function env.loadAudio(path)
  if audioCache[path] then return audioCache[path] end
  local ap = "assets/" .. path
  local full = env.downloadFile(ap)
  if not full then return nil end
  local ok, id = pcall(getcustomasset, full)
  if ok and id then
    audioCache[path] = id
    return id
  end
  return nil
end

function env.loadScript(relpath)
  if scriptCache[relpath] then return scriptCache[relpath] end
  local full = DIR .. relpath
  if isfile(full) then
    local code = readfile(full)
    scriptCache[relpath] = code
    return code
  end
  local ok, resp = pcall(request, { Url = BASE .. relpath, Method = "GET" })
  if ok and resp and resp.Body then
    ensureDir(relpath)
    writefile(full, resp.Body)
    print("[DDLC-DL] " .. relpath)
    scriptCache[relpath] = resp.Body
    return resp.Body
  end
  return nil
end

-- ============================================================
-- UI SETUP
-- ============================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DDLCGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = gui

local mainFrm = Instance.new("Frame")
mainFrm.Name = "Main"
mainFrm.BackgroundTransparency = 1
mainFrm.Size = UDim2.fromOffset(1280, 720)
mainFrm.Position = UDim2.fromScale(0.5, 0.5)
mainFrm.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrm.ClipsDescendants = true
mainFrm.Parent = screenGui

local function newFrm(n, pos, size, color, parent, z)
  local f = Instance.new("Frame")
  f.Name = n; f.BackgroundColor3 = color or Color3.new(0,0,0)
  f.BackgroundTransparency = 0; f.BorderSizePixel = 0
  f.Position = pos or UDim2.fromOffset(0,0)
  f.Size = size or UDim2.fromOffset(1280,720)
  f.Visible = false; f.Parent = parent or mainFrm
  if z then f.ZIndex = z end
  return f
end
local function newImg(n, pos, size, parent, z)
  local i = Instance.new("ImageLabel")
  i.Name = n; i.BackgroundTransparency = 1
  i.Position = pos or UDim2.fromOffset(0,0)
  i.Size = size or UDim2.fromOffset(1280,720)
  i.Visible = false; i.Parent = parent or mainFrm
  if z then i.ZIndex = z end
  return i
end
local function newTxt(n, pos, size, parent, z)
  local t = Instance.new("TextLabel")
  t.Name = n; t.BackgroundTransparency = 1
  t.Position = pos or UDim2.fromOffset(0,0)
  t.Size = size or UDim2.fromOffset(1280,720)
  t.Text = ""; t.TextColor3 = Color3.new(1,1,1)
  t.Font = Enum.Font.GothamMedium; t.TextSize = 20
  t.TextXAlignment = Enum.TextXAlignment.Left
  t.TextYAlignment = Enum.TextYAlignment.Top
  t.Visible = false; t.Parent = parent or mainFrm
  if z then t.ZIndex = z end
  return t
end
local function newBtn(n, pos, size, text, col1, col2, parent, z)
  local b = Instance.new("TextButton")
  b.Name = n; b.BackgroundColor3 = col1 or Color3.fromRGB(40,20,60)
  b.BorderSizePixel = 2; b.BorderColor3 = col2 or Color3.fromRGB(100,50,150)
  b.Position = pos; b.Size = size
  b.Text = text or ""; b.TextColor3 = Color3.new(1,1,1)
  b.Font = Enum.Font.GothamBold; b.TextSize = 24
  b.Visible = false; b.Parent = parent or mainFrm
  if z then b.ZIndex = z end
  return b
end

-- LAYERS (ZIndex)
local bgLayer = newFrm("BgLayer", nil, nil, Color3.new(0,0,0), mainFrm, 1)
bgLayer.Visible = true
local bgImg = newImg("BgImg", nil, nil, bgLayer, 1)
local bgFade = newFrm("BgFade", nil, nil, Color3.new(0,0,0), bgLayer, 1)
bgFade.BackgroundTransparency = 1

local cgLayer = newFrm("CgLayer", nil, nil, Color3.new(0,0,0), mainFrm, 2)
cgLayer.BackgroundTransparency = 1
local cgImg = newImg("CgImg", nil, nil, cgLayer, 2)

local charLayer = newFrm("CharLayer", nil, nil, Color3.new(0,0,0), mainFrm, 3)
charLayer.BackgroundTransparency = 1
charLayer.Visible = true
local charImgs = {}
for _, nm in ipairs({"sayori","yuri","natsuki","monika"}) do
  local ci = newImg(nm, UDim2.fromOffset(0,60), UDim2.fromOffset(500,600), charLayer, 3)
  ci.SizeConstraint = Enum.SizeConstraint.RelativeXX
  ci.ResampleMode = Enum.ResamplerMode.Pixelated
  charImgs[nm] = ci
end

local uiLayer = newFrm("UiLayer", nil, nil, Color3.new(0,0,0), mainFrm, 4)
uiLayer.BackgroundTransparency = 1
uiLayer.Visible = true

local fadeLayer = newFrm("FadeLayer", nil, nil, Color3.new(0,0,0), mainFrm, 5)
fadeLayer.BackgroundTransparency = 1
local fadeImg = newImg("FadeImg", nil, nil, fadeLayer, 5)
fadeImg.BackgroundColor3 = Color3.new(0,0,0); fadeImg.BackgroundTransparency = 1

local menuLayer = newFrm("MenuLayer", nil, nil, Color3.new(0,0,0), mainFrm, 6)

-- LOADING
local loadingLabel = newTxt("LoadingLabel", UDim2.fromOffset(0,300), UDim2.fromOffset(1280,100), mainFrm)
loadingLabel.Text = "DDLC-LOVE Loading..."
loadingLabel.TextSize = 36; loadingLabel.Font = Enum.Font.GothamBold
loadingLabel.TextColor3 = Color3.fromRGB(255,200,100); loadingLabel.Visible = true
loadingLabel.TextXAlignment = Enum.TextXAlignment.Center

-- TEXTBOX
local textboxBg = newFrm("TextBoxBg", UDim2.fromOffset(0,560), UDim2.fromOffset(1280,160), Color3.new(0,0,0), uiLayer)
textboxBg.BackgroundTransparency = 0.2
local nameboxFrm = newFrm("NameBox", UDim2.fromOffset(40,520), UDim2.fromOffset(260,36), Color3.fromRGB(186,84,153), uiLayer)
local nameTxt = newTxt("NameTxt", UDim2.fromOffset(10,4), UDim2.fromOffset(240,28), nameboxFrm)
nameTxt.TextSize = 20; nameTxt.Font = Enum.Font.GothamBold
local diaTxt = newTxt("DiaTxt", UDim2.fromOffset(50,580), UDim2.fromOffset(1180,130), uiLayer)
diaTxt.TextSize = 19; diaTxt.TextWrapped = true; diaTxt.RichText = true

-- AUDIO
local bgmSound = Instance.new("Sound"); bgmSound.Name="DDLCBGM"
bgmSound.Volume=0.5; bgmSound.Parent=ss
local sfx1 = Instance.new("Sound"); sfx1.Name="DDLCSFX1"
sfx1.Volume=0.7; sfx1.Parent=ss

-- ============================================================
-- GAME VARIABLES
-- ============================================================

env.state = "init"
env.running = true
env.alpha = 255; env.bg1 = "black"; env.cg1 = "blank"; env.audio1 = "0"
env.cl = 1; env.chapter = 0; env.ct = ""; env.c_disp = {"","","",""}
env.xaload = 0; env.sectimer = 0; env.getTime = 0; env.startTime = 0
env.autotimer = 0; env.autoskip = 0; env.unitimer = 0; env.uniduration = 0.25
env.print_full_text = false; env.last_text = ""
env.player = ""; env.menu_enabled = false; env.menu_type = nil
env.poem_enabled = false; env.event_enabled = false
env.textbox_enabled = true; env.bgimg_disabled = false
env.history = {}; env.choices = {"","","",""}; env.choicepick = ""
env.poemsread = -1; env.readpoem = {s=0,n=0,y=0,m=0}
env.poemwinner = {"","",""}; env.appeal = {s=0,n=0,y=0}
env.s_poemappeal = {0,0,0}; env.n_poemappeal = {0,0,0}; env.y_poemappeal = {0,0,0}
env.splashTimer = 0; env.menu_alpha = 0
env.tlp = {yx=525,nx=670,sx=470,mx=680,yy=850,ny=850,sy=850,my=850,scale=0.75}
env.z_timer = {0,0}; env.y_timer = 0; env.titlebg_ypos = -240
env.posX = -40; env.posY = 0

-- Character sets
env.s_Set = {a="",b="",x=-200,y=0}
env.y_Set = {a="",b="",x=-200,y=0}
env.n_Set = {a="",b="",x=-200,y=0}
env.m_Set = {a="",b="",x=-200,y=0}
env.changeX = {s={x=0,y=0,z=0},y={x=0,y=0,z=0},n={x=0,y=0,z=0},m={x=0,y=0,z=0}}

-- Persistent data
env.persistent = {ptr=0,chr={m=1,s=1},clear={0,0,0,0,0,0,0,0,0},act2={0,0,0,0}}
env.settings = {textspd=75,autospd=4,lang="eng",masvol=80,bgmvol=80,sfxvol=80,o=0}

-- ============================================================
-- TRANSLATION DATA
-- ============================================================

local tr = {
  names = {"Sayori","Natsuki","Yuri","Monika","Nat & Yuri"},
  splash = {"This game is not suitable for children","  or those who are easily disturbed.","Now everyone can be happy.","Unofficial port by LukeeGD"},
  menuitem = {"Yes","No","Delete ","Restore All"},
  menuhelp = {" - Advances through the game"," - Auto-Forward On/Off"," - Skipping On/Off"," - Enter Game Menu"," - Exit Menu","Managing files: Go to Settings > Characters","Deleting save data: Delete the save folder","There's no point in saving anymore.","Are you sure you want to return to the main menu?","Are you sure you want to quit?",""," - Toggle text outline"},
  auto = "Auto-Forward On",
  skip = "Skipping",
  selectlang = "Select language:"
}

-- ============================================================
-- UI HELPER FUNCTIONS
-- ============================================================

local menuItems = {}
local function clearMenuItems()
  for _, v in ipairs(menuItems) do
    pcall(v.Destroy, v)
  end
  menuItems = {}
end

local function addMenuItem(item)
  table.insert(menuItems, item)
end

local function showTextBox(show)
  textboxBg.Visible = show
  diaTxt.Visible = show
end

local function showNameBox(show)
  nameboxFrm.Visible = show
  nameTxt.Visible = show
end

-- ============================================================
-- GLOBAL FUNCTIONS (called by chapter scripts)
-- ============================================================

-- These MUST be global - chapter scripts call them via loadstring

function bgUpdate(bgx, forceload)
  if bgx == "club_day2" then
    bgx = (math.random(1,6) == 6) and "club-skill" or "club"
  end
  if env.xaload == 0 or forceload then
    bgFade.BackgroundTransparency = 0
  end
  local id = env.loadImg("images/bg/" .. bgx .. ".jpg")
  if id then
    bgImg.Image = id; bgImg.Visible = true; bgLayer.Visible = true
  else
    bgImg.Visible = true
    bgImg.BackgroundColor3 = Color3.fromRGB(60, 90, 140)
    bgImg.BackgroundTransparency = 0
  end
  env.bg1 = bgx
end

function cgUpdate(cgx, forceload)
  if env.cg1 ~= cgx or forceload then
    local id = env.loadImg("images/cg/" .. cgx .. ".png")
    if id then cgImg.Image = id; cgImg.Visible = true; cgLayer.Visible = true
    else cgImg.Visible = false end
  end
  env.cg1 = cgx
end

function cgHide()
  cgUpdate("blank")
end

function audioUpdate(audiox, forceload)
  if env.audio1 ~= audiox or forceload then
    bgmSound:Stop()
    if audiox ~= "" and audiox ~= "0" then
      local id = env.loadAudio("audio/bgm/" .. audiox .. ".ogg")
      if id then
        bgmSound.SoundId = id; bgmSound.Looped = true; bgmSound:Play()
      end
    end
  end
  env.audio1 = audiox
end

function sfxplay(sfxname)
  local id = env.loadAudio("audio/sfx/" .. sfxname .. ".ogg")
  if id then sfx1.SoundId = id; sfx1:Play() end
end

function sfxplay2(sfx)
  sfx:Play()
end

-- Character loading
local charMap = {s="sayori",n="natsuki",y="yuri",m="monika"}

function loadCharacterSprite(chr, a)
  local cn = charMap[chr]
  if not cn then return end
  local fname = "1l.png"
  if a == "1" or a == "" then fname = "1l.png"
  elseif a == "1b" then fname = "1bl.png"
  elseif a == "2" then fname = "1l.png"
  elseif a == "2b" then fname = "1bl.png"
  elseif a == "3" then fname = "2l.png"
  elseif a == "3b" then fname = "2bl.png"
  elseif a == "4" then fname = "2l.png"
  elseif a == "4b" then fname = "2bl.png"
  elseif a == "5" then fname = "3.png"
  elseif a == "5a" then fname = "3a.png"
  elseif a == "5b" then fname = "3b.png"
  elseif a == "5c" then fname = "3c.png"
  elseif a == "5d" then fname = "3d.png"
  else fname = a .. ".png"
  end
  local id = env.loadImg("images/" .. cn .. "/" .. fname)
  local img = charImgs[cn]
  if id and img then img.Image = id; img.Visible = true end
end

function updateSayori(a, b, px)
  loadCharacterSprite("s", a)
  env.s_Set.a = a or ""; env.s_Set.b = b or ""
  local ch = charImgs["sayori"]
  if ch then ch.Position = UDim2.fromOffset(px or -60, 60) end
end

function updateYuri(a, b, px)
  loadCharacterSprite("y", a)
  env.y_Set.a = a or ""; env.y_Set.b = b or ""
  local ch = charImgs["yuri"]
  if ch then ch.Position = UDim2.fromOffset(px or 200, 60) end
end

function updateNatsuki(a, b, px)
  loadCharacterSprite("n", a)
  env.n_Set.a = a or ""; env.n_Set.b = b or ""
  local ch = charImgs["natsuki"]
  if ch then ch.Position = UDim2.fromOffset(px or 80, 60) end
end

function updateMonika(a, b, px)
  loadCharacterSprite("m", a)
  env.m_Set.a = a or ""; env.m_Set.b = b or ""
  local ch = charImgs["monika"]
  if ch then ch.Position = UDim2.fromOffset(px or 150, 60) end
end

function hideSayori() if charImgs["sayori"] then charImgs["sayori"].Visible = false end end
function hideYuri() if charImgs["yuri"] then charImgs["yuri"].Visible = false end end
function hideNatsuki() if charImgs["natsuki"] then charImgs["natsuki"].Visible = false end end
function hideMonika() if charImgs["monika"] then charImgs["monika"].Visible = false end end

function hideAll()
  for _, img in pairs(charImgs) do img.Visible = false end
  env.s_Set = {a="",b="",x=-200,y=0}
  env.y_Set = {a="",b="",x=-200,y=0}
  env.n_Set = {a="",b="",x=-200,y=0}
  env.m_Set = {a="",b="",x=-200,y=0}
end

-- Dialogue system
function cw(p1, stext, tag)
  if p1 == "s" then env.ct = tr.names[1]
  elseif p1 == "n" then env.ct = tr.names[2]
  elseif p1 == "y" then env.ct = tr.names[3]
  elseif p1 == "m" then env.ct = tr.names[4]
  elseif p1 == "ny" then env.ct = tr.names[5]
  elseif p1 == "mc" then env.ct = env.player
  elseif p1 == "bl" then env.ct = ""
  else env.ct = p1 or "Error"
  end
  if not stext then stext = "" end
  if env.settings.lang == "eng" and p1 ~= "bl" then stext = '"' .. stext .. '"' end
  env.c_disp[1] = stext
  env.print_full_text = false; env.last_text = stext; env.startTime = env.getTime

  if env.ct and env.ct ~= "" then
    nameTxt.Text = env.ct; showNameBox(true)
  else
    showNameBox(false)
  end
  diaTxt.Text = stext; showTextBox(true)
end

-- Wrappers
function bl(say) cw("bl", say) end
function mc(say) cw("mc", say) end
function s(say) cw("s", say) end
function n(say) cw("n", say) end
function y(say) cw("y", say) end
function m(say) cw("m", say) end

-- Text utilities
function wrap(str, limit)
  local here = 1
  local function check(sp, st, word, fi)
    if fi - here > limit then here = st; return "\n" .. word end
  end
  return str:gsub("(%s+)()(%S+)()", check)
end

function glitchtext(range)
  local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  local ret = ""
  for i = 1, range do ret = ret .. chars:sub(math.random(1, #chars), math.random(1, #chars)) end
  return ret
end

function space(range)
  return string.rep(" ", range)
end

-- Script engine
-- Sync env vars to globals (chapter scripts read globals)
local function syncGlobals()
  cl = env.cl; chapter = env.chapter; bg1 = env.bg1
  audio1 = env.audio1; cg1 = env.cg1; ct = env.ct
  player = env.player; choices = env.choices; choicepick = env.choicepick
  poemwinner = env.poemwinner; appeal = env.appeal
  poemsread = env.poemsread; readpoem = env.readpoem
  s_Set = env.s_Set; y_Set = env.y_Set; n_Set = env.n_Set; m_Set = env.m_Set
  textbox_enabled = env.textbox_enabled; persistent = env.persistent; settings = env.settings
end
-- Sync globals back to env (chapter scripts may modify cl, chapter, etc.)
local function syncFromGlobals()
  env.cl = cl; env.chapter = chapter; env.bg1 = bg1
  env.audio1 = audio1; env.cg1 = cg1; env.ct = ct
  env.player = player; env.choices = choices; env.choicepick = choicepick
  env.poemwinner = poemwinner; env.appeal = appeal
  env.poemsread = poemsread; env.readpoem = readpoem
  env.s_Set = s_Set; env.y_Set = y_Set; env.n_Set = n_Set; env.m_Set = m_Set
  env.textbox_enabled = textbox_enabled; env.persistent = persistent; env.settings = settings
end
-- Initialize globals from env
syncGlobals()

function scriptJump(nu, fu, au)
  if nu then env.cl = nu; cl = nu end
  env.xaload = -1; env.unitimer = 0
  if fu and fu ~= "" then
    local fn = _G[fu]
    if fn then pcall(fn) end
  end
end

function scriptCheck()
  if not env.running then return end
  syncGlobals()
  local fn = _G["ch" .. chapter .. "script"]
  if fn then
    local ok, err = pcall(fn)
    if not ok then print("[DDLC] Script error cl=" .. tostring(cl) .. ": " .. tostring(err)) end
  end
  syncFromGlobals()
end

function pause(t, f)
  env.autotimer = 0
  if f == "disable" then env.textbox_enabled = false end
  env.ct = ""
  -- Will resume next frame
end

function choice_enable(x)
  if not env.menu_enabled then
    print("[DDLC] Choice enabled: " .. tostring(x))
    env.autotimer = 0; env.autoskip = 0; env.ct = ""
  end
end

function poeminitialize(y)
  env.poemsread = 0
  env.readpoem = {s=0,n=0,y=0,m=0}
  if env.persistent.ptr == 0 then
    env.choices = {tr.names[1],tr.names[2],tr.names[3],tr.names[4]}
  elseif y == "y_ranaway" then
    env.choices = {tr.names[2],tr.names[4]}
  else
    env.choices = {tr.names[2],tr.names[3],tr.names[4]}
  end
  scriptJump(666, "", 0)
end

function fadeOut(x)
  env.alpha = math.max(env.alpha - 5, 0)
  if env.alpha == 0 then
    if x == 1 then
      changeState("poemgame")
    elseif x == 2 then
      env.bg1 = "black"
      changeState("game", 3)
    elseif x == 3 then
      env.chapter = env.chapter + 1
      changeState("game", 3)
    elseif x == 4 then
      scriptJump(env.cl + 2)
      env.alpha = 255
    end
  end
end

-- Event system stubs
event_enabled = false
function event_init(etype, arg1, arg2) end
function event_initstart(etype, arg1, arg2) end
function event_start(etype, arg1) end
function event_draw() end
function event_update() end
function event_keypressed(key) end
function event_end(arg1) end

function changeState(cstate, x)
  print("[DDLC] State: " .. tostring(cstate) .. " x=" .. tostring(x))
  if cstate == "splash" then
    env.state = "splash"; env.splashTimer = 0; env.alpha = 0
    local id = env.loadImg("images/bg/splash.jpg")
    if id then bgImg.Image = id; bgImg.Visible = true; bgLayer.Visible = true end
    audioUpdate("1"); fadeImg.BackgroundTransparency = 1

  elseif cstate == "title" then
    env.state = "title"; env.alpha = 0; env.poem_enabled = false
    audioUpdate("1"); env.y_timer = 0; env.titlebg_ypos = -240
    env.tlp = {yx=525,nx=670,sx=470,mx=680,yy=850,ny=850,sy=850,my=850,scale=0.75}
    env.z_timer = {0,0}
    showTitleMenu()

  elseif cstate == "game" then
    hideTitleMenu(); env.state = "game"
    if x == 1 then
      env.cl = 1; env.chapter = env.persistent.ptr * 10
    elseif x == 2 then
      -- load game
    elseif x == 3 then
      env.cl = env.cl + 2
    elseif x == "autoload" then
      -- autoload
    end
    hideAll(); env.xaload = -1
    bgLayer.Visible = true; cgLayer.Visible = true
    charLayer.Visible = true; uiLayer.Visible = true
    fadeLayer.Visible = true; fadeImg.BackgroundTransparency = 1
    loadChapter(env.chapter)

  elseif cstate == "poemgame" then
    env.state = "poemgame"; hideAll()
    audioUpdate("4", true); env.bg1 = "notebook"
    startPoemGame()

  elseif cstate == "credits" then
    env.state = "credits"
    audioUpdate("credits")
    env.creditsTimer = 0

  elseif cstate == "language" then
    menu_type = "language"

  elseif cstate == "s_kill_early" then
    env.state = "s_kill_early"; env.alpha = 0
    audioUpdate("s_kill_early"); env.y_timer = 0

  elseif cstate == "ghostmenu" then
    env.state = "ghostmenu"; env.alpha = 0
    env.y_timer = 0.7; audioUpdate("ghostmenu")
    env.tlp = {yx=525,nx=670,sx=470,mx=680,yy=850,ny=850,sy=850,my=850,scale=0.75}
    env.z_timer = {0,0}
  end
end

function loadChapter(ch)
  env.chapter = ch; env.cl = 1
  local code = env.loadScript("scripts/eng/script-ch" .. ch .. ".lua")
  if code then
    local ok, err = loadstring(code)
    if ok then
      pcall(ok)
    else
      print("[DDLC] Script load error: " .. tostring(err))
    end
  end
  task.wait()
  scriptCheck()
end

-- ============================================================
-- POEM GAME
-- ============================================================

env.poemword = 1; env.poemstate = 0
env.wordlist = {}; env.sPoint = 0; env.nPoint = 0; env.yPoint = 0
env.poemMenuSel = 1

function startPoemGame()
  hideAll()
  env.state = "poemgame"; env.xaload = 0
  env.poemword = 1; env.sPoint = 0; env.nPoint = 0; env.yPoint = 0
  env.poemstate = 0

  local code = env.loadScript("scripts/eng/poemwords.lua")
  if code then
    local fn = loadstring(code)
    if fn then pcall(fn) end
    if poemwords then poemwords() end
  end
  env.wordlist = {}
  if type(wordlist) == "table" then
    for i = 1, math.min(10, #wordlist) do
      local idx = math.random(1, #wordlist)
      env.wordlist[i] = wordlist[idx]
      table.remove(wordlist, idx)
      if #wordlist == 0 then break end
    end
  end
end

function env.selectPoemWord()
  if #env.wordlist == 0 then return end
  local w = env.wordlist[env.poemMenuSel]
  if w then
    env.sPoint = env.sPoint + (w[2] or 0)
    env.nPoint = env.nPoint + (w[3] or 0)
    env.yPoint = env.yPoint + (w[4] or 0)
    env.poemword = env.poemword + 1
    table.remove(env.wordlist, env.poemMenuSel)
    if #env.wordlist < 3 then
      if type(wordlist) == "table" and #wordlist > 0 then
        for i = 1, math.min(5, #wordlist) do
          local idx = math.random(1, #wordlist)
          table.insert(env.wordlist, wordlist[idx])
          table.remove(wordlist, idx)
          if #wordlist == 0 then break end
        end
      end
    end
    if env.poemword > 20 then
      finishPoemGame()
    end
  end
end

function finishPoemGame()
  -- Determine winner
  if env.persistent.ptr <= 2 then
    env.chapter = env.chapter + 1
    local maxp = math.max(env.sPoint, env.nPoint, env.yPoint)
    local pch = env.chapter
    if env.persistent.ptr == 2 then pch = env.chapter - 20 end
    if maxp == env.sPoint then env.poemwinner[pch] = "Sayori"
    elseif maxp == env.nPoint then env.poemwinner[pch] = "Natsuki"
    elseif maxp == env.yPoint then env.poemwinner[pch] = "Yuri"
    end
  end
  changeState("game", 3)
end

-- ============================================================
-- TITLE / MENU SYSTEM
-- ============================================================

function showTitleMenu()
  menuLayer.Visible = true; env.state = "title"
  env.menu_type = "title"
  clearMenuItems()

  -- Title art
  local id = env.loadImg("images/gui/menu_bg.jpg")
  if id then
    local bg = newImg("MenuBg", nil, nil, menuLayer, 6)
    bg.Image = id; bg.Visible = true
    addMenuItem(bg)
  end

  local titleLabel = newTxt("TitleLabel", UDim2.fromScale(0.5,0.12), UDim2.fromOffset(800,80), menuLayer, 6)
  titleLabel.Text = "DDLC-LOVE " .. VERSION
  titleLabel.TextSize = 48; titleLabel.Font = Enum.Font.GothamBold
  titleLabel.TextColor3 = Color3.fromRGB(255,200,100)
  titleLabel.TextXAlignment = Enum.TextXAlignment.Center
  titleLabel.AnchorPoint = Vector2.new(0.5,0.5)
  titleLabel.Visible = true; addMenuItem(titleLabel)

  local btns = {{"NEW GAME",2},{"LOAD",3},{"SETTINGS",4},{"HELP",5},{"EXIT",6}}
  for i, bd in ipairs(btns) do
    local b = newBtn("B"..bd[1], UDim2.fromOffset(440,200+(i-1)*75),UDim2.fromOffset(400,60), bd[1], nil, nil, menuLayer, 6)
    b.Visible = true; b.TextScaled = true
    local sel = bd[2]
    b.MouseButton1Click:Connect(function()
      if sel == 2 then hideTitleMenu(); startGame()
      elseif sel == 3 then print("[DDLC] Load")
      elseif sel == 4 then print("[DDLC] Settings")
      elseif sel == 5 then print("[DDLC] Help")
      elseif sel == 6 then env.stop() end
    end)
    addMenuItem(b)
  end
  env.menu_alpha = 0
end

function hideTitleMenu()
  menuLayer.Visible = false; clearMenuItems()
end

-- ============================================================
-- GAME START
-- ============================================================

function startGame()
  hideTitleMenu(); env.state = "game"
  bgLayer.Visible = true; cgLayer.Visible = true
  charLayer.Visible = true; uiLayer.Visible = true
  fadeLayer.Visible = true; fadeImg.BackgroundTransparency = 1
  textboxBg.Visible = true; diaTxt.Visible = true

  env.cl = 1; env.chapter = 0; env.xaload = -1
  hideAll(); bgUpdate("residential"); audioUpdate("2")
  loadChapter(0)
end

-- ============================================================
-- MAIN LOOP
-- ============================================================

rs.RenderStepped:Connect(function(dt)
  if not env.running then return end

  env.sectimer = env.sectimer + dt
  env.getTime = env.getTime + dt
  env.unitimer = env.unitimer + dt

  -- Background fade
  if bgFade.BackgroundTransparency < 1 then
    bgFade.BackgroundTransparency = math.min(bgFade.BackgroundTransparency + dt * 3, 1)
  end

  -- State updates
  if env.state == "splash" then
    env.splashTimer = env.splashTimer + dt
    if env.splashTimer > 1.5 then
      env.alpha = math.min(env.alpha + dt * 150, 255)
      if env.splashTimer > 3.5 then
        env.splashTimer = 0; changeState("title")
      end
    end
  end

  if env.state == "title" then
    env.alpha = math.min(env.alpha + dt * 80, 255)
  end

  if env.state == "game" and env.xaload >= 0 then
    scriptCheck()
  end

  if env.state == "poemgame" then
    env.xaload = env.xaload + 1
  end
end)

-- ============================================================
-- INPUT
-- ============================================================

uis.InputBegan:Connect(function(inp, gpe)
  if gpe or not env.running then return end

  if inp.KeyCode == Enum.KeyCode.Escape then
    env.stop()
  end

  local advance = (inp.KeyCode == Enum.KeyCode.Space or inp.KeyCode == Enum.KeyCode.Return)
  if advance then
    if env.state == "splash" then
      changeState("title")
    elseif env.state == "title" then
      hideTitleMenu(); startGame()
    elseif env.state == "game" then
      env.cl = env.cl + 1; env.xaload = 0; env.unitimer = 0
      env.print_full_text = false; scriptCheck()
    elseif env.state == "poemgame" then
      if env.poemstate == 0 then
        env.poemstate = 1
      else
        env.selectPoemWord()
      end
    end
  end

  if inp.KeyCode == Enum.KeyCode.Up and env.state == "poemgame" then
    env.poemMenuSel = math.max(1, env.poemMenuSel - 1)
  end
  if inp.KeyCode == Enum.KeyCode.Down and env.state == "poemgame" then
    env.poemMenuSel = math.min(#env.wordlist, env.poemMenuSel + 1)
  end
end)

-- ============================================================
-- PLAYER NAME INPUT
-- ============================================================

uis.TextBoxFocusReleased:Connect(function(tb)
  if tb and tb.Text and tb.Text ~= "" then
    env.player = tb.Text
  end
end)

-- ============================================================
-- STOP / CLEANUP
-- ============================================================

function env.stop()
  env.running = false
  bgmSound:Stop(); sfx1:Stop()
  clearMenuItems()
  for _, g in pairs(gui:GetChildren()) do
    if g.Name:match("DDLC") then g:Destroy() end
  end
  print("[DDLC] Game stopped")
end

-- ============================================================
-- AUTO START
-- ============================================================

task.spawn(function()
  print("[DDLC] DDLC-LOVE " .. VERSION .. " loading...")

  -- Pre-download essential assets
  local essScripts = {
    "scripts/eng/script-ch0.lua",
    "scripts/eng/script-ch1.lua",
    "scripts/eng/script-ch2.lua",
    "scripts/eng/poemwords.lua",
    "scripts/eng/text.lua"
  }
  local essImages = {
    "images/bg/splash.jpg",
    "images/gui/menu_bg.jpg",
    "audio/bgm/1.ogg",
    "audio/bgm/2.ogg",
    "audio/bgm/3.ogg",
    "audio/sfx/select.ogg",
    "audio/sfx/hover.ogg"
  }
  for _, path in ipairs(essScripts) do
    env.loadScript(path)
    task.wait(0.02)
  end
  for _, path in ipairs(essImages) do
    env.loadImg(path)
    task.wait(0.02)
  end

  loadingLabel.Visible = false
  print("[DDLC] Starting game...")
  task.wait(0.3)
  changeState("splash")
end)

print("[DDLC] DDLC-LOVE loaded! Auto-starting...")
