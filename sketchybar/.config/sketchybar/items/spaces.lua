local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

-- Add aerospace workspace change event
sbar.add("event", "aerospace_workspace_change")

-- Use predefined workspaces 1-9
local workspaces = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

for _, sid in ipairs(workspaces) do
  local space = sbar.add("item", "space." .. sid, {
    position = "left",
    drawing = false, -- Start hidden, will show active ones
    icon = {
      font = { family = settings.font.numbers },
      string = sid,
      padding_left = 10,
      padding_right = 5,
      color = colors.white,
      highlight_color = colors.yellow,
    },
    label = {
      padding_right = 12,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:12.0",
      y_offset = -1,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 22,
      corner_radius = 6,
      border_color = colors.bg2,
    },
  })

  spaces[sid] = space

  -- Padding item
  sbar.add("item", "space.padding." .. sid, {
    position = "left",
    drawing = false,
    width = settings.group_paddings,
  })

  space:subscribe("mouse.clicked", function(env)
    sbar.exec("aerospace workspace " .. sid)
  end)
end

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

local spaces_indicator = sbar.add("item", {
  padding_left = 4,
  padding_right = 0,
  icon = {
    padding_left = 6,
    padding_right = 6,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 6,
    string = "Spaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  }
})

-- Function to update workspace visibility and app icons
local function update_workspaces()
  -- Single call to get all workspace info at once
  sbar.exec("aerospace list-workspaces --monitor all --empty no", function(non_empty_result)
    local active_workspaces = {}
    for ws in non_empty_result:gmatch("%S+") do
      active_workspaces[ws] = true
    end

    sbar.exec("aerospace list-workspaces --focused", function(focused)
      focused = focused:gsub("%s+", "")

      -- Always show focused workspace even if empty
      active_workspaces[focused] = true

      -- Batch update all workspaces
      for _, sid in ipairs(workspaces) do
        local is_active = active_workspaces[sid] == true
        local is_focused = sid == focused

        -- Update visibility and highlight in one call
        spaces[sid]:set({
          drawing = is_active,
          icon = { highlight = is_focused },
          label = { highlight = is_focused },
          background = { border_color = is_focused and colors.yellow or colors.bg2 }
        })

        -- Update app icons only for active workspaces
        if is_active then
          sbar.exec("aerospace list-windows --workspace " .. sid .. " --format '%{app-name}'", function(result)
            local icon_line = ""
            local no_app = true
            for app in result:gmatch("[^\r\n]+") do
              no_app = false
              local lookup = app_icons[app]
              local icon = ((lookup == nil) and app_icons["Default"] or lookup)
              icon_line = icon_line .. icon
            end

            if no_app then
              icon_line = " —"
            end

            sbar.animate("tanh", 10, function()
              spaces[sid]:set({ label = icon_line })
            end)
          end)
        end
      end
    end)
  end)
end

-- Update on workspace change
space_window_observer:subscribe("aerospace_workspace_change", function(env)
  update_workspaces()
end)

-- Update on app switch (to catch new windows)
space_window_observer:subscribe("front_app_switched", function(env)
  update_workspaces()
end)

-- Initial update
update_workspaces()


spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on
  })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0, }
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
