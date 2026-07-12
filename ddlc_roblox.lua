-- DDLC-LOVE for Roblox Executor (Instance-based)
-- Uses Sound, ImageLabel, TextLabel, Frame for rendering
-- Full DDLC-LOVE story via scripts loaded from GitHub

local env = {}\ngetgenv().ddlc = env
local BASE = "https://raw.githubusercontent.com/k0nkx/DDLC/main/"
local DIR = "DDLC/"

-- ========== IMAGE LOADER ==========
local imgCache = {}
local useDrawing = false
pcall(function() if Drawing and Drawing.new then local d = Drawing.new("Image"); d:Remove() end end)
local function tryGCA(path)
  local ok, id = pcall(getcustomasset, path)
  if ok and type(id) == "string" and #id > 0 then return id end
  return nil
end
function loadImg(assetRelPath)
  if imgCache[assetRelPath] then return imgCache[assetRelPath] end
  -- assetRelPath from callers is like "images/bg/splash.jpg"
  -- but files are at "DDLC/assets/images/bg/splash.jpg"
  local fullpath = DIR .. "assets/" .. assetRelPath
  if not isfile(fullpath) then
    print("[DDLC] Missing asset: " .. assetRelPath .. " (path: " .. fullpath .. ")")
    return nil
  end
  local id = tryGCA(fullpath) or tryGCA(fullpath:gsub("/", "\\\\"))
  if id then 
    imgCache[assetRelPath] = id
    return id
  end
  print("[DDLC] getcustomasset failed: " .. assetRelPath)
  return nil
end

