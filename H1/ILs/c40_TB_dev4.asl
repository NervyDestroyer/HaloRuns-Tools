//TB IL autosplitter (easy and leg)
//by Burnt
	
	
	//INSTALL INSTRUCTIONS
    //put this file anywhere you want
    //go to "Edit Layout" in livesplit
    //click the big plus sign
    //go to control > scriptable auto timer
    //double click the scriptable auto timer in your layout
    //browse the script path to wherever this .asl file is and load it
    //then, !!IMPORTANT!! right click livesplit > Compare Against > select "Real Time"
	
	
state("halo") 
{
	uint tickcounter1: 0x2F1D8C; //pauses on pause menu, resets on reverts 
	byte bspstate: 0x29E8D8; //tracks which bsp is loaded
	byte chiefstate: 0x2AC5B4; //tracks whether chief in cutscene or vehicle maybe
	string3 levelname: 0x319780; //tracks which level is loaded
	byte cutsceneskip: 0x3FFFD67A; //true when cutscene is skippable
	byte cutscenetrack: 0x29E8D8; //tracks which cutscene chief is in - TODO: PROBABLY REMOVE
	float xpos: 0x2AC5BC; //chief camera x position - TODO: replace with actual x & y
	float ypos: 0x2AC5C0; //chief camera y position
	byte door1state: 0x3FC8EEA0; //tracks state of first door button
	byte door3state: 0x3FC8E030; //tracks state of third door button
	byte gen1state: 0x3FFE11A2; //tracks state of first pulse generator
	uint b1startstate: 0x3FC26D44; //tracks state of b1start door  
	uint b1endstate: 0x3FC7EF04; //tracks state of b1end door 
	uint b2startstate: 0x3FC7E87C; //tracks state of b2start door
	uint b2endstate: 0x3FC7E1F4; //tracks state of b2end door
	uint liftstate: 0x004603B0, 0x730, 0x124; //tracks state of elevator
	uint brokendoorstate: 0x3FC26C64; //tracks state of broken door
	uint lastdoorstate: 0x3FC26C74; //tracks state of last door
	bool unpaused: 0x286A98; //1 normally, 0 when paused
	byte fade: 0x3FF1581A; //1 if fading
}


startup //settings for which splits you want to use
{
settings.Add("door1", false, "split on 1st door button"); //default to off
settings.Add("door3", true, "split on 3rd door button");
settings.Add("banshee1", true, "split on Banshee");
settings.Add("gen1", true, "split on Gen 1's death");
settings.Add("ibdoor", false, "split on Ice Bridge bsp change"); //default to off
settings.Add("b1start", true, "split on 1st Bridge start");
settings.Add("b1end", true, "split on 1st Bridge end");
settings.Add("b2start", true, "split on 2nd Bridge start");
settings.Add("b2end", true, "split on 2nd Bridge end");
settings.Add("lift", true, "split on elevator");
settings.Add("ghost", true, "split on Ghost");
settings.Add("gen2", true, "split on Gen 2 entry");
settings.Add("banshee2", true, "split on Banshee after gen2"); 
settings.Add("brokendoor", false, "split on broken door button"); //default to off
settings.Add("lastdoor", true, "split on last button door");

settings.Add("10xTB", false, "10x TB mode"); //default to off
settings.Add("10xTBmenu", false, "add menuing split in 10xTB"); //default to off


}

init
{
vars.indexoffset = 0;
vars.finalbsp = false;
vars.lastbsp = 0;
}

start 	//starts timer
{
vars.indexoffset = 0;
vars.finalbsp = false;
vars.lastbsp = 0;
return (current.cutsceneskip == 0 && old.cutsceneskip == 1 && current.levelname == "c40" && current.unpaused == true); 
}

