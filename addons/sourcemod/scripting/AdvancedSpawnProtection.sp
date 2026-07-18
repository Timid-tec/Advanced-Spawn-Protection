// Advanced Spawn Protection
// Source: https://github.com/Timid-tec/Advanced-Spawn-Protection

#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <sdktools_gamerules>
#include <cstrike>
#include <sdkhooks>

#define PLUGIN_VERSION "4.4.1"
#define CHAT_PREFIX "\x08[\x0CSpawn Protect\x08]"
#define DAMAGE_NO 0
#define DAMAGE_YES 2

public Plugin myinfo =
{
	name = "Advanced Spawn Protection",
	author = "Timid",
	description = "Lightweight spawn protection for CS:GO",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/MrTimid/"
};

static const int g_ProtectedColor[4] = {255, 255, 255, 120};
static const int g_UnprotectedColorFFA[4] = {255, 0, 0, 255};
static const int g_UnprotectedColorT[4] = {255, 0, 0, 255};
static const int g_UnprotectedColorCT[4] = {0, 0, 255, 255};
static const int g_DefaultColor[4] = {255, 255, 255, 255};
static const int g_HudShadowColor[4] = {0, 0, 0, 245};

int g_HudColor[4] = {235, 248, 255, 255};
int g_HudWarningColor[4] = {255, 120, 110, 255};

Handle g_SpawnProtectionTimer[MAXPLAYERS + 1];
Handle g_RainbowTimer[MAXPLAYERS + 1];
Handle g_HudText = null;
Handle g_HudTextShadow = null;

bool g_RainbowModelEnabled[MAXPLAYERS + 1];
int g_SpawnProtectionTimeLeft[MAXPLAYERS + 1];

ConVar g_CvarSpawnProtectionTime = null;
ConVar g_CvarBotControl = null;
ConVar g_CvarNotifyStart = null;
ConVar g_CvarFfaMode = null;
ConVar g_CvarColorModels = null;
ConVar g_CvarEndOnAttack = null;
ConVar g_CvarHudShadow = null;
ConVar g_CvarHudHoldTime = null;
ConVar g_CvarHudWarningTime = null;
ConVar g_CvarHudWarningFadeOut = null;
ConVar g_CvarHudEndHoldTime = null;
ConVar g_CvarHudEndFadeOut = null;
ConVar g_CvarHudColorRed = null;
ConVar g_CvarHudColorGreen = null;
ConVar g_CvarHudColorBlue = null;
ConVar g_CvarHudWarningRed = null;
ConVar g_CvarHudWarningGreen = null;
ConVar g_CvarHudWarningBlue = null;
ConVar g_CvarDisableImmunityAlpha = null;

int g_SpawnProtectionDuration = 0;
int g_IsControllingBotOffset = -1;

bool g_BotControlEnabled = false;
bool g_NotifyEnabled = true;
bool g_FfaColorsEnabled = true;
bool g_ColorModelsEnabled = false;
bool g_EndOnAttackEnabled = true;
bool g_HudShadowEnabled = true;

int g_HudWarningTime = 3;
float g_HudHoldTime = 1.25;
float g_HudWarningFadeOut = 0.25;
float g_HudEndHoldTime = 2.5;
float g_HudEndFadeOut = 0.75;

