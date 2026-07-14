# Advanced Spawn Protection

Advanced Spawn Protection is a SourceMod plugin for CS:GO servers. It gives newly spawned players temporary damage immunity, clearly shows the remaining protection time, and can end protection when the player attacks.

Current version: **4.3.0**

[Download Advanced Spawn Protection v4.3.0](https://github.com/Timid-tec/Advanced-Spawn-Protection/releases/latest/download/Advanced-Spawn-Protection.zip)

## Features

- Configurable spawn-protection duration.
- Damage immunity while protection is active.
- Layered Eclipse-style HUD with a light-blue foreground and dark shadow.
- Countdown includes any remaining delay before the round officially starts.
- Optional chat notifications when protection starts and ends.
- Optional protection removal when the protected player fires.
- Optional handling for players controlling bots.
- FFA or team-based player model colors.
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
5. Run `sm plugins list` and confirm that Advanced Spawn Protection reports version `4.3.0`.

## Configuration

| ConVar | Default | Description |
| --- | ---: | --- |
| `sm_spawnprotect_time` | `12` | Seconds of spawn protection after a player spawns. |
| `sm_spawnprotect_botcontrol` | `0` | Allow spawn protection while a player is controlling a bot. |
| `sm_spawnprotect_notifystart` | `1` | Show chat messages when protection starts or ends. |
| `sm_spawnprotect_ffamode` | `1` | Use FFA model colors instead of separate team colors. |
| `sm_spawnprotect_colormodels` | `1` | Color player models based on protection state. |
| `sm_spawnprotect_endonattack` | `1` | End protection when the protected player fires. |
| `sm_spawnprotect_rainbowhud` | `0` | Deprecated compatibility setting. The HUD now uses the fixed Eclipse-style color. |

Values of `0` disable an option and values of `1` enable it.

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
