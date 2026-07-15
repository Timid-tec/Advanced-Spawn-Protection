# Advanced Spawn Protection

Advanced Spawn Protection is a SourceMod plugin for CS:GO servers. It gives newly spawned players temporary damage immunity, clearly shows the remaining protection time, and can end protection when the player attacks.

Current version: **4.4.1**

[Download the latest Advanced Spawn Protection release](https://github.com/Timid-tec/Advanced-Spawn-Protection/releases/latest/download/Advanced-Spawn-Protection.zip)

## Features

- Configurable spawn-protection duration.
- Damage immunity while protection is active.
- Simple layered HUD showing `Spawn Protection` and the remaining seconds.
- Light-red warning text with a synchronized fade during the final three seconds.
- Flicker-resistant normal countdown rendering with overlapping hold times and no visibility gap.
- Configurable HUD colors, warning threshold, fades, hold times, and shadow.
- Countdown includes any remaining delay before the round officially starts.
- Optional chat notifications when protection starts and ends.
- Optional protection removal when the protected player fires.
- Optional handling for players controlling bots.
- Optional FFA or team-based player model colors, disabled by default.
- Separate optional rainbow player-model effect through `sm_rainbow`.

## Requirements

- A CS:GO dedicated server.
- MetaMod:Source and SourceMod installed.
- SourceMod 1.11 or newer. The included plugin is compiled with SourceMod 1.12.

This plugin is for CS:GO and is not a Counter-Strike 2 plugin.

## Installation

1. Download [Advanced-Spawn-Protection.zip](https://github.com/Timid-tec/Advanced-Spawn-Protection/releases/latest/download/Advanced-Spawn-Protection.zip).
2. Extract the ZIP directly into the server's `csgo` directory.
3. Confirm that the plugin exists at `csgo/addons/sourcemod/plugins/AdvancedSpawnProtect.smx`.
4. Start the server, or run `sm plugins load AdvancedSpawnProtect` from the server console.
5. Edit `csgo/cfg/sourcemod/AdvancedSpawnProtect.cfg` to configure the plugin.

## Updating

1. Back up `csgo/cfg/sourcemod/AdvancedSpawnProtect.cfg` if you customized it.
2. Replace `csgo/addons/sourcemod/plugins/AdvancedSpawnProtect.smx` with the new file from the ZIP.
3. Compare your existing configuration with the new `cfg/sourcemod/AdvancedSpawnProtect.cfg`. SourceMod does not automatically replace an existing config file.
4. Restart the server or run `sm plugins reload AdvancedSpawnProtect` from the server console.
5. Run `sm plugins list` and confirm that Advanced Spawn Protection reports version `4.4.1`.

## Configuration

| ConVar | Default | Description |
| --- | ---: | --- |
| `sm_spawnprotect_time` | `12` | Seconds of spawn protection after a player spawns. |
| `sm_spawnprotect_botcontrol` | `0` | Allow spawn protection while a player is controlling a bot. |
| `sm_spawnprotect_notifystart` | `1` | Show chat messages when protection starts or ends. |
| `sm_spawnprotect_ffamode` | `1` | Use FFA model colors instead of separate team colors. |
| `sm_spawnprotect_colormodels` | `0` | Color unprotected player models; disabled by default so HUD warnings do not coincide with red models. |
| `sm_spawnprotect_endonattack` | `1` | End protection when the protected player fires. |
| `sm_spawnprotect_rainbowhud` | `0` | Deprecated compatibility setting. The HUD uses configurable fixed colors. |
| `sm_spawnprotect_hud_shadow` | `1` | Draw a dark shadow behind the HUD. |
| `sm_spawnprotect_hud_holdtime` | `1.25` | Seconds each countdown update remains visible. Keep above `1.0` to avoid gaps. |
| `sm_spawnprotect_hud_warning_time` | `3` | Seconds remaining when the HUD changes to its warning color; `0` disables it. |
| `sm_spawnprotect_hud_warning_fadeout` | `0.25` | Fade-out time for warning countdown updates. |
| `sm_spawnprotect_hud_end_holdtime` | `2.5` | Seconds the protection-ended notice remains visible. |
| `sm_spawnprotect_hud_end_fadeout` | `0.75` | Fade-out time for the protection-ended notice. |
| `sm_spawnprotect_hud_color_red` | `235` | Red component of the normal HUD color. |
| `sm_spawnprotect_hud_color_green` | `248` | Green component of the normal HUD color. |
| `sm_spawnprotect_hud_color_blue` | `255` | Blue component of the normal HUD color. |
| `sm_spawnprotect_hud_warning_red` | `255` | Red component of the warning HUD color. |
| `sm_spawnprotect_hud_warning_green` | `120` | Green component of the warning HUD color. |
| `sm_spawnprotect_hud_warning_blue` | `110` | Blue component of the warning HUD color. |

Boolean options use `0` for disabled and `1` for enabled. RGB components accept values from `0` through `255`.

## Version 4.4.1

- Disabled unprotected player-model coloring by default.
- Kept the light-red three-second warning limited to the HUD layers.
- Player models now return to their normal color when protection expires with the default config.

## Version 4.4.0

- Renamed the in-game title from `SPAWN PROTECTION` to `Spawn Protection`.
- Kept the HUD focused on the title and remaining seconds.
- Added light-red warning text and a short fade during the final three seconds.
- Kept the normal HUD free of recurring fades and extended its hold time beyond the refresh interval to reduce in-game flicker.
- Added ConVars for HUD colors, warning time, warning fade, ending fade, hold times, and shadow visibility.
- Updated the shipped config and documentation with every available setting.

## Version 4.3.0

- Added a two-layer synchronized HUD using Eclipse's light-blue foreground and offset dark shadow.
- Removed the rainbow HUD behavior while retaining the legacy ConVar for configuration compatibility.
- Added pre-round delay compensation to the spawn-protection countdown.
- Rebuilt the plugin with SourceMod 1.12.
- Cleaned the downloadable package and corrected the installation and update documentation.

## Building from source

Compile `addons/sourcemod/scripting/AdvancedSpawnProtect.sp` with a SourceMod 1.11 or newer compiler. Place the generated binary at `addons/sourcemod/plugins/AdvancedSpawnProtect.smx`.

## License

Advanced Spawn Protection is distributed under the license in [LICENSE](./LICENSE).
