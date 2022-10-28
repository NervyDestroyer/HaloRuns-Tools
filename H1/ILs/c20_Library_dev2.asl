//library IL autosplitter (easy and leg)
//by Burnt
	
state("halo") 
{
	uint tickcounter1: 0x2F1D8C; //pauses on pause menu, resets on reverts 
	byte bspstate: 0x29E8D8; //tracks which bsp is loaded
	string3 levelname: 0x319780; //tracks which level is loaded
	byte chiefcontrol: 0x2869D0; // 1 when level ends
	byte cutsceneskip: 0x3FFFD67A; //true when cutscene is skippable
	byte cinematic: 0x3FFFD679; //true when cutscene is playing
	byte fade: 0x3FF1581A; //1 if fading
	short fadelength: 0x3FF15818; //length of fade
	uint fadetick: 0x3FF15814; //start of fade

}

startup //settings for which splits you want to use
{
settings.Add("bsp1", true, "split on 1st lift bsp load");
settings.Add("bsp2", true, "split on 2nd lift bsp load");
settings.Add("bsp3", true, "split on 3rd lift bsp load");


}

init
{
vars.indexoffset = 0;
}

start 	//starts timer
{
vars.indexoffset = 0;
return (current.cutsceneskip == 0 && old.cutsceneskip == 1 && current.levelname == "c20"); 
}

split
{
int checkindex = timer.CurrentSplitIndex + vars.indexoffset;
	switch (checkindex)
	{
		case 0: //split on 1st lift bsp load
		if (!(settings["bsp1"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.bspstate != 1 && current.bspstate == 1);
		break;
		
		case 1: //split on 2nd lift bsp load
		if (!(settings["bsp2"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.bspstate != 2 && current.bspstate == 2);
		break;

		case 2: //split on 3rd lift bsp load
		if (!(settings["bsp3"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.bspstate != 3 && current.bspstate == 3);
		break;
		

		
		
		default:	//splits on level end
		return (current.cinematic == 1 && old.cinematic == 0 && current.tickcounter1 > 60);
		break;
	}
}

reset
{
return (current.tickcounter1 < 30 && current.cutsceneskip == 1 && current.levelname == "c20");
}