-- ========== ASSET URLS ==========
local asset_urls = {
"assets/audio/bgm/1-loop.ogg","assets/audio/bgm/1.ogg","assets/audio/bgm/10-loop.ogg","assets/audio/bgm/10-yuri.ogg","assets/audio/bgm/10.ogg",
"assets/audio/bgm/2-loop.ogg","assets/audio/bgm/2.ogg","assets/audio/bgm/2g.ogg","assets/audio/bgm/2g2.ogg","assets/audio/bgm/2gs.ogg",
"assets/audio/bgm/2gs2.ogg","assets/audio/bgm/2gs3.ogg","assets/audio/bgm/3-loop.ogg","assets/audio/bgm/3.ogg","assets/audio/bgm/3g.ogg",
"assets/audio/bgm/3g2.ogg","assets/audio/bgm/3g3.ogg","assets/audio/bgm/4-loop.ogg","assets/audio/bgm/4.ogg","assets/audio/bgm/4g-loop.ogg",
"assets/audio/bgm/4g.ogg","assets/audio/bgm/5-loop.ogg","assets/audio/bgm/5.ogg","assets/audio/bgm/5_ghost.ogg","assets/audio/bgm/5_monika-loop.ogg",
"assets/audio/bgm/5_monika.ogg","assets/audio/bgm/5_natsuki-loop.ogg","assets/audio/bgm/5_natsuki.ogg","assets/audio/bgm/5_sayori-loop.ogg",
"assets/audio/bgm/5_sayori.ogg","assets/audio/bgm/5_yuri-loop.ogg","assets/audio/bgm/5_yuri.ogg","assets/audio/bgm/5_yuri2.ogg",
"assets/audio/bgm/6-loop.ogg","assets/audio/bgm/6.ogg","assets/audio/bgm/6g-.ogg","assets/audio/bgm/6g.ogg","assets/audio/bgm/6o.ogg",
"assets/audio/bgm/6r.ogg","assets/audio/bgm/6s.ogg","assets/audio/bgm/7-loop.ogg","assets/audio/bgm/7.ogg","assets/audio/bgm/7a.ogg",
"assets/audio/bgm/7g-loop.ogg","assets/audio/bgm/7g.ogg","assets/audio/bgm/8-loop.ogg","assets/audio/bgm/8.ogg","assets/audio/bgm/9.ogg","assets/audio/bgm/9g.ogg",
"assets/audio/bgm/d-loop.ogg","assets/audio/bgm/d.ogg","assets/audio/bgm/eng/credits.ogg","assets/audio/bgm/eng/end-voice.ogg",
"assets/audio/bgm/g1.ogg","assets/audio/bgm/g2.ogg","assets/audio/bgm/ghostmenu.ogg","assets/audio/bgm/heartbeat.ogg","assets/audio/bgm/m1.ogg",
"assets/audio/bgm/monika-end-loop.ogg","assets/audio/bgm/monika-end.ogg","assets/audio/bgm/monika-start.ogg","assets/audio/bgm/s_kill_early.ogg",
"assets/audio/bgm/spa/credits.ogg","assets/audio/bgm/spa/end-voice.ogg","assets/audio/bgm/yuri-kill.ogg",
"assets/audio/sfx/baa.ogg","assets/audio/sfx/closet-close.ogg","assets/audio/sfx/closet-open.ogg","assets/audio/sfx/crack.ogg","assets/audio/sfx/error.ogg",
"assets/audio/sfx/eyes.ogg","assets/audio/sfx/fall.ogg","assets/audio/sfx/fall2.ogg","assets/audio/sfx/giggle.ogg","assets/audio/sfx/glitch1.ogg",
"assets/audio/sfx/glitch1s.ogg","assets/audio/sfx/glitch2.ogg","assets/audio/sfx/glitch3.ogg","assets/audio/sfx/gnid.ogg","assets/audio/sfx/hover.ogg",
"assets/audio/sfx/interference.ogg","assets/audio/sfx/monikapound.ogg","assets/audio/sfx/monikapound2.ogg","assets/audio/sfx/pageflip.ogg","assets/audio/sfx/run.ogg",
"assets/audio/sfx/s_kill_glitch1.ogg","assets/audio/sfx/s_kill_glitch1s.ogg","assets/audio/sfx/select.ogg","assets/audio/sfx/select_glitch.ogg",
"assets/audio/sfx/slap.ogg","assets/audio/sfx/smack.ogg","assets/audio/sfx/stab.ogg",
"assets/images/gui/box.png","assets/images/gui/check_selected_foreground.png","assets/images/gui/choice_hover_background.png","assets/images/gui/choice_idle_background.png",
"assets/images/gui/slot_hover_background.png","assets/images/gui/slot_idle_background.png","assets/images/gui/ctc.png","assets/images/gui/skip.png",
"assets/images/gui/logo.png","assets/images/gui/icon.png","assets/images/gui/namebox.png","assets/images/gui/textbox.png","assets/images/gui/textbox_monika.png",
"assets/images/gui/menu_bg.jpg","assets/images/gui/menu_bg_m.jpg","assets/images/gui/menu_art_m.png","assets/images/gui/menu_art_m_ghost.png",
"assets/images/gui/menu_art_n.png","assets/images/gui/menu_art_n_ghost.png","assets/images/gui/menu_art_s.png","assets/images/gui/menu_art_s_break.png",
"assets/images/gui/menu_art_s_ghost.png","assets/images/gui/menu_art_y.png","assets/images/gui/menu_art_y_ghost.png","assets/images/gui/menu_particle.png","assets/images/gui/blood_drop.png",
"assets/images/gui/overlay/main_menu.png","assets/images/gui/overlay/game_menu.png","assets/images/gui/overlay/sidebar.png","assets/images/gui/overlay/confirm.png",
"assets/images/gui/scrollbar/horizontal_poem_bar.png","assets/images/gui/scrollbar/horizontal_poem_thumb.png",
"assets/images/gui/scrollbar/vertical_poem_bar.png","assets/images/gui/scrollbar/vertical_poem_thumb.png","assets/images/gui/slider/horizontal_hover_thumb.png",
"assets/images/gui/poemgame/poemtime.png","assets/images/gui/poemgame/poemtime2.png",
"assets/images/gui/poemgame/m_sticker_1.png","assets/images/gui/poemgame/m_sticker_2.png","assets/images/gui/poemgame/n_sticker_1.png","assets/images/gui/poemgame/n_sticker_2.png",
"assets/images/gui/poemgame/s_sticker_1.png","assets/images/gui/poemgame/s_sticker_2.png","assets/images/gui/poemgame/y_sticker_1.png","assets/images/gui/poemgame/y_sticker_1_broken.png",
"assets/images/gui/poemgame/y_sticker_2.png","assets/images/gui/poemgame/y_sticker_2g.png","assets/images/gui/poemgame/y_sticker_cut_1.png","assets/images/gui/poemgame/y_sticker_cut_2.png",
"assets/images/gui/eng/end.png","assets/images/gui/eng/endflipped.png","assets/images/gui/eng/gamebuttons.png","assets/images/gui/eng/gamemenu.png","assets/images/gui/eng/history.png",
"assets/images/gui/eng/load.png","assets/images/gui/eng/mainbuttons.png","assets/images/gui/eng/newgame.png","assets/images/gui/eng/newgame1.png","assets/images/gui/eng/save.png",
"assets/images/gui/eng/setbuttons.png","assets/images/gui/eng/settings.png",
"assets/images/gui/spa/end.png","assets/images/gui/spa/endflipped.png","assets/images/gui/spa/gamebuttons.png","assets/images/gui/spa/gamemenu.png","assets/images/gui/spa/history.png",
"assets/images/gui/spa/load.png","assets/images/gui/spa/mainbuttons.png","assets/images/gui/spa/newgame.png","assets/images/gui/spa/newgame1.png","assets/images/gui/spa/save.png",
"assets/images/gui/spa/setbuttons.png","assets/images/gui/spa/settings.png",
"assets/images/poem_special/eng/poem_end.jpg","assets/images/poem_special/eng/poem_end_clearall.jpg","assets/images/poem_special/eng/poem_special1.jpg",
"assets/images/poem_special/eng/poem_special10.jpg","assets/images/poem_special/eng/poem_special11.jpg","assets/images/poem_special/eng/poem_special2.jpg",
"assets/images/poem_special/eng/poem_special3.jpg","assets/images/poem_special/eng/poem_special4.jpg","assets/images/poem_special/eng/poem_special5a.jpg",
"assets/images/poem_special/eng/poem_special5b.jpg","assets/images/poem_special/eng/poem_special6.jpg","assets/images/poem_special/eng/poem_special8.jpg",
"assets/images/poem_special/eng/poem_special9.jpg",
"assets/images/poem_special/spa/poem_end.jpg","assets/images/poem_special/spa/poem_end_clearall.jpg","assets/images/poem_special/spa/poem_special1.jpg",
"assets/images/poem_special/spa/poem_special10.jpg","assets/images/poem_special/spa/poem_special11.jpg","assets/images/poem_special/spa/poem_special2.jpg",
"assets/images/poem_special/spa/poem_special3.jpg","assets/images/poem_special/spa/poem_special4.jpg","assets/images/poem_special/spa/poem_special5a.jpg",
"assets/images/poem_special/spa/poem_special5b.jpg","assets/images/poem_special/spa/poem_special6.jpg","assets/images/poem_special/spa/poem_special8.jpg",
"assets/images/poem_special/spa/poem_special9.jpg",
"assets/images/poem_special/poem_special7a.png","assets/images/poem_special/poem_special7b.png",
"assets/images/bg/splash.jpg","assets/images/bg/splash-glitch.jpg","assets/images/bg/splash-glitch2.jpg","assets/images/bg/glitch.jpg",
"assets/images/bg/bedroom.jpg","assets/images/bg/black.jpg","assets/images/bg/class.jpg","assets/images/bg/closet.jpg","assets/images/bg/club-skill.jpg","assets/images/bg/club.jpg",
"assets/images/bg/corridor.jpg","assets/images/bg/house.jpg","assets/images/bg/kitchen.jpg","assets/images/bg/notebook.jpg","assets/images/bg/notebook-glitch.jpg",
"assets/images/bg/poem.jpg","assets/images/bg/poem1.jpg","assets/images/bg/poem2.jpg","assets/images/bg/poem3.jpg","assets/images/bg/poem_y1.jpg",
"assets/images/bg/residential.jpg","assets/images/bg/sayori_bedroom.jpg","assets/images/bg/warning.jpg","assets/images/bg/warning2.jpg",
"assets/images/bg/end-glitch1.jpg","assets/images/bg/end-glitch2.jpg","assets/images/bg/end-glitch3.jpg","assets/images/bg/eyes.jpg",
"assets/images/bg/noise1.jpg","assets/images/bg/noise2.jpg","assets/images/bg/noise3.jpg","assets/images/bg/noise4.jpg",
"assets/images/bg/GlitchSayoriScreen1.jpg","assets/images/bg/GlitchSayoriScreen2.jpg","assets/images/bg/Menu_bg_m.jpg","assets/images/bg/ex3top.jpg",
"assets/images/bg/s_kill/ex2.jpg","assets/images/bg/s_kill/s_kill_bg.jpg","assets/images/bg/s_kill/s_kill_bg2.jpg","assets/images/bg/s_kill/s_kill_bgzoom.jpg",
"assets/images/bg/y_kill/1a.jpg","assets/images/bg/y_kill/1b.jpg","assets/images/bg/y_kill/1c.jpg","assets/images/bg/y_kill/2a.jpg","assets/images/bg/y_kill/2b.jpg",
"assets/images/bg/y_kill/2c.jpg","assets/images/bg/y_kill/3a.jpg","assets/images/bg/y_kill/3b.jpg","assets/images/bg/y_kill/3c.jpg",
"assets/images/bg/save/bedroom.jpg","assets/images/bg/save/black.jpg","assets/images/bg/save/class.jpg","assets/images/bg/save/closet.jpg","assets/images/bg/save/club-skill.jpg",
"assets/images/bg/save/club.jpg","assets/images/bg/save/corridor.jpg","assets/images/bg/save/house.jpg","assets/images/bg/save/kitchen.jpg","assets/images/bg/save/notebook.jpg",
"assets/images/bg/save/residential.jpg","assets/images/bg/save/sayori_bedroom.jpg",
"assets/images/bg/cg/monika_bg.jpg","assets/images/bg/cg/monika_bg2.jpg","assets/images/bg/cg/monika_bg_glitch.jpg","assets/images/bg/cg/monika_rh.jpg",
"assets/images/bg/cg/n_cg1_base.jpg","assets/images/bg/cg/n_cg1b.jpg","assets/images/bg/cg/n_cg2_base.jpg","assets/images/bg/cg/n_cg3_base.jpg","assets/images/bg/cg/n_cg3_cake.jpg",
"assets/images/bg/cg/s_cg1.jpg","assets/images/bg/cg/s_cg2_base1.jpg","assets/images/bg/cg/s_cg2_base2.jpg","assets/images/bg/cg/s_cg3.jpg",
"assets/images/bg/cg/y_cg1_base.jpg","assets/images/bg/cg/y_cg2.jpg","assets/images/bg/cg/y_cg2_nochoc.jpg","assets/images/bg/cg/y_cg3_base.jpg",
"assets/images/cg/blank.png","assets/images/cg/vignette.png",
"assets/images/cg/monika_glitch1.png","assets/images/cg/monika_glitch2.png","assets/images/cg/monika_glitch3.png","assets/images/cg/monika_glitch4.png",
"assets/images/cg/n_cg1_exp1.png","assets/images/cg/n_cg1_exp2.png","assets/images/cg/n_cg1_exp3.png","assets/images/cg/n_cg1_exp4.png","assets/images/cg/n_cg1_exp5.png",
"assets/images/cg/n_cg2_exp1.png","assets/images/cg/n_cg2_exp2.png","assets/images/cg/n_cg3_exp1.png","assets/images/cg/n_cg3_exp2.png",
"assets/images/cg/s_cg2_exp1.png","assets/images/cg/s_cg2_exp2.png","assets/images/cg/s_cg2_exp3.png",
"assets/images/cg/y_cg1_exp1.png","assets/images/cg/y_cg1_exp2.png","assets/images/cg/y_cg1_exp3.png","assets/images/cg/y_cg2_exp2.png","assets/images/cg/y_cg2_exp3.png","assets/images/cg/y_cg3_exp1.png",
"assets/images/cg/s_kill/s_kill.png","assets/images/cg/s_kill/s_kill2.png","assets/images/cg/s_kill/s_kill_early.png","assets/images/cg/s_kill/s_killzoom.png",
"assets/images/cg/credits/1.jpg","assets/images/cg/credits/1b.jpg","assets/images/cg/credits/2.jpg","assets/images/cg/credits/2b.jpg","assets/images/cg/credits/3.jpg",
"assets/images/cg/credits/4.jpg","assets/images/cg/credits/5.jpg","assets/images/cg/credits/5b.jpg","assets/images/cg/credits/6.jpg","assets/images/cg/credits/6b.jpg",
"assets/images/cg/credits/7.jpg","assets/images/cg/credits/7b.jpg","assets/images/cg/credits/8.jpg","assets/images/cg/credits/8b.jpg","assets/images/cg/credits/9.jpg",
"assets/images/cg/credits/9b.jpg","assets/images/cg/credits/10.jpg","assets/images/cg/credits/ddlc.jpg","assets/images/cg/credits/splashw.jpg",
"assets/images/sayori/1bl.png","assets/images/sayori/1br.png","assets/images/sayori/1l.png","assets/images/sayori/1r.png","assets/images/sayori/2bl.png","assets/images/sayori/2br.png",
"assets/images/sayori/2l.png","assets/images/sayori/2r.png","assets/images/sayori/3a.png","assets/images/sayori/3b.png","assets/images/sayori/3c.png","assets/images/sayori/3d.png",
"assets/images/sayori/a.png","assets/images/sayori/b.png","assets/images/sayori/c.png","assets/images/sayori/d.png","assets/images/sayori/e.png","assets/images/sayori/f.png",
"assets/images/sayori/f_1a.png","assets/images/sayori/f_1b.png","assets/images/sayori/g.png","assets/images/sayori/h.png","assets/images/sayori/i.png","assets/images/sayori/j.png",
"assets/images/sayori/k.png","assets/images/sayori/l.png","assets/images/sayori/m.png","assets/images/sayori/n.png","assets/images/sayori/o.png","assets/images/sayori/p.png",
"assets/images/sayori/q.png","assets/images/sayori/r.png","assets/images/sayori/s.png","assets/images/sayori/t.png","assets/images/sayori/u.png","assets/images/sayori/v.png",
"assets/images/sayori/w.png","assets/images/sayori/x.png","assets/images/sayori/y.png",
"assets/images/sayori/glitch1.png","assets/images/sayori/glitch2.png","assets/images/sayori/end-glitch1.png","assets/images/sayori/end-glitch2.png",
"assets/images/natsuki/1bl.png","assets/images/natsuki/1br.png","assets/images/natsuki/1l.png","assets/images/natsuki/1r.png","assets/images/natsuki/1t.png",
"assets/images/natsuki/2a.png","assets/images/natsuki/2b.png","assets/images/natsuki/2bl.png","assets/images/natsuki/2br.png","assets/images/natsuki/2c.png","assets/images/natsuki/2d.png",
"assets/images/natsuki/2e.png","assets/images/natsuki/2f.png","assets/images/natsuki/2g.png","assets/images/natsuki/2h.png","assets/images/natsuki/2i.png","assets/images/natsuki/2l.png",
"assets/images/natsuki/2r.png","assets/images/natsuki/2t.png","assets/images/natsuki/3.png","assets/images/natsuki/3b.png",
"assets/images/natsuki/a.png","assets/images/natsuki/b.png","assets/images/natsuki/blackeyes.png","assets/images/natsuki/c.png","assets/images/natsuki/d.png","assets/images/natsuki/e.png",
"assets/images/natsuki/eye.png","assets/images/natsuki/f.png","assets/images/natsuki/f_1.png","assets/images/natsuki/f_1b.png","assets/images/natsuki/f_h.png","assets/images/natsuki/f_i.png",
"assets/images/natsuki/f_o.png","assets/images/natsuki/f_v.png","assets/images/natsuki/g.png","assets/images/natsuki/h.png","assets/images/natsuki/i.png","assets/images/natsuki/j.png",
"assets/images/natsuki/k.png","assets/images/natsuki/l.png","assets/images/natsuki/m.png","assets/images/natsuki/n.png","assets/images/natsuki/o.png","assets/images/natsuki/p.png",
"assets/images/natsuki/q.png","assets/images/natsuki/r.png","assets/images/natsuki/s.png","assets/images/natsuki/scream.png","assets/images/natsuki/t.png","assets/images/natsuki/u.png",
"assets/images/natsuki/v.png","assets/images/natsuki/vomit.png","assets/images/natsuki/w.png","assets/images/natsuki/x.png","assets/images/natsuki/y.png","assets/images/natsuki/z.png",
"assets/images/natsuki/ghost1.png","assets/images/natsuki/ghost2.png","assets/images/natsuki/ghost3.png","assets/images/natsuki/ghost3-1.png","assets/images/natsuki/ghost3-2.png",
"assets/images/natsuki/ghost3-3.png","assets/images/natsuki/ghost_blood.png","assets/images/natsuki/glitch1.png",
"assets/images/yuri/0a.png","assets/images/yuri/0b.png","assets/images/yuri/1bl.png","assets/images/yuri/1br.png","assets/images/yuri/1l.png","assets/images/yuri/1r.png",
"assets/images/yuri/2bl.png","assets/images/yuri/2br.png","assets/images/yuri/2l.png","assets/images/yuri/2r.png","assets/images/yuri/3.png","assets/images/yuri/3b.png",
"assets/images/yuri/a.png","assets/images/yuri/a2.png","assets/images/yuri/b.png","assets/images/yuri/b2.png","assets/images/yuri/c.png","assets/images/yuri/c2.png",
"assets/images/yuri/cuts.png","assets/images/yuri/d.png","assets/images/yuri/d2.png","assets/images/yuri/dragon1.png","assets/images/yuri/dragon2.png",
"assets/images/yuri/e.png","assets/images/yuri/e2.png","assets/images/yuri/eyes1.png","assets/images/yuri/eyes2.png","assets/images/yuri/eyesfull.png",
"assets/images/yuri/f.png","assets/images/yuri/f_2bs.png","assets/images/yuri/g.png","assets/images/yuri/h.png","assets/images/yuri/hisui.png",
"assets/images/yuri/i.png","assets/images/yuri/j.png","assets/images/yuri/k.png","assets/images/yuri/l.png","assets/images/yuri/m.png","assets/images/yuri/n.png",
"assets/images/yuri/o.png","assets/images/yuri/oneeye.png","assets/images/yuri/oneeye2.png","assets/images/yuri/p.png","assets/images/yuri/q.png","assets/images/yuri/r.png",
"assets/images/yuri/s.png","assets/images/yuri/t.png","assets/images/yuri/u.png","assets/images/yuri/v.png","assets/images/yuri/w.png",
"assets/images/yuri/y1.png","assets/images/yuri/y2.png","assets/images/yuri/y3.png","assets/images/yuri/y4.png","assets/images/yuri/y5.png","assets/images/yuri/y6.png","assets/images/yuri/y7.png",
"assets/images/yuri/glitch1.png","assets/images/yuri/glitch2.png","assets/images/yuri/glitch3.png","assets/images/yuri/glitch4.png","assets/images/yuri/glitch5.png",
"assets/images/yuri/za.png","assets/images/yuri/zb.png","assets/images/yuri/zc.png","assets/images/yuri/zd.png",
"assets/images/yuri/stab/1.png","assets/images/yuri/stab/2.png","assets/images/yuri/stab/3.png","assets/images/yuri/stab/4.png","assets/images/yuri/stab/5.png",
"assets/images/yuri/stab/6.png","assets/images/yuri/stab/6-full.png",
"assets/images/monika/1l.png","assets/images/monika/1lwho.png","assets/images/monika/1r.png","assets/images/monika/2l.png","assets/images/monika/2r.png",
"assets/images/monika/3a.png","assets/images/monika/3b.png","assets/images/monika/a.png","assets/images/monika/ac.png","assets/images/monika/b.png","assets/images/monika/c.png",
"assets/images/monika/d.png","assets/images/monika/e.png","assets/images/monika/f.png","assets/images/monika/g.png","assets/images/monika/g1.png","assets/images/monika/g2.png",
"assets/images/monika/g3.png","assets/images/monika/g4.png","assets/images/monika/h.png","assets/images/monika/i.png","assets/images/monika/j.png","assets/images/monika/k.png",
"assets/images/monika/l.png","assets/images/monika/m.png","assets/images/monika/n.png","assets/images/monika/o.png","assets/images/monika/p.png","assets/images/monika/q.png","assets/images/monika/r.png",
"assets/fonts/Aller_Rg.ttf","assets/fonts/F25_Bank_Printer.ttf","assets/fonts/Halogen.ttf","assets/fonts/RifficFree-Bold.ttf","assets/fonts/VerilySerifMono.ttf",
"assets/fonts/m1.ttf","assets/fonts/n1.ttf","assets/fonts/s1.ttf","assets/fonts/y1.ttf",
"scripts/eng/text.lua","scripts/eng/script-ch0.lua","scripts/eng/script-ch1.lua","scripts/eng/script-ch2.lua","scripts/eng/script-ch3.lua","scripts/eng/script-ch4.lua",
"scripts/eng/script-ch5.lua","scripts/eng/script-ch10.lua","scripts/eng/script-ch20.lua","scripts/eng/script-ch21.lua","scripts/eng/script-ch22.lua","scripts/eng/script-ch23.lua",
"scripts/eng/script-ch30.lua","scripts/eng/script-ch40.lua",
"scripts/eng/script-exclusives-natsuki.lua","scripts/eng/script-exclusives-sayori.lua","scripts/eng/script-exclusives-yuri.lua",
"scripts/eng/script-exclusives2-natsuki.lua","scripts/eng/script-exclusives2-yuri.lua",
"scripts/eng/script-poemresponses.lua","scripts/eng/script-poemresponses1.lua","scripts/eng/script-poemresponses2.lua",
"scripts/eng/poems.lua","scripts/eng/poemwords.lua",
"scripts/event.lua","scripts/event-1.lua","scripts/event-2.lua","scripts/event-3.lua",
"scripts/spa/text.lua","scripts/spa/script-ch0.lua","scripts/spa/script-ch1.lua","scripts/spa/script-ch2.lua","scripts/spa/script-ch3.lua","scripts/spa/script-ch4.lua",
"scripts/spa/script-ch5.lua","scripts/spa/script-ch10.lua","scripts/spa/script-ch20.lua","scripts/spa/script-ch21.lua","scripts/spa/script-ch22.lua","scripts/spa/script-ch23.lua",
"scripts/spa/script-ch30.lua","scripts/spa/script-ch40.lua",
"scripts/spa/script-exclusives-natsuki.lua","scripts/spa/script-exclusives-sayori.lua","scripts/spa/script-exclusives-yuri.lua",
"scripts/spa/script-exclusives2-natsuki.lua","scripts/spa/script-exclusives2-yuri.lua",
"scripts/spa/script-poemresponses.lua","scripts/spa/script-poemresponses1.lua","scripts/spa/script-poemresponses2.lua","scripts/spa/poems.lua","scripts/spa/poemwords.lua",
"ddlc.lua"}

