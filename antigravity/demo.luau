-- â•”â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•—
-- â•‘          AntiGravity UI Demo  Â·  v1.0                           â•‘
-- â•‘          Load with: dofile("antigravity/demo.luau")             â•‘
-- â•‘          Press INSERT to toggle menu visibility                  â•‘
-- â•šâ•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

local AGY = dofile("antigravity/lib/core.luau")

local win = AGY:Window({
    name      = "AntiGravity",
    toggleKey = "Insert",
})

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  RAGE TAB
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local rage = win:Tab({ name = "Rage" })

local killAura = rage:Section({ name = "Kill Aura", side = "left" })
killAura:Toggle({ name = "Enabled",           flag = "ka_on",      default = false }):AddKeybind({ default = "F" })
killAura:Toggle({ name = "Team Check",         flag = "ka_team",    default = true  })
killAura:Toggle({ name = "Auto Attack",        flag = "ka_auto",    default = false, hasOptions = true })
killAura:Toggle({ name = "Auto Equip Weapon",  flag = "ka_equip",   default = false })
killAura:Slider({ name = "Hit Chance",         flag = "ka_hitpct",  min = 0, max = 100, default = 50,  suffix = "%" })
killAura:Dropdown({ name = "Target",           flag = "ka_target",  options = { "Lowest Health", "Closest", "Crosshair" }, default = "Lowest Health" })
killAura:Dropdown({ name = "Hitboxes",         flag = "ka_hitbox",  options = { "Torso", "Head", "All" },                  default = "Torso" })

local other = rage:Section({ name = "Other", side = "right" })
other:Dropdown({ name = "History",         flag = "oth_hist",   options = { "High", "Medium", "Low" }, default = "High" })
other:Toggle({  name = "Delay Shot",       flag = "oth_delay",  default = false })
other:Toggle({  name = "Remove Recoil",    flag = "oth_rcl",    default = false })
other:Toggle({  name = "Remove Spread",    flag = "oth_spd",    default = false })
other:Toggle({  name = "Quick Peek",       flag = "oth_qpa",    default = false, hasOptions = true }):AddKeybind({ default = "C" })
other:Toggle({  name = "Double Tap",       flag = "oth_dt",     default = false, hasOptions = true }):AddKeybind({ default = "X" })

local exploits = rage:Section({ name = "Exploits", side = "left" })
exploits:Dropdown({ name = "Multipoint",   flag = "exp_mp",     options = { "Head", "Torso", "Off" },          default = "Head" })
exploits:Slider({   name = "Min Damage",   flag = "exp_dmg",    min = 0, max = 126, default = 15, suffix = "" })
exploits:Toggle({   name = "Quick Stop",   flag = "exp_qs",     default = false, hasOptions = true }):AddKeybind({ default = "V" })
exploits:Toggle({   name = "Quick Scope",  flag = "exp_qsc",    default = false })

local antiAim = rage:Section({ name = "Anti-Aim", side = "right" })
antiAim:Toggle({   name = "Enabled",       flag = "aa_on",      default = false, hasOptions = true }):AddKeybind({ default = "Z" })
antiAim:Dropdown({ name = "Pitch",         flag = "aa_pitch",   options = { "Down", "Up", "Zero" },             default = "Down" })
antiAim:Dropdown({ name = "Yaw",           flag = "aa_yaw",     options = { "Backwards", "Spin", "Jitter" },    default = "Backwards" })
antiAim:Toggle({   name = "Freestanding",  flag = "aa_fs",      default = false })
antiAim:Toggle({   name = "Mouse Override",flag = "aa_mo",      default = false })

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  LEGIT TAB
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local legit = win:Tab({ name = "Legit" })

local aimSec = legit:Section({ name = "Aim Assist", side = "left" })
aimSec:Toggle({   name = "Enabled",   flag = "la_on",      default = false }):AddKeybind({ default = "K" })
aimSec:Slider({   name = "FOV",       flag = "la_fov",     min = 1, max = 360, default = 90, suffix = "Â°" })
aimSec:Slider({   name = "Smoothness",flag = "la_smooth",  min = 1, max = 20,  default = 8  })
aimSec:Dropdown({ name = "Aim Part",  flag = "la_part",    options = { "Head", "Torso", "HumanoidRootPart" }, default = "Head" })

local legitOther = legit:Section({ name = "Trigger Bot", side = "right" })
legitOther:Toggle({ name = "Enabled",     flag = "tb_on",    default = false }):AddKeybind({ default = "T" })
legitOther:Slider({ name = "Delay (ms)",  flag = "tb_delay", min = 0, max = 500, default = 80, suffix = "ms" })
legitOther:Dropdown({ name = "Bone",      flag = "tb_bone",  options = { "Head", "Torso", "Any" }, default = "Torso" })

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  VISUALS TAB
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local visuals = win:Tab({ name = "Visuals" })

local espSec = visuals:Section({ name = "Player ESP", side = "left" })
espSec:Toggle({ name = "Box",         flag = "esp_box",   default = false })
espSec:Toggle({ name = "Name",        flag = "esp_name",  default = false })
espSec:Toggle({ name = "Health Bar",  flag = "esp_hp",    default = false })
espSec:Toggle({ name = "Skeleton",    flag = "esp_skel",  default = false })
espSec:Toggle({ name = "Head Dot",    flag = "esp_head",  default = false })
espSec:Slider({ name = "Opacity",     flag = "esp_alpha", min = 0, max = 100, default = 100, suffix = "%" })

local worldSec = visuals:Section({ name = "World", side = "right" })
worldSec:Toggle({ name = "Chams",       flag = "vis_chams",  default = false })
worldSec:Toggle({ name = "No Flash",    flag = "vis_noflash",default = false })
worldSec:Toggle({ name = "No Smoke",    flag = "vis_nosmoke",default = false })
worldSec:Dropdown({ name = "Sky",       flag = "vis_sky",    options = { "Default", "Dark", "None" }, default = "Default" })

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  MISC TAB
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local misc = win:Tab({ name = "Misc" })

local moveSec = misc:Section({ name = "Movement", side = "left" })
moveSec:Toggle({ name = "BunnyHop",     flag = "mv_bhop",   default = false })
moveSec:Toggle({ name = "Speedhack",    flag = "mv_speed",  default = false })
moveSec:Slider({ name = "Speed",        flag = "mv_speedv", min = 16, max = 150, default = 32 })
moveSec:Toggle({ name = "No Clip",      flag = "mv_noclip", default = false }):AddKeybind({ default = "N" })

local cfgSec = misc:Section({ name = "Config", side = "right" })
cfgSec:Button({ name = "Save Config",   callback = function() win:SaveConfig() end })
cfgSec:Button({ name = "Load Config",   callback = function() win:LoadConfig() end })
cfgSec:Separator()
cfgSec:Button({ name = "Reset All",     callback = function()
    AGY.Flags = {}
    win:Notify("Flags reset to defaults")
end })
cfgSec:Button({ name = "Copy to Clipboard", callback = function()
    pcall(function()
        local ok, json = pcall(function()
            return game:GetService("HttpService"):JSONEncode(AGY.Flags)
        end)
        if ok then
            setclipboard(json)
            win:Notify("Flags copied to clipboard!")
        end
    end)
end })

print("[AntiGravity] Loaded! Press " .. AGY._ToggleKey .. " to toggle menu.")
return AGY