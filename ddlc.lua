--[[
DDLC-ROBLOX - Doki Doki Literature Club
Based on DDLC-LOVE
Port to Roblox Executor by asianyuh
]]--

--[[ DDLC-ROBLOX Engine v1.0
     Love2D
     This file is part of the DDLC Roblox port
     All assets must be hosted on GitHub and URLs configured below.
--]]

-- ============================================================
-- CONFIGURATION - EDIT THESE FOR YOUR GITHUB REPO
-- ============================================================
GITHUB_USER = "k0nkx"
GITHUB_REPO = "DDLC"
GITHUB_BRANCH = "main"
GITHUB_BASE = "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. GITHUB_REPO .. "/" .. GITHUB_BRANCH
ASSET_URL = GITHUB_BASE .. "/assets"
SCRIPT_URL = GITHUB_BASE .. "/scripts"

-- ============================================================
-- EMBEDDED TEXT DATA (English)
-- ============================================================
tr = {}
tr.selectlang = "Select language:"
tr.auto = "Auto-Forward On"
tr.skip = "Skipping"
tr.missing = {
    'Error: Script file is missing or corrupt.\nPlease reinstall the game.',
    'OK'
}
tr.credits = {
    'Every day, I imagine a future where I can be with you',
    'In my hand is a pen that will write a poem of me and you',
    'The ink flows down into a dark puddle',
    'Just move your hand - write the way into his heart!',
    'But in this world of infinite choices',
    'What will it take just to find that special day?',
    'Concept and Game Design', 'Character Art', 'Background Art',
    'Writing', 'Music', 'Vocals', 'Special Thanks',
    'deleted successfully', 'Playing audio'
}
tr.names = {'Sayori','Natsuki','Yuri','Monika','Nat & Yuri'}
tr.poemtime = "\nIt's time to write a poem!\n\nPick words you think your favorite club member\nwill like. Something good might happen with\nwhoever likes your poem the most!\n"
tr.splash = {
    "You are my sunshine,\nMy only sunshine", "I missed you.", "Play with me",
    "It's just a game, mostly.",
    "This game is not suitable for children\nor those who are easily disturbed?",
    "sdfasdklfgsdfgsgoinrfoenlvbd", "null",
    "I have granted kids to hell", "PM died for this.",
    "It was only partially your fault.",
    "This game is not suitable for children\nor those who are easily dismembered.",
    "Don't forget to backup Monika's character file.",
    "This game is not suitable for children",
    "  or those who are easily disturbed.",
    "Now everyone can be happy.",
    "Unofficial port by LukeZGD"
}
tr.menuitem = {'Yes','No','Delete ','Restore All'}
tr.menuhelp = {
    ' - Advances through the game, activates menu choices',
    ' - Auto-Forward On/Off',
    ' - Skipping On/Off',
    ' - Enter Game Menu',
    ' - Exit Menu, Show/hide text window',
    'Managing files: Go to Settings > Characters',
    "\n\tDeleting save data: Delete the save folder:\n\t> ",
    "There's no point in saving anymore.\nDon't worry, I'm not going anywhere.",
    'Are you sure you want to return to the\nmain menu?',
    'Are you sure you want to quit the game?',
    "\n\tWelcome to the Literature Club!...",
    ' - Toggle text outline - toggle this for better readability'
}
tr.error = {
    'Press Y/Triangle to quit',
    "\nError!\nOld save data detected...\n> "
}
lang_names = {"English"}
lang_codes = {"eng"}

function lang_draw()
    -- Language selection screen
    menu_draw()
end

-- ============================================================
-- EXECUTOR DETECTION & GLOBALS
-- ============================================================
dversion = "v1.2.2-RBX"
dvertype = ""
global_os = "Roblox"
g_system = "Roblox"
is_running = false
state = "load"
event_enabled = false
menu_enabled = false
textbox_enabled = true
bgimg_disabled = false
poem_enabled = false
console_enabled = false
keyboard = false
style_edited = false
autotimer = 0
autoskip = 0
alpha = 255
bgalpha = 255
cgalpha = 255
posX = -40
posY = 0
menu_alpha = 0
getTime = 0
dt = 0.016
sectimer = 0
cl = 1
chapter = 0
bg1 = "black"
audio1 = "0"
cg1 = "blank"
ct = ""
m_selected = 2
menu_type = nil
menu_previous = nil
m_selected2 = nil
xaload = 0
choicepick = ""
poemsread = -1
savevalue = ""
savenumber = 1
y_timer = 0
titlebg_ypos = -240
unitimer = 0
uniduration = 0.25
tlp = {yx=525,nx=670,sx=470,mx=680,yy=850,ny=850,sy=850,my=850,scale=0.75}
z_timer = {0,0}
guictc_x = 1015
history = {}
c_disp = {}
textx = ""
last_text = ""
print_full_text = false
startTime = 0
l_timer = 0
s_timer = 0
random_msgchance = 0
random_msg = 0
splashx = 975
menu_alpha = 0
poemstate = 0
event_type = ""
poemstatetimer = 0
poemtime = nil; poemtime2 = nil
notebook = nil; notebook_glitch = nil
menutext = ""
stab1 = 0
menu_mchance = 0
poemgame_block = false
global_poemobj = {}
pickedpoem = ""; pickedchar = ""
ptext = {}; poemtext = {}
poem_scroll = {x=0, y=0}
console_text1 = ""; console_text2 = ""; console_text3 = ""; console_text4 = ""
menutext = ""

-- ============================================================
-- ROBLOX SERVICE CACHES
-- ============================================================
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")

-- ============================================================
-- MOBILE DETECTION & SCREEN SCALING
-- ============================================================
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local GAME_WIDTH = 1280
local GAME_HEIGHT = 720
local screenScaleX = 1
local screenScaleY = 1
local screenOffsetX = 0
local screenOffsetY = 0

local function updateScreenScale()
    local vp = workspace.CurrentCamera
    if vp then
        local vpSize = vp.ViewportSize
        if vpSize.X > 0 and vpSize.Y > 0 then
            screenScaleX = vpSize.X / GAME_WIDTH
            screenScaleY = vpSize.Y / GAME_HEIGHT
            local scale = math.min(screenScaleX, screenScaleY)
            screenScaleX = scale
            screenScaleY = scale
            screenOffsetX = (vpSize.X - GAME_WIDTH * scale) / 2
            screenOffsetY = (vpSize.Y - GAME_HEIGHT * scale) / 2
        end
    end
end

-- Scale coordinates for current screen
local function sx(x) return x * screenScaleX + screenOffsetX end
local function sy(y) return y * screenScaleY + screenOffsetY end
local function sv(v) return v * screenScaleX end

-- ============================================================
-- HTTP REQUEST (cross-executor compatible)
-- ============================================================
local downloadCount = 0
local totalDownloads = 0
local function printProgress(msg)
    print("[DDLC] " .. msg)
end

local function httpGet(url)
    local success, result = pcall(function()
        return HttpService:GetAsync(url, false)
    end)
    if success then return result end
    success, result = pcall(function()
        return syn.request({Url = url, Method = "GET"}).Body
    end)
    if success then return result end
    success, result = pcall(function()
        return request({Url = url, Method = "GET"}).Body
    end)
    if success then return result end
    success, result = pcall(function()
        return http_request({Url = url, Method = "GET"}).Body
    end)
    if success then return result end
    error("No HTTP function available - executor may be unsupported")
end

-- ============================================================
-- DRAWING WRAPPER
-- ============================================================
local drawObjects = {}
local drawOrder = {}
local currentColor = Color3.fromRGB(255,255,255)
local currentAlpha = 1.0
local bgColor = Color3.fromRGB(0,0,0)

local function newDrawObj(obj)
    table.insert(drawObjects, obj)
    table.insert(drawOrder, obj)
    return obj
end

function lgSetColor(r, g, b, a)
    if type(r) == "table" then
        currentColor = r
        currentAlpha = g or 1
    else
        currentColor = Color3.fromRGB(r or 255, g or 255, b or 255)
        currentAlpha = (a or 255) / 255
    end
end

function lgSetBackgroundColor(r, g, b)
    bgColor = Color3.fromRGB(r, g, b)
end

-- ============================================================
-- TEXT WIDTH ESTIMATION (monospace approximation)
-- ============================================================
local textWidthCache = {}
local function estimateTextWidth(text, size)
    local cacheKey = text .. "|" .. tostring(size)
    if textWidthCache[cacheKey] then return textWidthCache[cacheKey] end
    local w = 0
    for c in text:gmatch(".") do
        if c == " " then w = w + size * 0.3
        elseif c == "m" or c == "w" or c == "M" or c == "W" then w = w + size * 0.7
        elseif c == "i" or c == "l" or c == "I" or c == "t" then w = w + size * 0.35
        elseif c == "." or c == "," or c == ":" or c == ";" then w = w + size * 0.2
        elseif c >= "A" and c <= "Z" then w = w + size * 0.6
        else w = w + size * 0.5 end
    end
    textWidthCache[cacheKey] = w
    return w
end

-- ============================================================
-- RENDERING SYSTEM
-- ============================================================
local drawTexts = {}
local drawSquares = {}
local drawImages = {}
local drawLines = {}

function textObjCreate()
    local t = Drawing.new("Text")
    table.insert(drawTexts, t)
    return t
end

function squareObjCreate()
    local s = Drawing.new("Square")
    table.insert(drawSquares, s)
    return s
end

function imageObjCreate(url, callback)
    local img = Drawing.new("Image")
    if url then
        img.URL = url
    end
    img.Visible = false
    table.insert(drawImages, img)
    return img
end

function lineObjCreate()
    local l = Drawing.new("Line")
    table.insert(drawLines, l)
    return l
end

-- ============================================================
-- RENDER & UPDATE LOOP
-- ============================================================
local renderStepped
renderStepped = RunService.RenderStepped:Connect(function(stepDt)
    dt = stepDt
    getTime = getTime + dt
    sectimer = sectimer + dt
    if sectimer >= 1 then sectimer = 0 end
    
    -- Background
    posX = posX - dt * 37.5
    posY = posY - dt * 37.5
    if posX <= -200 then posX = 0 end
    if posY <= -200 then posY = 0 end
    
    -- Clear and draw background
    for _, v in pairs(drawSquares) do v.Visible = false end
    for _, v in pairs(drawTexts) do v.Visible = false end
    for _, v in pairs(drawImages) do v.Visible = false end
    for _, v in pairs(drawLines) do v.Visible = false end
    
    -- Game update and render
    if is_running then
        if state == "load" then updateLoad()
        elseif state == "splash" or state == "splash2" or state == "title" then updateSplash()
        elseif state == "game" or state == "newgame" then updateGame()
        elseif state == "poemgame" then updatePoemGame()
        elseif state == "poem_special" then updatepoem_special()
        elseif state == "s_kill_early" or state == "ghostmenu" then updateSplashspec()
        elseif state == "credits" then updateCredits()
        end
        if menu_enabled then menu_update() end
    end
    
    -- Draw
    if is_running then
        if event_enabled then event_draw()
        elseif state == "language" then lang_draw()
        elseif state == "load" then drawLoad()
        elseif state == "splash" or state == "splash2" or state == "title" then drawSplash()
        elseif state == "game" or state == "newgame" then drawGame()
        elseif state == "poemgame" then drawPoemGame()
        elseif state == "s_kill_early" or state == "ghostmenu" then drawSplashspec()
        elseif state == "poem_special" then drawpoem_special()
        elseif state == "credits" then drawCredits()
        end
        if isMobile then mobileDrawButtons() end
    end
end)

-- ============================================================
-- CLEANUP
-- ============================================================
function stopGame()
    is_running = false
    if renderStepped then renderStepped:Disconnect() end
    for _, v in pairs(drawTexts) do pcall(function() v:Remove() end) end
    for _, v in pairs(drawSquares) do pcall(function() v:Remove() end) end
    for _, v in pairs(drawImages) do pcall(function() v:Remove() end) end
    for _, v in pairs(drawLines) do pcall(function() v:Remove() end) end
    drawTexts = {}
    drawSquares = {}
    drawImages = {}
    drawLines = {}
end
cleanup = stopGame

-- ============================================================
-- ASSET CACHE
-- ============================================================
local imageCache = {}
local soundCache = {}

function loadImageFromURL(url, cacheKey)
    local key = cacheKey or url
    if imageCache[key] and imageCache[key].Visible == false then
        imageCache[key].Visible = false
        imageCache[key].URL = url
        return imageCache[key]
    end
    local img = imageObjCreate(url)
    imageCache[key] = img
    return img
end

function loadSoundFromURL(url)
    local sound = Instance.new("Sound")
    sound.SoundId = url
    sound.Volume = 0
    sound.Parent = SoundService
    return sound
end


--[[ Save/Load System - Roblox version ]]--

-- Random special poems
local spr = {}
sp = {}
for i = 1, 11 do
    spr[i] = i
