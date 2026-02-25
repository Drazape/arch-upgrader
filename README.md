My parting gift to Arch Linux before migrating to NixOS. Automatically handle the updates

# Features
- Tight integration with *systemd*
- Pacman Notifications
  * Updates  
    <img width="413" height="108" alt="Screenshot: Update" src="https://github.com/user-attachments/assets/9cdb705f-8abf-400a-a85c-5e43f941e201" />
    - **Title**: Includes number of packages
    - **Description**: List of packages being upgraded
    - **Action**: Shows the change-log for the packages in the `kgx` terminal emulator
  * Failure
    - **Locked Database**: unlock database and retry update
    <img width="413" height="147" alt="Screenshot: Failure: Locked Database" src="https://github.com/user-attachments/assets/ae6e8733-5266-400a-bec1-1bfa4668ada7" />

    - **Other Issue**: Show logs on the `kgx` terminal emulator  
    <img width="413" height="147" alt="Screenshot: Failure: Other issue" src="https://github.com/user-attachments/assets/a2f27e7f-ce70-4beb-95e0-5749e8912a15" />

    
## Performs

### Pacman
- Updates
- Enables filesdb refresher timer
- Mirror list refresh (Uses [*rate-mirrors*](https://github.com/westandskif/rate-mirrors "A fast mirror ranking tool that finds the best mirrors for your Linux distribution. It uses submarine cable and internet exchange data to intelligently hop between countries and discover fast mirrors in ~30 seconds"))
  * Official
  * CachyOS
  * Chaotic AUR
  * EndeavourOS
### Flatpak Updates

# Help
## Installation
[![arch-upgrader](https://img.shields.io/aur/version/arch-upgrader?color=1793d1&label=arch-upgrader&logo=arch-linux&style=for-the-badge)](https://aur.archlinux.org/packages/arch-upgrader/ "Arch User Repository")  
[![arch-upgrader-git](https://img.shields.io/aur/version/arch-upgrader-git?color=1793d1&label=arch-upgrader-git&logo=arch-linux&style=for-the-badge)](https://aur.archlinux.org/packages/arch-upgrader-git/ "Arch User Repository")

## Configuration
Turn off upgrade notifications
- **Current user**: `systemctl --user mask pacman-update_notifier_update.service`
- **All users**: `systemctl mask pacman-update_notifier@update.service`
