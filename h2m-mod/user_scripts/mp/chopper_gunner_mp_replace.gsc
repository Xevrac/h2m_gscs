/*
	Fix chopper_gunner_mp crashing server on occasions
	This script replaces the chopper_gunner with ac130.
    Creator: Jeffy
    Distributed by: Xevrac

    This script is a temp fix for a known entity issue in-game. This fix is not intended to permanently resolve the issue however does reduce the likelihood. 
*/

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_gamelogic;

init()
{
    level thread constantMessageLoop();
}

constantMessageLoop()
{
    while(1)
    {
        foreach (player in level.players)
        {

            // Check and replace Chopper Gunner if it exists
            if (isDefined(player.pers["killstreaks"]) && player.pers["killstreaks"].size > 0)
            {
                for (i = 0; i < player.pers["killstreaks"].size; i++)
                {
                    if (player.pers["killstreaks"][i].streakName == "chopper_gunner_mp")
                    {
                        player.pers["killstreaks"][i].streakName = "ac130_mp";
                        player iprintlnbold("^7Chopper Gunner has been replaced with AC130 to prevent server crashes.");
                        player SetActionSlot(4, "");
                        player giveweapon("ac130_mp");
                        player givemaxammo("ac130_mp");
                        player setactionslot(4, "weapon", "ac130_mp");
                    }
                }
            }
        }

        // Wait for a few seconds before checking again
        wait 1;
    }
}