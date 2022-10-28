//Maw IL autosplitter (easy and leg)
//by Burnt
	
	
	//INSTALL INSTRUCTIONS
    //put this file anywhere you want
    //go to "Edit Layout" in livesplit
    //click the big plus sign
    //go to control > scriptable auto timer
    //double click the scriptable auto timer in your layout
    //browse the script path to wherever this .asl file is and load it
    //tick the splits you want to work, then add that amount to your splits + 1 (for level end)

	
	
state("halo") 
{
 	uint tickcounter: 0x2F1D8C; //pauses on pause menu, resets on reverts 
	byte bspstate: 0x29E8D8; //tracks which bsp is loaded
	byte chiefstate: 0x2AC5B4; //tracks whether chief in cutscene or vehicle maybe
	string3 levelname: 0x319780; //tracks which level is loaded
	float xpos: 0x2AC5BC; //chief camera x position - TODO: replace with actual x & y
	float ypos: 0x2AC5C0; //chief camera y position
	bool playerfrozen: 0x47A478, 0x11; //1 at maw ending, from fatalis' autosplitter 
	float firstdoor: 0x3FCA3D70; // only becomes 1.00 when fully open
	byte4 rockets: 0x3FC02C54; //0024001E on rockets
	byte cutsceneskip: 0x3FFFD67A; //true when cutscene is skippable
	byte cinematic: 0x3FFFD679; //true when cutscene is playing
}


startup //settings for which splits you want to use
{
settings.Add("firstdoor", false, "split on first door opening"); 
settings.Add("bsp1", true, "split on load into cafe"); 
settings.Add("cafetele", false, "split on cafetele"); 
settings.Add("bsp2", true, "split on load into cyro");  
settings.Add("bsp3", true, "split on load into hunters"); 
settings.Add("rockets", false, "split on armory rockets"); 
settings.Add("bsp4", true, "split on load into reactors"); 
settings.Add("doorkiss", true, "split on kissing reactor exit door");
settings.Add("bsp5", false, "split on load into hogrun");
settings.Add("hog", false, "split on entering hog");  
settings.Add("sec1", false, "split after 1st hog sec");  
settings.Add("sec2", false, "split after 2nd hog sec");  
settings.Add("bsp6", false, "split on bsp 6"); 
settings.Add("bsp7", true, "split on load into waitstop"); 
settings.Add("360", false, "split just before 360");  
settings.Add("barrels", true, "split just before barrels");  




}

init
{
vars.indexoffset = 0;
}

start 	//starts timer
{
vars.indexoffset = 0;
return (current.cutsceneskip == 0 && old.cutsceneskip == 1 && current.levelname == "d40" && current.tickcounter < 100); 
}

split
{
//print (""+current.ending);
int checkindex = timer.CurrentSplitIndex + vars.indexoffset;

	switch (checkindex)
	{
	
		case 0: //split on first door opening
		if (!(settings["firstdoor"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.firstdoor == 1.00 && old.firstdoor != 1.00);
		break;
	
	
		case 1: //split on bsp 1
		if (!(settings["bsp1"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.bspstate != 1 && current.bspstate == 1);
		break;
				
				
		case 2: //split on cafe tele
		if (!(settings["cafetele"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.ypos > 6 && current.ypos < 6); //ie tele went at least 8 units (1st door tele is around 13 units)
		break;
		
		
		case 3: //split on bsp 2
		if (!(settings["bsp2"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.bspstate != 2 && current.bspstate == 2);
		break;
		
		case 4: //split on bsp 3
		if (!(settings["bsp3"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.bspstate != 3 && current.bspstate == 3);
		break;
		
		case 5: //split on picking up rockets from armory
		if (!(settings["rockets"]))
		{
		vars.indexoffset++;
		break;
		}
		//print ("rockets: "+ BitConverter.ToString(current.rockets));
		return (BitConverter.ToString(current.rockets) == "1E-00-24-00" && BitConverter.ToString(old.rockets) != "1E-00-24-00");
		break;
		
		case 6: //split on bsp 4
		if (!(settings["bsp4"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.bspstate != 4 && current.bspstate == 4);
		break;
		
		case 7: //split on kissing door after reactors
		if (!(settings["doorkiss"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.xpos < -109.3 && old.xpos > -109.3);
		break;
		
		case 8: //split on bsp 5
		if (!(settings["bsp5"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.bspstate != 5 && current.bspstate == 5);
		break;
		
		

		
		
		case 9: //split on entering hog
		if (!(settings["hog"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.chiefstate != 2 && current.chiefstate == 2);
		break;
			
		case 10: //after 1st hog section
		if (!(settings["sec1"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.xpos < 76 && current.xpos >= 76);
		break;
		
		case 11: //after 2nd hog section
		if (!(settings["sec2"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.xpos < 192 && current.xpos >= 192);
		break;
		
		case 12: //split on bsp 6
		if (!(settings["bsp6"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.bspstate != 6 && current.bspstate == 6);
		break; 
		
		case 13: //split on bsp 7
		if (!(settings["bsp7"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.bspstate != 7 && current.bspstate == 7);
		break;
		
		case 14: //before 360
		if (!(settings["360"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.xpos < 871 && current.xpos >= 871);
		break;
		
		case 15: //before barrels
		if (!(settings["barrels"]))
		{
		vars.indexoffset++;
		break;
		}
		return (old.xpos < 995 && current.xpos >= 995);
		break;
		
		case 16: //split on ending
		return (current.bspstate == 7 && current.cinematic == 1 && old.cinematic == 0);
		break;
		
		
		default:	//shit's broke yo
		//print("shit's broke yo"); 
		return false;
		break;
	}
}

reset
{
return (current.tickcounter < 50 && current.playerfrozen == true && current.levelname == "d40");
}