local cursor_theme = "Bibata-Modern-Classic"
local cursor_size = "20"

hl.env("HYPRCURSOR_THEME", cursor_theme)
hl.env("HYPRCURSOR_SIZE", cursor_size)
hl.env("XCURSOR_THEME", cursor_theme)
hl.env("XCURSOR_SIZE", cursor_size)

hl.on("hyprland.start", function()
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme '" .. cursor_theme .. "'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size " .. cursor_size)
    hl.exec_cmd("hyprctl setcursor " .. cursor_theme .. " " .. cursor_size)
end)
