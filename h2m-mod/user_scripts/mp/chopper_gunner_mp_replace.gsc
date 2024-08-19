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

player_spawned()
{
    self endon("disconnect");
    level endon("game_ended");
    for(;;){

        if(self.pers["killstreaks"].size == 0) {
            wait 0.2;
            continue;
        }

    for(i = 0; i < self.pers["killstreaks"].size ;i++){
        if (self.pers[ "killstreaks" ][i].streakName == "chopper_gunner_mp") {
            self.pers[ "killstreaks" ][i].streakName  = "ac130_mp";
            iprintlnbold("^7Chopper Gunner has been replaced to AC130 to prevent server crashes.");
            self SetActionSlot( 4,"" );
            self giveweapon( "ac130_mp" );
            self givemaxammo( "ac130_mp" );
            self setactionslot( 4, "weapon", "ac130_mp" );

        }
    }

     wait 0.2;
    }
}