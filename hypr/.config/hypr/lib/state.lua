-- Runtime state written by the hypr scripts.
-- Read on every (re)load, so `hyprctl reload` is enough to apply changes.

local dir = (os.getenv("HOME") or "") .. "/.local/state/dotfiles/hypr/"

local function read(name)
  local f = io.open(dir .. name, "r")
  if not f then
    return nil
  end
  local v = f:read("l")
  f:close()
  return v and (v:gsub("%s+$", "")) or nil
end

return {
  zen = read("zen-mode") == "true",
  accent = read("accent") or "rgb(6f8396)",
}
