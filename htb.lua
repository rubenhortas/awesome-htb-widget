local wibox = require("wibox")
local watch = require("awful.widget.watch")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local interface = "tun0" -- Set the interface name here
local target_ip_file = "/tmp/target"

local get_host_ip_command = string.format("ip addr show %s | grep -oE '[[:digit:].]{2,3}[[:digit:].]{2,3}[[:digit:].]{2,3}[[:digit:]]{2,3}/' | cut -d'/' -f1", interface)
local get_target_ip_command = "if [ -f /tmp/target ]; then cat /tmp/target; else echo \"\"; fi"

-- Configure widgets appearance
local widgets_font = beautiful.font -- Set font size here (family, name size...)
local host_widget_fg_color = "#000000" -- Black text
local host_widget_bg_color = "#9fef00" -- Green background
local target_widget_fg_color = "#ffffff" -- White text
local target_widget_bg_color = "#ff3e3e" -- Red background

local host_ip = ""
local target_ip = ""

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
	layout = wibox.layout.fixed.horizontal,
}

local function show_widgets(show_host_widget, show_target_widget)
	host_widget.visibile = show_host_widget
	target_widget.visible = show_target_widget
end

local function get_formated_text(text)
	if(text ~= "") then
		return string.format(" %s ", text)
	else
		return text
	end
end

local function set_widgets_text(host_widget_text, target_widget_text)
	host_widget.widget.text = get_formated_text(host_widget_text)
	target_widget.widget.text = get_formated_text(target_widget_text)
end

local function get_normalized_output(output)
	return string.gsub(output, "[\n\r]", "")
end

gears.timer {
	timeout   = 1,
	call_now  = true,
	autostart = true,
	callback  = function()
	awful.spawn.easy_async_with_shell(get_host_ip_command,
		function(stdout, _, _, _)
			host_ip = get_normalized_output(stdout)

			awful.spawn.easy_async_with_shell(get_target_ip_command,
				function(stdout2, _, _, _)
					target_ip = get_normalized_output(stdout2)
					
					set_widgets_text(host_ip, target_ip)
					show_widgets(host_ip ~= "", target_ip ~= "")

					if(host_ip == "") then
						awful.spawn.easy_async_with_shell(string.format("rm %s", target_ip_file),
							function()
						end)
					end
				end)
		end)
	end
}

--Export the widget
return htb_widget
