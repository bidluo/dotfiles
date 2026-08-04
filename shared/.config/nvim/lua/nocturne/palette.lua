-- Nocturne base16 palette.
--
-- This is the *default* (used before matugen has generated anything, and as a
-- fallback). matugen writes lua/nocturne/generated.lua on wallpaper change; if
-- that file exists it wins, so Neovim tracks the desktop palette live.
--
-- Slot meanings (base16 convention):
--   base00 darkest bg   base03 comments      base08 red/vars    base0C cyan/support
--   base01 bg           base04 dark fg        base09 orange/nums base0D blue/funcs
--   base02 selection    base05 default fg     base0A yellow/cls  base0E purple/kw
--   base03 -            base06 light fg       base0B green/str   base0F deprecated
--                       base07 lightest fg

local default = {
  base00 = "#0f1115", -- deep near-black (matches the desktop background)
  base01 = "#161920",
  base02 = "#232a34", -- selection
  base03 = "#4a515e", -- comments / line-nr
  base04 = "#8a929f",
  base05 = "#c8ccd4", -- default fg
  base06 = "#e2e6ec",
  base07 = "#f5f7fa",
  base08 = "#ff6b6b", -- red     — variables, errors
  base09 = "#ffcc66", -- amber   — numbers, constants
  base0A = "#ffd580", -- warm    — classes, search
  base0B = "#00ff99", -- mint    — strings  ← signature
  base0C = "#00d9c0", -- teal    — support, regex
  base0D = "#33ccff", -- cyan    — functions ← signature
  base0E = "#cc99ff", -- violet  — keywords
  base0F = "#ff99cc", -- pink    — deprecated
}

local ok, generated = pcall(require, "nocturne.generated")
if ok and type(generated) == "table" and generated.base00 then
  return generated
end
return default
