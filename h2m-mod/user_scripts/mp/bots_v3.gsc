/*
	Modified by TokyoCowboy using Bot Spawning from Autobots by DoktorSAS
	Modified By MinSpecMike Using Cursor AI
	Modified By Xevrac
	Created By Jeffy
	Better Bots Script, With DVARs And Random Bot Ranks/Prestiges/Difficulties
	v3.0
*/

#include maps\mp\bots\_bots;
#include maps\mp\bots\_bots_util;
#include maps\mp\gametypes\_persistence;

init()
{
	level.max_rank = 70;  // Maximum rank in MWR (1-70)
    level.max_prestige = 10;  // Maximum prestige in MWR (0-10)
    setup_bot_ranks();
    setup_bot_difficulties();
    level thread onPlayerConnect();
    level thread serverBotFill();
	
}

setup_bot_ranks()
{
    level.bot_rnd_rank = [];
    level.bot_rnd_rank["recruit"][0] = 5;
    level.bot_rnd_rank["recruit"][1] = level.max_rank;
    level.bot_rnd_rank["regular"][0] = 10;
    level.bot_rnd_rank["regular"][1] = level.max_rank;
    level.bot_rnd_rank["hardened"][0] = 25;
    level.bot_rnd_rank["hardened"][1] = level.max_rank;
    level.bot_rnd_rank["veteran"][0] = 50;
    level.bot_rnd_rank["veteran"][1] = level.max_rank;

    level.bot_rnd_prestige = [];
    level.bot_rnd_prestige["recruit"][0] = 0;
    level.bot_rnd_prestige["recruit"][1] = 0;
    level.bot_rnd_prestige["regular"][0] = 1;
    level.bot_rnd_prestige["regular"][1] = 4;
    level.bot_rnd_prestige["hardened"][0] = 4;
    level.bot_rnd_prestige["hardened"][1] = 8;
    level.bot_rnd_prestige["veteran"][0] = 8;
    level.bot_rnd_prestige["veteran"][1] = level.max_prestige;
}

setup_bot_difficulties()
{
    level.bot_difficulties = [];
    level.bot_difficulties[0] = "recruit";
    level.bot_difficulties[1] = "regular";
    level.bot_difficulties[2] = "hardened";
    level.bot_difficulties[3] = "veteran";
    
    // Adjust these percentages to change the distribution of bot difficulties
    level.bot_difficulty_percentages = [];
    level.bot_difficulty_percentages["recruit"] = 11;
    level.bot_difficulty_percentages["regular"] = 22;
    level.bot_difficulty_percentages["hardened"] = 45;
    level.bot_difficulty_percentages["veteran"] = 22;
}

get_random_bot_difficulty()
{
    rand = randomint(100);
    cumulative = 0;
    
    for (i = 0; i < level.bot_difficulties.size; i++)
    {
        difficulty = level.bot_difficulties[i];
        cumulative += level.bot_difficulty_percentages[difficulty];
        if (rand < cumulative)
            return difficulty;
    }
    
    return "regular"; // Fallback to regular if something goes wrong
}

bot_random_ranks_for_difficulty(difficulty)
{
    rankData = [];
    rankData["rank"] = 0;
    rankData["prestige"] = 0;

    if (difficulty == "default")
        return rankData;

    rankData["rank"] = randomintrange(level.bot_rnd_rank[difficulty][0], level.bot_rnd_rank[difficulty][1] + 1);
    rankData["prestige"] = randomintrange(level.bot_rnd_prestige[difficulty][0], level.bot_rnd_prestige[difficulty][1] + 1);
    rankData["rankxp"] = rankData["rank"] * 10000 + randomint(10000);  // Approximate XP calculation
    return rankData;
}

set_bot_rank(bot)
{
    if (isdefined(bot.rank_set) && bot.rank_set)
        return;

    difficulty = get_random_bot_difficulty();
    bot maps\mp\bots\_bots_util::bot_set_difficulty(difficulty);
    
    rankData = bot_random_ranks_for_difficulty(difficulty);
    
    // Set the bot's rank, XP, and prestige
    bot.pers["rank"] = rankData["rank"];
    bot.pers["experience"] = rankData["rankxp"];
    bot.pers["prestige"] = rankData["prestige"];
    
    // Set actual values
    bot.rank = rankData["rank"];
    bot.prestige = rankData["prestige"];
    
    // Use maps\mp\gametypes\_persistence::statset to ensure values are properly set
    bot maps\mp\gametypes\_persistence::statset("rank", rankData["rank"]);
    bot maps\mp\gametypes\_persistence::statset("experience", rankData["rankxp"]);
    bot maps\mp\gametypes\_persistence::statset("prestige", rankData["prestige"]);
    
    // Force update of player information
    wait 0.05; // Short delay to allow values to be processed
    bot updatescores();
    bot.rank_set = true;
}

onPlayerConnect()
{
    level endon("game_ended");
    for (;;)
    {
        level waittill("connected", player);
        if (!player isentityabot())
        {
            player thread kickBotOnJoin();
        }
    }
}

isentityabot()
{
    return isSubStr(self getguid(), "bot");
}
serverBotFill()
{
    level endon("game_ended");
    level waittill("connected", player);
    for (;;)
    {
        while (level.players.size < 18 && !level.gameended)
        {
            self spawnBots(11);
            wait 1;
        }
		foreach (player in level.players)
		{
			if (isbot(player) && (!isdefined(player.rank_set) || !player.rank_set))
			{
				set_bot_rank(player);
			}
		}
        if (level.players.size >= 18 && contBots() > 0)
            kickbot();

        wait 0.05;
    }
}

contBots()
{
    bots = 0;
    foreach (player in level.players)
    {
        if (player isentityabot())
        {
            bots++;
        }
    }
    return bots;
}

spawnBots(a)
{
    spawn_bots(a, "autoassign");
}

kickbot()
{
    level endon("game_ended");
    foreach (player in level.players)
    {
        if (player isentityabot())
        {
            player bot_drop();
            break;
        }
    }
}

kickBotOnJoin()
{
    level endon("game_ended");
    foreach (player in level.players)
    {
        if (player isentityabot())
        {
            player bot_drop();
            break;
        }
    }
}