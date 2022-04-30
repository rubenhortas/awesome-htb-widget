# awesome htb widget
A simple widget to show the ips of your vpn interface and yout target machine while you are playing in [hack the box](https://app.hackthebox.com/)

## Screenshots


## Installation

Clone the repo under your widgets folder: 
  - If you are using a custom theme: ~/.config/awesome/widgets/
  - If you are using a default theme: /usr/share/awesome/lib/ (requires root privileges)

Edit _awesome-htb-widget/ip.lua_ and set your interface name

```lua
local interface = "tun0" --Change enp0s3 for your interface name
```


Edit your _lua.rc_ file and add the following
  - If you are using a custom theme: ~/.config/awesome/rc.lua
  - If you are using a default theme: /etc/xdg/awesome/lua.rc (requires root privileges)

```lua
local htb_widget = require("awesome-htb-widget.ip")

...
s.mytasklist, -- Middle widget
{ -- Right widgets
  layout = wibox.layout.fixed.horizontal,
	...
	htb_widget,
	...
},
```

Restart awesome ;)

## Troubleshooting

In case of any problem create an [issue](https://github.com/rubenhortas/awesome-htb-widget/issues/new)

## Support

If you find this widget useful you can star this repo.
