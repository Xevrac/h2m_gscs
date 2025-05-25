/*
    v4.0 Refactor and performance improvements by Horizonz
    v3.1 Modified by Xevrac adding DVAR logic back in from v2.1
    v3.0 Modified by TokyoCowboy using bot spawning from autobots by DoktorSAS
    v2.2 Modified By MinSpecMike using Cursor AI
    v2.1 Modified By Xevrac
    Created By Jeffy
    Better Bots Script, With DVARs and random bot Ranks / Prestiges / Difficulties
    Version: v3.1
*/

init()
{
    self thread handle_bot_count();
}

handle_bot_count()
{
    if (!isDefined("enableBotScript"))
    {
        setDvarIfUninitialized("enableBotScript", 1); 
    }

    if (getDvarInt("enableBotScript") != 1)
    {
        return; 
    }

    if (!isDefined("botQuota"))
    {
        setDvarIfUninitialized("botQuota", 18); 
    }

    bot_quota = getDvarInt("botQuota");

    level endon("game_ended");
    level waittill("prematch_over");

    for (;;)
    {
        wait 0.5;
        player_count = level.players.size;

        if (player_count < bot_quota)
        {
            fill_amount = bot_quota - player_count;

            for (i = 0; i < fill_amount; i++)
            {
                team = getBalancedTeam();
                executecommand("spawnbot 1"); // Add the bot
                wait 0.1;

                bot = getNewestBot(); // Get the bot that was just spawned
                if (isDefined(bot))
                {
                    spawnpoint = getTeamSpawnPoint(team);
                    if (isDefined(spawnpoint))
                    {
                        bot.sessionteam = team;
                        bot.origin = spawnpoint.origin;
                        bot.angles = spawnpoint.angles;
                    }
                }
                wait 0.1;
            }

            iprintln("[BOT] Filled with " + fill_amount + " bot(s) to reach quota of " + bot_quota);
            wait 2.0;
        }
        else if (player_count > bot_quota)
        {
            foreach (player in level.players)
            {
                if (isBot(player))
                {
                    kick(player getEntityNumber());
                    break;
                }
            }
        }
    }
}

getBalancedTeam()
{
    axisCount = 0;
    alliesCount = 0;

    foreach(p in level.players)
    {
        if (p.sessionteam == "axis") axisCount++;
        else if (p.sessionteam == "allies") alliesCount++;
    }

    if (axisCount <= alliesCount)
        return "axis";
    else
        return "allies";
}

getTeamSpawnPoint(team)
{
    classname = "mp_team_spawn_" + team; // "axis" or "allies"
    spawnpoints = getentarray(classname, "classname");

    if (spawnpoints.size > 0)
    {
        return spawnpoints[randomint(spawnpoints.size)];
    }

    return undefined;
}

getNewestBot()
{
    bots = [];
    foreach (p in level.players)
    {
        if (isBot(p))
        {
            bots[bots.size] = p;
        }
    }

    if (bots.size > 0)
    {
        return bots[bots.size - 1]; // Return the most recently added bot
    }

    return undefined;
}

isBot(player)
{
    return (player isAI()); // Some engines may still use isTestClient()
}