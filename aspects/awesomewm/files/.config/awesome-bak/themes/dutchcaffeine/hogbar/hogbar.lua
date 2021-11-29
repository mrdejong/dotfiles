local beautiful = require("beautiful")
local file_name = "hogbar"
local resources = {}

resources.networking_normal = beautiful.theme_path .. file_name .. "/networking/wifi_normal.svg"
resources.notifications_normal = beautiful.theme_path .. file_name .. "/notifications/bell.svg"
resources.notifications_slash_normal = beautiful.theme_path .. file_name .. "/notifications/bell_slash.svg"

return resources
