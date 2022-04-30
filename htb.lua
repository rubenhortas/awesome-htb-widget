local wibox = require("wibox")
local watch = require("awful.widget.watch")
local awful = require("awful")
local gears = require("gears")

-- Configure the interface
local interface = "tun0"
local target_ip_file = "/tmp/target"

local get_host_ip_command = string.format("ip addr show %s | grep -oE '[[:digit:].]{2,3}[[:digit:].]{2,3}[[:digit:].]{2,3}[[:digit:]]{2,3}/' | cut -d'/' -f1", interface)
local get_target_ip_command = "if [ -f /tmp/target ]; then cat /tmp/target; else echo \"off\"; fi"

-- Configure widgets appearance
local widgets_font = "sans 12"
local host_widget_fg_color = "#000000" -- Black text
local host_widget_bg_color = "#9fef00" -- Green background
local target_widget_fg_color = "#ffffff" -- White text
local target_widget_bg_color = "#ff3e3e" -- Red background

local host_ip = ""
local target_ip = "off"

local host_widget = wibox.widget {
	{
		font = widgets_font,
		widget = wibox.widget.textbox,
		text = "",
	},
	fg = host_widget_fg_color,
	bg = host_widget_bg_color,
	widget = wibox.container.background,
}

local target_widget = wibox.widget {
	{
		font = widgets_font,
		widget = wibox.widget.textbox,
		text = "",
	},
	fg = target_widget_fg_color,
	bg = target_widget_bg_color,
	widget = wibox.container.background,
}

local htb_widget = wibox.widget {
	host_widget,
	target_widget,
	layout = wibox.layout.align.horizontal,
}

host_widget.widget.text = ""
target_widget.widget.text = ""

gears.timer {
	timeout   = 10,
	call_now  = true,
	autostart = true,
	callback  = function()
	awful.spawn.easy_async_with_shell(get_host_ip_command,
		function(stdout, stderr, reason, exit_code)
			host_ip = string.gsub(stdout, "[\n\r]", "")

			awful.spawn.easy_async_with_shell(get_target_ip_command,
				function(stdout2, stderr2, reason2, exit2)
					target_ip = string.gsub(stdout2, "[\n\r]", "")
				end)
			
			if(host_ip ~= "") then
				host_widget.widget.text = string.format(" %s ", host_ip)
				target_widget.widget.text = string.format(" %s ", target_ip)
			end
		end)
	end
}

--Export the widget
return htb_widget
