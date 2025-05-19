init()
{
    level thread onplayerconnect();
}

onplayerconnect()
{
    while(true)
    {
        level waittill("connected", player);
        player thread onplayerspawned();
    }
}

onplayerspawned()
{
    while(true)
    {
        self waittill("spawned_player");
        if(self.first)
        {
            if(isMaxLevel(self))
            {
                self thread kickMaxLevel(); 
            }
            else if(!isMaxLevel(self))
            {
                self iprintln("Welcome: "+self.name);
            }
            self.first = false;
        }
    }
}

kickMaxLevel()
{
    self iprintln("Player kicked. Unlock All is not ^1not allowed^7 on this server.");
    wait 10;
    kick( self getentitynumber(), "EXE_PLAYERKICKED" );
}

isMaxLevel(player)
{
    if(self.pers["prestige"] >= 10 && self.pers["rank"] >= 900)
    {
        return true;
    }
    else
        return false;
}