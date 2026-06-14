-- Set programs that you use
require("programs")

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local secondMod = "ALT" -- Sets "Alt" key as second modifier
local bothMod = mainMod .. " + " .. secondMod -- Sets both modifiers

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal), { description = "Open terminal" })
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("~/.config/rofi/launcher1.sh"), { description = "Open Apps menu" })
hl.bind(bothMod .. " + DELETE", hl.dsp.exec_cmd("~/.config/rofi/powermenu.sh"), { description = "Power menu" })
hl.bind(bothMod .. " + 7", hl.dsp.exec_cmd("~/.config/rofi/keybindings.sh"), { description = "Open keybindings helper" })
--hl.bind(bothMod .. " + DELETE", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"), { description = "Shutdown or exit Hyprland" })
local closeWindowBind = hl.bind(mainMod .. " + F4", hl.dsp.window.close(), { description = "Close focused window" })
local closeWindowBind = hl.bind(mainMod .. " + X", hl.dsp.window.close(), { description = "Close focused window" })
local closeWindowBind = hl.bind(secondMod .. " + X", hl.dsp.window.close(), { description = "Close focused window" })
-- closeWindowBind:set_enabled(false)

------------------------------------
-------------PROGRAMS---------------
------------------------------------

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager), { description = "Open file manager" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("brave-origin"), { description = "Open Brave Origin" })
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("code"), { description = "Open VS Code" })
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("flameshot gui"), { description = "Screenshot" })
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle window float" })
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("NotepadNext"), { description = "Open NotepadNext" })
hl.bind(secondMod .. " + N", hl.dsp.exec_cmd("swaync-client -t"), { description = "Open Notification Center" })
hl.bind(bothMod .. " + N", hl.dsp.exec_cmd("swaync-client -t"), { description = "Open Notification Center" })
-- hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu), { description = "Open launcher menu" })
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(), { description = "Toggle pseudo fullscreen" })

-- Move focus with mainMod + arrow keys
hl.bind(secondMod .. " + TAB",  function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end,  { description = "Focus next window" })

hl.bind(secondMod .. " + left",  hl.dsp.focus({ direction = "left" }),  { description = "Focus window to the left" })
hl.bind(secondMod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Focus window to the right" })
hl.bind(secondMod .. " + up",    hl.dsp.focus({ direction = "up" }),    { description = "Focus window above" })
hl.bind(secondMod .. " + down",  hl.dsp.focus({ direction = "down" }),  { description = "Focus window below" })

-- Move windows with mainMod + SHIFT + arrow keys
hl.bind(bothMod .. " + left", hl.dsp.window.swap({ direction = "left" }), { description = "Swap tiled window left" })
hl.bind(bothMod .. " + right", hl.dsp.window.swap({ direction = "right" }), { description = "Swap tiled window right" })
hl.bind(bothMod .. " + up", hl.dsp.window.swap({ direction = "up" }), { description = "Swap tiled window up" })
hl.bind(bothMod .. " + down", hl.dsp.window.swap({ direction = "down" }), { description = "Swap tiled window down" })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + left",   hl.dsp.focus({ workspace = "e-1" }), { description = "Focus previous workspace" })
hl.bind(mainMod .. " + right",  hl.dsp.focus({ workspace = "e+1" }), { description = "Focus next workspace" })
-- hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Focus previous workspace" })
-- hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Focus next workspace" })

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}), { description = "Focus workspace " .. i })
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }), { description = "Move window to workspace " .. i })
end

-- Minimize window with special workspace
hl.bind(mainMod .. " + M", function ()
    hl.dispatch(hl.dsp.workspace.toggle_special("minimize"))
    hl.dispatch(hl.dsp.window.move({workspace = "+0"}))
    hl.dispatch(hl.dsp.workspace.toggle_special("minimize"))
    hl.dispatch(hl.dsp.window.move({workspace = "special:minimize"}))
    hl.dispatch(hl.dsp.workspace.toggle_special("minimize"))
end)

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true, description = "Drag window with mouse" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window with mouse" })


-- Laptop multimedia keys for volume and LCD brightness
-- hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true, description = "Increase volume" })
-- hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true, description = "Decrease volume" })
-- hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true, description = "Toggle volume mute" })
-- hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true, description = "Toggle microphone mute" })
-- hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true, description = "Increase screen brightness" })
-- hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true, description = "Decrease screen brightness" })

-- Requires playerctl
-- hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true, description = "Next media track" })
-- hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Play/Pause media" })
-- hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Play/Pause media" })
-- hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true, description = "Previous media track" })

