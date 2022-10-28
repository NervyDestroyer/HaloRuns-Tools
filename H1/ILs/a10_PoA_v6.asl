//Halo IL autosplitter (easy and leg)
//by Burnt & Wackee

//REMEMBER, easy should have 8 splits, leg should have 7
	
state("halo") 
{
	uint tickcounter1: 0x2F1D8C; //pauses on pause menu, resets on reverts 
	byte bspstate: 0x29E8D8; //tracks which bsp is loaded
	string3 levelname: 0x319780; //tracks which level is loaded
	float xpos: 0x2AC5BC; //chief camera x position
	float ypos: 0x2AC5C0; //chief camera y position
	byte fade: 0x3FF1581A; //0 if not 1 if fading
	byte playercontrol: 0x2869D1; //1 for true, 0 for false
	byte difficulty: 0x3FC00126; //0 for easy, 3 for leg
	float maintdoor: 0x3FC26E2C; //power setting of maint door
	float firstdoor: 0x3FC26CC4; //position setting of first door
	byte cutsceneskip: 0x3FFFD67A; //true when cutscene is skippable
	byte cinematic: 0x3FFFD679; //true when cutscene is playing
}

startup //settings for which splits you want to use 
{
	settings.Add("Sam", true, "split on moving through sam door");
	settings.Add("Bridge", true, "split on keyes fade end");
	settings.Add("Load", true, "split on passing load trigger");
	settings.Add("Upstairs", true, "split on passing under the steel arch upstairs");
	settings.Add("Maintenance", true, "split on passing through maintenance door");
	settings.Add("Easy", true, "split on passing through the broken door IF easy");
	settings.Add("2LD", true, "split on leaving 2nd to last door");
	settings.Add("Frags", true, "split on approaching the frag barrier");
} 

init
{
	vars.indexoffset = 0;
} 


start
{
	vars.indexoffset = 0;
	return (current.bspstate == 0 && current.tickcounter1 > 280 && current.cinematic == 0 && old.cinematic == 1);
}

split
{

	int checkindex = timer.CurrentSplitIndex + vars.indexoffset;

	//print("checkindex = "+checkindex);
	//print("vars.indexoffset = "+vars.indexoffset);
	//print("timer.CurrentSplitIndex = "+timer.CurrentSplitIndex);

	switch (checkindex)
	{
 
		case 0: 
		if (!(settings["Sam"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.xpos > -51.5 && !(old.xpos > -51.5) && current.bspstate == 0 && current.levelname == "a10" && current.playercontrol == 1);
		break;




		case 1:
		if (!(settings["Bridge"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.fade == 1 && current.fade == 0 && current.bspstate == 1);
		break;
		
		case 2:
		if (!(settings["Load"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.bspstate == 3 && !(old.bspstate == 3));
		break;

		case 3:
		if (!(settings["Upstairs"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.bspstate == 4 && current.xpos < -92 && current.ypos > 24.5 && !(old.ypos > 24.5));
		break;

	    //need to fix to be able to undo split
		case 4:
		if (!(settings["Maintenance"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.xpos < -60 && !(old.xpos < -60) && current.bspstate == 4 && current.maintdoor == 1.0);
		break;

	
		case 5:
		if (!(settings["Easy"]))
		{
		vars.indexoffset++;
		break;
		}
		if (current.difficulty > 1)
		{
		vars.indexoffset++;
		break;
		}
		else 
		{
		return (current.xpos < -66.1 && !(old.xpos < -66.1) && current.bspstate == 5);
		break;
		}





		
		case 6:
		if (!(settings["2LD"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.ypos < -32.9 && !(old.ypos < -32.9) && current.bspstate == 6);
		break;		
		
		case 7:
		if (!(settings["Frags"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.ypos < -47.8 && !(old.ypos < -47.8) && current.bspstate == 6);
		break;

		default:	//end level splitw
		return (current.bspstate == 6 && current.cutsceneskip == 1 && old.cutsceneskip == 0);
		break;
	}
}

reset
{
	return (current.levelname == "a10" && current.bspstate == 0 && current.cutsceneskip == 0 && old.cutsceneskip == 1);
}