split
{
//print("xpos is" + current.xpos);
//print("ypos is" + current.ypos);
int checkindex = timer.CurrentSplitIndex + vars.indexoffset;
print("checkindex is" + checkindex);
print("indexoffset is" +vars.indexoffset);
	switch (checkindex)
	{
		case 0: //split on 1st door button
		if (!(settings["door1"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.door1state == 4);
		break;
		
		case 1: //split on 3rd door button
		if (!(settings["door3"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.door3state == 4);
		break;

		case 2: //split on Banshee
		if (!(settings["banshee1"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.chiefstate != 2 && current.chiefstate == 2 && current.bspstate == 2); 
		break;
		
		case 3: //split on Gen 1's death
		if (!(settings["gen1"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.gen1state == 1);
		break;
		
		case 4: //split on Ice Bridge door
		if (!(settings["ibdoor"]))
		{
		vars.indexoffset++;
		break;
		}		
		return (old.bspstate != 10 && current.bspstate == 10);
		break;
		
		case 5: //split on 1st Bridge start
		if (!(settings["b1start"]))
		{
		vars.indexoffset++;
		break;
		}
		if (old.bspstate < 20)
		{
		vars.lastbsp = old.bspstate;
		}
		return (vars.lastbsp == 10 && current.bspstate == 1 && current.xpos > 275);
		break;
		
		case 6: //split on 1st Bridge end
		if (!(settings["b1end"]))
		{
		vars.indexoffset++;
		break;
		}
		if (old.bspstate < 20)
		{
		vars.lastbsp = old.bspstate;
		}
		return (vars.lastbsp == 1 && current.bspstate == 9 && current.xpos > 275 && current.ypos < -495);
		break;
		
		case 7: //split on 2nd Bridge start
		if (!(settings["b2start"]))
		{
		vars.indexoffset++;
		break;
		}
		if (old.bspstate < 20)
		{
		vars.lastbsp = old.bspstate;
		}
		return (vars.lastbsp == 9 && current.bspstate == 1 && current.xpos < 275 && current.ypos < -495);
		break;
		
		case 8: //split on 2nd Bridge end
		if (!(settings["b2end"]))
		{
		vars.indexoffset++;
		break;
		}
		if (old.bspstate < 20)
		{
		vars.lastbsp = old.bspstate;
		}
		return (vars.lastbsp == 1 && current.bspstate == 8 && current.xpos < 275);
		break;
		
		case 9: //split on elevator
		if (!(settings["lift"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.liftstate != 1065353216 && current.liftstate == 1065353216 && current.bspstate == 8);
		break;
		
		case 10: //split on Ghost
		if (!(settings["ghost"]))
		{
		vars.indexoffset++;
		break;
		}
		if (old.bspstate < 20 && old.bspstate != 1)
		{
		vars.lastbsp = old.bspstate;
		}
		return (old.chiefstate != 2 && current.chiefstate == 2 && vars.lastbsp == 8);
		break;
		
		case 11: //split on Gen 2 entry 
		if (!(settings["gen2"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.bspstate != 6 && current.bspstate == 6);
		break;
		
		case 12: //split on Banshee after gen
		if (!(settings["banshee2"]))
		{
		vars.indexoffset++;
		break;
		}
		if (old.bspstate < 20 && old.bspstate != 1)
		{
		vars.lastbsp = old.bspstate;
		}
		return (old.chiefstate != 2 && current.chiefstate == 2 && vars.lastbsp == 6);
		break;
		
		case 13: //split on broken door button
		if (!(settings["brokendoor"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.brokendoorstate == 1065353216);
		break;
		
		case 14: //split on last button door
		if (!(settings["lastdoor"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.lastdoorstate == 1065353216);
		break;
		
		case 15: //split on end (& check for 10xTB)
		if (vars.finalbsp == false && current.bspstate == 5)
		{
		vars.finalbsp = true;
		}
		
		if (vars.finalbsp == true && current.cutsceneskip == 1 && old.cutsceneskip == 0)
		{
			if (settings["10xTB"] && (settings["10xTBmenu"]))
			{
				vars.finalbsp = false;
				return true;
				break;
			}
			else if (settings["10xTB"] && !(settings["10xTBmenu"]))
			{
				vars.indexoffset = 0 - (timer.CurrentSplitIndex + 1) ; //I have a bad feeling about this
				vars.finalbsp = false;
				return true;
				break;
			}
			else
			{
				vars.indexoffset = 58008;
				vars.finalbsp = false;
				return true;
				break;
			}
		}
		else
		{
		return false;
		}
		break;
		
		case 16: //ONLY USED IN 10xTB MODE WITH MENUING
		if (!(settings["10xTB"] && (settings["10xTBmenu"])))
		{
		vars.indexoffset++;
		break;
		}
		if (current.cutsceneskip != 1 && current.tickcounter1 > 0 && current.tickcounter1 < 30 && current.levelname == "c40")
		{
			vars.indexoffset = 0 - (timer.CurrentSplitIndex + 1) ; //I have a bad feeling about this
			vars.finalbsp = false;
			return true;
			break;
		
		}
		break;
		
		
		default:	//shit's broke yo
		//print("shit's broke yo"); //probably 10xTB mode causing issues
		return false;
		break;
	}
}

reset
{
return (current.tickcounter1 < 30 && current.cutsceneskip == 1 && current.levelname == "c40" && !(settings["10xTB"]));
}