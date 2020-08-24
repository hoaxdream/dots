# Arch UEFI EFISTUB Install
**DISCLAIMER**
---
_I am not responsible for any damages, loss of data, system corruption, or any mishap you may somehow cause by following this guide._
_Use at your own risk or use [Arch Wiki](https://wiki.archlinux.org/index.php/installation_guide) as your guide._

#### Before booting from usb stick check your hardware settings
- Disable Secure Boot
- Disable Launch CSM or Legacy Support
- Set Boot Mode to UEFI

#### Burn ISO with CLI using dd
  - `dd bs=4M if=path/to/archlinux.iso of=/dev/sdx status=progress oflag=sync`

#### Verify the boot mode
  - If the command shows the directory without error, then the system is **UEFI**
  - `efivar -l`

#### Test internet connection
- `ping -c 3 archlinux.org`

#### Update system clock
  - `timedatectl set-ntp true`
  - `timedatectl status`
---
#### Prepare disk
**Mount point** | **Partition** | **Partition type** | **Suggested size**
| :---: | :---: | :---: | :---: |
/mnt/boot | /dev/sdX1 | EFI system partition | 512 MiB
/mnt | /dev/sdX2 | Linux Filesystem | Remainder of the device
- **Partition drive** - where _X_ is the number of the drive you want to use
  - `lsblk -f` - check which drive you want to use
  - `fdisk /dev/sdX`
  - `Create GPT disklabel`
  - `Use the chart above`
- **Format drive**
  - `mkfs.fat -n BOOT -F32 /dev/sdx1`
  - `mkfs.ext4 -L SYSTEM /dev/sdx2`
- **Mount disk**
  - `mount /dev/sdx2 /mnt`
  - `mkdir /mnt/boot`
  - `mount /dev/sdx1 /mnt/boot`
---
#### Pacstrap
- **Change dns** if mirrors failed for some reason in _/etc/resolv.conf_
  - `nameserver 1.1.1.1`
  - edit mirrors in _`/etc/pacman.d/mirrorlist`_
- **Install essential packages**
  - `pacstrap /mnt base base-devel linux linux-firmware`
---
#### System Configuration
- **Fstab**
  - `genfstab -U /mnt >> /mnt/etc/fstab`
- **Chroot** into the new system
  - `arch-chroot /mnt`
- **Set timezone**
  - `ln -sf /usr/share/zoneinfo/Asia/Manila /etc/localtime`
  - `hwclock --systohc --utc`
- **Localization**
  - `pacman -S neovim`
  - uncomment prefer language in _`/etc/locale.gen`_
  - `locale-gen`
  - `echo LANG=en_PH.UTF-8 > /etc/locale.conf`
- **Network configuration**
  - `echo art > /etc/hostname`
  - add matching entries to host in _`/etc/hosts`_
```javascript
127.0.0.1    localhost
::1          localhost
127.0.1.1    art.localdomain art
```
- **Install your preferred network management software** - this guide will use systemd
  - **Systemd-networkd**
    - find the name of your network adapter with _`ip link`_
    - `systemctl enable systemd-networkd.service`
     - configure adapter in _`/etc/systemd/network/20-wired.network`_
```javascript
[Match]
Name=enp0s31f6

[Network]
DHCP=yes
DNS=1.1.1.1
```
- **Root password**
  - `passwd`
- **Boot loader**
  - `pacman -S efibootmgr intel-ucode`
  - find UUID of root with _`lsblk -f`_
  - delete old boot entry if there's one with _`efibootmgr -b <bootnum> -B`_
  - create boot entry: _`Where /dev/sdX and Y`_ are the drive and partition number where the ESP is located.
  ```javascript
  efibootmgr -d /dev/sdX -p Y -c -L "Arch" -l /vmlinuz-linux -u 'root=UUID=XXXXXX-XXX rw quiet loglevel=3 nvidia-drm.modeset=1 rd.systemd.show_status=false rd.udev.log_priority=3 initrd=\intel-ucode.img initrd=\initramfs-linux.img' --verbose
  ```
- **Exit the chroot environment**
  - `exit`
  - `umount -R /mnt`
  - `reboot`
  - `login as root`
  - `pacman -Syu`
- **Enable multilib** - in _`/etc/pacman.conf`_ uncomment multilib
```javascript
[multilib]
include = /etc/pacman.d/mirrorlist
```
  - `pacman -Syu`
- **Add user**
  - `pacman -S zsh`
  - `useradd -m -G users,wheel,video,audio,storage,disk -s /bin/zsh hoaxdream`
  - `passwd hoaxdream`
- **Add sudoers**
  - `EDITOR=nvim visudo`
  - `uncomment wheel group`
```javascript
%wheel ALL=(ALL) ALL
```
  - `logout root`
  - `login with created username and password`
  - `sudo pacman -Syu`
---
#### Automatic installation of packages and dotfiles configuration
  - `sudo pacman -S git stow`
  - `git clone https://github.com/hoaxdream/bootstrap
  - `cd bootstrap`
  - `./install`
  - `sudo ./postinstall`
  - `reboot`
  - `./suckpatch`
---
#### Manual installation of packages and dotfiles
- **Xorg**
  - `xorg-server xorg-xwininfo xorg-xprop xorg-xdpyinfo xorg-util-macros xorg-xset xorg-xsetroot xorg-xinit xterm`
- **Nvidia driver**
  - `nvidia nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader`
- **Core**
  - `pacman-contrib mlocate man-db`
  - `git wget npm highlight`
  - `gnome-keyring python-pynvim`
  - `atool zip unzip unrar dosfstools ntfs-3g libimobiledevice`
  - `xdg-user-dirs xclip xdo xdotool mediainfo fzf`
  - `transmission-cli bc tree cronie`
- **Audio**
  - `pulseaudio-alsa pulsemixer pamixer`
- **Fonts**
  - `ttf-joypixels ttf-dejavu ttf-liberation ttf-nerd-fonts-symbols noto-fonts noto-fonts-emoji`
- **Miscellaneous**
  - `youtube-dl youtube-viewer ffmpeg ffmpegthumbnailer`
  - `maim sxiv xwallpaper imagemagick ueberzug`
  - `vifm newsboat picom calcurse unclutter`
  - `mpd mpc mpv ncmpcpp easytag`
  - `zathura zathura-pdf-mupdf poppler`
  - `dunst libnotify gucharmap lynx`
  - `neomutt isync msmtp pass abook`
  - `firefox`
  - `steam`
  - `gimp`
  - `zsh zsh-autosuggestions`
  - `sudo systemctl reboot`
---
### Window manager
- **Dwm**
  - `mkdir -p ~/.config/work/repositories`
  - `cd ~/.config/work/repositories`
  - `git clone https://git.suckless.org/dwm`
  - `git clone https://git.suckless.org/st`
  - `git clone https://git.suckless.org/dmenu`
  - `git clone https://github.com/torrinfail/dwmblocks dblocks`
  - `make && sudo make install`-`in each directory and install`
- **Xmonad**
  - `sudo pacman -S xmonad xmonad-contrib xmobar`
- **Bspwm**
  - `sudo pacman -S bspwm sxhkd`
- **Preparing for first boot**
  - `nvim ~/.xinitrc`
  ```javascript
  xset r rate 300 50 &
  xset s off -dpms &
  picom -b &

  while true; do
    dwm >/dev/null 2>&1
  done
  ```
  - `startx`
