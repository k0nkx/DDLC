-- DDLC-LOVE for Roblox Executor (Xeno Compatible)
-- Downloads assets from GitHub, runs visual novel via Drawing API

getgenv().ddlc = {}
local env = getgenv().ddlc

local BASE = "https://raw.githubusercontent.com/k0nkx/DDLC/main/"
local DIR = "DDLC/"

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
    local parts = {}
    for part in relpath:gmatch("[^/]+") do table.insert(parts, part) end
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

-- ========== DRAWING SETUP ==========
local dw, dh = 1280, 720
local vp = workspace.CurrentCamera.ViewportSize

local images = {}
local textPool, squarePool = {}, {}
local function text(key)
  if textPool[key] then return textPool[key] end
  local t = Drawing.new("Text"); t.Visible = false; t.Color = Color3.new(1,1,1); t.Size = 23; t.Font = 3
  textPool[key] = t; return t
end
local function square(key)
  if squarePool[key] then return squarePool[key] end
  local s = Drawing.new("Square"); s.Visible = false; s.Filled = true; s.Thickness = 0
  squarePool[key] = s; return s
end

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
startTime = 0
timer = 0
textbox_enabled = true
event_enabled = false
bgimg_disabled = false

local bgImg, cgImg = nil, nil

-- ========== ENGINE FUNCTIONS ==========
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
  local wrapped = ""
  local here = 1
  display:gsub("(%s+)()(%S+)()", function(_, sp, word, fi)
    if fi - here > 65 then here = sp; wrapped = wrapped .. "\n" .. word else wrapped = wrapped .. word end
  end)
  if wrapped == "" then wrapped = display end
  c_disp = {wrapped}
  if tag and (tag == "nw" or tag == "nwfast") then scriptJump(cl + 1) end
end

function bl(say) cw('bl',say) end
function mc(say) cw('mc',say) end
function s(say) cw('s',say) end
function n(say) cw('n',say) end
function y(say) cw('y',say) end
function m(say) cw('m',say) end

function bgUpdate(bgx)
  local path = "assets/images/bg/" .. bgx .. ".jpg"
  local key = "bg_" .. bgx
  if isfile(DIR .. path) then
    local ca = getcustomasset(DIR .. path)
    if not images[key] then
      local img = Drawing.new("Image"); img.Image = ca; img.Visible = false; img.Size = Vector2.new(vp.X, vp.Y)
      images[key] = img
    end
    bgImg = images[key]; bg1 = bgx
  end
end

function cgUpdate(cgx)
  local path = "assets/images/cg/" .. cgx .. ".png"
  local key = "cg_" .. cgx
  if isfile(DIR .. path) then
    local ca = getcustomasset(DIR .. path)
    if not images[key] then
      local img = Drawing.new("Image"); img.Image = ca; img.Visible = false; img.Size = Vector2.new(vp.X, vp.Y)
      images[key] = img
    end
    cgImg = images[key]; cg1 = cgx
  end
end

function audioUpdate(audiox)
  audio1 = audiox or "0"
end

function sfxplay(sfx) end
function sfxplay2(sfx) end

function updateSayori(a, b, px)
  s_Set = {a=a, b=b or '', x=s_Set.x, y=0}
end
function updateYuri(a, b, px)
  y_Set = {a=a, b=b or '', x=y_Set.x, y=0}
end
function updateNatsuki(a, b, px)
  n_Set = {a=a, b=b or '', x=n_Set.x, y=0}
end
function updateMonika(a, b, px)
  m_Set = {a=a, b=b or '', x=m_Set.x, y=0}
end
function hideSayori() s_Set = {a='',b='',x=-675,y=4} end
function hideYuri() y_Set = {a='',b='',x=-675,y=4} end
function hideNatsuki() n_Set = {a='',b='',x=-675,y=4} end
function hideMonika() m_Set = {a='',b='',x=-675,y=4} end
function hideAll()
  s_Set = {a='',b='',x=-675,y=4}
  y_Set = {a='',b='',x=-675,y=4}
  n_Set = {a='',b='',x=-675,y=4}
  m_Set = {a='',b='',x=-675,y=4}
end

function scriptJump(nu)
  if nu then cl = nu end; xaload = 0
end

