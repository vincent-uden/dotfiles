# config.nu
#
# Installed by:
# version = "0.104.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

source ~/.zoxide.nu

$env.config.buffer_editor = "nvim"
$env.config = ($env.config
  | upsert use_ansi_coloring true
  | upsert color_config {
      header: 'def'
      hints: 'def'
      empty: 'def'
      string: 'def'
      int: 'def'
      bool: 'def'
      date: 'def'
      duration: 'def'
      filesize: 'def'
      path: 'def'
      record: 'def'
      list: 'def'
      separator: 'def'
    }
)
$env.LS_COLORS = 'di=1;34:ln=36:so=35:pi=33:ex=1;32:bd=1;33;44:cd=1;33;44:su=37;41:sg=30;43:tw=30;42:ow=34;43:or=31:mi=31:fi=0'


def show_banner [] {
    let ip_info = ip -o -f inet addr show wlan0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}'

    let battery_name = upower -e | grep BAT
    let battery_info = upower -i $battery_name

    let info_rows = ($battery_info | split row "\n" | skip 9 | first 16 | each {|row| $row | str trim})

    let battery_table = ($info_rows | each {|row| 
        let fields = $row | split row ":"
        { name: ($fields.0 | str trim), value: ($fields.1 | str trim) }
    })

    print $"(ansi light_blue_bold) ⢸⣿⣿⣿⣿⣿⣿⣿⣷⣦⡀⠀⢸⣿⣿⠀⠀⠀⠀⠀(ansi reset) │ (ansi blue_bold)Vincent Udén(ansi reset)"
    print $"(ansi light_blue_bold) ⢸⣿⣿⡇⠀⠀⠀⠉⣿⣿⣷⠀⢸⣿⣿⠀⠀⠀⠀⠀(ansi reset) ├───────────────────"
    print $"(ansi light_blue_bold) ⢸⣿⣿⣇⣀⣀⣀⣠⣿⣿⠏⠀⢸⣿⣿⠀⠀⠀⠀⠀(ansi reset) │ (ansi blue_underline)vincent.uden@ri.se(ansi reset)"
    print $"(ansi light_blue_bold) ⢸⣿⣿⡿⠿⠿⠿⣿⣿⣧⡀⠀⢸⣿⣿⠀⠀⠀⠀⠀(ansi reset) │ "
    print $"(ansi light_blue_bold) ⢸⣿⣿⡇⠀⠀⠀⠈⣿⣿⡇⠀⢸⣿⣿⠀⠀⣤⣤⣤(ansi reset) │ (ansi blue_bold)Packages(ansi reset) : (pacman -Q | wc -l) \(pacman\)"
    print $"(ansi light_blue_bold) ⢸⣿⣿⡇⠀⠀⠀⠀⢻⣿⣿⠀⢸⣿⣿⠀⠀⣿⣿⣿(ansi reset) │ (ansi blue_bold)Local IP(ansi reset) : ($ip_info)"
    print $"(ansi light_blue_bold) ⠈⠉⣉⣥⣤⣤⣤⣀⠈⠉⠉⢀⣈⣉⣉⣀⣀⣉⣉⣉(ansi reset) │ (ansi blue_bold)Battery(ansi reset)  : (($battery_table | where name == "percentage" | get value).0) (($battery_table | where name == "state" | get value).0)"
    print $"(ansi light_blue_bold) ⢀⣾⣿⡿⠛⠛⠿⣿⣿⣆⠀⣿⣿⣿⠿⠿⠿⠿⠿⠿(ansi reset) │ "
    print $"(ansi light_blue_bold) ⢸⣿⣿⣄⡀⠀⠀⠙⠛⠛⠀⣿⣿⣿⠀⠀⠀⠀⠀⠀(ansi reset) │ "
    print $"(ansi light_blue_bold) ⠀⠻⢿⣿⣿⣿⣶⣶⣤⡀⠀⣿⣿⣿⣿⣿⣿⣿⣿⡇(ansi reset) │ "
    print $"(ansi light_blue_bold) ⣀⣀⡀⠀⠉⠉⠛⢿⣿⣿⡄⣿⣿⣿⠉⠉⠉⠉⠉⠁(ansi reset) │ "
    print $"(ansi light_blue_bold) ⢻⣿⣷⣄⡀⠀⢀⣰⣿⣿⠃⣿⣿⣿⣀⣀⣀⣀⣀⣀(ansi reset) │ "
    print $"(ansi light_blue_bold) ⠀⠙⠿⢿⣿⣿⣿⡿⠟⠁⠀⠿⠿⠿⠿⠿⠿⠿⠿⠿(ansi reset) │ "
}

$env.config.show_banner = false

show_banner




