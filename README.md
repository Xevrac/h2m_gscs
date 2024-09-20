![HMW](https://github.com/user-attachments/assets/9ed9ba0e-81a1-4e88-824d-3253af04b85d)

![H2M](https://github.com/user-attachments/assets/42656b5e-5052-457d-a780-bc8f5fa22df3)

# h2m_gscs
This is a collection of our GSCs. Some are authored by Xevrac and/or in collaboration with other developers. Credits are included in each script respectively.

# Install steps
Steps are super simple so I will keep it high level.

* Drop the scripts into `.\h2m-mod\user_scripts\mp\`.
* Some scripts require a DVAR to enable / disable, use where required.

# What's in the repo
> Note more work needed to fix timer on DOM. Timer works for FFA. (scores not updated yet)
* Nuke to Moab Patch
  * This patch tweaks the game's Nuke to not end_game rather kill all players and resume as normal
  * Enable/Disable DVAR `set nukeEndsGame "0"` (off) or `set nukeEndsGame "1"` (on)

* Multiplayer Bots
  * Refined codebase compared to the included copy with H2M
  * Enable/Disable DVAR `set enableBotScript "1"` (on) or `set enableBotScript "0"` (off)
  * Set amount of bots on your server `set botQuota "6"` e.g. sets 6 bot quota, i.e. if a player joins, 5 bots will be present + 1 player (6)
    * Place in your server `.cfg`

* g_Entity Patch
  * Replaces `chopper_gunner_mp` with `ac130_mp` killstreak
  * This reduces likelihood of g_Entity crashes however other entity data cause this issue so its not a permanent fix
 
* More scripts coming soon!

# References

[H2M GSC Dump](https://github.com/Jeffx539/h2m-gsc-dump/tree/main)
