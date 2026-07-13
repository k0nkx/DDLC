-- DDLC-LOVE Roblox Full Conversion
-- Auto-generated from DDLC-LOVE v1.2.2
-- https://github.com/k0nkx/DDLC

local env = {}
getgenv().ddlc = env

local BASE = "https://raw.githubusercontent.com/k0nkx/DDLC/main/"
local DIR = "DDLC/"

local function ensureDir(p)
  local parts = {}
  for part in p:gmatch("[^/]+") do table.insert(parts, part) end
  local acc = ""
  for i = 1, #parts do
    acc = acc .. parts[i] .. "/"
    if not isfolder(acc) then makefolder(acc) end
  end
end

local function downloadFile(url, localPath, silent)
  if isfile(localPath) then return end
  if not silent then print("[DDLC] Downloading: " .. url) end
  local ok, resp = pcall(request, {Url = url, Method = "GET"})
  if ok and resp and resp.Body then
    local parent = localPath:match("^(.+)/[^/]+$")
    if parent then ensureDir(parent) end
    writefile(localPath, resp.Body)
    if not silent then print("[DDLC] Downloaded: " .. localPath) end
  else
    warn("[DDLC] Failed: " .. url)
  end
end

local function getFile(relPath, silent)
  local full = DIR .. relPath
  if isfile(full) then return full end
  downloadFile(BASE .. relPath, full, silent)
  if isfile(full) then return full end
  return nil
end

local function readScript(relPath)
  local full = DIR .. relPath
  if isfile(full) then return readfile(full) end
  downloadFile(BASE .. relPath, full)
  if isfile(full) then return readfile(full) end
  return nil
end

local imgCache = {}
local function getCachedAsset(path)
  if imgCache[path] then return imgCache[path] end
  local full = DIR .. path
  if not isfile(full) then return nil end
  local ok, id = pcall(getcustomasset, full)
  if ok and id and type(id) == "string" and #id > 0 then
    imgCache[path] = id
    return id
  end
  return nil
end

