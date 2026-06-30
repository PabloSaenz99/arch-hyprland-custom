## Crear tabla de particiones
cfdisk /dev/sda
###### New -> 512M -> Type -> EFI System
###### New -> Enter a todo
###### Write -> yes

## Formatear particiones
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
## Montar para instalacion
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
###### Check que esta bien con: lsblk
## Instalar kernel de linux
pacstrap -K /mnt base linux linux-firmware networkmanager sudo nano git

## Configurar el SO
### Generar fstab
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
### Zona horaria
```
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc
```
### Idioma
Descomentar la linea
`nano /etc/locale.gen`
```
locale-gen
echo "LANG=es_ES.UTF-8" > /etc/locale.conf
```
### Crear hostname
`echo "arch" > /etc/hostname`

### Crear usuario propio
```
useradd -m -G wheel -s /bin/bash pablo
passwd pablo
```
#### Dar permisos de sudo
Descomentar la linea con: `%wheel ALL=(ALL:ALL) ALL`

`EDITOR=nano visudo`

## Instalar gestor de arranque
`pacman -S grub efibootmgr`

`grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB`

`grub-mkconfig -o /boot/grub/grub.cfg`

## Salir y reinicio limpio
`exit`

`umount -R /mnt`

`reboot`

# Instalar escritorio

## Habilitar red
```
sudo ip link set enp0s3 up
sudo systemctl restart NetworkManager
```

## Habilitar ssh
```
sudo pacman -S openssh
sudo systemctl start sshd
```
#### Recargar ssh en host
`ssh-keygen -R `<ip>`

## Sincronizar pacman
`sudo pacman -Syyu`

## Instalar yay
#### Compiladores de arch
`sudo pacman -S --needed base-devel git`
#### Clonar repositorio de yay
```
cd ~
git clone https://aur.archlinux.org/yay-bin.git
```
#### Compilar e Instalar
```
cd yay-bin
makepkg -si
```
#### Borrar carpeta de yay-bin
`rm -rf ~/yay-bin`

## Instalar escritorio, terminal, gestor de archivos
`sudo pacman -S plasma-meta sddm xdg-user-dirs`
o tambien:
`sudo pacman -S i3-wm i3status i3lock dmenu xterm`

y en ambas:
`sudo yay -S sigma-file-manager`
`yay -S yakuake`


#### Configurar xdg-user-dirs
```
# 1. Asegúrate de que existe la carpeta de configuración en tu usuario
mkdir -p ~/.config

# 2. Sobrescribe la configuración por defecto apuntando lo sobrante a $HOME
cat << 'EOF' > ~/.config/user-dirs.dirs
XDG_DESKTOP_DIR="$HOME/Escritorio"
XDG_DOWNLOAD_DIR="$HOME/Descargas"
XDG_TEMPLATES_DIR="$HOME"
XDG_PUBLICSHARE_DIR="$HOME"
XDG_DOCUMENTS_DIR="$HOME/Documentos"
XDG_MUSIC_DIR="$HOME"
XDG_PICTURES_DIR="$HOME"
XDG_VIDEOS_DIR="$HOME"
EOF

# 3. Fuerza la creación de las carpetas configuradas
xdg-user-dirs-update
```

#### Activar entorno grafico y reiniciar
```
sudo systemctl enable sddm
sudo reboot
```
# Instalar apps

### Iniciar red
```
sudo ip link set dev enp0s3 up
sudo systemctl enable --now NetworkManager
```

## Zsh
```
sudo pacman -S zsh ttf-nerd-fonts-symbols-common powerline-fonts
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```












pacman -Sy archlinux-keyring

sudo pacman -S openssh
sudo pacman -S virtualbox-guest-utils virtualbox-guest-modules-arch linux-headers
sudo systemctl enable --now vboxservice.service   

sudo pacman -S plasma-meta sddm
sudo systemctl enable sddm