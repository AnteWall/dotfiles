local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local menubar = sbar.add("item", "widgets.menubar", {
  position = "right",
  icon = {
    string = icons.menubar,
    color = colors.lavender,
    font = {
      style = settings.font.style_map["Bold"],
      size = 15.0,
    },
  },
  label = { drawing = false },
  popup = { align = "center" },
})

local hint = sbar.add("item", {
  position = "popup." .. menubar.name,
  icon = { drawing = false },
  label = {
    string = "Native menu bar visible. Click again to hide.",
    width = 260,
    align = "center",
  },
})

local visible = false

local function set_menubar(show)
  visible = show
  local opacity = show and "1.0" or "0.0"
  sbar.exec("yabai -m config menubar_opacity " .. opacity)
  menubar:set({
    icon = { color = show and colors.green or colors.lavender },
    popup = { drawing = show },
  })
  hint:set({ drawing = show })
end

menubar:subscribe("mouse.clicked", function()
  set_menubar(not visible)
end)

menubar:subscribe("mouse.exited.global", function()
  if visible then set_menubar(false) end
end)

sbar.add("bracket", "widgets.menubar.bracket", { menubar.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.menubar.padding", {
  position = "right",
  width = settings.group_paddings
})
