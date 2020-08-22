**Post installation, daemons and silent boot**
---
#### Xdg
  - `sudo -i`
  - `nvim /etc/xdg/user-dirs.conf`
```javascript
enabled=False
```
#### Npm
  - `npm i -g bash-language-server`
---
#### Silent boot
- **Watchdog**
  - `sudo -E nvim /etc/modprobe.d/watchdog.conf`
```javascript
blacklist iTCO_wdt
blacklist iTCO_vendor_support
```
- **Nvidia**
  - `sudo mkdir -p /etc/pacman.d/hooks`
  - `sudo -E nvim /etc/pacman.d/hooks/nvidia.hook`
```javascript
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
```
- **Initramfs**
  - `sudo -E nvim /etc/mkinitcpio.conf`
```javascript
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
HOOKS=(base systemd autodetect modconf block filesystems btrfs keyboard fsck)
```
- `sudo mkinitcpio -p linux`
- **Sysctl**
  - `sudo -E nvim /etc/sysctl.d/20-quiet-printk.conf`
```javascript
kernel.printk = 3 3 3 3
```
- **Fcsk**
  - `sudo -E systemctl edit --full systemd-fsck-root.service`
  - `sudo -E systemctl edit --full systemd-fsck@.service`
```javascript
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/lib/systemd/systemd-fsck
StandardOutput=null
StandardError=journal+console
TimeoutSec=0
```
---
#### Configure Fstab
  - find **UUID** with `lsblk -f`
  - `sudo -E nvim /etc/fstab/`
  - `sudo -i`
  - `mkdir /media/`
  - `cd /media`
  - `mkdir core`
  - `chown -R user:user /media/core/`
  - `exit root`
  - `sudo mount -a`
  - `sudo systemctl reboot`
```javascript
UUID=xxxx-xxxx /media/core/ ext4 rw,user,exec 0 0
```
---
#### Transmission
  - **Enable deamon**
    - `sudo systemctl enable transmission`
  - `sudo -E nvim /usr/lib/systemd/system/transmission.service`
```javascript
[Service]
User=your_username
```
---
#### Cronie
  - **Enable daemon**
    - `sudo systemctl enable cronie`
  - **User**
    - `crontab -e`
    - `*/15 * * * * /usr/bin/newsboat -x reload && pkill -RTMIN+6 dwmblocks`
    - `*/5 * * * * export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus; export DISPLAY=:0; . $HOME/.zprofile; /usr/bin/mbsync -a && pkill -RTMIN+12 dwmblocks`
  - **Root**
    - `sudo -E crontab -e`
    - `5 */2 * * * /usr/bin/pacman -Syuw --noconfirm && pkill -RTMIN+8 dwmblocks`
    - `*/30 * * * * /usr/bin/updatedb`
---
#### Ssh
  - **Enable deamon**
    - `sudo systemctl enable sshd`
  - `sudo nvim /etc/ssh/sshd_config`
  - `Port 39901`
  - `ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`
  - `ssh-add ~/.ssh/id_rsa`
  - `ssh-add -l`
  - `xclip -sel clip < ~/.ssh/id_rsa.pub`
  - `add key to github account`
---
#### Gpg
  - `chown -R $(whoami) ~/.local/share/gnupg/`
  - `find ~/.local/share/gnupg -type f -exec chmod 600 {} \;`
  - `find ~/.local/share/gnupg -type d -exec chmod 700 {} \;`
  - `gpg --full-gen-key`
  - `pass init youremail@here`
  - `gpg -r youremail@here -e file`
  - `gpg -d file.gpg`
---
#### Gnome-keyring
  - Start gnome-keyring from _`/etc/pam.d/login`_
```javascript
#%PAM-1.0

auth       required     pam_securetty.so
auth       requisite    pam_nologin.so
auth       include      system-local-login
auth       optional     pam_gnome_keyring.so
account    include      system-local-login
session    include      system-local-login
session    optional     pam_gnome_keyring.so auto_start
```
---
#### Mpd
  - `systemctl --user enable --now mpd`
  - `sudo systemctl reboot`