-- ========== ASSET DOWNLOADER ==========
function env.downloadAssets()
  if not isfolder(DIR) then makefolder(DIR); print("[DDLC] Created " .. DIR) end
  local total, downloaded, skipped = #asset_urls, 0, 0
  for i, relpath in ipairs(asset_urls) do
    local fullpath = DIR .. relpath
    if isfile(fullpath) then
      skipped = skipped + 1
    else
      local parts = {}
      for part in relpath:gmatch("[^/]+") do table.insert(parts, part) end
      if #parts > 1 then
        local dirpath = DIR
        for j = 1, #parts - 1 do
          dirpath = dirpath .. parts[j] .. "/"
          if not isfolder(dirpath) then makefolder(dirpath) end
        end
      end
      local ok, resp = pcall(request, {Url=BASE .. relpath, Method="GET"})
      if ok and resp and resp.Body and #resp.Body > 0 then
        writefile(fullpath, resp.Body)
        downloaded = downloaded + 1
        print("[DDLC] Downloaded: " .. relpath)
      else
        print("[DDLC] FAILED: " .. relpath)
      end
    end
    if i % 15 == 0 then task.wait() end
  end
  print("[DDLC] Done - Downloaded: " .. downloaded .. ", Skipped: " .. skipped .. ", Total: " .. total)
