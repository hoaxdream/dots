#### Cronjob
```javascript
* * * * * command to be executed
- - - - -
| | | | |
| | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
| | | ------- Month (1 - 12)
| | --------- Day of month (1 - 31)
| ----------- Hour (0 - 23)
------------- Minute (0 - 59)
```
- **User**
  - `crontab -e`
  - `*/15 * * * * /usr/bin/newsboat -x reload && pkill -RTMIN+6 dwmblocks`
  - `*/5 * * * * export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus; export DISPLAY=:0; . $HOME/.zprofile; /usr/bin/mbsync -a && pkill -RTMIN+12 dwmblocks`
  - `5 */2 * * * export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus; export DISPLAY=:0; . $HOME/.zprofile; checkup`
- **Root**
  - `sudo -E crontab -e`
  - `5 */2 * * * /usr/bin/pacman -Syuw --noconfirm && pkill -RTMIN+8 dwmblocks`
  - `*/30 * * * * /usr/bin/updatedb`
- **Run 5 minutes after boot/reboot**
  - `@reboot sleep 300 && /usr/bin/reflector -c India -c HK -a 12 -p https -p http --sort rate >> /etc/pacman.d/mirrorlist`
- **Run every 2 days**
  - `0 23 */2 * * /usr/bin/reflector -c India -c HK -a 12 -p https -p http --sort rate >> /etc/pacman.d/mirrorlist`
---
#### Silent boot
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
#### Ssh
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
#### Git
  - **Change remote url**
    - `git remote set-url origin https://github.com/USERNAME/REPOSITORY.git`
---
#### Pass
  - **Store passwd**
    - `pass insert website_you_would_like_to_save_password`
---
#### Firefox
- **Fix screen tearing set to** `true`
  - `layers.acceleration.force-enabled`
- **Remove what's new: set to** `"false"`
  - `browser.messaging-system.whatsNewPanel.enabled`
- **Fix mouse right click:  set to** `"true"`
  - `ui.context_menus.after_mouseup`
- **Remove video fullscreen warning: set to** `"0"`
  - `full-screen-api.warning.timeout`
- **Remove pocket: set to** `"false"`
  - `extensions.pocket.enabled`
- **Enable user interface css setings: set to** `"true"`
  -`toolkit.legacyUserProfileCustomizations.stylesheets`
---
#### Keybind XFree86 keysym path
- `/usr/include/X11/XF86keysym.h
---
#### Keyserver error
  - `nvim`_`/etc/pacman.d/gnupg/gpg.conf`_
  - `keyserver hkp://ipv4.pool.sks-keyservers.net:11371`
  - `nvim`_`~/.local/share/gnupg/gpg.conf`_
  - `keyserver hkp://ipv4.pool.sks-keyservers.net:11371`
  - `sudo pacman-key --populate archlinux`
  - `sudo pacman-key --refresh-keys`
- **libxft-bgra** - `in case above doesn't work`
  - `gpg --keyserver "hkp://ipv4.pool.sks-keyservers.net:11371" --recv-keys KEYS_HERE`
---
#### Stow
- Stow
  - `stow * --target ~`
- Unstow
  - `stow -Dt ~ *`
---
#### Mounting USB
- NTFS
  - `fdisk /dev/sdx`
  - `n, t, 7`
  - `w`
  - `mkfs.ntfs -f /dev/sdx`
- Fix NTFS drive unmountable
  - `sudo ntfsfix /dev/sddX`
- Mbr ext4
  - `fdisk /dev/sdx`
  - `mkfs.ext4 -F -O ^64bit -L 'core' '/dev/sdx'
---
#### Startpage:
  - **Set firefox homepage**
    - `/home/hoaxdream/.ansible/work/repositories/startpage/index.html`
