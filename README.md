# awesome htb widget
A simple widget to show the IPs of your VPN interface and your target machine while you are playing in [hack the box](https://app.hackthebox.com/)\
It's also good to see the IP of your VPN interface (and) if the interface is up. 

## Screenshots
- With target on\
![Screenshot target on](https://github.com/rubenhortas/awesome-htb-widget/blob/main/screenshots/target_on_screenshot.jpg)

- With target off\
![Screenshot target off](https://github.com/rubenhortas/awesome-htb-widget/blob/main/screenshots/target_off_screenshot.jpg)

(If the VPN interface is down the widget is not shown)

## Installation and configuration

Clone the repo under your widgets folder: 
  - If you are using a custom theme: ~/.config/awesome/widgets/
  - If you are using a default theme: /usr/share/awesome/lib/ (requires root privileges)

Edit **_awesome-htb-widget/ip.lua_** file and set your interface name

```lua
local interface = "tun0" --Change tun0 for your interface name
```

Edit your **_lua.rc_** file and add the following
  - If you are using a custom theme: ~/.config/awesome/rc.lua
  - If you are using a default theme: /etc/xdg/awesome/lua.rc (requires root privileges)

```lua
local htb_widget = require("widgets.awesome-htb-widget.htb")

...
s.mytasklist, -- Middle widget
{ -- Right widgets
  layout = wibox.layout.fixed.horizontal,
	...
	htb_widget,
	...
},
```

Add the following [alias](https://github.com/rubenhortas/awesome-htb-widget/blob/main/target_function) to your shell (.bashrc, .zshrc, etc):

```bash
function target() {
    if [[ $# -eq 0 ]] then
        rm -rf /tmp/target
    else
        echo $1 > /tmp/target
    fi
}
```

## Getting the _target_ alias working
Log off and log in or read and execute your shell with the _source_ command to get the new alias working:

```bash
$ source ~/.bashrc # or .zshrc, etc
```

Restart awesome ;)

## Setting and unsetting the target
- Setting a target (execute _target_ passing as parameter the ip of the target machine)
```bash
$ target 13.12.11.10
```
- Unsetting a target (execute _target_ without paramters)
```bash
$ target
```

## Troubleshooting

In case of any problem create an [issue](https://github.com/rubenhortas/awesome-htb-widget/issues/new)

## Support

If you find this widget useful you can star this repo.
