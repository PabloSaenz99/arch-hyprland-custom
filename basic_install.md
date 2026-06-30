# Instalacion basica

`passwd`

```
sudo pacman -Sy
sudo pacman -S openssh
ip a
```

## Crear tabla de particiones

cfdisk /dev/sda

###### New -> 512M -> Type -> EFI System

###### New -> Enter a todo

###### Write -> yes

## Formatear particiones

```
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
```

## Montar para instalacion

```
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
```

###### Check que esta bien con: lsblk

## Instalar kernel de linux

`pacstrap -K /mnt base linux linux-firmware networkmanager sudo nano git`

## Configurar el SO

### Generar fstab

`genfstab -U /mnt >> /mnt/etc/fstab`

### Entrar

`arch-chroot /mnt`

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
useradd -m -G wheel -s /bin/bash user
passwd user
```

#### Dar permisos de sudo

`EDITOR=nano visudo`

Descomentar la linea con: `%wheel ALL=(ALL:ALL) ALL`

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