function choice_enable(x) end
function poem_disable(x) end
function changeState(cs, x)
  print("[DDLC] State: " .. tostring(cs))
  if cs == "game" then
    hideAll(); xaload = 0; state = "game"
    if x == 1 then cl = 1; chapter = persistent.ptr * 10 end
    local ch = chapter
    local code = fetchScript("scripts/eng/script-ch" .. ch .. ".lua")
    if code then pcall(loadstring(code)) end
    startTime = getTime
  elseif cs == "title" then
    state = "title"; alpha = 0; timer = 0
  elseif cs == "splash" then
    state = "splash"; alpha = 0; timer = 0
  end
end

-- ========== RENDER ==========
local function renderFrame()
  local bgs = square("bg")
  bgs.Visible = true; bgs.Color = Color3.new(0,0,0); bgs.Size = Vector2.new(vp.X, vp.Y); bgs.Position = Vector2.new(0,0)

  if state == "load" then
    local t = text("loadT"); t.Visible = true; t.Text = "Loading DDLC-LOVE..."; t.Size = 28; t.Position = Vector2.new(vp.X/2-80, vp.Y/2)
    return
  end

  if bgImg then bgImg.Visible = true; bgImg.Position = Vector2.new(0,0) end
  if cgImg then cgImg.Visible = true; cgImg.Position = Vector2.new(0,0) end

  if state == "game" or state == "newgame" then
    if textbox_enabled then
      local tb = square("tb"); tb.Visible = true; tb.Color = Color3.new(0,0,0); tb.Size = Vector2.new(vp.X, vp.Y*0.2); tb.Position = Vector2.new(0, vp.Y*0.8)
      if ct ~= "" then
        local nb = square("nb"); nb.Visible = true; nb.Color = Color3.fromRGB(186,84,153); nb.Size = Vector2.new(200,28); nb.Position = Vector2.new(30, vp.Y*0.77)
        local nt = text("nt"); nt.Visible = true; nt.Text = ct; nt.Size = 18; nt.Color = Color3.new(1,1,1); nt.Position = Vector2.new(40, vp.Y*0.775)
      end
      if c_disp[1] then
        local dt = text("dt"); dt.Visible = true; dt.Text = c_disp[1]; dt.Size = 16; dt.Color = Color3.new(1,1,1); dt.Position = Vector2.new(40, vp.Y*0.82)
      end
    end
    if autotimer > 0 then
      local st = text("autoT"); st.Visible = true; st.Text = "Auto"; st.Size = 16; st.Position = Vector2.new(10,20); st.Color = Color3.new(1,1,1)
    end
  end

  if alpha < 255 then
    local fd = square("fd"); fd.Visible = true; fd.Color = Color3.new(0,0,0); fd.Size = Vector2.new(vp.X, vp.Y); fd.Position = Vector2.new(0,0); fd.Transparency = 1 - alpha/255
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

-- ========== MAIN LOOP ==========
local conn; running = false
function env.start()
  if running then return end
  running = true
  print("[DDLC] Starting...")
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
      if timer < 3 then alpha = math.min(alpha + 7.75 * delta * 60, 255)
      else alpha = math.max(alpha - 7.75 * delta * 60, 0)
        if alpha == 0 and timer > 4 then changeState("title") end
      end
    elseif state == "title" then
      timer = timer + delta; alpha = math.min(alpha + 5 * delta * 60, 255)
    elseif state == "game" then
      xaload = xaload + 1
      if xaload > 2 then
        local fn = _G["ch" .. chapter .. "script"]
        if fn then pcall(fn) end
      end
      if autotimer > 0 then
        autotimer = autotimer + delta
        if autotimer > 3 then autotimer = 0; cl = cl + 1; xaload = 0; print_full_text = false; startTime = getTime end
      end
    end
    renderFrame()
  end)

  game:GetService("UserInputService").InputBegan:Connect(onInput)
end

function env.stop()
  running = false
  if conn then conn:Disconnect() end
  for _, v in pairs(images) do if v and v.Visible ~= nil then v.Visible = false end end
  for _, v in pairs(textPool) do if v and v.Visible ~= nil then v.Visible = false end end
  for _, v in pairs(squarePool) do if v and v.Visible ~= nil then v.Visible = false end end
end

print("DDLC-LOVE loaded! Run: ddlc.start()")
