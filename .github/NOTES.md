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
- **Run 5 minutes after boot/reboot**
  - `@reboot sleep 300 && /usr/bin/reflector -c India -c HK -a 12 -p https -p http --sort rate >> /etc/pacman.d/mirrorlist`
- **Run every 2 days**
  - `0 23 */2 * * /usr/bin/reflector -c India -c HK -a 12 -p https -p http --sort rate >> /etc/pacman.d/mirrorlist`
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
#### Startpage:
  - **Set firefox homepage**
    - `/home/hoaxdream/.ansible/work/repositories/startpage/index.html`
#### Checkra1n
  - **Checkra1n**
    - `sudo ./checkra1n -c`
