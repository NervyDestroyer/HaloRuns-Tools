//GS IL autosplitter (easy and leg)
//by Burnt
	
state("halo") 
{
	uint tickcounter1: 0x2F1D8C; //pauses on pause menu, resets on reverts 
	byte bspstate: 0x29E8D8; //tracks which bsp is loaded
	string3 levelname: 0x319780; //tracks which level is loaded
	byte cinematic: 0x3FFFD679; //true when cutscene is playing
	byte cutsceneskip: 0x3FFFD67A; //true when cutscene is skippable
}

startup //settings for which splits you want to use
{
settings.Add("bsp1", true, "split on 1st lift bsp load");
settings.Add("bsp3", true, "split on 2nd lift bsp load");
settings.Add("bsp4", true, "split on load after camojumo");
settings.Add("bsp5", true, "split on 3rd lift bsp load");

}

init
{
vars.indexoffset = 0;
}

start 	//starts timer
{
vars.indexoffset = 0;
return (current.cinematic == 0 && old.cinematic == 1 && current.tickcounter1 < 670 && current.levelname == "c10"); //starts timer on specific tick that chief hits the ground
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
		if (!(settings["bsp3"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.bspstate != 3 && current.bspstate == 3);
		break;

		case 2: //split on load after camojumo
		if (!(settings["bsp4"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.bspstate != 4 && current.bspstate == 4);
		break;
		
		case 3: //split on 3rd lift bsp load
		if (!(settings["bsp5"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.bspstate != 5 && current.bspstate == 5);
		break;
		
		
		default:	//splits on level end
		return (current.bspstate != 2 && current.cutsceneskip == 1 && old.cutsceneskip == 0);
		break;
	}
}

reset
{
return (current.tickcounter1 < 650 && current.levelname == "c10");
}