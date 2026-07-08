sudo pacman -Syyu

# Instalar hyprland

`sudo pacman -S kitty hyprland ly xdg-user-dirs`

### Instalar fuentes

```
sudo pacman -S noto-fonts noto-fonts-emoji fontconfig ttf-jetbrains-mono-nerd
fc-cache -rv
```

### Explorador de archivos (yazi)

`sudo pacman -S yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick`

###### Usar como explorador por defecto
Crear un symlink entre la carpeta de yazi y ~/.local/share/applications/yazi-gui.desktop
```
update-desktop-database ~/.local/share/applications
xdg-mime default yazi-gui.desktop inode/directory
```

### Barra superior (waybar)

```
sudo pacman -S waybar
mkdir -p ~/.config/waybar
touch ~/.config/waybar/config ~/.config/waybar/style.css
```

### Lanzador de apps (rofi)

```
sudo pacman -S rofi
```

### Login (ly)

```
sudo systemctl enable ly@tty2.service
sudo reboot
```

### Power Menu (wlogout)

`yay -S wlogout`

### Lock screen (swaylock)

`yay -S swaylock-effects-git`

### Notificaciones (swaync)

`yay -S swaync`

Ejecutar con: `swaync-client -t`

### Portapapeles (clipvault)

`yay -S wl-clipboard clipvault`

Ejecutar o añadir al inicio de hyprland: `wl-paste --watch clipvault store`

DOC: `https://github.com/Rolv-Apneseth/clipvault#picker-examples`

### Capturas de pantalla

`yay -S grim slurp flameshot`

### Color picker (hyprpicker)

`sudo pacman -S hyprpicker`

### ls mejorado

`yay -S exa`

Ejemplo de ejecucion: `exa -laa --icons --sort=type`

### Wallpaper (awww)
`yay -S awww`

`awww-daemon`

### Audio (pulseaudio)
`sudo pacman -S pulseaudio pulseaudio-alsa alsa-utils`

##### Interfaz grafica
`sudo pacman -S pavucontrol`

### Selector de emojis (rofi)
`sudo pacman -S rofi-emoji wtype`

Ejecutar con: `rofi -modi emoji -show emoji -emoji-format '{emoji}'`

# Apps utiles

`https://github.com/hyprland-community/awesome-hyprland`