public void OnPluginStart()
{
	g_CvarSpawnProtectionTime = CreateConVar("sm_spawnprotect_time", "12", "Seconds of spawn protection after a player spawns.", FCVAR_NONE, true, 0.0, true, 60.0);
	CreateConVar("sm_spawnprotect_rainbowhud", "0", "Deprecated compatibility setting. The HUD now uses configurable fixed colors.", FCVAR_NONE, true, 0.0, true, 1.0);
	g_CvarBotControl = CreateConVar("sm_spawnprotect_botcontrol", "0", "Whether a player controlling a bot should still receive spawn protection.", FCVAR_NONE, true, 0.0, true, 1.0);
	g_CvarNotifyStart = CreateConVar("sm_spawnprotect_notifystart", "1", "Print chat messages when spawn protection starts or ends.", FCVAR_NONE, true, 0.0, true, 1.0);
	g_CvarFfaMode = CreateConVar("sm_spawnprotect_ffamode", "1", "Use FFA colors instead of separate team colors for unprotected players.", FCVAR_NONE, true, 0.0, true, 1.0);
	g_CvarColorModels = CreateConVar("sm_spawnprotect_colormodels", "0", "Color player models while they are unprotected.", FCVAR_NONE, true, 0.0, true, 1.0);
	g_CvarEndOnAttack = CreateConVar("sm_spawnprotect_endonattack", "1", "End spawn protection as soon as the protected player fires.", FCVAR_NONE, true, 0.0, true, 1.0);
	g_CvarHudShadow = CreateConVar("sm_spawnprotect_hud_shadow", "1", "Draw a dark shadow behind the spawn protection HUD.", FCVAR_NONE, true, 0.0, true, 1.0);
	g_CvarHudHoldTime = CreateConVar("sm_spawnprotect_hud_holdtime", "1.25", "Seconds each countdown HUD update remains visible. Keep this above 1.0 to prevent gaps.", FCVAR_NONE, true, 0.1, true, 10.0);
	g_CvarHudWarningTime = CreateConVar("sm_spawnprotect_hud_warning_time", "3", "Seconds remaining when the HUD changes to the warning color. Set to 0 to disable.", FCVAR_NONE, true, 0.0, true, 60.0);
	g_CvarHudWarningFadeOut = CreateConVar("sm_spawnprotect_hud_warning_fadeout", "0.25", "Fade-out time for warning countdown updates.", FCVAR_NONE, true, 0.0, true, 5.0);
	g_CvarHudEndHoldTime = CreateConVar("sm_spawnprotect_hud_end_holdtime", "2.5", "Seconds the protection-ended HUD remains visible.", FCVAR_NONE, true, 0.1, true, 10.0);
	g_CvarHudEndFadeOut = CreateConVar("sm_spawnprotect_hud_end_fadeout", "0.75", "Fade-out time for the protection-ended HUD.", FCVAR_NONE, true, 0.0, true, 5.0);
	g_CvarHudColorRed = CreateConVar("sm_spawnprotect_hud_color_red", "235", "Red component of the normal HUD color.", FCVAR_NONE, true, 0.0, true, 255.0);
	g_CvarHudColorGreen = CreateConVar("sm_spawnprotect_hud_color_green", "248", "Green component of the normal HUD color.", FCVAR_NONE, true, 0.0, true, 255.0);
	g_CvarHudColorBlue = CreateConVar("sm_spawnprotect_hud_color_blue", "255", "Blue component of the normal HUD color.", FCVAR_NONE, true, 0.0, true, 255.0);
	g_CvarHudWarningRed = CreateConVar("sm_spawnprotect_hud_warning_red", "255", "Red component of the warning HUD color.", FCVAR_NONE, true, 0.0, true, 255.0);
	g_CvarHudWarningGreen = CreateConVar("sm_spawnprotect_hud_warning_green", "120", "Green component of the warning HUD color.", FCVAR_NONE, true, 0.0, true, 255.0);
	g_CvarHudWarningBlue = CreateConVar("sm_spawnprotect_hud_warning_blue", "110", "Blue component of the warning HUD color.", FCVAR_NONE, true, 0.0, true, 255.0);

	g_CvarSpawnProtectionTime.AddChangeHook(OnConVarChanged);
	g_CvarBotControl.AddChangeHook(OnConVarChanged);
	g_CvarNotifyStart.AddChangeHook(OnConVarChanged);
	g_CvarFfaMode.AddChangeHook(OnConVarChanged);
	g_CvarColorModels.AddChangeHook(OnConVarChanged);
	g_CvarEndOnAttack.AddChangeHook(OnConVarChanged);
	g_CvarHudShadow.AddChangeHook(OnConVarChanged);
	g_CvarHudHoldTime.AddChangeHook(OnConVarChanged);
	g_CvarHudWarningTime.AddChangeHook(OnConVarChanged);
	g_CvarHudWarningFadeOut.AddChangeHook(OnConVarChanged);
	g_CvarHudEndHoldTime.AddChangeHook(OnConVarChanged);
	g_CvarHudEndFadeOut.AddChangeHook(OnConVarChanged);
	g_CvarHudColorRed.AddChangeHook(OnConVarChanged);
	g_CvarHudColorGreen.AddChangeHook(OnConVarChanged);
	g_CvarHudColorBlue.AddChangeHook(OnConVarChanged);
	g_CvarHudWarningRed.AddChangeHook(OnConVarChanged);
	g_CvarHudWarningGreen.AddChangeHook(OnConVarChanged);
	g_CvarHudWarningBlue.AddChangeHook(OnConVarChanged);

	g_CvarDisableImmunityAlpha = FindConVar("sv_disable_immunity_alpha");
	if (g_CvarDisableImmunityAlpha != null)
	{
		g_CvarDisableImmunityAlpha.IntValue = 1;
		g_CvarDisableImmunityAlpha.AddChangeHook(OnConVarChanged);
	}

	AutoExecConfig(true, "AdvancedSpawnProtect");

	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
	HookEvent("round_end", Event_RoundEnd, EventHookMode_PostNoCopy);
	HookEvent("round_prestart", Event_RoundPrestart, EventHookMode_PostNoCopy);
	HookEvent("weapon_fire", Event_WeaponFire, EventHookMode_Post);

	RegAdminCmd("sm_rainbow", Command_ToggleRainbow, ADMFLAG_RCON, "Toggle a rainbow render effect on yourself.");

	g_IsControllingBotOffset = FindSendPropInfo("CCSPlayer", "m_bIsControllingBot");
	g_HudText = CreateHudSynchronizer();
	g_HudTextShadow = CreateHudSynchronizer();

	RefreshSettings();

	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			OnClientPutInServer(client);
		}
	}
}

