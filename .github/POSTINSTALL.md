**Post installation, daemons and silent boot**
---
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
#### Cronie
  - **User**
    - `crontab -e`
    - `*/15 * * * * /usr/bin/newsboat -x reload && pkill -RTMIN+6 dwmblocks`
    - `*/5 * * * * export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus; export DISPLAY=:0; . $HOME/.zprofile; /usr/bin/mbsync -a && pkill -RTMIN+12 dwmblocks`
    - `5 */2 * * * export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus; export DISPLAY=:0; . $HOME/.zprofile; checkup`
  - **Root**
    - `sudo -E crontab -e`
    - `5 */2 * * * /usr/bin/pacman -Syuw --noconfirm && pkill -RTMIN+8 dwmblocks`
    - `*/30 * * * * /usr/bin/updatedb`
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
