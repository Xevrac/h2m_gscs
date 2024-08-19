// Created by Xevrac
// Modify NUKE to MOAB style 
// Use DVAR nukeEndsGame to 0 for no endgame nuke like MW3 MOAB
// Version 2.0

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_gamelogic;
#include maps\mp\h2_killstreaks\_nuke;

init()
{
    setDvarIfUninitialized("nukeEndsGame", 1);

    replaceFunc(maps\mp\h2_killstreaks\_nuke::nukeDeath, ::customNukeDeath);
}

customNukeDeath()
{
    level endon("nuke_cancelled");
    level notify("nuke_death");

    maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
    AmbientStop(1);

    nukeEndsGame = getDvarInt("nukeEndsGame");

    if (nukeEndsGame == 1)
    {
        foreach (player in level.players)
        {
            if (isAlive(player))
                player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper(level.nukeInfo.player, level.nukeInfo.player, 999999, 0, "MOD_EXPLOSIVE", "nuke_mp", player.origin, player.origin, "none", 0, 0);
        }

        if (level.teamBased)
            thread maps\mp\gametypes\_gamelogic::endGame(level.nukeInfo.team, game["strings"]["nuclear_strike"], true);
        else
        {
            if (isDefined(level.nukeInfo.player))
                thread maps\mp\gametypes\_gamelogic::endGame(level.nukeInfo.player, game["strings"]["nuclear_strike"], true);
            else
                thread maps\mp\gametypes\_gamelogic::endGame(level.nukeInfo, game["strings"]["nuclear_strike"], true);
        }
    }
    else if (nukeEndsGame == 0)
    {
        foreach (player in level.players)
        {
            if (isAlive(player))
                player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper(level.nukeInfo.player, level.nukeInfo.player, 999999, 0, "MOD_EXPLOSIVE", "nuke_mp", player.origin, player.origin, "none", 0, 0);
        }
    }
}