public void OnPluginEnd()
{
	for (int client = 1; client <= MaxClients; client++)
	{
		StopSpawnProtectionTimer(client);
		StopRainbowTimer(client);
	}
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_TraceAttack, OnTraceAttack);

	g_SpawnProtectionTimeLeft[client] = 0;
	g_RainbowModelEnabled[client] = false;
	g_SpawnProtectionTimer[client] = null;
	g_RainbowTimer[client] = null;
}

public void OnClientDisconnect(int client)
{
	SDKUnhook(client, SDKHook_TraceAttack, OnTraceAttack);

	StopSpawnProtectionTimer(client);
	StopRainbowTimer(client);

	g_SpawnProtectionTimeLeft[client] = 0;
	g_RainbowModelEnabled[client] = false;
}

public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if (convar == g_CvarDisableImmunityAlpha && g_CvarDisableImmunityAlpha != null && g_CvarDisableImmunityAlpha.IntValue != 1)
	{
		g_CvarDisableImmunityAlpha.IntValue = 1;
		return;
	}

	RefreshSettings();
}

public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (!IsValidClient(client))
	{
		return;
	}

	DisableSpawnProtection(client, false, false);

	if (IsWarmupActive())
	{
		SetClientRenderColor(client, g_ProtectedColor);
		EnsureRainbowTimer(client);
		return;
	}

	if (!g_BotControlEnabled && IsPlayerControllingBot(client))
	{
		ApplyUnprotectedColor(client);
		EnsureRainbowTimer(client);
		return;
	}

	if (g_SpawnProtectionDuration <= 0)
	{
		ApplyUnprotectedColor(client);
		EnsureRainbowTimer(client);
		return;
	}

	SetEntProp(client, Prop_Data, "m_takedamage", DAMAGE_NO, 1);
	g_SpawnProtectionTimeLeft[client] = RoundToCeil(GetSpawnProtectionTimeRemaining());

	SetClientRenderColor(client, g_ProtectedColor);
	ShowSpawnProtectionCountdown(client);

	if (g_NotifyEnabled)
	{
		PrintToChat(client, "%s Spawn protection is now \x04ON.", CHAT_PREFIX);
	}

	g_SpawnProtectionTimer[client] = CreateTimer(1.0, Timer_SpawnProtection, client, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	EnsureRainbowTimer(client);
}

