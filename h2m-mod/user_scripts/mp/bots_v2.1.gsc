// Modified by Xevrac
// Created by Jeffy
// Better bots script, also adds DVAR for selective enablement on servers from same-host environments
// v2.1

init()
{
    self thread handle_bot_count();
}

handle_bot_count()
{
    if ( !isDefined("enableBotScript") )
    {
        setDvarIfUninitialized("enableBotScript", 1); 
    }

    if ( getDvarInt("enableBotScript") != 1 )
    {
        return; 
    }

    if ( !isDefined("botQuota") )
    {
        setDvarIfUninitialized("botQuota", 18); 
    }

    bot_quota = getDvarInt("botQuota");

    level endon( "game_ended" );
    level waittill( "prematch_over" );

    for(;;)
    {
        wait 0.5;
         player_count = level.players.size;
        if( player_count < bot_quota )
        {
            fill_amount = bot_quota - player_count;
            for( i=0; i < fill_amount; i++ )
            {
                executecommand("spawnbot 1");
                wait 0.01;
            }
            iprintln("[BOT] Filling with " + fill_amount + " bots to reach quota " + bot_quota);
            wait 2.0;

        }
        else if ( player_count > bot_quota)
        {
            foreach(player in level.players)
            {
                if( isBot( player ) )
                {
                    kick( player getEntityNumber() );
                    break;
                }
            }
        }
    }
}