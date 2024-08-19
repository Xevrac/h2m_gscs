![H2M](https://github.com/user-attachments/assets/42656b5e-5052-457d-a780-bc8f5fa22df3)

# h2m_gscs
This is a collection of our GSCs. Some are authored by Xevrac and/or in collaboration with other developers. Credits are included in each script respectively.

# Install steps
Steps are super simple so I will keep it high level.

* Drop the scripts into `.\h2m-mod\user_scripts\mp\`.
* Some scripts require a DVAR to enable / disable, use where required.

# What's in the repo
> Note this is currently broken and will be fixed in v3
* Nuke to Moab Patch
  * This patch tweaks the game's Nuke to not end_game rather kill all players and resume as normal
  * Enable/Disable DVAR `set nukeEndsGame "0"` (off) or `set nukeEndsGame "1"` (on)

* Multiplayer Bots
  * Refined codebase compared to the included copy with H2M
  * Enable/Disable DVAR `set enableBotScript "1"` (on) or `set enableBotScript "0"` (off)
    * Place in your server `.cfg`

* g_Entity Patch
  * Replaces `chopper_gunner_mp` with `ac130_m` killstreak
  * This reduces likelihood of g_Entity crashes however other entity data cause this issue so its not a permanent fix
 
* More scripts coming soon!

# References

[H2M GSC Dump](https://github.com/Jeffx539/h2m-gsc-dump/tree/main)
