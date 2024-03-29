<p align="center">
  <a href="https://github.com/DenverCoder1/readme-typing-svg"><img src="https://readme-typing-svg.herokuapp.com?size=21&color=F7E7E5&background=F8000000&lines=Advanced+Spawn+Protect&center=true&width=500&height=50"></a>
   </p>
A source mod plugin simply made to make spawn protection more user-friendly, With the idea in mind for it to be more reliable for the servers to run with the intention of fewer memory leaks.

![](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMjljMzM4MDk1Zjk2OTc0NzhkYzU0MmUxNzJhMTNkNjM0NTk4NjgwNiZjdD1n/XKzpmmB5xOsjx0mQWH/giphy.gif)

## Custom Features
- Colors players who are spawn protected
- Join grace time for unprotected players
- Shows hud text when players are protected
- Notifys the player that they have spawn protection
- Capability to remove spawn protect on weapon fired
- Capability to remove spawn protect on players who control bots
- Rainbow hud message for spawn protect time

## Game Supported
- CS:GO

## ConVars
- sm_spawnprotect_time - Sets how much time is left for spawn protection default 14
- sm_spawnprotect_rainbowhud - Seddts whether rainbow menu is enabled. (0 off, 1 on) default 1
- sm_spawnprotect_botcontrol - Should bots receive spawn protection if another player takes control of them. (0 off, 1 on) default 1
- sm_spawnprotect_notifystart -Should we notify users that they have spawn protection. (0 off, 1 on) default 1
- sm_spawnprotect_ffamode - Should we set colors for ffa or teams. (0 off, 1 on) default 1
- sm_spawnprotect_colormodels - Should we set colored player models. (0 off, 1 on) default 1
- sm_spawnprotect_endonattack - Should we disable spawn protect on attack. (0 off, 1 on) default 1

## Things to Add
- Allow players to set custom spawn protect model highlighting color.

## How to Install
- Donwload AdvancedSpawnProtect.smx and put into /csgo/addons/sourcemod/plugins
- Configure settings by editing /cfg/sourcemod/AdvancedSpawnProtection.cfg

## Updates

| Version | Change-Log          |
| ------- | ------------------ |
| 4.2.4   | Added some changes to include, and other issues fixed |
| 4.2.3   | Fixed Transalpha Render to models with cvar change |
| 4.2.2   | Added Transalpha Render to models |
| 4.2.1   | Fixed ShowSyncHudText not Working |
| 4.2.0   | Fixed Protected-Color to Green |