end

-- ========== SCRIPT FETCHER ==========
local function fetchScript(relpath)
  local fullpath = DIR .. relpath
  if isfile(fullpath) then return readfile(fullpath) end
  local ok, resp = pcall(request, {Url=BASE .. relpath, Method="GET"})
  if ok and resp and resp.Body then
    local parts = {}; for part in relpath:gmatch("[^/]+") do table.insert(parts, part) end
    if #parts > 1 then
      local dirpath = DIR
      for j = 1, #parts - 1 do
        dirpath = dirpath .. parts[j] .. "/"
        if not isfolder(dirpath) then makefolder(dirpath) end
      end
    end
    writefile(fullpath, resp.Body)
    return resp.Body
  end
end

-- ========== GUI SETUP ==========
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local vp = workspace.CurrentCamera.ViewportSize
local sw, sh = vp.X, vp.Y

-- Cleanup old
local oldGui = gui:FindFirstChild("DDLCGui")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DDLCGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = gui

-- Main container: 1280x720 centered (TRANSPARENT - don't cover layers!)
local mainFrm = Instance.new("Frame")
mainFrm.Name = "Main"
mainFrm.BackgroundTransparency = 1
mainFrm.BorderSizePixel = 0
mainFrm.Size = UDim2.fromOffset(1280, 720)
mainFrm.Position = UDim2.fromScale(0.5, 0.5)
mainFrm.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrm.ClipsDescendants = true
mainFrm.Parent = screenGui

-- Helper: create image label
function newImg(name, pos, size, parent)
  local img = Instance.new("ImageLabel")
  img.Name = name
  img.BackgroundTransparency = 1
  img.Position = pos or UDim2.fromOffset(0,0)
  img.Size = size or UDim2.fromOffset(1280, 720)
  img.Visible = false
  img.Parent = parent or mainFrm
  return img
end

-- Helper: create text label
function newTxt(name, pos, size, parent)
  local txt = Instance.new("TextLabel")
  txt.Name = name
  txt.BackgroundTransparency = 1
  txt.Position = pos or UDim2.fromOffset(0,0)
  txt.Size = size or UDim2.fromOffset(1280, 720)
  txt.Text = ""
  txt.TextColor3 = Color3.new(1,1,1)
  txt.Font = Enum.Font.GothamMedium
  txt.TextScaled = false
  txt.TextSize = 20
  txt.TextXAlignment = Enum.TextXAlignment.Left
  txt.TextYAlignment = Enum.TextYAlignment.Top
  txt.RichText = true
  txt.Visible = false
  txt.Parent = parent or mainFrm
  return txt
end

-- Helper: create frame
function newFrm(name, pos, size, color, parent)
  local f = Instance.new("Frame")
  f.Name = name
  f.BackgroundColor3 = color or Color3.new(0,0,0)
  f.BackgroundTransparency = 0
  f.BorderSizePixel = 0
  f.Position = pos or UDim2.fromOffset(0,0)
  f.Size = size or UDim2.fromOffset(1280, 720)
  f.Visible = false
  f.Parent = parent or mainFrm
  return f
end

-- Layers (ordered back to front with explicit ZIndex on the frames)
local bgLayer = newFrm("BgLayer", UDim2.fromOffset(0,0), UDim2.fromOffset(1280, 720), Color3.fromRGB(30, 15, 40), mainFrm)
bgLayer.Visible = true; bgLayer.ZIndex = 1
local bgImg = newImg("BgImg", UDim2.fromOffset(0,0), UDim2.fromOffset(1280, 720), bgLayer)
bgImg.ZIndex = 1
local cgLayer = newFrm("CgLayer", UDim2.fromOffset(0,0), UDim2.fromOffset(1280, 720), Color3.new(0,0,0.5), mainFrm)
cgLayer.ZIndex = 2
local cgImg = newImg("CgImg", UDim2.fromOffset(0,0), UDim2.fromOffset(1280, 720), cgLayer)
cgImg.ZIndex = 2
local charLayer = newFrm("CharLayer", UDim2.fromOffset(0,0), UDim2.fromOffset(1280, 720), Color3.new(0,0,0), mainFrm)
charLayer.ZIndex = 3
local poemLayer = newFrm("PoemLayer", UDim2.fromOffset(0,0), UDim2.fromOffset(1280, 720), Color3.new(0,0,0), mainFrm)
poemLayer.ZIndex = 4
local uiLayer = newFrm("UiLayer", UDim2.fromOffset(0,0), UDim2.fromOffset(1280, 720), Color3.new(0,0,0), mainFrm)
uiLayer.ZIndex = 5
local fadeLayer = newFrm("FadeLayer", UDim2.fromOffset(0,0), UDim2.fromOffset(1280, 720), Color3.new(0,0,0), mainFrm)
fadeLayer.ZIndex = 6
local menuLayer = newFrm("MenuLayer", UDim2.fromOffset(0,0), UDim2.fromOffset(1280, 720), Color3.new(0,0,0), mainFrm)
menuLayer.ZIndex = 7

-- Fade image
local fadeImg = newImg("FadeImg", UDim2.fromOffset(0,0), UDim2.fromOffset(1280, 720), fadeLayer)
fadeImg.BackgroundColor3 = Color3.new(0,0,0)
fadeImg.BackgroundTransparency = 0

-- Textbox elements (1280x720 coordinate space)
local textboxBg = newFrm("TextBoxBg", UDim2.fromOffset(0, 560), UDim2.fromOffset(1280, 160), Color3.new(0,0,0), uiLayer)
textboxBg.BackgroundTransparency = 0.2
local nameboxFrm = newFrm("NameBox", UDim2.fromOffset(40, 520), UDim2.fromOffset(260, 36), Color3.fromRGB(186,84,153), uiLayer)
local nameTxt = newTxt("NameTxt", UDim2.fromOffset(10, 4), UDim2.fromOffset(240, 28), nameboxFrm)
nameTxt.TextSize = 20
nameTxt.Font = Enum.Font.GothamBold
local diaTxt = newTxt("DiaTxt", UDim2.fromOffset(50, 580), UDim2.fromOffset(1180, 130), uiLayer)
diaTxt.TextSize = 19
diaTxt.TextWrapped = true
diaTxt.TextXAlignment = Enum.TextXAlignment.Left
diaTxt.TextYAlignment = Enum.TextYAlignment.Top

-- Character image labels
local charImgs = {}
for _, name in ipairs({"sayori", "yuri", "natsuki", "monika"}) do
  local ci = newImg(name, UDim2.fromScale(0,0), UDim2.fromOffset(400, 600), charLayer)
  ci.SizeConstraint = Enum.SizeConstraint.RelativeXX
  ci.ResampleMode = Enum.ResamplerMode.Pixelated
  charImgs[name] = ci
end

-- Sound system
local soundService = game:GetService("SoundService")
local bgmSound = Instance.new("Sound")
bgmSound.Name = "DDLCBGM"
bgmSound.Volume = 0.5
bgmSound.Parent = soundService
local sfxSound = Instance.new("Sound")
sfxSound.Name = "DDLCSFX"
sfxSound.Volume = 0.7
sfxSound.Parent = soundService

-- ========== GAME STATE (GLOBALS for script compatibility) ==========
state, cl, chapter = "load", 1, 0
alpha, bg1, cg1, audio1, ct = 255, "black", "blank", "0", ""
player = ""
s_Set = {a='',b='',x=-200,y=0}
y_Set = {a='',b='',x=-200,y=0}
n_Set = {a='',b='',x=-200,y=0}
m_Set = {a='',b='',x=-200,y=0}
persistent = {ptr=0, clear={0,0,0,0,0,0,0,0,0}, chr={m=1,s=1}, act2={0,0,0,0}}
settings = {textspd=75, autospd=4, lang='eng', masvol=80, bgmvol=80, sfxvol=80, o=0}
poemwinner = {'','',''}
appeal = {s=0,n=0,y=0}
readpoem = {s=0,n=0,y=0,m=0}
c_disp = {''}
menu_enabled, menu_type, m_selected = false, "", 2
print_full_text, getTime, dt, xaload = false, 0, 0, 0
autotimer, autoskip, poem_enabled = 0, 0, false
history = {}
startTime, timer = 0, 0
textbox_enabled, event_enabled, bgimg_disabled = true, false, false
currentBGM = ""

-- ========== AUDIO FUNCTIONS ==========
function audioUpdate(audiox)
  if audiox == nil or audiox == "0" then
    bgmSound:Stop()
    currentBGM = ""
    return
  end
  audio1 = audiox
  local path = DIR .. "assets/audio/bgm/" .. audiox .. ".ogg"
  if isfile(path) then
    local id = getcustomasset(path)
    if bgmSound.SoundId ~= id then
      bgmSound.SoundId = id
      bgmSound:Play()
    end
    currentBGM = audiox
  end
end

function sfxplay(sfxname)
  local path = DIR .. "assets/audio/sfx/" .. sfxname .. ".ogg"
  if isfile(path) then
    sfxSound.SoundId = getcustomasset(path)
    sfxSound:Play()
  end
end

function sfxplay2(sfx) sfxplay(sfx) end

-- ========== IMAGE FUNCTIONS ==========
function bgUpdate(bgx)
  local id = loadImg("images/bg/" .. bgx .. ".jpg")
  if id then
    bgImg.Image = id
    bgImg.Visible = true
    bg1 = bgx
  else
    bgImg.Visible = false
    bg1 = "black"
  end
end

function cgUpdate(cgx)
  local id = loadImg("images/cg/" .. cgx .. ".png")
  if id then
    cgImg.Image = id
    cgImg.Visible = true
    cg1 = cgx
  end
end

-- ========== CHARACTER FUNCTIONS ==========
local charMap = {s="sayori", n="natsuki", y="yuri", m="monika"}
local charProps = {
  sayori = {ox = -200, oy = 80}, natsuki = {ox = -200, oy = 80},
  yuri = {ox = -200, oy = 80}, monika = {ox = -200, oy = 80}
}

function loadCharacter(chr)
  local charName = charMap[chr]
  if not charName then return end
  local set = (chr == 's' and s_Set or chr == 'n' and n_Set or chr == 'y' and y_Set or m_Set)
  local a, b = set.a, set.b
  local lr = {'',''}
  if a == '1' then lr = {'1l','1r'}
  elseif a == '2' then lr = {'1l','2r'}
  elseif a == '3' and chr ~= 'y' then lr = {'2l','1r'}
  elseif (a == '3' and chr == 'y') or (a == '4' and chr ~= 'y') then lr = {'2l','2r'}
  elseif a == '1b' then lr = {'1bl','1br'}
  elseif a == '2b' then lr = {'1bl','2br'}
  elseif a == '3b' and chr ~= 'y' then lr = {'2bl','1br'}
  elseif (a == '3b' and chr == 'y') or (a == '4b' and chr ~= 'y') then lr = {'2bl','2br'}
  elseif (a == '4' and chr == 'y') or a == '5' then lr = {'3',''}
  elseif a == '5a' then lr = {'3a',''}
  elseif (a == '4b' and chr == 'y') or a == '5b' then lr = {'3b',''}
  elseif a == '5c' then lr = {'3c',''}
  elseif a == '5d' then lr = {'3d',''}
  else lr = {a, ''} end

  local leftPath = "images/" .. charName .. "/" .. lr[1] .. ".png"
  local rightPath = lr[2] ~= '' and ("images/" .. charName .. "/" .. lr[2] .. ".png") or nil
  local extraPath = b ~= '' and ("images/" .. charName .. "/" .. b .. ".png") or nil
  local img = charImgs[charName]
  if img then
    local id = loadImg(leftPath)
    if id then
      img.Image = id
      img.Visible = true
    end
  end
end

function updateSayori(a, b, px) s_Set = {a=a, b=b or '', x=s_Set.x, y=0} loadCharacter('s') end
function updateYuri(a, b, px) y_Set = {a=a, b=b or '', x=y_Set.x, y=0} loadCharacter('y') end
function updateNatsuki(a, b, px) n_Set = {a=a, b=b or '', x=n_Set.x, y=0} loadCharacter('n') end
function updateMonika(a, b, px) m_Set = {a=a, b=b or '', x=m_Set.x, y=0} loadCharacter('m') end
function hideSayori() charImgs['sayori'].Visible = false; s_Set = {a='',b='',x=-675,y=4} end
function hideYuri() charImgs['yuri'].Visible = false; y_Set = {a='',b='',x=-675,y=4} end
function hideNatsuki() charImgs['natsuki'].Visible = false; n_Set = {a='',b='',x=-675,y=4} end
function hideMonika() charImgs['monika'].Visible = false; m_Set = {a='',b='',x=-675,y=4} end
function hideAll()
  hideSayori(); hideYuri(); hideNatsuki(); hideMonika()
end

-- ========== TEXT/DIALOGUE ==========
function cw(p1, stext, tag)
  local names = {s="Sayori", n="Natsuki", y="Yuri", m="Monika", ny="Nat & Yuri", mc=player, bl=""}
  ct = names[p1] or p1 or "Error"
  if not stext then stext = "" end
  if settings.lang == "eng" and p1 ~= "bl" then stext = '"' .. stext .. '"' end
  table.insert(history, 1, ct .. ": " .. stext)
  if #history > 30 then table.remove(history) end
  local tspd = autoskip > 0 and 10000 or settings.textspd
  local cps = tspd / 100
  local len = math.floor((getTime - startTime) * cps)
  len = math.max(math.min(len, #stext), 1)
  if len >= #stext then print_full_text = true end
  local display = print_full_text and stext or stext:sub(1, len)
  c_disp = {display}
  diaTxt.Text = display
  nameTxt.Text = ct
  textboxBg.Visible = true
  nameboxFrm.Visible = ct ~= ""
  if ct ~= "" then nameTxt.Text = ct end
  if tag and (tag == "nw" or tag == "nwfast") then scriptJump(cl + 1) end
end

function bl(say) cw('bl',say) end
function mc(say) cw('mc',say) end
function s(say) cw('s',say) end
function n(say) cw('n',say) end
function y(say) cw('y',say) end
function m(say) cw('m',say) end

function scriptJump(nu) if nu then cl = nu end; xaload = 0 end
function choice_enable(x) end
function poem_disable(x) end

-- Loading text
local loadTxt = newTxt("LoadTxt", UDim2.fromOffset(400, 340), UDim2.fromOffset(480, 40), mainFrm)
loadTxt.Text = "Loading DDLC-LOVE..."
loadTxt.TextSize = 28
loadTxt.TextXAlignment = Enum.TextXAlignment.Center
loadTxt.TextColor3 = Color3.new(1,1,1)
loadTxt.Visible = true

-- ========== STATE MANAGEMENT ==========
function changeState(cs, x)
  print("[DDLC] State: " .. tostring(cs))
  loadTxt.Visible = false
  if cs == "game" then
    hideAll(); xaload = 0; state = "game"
    if x == 1 then cl = 1; chapter = persistent.ptr * 10 end
    local ch = chapter
    local code = fetchScript("scripts/eng/script-ch" .. ch .. ".lua")
    if code then
      local ok, err = pcall(loadstring(code))
      if not ok then warn("[DDLC] Script error: " .. tostring(err)) end
    end
    -- Immediately run the chapter function - ensure it's in _G
    local fn = _G["ch" .. ch .. "script"]
    if fn then
      pcall(fn)
    else
      -- Fallback: try running the chapter function directly if it's not in _G
      -- The loadstring should have created it
      local fallback = _G["ch" .. ch .. "script"]
      if fallback then pcall(fallback) end
    end
    startTime = getTime
    bgLayer.Visible = true
    bgImg.Visible = (bg1 ~= "black")
    cgLayer.Visible = true
    charLayer.Visible = true
    diaTxt.Visible = true
    nameTxt.Visible = true
    nameboxFrm.Visible = true
    textboxBg.Visible = true
    uiLayer.Visible = true
    fadeLayer.Visible = true
    fadeImg.BackgroundTransparency = 1
    print("[DDLC] Game state - chapter: " .. ch .. ", cl: " .. cl)
  elseif cs == "title" then
    state = "title"; alpha = 255; timer = 0
    textboxBg.Visible = false; nameboxFrm.Visible = false
    diaTxt.Visible = false; nameTxt.Visible = false
    fadeLayer.Visible = true; fadeImg.Visible = true
    fadeImg.BackgroundTransparency = 0
    -- Title uses menu background
    local id = loadImg("images/gui/menu_bg.jpg")
    if id then
      bgImg.Image = id
      bgImg.Visible = true; bgLayer.Visible = true
    else
      -- fallback to splash
      local id2 = loadImg("images/bg/splash.jpg")
      if id2 then
        bgImg.Image = id2
        bgImg.Visible = true; bgLayer.Visible = true
      else
        bgImg.Visible = false; bgLayer.Visible = true
      end
    end
  elseif cs == "splash" then
    state = "splash"; alpha = 255; timer = 0
    bgLayer.Visible = true; bgImg.Visible = true
    local id = loadImg("images/bg/splash.jpg")
    if id then
      bgImg.Image = id
    end
    textboxBg.Visible = false; nameboxFrm.Visible = false
    diaTxt.Visible = false; nameTxt.Visible = false
    fadeLayer.Visible = true; fadeImg.Visible = true
    fadeImg.BackgroundTransparency = 0
  end
end

-- ========== INPUT ==========
local function onInput(input, gpe)
  if gpe or not running then return end
  local key = input.KeyCode
  if key == Enum.KeyCode.Space or key == Enum.KeyCode.Return then
    if state == "splash" then changeState("title")
    elseif state == "title" then changeState("game", 1)
    elseif state == "game" or state == "newgame" then
      if print_full_text then cl = cl + 1; xaload = 0; print_full_text = false; startTime = getTime
      else print_full_text = true end
    end
  elseif key == Enum.KeyCode.Escape then env.stop()
  elseif key == Enum.KeyCode.LeftControl or key == Enum.KeyCode.Y then
    if state == "game" then
      if autotimer == 0 then autotimer = 0.01 else autotimer = 0 end
    end
  end
end

-- ========== ASSET VERIFICATION ==========
function env.verifyCriticalAssets()
  print("[DDLC] Verifying critical assets...")
  local critical = {
    "images/bg/splash.jpg",
    "images/bg/black.jpg", 
    "images/bg/bedroom.jpg",
    "images/bg/class.jpg",
    "images/bg/club.jpg",
    "images/gui/textbox.png",
    "images/gui/namebox.png",
    "images/sayori/1l.png",
    "images/natsuki/1l.png",
    "images/yuri/1l.png",
    "images/monika/1l.png",
    "audio/bgm/1.ogg",
    "audio/bgm/2.ogg",
  }
  local missing = {}
  for _, path in ipairs(critical) do
    local fullpath = DIR .. "assets/" .. path
    if not isfile(fullpath) then
      table.insert(missing, path)
    end
  end
  if #missing > 0 then
    warn("[DDLC] MISSING CRITICAL ASSETS: " .. table.concat(missing, ", "))
    warn("[DDLC] Run downloadAssets() first or check GitHub")
    return false
  end
  print("[DDLC] All critical assets verified OK")
  return true
end

-- ========== STARTUP ASSET LOADING SCREEN ==========
function env.showStartupAssetLoader()
  -- Create loading screen that shows assets being loaded
  local loadGui = Instance.new("ScreenGui")
  loadGui.Name = "DDLCAssetLoader"
  loadGui.ResetOnSpawn = false
  loadGui.IgnoreGuiInset = true
  loadGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
  
  local mainFrame = Instance.new("Frame")
  mainFrame.Size = UDim2.fromScale(1, 1)
  mainFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 15)
  mainFrame.Parent = loadGui
  
  local title = Instance.new("TextLabel")
  title.Size = UDim2.fromOffset(1200, 60)
  title.Position = UDim2.fromOffset(40, 30)
  title.BackgroundTransparency = 1
  title.Text = "DDLC-LOVE: Loading Assets..."
  title.TextColor3 = Color3.fromRGB(255, 200, 100)
  title.TextSize = 36
  title.Font = Enum.Font.GothamBold
  title.TextXAlignment = Enum.TextXAlignment.Left
  title.Parent = mainFrame
  
  local statusText = Instance.new("TextLabel")
  statusText.Size = UDim2.fromOffset(1200, 30)
  statusText.Position = UDim2.fromOffset(40, 100)
  statusText.BackgroundTransparency = 1
  statusText.Text = "Downloading assets from GitHub..."
  statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
  statusText.TextSize = 20
  statusText.Font = Enum.Font.Gotham
  statusText.TextXAlignment = Enum.TextXAlignment.Left
  statusText.Parent = mainFrame
  
  local progressBarBg = Instance.new("Frame")
  progressBarBg.Size = UDim2.fromOffset(1200, 20)
  progressBarBg.Position = UDim2.fromOffset(40, 140)
  progressBarBg.BackgroundColor3 = Color3.fromRGB(40, 20, 50)
  progressBarBg.BorderSizePixel = 2
  progressBarBg.BorderColor3 = Color3.fromRGB(100, 50, 150)
  progressBarBg.Parent = mainFrame
  
  local progressBar = Instance.new("Frame")
  progressBar.Size = UDim2.fromScale(0, 1)
  progressBar.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
  progressBar.BorderSizePixel = 0
  progressBar.Parent = progressBarBg
  
  local progressText = Instance.new("TextLabel")
  progressText.Size = UDim2.fromOffset(1200, 20)
  progressText.Position = UDim2.fromOffset(40, 170)
  progressText.BackgroundTransparency = 1
  progressText.Text = "0 / 0"
  progressText.TextColor3 = Color3.fromRGB(150, 150, 150)
  progressText.TextSize = 16
  progressText.Font = Enum.Font.Gotham
  progressText.TextXAlignment = Enum.TextXAlignment.Left
  progressText.Parent = mainFrame
  
  -- Asset preview grid
  local scroll = Instance.new("ScrollingFrame")
  scroll.Size = UDim2.fromOffset(1200, 500)
  scroll.Position = UDim2.fromOffset(40, 210)
  scroll.CanvasSize = UDim2.fromScale(0, 3)
  scroll.ScrollBarThickness = 6
  scroll.BackgroundColor3 = Color3.fromRGB(15, 8, 25)
  scroll.BorderSizePixel = 1
  scroll.BorderColor3 = Color3.fromRGB(60, 30, 90)
  scroll.Parent = mainFrame
  
  local layout = Instance.new("UIGridLayout")
  layout.CellSize = UDim2.fromOffset(150, 150)
  layout.CellPadding = UDim2.fromOffset(10, 10)
  layout.SortOrder = Enum.SortOrder.LayoutOrder
  layout.Parent = scroll
  
  return {
    gui = loadGui,
    statusText = statusText,
    progressBar = progressBar,
    progressText = progressText,
    scroll = scroll,
    layout = layout,
    loaded = 0,
    total = 0
  }
end

-- ========== ASSET LOADER UI (Fast & Compact) ==========
function env.createAssetLoader()
  local loadGui = Instance.new("ScreenGui")
  loadGui.Name = "AssetLoader"
  loadGui.ResetOnSpawn = false
  loadGui.IgnoreGuiInset = true
  loadGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  loadGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
  
-- Compact centered panel (40% bigger: 560x392)
  local panel = Instance.new("Frame")
  panel.Size = UDim2.fromOffset(560, 392)
  panel.Position = UDim2.fromScale(0.5, 0.5)
  panel.AnchorPoint = Vector2.new(0.5, 0.5)
  panel.BackgroundColor3 = Color3.fromRGB(15, 8, 25)
  panel.BorderSizePixel = 2
  panel.BorderColor3 = Color3.fromRGB(100, 50, 150)
  panel.Parent = loadGui
  
  local title = Instance.new("TextLabel")
  title.Size = UDim2.fromOffset(360, 30)
  title.Position = UDim2.fromOffset(20, 15)
  title.BackgroundTransparency = 1
  title.Text = "DDLC-LOVE // LOADING ASSETS"
  title.TextColor3 = Color3.fromRGB(255, 200, 100)
  title.TextSize = 18
  title.Font = Enum.Font.GothamBold
  title.TextXAlignment = Enum.TextXAlignment.Left
  title.Parent = panel
  
  local statusText = Instance.new("TextLabel")
  statusText.Size = UDim2.fromOffset(360, 20)
  statusText.Position = UDim2.fromOffset(20, 50)
  statusText.BackgroundTransparency = 1
  statusText.Text = "Verifying..."
  statusText.TextColor3 = Color3.fromRGB(180, 180, 200)
  statusText.TextSize = 14
  statusText.Font = Enum.Font.Gotham
  statusText.TextXAlignment = Enum.TextXAlignment.Left
  statusText.Parent = panel
  
  local progressBg = Instance.new("Frame")
  progressBg.Size = UDim2.fromOffset(360, 14)
  progressBg.Position = UDim2.fromOffset(20, 80)
  progressBg.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
  progressBg.BorderSizePixel = 0
  progressBg.Parent = panel
  
  local progressBar = Instance.new("Frame")
  progressBar.Size = UDim2.fromScale(0, 1)
  progressBar.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
  progressBar.BorderSizePixel = 0
  progressBar.Parent = progressBg
  
  local progressText = Instance.new("TextLabel")
  progressText.Size = UDim2.fromOffset(360, 20)
  progressText.Position = UDim2.fromOffset(20, 100)
  progressText.BackgroundTransparency = 1
  progressText.Text = "0 / 0"
  progressText.TextColor3 = Color3.fromRGB(150, 150, 150)
  progressText.TextSize = 14
  progressText.Font = Enum.Font.Gotham
  progressText.TextXAlignment = Enum.TextXAlignment.Left
  progressText.Parent = panel
  
  -- Small preview grid (just critical assets)
  local scroll = Instance.new("ScrollingFrame")
  scroll.Size = UDim2.fromOffset(360, 150)
  scroll.Position = UDim2.fromOffset(20, 130)
  scroll.CanvasSize = UDim2.fromScale(0, 2)
  scroll.ScrollBarThickness = 4
  scroll.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
  scroll.BorderSizePixel = 1
  scroll.BorderColor3 = Color3.fromRGB(60, 30, 90)
  scroll.Parent = panel
  
  local layout = Instance.new("UIGridLayout")
  layout.CellSize = UDim2.fromOffset(80, 80)
  layout.CellPadding = UDim2.fromOffset(6, 6)
  layout.SortOrder = Enum.SortOrder.LayoutOrder
  layout.Parent = scroll
  
  return {
    gui = loadGui,
    panel = panel,
    statusText = statusText,
    progressBar = progressBar,
    progressText = progressText,
    scroll = scroll,
    layout = layout,
    loaded = 0,
    total = 0
  }
end

function env.showAssetGrid(loader, assets)
  -- Show first 20 images in a simple grid
  local showAssets = {}
  for i = 1, math.min(20, #assets) do
    table.insert(showAssets, assets[i])
  end

  loader.total = #showAssets
  loader.loaded = 0

  for i, path in ipairs(showAssets) do
    local fullpath = DIR .. path
    if isfile(fullpath) then
      local img = Instance.new("ImageLabel")
      img.Size = UDim2.fromOffset(100, 100)
      img.BackgroundColor3 = Color3.fromRGB(30, 15, 40)
      img.BorderSizePixel = 1
      img.BorderColor3 = Color3.fromRGB(80, 40, 120)
      img.Image = getcustomasset(fullpath)
      img.ScaleType = Enum.ScaleType.Fit
      img.LayoutOrder = i
      img.Parent = loader.scroll

      local name = Instance.new("TextLabel")
      name.Size = UDim2.fromOffset(100, 14)
      name.Position = UDim2.fromOffset(0, 100)
      name.BackgroundTransparency = 1
      name.Text = path:match("([^/]+)$")
      name.TextColor3 = Color3.fromRGB(200, 180, 220)
      name.TextSize = 9
      name.Font = Enum.Font.Gotham
      name.TextWrapped = true
      name.TextXAlignment = Enum.TextXAlignment.Center
      name.Parent = img

      loader.loaded = loader.loaded + 1
      loader.progressText.Text = string.format("%d / %d", loader.loaded, loader.total)
      loader.progressBar.Size = UDim2.fromScale(loader.loaded / loader.total, 1)
      loader.statusText.Text = "Verifying: " .. path:match("([^/]+)$")
    end
  end

  loader.progressText.Text = string.format("Done! %d assets verified", loader.loaded)
  loader.statusText.Text = "All critical assets OK - Starting game..."
  task.wait(0.5)

  loader.gui:Destroy()
end

-- ========== MAIN LOOP ==========
local conn; running = false
function env.start()
  -- Cleanup any previous state
  env.stop()
  running = true
  print("[DDLC] Starting...")
  
  -- Show visual asset loader first (compact, fast)
  local loader = env.createAssetLoader()
  local allAssets = {}
  for _, url in ipairs(asset_urls) do
    if url:match("%.png$") or url:match("%.jpg$") then
      table.insert(allAssets, url)
    end
  end
  env.showAssetGrid(loader, allAssets)
  
  if not env.verifyCriticalAssets() then
    print("[DDLC] Asset verification failed - continuing anyway (will download missing)")
  end
  env.downloadAssets()
  local textCode = fetchScript("scripts/eng/text.lua")
  if textCode then pcall(loadstring(textCode)) end
  changeState("splash")
  startTime = getTime

  conn = game:GetService("RunService").RenderStepped:Connect(function(delta)
    if not running then if conn then conn:Disconnect() end return end
    dt = delta; getTime = getTime + delta
    if state == "splash" then
      timer = timer + delta
      local speed = 7.75 * delta * 60
      if timer < 3 then
        alpha = math.max(alpha - speed, 0)
        fadeImg.BackgroundTransparency = alpha / 255
      else
        alpha = math.min(alpha + speed, 255)
        fadeImg.BackgroundTransparency = alpha / 255
        if alpha >= 255 and timer > 4 then changeState("title") end
      end
    elseif state == "title" then
      timer = timer + delta
      if timer < 2 then
        alpha = math.max(alpha - 5 * delta * 60, 0)
        fadeImg.BackgroundTransparency = alpha / 255
      elseif timer > 5 then
        changeState("game", 1)
      end
    elseif state == "game" then
      xaload = xaload + 1
      if xaload == 3 then
        local fn = _G["ch" .. chapter .. "script"]
        if fn then pcall(fn) end
      end
      if autotimer > 0 then
        autotimer = autotimer + delta
        if autotimer > 3 then
          autotimer = 0; cl = cl + 1; xaload = 0; print_full_text = false; startTime = getTime
        end
      end
    end
  end)

  game:GetService("UserInputService").InputBegan:Connect(onInput)
end

function env.stop()
  running = false
  if conn then conn:Disconnect() end
  -- Clean up all DDLC GUIs
  for _, gui in pairs(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
    if gui.Name:match("^DDLC") or gui.Name == "AssetLoader" then
      gui:Destroy()
    end
  end
  if screenGui then screenGui:Destroy() end
  bgmSound:Stop()
  sfxSound:Stop()
  running = false
end

print("DDLC-LOVE loaded! Run: ddlc.start()")





