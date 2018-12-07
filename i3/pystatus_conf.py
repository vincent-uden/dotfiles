#!/usr/bin/python3
from i3pystatus import Status

main_color = "#ffffff"
status = Status()

status.register("clock",
        format="%X ",
        color=main_color)

status.register("battery",
    format="Bat:{status} {percentage:.2f}% {remaining:%E%hh:%Mm}",
    alert=True,
    alert_percentage=5,
    status={
        "DIS": "",
        "CHR": "+",
        "FULL": "",
    },
    color=main_color,
    charging_color="#008800")

# Note: requires both netifaces and basiciw (for essid and quality)
status.register("network",
    interface="wlp3s0",
    format_up="{essid} {quality:03.0f}% {v4}",
    color_up=main_color,
    color_down="#ff4100"
    )

# Shows disk usage of /
# Format:
# 42/128G [86G]
status.register("disk",
    path="/",
    format="{used}/{total}GB -{avail}GB",
    color=main_color)

# Shows pulseaudio default sink volume
#
# Note: requires libpulseaudio from PyPI
status.register("pulseaudio",
    format="♪{volume}",
    color_muted=main_color,
    color_unmuted=main_color
    )

status.register("keyboard_locks",
        format="{num}",
        num_on="NUM",
        num_off="num",
        color="#ee0000")

status.run()
