# Advanced-Spawn-Protection

A source mod plugin simply made to make spawn protection more user-friendly, With the idea in mind for it to be more reliable for the servers to run with the intention of fewer memory leaks.

# Custom Features
- Colors players who are spawn protected
- Join grace time for unprotected players
- Shows hud text when players are protected
- Notifys the player that they have spawn protection
- Capability to remove spawn protect on weapon fired
- Capability to remove spawn protect on players who control bots
- Rainbow hud message for spawn protect time

# Game Supported
- CS:GO

# 

| Version | Change-Log          |
| ------- | ------------------ |
| 4.2.0   | Fixed Protected-Color to Green |

# ConVars
- sm_spawnprotect_time - Sets how much time is left for spawn protection default 14
- sm_spawnprotect_rainbowhud - Sets whether rainbow menu is enabled. (0 off, 1 on) default 1
- sm_spawnprotect_botcontrol - Should bots receive spawn protection if another player takes control of them. (0 off, 1 on) default 1
- sm_spawnprotect_notifystart -Should we notify users that they have spawn protection. (0 off, 1 on) default 1
- sm_spawnprotect_ffamode - Should we set colors for ffa or teams. (0 off, 1 on) default 1
- sm_spawnprotect_colormodels - Should we set colored player models. (0 off, 1 on) default 1
- sm_spawnprotect_endonattack - Should we disable spawn protect on attack. (0 off, 1 on) default 1

# Commands
- /rainbow default admin flag ADMFLAG_RCON - Allows the player models on spawn to go into a loop of R G B

# Things to Add
- Allow players to set custom spawn protect model highlighting color.

# How to Install
- Donwload AdvancedSpawnProtect.smx and put into /csgo/addons/sourcemod/plugins
- Configure settings by editing /cfg/sourcemod/AdvancedSpawnProtection.cfg


| Version | Supported          |
| ------- | ------------------ |
| 5.1.x   | :white_check_mark: |
| 5.0.x   | :x:                |
| 4.0.x   | :white_check_mark: |
| < 4.0   | :x:                |
