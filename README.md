Automatically handle upgrades for **Arch Linux** and its derivatives

# Features
- Tight integration with *systemd*
- Pacman Notifications
  * Upgrades  
    <img width="426" height="123" alt="Screenshot: Upgrade" src="https://github.com/user-attachments/assets/8a48099d-8367-4742-9308-71fb242a2eed" />
    - **Title**: Includes number of packages
    - **Description**: List of packages being upgraded
    - **Action**: Shows the change-log for the packages in the `kgx` terminal emulator
  * Failure
    - **Locked Database**: unlock database and retry upgrade
    <img width="427" height="164" alt="Screenshot: Failure: Locked Database" src="https://github.com/user-attachments/assets/3114c05e-94f1-4ad9-945a-255ef9022bf5" />

    - **Other Issue**: Show logs on the `kgx` terminal emulator  
    <img width="427" height="164" alt="Screenshot: Failure: Other issue" src="https://github.com/user-attachments/assets/c48ebb7e-4866-4019-88d0-73c5f39c7bec" />

    
## Performs

### Pacman
- Upgrades
- Mirror list refresh (Uses [*rate-mirrors*](https://github.com/westandskif/rate-mirrors "A fast mirror ranking tool that finds the best mirrors for your Linux distribution. It uses submarine cable and internet exchange data to intelligently hop between countries and discover fast mirrors in ~30 seconds"))
  * Official
  * CachyOS
  * Chaotic AUR
  * EndeavourOS
### Flatpak Upgrades

# Installation
[![arch-upgrader](https://img.shields.io/aur/version/arch-upgrader?color=1793d1&label=arch-upgrader&logo=arch-linux&style=for-the-badge)](https://aur.archlinux.org/packages/arch-upgrader/ "Arch User Repository")  
[![arch-upgrader-git](https://img.shields.io/aur/version/arch-upgrader-git?color=1793d1&label=arch-upgrader-git&logo=arch-linux&style=for-the-badge)](https://aur.archlinux.org/packages/arch-upgrader-git/ "Arch User Repository")
