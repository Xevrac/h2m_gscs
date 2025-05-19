init()
{
	setDvarIfUninitialized("sv_mapvote_time", 60);
	thread setMapVoteTimer();
}
setMapVoteTimer()
{
	wait(1);

	level.mapvote_duration = getDvarInt("sv_mapvote_time");
    setDvar("mapvote_timeleft", level.mapvote_duration);
}