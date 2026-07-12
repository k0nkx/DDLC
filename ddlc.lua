
--[[
DDLC-ROBLOX - Doki Doki Literature Club
Based on DDLC-LOVE
Port to Roblox Executor by asianyuh
]]--

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

startGame()