end
for i = 1, 3 do
    local r = math.random(1, #spr)
    sp[i] = spr[r]
    table.remove(spr, r)
end

-- Default persistent values
player = ""
persistent = {ptr=0, clear={0,0,0,0,0,0,0,0,0}, chr={m=1,s=1}}
settings = {textspd=75, autospd=4, lang="eng", masvol=80, bgmvol=80, sfxvol=80, o=0}
persistent.act2 = {0,0,0,0}

s_Set = {a="",b="",x=-200,y=0}
y_Set = {a="",b="",x=-200,y=0}
n_Set = {a="",b="",x=-200,y=0}
m_Set = {a="",b="",x=-200,y=0}
readpoem = {s=0,n=0,y=0,m=0}
choices = {"","","",""}
s_poemappeal = {0,0,0}
n_poemappeal = {0,0,0}
y_poemappeal = {0,0,0}
poemwinner = {"","",""}
appeal = {s=0,n=0,y=0}

function savegame(x)
    local choiceset = ""
    for i = 1, 4 do
        if choices[i] and choices[i+1] then choiceset = choiceset..choices[i].."','"
        elseif choices[i] then choiceset = choiceset..choices[i] end
    end
    local data = "cl="..cl.."\nbg1='"..bg1.."'\naudio1='"..audio1.."'\ncg1='"..cg1.."'\nct='"..ct..
        "'\ns_Set={a='"..s_Set.a.."',b='"..s_Set.b.."',x="..s_Set.x..",y="..s_Set.y.."}"..
        "\ny_Set={a='"..y_Set.a.."',b='"..y_Set.b.."',x="..y_Set.x..",y="..y_Set.y.."}"..
        "\nn_Set={a='"..n_Set.a.."',b='"..n_Set.b.."',x="..n_Set.x..",y="..n_Set.y.."}"..
        "\nm_Set={a='"..m_Set.a.."',b='"..m_Set.b.."',x="..m_Set.x..",y="..m_Set.y.."}"..
        "\nchapter="..chapter.."\nreadpoem={s="..readpoem.s..",n="..readpoem.n..",y="..readpoem.y..",m="..readpoem.m.."}"..
        "\nchoices={'"..choiceset.."'}\nchoicepick='"..choicepick.."'\npoemsread="..poemsread..
        "\ns_poemappeal={"..s_poemappeal[1]..","..s_poemappeal[2]..","..s_poemappeal[3].."}"..
        "\nn_poemappeal={"..n_poemappeal[1]..","..n_poemappeal[2]..","..n_poemappeal[3].."}"..
        "\ny_poemappeal={"..y_poemappeal[1]..","..y_poemappeal[2]..","..y_poemappeal[3].."}"..
        "\npoemwinner={'"..poemwinner[1].."','"..poemwinner[2].."','"..poemwinner[3].."'}"..
        "\nappeal={s="..appeal.s..",n="..appeal.n..",y="..appeal.y.."}\nsavevalue='"..savevalue.."'"
    local fname = (x == "autoload") and "ddlc-save-autoload.txt" or "ddlc-save"..savenumber.."-"..persistent.ptr..".txt"
    pcall(writefile, fname, data)
end

function loadgame(x)
    local fname = (x == "autoload") and "ddlc-save-autoload.txt" or "ddlc-save"..savenumber.."-"..persistent.ptr..".txt"
    local success, data = pcall(readfile, fname)
    if success and data and data ~= "" then
        local func, err = loadstring(data)
        if func then pcall(func) end
    end
end

function savedatainfo(save)
    local data = "save"..save.."={bg1='"..bg1.."',date='"..os.date("%Y-%m-%d %H:%M").."'}"
    pcall(writefile, "ddlc-save"..savenumber.."-"..persistent.ptr.."_data.txt", data)
end

function loaddatainfo(save)
    local success, data = pcall(readfile, "ddlc-save"..save.."-"..persistent.ptr.."_data.txt")
    if success and data and data ~= "" then
        local func, err = loadstring(data)
        if func then return pcall(func) end
    end
    return false
end

function savesettings()
    local data = "settings={textspd="..settings.textspd..",autospd="..settings.autospd..
        ",masvol="..settings.masvol..",bgmvol="..settings.bgmvol..",sfxvol="..settings.sfxvol..
        ",lang='"..settings.lang.."',o="..settings.o.."}"
    pcall(writefile, "ddlc-settings.txt", data)
end

function loadsettings()
    local success, data = pcall(readfile, "ddlc-settings.txt")
    if success and data and data ~= "" then
        local func, err = loadstring(data)
        if func then pcall(func) end
    end
end

function savepersistent()
    local clear = ""
    for i = 1, #persistent.clear do
        if i > 1 then clear = clear .. "," end
        clear = clear .. tostring(persistent.clear[i])
    end
    local act2 = ""
    for i = 1, #persistent.act2 do
        if i > 1 then act2 = act2 .. "," end
        act2 = act2 .. tostring(persistent.act2[i])
    end
    local data = "player='"..player.."'\nsp={"..sp[1]..","..sp[2]..","..sp[3]..
        "}\npersistent={ptr="..persistent.ptr..",chr={m="..persistent.chr.m..",s="..persistent.chr.s..
        "},clear={"..clear.."},act2={"..act2.."}}"
    pcall(writefile, "ddlc-persistent.txt", data)
end

function loadpersistent()
    local success, data = pcall(readfile, "ddlc-persistent.txt")
    if success and data and data ~= "" then
        local func, err = loadstring(data)
        if func then pcall(func) end
    end
end

function game_setvolume()
    if not settings.masvol or not settings.bgmvol or not settings.sfxvol then
        settings.masvol = 80; settings.bgmvol = 80; settings.sfxvol = 80
    end
end


--[[ Drawing/Render System - Roblox Drawing API based ]]--

xps = {c=260,ct=285,textbox=230,namebox=260}
yps = {c={593,623,653,683},ct=532,textbox=565,namebox=527}
changeX = {s={x=0,y=0,z=0},y={x=0,y=0,z=0},n={x=0,y=0,z=0},m={x=0,y=0,z=0}}
with_r = {"1","1b","2","2b","3","3b","4","4b"}
with_yr = {"1","1b","2","2b","3","3b"}

-- Current font tracking
local currentFontSize = 16
local currentFont = 1

function lgPrint(text, x, y)
    if not text or text == "" then return end
    local t = textObjCreate()
    t.Text = tostring(text)
    t.Position = Vector2.new(sx(x or 0), sy(y or 0))
    t.Size = sv(currentFontSize)
    t.Font = currentFont
    t.Color = currentColor
    t.Transparency = currentAlpha
    t.Visible = true
end

function lgPrintf(text, x, y, width)
    if not text or text == "" then return end
    local t = textObjCreate()
    t.Text = tostring(text)
    t.Position = Vector2.new(sx(x or 0), sy(y or 0))
    t.Size = sv(currentFontSize)
    t.Font = currentFont
    t.Color = currentColor
    t.Transparency = currentAlpha
    t.Visible = true
end

function lgRectangle(mode, x, y, w, h)
    if mode == "fill" then
        local s = squareObjCreate()
        s.Position = Vector2.new(sx(x), sy(y))
        s.Size = Vector2.new(sv(w), sv(h))
        s.Color = currentColor
        s.Transparency = currentAlpha
        s.Visible = true
    end
end

function lgDraw(drawable, x, y, r, scalex, scaley)
    if not drawable then return end
    drawable.Position = Vector2.new(sx(x or 0), sy(y or 0))
    if drawable.Size then
        local ow = drawable.Size.X
        local oh = drawable.Size.Y
        if scalex and scaley then
            drawable.Size = Vector2.new(ow * scalex * screenScaleX, oh * scaley * screenScaleY)
        else
            drawable.Size = Vector2.new(ow * screenScaleX, oh * screenScaleY)
        end
    end
end

function lgSetFont(fontInfo)
    if type(fontInfo) == "table" and fontInfo.size then
        currentFontSize = fontInfo.size
        currentFont = fontInfo.font or 1
    elseif type(fontInfo) == "number" then
        currentFontSize = fontInfo
    end
end

function lgNewFont(name, size)
    local fontMap = {["Halogen.ttf"]=2, ["m1.ttf"]=1, ["y1.ttf"]=1, ["s1.ttf"]=1, ["n1.ttf"]=1}
    local font = 1
    if type(name) == "string" then
        for k, v in pairs(fontMap) do
            if name:find(k) then font = v; break end
        end
    end
    if name == "mono" or (type(name) == "string" and name:find("Mono")) then font = 3 end
    return {font=font, size=size or 16}
end

function wrap(str, limit)
    local here = 1
    local function check(sp, st, word, fi)
        if fi - here > limit then
            here = st
            return "\n" .. word
        end
    end
    return str:gsub("(%s+)()(%S+)()", check)
end

function easeQuadOut(t, b, c, d)
    t = t / d
    return -(c) * t * (t - 2) + b
end

function easeQuadInOut(t, b, c, d)
    t = t / (d / 2)
    if t < 1 then return c / 2 * t * t + b
    else
        t = t - 1
        return -c / 2 * (t * (t - 2) - 1) + b
    end
end

function easeCubicInOut(t, b, c, d)
    t = t / (d / 2)
    if t < 1 then return c / 2 * t * t * t + b
    else
        t = t - 2
        return c / 2 * (t * t * t + 2) + b
    end
end

function nearest(a, b)
    local n = 3
    return (a >= b - n) and (a <= b + n)
end

function dripText(text, cps, sTime)
    if text ~= last_text then
        sTime = getTime
        startTime = sTime
        last_text = text
        print_full_text = false
    end
    local cTime = getTime
    if (cTime <= sTime) or sTime == 0 then return "" end
    if not cps then cps = 100 end
    local length = math.floor((cTime - sTime) * cps)
    length = math.max(length, 1)
    length = math.min(length, text:len())
    if print_full_text then return text end
    if length == text:len() then print_full_text = true end
    return text:sub(1, length)
end

function outlineText(text, x, y, textType)
    if not text or text == "" then return end
    local addm = sv(1.5)
    if textType == "ct" then
        lgSetColor(187, 85, 153, 255)
        addm = sv(2.35)
    elseif textType == "m_selected" then
        lgSetColor(255, 189, 255, math.min(menu_alpha, 255))
    end
    
    local sxPos = sx(x)
    local syPos = sy(y)
    local fontSize = sv(currentFontSize)
    
    -- Shadow passes
    local shadowColor = Color3.fromRGB(0, 0, 0)
    
    local function shadowText(xo, yo)
        local t = textObjCreate()
        t.Text = tostring(text)
        t.Size = fontSize
        t.Font = currentFont
        t.Color = shadowColor
        t.Transparency = currentAlpha
        t.Position = Vector2.new(sxPos + xo, syPos + yo)
        t.Visible = true
    end
    shadowText(-addm, 0); shadowText(0, -addm)
    shadowText(addm, 0); shadowText(0, addm)
    
    -- Main text
    if textType == "ct" then lgSetColor(187, 85, 153, 255)
    elseif textType == "m_selected" then lgSetColor(255, 189, 255, math.min(menu_alpha, 255))
    else lgSetColor(255, 255, 255, 255) end
    local tm = textObjCreate()
    tm.Text = tostring(text)
    tm.Size = fontSize
    tm.Font = currentFont
    tm.Color = currentColor
    tm.Transparency = currentAlpha
    tm.Position = Vector2.new(sxPos, syPos)
    tm.Visible = true
end

function fadeOut(x)
    alpha = math.max(alpha - 2.5, 0)
    if alpha == 0 then
        if x == 1 then changeState("poemgame")
        elseif x == 2 then bg1 = "black"; changeState("game", 3)
        elseif x == 3 then chapter = chapter + 1; changeState("game", 3)
        elseif x == 4 then scriptJump(cl + 2); alpha = 255 end
    end
end

function glitchtext(range)
    local chars = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                   "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                   "0","1","2","3","4","5","6","7","8","9"}
    local s = ""
    for i = 1, range do
        s = s .. chars[math.random(1, #chars)]
    end
    return s
end

function space(range)
    local s = " "
    for i = 1, range do s = s .. " " end
    return s
end


--[[ Audio System - Downloads from GitHub, plays from executor file cache ]]--

audio_ext = ".ogg"
audio_wloop = {"1","2","3","4","4g","5","5_monika","5_natsuki","5_sayori","5_yuri","6","7g","8","10","d","monika-end"}
audio_bgm = nil
audio_bgmloop = nil
sfx1 = nil
sfx2 = nil
audioCacheDir = "DDLC/audio/"

-- Ensure audio cache directory exists
pcall(function()
    if not isfolder then return end
    if not isfolder("DDLC") then makefolder("DDLC") end
    if not isfolder(audioCacheDir) then makefolder(audioCacheDir) end
end)

-- Download audio file from GitHub and cache locally
function cacheAudioFile(url, cacheName)
    local localPath = audioCacheDir .. cacheName
    local needDownload = true
    pcall(function()
        if isfile and isfile(localPath) then needDownload = false end
    end)
    if needDownload then
        printProgress("Downloading audio: " .. cacheName)
        local success, data = pcall(httpGet, url)
        if success and data and #data > 100 then
            pcall(function() writefile(localPath, data) end)
            printProgress("  Saved: " .. cacheName .. " (" .. math.floor(#data/1024) .. "KB)")
            return localPath
        end
        printProgress("  Failed: " .. cacheName)
        return nil
    end
    return localPath
end

-- Try to play audio using any available executor API
function tryPlayAudio(filePath, volume, loop)
    if not filePath then return nil end
    -- Try syn.audio (Synapse-style)
    local success, player = pcall(function()
        local a = syn.audio.new(filePath)
        a:SetVolume(volume or 0.8)
        if loop then a:SetLooped(true) end
        a:Play()
        return a
    end)
    if success then return player end
    -- Try playaudio
    success, player = pcall(function()
        return playaudio(filePath, volume or 0.8, loop)
    end)
    if success then return player end
    -- Try audio.new (Script-Ware style)
    success, player = pcall(function()
        local a = audio.new(filePath)
        a:Play()
        if loop then a.Looped = true end
        return a
    end)
    if success then return player end
    return nil
end

function tryStopAudio(player)
    if not player then return end
    pcall(function()
        if player.Stop then player:Stop()
        elseif player.Stop then player:Stop() end
    end)
end

function trySetVolume(player, vol)
    if not player then return end
    pcall(function()
        if player.SetVolume then player:SetVolume(vol) end
    end)
end

function trySetLoop(player, loop)
    if not player then return end
    pcall(function()
        if player.SetLooped then player:SetLooped(loop)
        elseif player.Looped ~= nil then player.Looped = loop end
    end)
end

-- Main audio update function
function audioUpdate(audiox, forceload)
    if audio1 == audiox and not forceload then return end
    if audio_bgm then tryStopAudio(audio_bgm) end
    if audio_bgmloop then tryStopAudio(audio_bgmloop) end
    audio_bgm = nil
    audio_bgmloop = nil
    
    if audiox ~= "" and audiox ~= "0" then
        local url
        if audiox == "credits" or audiox == "end-voice" then
            url = ASSET_URL .. "/audio/bgm/" .. settings.lang .. "/" .. audiox .. audio_ext
        else
            url = ASSET_URL .. "/audio/bgm/" .. audiox .. audio_ext
        end
        local cacheName = "bgm_" .. audiox .. audio_ext
        local filePath = cacheAudioFile(url, cacheName)
        if filePath then
            audio_bgm = tryPlayAudio(filePath, (settings.bgmvol/100)*(settings.masvol/100), false)
            -- Handle loop tracks
            local loopFile = nil
            if audiox == "2g" then
                loopFile = cacheAudioFile(ASSET_URL .. "/audio/bgm/2-loop" .. audio_ext, "bgm_2-loop" .. audio_ext)
            elseif audiox == "3g" or audiox == "3g2" then
                loopFile = cacheAudioFile(ASSET_URL .. "/audio/bgm/3-loop" .. audio_ext, "bgm_3-loop" .. audio_ext)
            elseif audiox == "7" then
                local suffix = (persistent.ptr == 2) and "7a" or "7-loop"
                loopFile = cacheAudioFile(ASSET_URL .. "/audio/bgm/" .. suffix .. audio_ext, "bgm_" .. suffix .. audio_ext)
            end
            for i = 1, #audio_wloop do
                if audiox == audio_wloop[i] then
                    loopFile = cacheAudioFile(ASSET_URL .. "/audio/bgm/" .. audiox .. "-loop" .. audio_ext, "bgm_" .. audiox .. "-loop" .. audio_ext)
                end
            end
            if loopFile then
                audio_bgmloop = tryPlayAudio(loopFile, (settings.bgmvol/100)*(settings.masvol/100), true)
            else
                trySetLoop(audio_bgm, true)
            end
        end
    end
    audio1 = audiox
end

function sfxplay(sfx)
    if xaload == 0 and sfx and sfx ~= "" then
        local url = ASSET_URL .. "/audio/sfx/" .. sfx .. audio_ext
        local cacheName = "sfx_" .. sfx .. audio_ext
        local filePath = cacheAudioFile(url, cacheName)
        if filePath then
            tryPlayAudio(filePath, (settings.sfxvol/100)*(settings.masvol/100), false)
        end
    end
end

function sfxplay2(sfx)
    if sfx then
        pcall(function()
            if sfx.Play then sfx:Play()
            elseif sfx.play then sfx:play() end
        end)
    end
end

function game_setvolume()
    if not settings.masvol or not settings.bgmvol or not settings.sfxvol then
        settings.masvol = 80; settings.bgmvol = 80; settings.sfxvol = 80
    end
    local masvol = settings.masvol / 100
    local bgmvol = (settings.bgmvol / 100) * masvol
    if audio_bgm then trySetVolume(audio_bgm, bgmvol) end
    if audio_bgmloop then trySetVolume(audio_bgmloop, bgmvol) end
end


--[[ Input Handling System + Mobile Touch Support ]]--

local inputConnections = {}
local touchStartPos = nil
local touchStartTime = nil
local mobileButtonRects = {}
local mobileButtonsVisible = false

-- Touch zones for mobile (in game coordinates)
local mobileZones = {
    a = {x=1050, y=620, w=180, h=80},     -- Advance/Confirm
    b = {x=50, y=620, w=180, h=80},       -- Back/Pause
    menu = {x=50, y=50, w=180, h=60},     -- Menu
    skip = {x=1050, y=50, w=180, h=60},   -- Skip
    up = {x=1140, y=290, w=100, h=60},
    down = {x=1140, y=370, w=100, h=60},
}

function mobileDrawButtons()
    if not isMobile or keyboard then return end
    lgSetColor(255, 255, 255, 128)
    lgRectangle("fill", 1030, 610, 220, 100)
    lgRectangle("fill", 30, 610, 220, 100)
    lgRectangle("fill", 30, 40, 200, 70)
    lgRectangle("fill", 1030, 40, 220, 70)
    lgSetColor(0, 0, 0, 255)
    lgSetFont(allerfont)
    lgPrint("[A] Advance", 1050, 635)
    lgPrint("[B] Back", 50, 635)
    lgPrint("[Menu]", 50, 55)
    lgPrint("[Skip]", 1050, 55)
end

-- Map touch position to game coordinates
local function gameCoords(touchPos)
    local vp = workspace.CurrentCamera
    if not vp then return touchPos.X, touchPos.Y end
    local vs = vp.ViewportSize
    local gx = (touchPos.X - screenOffsetX) / screenScaleX
    local gy = (touchPos.Y - screenOffsetY) / screenScaleY
    return gx, gy
end

-- Check which mobile zone was tapped
local function checkMobileZones(gx, gy)
    for action, zone in pairs(mobileZones) do
        if gx >= zone.x and gx <= zone.x + zone.w and gy >= zone.y and gy <= zone.y + zone.h then
            return action
        end
    end
    return nil
end

-- Map touch to main game action (tap center = advance)
local function getTouchAction(gx, gy)
    local zone = checkMobileZones(gx, gy)
    if zone then return zone end
    -- Tap center of screen = advance
    if gx > 300 and gx < 980 and gy > 150 and gy < 550 then return "a" end
    return nil
end

-- Touch event handlers
local function onTouchBegan(touch)
    touchStartPos = Vector2.new(touch.Position.X, touch.Position.Y)
    touchStartTime = tick()
end

local function onTouchMoved(touch)
    -- Could be used for scrolling in poem game / history
end

local function onTouchEnded(touch)
    if not touchStartPos then return end
    local dx = math.abs(touch.Position.X - touchStartPos.X)
    local dy = math.abs(touch.Position.Y - touchStartPos.Y)
    local dt = tick() - touchStartTime
    
    if dt < 0.5 and dx < 50 and dy < 50 then
        -- It's a tap
        local gx, gy = gameCoords(touch.Position)
        local action = getTouchAction(gx, gy)
        if action then keypressed(action) end
    elseif dy > dx and dy > 50 then
        -- Swipe up/down
        if touch.Position.Y < touchStartPos.Y then keypressed("up")
        else keypressed("down") end
    end
    touchStartPos = nil
end

-- Keyboard input handler
local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local keyMap = {
            [Enum.KeyCode.Space] = "a", [Enum.KeyCode.Return] = "a",
            [Enum.KeyCode.Escape] = "b", [Enum.KeyCode.Backspace] = "b",
            [Enum.KeyCode.LeftShift] = "y", [Enum.KeyCode.RightShift] = "y",
            [Enum.KeyCode.One] = "y", [Enum.KeyCode.Two] = "r",
            [Enum.KeyCode.Three] = "start", [Enum.KeyCode.Four] = "back",
            [Enum.KeyCode.Up] = "up", [Enum.KeyCode.Down] = "down",
            [Enum.KeyCode.Left] = "left", [Enum.KeyCode.Right] = "right",
            [Enum.KeyCode.Z] = "a", [Enum.KeyCode.X] = "b", [Enum.KeyCode.C] = "y",
        }
        local mapped = keyMap[input.KeyCode]
        if mapped then keypressed(mapped) end
        if keyboard then
            local keyName = input.KeyCode.Name:lower()
            local dirs = {up=true,down=true,left=true,right=true}
            if dirs[keyName] then keyboard_keypressed(keyName)
            elseif input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.Space then
                keyboard_keypressed("a")
            elseif input.KeyCode == Enum.KeyCode.Backspace then
                keyboard_keypressed("b")
            end
        end
    end
end

local function onTextInput(text)
    if keyboard then return end
    if text ~= "" and m_selected ~= 3 then
        player = text; savepersistent(); cl = 1; changeState("game", 1)
    elseif m_selected == 3 then
        player = text; savepersistent()
    else changeState("title") end
end

function keypressed(key)
    if menu_enabled ~= true then
        if state == "splash" or state == "splash2" then splash_keypressed(key)
        elseif state == "game" then game_keypressed(key)
        elseif state == "newgame" then newgame_keypressed(key)
        elseif state == "poemgame" then poemgamekeypressed(key)
        elseif state == "poem_special" then poem_special_keypressed(key)
        elseif state == "load" then loadkeypressed(key)
        elseif (state == "s_kill_early" or state == "ghostmenu") and key == "y" then cleanup() end
    elseif keyboard then keyboard_keypressed(key)
    elseif menu_enabled then menu_keypressed(key) end
end

function initInput()
    table.insert(inputConnections, UserInputService.InputBegan:Connect(onInputBegan))
    table.insert(inputConnections, UserInputService.TouchStarted:Connect(onTouchBegan))
    table.insert(inputConnections, UserInputService.TouchMoved:Connect(onTouchMoved))
    table.insert(inputConnections, UserInputService.TouchEnded:Connect(onTouchEnded))
end

-- On-screen keyboard for player name input
local keyboard_textinput = ""
local keyboard_keycursorX = 1
local keyboard_keycursorY = 1
local keyboard_caps = false
local keyboard_keys = {
    {"1","2","3","4","5","6","7","8","9","0"},
    {"q","w","e","r","t","y","u","i","o","p"},
    {"a","s","d","f","g","h","j","k","l","X  Space"},
    {"z","x","c","v","b","n","m","","","X  Enter"},
}
local keyboard_keys_upper = {
    {"1","2","3","4","5","6","7","8","9","0"},
    {"Q","W","E","R","T","Y","U","I","O","P"},
    {"A","S","D","F","G","H","J","K","L","X  Space"},
    {"Z","X","C","V","B","N","M","","","X  Enter"},
}

function keyboard_draw()
    lgSetColor(255, 255, 255, menu_alpha / 2)
    lgRectangle("fill", 0, 0, 1280, 725)
    lgSetColor(255, 189, 225, menu_alpha)
    lgRectangle("fill", 270, 180, 630, 360)
    lgSetColor(255, 230, 244, menu_alpha)
    lgRectangle("fill", 280, 190, 610, 340)
    lgSetColor(0, 0, 0, 255)
    lgPrint("Player Name: " .. keyboard_textinput, 290, 220)
    local rows = keyboard_caps and keyboard_keys_upper or keyboard_keys
    for row = 1, 4 do
        for col = 1, 10 do
            if rows[row][col] ~= "" then
                lgPrint(rows[row][col], (50 * col) + 290, 250 + (50 * row))
            end
        end
    end
    if gui.keysbox then lgDraw(gui.keysbox, (keyboard_keycursorX * 50) + 282, (keyboard_keycursorY * 50) + 250) end
    lgPrint("Shift - Toggle Caps Lock", 290, 500)
end

function keyboard_keypressed(key)
    if key == "left" and keyboard_keycursorX > 1 then keyboard_keycursorX = keyboard_keycursorX - 1
    elseif key == "right" and keyboard_keycursorX < 10 then keyboard_keycursorX = keyboard_keycursorX + 1
    elseif key == "up" and keyboard_keycursorY > 0 then keyboard_keycursorY = keyboard_keycursorY - 1
    elseif key == "down" and keyboard_keycursorY < 4 then keyboard_keycursorY = keyboard_keycursorY + 1
    elseif key == "a" then
        local rows = keyboard_caps and keyboard_keys_upper or keyboard_keys
        local char = rows[keyboard_keycursorY + 1][keyboard_keycursorX]
        if keyboard_keycursorY == 2 and keyboard_keycursorX == 10 then
            keyboard_textinput = keyboard_textinput .. " "
        elseif keyboard_keycursorY == 3 and keyboard_keycursorX == 10 then
            keyboard = false; player = keyboard_textinput
            savepersistent(); cl = 1; changeState("game", 1)
        elseif char and char ~= "" then
            keyboard_textinput = keyboard_textinput .. char
        end
    elseif key == "b" then
        keyboard_textinput = string.sub(keyboard_textinput, 1, string.len(keyboard_textinput) - 1)
    elseif key == "y" then
        keyboard_caps = not keyboard_caps
    end
end

-- On mobile, use native text input instead of on-screen keyboard
if isMobile then
    keyboard_draw = function() end -- Disable on-screen keyboard drawing on mobile
    local function onMobileNameInput()
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(0, 400, 0, 50)
        textBox.Position = UDim2.new(0.5, -200, 0.5, -25)
        textBox.PlaceholderText = "Enter player name..."
        textBox.Text = ""
        textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        textBox.TextColor3 = Color3.fromRGB(0, 0, 0)
        textBox.BorderSizePixel = 2
        textBox.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        textBox:CaptureFocus()
        local conn
        conn = textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed and textBox.Text ~= "" then
                player = textBox.Text
                savepersistent()
                cl = 1
                changeState("game", 1)
            end
            textBox:Destroy()
            conn:Disconnect()
        end)
    end
    
    -- Override the keyboard activation in menu.lua
    local origMenuConfirm = menu_confirm
    menu_confirm = function()
        if menu_type == "title" and m_selected == 2 and player == "" then
            onMobileNameInput()
            return
        end
        origMenuConfirm()
    end
end

initInput()


--[[ Asset Loading System - loads from GitHub raw URLs ]]--

-- ============================================================
-- BACKGROUND LOADING
-- ============================================================
function bgUpdate(bgx, forceload)
    if bgx == "club_day2" then
        local r = math.random(1, 6)
        bgx = (r == 6) and "club-skill" or "club"
    end
    if xaload == 0 or forceload then
        bgch2 = bgch
        bgch = loadImageFromURL(ASSET_URL .. "/images/bg/" .. bgx .. ".jpg", "bg_" .. bgx)
    end
    bg1 = bgx
end

function cgUpdate(cgx, forceload)
    if cg1 ~= cgx or forceload then
        cgch2 = cgch
        cgch = loadImageFromURL(ASSET_URL .. "/images/cg/" .. cgx .. ".png", "cg_" .. cgx)
    end
    cg1 = cgx
end

function cgHide()
    cgUpdate("blank")
end

function loaderGame()
    if bgch2 then
        bgalpha = math.max(bgalpha - 15, 0)
        if bgalpha == 0 then bgalpha = 255; bgch2 = nil end
    end
    if cgch2 then
        cgalpha = math.max(cgalpha - 15, 0)
        if cgalpha == 0 then cgalpha = 255; cgch2 = nil end
    end
end

-- ============================================================
-- CHARACTER LOADING
-- ============================================================
function loadCharacter(set)
    local chr
    local asset1, asset2, asset3
    local lr = {"", ""}
    
    if set == s_Set then chr = "sayori"
    elseif set == y_Set then chr = "yuri"
    elseif set == n_Set then chr = "natsuki"
    elseif set == m_Set then chr = "monika" end
    
    if set.a == "1" then lr = {"1l","1r"}
    elseif set.a == "2" then lr = {"1l","2r"}
    elseif set.a == "3" and set ~= y_Set then lr = {"2l","1r"}
    elseif (set.a == "3" and set == y_Set) or (set.a == "4" and set ~= y_Set) then lr = {"2l","2r"}
    elseif set.a == "1b" then lr = {"1bl","1br"}
    elseif set.a == "2b" then lr = {"1bl","2br"}
    elseif set.a == "3b" and set ~= y_Set then lr = {"2bl","1br"}
    elseif (set.a == "3b" and set == y_Set) or (set.a == "4b" and set ~= y_Set) then lr = {"2bl","2br"}
    elseif (set.a == "4" and set == y_Set) or set.a == "5" then lr = {"3",""}
    elseif set.a == "5a" then lr = {"3a",""}
    elseif (set.a == "4b" and set == y_Set) or set.a == "5b" then lr = {"3b",""}
    elseif set.a == "5c" then lr = {"3c",""}
    elseif set.a == "5d" then lr = {"3d",""}
    elseif set.a then lr = {set.a, ""} end
    
    asset1 = loadImageFromURL(ASSET_URL .. "/images/" .. chr .. "/" .. lr[1] .. ".png", chr .. "_" .. lr[1])
    if lr[2] ~= "" then
        asset2 = loadImageFromURL(ASSET_URL .. "/images/" .. chr .. "/" .. lr[2] .. ".png", chr .. "_" .. lr[2])
    end
    if set.b ~= "" then
        asset3 = loadImageFromURL(ASSET_URL .. "/images/" .. chr .. "/" .. set.b .. ".png", chr .. "_" .. set.b)
    end
    return asset1, asset2, asset3
end

function loadSayori()
    sl, sr, s_a = loadCharacter(s_Set)
end
function unloadSayori()
    sl = nil; sr = nil; s_a = nil
end
function loadYuri()
    yl, yr, y_a = loadCharacter(y_Set)
end
function unloadYuri()
    yl = nil; yr = nil; y_a = nil
end
function loadNatsuki()
    nl, nr, n_a = loadCharacter(n_Set)
end
function unloadNatsuki()
    nl = nil; nr = nil; n_a = nil
end
function loadMonika()
    ml, mr, m_a = loadCharacter(m_Set)
end
function unloadMonika()
    ml = nil; mr = nil; m_a = nil
end
function loadAll()
    loadSayori(); loadNatsuki(); loadYuri(); loadMonika()
end
function unloadAll(x)
    if x == "poemgame" then
        s_sticker_1 = nil; s_sticker_2 = nil
        y_sticker_1 = nil; y_sticker_2 = nil
        n_sticker_1 = nil; n_sticker_2 = nil
        eyes = nil
    else
        unloadSayori(); unloadYuri(); unloadNatsuki(); unloadMonika()
    end
end

-- ============================================================
-- CHARACTER UPDATE FUNCTIONS
-- ============================================================
function updateCharacter(set, a, b, px, py, chset)
    if not b then b = "" end
    set.a = a
    set.b = b
    if px and xaload == 0 then
        chset.x = set.x
        chset.y = px * 3.2
        if chset.x < chset.y then chset.z = chset.y - chset.x
        elseif chset.x > chset.y then chset.z = chset.x - chset.y
        else chset.z = 0 end
    end
    if py then set.y = py end
end

function updateSayori(a, b, px, py)
    updateCharacter(s_Set, a, b, px, py, changeX.s)
    if xaload == 0 then loadSayori() end
end
function updateYuri(a, b, px, py)
    updateCharacter(y_Set, a, b, px, py, changeX.y)
    if xaload == 0 then loadYuri() end
end
function updateNatsuki(a, b, px, py)
    updateCharacter(n_Set, a, b, px, py, changeX.n)
    if xaload == 0 then loadNatsuki() end
end
function updateMonika(a, b, px, py)
    updateCharacter(m_Set, a, b, px, py, changeX.m)
    if xaload == 0 then loadMonika() end
end

function hideCharacter(set, chset)
    if xaload == 0 then
        chset.x = set.x
        chset.y = -675
        chset.z = chset.x - chset.y
    end
end
function hideSayori() hideCharacter(s_Set, changeX.s) end
function hideYuri() hideCharacter(y_Set, changeX.y) end
function hideNatsuki() hideCharacter(n_Set, changeX.n) end
function hideMonika() hideCharacter(m_Set, changeX.m) end

function hideAll()
    s_Set = {a="",b="",x=-675,y=4}
    y_Set = {a="",b="",x=-675,y=4}
    n_Set = {a="",b="",x=-675,y=4}
    m_Set = {a="",b="",x=-675,y=4}
    unloadAll()
end

-- ============================================================
-- DRAW CHARACTERS
-- ============================================================
function drawCharacter(l, r, a, set, chset)
    set.y = 0
    if set.b ~= "" then
        local xh = set.x
        local yh = set.y
        if set == n_Set and (n_Set.a == "5" or n_Set.a == "5b") then
            xh = set.x + 14; yh = set.y + 18
        end
        if a then lgDraw(a, xh, yh) end
    end
    lgDraw(l, set.x, set.y)
    local with_set = (set == y_Set) and with_yr or with_r
    for i = 1, #with_set do
        if with_set[i] == set.a then lgDraw(r, set.x, set.y) end
    end
    if set.x ~= chset.y and (autoskip >= 1 or unitimer >= uniduration) then
        set.x = chset.y
    elseif set.x < chset.y and not nearest(set.x, chset.y) then
        set.x = math.ceil(chset.x + easeQuadInOut(unitimer, 0, chset.z, uniduration))
    elseif set.x > chset.y and not nearest(set.x, chset.y) then
        set.x = math.floor(chset.x - easeQuadInOut(unitimer, 0, chset.z, uniduration))
    end
end

function drawSayori() drawCharacter(sl, sr, s_a, s_Set, changeX.s) end
function drawYuri() drawCharacter(yl, yr, y_a, y_Set, changeX.y) end
function drawNatsuki() drawCharacter(nl, nr, n_a, n_Set, changeX.n) end
function drawMonika() drawCharacter(ml, mr, m_a, m_Set, changeX.m) end


--[[ State Management & Game States ]]--

function changeState(cstate, x)
    menu_alpha = 0
    menu_previous = nil
    history = {}
    
    if cstate == "splash" then
        splash = loadImageFromURL(ASSET_URL .. "/images/bg/splash.jpg", "splash_bg")
        alpha = 0
        audioUpdate("1")
    elseif cstate == "title" then
        alpha = 0
        if (persistent.ptr == 1 or persistent.ptr == 2) and not menu_art_s_break then
            menu_art_s_break = loadImageFromURL(ASSET_URL .. "/images/gui/menu_art_s_break.png", "menu_art_s_break")
        elseif not menu_art_s then
            menu_art_s = loadImageFromURL(ASSET_URL .. "/images/gui/menu_art_s.png", "menu_art_s")
        end
        if persistent.ptr == 1 and not gui.newgame1 then
            gui.newgame1 = loadImageFromURL(ASSET_URL .. "/images/gui/" .. settings.lang .. "/newgame1.png", "newgame1")
        elseif not gui.newgame then
            gui.newgame = loadImageFromURL(ASSET_URL .. "/images/gui/" .. settings.lang .. "/newgame.png", "newgame")
        end
        if persistent.ptr == 4 and not menu_art_m then
            menu_art_m = loadImageFromURL(ASSET_URL .. "/images/cg/blank.png", "menu_art_m")
        elseif not menu_art_m then
            menu_art_m = loadImageFromURL(ASSET_URL .. "/images/gui/menu_art_m.png", "menu_art_m")
        end
        if not menu_art_n then menu_art_n = loadImageFromURL(ASSET_URL .. "/images/gui/menu_art_n.png", "menu_art_n") end
        if not menu_art_y then menu_art_y = loadImageFromURL(ASSET_URL .. "/images/gui/menu_art_y.png", "menu_art_y") end
        poem_enabled = false
        audioUpdate("1")
        menu_enable("title")
        y_timer = 0
        titlebg_ypos = -240
        tlp = {yx=525,nx=670,sx=470,mx=680,yy=850,ny=850,sy=850,my=850,scale=0.75}
        z_timer = {0,0}
    elseif cstate == "game" and x == 1 then
        cl = 1
        chapter = persistent.ptr * 10
        if persistent.ptr == 0 and persistent.chr.m == 0 then cl = 10001 end
    elseif cstate == "game" and (x == 2 or x == 3) then
        if x == 2 then loadgame()
        elseif x == 3 then cl = cl + 2 end
    elseif cstate == "game" and x == "autoload" then
        loadgame("autoload")
    elseif cstate == "newgame" then
        cl = 10016
    elseif cstate == "poemgame" then
        if persistent.ptr <= 2 then
            audioUpdate("4")
            bg1 = "notebook"
            if not notebook then notebook = loadImageFromURL(ASSET_URL .. "/images/bg/notebook.jpg", "notebook") end
        elseif persistent.ptr == 3 then
            audioUpdate("ghostmenu")
            notebook_glitch = loadImageFromURL(ASSET_URL .. "/images/bg/notebook-glitch.jpg", "notebook_glitch")
        end
        if poemstate == 0 and not poemtime then
            poemtime = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/poemtime.png", "poemtime")
            poemtime2 = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/poemtime2.png", "poemtime2")
        end
        if persistent.ptr <= 2 then
            if persistent.ptr == 0 and not s_sticker_1 then
                s_sticker_1 = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/s_sticker_1.png", "s_sticker_1")
                s_sticker_2 = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/s_sticker_2.png", "s_sticker_2")
            elseif not eyes then
                eyes = loadImageFromURL(ASSET_URL .. "/images/bg/eyes.jpg", "eyes")
                m_sticker_2 = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/m_sticker_2.png", "m_sticker_2")
                y_sticker_1_broken = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/y_sticker_1_broken.png", "y_sticker_1_broken")
                y_sticker_2g = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/y_sticker_2g.png", "y_sticker_2g")
            end
            if chapter == 22 then
                y_sticker_1 = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/y_sticker_cut_1.png", "y_sticker_cut_1")
                y_sticker_2 = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/y_sticker_cut_2.png", "y_sticker_cut_2")
            elseif not y_sticker_1 then
                y_sticker_1 = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/y_sticker_1.png", "y_sticker_1")
                y_sticker_2 = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/y_sticker_2.png", "y_sticker_2")
            end
            if not n_sticker_1 then
                n_sticker_1 = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/n_sticker_1.png", "n_sticker_1")
                n_sticker_2 = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/n_sticker_2.png", "n_sticker_2")
            end
        elseif not m_sticker_1 then
            m_sticker_1 = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/m_sticker_1.png", "m_sticker_1")
        end
        poemgame()
        alpha = 255
    elseif cstate == "s_kill_early" then
        loadNoise()
        bgSet = "black"
        endbg = loadImageFromURL(ASSET_URL .. "/images/gui/" .. settings.lang .. "/end.png", "endbg")
        s_killearly = loadImageFromURL(ASSET_URL .. "/images/cg/s_kill/s_kill_early.png", "s_killearly")
        audioUpdate("s_kill_early")
        y_timer = 0; alpha = 0
    elseif cstate == "ghostmenu" then
        endbg = loadImageFromURL(ASSET_URL .. "/images/gui/end.png", "endbg")
        menu_art_m = loadImageFromURL(ASSET_URL .. "/images/gui/menu_art_m_ghost.png", "menu_art_m_ghost")
        menu_art_s = loadImageFromURL(ASSET_URL .. "/images/gui/menu_art_s_ghost.png", "menu_art_s_ghost")
        menu_art_n = loadImageFromURL(ASSET_URL .. "/images/gui/menu_art_n_ghost.png", "menu_art_n_ghost")
        menu_art_y = loadImageFromURL(ASSET_URL .. "/images/gui/menu_art_y_ghost.png", "menu_art_y_ghost")
        y_timer = 0.7
        tlp = {yx=525,nx=670,sx=470,mx=680,yy=850,ny=850,sy=850,my=850,scale=0.75}
        z_timer = {0,0}
        audioUpdate("ghostmenu")
        alpha = 0
    elseif cstate == "poem_special" then
        poem_special_i(x)
    elseif cstate == "credits" then
        loadCredits(x)
    elseif cstate == "language" then
        menu_enable("language")
    end
    
    -- Load game state and scripts
    if cstate == "game" or cstate == "newgame" then
        if (bg1 == "notebook" and (x == 2 or x == "autoload")) or x == 0 then
            alpha = 20
        else
            alpha = 255
            loadAll()
            changeX.s.y = s_Set.x; changeX.y.y = y_Set.x
            changeX.n.y = n_Set.x; changeX.m.y = m_Set.x
            bgUpdate(bg1, true)
            audioUpdate(audio1, true)
            cgUpdate(cg1, true)
        end
        poem_enabled = false
        menu_enabled = false
        xaload = -1
        runChapterScript(chapter)
    end
    
    state = cstate
end

function runChapterScript(ch)
    printProgress("Loading chapter script: ch" .. ch)
    local url = SCRIPT_URL .. "/eng/script-ch" .. ch .. ".lua"
    local ok, data = pcall(httpGet, url)
    if ok and data then
        local func, err = loadstring(data)
        if func then pcall(func) end
        printProgress("  Chapter " .. ch .. " loaded")
    else
        printProgress("  ERROR: Chapter " .. ch .. " failed to load")
    end
    if persistent.ptr == 0 then
        local pw = poemwinner[chapter]
        if pw == "Sayori" then
            local ok2, d2 = pcall(httpGet, SCRIPT_URL .. "/eng/script-exclusives-sayori.lua")
            if ok2 then pcall(loadstring(d2)) end
        elseif pw == "Natsuki" then
            local ok2, d2 = pcall(httpGet, SCRIPT_URL .. "/eng/script-exclusives-natsuki.lua")
            if ok2 then pcall(loadstring(d2)) end
        elseif pw == "Yuri" then
            local ok2, d2 = pcall(httpGet, SCRIPT_URL .. "/eng/script-exclusives-yuri.lua")
            if ok2 then pcall(loadstring(d2)) end
        end
    elseif persistent.ptr == 2 and chapter > 20 then
        local pw = poemwinner[chapter - 20]
        if pw == "Natsuki" and chapter == 21 then
            local ok2, d2 = pcall(httpGet, SCRIPT_URL .. "/eng/script-exclusives2-natsuki.lua")
            if ok2 then pcall(loadstring(d2)) end
        elseif pw == "Yuri" or chapter > 21 then
            local ok2, d2 = pcall(httpGet, SCRIPT_URL .. "/eng/script-exclusives2-yuri.lua")
            if ok2 then pcall(loadstring(d2)) end
        end
    end
end


--[[ Loading Screen & Asset Preloader ]]--

gui = {}
menu_bg_m = nil
menu_bg = nil
namebox = nil
textbox = nil
notebook = nil
notebook_glitch = nil
poemtime = nil
poemtime2 = nil
splash = nil
endbg = nil
s_killearly = nil
menu_art_s = nil
menu_art_s_break = nil
menu_art_m = nil
menu_art_n = nil
menu_art_y = nil
bgch = nil
bgch2 = nil
cgch = nil
cgch2 = nil
splash = nil

-- Character sprite globals
sl = nil; sr = nil; s_a = nil
yl = nil; yr = nil; y_a = nil
nl = nil; nr = nil; n_a = nil
ml = nil; mr = nil; m_a = nil

-- Poem sticker globals
s_sticker_1 = nil; s_sticker_2 = nil
y_sticker_1 = nil; y_sticker_2 = nil
y_sticker_1_broken = nil; y_sticker_2g = nil
n_sticker_1 = nil; n_sticker_2 = nil
m_sticker_1 = nil; m_sticker_2 = nil
eyes = nil
vignette = nil

-- Font globals (we use font config tables instead)
dfnt = {font=3, size=23}
rifficfont = {font=1, size=24}
allerfont = {font=1, size=23}
halogenfont = {font=2, size=28}
m1 = {font=1, size=30}
y1 = {font=1, size=33}
s1 = {font=1, size=35}
n1 = {font=1, size=24}
consolefont = {font=3, size=18}

-- Sound globals
sfx1 = nil
sfx2 = nil

function loaderAssets(l_timer)
    if l_timer == 96 then
        lgSetFont(allerfont)
    elseif l_timer == 97 then
        menu_bg_m = loadImageFromURL(ASSET_URL .. "/images/gui/menu_bg_m.jpg", "menu_bg_m")
        gui.keysbox = loadImageFromURL(ASSET_URL .. "/images/gui/button/box.png", "keysbox")
        gui.mmenu = loadImageFromURL(ASSET_URL .. "/images/gui/overlay/main_menu.png", "mmenu")
        gui.gmenu = loadImageFromURL(ASSET_URL .. "/images/gui/overlay/game_menu.png", "gmenu")
    elseif l_timer == 98 then
        namebox = loadImageFromURL(ASSET_URL .. "/images/gui/namebox.png", "namebox")
        textbox = loadImageFromURL(ASSET_URL .. "/images/gui/textbox.png", "textbox")
        menu_bg = loadImageFromURL(ASSET_URL .. "/images/gui/menu_bg.jpg", "menu_bg")
        gui.check = loadImageFromURL(ASSET_URL .. "/images/gui/button/check_selected_foreground.png", "check")
        gui.ctc = loadImageFromURL(ASSET_URL .. "/images/gui/ctc.png", "ctc")
        gui.skip = loadImageFromURL(ASSET_URL .. "/images/gui/skip.png", "skip")
        gui.sidebar = loadImageFromURL(ASSET_URL .. "/images/gui/overlay/sidebar.png", "sidebar")
        gui.slothover = loadImageFromURL(ASSET_URL .. "/images/gui/button/slot_hover_background.png", "slothover")
        gui.scrbarh = loadImageFromURL(ASSET_URL .. "/images/gui/scrollbar/horizontal_poem_bar.png", "scrbarh")
        gui.scrhover = loadImageFromURL(ASSET_URL .. "/images/gui/slider/horizontal_hover_thumb.png", "scrhover")
    elseif l_timer == 101 then
        gui.mainbuttons = loadImageFromURL(ASSET_URL .. "/images/gui/" .. settings.lang .. "/mainbuttons.png", "mainbuttons")
        gui.gamebuttons = loadImageFromURL(ASSET_URL .. "/images/gui/" .. settings.lang .. "/gamebuttons.png", "gamebuttons")
        gui.history = loadImageFromURL(ASSET_URL .. "/images/gui/" .. settings.lang .. "/history.png", "history")
        gui.load = loadImageFromURL(ASSET_URL .. "/images/gui/" .. settings.lang .. "/load.png", "load")
        gui.save = loadImageFromURL(ASSET_URL .. "/images/gui/" .. settings.lang .. "/save.png", "save")
        gui.settings = loadImageFromURL(ASSET_URL .. "/images/gui/" .. settings.lang .. "/settings.png", "settings")
        gui.setbuttons = loadImageFromURL(ASSET_URL .. "/images/gui/" .. settings.lang .. "/setbuttons.png", "setbuttons")
    end
end

function drawLoad()
    -- Simple loading indicator
    lgSetColor(255, 255, 255, 255)
    lgPrint("DDLC-ROBLOX - Loading...", 540, 360)
    lgPrint(dversion .. " " .. dvertype, 540, 390)
end

function updateLoad()
    l_timer = l_timer + 1
    if l_timer < 50 then
        -- Wait
    elseif l_timer == 50 then
        printProgress("Loading save data...")
        loadpersistent()
        loadsettings()
        printProgress("  Save data loaded")
    elseif l_timer >= 96 and l_timer <= 105 then
        if l_timer == 96 then printProgress("Preloading assets from GitHub...") end
        loaderAssets(l_timer)
    elseif l_timer == 106 then
        printProgress("Assets ready, starting game...")
    end
    if l_timer >= 120 then
        if persistent.ptr == 4 then
            changeState("s_kill_early")
        elseif persistent.ptr >= 1 then
            if persistent.ptr == 1 then
                if l_timer >= 140 then changeState("splash") end
            elseif persistent.ptr == 2 then
                if l_timer >= 140 then changeState("splash") end
            elseif persistent.ptr == 3 then
                if l_timer >= 140 then changeState("ghostmenu") end
            end
        else
            changeState("splash")
        end
    end
end

function loadkeypressed(key)
    if key == "a" then
        if l_timer < 50 then l_timer = 50 end
    end
end


--[[ Splash & Title Screen (adapted from states/splash.lua) ]]--

function drawSplashChar()
    if menu_art_s_break then
        lgDraw(menu_art_s_break, 640, 298)
    elseif menu_art_s then
        lgDraw(menu_art_s, 640, 298)
    end
    if menu_art_n then lgDraw(menu_art_n, 640, 298) end
    if menu_art_y then lgDraw(menu_art_y, 640, 298) end
    if menu_art_m then lgDraw(menu_art_m, 640, 298) end
end

function updateSplashChar()
    local d = tlp.scale
    if y_timer < 0.2 then
        if menu_art_y then lgDraw(menu_art_y, 640, 298 - (y_timer * 1500), 0, d, d) end
    end
    if y_timer >= 0.2 and y_timer < 0.35 then
        if menu_art_n then lgDraw(menu_art_n, 640, 298 - (y_timer * 1500), 0, d, d) end
    end
    if y_timer >= 0.35 and y_timer < 0.55 then
        if menu_art_s_break then
            lgDraw(menu_art_s_break, 640, 298 - (y_timer * 1500), 0, d, d)
        elseif menu_art_s then
            lgDraw(menu_art_s, 640, 298 - (y_timer * 1500), 0, d, d)
        end
    end
    if y_timer >= 0.55 and y_timer < 0.7 then
        if menu_art_m then lgDraw(menu_art_m, 640, 298 - (y_timer * 1500), 0, d, d) end
    end
end

function drawSplash()
    if state == "splash" then
        lgSetBackgroundColor(255, 255, 255)
        lgSetColor(255, 255, 255, alpha)
        if splash then lgDraw(splash) end
        lgSetColor(0, 0, 0, alpha)
        lgPrint("DDLC-LOVE " .. dversion .. " " .. dvertype, 15, 675)
    elseif state == "splash2" then
        lgSetBackgroundColor(255, 255, 255)
        lgSetColor(0, 0, 0, alpha)
        lgPrint(tr.splash[13], 440, 300)
        lgPrint(tr.splash[14], 447, 330)
    elseif state == "title" then
        lgSetColor(255, 255, 255, alpha)
        if menu_bg then lgDraw(menu_bg, posX, posY) end
        if gui.sidebar then lgDraw(gui.sidebar, -720 + titlebg_ypos, 0) end
        drawSplashChar()
        if gui.mainbuttons then lgDraw(gui.mainbuttons) end
        if persistent.ptr == 1 and gui.newgame1 then lgDraw(gui.newgame1)
        elseif gui.newgame then lgDraw(gui.newgame) end
        lgSetColor(64, 64, 64, alpha)
        lgPrint(tr.splash[16], splashx, 10)
        menu_draw()
        if keyboard then keyboard_draw() end
    end
end

function updateSplash()
    s_timer = s_timer + dt
    if state == "splash" then
        if s_timer <= 3 then
            alpha = math.min(alpha + 7.75, 255)
        elseif s_timer > 3 then
            alpha = math.max(alpha - 7.75, 0)
            if alpha == 0 then state = "splash2" end
        end
    elseif state == "splash2" then
        if s_timer <= 6 then
            alpha = math.min(alpha + 7.75, 255)
        elseif s_timer > 6 and s_timer < 7 then
            alpha = math.max(alpha - 7.75, 0)
        elseif s_timer >= 7 then
            changeState("title")
        end
    elseif state == "title" then
        y_timer = y_timer + dt
        alpha = math.min(alpha + 5, 255)
        if y_timer > 0.7 and y_timer < 1.7 then
            titlebg_ypos = easeQuadOut(y_timer - 0.7, 0, 720, 1)
        end
    end
end

function splash_keypressed(key)
    if key == "a" then changeState("title") end
end

function drawSplashspec()
    lgSetColor(255, 255, 255, alpha)
    if s_timer > 3.1 then
        lgSetBackgroundColor(230, 230, 230)
        if state == "s_kill_early" then
            if s_killearly then lgDraw(s_killearly, 280, -5) end
            lgSetColor(160, 160, 160)
            lgSetFont(s1)
            if s_timer > 600 then lgPrint(tr.splash[15], 640, 300) end
        elseif state == "ghostmenu" then
            drawSplashChar()
        end
    end
end

function updateSplashspec()
    s_timer = s_timer + dt
    if state == "s_kill_early" then
        alpha = math.min(alpha + 2, 255)
    elseif state == "ghostmenu" then
        y_timer = y_timer + dt
        alpha = math.min(alpha + 5, 255)
        if y_timer > 0.7 and y_timer < 1.7 then
            titlebg_ypos = easeQuadOut(y_timer - 0.7, 0, 720, 1)
        end
        updateSplashChar()
    end
end


--[[ Game State - Main Visual Novel Engine ]]--

local skipspeed = 4
local textboxd = true

function drawTextBox()
    if sectimer >= 0.5 then guictc_x = math.max(guictc_x - dt * 5, 1015)
    else guictc_x = math.min(guictc_x + dt * 5, 1020) end
    
    if menu_type ~= "choice" and not poem_enabled then
        lgSetColor(255, 255, 255, alpha)
        if ct ~= "" and namebox then lgDraw(namebox, xps.namebox, yps.namebox) end
        if textbox then lgDraw(textbox, xps.textbox, yps.textbox) end
        if print_full_text and gui.ctc then lgDraw(gui.ctc, guictc_x, 685) end
        
        lgSetColor(0, 0, 0, alpha)
        lgSetFont(rifficfont)
        if ct ~= "" then outlineText(ct, xps.ct, yps.ct, "ct") end
        
        lgSetFont(allerfont)
        if c_disp[1] then outlineText(c_disp[1], xps.c, yps.c[1], "c_disp") end
    end
end

function drawGame()
    lgSetBackgroundColor(0, 0, 0)
    
    if menu_enabled and menu_type ~= "pause" and menu_type ~= "choice" and menu_type ~= "dialog" then
        menu_draw()
        return
    end
    
    lgSetColor(255, 255, 255, alpha)
    if bgch then lgDraw(bgch) end
    if cgch then lgDraw(cgch) end
    lgSetColor(255, 255, 255, bgalpha)
    if bgch2 then lgDraw(bgch2) end
    lgSetColor(255, 255, 255, cgalpha)
    if cgch2 then lgDraw(cgch2) end
    
    lgSetColor(255, 255, 255, alpha)
    drawSayori()
    drawYuri()
    drawNatsuki()
    drawMonika()
    
    if poem_enabled then drawPoem() end
    if textboxd then drawTextBox() end
    
    lgSetFont(allerfont)
    lgSetColor(255, 255, 255, alpha)
    if dvertype == "Test" then lgPrint(cl, 5, 690) end
    if autotimer > 0 then
        if gui.skip then lgDraw(gui.skip, 0, 27) end
        lgSetColor(0, 0, 0)
        outlineText(tr.auto, 5, 35)
    elseif autoskip > 0 then
        local skiptext
        if sectimer >= 0.75 then skiptext = tr.skip .. " >>>"
        elseif sectimer >= 0.5 then skiptext = tr.skip .. " >>"
        elseif sectimer >= 0.25 then skiptext = tr.skip .. " >"
        else skiptext = tr.skip end
        if gui.skip then lgDraw(gui.skip, 0, 27) end
        lgSetColor(0, 0, 0)
        outlineText(skiptext, 5, 35)
    end
    if menu_enabled then menu_draw() end
end

function updateGame()
    scriptCheck()
    
    if xaload == 0 then
        startTime = getTime
    end
    xaload = xaload + 1
    if unitimer < uniduration then unitimer = unitimer + dt end
    
    loaderGame()
    
    if autotimer == 0 then autotimer = 0
    elseif autotimer > 0 then autotimer = autotimer + dt end
    
    if menu_enabled == false and cl ~= 666 then
        if autoskip > 0 and autoskip < skipspeed then autoskip = autoskip + 1
        elseif autoskip >= skipspeed then
            autotimer = 0
            cl = cl + 1
            xaload = 0
            autoskip = 1
        end
    end
    
    if poem_enabled and poem_scroll and not menu_enabled then
        if UserInputService:IsKeyDown(Enum.KeyCode.Up) then
            poem_scroll.y = poem_scroll.y + dt * 25
        elseif UserInputService:IsKeyDown(Enum.KeyCode.Down) then
            poem_scroll.y = poem_scroll.y - dt * 25
        end
    end
end

function game_keypressed(key)
    if key == "a" or key == "leftshoulder" then
        if print_full_text or autoskip > 0 then
            if autotimer > 0 then
                autotimer = 0
            elseif menu_type ~= "choice" then
                cl = cl + 1
                xaload = 0
            end
        else
            print_full_text = true
        end
    elseif key == "y" or key == "rightshoulder" then
        if menu_type ~= "choice" then
            if autoskip > 0 then autoskip = 0
            else autoskip = 1 end
        end
    elseif key == "b" or key == "back" then
        menu_enable("pause")
    elseif key == "start" then
        if autotimer > 0 then autotimer = 0
        else autotimer = 0.01 end
    end
end

function newgame_keypressed(key)
    game_keypressed(key)
end

function drawPoem()
    lgSetColor(243, 243, 243)
    lgRectangle("fill", 240, 0, 800, 725)
    
    lgSetColor(0, 0, 0)
    if poemtext and poem_scroll then
        for i = 1, #poemtext do
            if poemtext[i] then
                lgPrint(poemtext[i], 250 + (poem_scroll.x * 30) - 30, ((poem_scroll.y * 24) + (i * 35)) - 25)
            end
        end
    end
end


--[[ Script Engine - Dialogue & Game Logic ]]--

local tagtimer = 0
local c_a1
local script_poemresponsesx = false
local h_items = 30
local pchapter

function cw(p1, stext, tag)
    if p1 == "s" then ct = tr.names[1]
    elseif p1 == "n" then ct = tr.names[2]
    elseif p1 == "y" then ct = tr.names[3]
    elseif p1 == "m" then ct = tr.names[4]
    elseif p1 == "ny" then ct = tr.names[5]
    elseif p1 == "mc" then ct = player
    elseif p1 == "bl" then ct = ""
    elseif p1 then ct = p1
    else ct = "Error" end
    
    if not stext then stext = "" end
    
    if settings.lang == "eng" and p1 ~= "bl" then
        stext = '"' .. stext .. '"'
    end
    
    local temptext = ct .. ": " .. stext
    
    if history[1] ~= stext and history[1] ~= temptext then
        for i = h_items, 1, -1 do
            history[i] = history[i - 1]
        end
        if style_edited then history[1] = ""
        elseif ct == "" then history[1] = stext
        else history[1] = temptext end
    end
    
    local tspd
    if autoskip > 0 then tspd = 10000
    elseif tag == "fast" or tag == "nwfast" then tspd = 250
    elseif tag == "slow" then tspd = 25
    elseif chapter == 30 then tspd = 50
    else tspd = settings.textspd end
    
    textx = dripText(stext, tspd, startTime)
    
    if style_edited then c_a1 = {40,104,156}
    else c_a1 = {65,140,210} end
    
    c_disp[1] = wrap(textx, c_a1[1])
    
    local slen = string.len(stext)
    if tag then
        tagtimer = tagtimer + (settings.textspd / 100)
        if tagtimer >= (settings.textspd + slen) / 4 then
            if tag == "nw" or tag == "nwfast" then scriptJump(cl + 1) end
            tagtimer = 0
            if autotimer > 0 then autotimer = 0.01 end
        end
    elseif autotimer > 0 then
        tagtimer = tagtimer + (settings.textspd / 100)
        if tagtimer >= ((settings.textspd + slen) / 4 + (settings.autospd * 25)) then
            scriptJump(cl + 1)
            tagtimer = 0
            autotimer = 0.01
        end
    else
        tagtimer = 0
    end
end

function bl(say) return cw("bl", say) end
function mc(say) return cw("mc", say) end
function s(say) return cw("s", say) end
function n(say) return cw("n", say) end
function y(say) return cw("y", say) end
function m(say) return cw("m", say) end

function pause(t, f)
    if f == "disable" then textbox_enabled = false end
    autotimer = 0
    tagtimer = tagtimer + dt
    print_full_text = false
    ct = ""
    if tagtimer >= t then
        scriptJump(cl + 1)
        tagtimer = 0
        textbox_enabled = true
    end
end

function scriptJump(nu, fu, au)
    xaload = -1
    unitimer = 0
    if nu then cl = nu end
    if au then autotimer = au; autoskip = au end
    if fu and fu ~= "" then
        local func = loadstring(fu .. "()")
        if func then pcall(func) end
    end
end

function choice_enable(x)
    if menu_enabled ~= true then
        if x == "dialog" then menu_enable("dialog")
        else menu_enable("choice") end
        autotimer = 0
        autoskip = 0
        ct = ""
    end
end

function poeminitialize(y)
    poemsread = 0
    readpoem = {s=0,n=0,y=0,m=0}
    if persistent.ptr == 0 then
        choices = {tr.names[1],tr.names[2],tr.names[3],tr.names[4]}
    elseif y == "y_ranaway" then
        choices = {tr.names[2],tr.names[4]}
    else
        choices = {tr.names[2],tr.names[3],tr.names[4]}
    end
    scriptJump(666, "", 0)
end

function scriptCheck()
    c_disp = {"","","",""}
    
    if poemsread ~= -1 and not script_poemresponsesx then
        script_poemresponsesx = true
        -- Load poem responses from GitHub
        loadPoemResponses()
    elseif poemsread == -1 then
        script_poemresponsesx = false
    end
    
    if persistent.ptr == 2 then pchapter = chapter - 20
    else pchapter = chapter end
    
    local aa
    if poemwinner[pchapter] == "Sayori" then aa = "s"
    elseif poemwinner[pchapter] == "Natsuki" then aa = "n"
    elseif poemwinner[pchapter] == "Yuri" then aa = "y" end
    
    if aa and persistent.ptr == 0 and chapter ~= 4 and ((cl >= 423 and cl < 652) or (cl >= 1359 and cl < 1638)) then
        local fnName = poemwinner[pchapter] .. "_exclusive_" .. tostring(appeal[aa])
        local fn = _G[fnName]
        if fn then fn() end
    elseif aa and persistent.ptr == 2 and cl >= 358 and cl < 665 then
        local fnName = poemwinner[pchapter] .. "_exclusive2_" .. tostring(appeal[aa])
        local fn = _G[fnName]
        if fn then fn() end
    elseif persistent.ptr == 2 and cl >= 1235 and cl <= 1445 then
        local fn = _G["Yuri_exclusive2_2_ch22"]
        if fn then fn() end
    elseif persistent.ptr == 0 and cl == 652 and chapter >= 2 and chapter ~= 4 then
        poeminitialize()
    else
        local fnName = "ch" .. chapter .. "script"
        local fn = _G[fnName]
        if fn then fn() end
    end
end

function loadPoemResponses()
    printProgress("Loading poem response scripts...")
    local ok, data = pcall(httpGet, SCRIPT_URL .. "/eng/script-poemresponses.lua")
    if ok then pcall(loadstring(data)) end
    ok, data = pcall(httpGet, SCRIPT_URL .. "/eng/poems.lua")
    if ok then pcall(loadstring(data)) end
    ok, data = pcall(httpGet, SCRIPT_URL .. "/eng/poemwords.lua")
    if ok then pcall(loadstring(data)) end
    if persistent.ptr == 0 then
        ok, data = pcall(httpGet, SCRIPT_URL .. "/eng/script-poemresponses1.lua")
        if ok then pcall(loadstring(data)) end
    else
        ok, data = pcall(httpGet, SCRIPT_URL .. "/eng/script-poemresponses2.lua")
        if ok then pcall(loadstring(data)) end
    end
    printProgress("  Poem scripts loaded")
end

function updateConsole(text, text2, text3, text4)
    if not console_enabled then console_enabled = true end
    console_text1 = dripText(text, 30, startTime)
    console_text2 = text2 or ""
    console_text3 = text3 or ""
    console_text4 = text4 or ""
end


--[[ Event System (adapted from scripts/event.lua & loader/events.lua) ]]--

event_timer = 0
eventvar1 = 0
eventvar2 = 0
eventvar3 = 0
eventvar4 = 0
eventvar5 = 0
animframe = {}

function loadNoise()
    for i = 1, 4 do
        animframe[i] = loadImageFromURL(ASSET_URL .. "/images/bg/noise" .. i .. ".jpg", "noise_" .. i)
    end
end

function loadVignette()
    vignette = loadImageFromURL(ASSET_URL .. "/images/cg/vignette.png", "vignette")
end

function loadYuriGlitch()
    for i = 1, 4 do
        animframe[i] = loadImageFromURL(ASSET_URL .. "/images/yuri/glitch" .. i .. ".png", "yglitch_" .. i)
    end
end

function event_start(etype, arg1)
    autotimer = 0
    autoskip = 0
    event_enabled = true
    event_type = etype
    
    if etype == "s_kill_start" then
        textbox_enabled = true
        bgimg_disabled = true
    elseif string.sub(etype, 1, 6) == "s_kill" then
        bgimg_disabled = true
        textbox_enabled = false
        if etype == "s_kill" then eventvar1 = 0; eventvar2 = 0 end
    elseif etype == "wipe" then
        eventvar1 = 0; hideAll(); textbox_enabled = false
        eventvar2 = arg1
    elseif etype == "black" then textbox_enabled = true; bgimg_disabled = true
    elseif etype == "endscreen" then hideAll(); textbox_enabled = false; audioUpdate("0")
    elseif etype == "ny_argument" then
        eventvar1 = 0; eventvar2 = 0
        eventvar3 = {2.0,3.6,5.2,6.8,8.3,9.90,11.5,13.1,14.7,16.3,17.90,19.45,21.1,22.7,24.2,25.8}
        eventvar4 = {2.5,4.1,5.7,7.3,8.8,10.3,12.0,13.5,15.1,16.7,18.25,19.85,21.5,23.0,24.6,26.2}
        eventvar5 = 1; bgimg_disabled = false; textbox_enabled = true
    elseif etype == "yuri_eyes" then
        bgimg_disabled = false; textbox_enabled = false
        eventvar1 = 2; eventvar2 = -13; eventvar3 = 0
    elseif etype == "faint_effect" then eventvar1 = 192; bgimg_disabled = false; textbox_enabled = true
    elseif etype == "yuri_glitch_head" then eventvar1 = arg1; bgimg_disabled = false; textbox_enabled = true
    elseif etype == "show_darkred" then eventvar2 = 1; bgimg_disabled = false; textbox_enabled = true
    elseif etype == "yuri_ch23_2" or etype == "natsuki_ch22" then
        eventvar1 = 0; eventvar2 = 0; eventvar3 = 0; bgimg_disabled = false; textbox_enabled = true
    elseif etype == "yuri_ch23" or etype == "m_ch23ex" or etype == "just_monika" then
        bgimg_disabled = true; textbox_enabled = false
        if etype == "just_monika" then alpha = 0
            if arg1 == "ch30" then eventvar1 = "ch30" end
        end
    elseif etype == "yuri_kill" then
        eventvar1 = stab1; eventvar2 = 0; eventvar3 = 0.025; bgimg_disabled = true; textbox_enabled = false
    elseif etype == "monika_end" then
        eventvar1 = 200; eventvar2 = math.random(1,8)*50; eventvar3 = math.random(1,8)*50; eventvar5 = 0
        bgimg_disabled = false; textbox_enabled = false
        if arg1 == 2 then event_timer = 0.69; eventvar4 = "end2" end
    elseif etype == "beforecredits" or etype == "sayori_gs" then
        if etype == "beforecredits" then audioUpdate("end-voice") end
        eventvar1 = 0; eventvar2 = nil; eventvar3 = 0
        bgimg_disabled = true; textbox_enabled = false
    else
        bgimg_disabled = false; textbox_enabled = true
    end
    
    if arg1 == "show_noise" then eventvar4 = "show_noise"
    elseif arg1 == "show_vignette" then eventvar4 = "show_vignette"
    elseif arg1 == "show_darkred" then eventvar4 = "show_darkred"
    elseif arg1 == "" then eventvar4 = "" end
end

function event_init(etype, arg1, arg2)
    if xaload == 1 then
        -- Load event sub-scripts from GitHub
        local evt = persistent.ptr <= 1 and "event-1" or (persistent.ptr == 2 and "event-2" or "event-3")
        printProgress("Loading event script: " .. evt)
        local ok, evtData = pcall(httpGet, SCRIPT_URL .. "/" .. evt .. ".lua")
        if ok then pcall(loadstring(evtData)); printProgress("  Event script loaded") end
        if etype == "s_kill" then
            s_kill = loadImageFromURL(ASSET_URL .. "/images/cg/s_kill/s_kill.png", "s_kill")
            s_kill2 = loadImageFromURL(ASSET_URL .. "/images/cg/s_kill/s_kill2.png", "s_kill2")
            s_killzoom = loadImageFromURL(ASSET_URL .. "/images/cg/s_kill/s_killzoom.png", "s_killzoom")
            s_kill_bg = loadImageFromURL(ASSET_URL .. "/images/bg/s_kill/s_kill_bg.jpg", "s_kill_bg")
            s_kill_bg2 = loadImageFromURL(ASSET_URL .. "/images/bg/s_kill/s_kill_bg2.jpg", "s_kill_bg2")
            s_kill_bgzoom = loadImageFromURL(ASSET_URL .. "/images/bg/s_kill/s_kill_bgzoom.jpg", "s_kill_bgzoom")
            splash_glitch = loadImageFromURL(ASSET_URL .. "/images/bg/splash-glitch.jpg", "splash_glitch")
            exception = loadImageFromURL(ASSET_URL .. "/images/bg/s_kill/ex2.jpg", "exception")
            loadNoise()
        elseif etype == "endscreen" then
            local fname = (arg1 == "flipped") and "endflipped" or "end"
            bgch = loadImageFromURL(ASSET_URL .. "/images/gui/" .. settings.lang .. "/" .. fname .. ".png", "endscreen")
        elseif etype == "s_glitch" then
            s_glitch1 = loadImageFromURL(ASSET_URL .. "/images/sayori/glitch1.png", "s_glitch1")
            s_glitch2 = loadImageFromURL(ASSET_URL .. "/images/sayori/glitch2.png", "s_glitch2")
        elseif etype == "m_glitch1" then
            ml = loadImageFromURL(ASSET_URL .. "/images/monika/g2.png", "m_glitch1")
        elseif etype == "n_glitch1" then
            nl = loadImageFromURL(ASSET_URL .. "/images/natsuki/glitch1.png", "n_glitch1")
        elseif etype == "n_blackeyes" then
            n_blackeyes = loadImageFromURL(ASSET_URL .. "/images/natsuki/blackeyes.png", "n_blackeyes")
            n_eye = loadImageFromURL(ASSET_URL .. "/images/natsuki/eye.png", "n_eye")
        elseif etype == "ny_argument" then
            loadVignette(); loadNoise()
        elseif etype == "ny_argument2" then
            ml = loadImageFromURL(ASSET_URL .. "/images/monika/ac.png", "ny_arg2")
        elseif etype == "yuri_glitch" then
            loadYuriGlitch()
        elseif etype == "show_vignette" then
            loadVignette()
        elseif etype == "yuri_eyes" then
            eyes1 = loadImageFromURL(ASSET_URL .. "/images/yuri/eyes1.png", "eyes1")
            eyes2 = loadImageFromURL(ASSET_URL .. "/images/yuri/eyes2.png", "eyes2")
        elseif etype == "yuri_glitch_head" then
            animframe = {}
            animframe[1] = loadImageFromURL(ASSET_URL .. "/images/yuri/za.png", "yza")
            animframe[2] = loadImageFromURL(ASSET_URL .. "/images/yuri/zb.png", "yzb")
            animframe[3] = loadImageFromURL(ASSET_URL .. "/images/yuri/zc.png", "yzc")
            animframe[4] = loadImageFromURL(ASSET_URL .. "/images/yuri/zd.png", "yzd")
        elseif etype == "yuri_ch23" then
            bg_glitch = loadImageFromURL(ASSET_URL .. "/images/bg/glitch.jpg", "bg_glitch")
            eyes1 = loadImageFromURL(ASSET_URL .. "/images/yuri/eyes1.png", "eyes1")
            loadYuriGlitch()
        elseif etype == "m_ch23ex" then
            ex3top = loadImageFromURL(ASSET_URL .. "/images/bg/ex3top.jpg", "ex3top")
        elseif etype == "just_monika" then
            if arg1 == "ch30" then
                splash = loadImageFromURL(ASSET_URL .. "/images/bg/splash-glitch2.jpg", "splash_glitch2")
            else
                splash = loadImageFromURL(ASSET_URL .. "/images/bg/splash.jpg", "splash_bg")
            end
        elseif etype == "natsuki_ch22" then
            ghost_blood = loadImageFromURL(ASSET_URL .. "/images/natsuki/ghost_blood.png", "ghost_blood")
            ghost3 = loadImageFromURL(ASSET_URL .. "/images/natsuki/ghost3.png", "ghost3")
            ghost3_1 = loadImageFromURL(ASSET_URL .. "/images/natsuki/ghost3-1.png", "ghost3_1")
            ghost3_2 = loadImageFromURL(ASSET_URL .. "/images/natsuki/ghost3-2.png", "ghost3_2")
        end
        event_start(etype, arg1)
    elseif xaload > 0 then
        event_start(etype, arg1)
    end
end

function event_next()
    print_full_text = true
    newgame_keypressed("a")
    event_timer = 0
end

function event_keypressed(key)
    if (textbox_enabled and event_type ~= "show_vignette") or (event_type == "yuri_eyes" and cl < 700) then
        if key == "a" or key == "leftshoulder" then newgame_keypressed("a") end
    elseif key == "y" and event_type == "ch23-30" then
        menu_mchance = math.random(1,50)
        menu_enable("pause")
    elseif (key == "start" or key == "return") and event_type == "ch23-30" and chapter == 30 then
        if autotimer == 0 then autotimer = 0.01 else autotimer = 0 end
    elseif (key == "back" or key == "-") and event_type == "ch23-30" then
        if settings.o ~= 1 then settings.o = 1 else settings.o = 0 end
    end
end

function event_draw()
    lgSetColor(255,255,255)
    if persistent.ptr <= 1 then
        if event_draw_1 then event_draw_1() end
    elseif persistent.ptr == 2 then
        if event_draw_2 then event_draw_2() end
    else
        if event_draw_3 then event_draw_3() end
    end
    
    if event_type == "wipe" then
        if bgch then lgDraw(bgch) end
        lgSetColor(0,0,0,eventvar1)
        lgRectangle("fill",0,0,1280,725)
    end
end

function drawanimframe(x, y, s)
    if not x then x = 0 end
    if not y then y = 0 end
    if not s then s = 1 end
    local currentframe = 1
    if sectimer > 0.75 and animframe[4] then currentframe = 4
    elseif sectimer > 0.5 and animframe[3] then currentframe = 3
    elseif sectimer > 0.25 and animframe[2] then currentframe = 2
    elseif animframe[1] then currentframe = 1 end
    if animframe[currentframe] then lgDraw(animframe[currentframe], x, y) end
end


--[[ Poem Game State (adapted from states/poemgame.lua) ]]--

poemstate = 0
poemtime = nil
poemtime2 = nil
poemgame_block = false
global_poemobj = {}
pickedpoem = ""
pickedchar = ""
poemwinner_act = {}
ptext = {}
poemtext = {}
poem_scroll = {x=0, y=0}

function drawPoemGame()
    lgSetBackgroundColor(0, 0, 0)
    if poemstate == 0 then
        lgSetColor(255, 255, 255, alpha)
        if poemtime then lgDraw(poemtime) end
        if poemtime2 then lgDraw(poemtime2) end
    elseif poemstate == 1 then
        lgSetColor(255, 255, 255, alpha)
        if notebook then lgDraw(notebook) end
        if s_sticker_1 or s_sticker_2 then
            if s_sticker_1 then lgDraw(s_sticker_1) end
        end
        if n_sticker_1 or n_sticker_2 then
            if n_sticker_1 then lgDraw(n_sticker_1) end
        end
        if y_sticker_1 or y_sticker_2 then
            if y_sticker_1 then lgDraw(y_sticker_1) end
        end
    elseif poemstate == 2 then
        drawPoem()
    end
    if menu_enabled then menu_draw() end
end

function updatePoemGame()
    if menu_enabled == false then
        if poemstate == 0 then
            poemstatetimer = poemstatetimer + dt
        elseif poemstate == 1 then
            -- Sticker selection
        end
    end
end

function poemgamekeypressed(key)
    if key == "a" then
        if poemstate == 0 then
            poemstate = 1
            poemstatetimer = 0
        elseif poemstate == 1 then
            if pickedpoem ~= "" then
                poemgame_block = false
                -- Process poem choice
                poemsread = poemsread + 1
                for i = 1, 3 do
                    if global_poemobj[i] and global_poemobj[i].text then
                        ptext[i] = global_poemobj[i].text
                    end
                end
                poemstate = 2
            end
        elseif poemstate == 2 then
            if menu_type ~= "choice" then
                fadeOut(2)
            end
        end
    elseif key == "y" and poemstate == 1 then
        poemgame_block = not poemgame_block
    end
end

function poemgame()
    -- Initialize poem game
    poemstate = 0
    poemstatetimer = 0
    pickedpoem = ""
    pickedchar = ""
    global_poemobj = {}
    ptext = {}
end

function poemgame_updateappeal(char)
    if char == "Sayori" then
        s_poemappeal = {s_poemappeal[1]+1, s_poemappeal[2]+1, s_poemappeal[3]+1}
        if persistent.ptr == 0 then appeal.s = appeal.s + 1 end
    elseif char == "Natsuki" then
        n_poemappeal = {n_poemappeal[1]+1, n_poemappeal[2]+1, n_poemappeal[3]+1}
        if persistent.ptr == 0 then appeal.n = appeal.n + 1 end
    elseif char == "Yuri" then
        y_poemappeal = {y_poemappeal[1]+1, y_poemappeal[2]+1, y_poemappeal[3]+1}
        if persistent.ptr == 0 then appeal.y = appeal.y + 1 end
    end
end

function drawPoem()
    lgSetColor(243,243,243)
    lgRectangle("fill",240,0,800,725)
    lgSetColor(0,0,0)
    if poemtext and poem_scroll then
        for i = 1, #poemtext do
            if poemtext[i] then
                lgPrint(poemtext[i],250 + (poem_scroll.x * 30) - 30, ((poem_scroll.y * 24) + (i * 35)) - 25)
            end
        end
    end
end


--[[ Credits & Poem Special States (adapted from states/credits.lua, states/poem_special.lua) ]]--

-- Credits
credits_timer = 0
credits_img = nil
nats1=nil; nats2=nil; nats3=nil
yuri1=nil; yuri2=nil; yuri3=nil
sayo1=nil; sayo2=nil; sayo3=nil
moni1=nil; splashw=nil

function loadCredits(x)
    credits_timer = 0
    credits_img = nil
    nats1=nil; nats2=nil; nats3=nil
    yuri1=nil; yuri2=nil; yuri3=nil
    sayo1=nil; sayo2=nil; sayo3=nil
    moni1=nil; splashw=nil
end

function loaderCredits(c_timer)
    if c_timer >= 60 and c_timer < 75 then
        if not nats1 then
            nats1 = loadImageFromURL(ASSET_URL .. "/images/cg/credits/" .. ((persistent.clear[1]==1) and "1.jpg" or "1b.jpg"), "cred_1")
        end
        if not nats2 then
            nats2 = loadImageFromURL(ASSET_URL .. "/images/cg/credits/" .. ((persistent.clear[2]==1) and "2.jpg" or "2b.jpg"), "cred_2")
        end
    elseif c_timer >= 75 and c_timer < 84 then
        nats1 = nil
        if not yuri1 then yuri1 = loadImageFromURL(ASSET_URL .. "/images/cg/credits/3.jpg", "cred_3") end
    elseif c_timer >= 86 and c_timer < 93 then
        nats2 = nil
        if not yuri2 then yuri2 = loadImageFromURL(ASSET_URL .. "/images/cg/credits/4.jpg", "cred_4") end
    elseif c_timer >= 94 and c_timer < 103 then
        yuri1 = nil
        if not nats3 then
            nats3 = loadImageFromURL(ASSET_URL .. "/images/cg/credits/" .. ((persistent.clear[5]==1) and "5.jpg" or "5b.jpg"), "cred_5")
        end
    elseif c_timer >= 104 and c_timer < 111 then
        yuri2 = nil
        if not yuri3 then
            yuri3 = loadImageFromURL(ASSET_URL .. "/images/cg/credits/" .. ((persistent.clear[6]==1) and "6.jpg" or "6b.jpg"), "cred_6")
        end
    elseif c_timer >= 112 and c_timer < 120 then
        nats3 = nil
        if not sayo1 then
            sayo1 = loadImageFromURL(ASSET_URL .. "/images/cg/credits/" .. ((persistent.clear[7]==1) and "7.jpg" or "7b.jpg"), "cred_7")
        end
    elseif c_timer >= 120 and c_timer < 130 then
        yuri3 = nil
        if not sayo2 then
            sayo2 = loadImageFromURL(ASSET_URL .. "/images/cg/credits/" .. ((persistent.clear[8]==1) and "8.jpg" or "8b.jpg"), "cred_8")
        end
    elseif c_timer >= 130 and c_timer < 138 then
        sayo1 = nil
        m_sticker_1 = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/m_sticker_1.png", "cred_st_m")
        n_sticker_1 = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/n_sticker_1.png", "cred_st_n")
        s_sticker_1 = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/s_sticker_1.png", "cred_st_s")
        y_sticker_1 = loadImageFromURL(ASSET_URL .. "/images/gui/poemgame/y_sticker_1.png", "cred_st_y")
    elseif c_timer >= 139 and c_timer < 144 then
        sayo2 = nil
        if not sayo3 then
            sayo3 = loadImageFromURL(ASSET_URL .. "/images/cg/credits/" .. ((persistent.clear[9]==1) and "9.jpg" or "9b.jpg"), "cred_9")
        end
    elseif c_timer >= 145 and c_timer < 164 then
        m_sticker_1 = nil; n_sticker_1 = nil; s_sticker_1 = nil; y_sticker_1 = nil
        if not moni1 then moni1 = loadImageFromURL(ASSET_URL .. "/images/cg/credits/10.jpg", "cred_10") end
    elseif c_timer >= 164 and c_timer < 200 then
        sayo3 = nil; moni1 = nil
        if not splashw then splashw = loadImageFromURL(ASSET_URL .. "/images/cg/credits/splashw.jpg", "cred_splashw") end
    end
end

function drawCredits()
    lgSetBackgroundColor(0, 0, 0)
    credits_timer = credits_timer + dt
    loaderCredits(credits_timer)
    
    lgSetColor(255, 255, 255, 255)
    if credits_timer < 60 then
        lgPrint("Please enjoy the credits...", 440, 300)
    elseif credits_timer >= 60 and nats1 then lgDraw(nats1)
    elseif credits_timer >= 75 and yuri1 then lgDraw(yuri1)
    elseif credits_timer >= 86 and yuri2 then lgDraw(yuri2)
    elseif credits_timer >= 94 and nats3 then lgDraw(nats3)
    elseif credits_timer >= 104 and yuri3 then lgDraw(yuri3)
    elseif credits_timer >= 112 and sayo1 then lgDraw(sayo1)
    elseif credits_timer >= 120 and sayo2 then lgDraw(sayo2)
    elseif credits_timer >= 130 then
        if m_sticker_1 then lgDraw(m_sticker_1) end
        if n_sticker_1 then lgDraw(n_sticker_1) end
        if s_sticker_1 then lgDraw(s_sticker_1) end
        if y_sticker_1 then lgDraw(y_sticker_1) end
    elseif credits_timer >= 139 and sayo3 then lgDraw(sayo3)
    elseif credits_timer >= 145 and moni1 then lgDraw(moni1)
    elseif credits_timer >= 164 and splashw then lgDraw(splashw) end
end

function updateCredits()
    if credits_timer >= 200 then
        changeState("title")
    end
end

-- Poem Special
function poem_special_i(x)
    -- Load poem special assets
    -- x contains poem author info
end

function drawpoem_special()
    lgSetBackgroundColor(0, 0, 0)
    drawPoem()
end

function updatepoem_special()
    -- Scroll through poem
end

function poem_special_keypressed(key)
    if key == "a" or key == "b" then
        changeState("game", 2)
    end
end


--[[ Menu System (adapted from menu.lua) ]]--

local menu_items
local cX, cY
local pagenum = 1
local savenum = {}
local itemnames = {}
local chch
local menu_fadeout
local save_oset = {x={366,652,938}, y={250,485}}
local save_date = {}
local save_bpic = {}
local save_hoverpos = {}
local sxp = 0
local history_scr = -39
local dversionx = 1180
local xpsc = 400
local hold = {0,0,0,0}
local scanbuttons = {"up","down","left","right"}
local cond = {}
menu_mchance = 0

function menu_enable(m)
    menu_enabled = true
    menu_type = m
    
    if menu_type == "savegame" or menu_type == "loadgame" or menu_type == "title" then
        save_bpic = {}
        for i = 1, 6 do
            chch = (pagenum > 1) and ((pagenum - 1) * 6 + i) or i
            savenum[i] = (chch < 10) and "0" .. chch or tostring(chch)
            local ok = loaddatainfo(savenum[i])
            if ok then
                save_date[i] = loadstring("return save" .. savenum[i] .. ".date") and "saved" or "empty slot"
                if menu_type ~= "title" then
                    -- load save preview image
                end
            else
                save_date[i] = "empty slot"
            end
        end
    end
    
    if menu_type == "mainyesno" then
        menutext = tr.menuhelp[9]
        itemnames = {tr.menuitem[1], tr.menuitem[2]}
    elseif menu_type == "quityesno" then
        menutext = tr.menuhelp[10]
        itemnames = {tr.menuitem[1], tr.menuitem[2]}
    elseif menu_type == "title" then
        itemnames = {"","","","",""}
    elseif menu_type == "settings" then
        itemnames = {"Text Speed","Auto-Forward Time","Characters","Language","Master Volume","Music Volume","Sound Volume"}
    elseif menu_type == "characters" then
        itemnames = {tr.menuitem[3] .. "monika.chr", tr.menuitem[3] .. "natsuki.chr", tr.menuitem[3] .. "sayori.chr", tr.menuitem[3] .. "yuri.chr", tr.menuitem[4]}
    elseif menu_type == "pause" then
        itemnames = {"","","","","","","",""}
    elseif menu_type == "dialog" then
        itemnames = {""}
    elseif menu_type == "savegame" or menu_type == "loadgame" then
        itemnames = {"","","","","",""}
    elseif menu_type == "help" or menu_type == "history" then
        itemnames = {}
    elseif menu_type == "language" then
        itemnames = lang_names or {"English"}
        menutext = tr.selectlang
    end
    
    if menu_type == "choice" then
        menu_items = #choices + 1
    else
        menu_items = #itemnames + 1
    end
    
    sxp = 0
    for i = 1, #save_date do
        if save_date[i] ~= "empty slot" then sxp = sxp + 1 end
    end
    
    if sxp > 0 and menu_type == "title" then m_select(3)
    else m_select(2) end
end

function menu_drawstuff(a)
    if a == "dialog" then
        lgSetColor(255, 189, 225, 255)
        lgRectangle("fill", 400, 180, 480, 360)
        lgSetColor(255, 230, 244, 255)
        lgRectangle("fill", 410, 190, 460, 340)
    elseif a == "overlay" then
        lgSetColor(255, 255, 255, menu_alpha)
        if menu_bg then lgDraw(menu_bg, posX, posY) end
        if gui.mmenu then lgDraw(gui.mmenu) end
        if gui.gamebuttons then lgDraw(gui.gamebuttons) end
    end
end

function menu_draw()
    lgSetColor(255, 255, 255, menu_alpha)
    
    if menu_type == "title" then
        if gui.check then lgDraw(gui.check, -670 + titlebg_ypos, (cY / 1.2) + 280) end
    elseif menu_type == "choice" or menu_type == "mainyesno" or menu_type == "quityesno" or menu_type == "language" then
        if menu_type == "mainyesno" or menu_type == "quityesno" then
            if menu_bg then lgDraw(menu_bg, posX, posY) end
        end
        if menu_type == "choice" then
            lgSetColor(255, 255, 255, 255)
            if textbox then lgDraw(textbox, 230, 565) end
            outlineText(menutext, 260, 593, "c_disp")
        else
            lgSetColor(255, 255, 255, 128)
            lgRectangle("fill", 0, 0, 1280, 725)
            menu_drawstuff("dialog")
            lgSetColor(0, 0, 0)
            lgPrint(menutext, 430, 190)
        end
        for i = 1, 8 do
            if menu_items >= i + 1 then
                lgSetColor(255, 189, 255, menu_alpha)
                lgRectangle("fill", 435, 195 + (50 * i), 410, 42)
                lgSetColor(255, 230, 244, menu_alpha)
                lgRectangle("fill", 440, 200 + (50 * i), 400, 32)
            end
        end
        lgSetColor(255, 255, 255, menu_alpha / 2.5)
        lgRectangle("fill", 435, 195 + (50 * (m_selected - 1)), 410, 42)
        lgSetColor(0, 0, 0, menu_alpha)
        for i = 1, 8 do
            if menu_items >= i + 1 and menu_type == "choice" and choices[i] and m_selected ~= i + 1 then
                lgPrint(choices[i], 440, 200 + (50 * i))
            elseif menu_items >= i + 1 and itemnames[i] and m_selected ~= i + 1 then
                lgPrint(itemnames[i], 440, 200 + (50 * i))
            end
        end
        if menu_items >= m_selected and menu_type == "choice" and choices[m_selected - 1] then
            outlineText(choices[m_selected - 1], 440, 150 + (50 * m_selected), "m_selected")
        elseif menu_items >= m_selected and itemnames[m_selected - 1] then
            outlineText(itemnames[m_selected - 1], 440, 150 + (50 * m_selected), "m_selected")
        end
        if gui.check then lgDraw(gui.check, 408, 200 + (50 * (m_selected - 1))) end
        
    elseif menu_type == "dialog" then
        lgSetColor(255, 255, 255, 128)
        lgRectangle("fill", 0, 0, 1280, 725)
        menu_drawstuff("dialog")
        lgSetColor(255, 189, 255, 255)
        lgRectangle("fill", 435, 245, 410, 42)
        lgSetColor(255, 230, 244, 255)
        lgRectangle("fill", 440, 250, 400, 32)
        lgSetColor(0, 0, 0, 255)
        lgPrint(menutext, 430, 190)
        outlineText(tr.missing[2], 440, 250, "m_selected")
        
    elseif menu_type == "pause" then
        if gui.gmenu then lgDraw(gui.gmenu) end
        if gui.gamebuttons then lgDraw(gui.gamebuttons) end
        if gui.check then lgDraw(gui.check, 50, (cY / 1.2) + 240) end
        
    elseif menu_type == "help" then
        lgSetColor(255, 255, 255, menu_alpha)
        if menu_bg then lgDraw(menu_bg, posX, posY) end
        lgSetColor(255, 189, 225, menu_alpha)
        lgRectangle("fill", 100, 50, 1080, 620)
        lgSetColor(255, 230, 244, menu_alpha)
        lgRectangle("fill", 120, 70, 1040, 580)
        lgSetColor(0, 0, 0, menu_alpha)
        lgPrint(menutext, 140, 90)
        lgSetColor(0, 0, 0)
        lgPrint("Key Bindings:", 160, 120)
        lgPrint("Space/Enter - Advance", 160, 160)
        lgPrint("3 - Auto", 160, 190)
        lgPrint("2 - Skip", 160, 220)
        lgPrint("1/Shift - Menu", 160, 250)
        lgPrint("Esc - Back/Pause", 160, 280)
        lgPrint("4 - Special", 160, 310)
        lgPrint("Save files are stored in the executor workspace", 160, 360)
        
    elseif menu_type == "savegame" or menu_type == "loadgame" then
        menu_drawstuff("overlay")
        lgSetColor(236, 182, 229, menu_alpha)
        for i = 1, 6 do
            local apx = {}
            if i >= 1 and i <= 3 then apx = {x=save_oset.x[i], y=save_oset.y[1]}
            else apx = {x=save_oset.x[i-3], y=save_oset.y[2]} end
            lgRectangle("fill", apx.x + 10, apx.y - 40, 256, 144)
            lgSetColor(0, 0, 0, menu_alpha)
            lgPrint(savenum[i] .. ": " .. save_date[i], apx.x + 10, apx.y + 110)
        end
        if gui.slothover then
            if m_selected >= 2 and m_selected <= 4 then
                save_hoverpos = {x=save_oset.x[m_selected-1], y=save_oset.y[1]}
            else
                save_hoverpos = {x=save_oset.x[m_selected-4], y=save_oset.y[2]}
            end
            lgDraw(gui.slothover, save_hoverpos.x, save_hoverpos.y - 50)
        end
        lgSetColor(255, 255, 255, 128)
        lgRectangle("fill", save_hoverpos.x + 10, save_hoverpos.y - 40, 256, 144)
        
    elseif menu_type == "settings" then
        menu_drawstuff("overlay")
        lgSetColor(255, 255, 255, menu_alpha)
        if gui.settings then lgDraw(gui.settings) end
        if gui.setbuttons then lgDraw(gui.setbuttons) end
        
        local hv = {x=0, y=0}
        if m_selected <= 5 then hv.x = 340 else hv.x = 790 end
        if m_selected == 2 or m_selected == 6 then hv.y = 344
        elseif m_selected == 3 or m_selected == 7 then hv.y = 412
        elseif m_selected == 4 or m_selected == 8 then hv.y = 480
        elseif m_selected == 5 then hv.y = 548 end
        if gui.check then lgDraw(gui.check, hv.x, hv.y) end
        
        lgSetColor(0, 0, 0)
        lgPrint(settings.textspd, 525, 340)
        lgPrint(settings.autospd, 625, 410)
        lgPrint(settings.masvol .. "%", 1020, 340)
        lgPrint(settings.bgmvol .. "%", 1005, 410)
        lgPrint(settings.sfxvol .. "%", 1010, 480)
        
    elseif menu_type == "history" then
        menu_drawstuff("overlay")
        if gui.history then lgDraw(gui.history) end
        lgSetColor(0, 0, 0)
        for i = 1, #history do
            local temptext = wrap(history[i], 70)
            local ypos = 3600 + (history_scr * 75) - (i * 120)
            lgPrint(temptext, xpsc, ypos)
        end
    end
    
    if menu_type == "characters" then
        lgSetColor(0, 0, 0, menu_alpha)
        for i = 1, 8 do
            if menu_items >= i + 1 and itemnames[i] then
                lgPrint(itemnames[i], 362, 110 + (50 * i))
            end
        end
    end
end

function menu_update()
    if menu_fadeout then
        menu_alpha = math.max(menu_alpha - dt * 1000, 0)
        if menu_alpha == 0 then
            menu_enabled = false; menu_type = nil
            menu_previous = nil; menu_fadeout = false
        end
    else
        menu_alpha = math.min(menu_alpha + dt * 1000, 255)
    end
    
    if menu_type == "history" then
        if UserInputService:IsKeyDown(Enum.KeyCode.Down) and history_scr > -39 then
            history_scr = history_scr - dt * 15
        elseif UserInputService:IsKeyDown(Enum.KeyCode.Up) and history_scr < 2 then
            history_scr = history_scr + dt * 15
        end
    end
end

function menu_confirm()
    if menu_type == "title" or menu_type == "pause" or menu_type == "choice" or menu_type == "dialog" then
        sfxplay2(sfx1)
    end
    
    if menu_type == "title" then
        menu_previous = "title"
        m_selected2 = m_selected
        
        if m_selected == 2 then
            bg1 = "black"
            if player ~= "" then changeState("game", 1)
            elseif player == "" then
                -- Show keyboard input
                keyboard = true
            end
            menu_previous = nil
        elseif m_selected == 3 then
            pagenum = 1; menu_enable("loadgame")
        elseif m_selected == 4 then
            pagenum = 1; menu_enable("settings")
        elseif m_selected == 5 then
            menu_enable("help")
        elseif m_selected == 6 then
            menu_enable("quityesno")
        end
        
    elseif menu_type == "loadgame" and persistent.chr.m ~= 2 then
        savenumber = savenum[m_selected - 1]
        if isfile and pcall(isfile, "ddlc-save" .. savenumber .. "-" .. persistent.ptr .. ".txt") then
            changeState("game", 2)
        else
            menu_enable(menu_previous)
        end
    elseif menu_type == "loadgame" and persistent.chr.m == 2 then
        menu_enable(menu_previous)
    elseif menu_type == "savegame" and persistent.chr.m ~= 2 then
        savenumber = savenum[m_selected - 1]
        savegame()
        savedatainfo(savenumber)
        menu_enable("savegame")
    elseif menu_type == "savegame" and persistent.chr.m == 2 then
        menu_enable(menu_previous)
        
    elseif menu_type == "pause" then
        menu_previous = menu_type
        m_selected2 = m_selected
        if m_selected == 2 then menu_enable("history")
        elseif m_selected == 3 then pagenum = 1; menu_enable("savegame")
        elseif m_selected == 4 then pagenum = 1; menu_enable("loadgame")
        elseif m_selected == 5 then
            if persistent.chr.m == 2 then menu_fadeout = true
            else menu_enable("mainyesno") end
        elseif m_selected == 6 then pagenum = 1; menu_enable("settings")
        elseif m_selected == 7 then menu_enable("help")
        elseif m_selected == 8 then menu_enable("quityesno")
        elseif m_selected == 9 then menu_fadeout = true end
        
    elseif menu_type == "mainyesno" then
        if m_selected == 2 then changeState("title")
        elseif m_selected == 3 then menu_enable("pause") end
        
    elseif menu_type == "quityesno" then
        if m_selected == 2 then cleanup()
        elseif m_selected == 3 then menu_enable(menu_previous) end
        
    elseif menu_type == "settings" then
        if m_selected <= 3 or m_selected >= 6 then menu_keypressed("left")
        elseif m_selected == 4 then menu_enable("characters")
        elseif m_selected == 5 then changeState("language") end
        
    elseif menu_type == "characters" then
        if m_selected == 2 then
            if persistent.chr.m < 2 or (persistent.chr.m == 2 and chapter == 30) then persistent.chr.m = 0 end
        elseif m_selected == 4 then
            if persistent.ptr == 0 then persistent.chr.s = 0 end
        elseif m_selected == 6 then
            if persistent.ptr == 0 then persistent.chr.s = 1 end
            if persistent.chr.m < 2 then persistent.chr.m = 1 end
        end
        savepersistent()
        menu_enable(menu_previous)
        
    elseif menu_type == "choice" then
        if choicepick ~= "" then
            scriptJump(cl + 1)
            menu_fadeout = true
        end
        
    elseif menu_type == "dialog" then
        scriptJump(cl + 1)
        menu_fadeout = true
        
    elseif menu_type == "language" then
        settings.lang = lang_codes[m_selected - 1]
        savesettings()
        l_timer = 99
        changeState("load")
    end
end

function m_select(arg)
    if arg then m_selected = arg end
    if m_selected <= 5 and menu_type == "choice" then
        choicepick = choices[m_selected - 1]
    end
    cX = 135
    cY = 110 + (50 * (m_selected - 1))
end

function menu_keypressed(key)
    if key == "down" then
        if menu_type == "savegame" or menu_type == "loadgame" then
            if m_selected <= 4 then m_selected = m_selected + 3
            else m_selected = m_selected - 3 end
        elseif m_selected <= menu_items - 1 then m_selected = m_selected + 1
        else m_selected = 2 end
        m_select()
        
    elseif key == "up" then
        if menu_type == "savegame" or menu_type == "loadgame" then
            if m_selected >= 5 and m_selected <= 7 then m_selected = m_selected - 3
            else m_selected = m_selected + 3 end
        elseif m_selected >= 3 then m_selected = m_selected - 1
        else m_selected = menu_items end
        m_select()
        
    elseif key == "a" then
        menu_confirm()
        
    elseif key == "b" then
        if menu_type == "history" then history_scr = -39
        elseif menu_type == "settings" then savesettings() end
        if menu_type == "pause" then menu_fadeout = true
        elseif menu_type ~= "title" and menu_type ~= "pause" and menu_type ~= "choice" and menu_type ~= "language" then
            menu_enable(menu_previous)
        end
        if m_selected2 then
            m_selected = m_selected2; m_select(); m_selected2 = nil
        end
        menu_previous = nil
        
    elseif key == "left" then
        if menu_type == "savegame" or menu_type == "loadgame" then
            if (m_selected == 2 or m_selected == 5) and pagenum > 1 then
                pagenum = pagenum - 1; m_selected2 = m_selected
                menu_enable(menu_type)
                if m_selected2 == 2 then m_selected = 4
                elseif m_selected2 == 5 then m_selected = 7 end
            elseif m_selected > 2 and m_selected ~= 5 then m_selected = m_selected - 1 end
            m_select()
        elseif menu_type == "settings" then
            local names = itemnames
            if m_selected <= 5 and m_selected >= 2 then
                if names[m_selected-1] == "Text Speed" and settings.textspd > 50 then settings.textspd = settings.textspd - 25
                elseif names[m_selected-1] == "Auto-Forward Time" and settings.autospd > 1 then settings.autospd = settings.autospd - 1
                elseif names[m_selected-1] == "Master Volume" and settings.masvol > 0 then settings.masvol = settings.masvol - 10
                elseif names[m_selected-1] == "Music Volume" and settings.bgmvol > 0 then settings.bgmvol = settings.bgmvol - 10
                elseif names[m_selected-1] == "Sound Volume" and settings.sfxvol > 0 then settings.sfxvol = settings.sfxvol - 10 end
            end
        end
        game_setvolume()
        
    elseif key == "right" then
        if menu_type == "savegame" or menu_type == "loadgame" then
            if (m_selected == 4 or m_selected == 7) and pagenum < 10 then
                pagenum = pagenum + 1; m_selected2 = m_selected
                menu_enable(menu_type)
                if m_selected2 == 4 then m_selected = 2
                elseif m_selected2 == 7 then m_selected = 5 end
            elseif m_selected < 7 and m_selected ~= 4 then m_selected = m_selected + 1 end
            m_select()
        elseif menu_type == "settings" then
            local names = itemnames
            if m_selected <= 5 and m_selected >= 2 then
                if names[m_selected-1] == "Text Speed" and settings.textspd < 250 then settings.textspd = settings.textspd + 25
                elseif names[m_selected-1] == "Auto-Forward Time" and settings.autospd < 15 then settings.autospd = settings.autospd + 1
                elseif names[m_selected-1] == "Master Volume" and settings.masvol < 100 then settings.masvol = settings.masvol + 10
                elseif names[m_selected-1] == "Music Volume" and settings.bgmvol < 100 then settings.bgmvol = settings.bgmvol + 10
                elseif names[m_selected-1] == "Sound Volume" and settings.sfxvol < 100 then settings.sfxvol = settings.sfxvol + 10 end
            end
        end
        game_setvolume()
    end
end


--[[ Main Entry Point ]]--
math.randomseed(tick())
math.random(); math.random(); math.random()

function startGame()
    is_running = true
    getTime = 0
    startTime = getTime
    last_text = ''
    print_full_text = false
    autotimer = 0
    autoskip = 0
    sectimer = 0
    xaload = 0
    alpha = 255
    posX = -40
    posY = 0
    menu_enabled = false
    textbox_enabled = true
    bgimg_disabled = false
    changeState('load')
end

--- Run!
startGame()