-- Persistent state
player = ""
persistent = { ptr = 0, clear = {0,0,0,0,0,0,0,0,0}, chr = {m = 1, s = 1}, act2 = {0,0,0,0} }
settings = { textspd = 75, autospd = 4, lang = "eng", masvol = 80, bgmvol = 80, sfxvol = 80, o = 0 }
cl = 1; bg1 = "black"; audio1 = "0"; cg1 = "blank"; ct = ""
s_Set = { a = "", b = "", x = -200, y = 0 }
y_Set = { a = "", b = "", x = -200, y = 0 }
n_Set = { a = "", b = "", x = -200, y = 0 }
m_Set = { a = "", b = "", x = -200, y = 0 }
chapter = 0
readpoem = { s = 0, n = 0, y = 0, m = 0 }
choices = { "", "", "", "" }
choicepick = ""
poemsread = -1
s_poemappeal = { 0, 0, 0 }; n_poemappeal = { 0, 0, 0 }; y_poemappeal = { 0, 0, 0 }
poemwinner = { "", "", "" }; appeal = { s = 0, n = 0, y = 0 }
savenumber = 1
state = "load"
menu_enabled = false; menu_type = nil; menu_alpha = 0; m_selected = 2
textbox_enabled = true; poem_enabled = false; event_enabled = false
bgalpha = 255; cgalpha = 255; alpha = 255
getTime = 0; startTime = 0; autotimer = 0; autoskip = 0
posX = -40; posY = 0; xaload = 0; unitimer = 0; uniduration = 0.25
sectimer = 0; last_text = ""; print_full_text = false
c_disp = {}; history = {}
style_edited = false
tlp = { yx = 525, nx = 670, sx = 470, mx = 680, yy = 850, ny = 850, sy = 850, my = 850, scale = 0.75 }
z_timer = { 0, 0 }; y_timer = 0; titlebg_ypos = -240
s_timer = 0; l_timer = 95
sp = {}
local sprr = {}; for i = 1, 11 do sprr[i] = i end
for i = 1, 3 do local r = math.random(1, #sprr); sp[i] = sprr[r]; table.remove(sprr, r) end
gui = {}; tr = {}
console_enabled = false

-- GUI Setup
local Players = game:GetService("Players")
local playerObj = Players.LocalPlayer
local RunSvc = game:GetService("RunService")
local UserISvc = game:GetService("UserInputService")
local SoundSvc = game:GetService("SoundService")
local playerGui = playerObj:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("DDLCGui")
if oldGui then oldGui:Destroy() end
local oldBgm = SoundSvc:FindFirstChild("DDLCBGM")
if oldBgm then oldBgm:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DDLCGui"; screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true; screenGui.DisplayOrder = 100
screenGui.Parent = playerGui

local mainFrm = Instance.new("Frame")
mainFrm.Name = "Main"; mainFrm.BackgroundTransparency = 1
mainFrm.Size = UDim2.fromOffset(1280, 720)
mainFrm.Position = UDim2.fromScale(0.5, 0.5)
mainFrm.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrm.ClipsDescendants = true
mainFrm.Parent = screenGui

local function newImg(n, pos, sz, parent)
  local i = Instance.new("ImageLabel")
  i.Name = n; i.BackgroundTransparency = 1
  i.Position = pos or UDim2.fromOffset(0,0)
  i.Size = sz or UDim2.fromOffset(1280,720)
  i.Visible = false; i.Parent = parent or mainFrm
  return i
end

local function newTxt(n, pos, sz, parent)
  local t = Instance.new("TextLabel")
  t.Name = n; t.BackgroundTransparency = 1
  t.Position = pos or UDim2.fromOffset(0,0)
  t.Size = sz or UDim2.fromOffset(1280,720)
  t.Text = ""; t.TextColor3 = Color3.new(1,1,1)
  t.Font = Enum.Font.GothamMedium; t.TextSize = 20
  t.TextXAlignment = Enum.TextXAlignment.Left
  t.TextYAlignment = Enum.TextYAlignment.Top
  t.Visible = false; t.Parent = parent or mainFrm
  t.RichText = true
  return t
end

local function newFrm(n, pos, sz, col, parent)
  local f = Instance.new("Frame")
  f.Name = n; f.BackgroundColor3 = col or Color3.new(0,0,0)
  f.BackgroundTransparency = 0; f.BorderSizePixel = 0
  f.Position = pos or UDim2.fromOffset(0,0)
  f.Size = sz or UDim2.fromOffset(1280,720)
  f.Visible = false; f.Parent = parent or mainFrm
  return f
end

-- Layers
local bgLayer = newFrm("BgLayer", nil, nil, Color3.new(0,0,0))
bgLayer.Visible = true; bgLayer.ZIndex = 1; bgLayer.BackgroundTransparency = 0
local bgImg = newImg("BgImg", nil, nil, bgLayer)
bgImg.ZIndex = 1; bgImg.BackgroundColor3 = Color3.new(0,0,0); bgImg.BackgroundTransparency = 0
local bgImg2 = newImg("BgImg2", nil, nil, bgLayer)
bgImg2.ZIndex = 2; bgImg2.BackgroundColor3 = Color3.new(0,0,0); bgImg2.BackgroundTransparency = 0

local cgLayer = newFrm("CgLayer", nil, nil, Color3.new(0,0,0))
cgLayer.ZIndex = 3; cgLayer.BackgroundTransparency = 0
local cgImg = newImg("CgImg", nil, nil, cgLayer)
cgImg.ZIndex = 3; cgImg.BackgroundColor3 = Color3.new(0,0,0); cgImg.BackgroundTransparency = 0

local charLayer = newFrm("CharLayer", nil, nil, Color3.new(0,0,0))
charLayer.ZIndex = 4; charLayer.BackgroundTransparency = 1
local uiLayer = newFrm("UiLayer", nil, nil, Color3.new(0,0,0))
uiLayer.ZIndex = 5; uiLayer.BackgroundTransparency = 1
local fadeLayer = newFrm("FadeLayer", nil, nil, Color3.new(0,0,0))
fadeLayer.ZIndex = 6; fadeLayer.BackgroundTransparency = 0
local menuLayer = newFrm("MenuLayer", nil, nil, Color3.new(0,0,0))
menuLayer.ZIndex = 7; menuLayer.BackgroundTransparency = 1
local overlayLayer = newFrm("OverlayLayer", nil, nil, Color3.new(0,0,0))
overlayLayer.ZIndex = 8; overlayLayer.BackgroundTransparency = 1

local fadeImg = newImg("FadeImg", nil, nil, fadeLayer)
fadeImg.BackgroundColor3 = Color3.new(0,0,0); fadeImg.BackgroundTransparency = 0; fadeImg.ZIndex = 6

-- Textbox
local textboxBg = newFrm("TextBoxBg", UDim2.fromOffset(0,560), UDim2.fromOffset(1280,160), Color3.fromRGB(0,0,0), uiLayer)
textboxBg.BackgroundTransparency = 0.2; textboxBg.ZIndex = 5
local nameboxFrm = newFrm("NameBox", UDim2.fromOffset(40,520), UDim2.fromOffset(260,36), Color3.fromRGB(186,84,153), uiLayer)
nameboxFrm.ZIndex = 5
local nameTxt = newTxt("NameTxt", UDim2.fromOffset(10,4), UDim2.fromOffset(240,28), nameboxFrm)
nameTxt.TextSize = 20; nameTxt.Font = Enum.Font.GothamBold; nameTxt.ZIndex = 5
nameTxt.TextColor3 = Color3.new(0,0,0)
local diaTxt = newTxt("DiaTxt", UDim2.fromOffset(50,580), UDim2.fromOffset(1180,130), uiLayer)
diaTxt.TextSize = 19; diaTxt.TextWrapped = true; diaTxt.ZIndex = 5
diaTxt.TextColor3 = Color3.new(1,1,1)
local ctcImg = newImg("CtcImg", UDim2.fromOffset(1015,685), UDim2.fromOffset(30,20), uiLayer)
ctcImg.ZIndex = 5

-- Characters
local charImgs = {}
for _, name in ipairs({"sayori","yuri","natsuki","monika"}) do
  local ci = newImg(name, UDim2.fromScale(0,0), UDim2.fromOffset(400,600), charLayer)
  ci.SizeConstraint = Enum.SizeConstraint.RelativeXX
  ci.ResampleMode = Enum.ResamplerMode.Pixelated
  ci.ZIndex = 4
  charImgs[name] = ci
end

-- Loading bar
local loadBar = newFrm("LoadBar", UDim2.fromOffset(0,710), UDim2.fromOffset(0,10), Color3.fromRGB(255,255,255))
loadBar.ZIndex = 10; loadBar.BackgroundTransparency = 0; loadBar.Visible = false

-- Splash text
local splashTxt = newTxt("SplashTxt", UDim2.fromOffset(440,300), UDim2.fromOffset(400,400))
splashTxt.TextSize = 20; splashTxt.TextWrapped = true; splashTxt.ZIndex = 9
splashTxt.TextColor3 = Color3.new(0,0,0); splashTxt.TextXAlignment = Enum.TextXAlignment.Left

-- Name input
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.fromOffset(400,40); nameBox.Position = UDim2.fromOffset(440,200)
nameBox.Visible = false; nameBox.Text = ""; nameBox.ZIndex = 10
nameBox.PlaceholderText = "Enter name and press Enter"
nameBox.Font = Enum.Font.GothamBold; nameBox.TextSize = 24
nameBox.TextColor3 = Color3.new(1,1,1)
nameBox.BackgroundColor3 = Color3.fromRGB(40,20,60)
nameBox.BorderSizePixel = 2; nameBox.BorderColor3 = Color3.fromRGB(100,50,150)
nameBox.Parent = mainFrm
nameBox.FocusLost:Connect(function(enter)
  if enter and #nameBox.Text > 0 then
    player = nameBox.Text; nameBox.Visible = false; keyboard = false
    changeState("game", 1)
  end
end)

-- Title buttons
local titleBtns = {}
local function createTitleBtns()
  for _, b in pairs(titleBtns) do if b then pcall(function() b:Destroy() end) end end
  titleBtns = {}
  local items = {"NEW GAME","LOAD","SETTINGS","HELP","QUIT"}
  local yp = 250
  for i, txt in ipairs(items) do
    local b = Instance.new("TextButton")
    b.Name = "TB"..i
    b.BackgroundColor3 = Color3.fromRGB(40,20,60)
    b.BorderSizePixel = 2; b.BorderColor3 = Color3.fromRGB(100,50,150)
    b.Position = UDim2.fromOffset(440, yp)
    b.Size = UDim2.fromOffset(400,50)
    b.Text = txt; b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 24
    b.Parent = mainFrm; b.ZIndex = 7; b.Visible = false
    b.MouseButton1Click:Connect(function()
      m_selected = i + 1; menu_confirm()
    end)
    titleBtns[txt] = b; yp = yp + 65
  end
end
createTitleBtns()

-- Audio
local bgmS = Instance.new("Sound"); bgmS.Name = "DDLCBGM"; bgmS.Volume = 0.5; bgmS.Parent = SoundSvc
local bgmLpS = Instance.new("Sound"); bgmLpS.Name = "DDLCBGML"; bgmLpS.Volume = 0.5; bgmLpS.Parent = SoundSvc
local sfx1S = Instance.new("Sound"); sfx1S.Name = "DDLCSFX1"; sfx1S.Volume = 0.7; sfx1S.Parent = SoundSvc

-- Audio functions
local audio_wloop = {"1","2","3","4","4g","5","5_monika","5_natsuki","5_sayori","5_yuri","6","7g","8","10","d","monika-end"}

local function game_setvolume()
  local mv = (settings.masvol or 80)/100
  local bv = (settings.bgmvol or 80)/100*mv
  local sv = (settings.sfxvol or 80)/100*mv
  bgmS.Volume = bv; bgmLpS.Volume = bv; sfx1S.Volume = sv
end

function audioUpdate(ax, fl)
  if audio1 ~= ax or fl then
    bgmS:Stop(); bgmLpS:Stop()
    if ax ~= "" and ax ~= "0" then
      local p
      if ax == "credits" or ax == "end-voice" then
        p = "assets/audio/bgm/"..settings.lang.."/"..ax..".ogg"
      else
        p = "assets/audio/bgm/"..ax..".ogg"
      end
      local lp = getFile(p, true)
      if lp then
        local ok, id = pcall(getcustomasset, lp)
        if ok and id then
          bgmS.SoundId = id
          local looped = false
          for _, w in ipairs(audio_wloop) do
            if ax == w then
              local lp2 = getFile("assets/audio/bgm/"..ax.."-loop.ogg", true)
              if lp2 then
                local ok2, lid = pcall(getcustomasset, lp2)
                if ok2 and lid then
                  bgmLpS.SoundId = lid; bgmLpS.Looped = true
                  bgmS.Looped = false; looped = true
                end
              end
            end
          end
          if not looped then
            if ax == "2g" then
              local lp2 = getFile("assets/audio/bgm/2-loop.ogg", true)
              if lp2 then local _, lid = pcall(getcustomasset, lp2); if _ and lid then bgmLpS.SoundId = lid; bgmLpS.Looped = true; bgmS.Looped = false; looped = true end end
            elseif ax == "3g" or ax == "3g2" then
              local lp2 = getFile("assets/audio/bgm/3-loop.ogg", true)
              if lp2 then local _, lid = pcall(getcustomasset, lp2); if _ and lid then bgmLpS.SoundId = lid; bgmLpS.Looped = true; bgmS.Looped = false; looped = true end end
            elseif ax == "7" then
              local lp2 = getFile("assets/audio/bgm/"..(persistent.ptr==2 and "7a" or "7-loop")..".ogg", true)
              if lp2 then local _, lid = pcall(getcustomasset, lp2); if _ and lid then bgmLpS.SoundId = lid; bgmLpS.Looped = true; bgmS.Looped = false; looped = true end end
            end
          end
          if not looped then bgmS.Looped = true end
          game_setvolume(); bgmS:Play()
        end
      end
    end
  end
  audio1 = ax
end

function sfxplay(sfx)
  if sfx ~= "" then
    local p = "assets/audio/sfx/"..sfx..".ogg"
    local lp = getFile(p, true)
    if lp then
      local ok, id = pcall(getcustomasset, lp)
      if ok and id then
        local c = Instance.new("Sound")
        c.SoundId = id; c.Volume = (settings.sfxvol/100)*(settings.masvol/100)
        c.Parent = SoundSvc; c:Play()
        c.Ended:Connect(function() c:Destroy() end)
      end
    end
  end
end

-- Image functions
function bgUpdate(bgx, fl)
  if bgx == "club_day2" then
    bgx = (math.random(1,6)==6) and "club-skill" or "club"
  end
  if xaload == 0 or fl then
    local p = "assets/images/bg/"..bgx..".jpg"
    local lp = getFile(p, true)
    if lp then
      local ok, id = pcall(getcustomasset, lp)
      if ok and id then bgImg.Image = id; bgImg.Visible = true end
    end
  end
  bg1 = bgx
end

function cgUpdate(cgx, fl)
  if cg1 ~= cgx or fl then
    local p = "assets/images/cg/"..cgx..".png"
    local lp = getFile(p, true)
    if lp then
      local ok, id = pcall(getcustomasset, lp)
      if ok and id then cgImg.Image = id; cgImg.Visible = true; cgLayer.Visible = true end
    end
  end
  cg1 = cgx
end

function cgHide()
  cgImg.Visible = false; cgLayer.Visible = false; cg1 = "blank"
end

-- Character functions
local charMap = {s="sayori",n="natsuki",y="yuri",m="monika"}
local lrT = {
  ["1"]={"1l","1r"},["2"]={"1l","2r"},["3"]={"2l","1r"},["4"]={"2l","2r"},
  ["1b"]={"1bl","1br"},["2b"]={"1bl","2br"},["3b"]={"2bl","1br"},["4b"]={"2bl","2br"},
  ["5"]={"3",""},["5a"]={"3a",""},["5b"]={"3b",""},["5c"]={"3c",""},["5d"]={"3d",""}
}

function loadCharacter(set)
  local chr
  if set == s_Set then chr="sayori" elseif set == y_Set then chr="yuri"
  elseif set == n_Set then chr="natsuki" elseif set == m_Set then chr="monika"
  else return end
  local lr = lrT[set.a] or {set.a,""}
  local img = charImgs[chr]
  if not img then return end
  local p = "assets/images/"..chr.."/"..lr[1]..".png"
  local lp = getFile(p, true)
  if lp then
    local ok, id = pcall(getcustomasset, lp)
    if ok and id then img.Image = id; img.Visible = true end
  end
end

function loadSayori() loadCharacter(s_Set) end
function loadYuri() loadCharacter(y_Set) end
function loadNatsuki() loadCharacter(n_Set) end
function loadMonika() loadCharacter(m_Set) end

function hideAll()
  s_Set = {a="",b="",x=-675,y=4}; y_Set = {a="",b="",x=-675,y=4}
  n_Set = {a="",b="",x=-675,y=4}; m_Set = {a="",b="",x=-675,y=4}
  for _, img in pairs(charImgs) do img.Visible = false; img.Image = "" end
end
function hideSayori() charImgs["sayori"].Visible = false end
function hideYuri() charImgs["yuri"].Visible = false end
function hideNatsuki() charImgs["natsuki"].Visible = false end
function hideMonika() charImgs["monika"].Visible = false end
function loadAll() loadSayori(); loadNatsuki(); loadYuri(); loadMonika() end
function unloadAll() hideAll() end

function updateSayori(a, b, px)
  s_Set.a = a; s_Set.b = b or ""
  loadSayori()
end
function updateYuri(a, b, px)
  y_Set.a = a; y_Set.b = b or ""
  loadYuri()
end
function updateNatsuki(a, b, px)
  n_Set.a = a; n_Set.b = b or ""
  loadNatsuki()
end
function updateMonika(a, b, px)
  m_Set.a = a; m_Set.b = b or ""
  loadMonika()
end

-- Text system
function dripText(text, cps, sTime)
  if text ~= last_text then
    sTime = getTime; startTime = sTime; last_text = text; print_full_text = false
  end
  local cTime = getTime
  if cTime <= sTime or sTime == 0 then return "" end
  if not cps then cps = 100 end
  local len = math.floor((cTime-sTime)*cps)
  len = math.max(len,1); len = math.min(len,#text)
  if print_full_text then return text end
  if len == #text then print_full_text = true end
  return text:sub(1,len)
end

function cw(p1, stext, tag)
  local ct_text = ""
  if p1 == "s" then ct_text = (tr.names and tr.names[1]) or "Sayori"
  elseif p1 == "n" then ct_text = (tr.names and tr.names[2]) or "Natsuki"
  elseif p1 == "y" then ct_text = (tr.names and tr.names[3]) or "Yuri"
  elseif p1 == "m" then ct_text = (tr.names and tr.names[4]) or "Monika"
  elseif p1 == "ny" then ct_text = (tr.names and tr.names[5]) or "Nat & Yuri"
  elseif p1 == "mc" then ct_text = player
  elseif p1 == "bl" then ct_text = ""
  elseif p1 then ct_text = p1 else ct_text = "Error" end
  if not stext then stext = "" end
  if settings.lang == "eng" and p1 ~= "bl" then stext = "\u{201C}"..stext.."\u{201D}" end

  if #history == 0 or history[1] ~= stext then
    for i = 30, 1, -1 do history[i] = history[i-1] end
    history[1] = (ct_text == "") and stext or (ct_text..": "..stext)
  end

  local tspd
  if autoskip > 0 then tspd = 10000
  elseif tag == "fast" or tag == "nwfast" then tspd = 250
  elseif tag == "slow" then tspd = 25
  elseif chapter == 30 then tspd = 50
  else tspd = settings.textspd or 75 end

  local textx = dripText(stext, tspd, startTime)
  nameTxt.Text = ct_text; diaTxt.Text = textx
  nameboxFrm.Visible = true; nameTxt.Visible = true
  diaTxt.Visible = true; textboxBg.Visible = true
  ctcImg.Visible = print_full_text

  if tag and (tag == "nw" or tag == "nwfast") and print_full_text then
    scriptJump(cl + 1)
  elseif autotimer > 0 and print_full_text then
    scriptJump(cl + 1); autotimer = 0.01
  end
end

function bl(say) cw("bl", say) end
function mc(say) cw("mc", say) end
function s(say) cw("s", say) end
function n(say) cw("n", say) end
function y(say) cw("y", say) end
function m(say) cw("m", say) end

-- Script engine
function scriptJump(nu, fu, au)
  xaload = -1; unitimer = 0
  if nu then cl = nu end
  if au then autotimer = au; autoskip = au end
  if fu and fu ~= "" then
    local fn = _G[fu]
    if fn then fn() else pcall(loadstring(fu.."()")) end
  end
end

function pause(t, f)
  if f == "disable" then textbox_enabled = false end
  autotimer = 0; print_full_text = false; ct = ""
end

function choice_enable(x)
  if not menu_enabled then
    if x == "dialog" then menu_enable("dialog") else menu_enable("choice") end
    autotimer = 0; autoskip = 0; ct = ""
  end
end

function poeminitialize(y)
  poemsread = 0; readpoem = {s=0,n=0,y=0,m=0}
  if persistent.ptr == 0 then
    choices = {tr.names[1],tr.names[2],tr.names[3],tr.names[4]}
  elseif y == "y_ranaway" then choices = {tr.names[2],tr.names[4]}
  else choices = {tr.names[2],tr.names[3],tr.names[4]} end
  scriptJump(666,"",0)
end

function glitchtext(r)
  local c = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  local res = ""
  for i = 1, r do res = res..c:sub(math.random(1,#c),math.random(1,#c)) end
  return res
end

function scriptCheck()
  local fn = _G["ch"..chapter.."script"]
  if fn then local ok, err = pcall(fn); if not ok then print("[DDLC] Script err ch"..chapter..": "..tostring(err)) end end
end

-- Event stubs
function event_init(e, a1, a2) event_enabled = true end
function event_initstart(e, a1, a2) event_init(e, a1, a2) end
function event_start(e, a1, a2) end
function event_draw() end
function event_update() end
function event_keypressed(k) end
function event_endnext() cl = cl + 1; xaload = 0 end
function event_end(a1) event_enabled = false; if a1 == "next" then event_endnext() end end

-- Menu system
local menu_previous = nil; local menu_previous2 = nil
local menu_fadeout = false; local pagenum = 1; local keyboard = false
local save_date = {}; local savenum = {}

function menu_enable(m)
  menu_enabled = true; menu_type = m
  if m == "title" then menu_items = 6
  elseif m == "pause" then menu_items = 9
  elseif m == "choice" then menu_items = #choices + 1
  elseif m == "settings" then menu_items = 8
  elseif m == "savegame" or m == "loadgame" then menu_items = 8
  elseif m == "characters" then menu_items = 6
  elseif m == "help" or m == "history" then menu_items = 0
  elseif m == "dialog" then menu_items = 2
  elseif m == "mainyesno" or m == "quityesno" or m == "language" then menu_items = 3 end
  m_selected = 2
end

function menu_confirm()
  if menu_type == "title" then
    menu_previous = "title"
    if m_selected == 2 then
      bg1 = "black"
      if player ~= "" then changeState("game", 1)
      else nameBox.Visible = true; nameBox:CaptureFocus() end
    elseif m_selected == 3 then pagenum = 1; menu_enable("loadgame")
    elseif m_selected == 4 then menu_enable("settings")
    elseif m_selected == 5 then menu_enable("help")
    elseif m_selected == 6 then menu_enable("quityesno") end
  elseif menu_type == "pause" then
    menu_previous = "pause"
    if m_selected == 2 then menu_enable("history")
    elseif m_selected == 3 then pagenum = 1; menu_enable("savegame")
    elseif m_selected == 4 then pagenum = 1; menu_enable("loadgame")
    elseif m_selected == 5 then
      if persistent.chr.m == 2 then menu_fadeout = true else menu_enable("mainyesno") end
    elseif m_selected == 6 then menu_enable("settings")
    elseif m_selected == 7 then menu_enable("help")
    elseif m_selected == 8 then menu_enable("quityesno")
    elseif m_selected == 9 then menu_fadeout = true end
  elseif menu_type == "choice" then
    if choicepick ~= "" then scriptJump(cl+1); menu_fadeout = true end
  elseif menu_type == "mainyesno" then
    if m_selected == 2 then changeState("title") elseif m_selected == 3 then menu_enable("pause") end
  elseif menu_type == "quityesno" then
    if m_selected == 2 then env.stop() end
  end
end

function menu_keypressed(key)
  if key == "down" then
    if menu_type == "savegame" or menu_type == "loadgame" then
      if m_selected <= 4 then m_selected = m_selected + 3 else m_selected = m_selected - 3 end
    elseif m_selected <= menu_items - 1 then m_selected = m_selected + 1 else m_selected = 2 end
  elseif key == "up" then
    if menu_type == "savegame" or menu_type == "loadgame" then
      if m_selected >= 5 then m_selected = m_selected - 3 else m_selected = m_selected + 3 end
    elseif m_selected >= 3 then m_selected = m_selected - 1 else m_selected = menu_items end
  elseif key == "a" then
    sfxplay("select"); menu_confirm()
  elseif key == "b" then
    sfxplay("hover")
    if menu_type == "pause" then menu_fadeout = true
    elseif menu_type ~= "title" and menu_type ~= "choice" and menu_type ~= "language" then
      menu_enable(menu_previous)
    end
  end
end

-- States
function changeState(cs, x)
  print("[DDLC] Loading state: "..cs)
  menu_alpha = 0; menu_previous = nil; history = {}
  if cs == "load" then
    l_timer = 95; loadBar.Visible = true
  elseif cs == "splash" then
    local p = "assets/images/bg/splash.jpg"
    local lp = getFile(p, true)
    if lp then local _, id = pcall(getcustomasset, lp); if _ and id then bgImg.Image = id; bgImg.Visible = true end end
    alpha = 0; audioUpdate("1"); s_timer = 0
  elseif cs == "title" then
    alpha = 0; audioUpdate("1")
    menu_enable("title")
    local p = "assets/images/gui/menu_bg.jpg"
    local lp = getFile(p, true)
    if lp then local _, id = pcall(getcustomasset, lp); if _ and id then bgImg.Image = id; bgImg.Visible = true end end
    for _, b in pairs(titleBtns) do if b then b.Visible = true end end
    hideAll()
    charLayer.Visible = false; uiLayer.Visible = false; cgLayer.Visible = false
  elseif cs == "game" and x == 1 then
    cl = 1; chapter = persistent.ptr * 10
    if persistent.ptr == 0 and persistent.chr.m == 0 then cl = 10001 end
    loadChapterScript()
  elseif cs == "game" and (x == 2 or x == 3) then
    loadChapterScript()
  elseif cs == "poemgame" then
    alpha = 255
  end
  if cs == "game" or cs == "newgame" then
    alpha = 255; loadAll()
    bgUpdate(bg1, true); audioUpdate(audio1, true); cgUpdate(cg1, true)
    poem_enabled = false; menu_enabled = false; xaload = -1
    for _, b in pairs(titleBtns) do if b then b.Visible = false end end
    -- Show UI layers
    charLayer.Visible = true; uiLayer.Visible = true; cgLayer.Visible = true
    fadeLayer.Visible = true; fadeImg.BackgroundTransparency = 1
  end
  state = cs
  print("[DDLC] Loaded state: "..cs)
end

function loadChapterScript()
  local code = readScript("scripts/eng/script-ch"..chapter..".lua")
  if code then
    local ok, err = pcall(loadstring(code))
    if not ok then warn("[DDLC] Script load error ch"..chapter..": "..tostring(err)) end
  end
end

-- Loading
function loadAssets()
  print("[DDLC] Loading assets...")
  getFile("assets/images/gui/menu_bg.jpg")
  getFile("assets/images/gui/namebox.png")
  getFile("assets/images/gui/textbox.png")
  getFile("assets/images/gui/ctc.png")
  getFile("assets/images/gui/overlay/main_menu.png")
  getFile("assets/images/gui/overlay/game_menu.png")
  getFile("assets/images/bg/splash.jpg")
  getFile("assets/images/bg/black.jpg")
  getFile("assets/audio/bgm/1.ogg")
  getFile("assets/audio/sfx/select.ogg")
  getFile("assets/audio/sfx/hover.ogg")
  -- Preload chapter 0 script
  readScript("scripts/eng/script-ch0.lua")
  print("[DDLC] Asset loading complete")
end

-- Draw/Update
function drawSplash()
  if state == "splash" then
    bgLayer.Visible = true; bgImg.Visible = true
    splashTxt.Visible = false; fadeImg.BackgroundTransparency = math.max(1 - alpha/255, 0)
  elseif state == "splash2" then
    bgLayer.Visible = true; splashTxt.Visible = true
    splashTxt.Text = "This game is not suitable for children\n  or those who are easily disturbed."
  elseif state == "title" then
    for _, b in pairs(titleBtns) do b.Visible = true end
    splashTxt.Visible = false
  end
end

function updateSplash()
  s_timer = s_timer + 0.016
  if state == "splash" then
    if s_timer <= 3 then alpha = math.min(alpha+7.75, 255)
    else alpha = math.max(alpha-7.75, 0); if alpha <= 0 then state = "splash2"; s_timer = 0 end end
  elseif state == "splash2" then
    if s_timer <= 6 then alpha = math.min(alpha+7.75, 255)
    elseif s_timer < 7 then alpha = math.max(alpha-7.75, 0)
    elseif s_timer >= 7 then changeState("title") end
  elseif state == "title" then
    alpha = math.min(alpha+5, 255)
  end
end

function updateGame()
  scriptCheck()
  xaload = xaload + 1
  unitimer = math.min(unitimer + 0.016, uniduration)
end

-- Input
UserISvc.InputBegan:Connect(function(input, gpe)
  if gpe then return end
  local kc = input.KeyCode
  local mapped
  if kc == Enum.KeyCode.Space or kc == Enum.KeyCode.Return then mapped = "a"
  elseif kc == Enum.KeyCode.Escape or kc == Enum.KeyCode.Backspace then mapped = "b"
  elseif kc == Enum.KeyCode.LeftShift or kc == Enum.KeyCode.RightShift or kc == Enum.KeyCode.One then mapped = "y"
  elseif kc == Enum.KeyCode.Two then mapped = "r"
  elseif kc == Enum.KeyCode.Three then mapped = "start"
  elseif kc == Enum.KeyCode.Four then mapped = "back"
  elseif kc == Enum.KeyCode.Up then mapped = "up"
  elseif kc == Enum.KeyCode.Down then mapped = "down"
  elseif kc == Enum.KeyCode.Left then mapped = "left"
  elseif kc == Enum.KeyCode.Right then mapped = "right" end
  if not mapped then return end

  if menu_enabled then menu_keypressed(mapped); return end
  if state == "splash" or state == "splash2" then
    if mapped == "a" then changeState("title") end
  elseif state == "title" then
    -- Handled by buttons
  elseif state == "game" or state == "newgame" then
    if event_enabled then
      if mapped == "a" then event_endnext() end
    elseif mapped == "a" then
      if print_full_text then
        autotimer = 0; cl = cl + 1; xaload = 0; unitimer = 0
      else
        print_full_text = true
      end
    elseif mapped == "y" then
      autotimer = 0; menu_enable("pause")
    elseif mapped == "start" then
      if autotimer == 0 then autotimer = 0.01 else autotimer = 0 end
    elseif mapped == "b" then
      textbox_enabled = not textbox_enabled
    end
  end
end)

-- Main loop
RunSvc.RenderStepped:Connect(function(dt)
  getTime = getTime + dt

  if state == "title" then
    posX = posX - dt * 37.5; posY = posY - dt * 37.5
    if posX <= -200 then posX = 0 end; if posY <= -200 then posY = 0 end
  end

  if state == "splash" or state == "splash2" or state == "title" then
    updateSplash(); drawSplash()
  elseif state == "game" or state == "newgame" then
    updateGame()
  end

  if state == "title" and bgImg.Visible and bgImg.Image ~= "" then
    bgImg.Position = UDim2.fromOffset(posX, posY)
  end
end)

-- Stop
function env.stop()
  bgmS:Stop(); bgmLpS:Stop()
  local g = playerGui:FindFirstChild("DDLCGui")
  if g then g:Destroy() end
end

-- Auto-start - skip loading screen, go straight to Chapter 0
print("[DDLC] DDLC-LOVE for Roblox starting...")

local function bootstrap()
  -- Load text/localization
  local textCode = readScript("scripts/eng/text.lua")
  if textCode then
    local ok, err = pcall(loadstring(textCode))
    if ok then print("[DDLC] Text loaded") else warn("[DDLC] Text error: "..tostring(err)) end
  end

  -- Download essential assets in background
  print("[DDLC] Downloading assets...")
  getFile("assets/images/gui/menu_bg.jpg", true)
  getFile("assets/images/bg/black.jpg", true)
  getFile("assets/images/bg/residential.jpg", true)
  getFile("assets/images/bg/class.jpg", true)
  getFile("assets/images/bg/club.jpg", true)
  getFile("assets/images/bg/corridor.jpg", true)
  getFile("assets/images/bg/house.jpg", true)
  getFile("assets/images/bg/kitchen.jpg", true)
  getFile("assets/images/bg/sayori_bedroom.jpg", true)
  getFile("assets/images/bg/closet.jpg", true)
  getFile("assets/audio/bgm/1.ogg", true)
  getFile("assets/audio/bgm/1-loop.ogg", true)
  getFile("assets/audio/bgm/2.ogg", true)
  getFile("assets/audio/bgm/2-loop.ogg", true)
  getFile("assets/audio/sfx/select.ogg", true)
  getFile("assets/audio/sfx/hover.ogg", true)
  -- Sayori sprites for ch0
  getFile("assets/images/sayori/1l.png", true)
  getFile("assets/images/sayori/1r.png", true)
  getFile("assets/images/sayori/2l.png", true)
  getFile("assets/images/sayori/2r.png", true)
  getFile("assets/images/sayori/3a.png", true)
  getFile("assets/images/sayori/3b.png", true)
  getFile("assets/images/sayori/3c.png", true)
  getFile("assets/images/sayori/3d.png", true)
  getFile("assets/images/sayori/4.png", true)
  getFile("assets/images/sayori/a.png", true)
  getFile("assets/images/sayori/b.png", true)
  getFile("assets/images/sayori/c.png", true)
  getFile("assets/images/sayori/d.png", true)
  getFile("assets/images/sayori/e.png", true)
  getFile("assets/images/sayori/f.png", true)
  getFile("assets/images/sayori/g.png", true)
  getFile("assets/images/sayori/h.png", true)
  getFile("assets/images/sayori/i.png", true)
  getFile("assets/images/sayori/j.png", true)
  getFile("assets/images/sayori/k.png", true)
  getFile("assets/images/sayori/l.png", true)
  getFile("assets/images/sayori/m.png", true)
  getFile("assets/images/sayori/n.png", true)
  getFile("assets/images/sayori/o.png", true)
  getFile("assets/images/sayori/p.png", true)
  getFile("assets/images/sayori/q.png", true)
  getFile("assets/images/sayori/r.png", true)
  getFile("assets/images/sayori/s.png", true)
  getFile("assets/images/sayori/t.png", true)
  getFile("assets/images/sayori/u.png", true)
  getFile("assets/images/sayori/v.png", true)
  getFile("assets/images/sayori/w.png", true)
  getFile("assets/images/sayori/x.png", true)
  getFile("assets/images/sayori/y.png", true)
  getFile("assets/images/sayori/1bl.png", true)
  getFile("assets/images/sayori/1br.png", true)
  getFile("assets/images/sayori/2bl.png", true)
  getFile("assets/images/sayori/2br.png", true)
  -- Pre-load chapter 0 script
  readScript("scripts/eng/script-ch0.lua")
  print("[DDLC] Assets ready, starting Chapter 0...")

  -- Set up for new game
  player = "Player"
  persistent.ptr = 0; persistent.chr = {m = 1, s = 1}
  bg1 = "black"; audio1 = "0"; cg1 = "blank"
  loadBar.Visible = false
  changeState("game", 1)
end

task.spawn(bootstrap)
print("[DDLC] DDLC-LOVE Ready!")