public void Event_WeaponFire(Event event, const char[] name, bool dontBroadcast)
{
	if (!g_EndOnAttackEnabled || IsWarmupActive())
	{
		return;
	}

	int client = GetClientOfUserId(event.GetInt("userid"));
	if (!IsAliveClient(client) || g_SpawnProtectionTimeLeft[client] <= 0)
	{
		return;
	}

	DisableSpawnProtection(client, true, true);
}

public void Event_RoundPrestart(Event event, const char[] name, bool dontBroadcast)
{
	ResetAllSpawnProtection();
}

public void Event_RoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	ResetAllSpawnProtection();
}

public Action Command_ToggleRainbow(int client, int args)
{
	if (!IsValidClient(client))
	{
		return Plugin_Handled;
	}

	g_RainbowModelEnabled[client] = !g_RainbowModelEnabled[client];

	if (g_RainbowModelEnabled[client])
	{
		EnsureRainbowTimer(client);
	}
	else
	{
		StopRainbowTimer(client);

		if (g_SpawnProtectionTimeLeft[client] > 0 || IsWarmupActive())
		{
			SetClientRenderColor(client, g_ProtectedColor);
		}
		else
		{
			ApplyUnprotectedColor(client);
		}
	}

	PrintToChat(client, "%s Rainbow model %s!", CHAT_PREFIX, g_RainbowModelEnabled[client] ? "enabled" : "disabled");
	return Plugin_Handled;
}

public Action Timer_SpawnProtection(Handle timer, any data)
{
	int client = data;
	if (client < 1 || client > MaxClients || timer != g_SpawnProtectionTimer[client])
	{
		return Plugin_Stop;
	}

	if (!IsAliveClient(client))
	{
		g_SpawnProtectionTimer[client] = null;
		g_SpawnProtectionTimeLeft[client] = 0;
		if (IsValidClient(client))
		{
			ClearSpawnProtectionHud(client);
		}
		return Plugin_Stop;
	}

	g_SpawnProtectionTimeLeft[client]--;

	if (g_SpawnProtectionTimeLeft[client] <= 0)
	{
		g_SpawnProtectionTimer[client] = null;
		FinishSpawnProtection(client, true, true);
		return Plugin_Stop;
	}

	SetClientRenderColor(client, g_ProtectedColor);
	ShowSpawnProtectionCountdown(client);
	return Plugin_Continue;
}

public Action Timer_RainbowColor(Handle timer, any data)
{
	int client = data;
	if (client < 1 || client > MaxClients || timer != g_RainbowTimer[client] || !g_RainbowModelEnabled[client] || !IsAliveClient(client))
	{
		if (client >= 1 && client <= MaxClients && g_RainbowTimer[client] == timer)
		{
			g_RainbowTimer[client] = null;
		}

		return Plugin_Stop;
	}

	int color[4];
	GetRainbowColor(client, 0.3, color);
	SetClientRenderColor(client, color);
	return Plugin_Continue;
}

public Action OnTraceAttack(int victim, int &attacker, int &inflictor, float &damage, int &damageType, int &ammoType, int hitbox, int hitgroup)
{
	if (!IsAliveClient(victim) || attacker == victim || !IsAliveClient(attacker))
	{
		return Plugin_Continue;
	}

	if (IsWarmupActive() || g_SpawnProtectionTimeLeft[attacker] > 0)
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

void RefreshSettings()
{
	g_SpawnProtectionDuration = g_CvarSpawnProtectionTime.IntValue;
	g_BotControlEnabled = g_CvarBotControl.BoolValue;
	g_NotifyEnabled = g_CvarNotifyStart.BoolValue;
	g_FfaColorsEnabled = g_CvarFfaMode.BoolValue;
	g_ColorModelsEnabled = g_CvarColorModels.BoolValue;
	g_EndOnAttackEnabled = g_CvarEndOnAttack.BoolValue;
	g_HudShadowEnabled = g_CvarHudShadow.BoolValue;
	g_HudWarningTime = g_CvarHudWarningTime.IntValue;
	g_HudHoldTime = g_CvarHudHoldTime.FloatValue;
	g_HudWarningFadeOut = g_CvarHudWarningFadeOut.FloatValue;
	g_HudEndHoldTime = g_CvarHudEndHoldTime.FloatValue;
	g_HudEndFadeOut = g_CvarHudEndFadeOut.FloatValue;

	g_HudColor[0] = g_CvarHudColorRed.IntValue;
	g_HudColor[1] = g_CvarHudColorGreen.IntValue;
	g_HudColor[2] = g_CvarHudColorBlue.IntValue;
	g_HudColor[3] = 255;
	g_HudWarningColor[0] = g_CvarHudWarningRed.IntValue;
	g_HudWarningColor[1] = g_CvarHudWarningGreen.IntValue;
	g_HudWarningColor[2] = g_CvarHudWarningBlue.IntValue;
	g_HudWarningColor[3] = 255;
}

void ResetAllSpawnProtection()
{
	for (int client = 1; client <= MaxClients; client++)
	{
		if (!IsClientInGame(client))
		{
			continue;
		}

		DisableSpawnProtection(client, false, false);
	}
}

void DisableSpawnProtection(int client, bool notifyClient, bool showHudNotice)
{
	StopSpawnProtectionTimer(client);
	FinishSpawnProtection(client, notifyClient, showHudNotice);
}

void FinishSpawnProtection(int client, bool notifyClient, bool showHudNotice)
{
	g_SpawnProtectionTimeLeft[client] = 0;

	if (!IsValidClient(client))
	{
		return;
	}

	SetEntProp(client, Prop_Data, "m_takedamage", DAMAGE_YES, 1);
	ApplyUnprotectedColor(client);

	if (showHudNotice)
	{
		ShowSpawnProtectionEndNotice(client);
	}
	else
	{
		ClearSpawnProtectionHud(client);
	}

	if (notifyClient && g_NotifyEnabled)
	{
		PrintToChat(client, "%s Spawn protection is now \x07OFF.", CHAT_PREFIX);
	}
}

void StopSpawnProtectionTimer(int client)
{
	if (client < 1 || client > MaxClients)
	{
		return;
	}

	if (g_SpawnProtectionTimer[client] != null)
	{
		delete g_SpawnProtectionTimer[client];
		g_SpawnProtectionTimer[client] = null;
	}
}

void StopRainbowTimer(int client)
{
	if (client < 1 || client > MaxClients)
	{
		return;
	}

	if (g_RainbowTimer[client] != null)
	{
		delete g_RainbowTimer[client];
		g_RainbowTimer[client] = null;
	}
}

void EnsureRainbowTimer(int client)
{
	if (!g_RainbowModelEnabled[client] || !IsAliveClient(client) || g_RainbowTimer[client] != null)
	{
		return;
	}

	g_RainbowTimer[client] = CreateTimer(0.1, Timer_RainbowColor, client, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

void ShowSpawnProtectionCountdown(int client)
{
	bool warning = g_HudWarningTime > 0 && g_SpawnProtectionTimeLeft[client] <= g_HudWarningTime;
	float fadeOut = warning ? g_HudWarningFadeOut : 0.0;

	if (g_HudShadowEnabled)
	{
		SetSpawnProtectionHudShadowStyle(g_HudHoldTime, fadeOut);
		ShowSyncHudText(client, g_HudTextShadow, "Spawn Protection\n%d seconds left", g_SpawnProtectionTimeLeft[client]);
	}
	else if (g_HudTextShadow != null)
	{
		ClearSyncHud(client, g_HudTextShadow);
	}

	SetSpawnProtectionHudStyle(warning ? g_HudWarningColor : g_HudColor, g_HudHoldTime, fadeOut);
	ShowSyncHudText(client, g_HudText, "Spawn Protection\n%d seconds left", g_SpawnProtectionTimeLeft[client]);
}

void ShowSpawnProtectionEndNotice(int client)
{
	if (g_HudShadowEnabled)
	{
		SetSpawnProtectionHudShadowStyle(g_HudEndHoldTime, g_HudEndFadeOut);
		ShowSyncHudText(client, g_HudTextShadow, "Spawn Protection\nis now off!");
	}
	else if (g_HudTextShadow != null)
	{
		ClearSyncHud(client, g_HudTextShadow);
	}

	SetSpawnProtectionHudStyle(g_HudWarningColor, g_HudEndHoldTime, g_HudEndFadeOut);
	ShowSyncHudText(client, g_HudText, "Spawn Protection\nis now off!");
}

void SetSpawnProtectionHudStyle(const int color[4], float holdTime, float fadeOut)
{
	SetHudTextParams(-1.0, 0.1, holdTime, color[0], color[1], color[2], color[3], 0, 0.0, 0.0, fadeOut);
}

void SetSpawnProtectionHudShadowStyle(float holdTime, float fadeOut)
{
	SetHudTextParams(-1.0, 0.103, holdTime, g_HudShadowColor[0], g_HudShadowColor[1], g_HudShadowColor[2], g_HudShadowColor[3], 0, 0.0, 0.0, fadeOut);
}

void ClearSpawnProtectionHud(int client)
{
	if (g_HudText != null)
	{
		ClearSyncHud(client, g_HudText);
	}

	if (g_HudTextShadow != null)
	{
		ClearSyncHud(client, g_HudTextShadow);
	}
}

void ApplyUnprotectedColor(int client)
{
	if (!IsValidClient(client))
	{
		return;
	}

	if (!g_ColorModelsEnabled)
	{
		SetClientRenderColor(client, g_DefaultColor);
		return;
	}

	if (g_FfaColorsEnabled)
	{
		SetClientRenderColor(client, g_UnprotectedColorFFA);
		return;
	}

	switch (GetClientTeam(client))
	{
		case CS_TEAM_T:
		{
			SetClientRenderColor(client, g_UnprotectedColorT);
		}
		case CS_TEAM_CT:
		{
			SetClientRenderColor(client, g_UnprotectedColorCT);
		}
		default:
		{
			SetClientRenderColor(client, g_DefaultColor);
		}
	}
}

void SetClientRenderColor(int client, const int color[4])
{
	if (!IsValidClient(client))
	{
		return;
	}

	SetEntityRenderMode(client, RENDER_TRANSALPHA);
	SetEntityRenderColor(client, color[0], color[1], color[2], color[3]);
}

void GetRainbowColor(int client, float rate, int color[4])
{
	float gameTime = GetGameTime() * rate + float(client);

	color[0] = RoundToNearest(Cosine(gameTime + 0.0) * 127.5 + 127.5);
	color[1] = RoundToNearest(Cosine(gameTime + 2.0) * 127.5 + 127.5);
	color[2] = RoundToNearest(Cosine(gameTime + 4.0) * 127.5 + 127.5);
	color[3] = 255;
}

bool IsPlayerControllingBot(int client)
{
	if (g_IsControllingBotOffset < 0 || !IsValidClient(client))
	{
		return false;
	}

	return view_as<bool>(GetEntData(client, g_IsControllingBotOffset, 1));
}

bool IsWarmupActive()
{
	return GameRules_GetProp("m_bWarmupPeriod") != 0;
}

float GetSpawnProtectionTimeRemaining()
{
	float remaining = float(g_SpawnProtectionDuration);
	float roundStartDelta = GameRules_GetPropFloat("m_fRoundStartTime") - GetGameTime();
	if (roundStartDelta > 0.0)
	{
		remaining += roundStartDelta;
	}

	return remaining > 0.0 ? remaining : 0.0;
}

bool IsValidClient(int client)
{
	return client >= 1 && client <= MaxClients && IsClientInGame(client);
}

bool IsAliveClient(int client)
{
	return IsValidClient(client) && IsPlayerAlive(client);
}
