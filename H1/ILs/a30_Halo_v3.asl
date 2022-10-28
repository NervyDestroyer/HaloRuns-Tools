//Halo IL autosplitter (easy and leg)
//by Burnt & Wackee
	
state("halo") 
{
	uint tickcounter1: 0x2F1D8C; //pauses on pause menu, resets on reverts 
	byte bspstate: 0x29E8D8; //tracks which bsp is loaded
	uint levelname: 0x2A8174; //tracks which level is loaded
	float xpos: 0x2AC5BC; //chief camera x position
	float ypos: 0x2AC5C0; //chief camera y position
	byte fade: 0x3FF1581A; //0 if not 1 if fading
	byte cutsceneskip: 0x3FFFD67A; //true when cutscene is skippable
	byte letterbox: 0x3FFFD678; //true when letterbox is showing

	byte mission_first: 0x3FFE1806; //
	byte first_welcome: 0x3FFE17FC; //Not a mission, it's ai_conversation first_welcome; we need it for timing the difference
	byte mission_first_wave_2: 0x3FFE0908; //
	byte mission_first_wave_6: 0x3FFE1168; //
	byte echo419: 0x3FFE1812; //Not mission, ai_conversation first_evac_1
	byte NF: 0x3FFE1613; // Not mission, ai_conversation cave_entrance
	float bridge_button: 0x3FC26C14; //(sleep_until (< 0 (device_group_get bridge_control_position ))1 )
	byte reunion_tour: 0x3FFE288D; // upon wake mission_cliff
	byte cliff_abandon: 0x3FFE1E04; // upon wake obj_cliff_abandon; starts as you enter cliff
	byte cliff_end: 0x3FFE1EAD; //Not mission, when global cliff_end is true?
	byte rubble_abandon: 0x3FFE3FDF; // upon wake obj_rubble_abandon; as you enter rubble
	//byte rubble_end: 0x; // Not mission, global_rubble_end true? --- use xyz
	byte river_marine: 0x3FFE45EB; // upon wake mission_river_marine
	byte river_spirit: 0x3FFE5044; //upon wake mission_river_wave_3
	byte river_extraction: 0x3FFDF424; // upon wake mission_extraction_river

	byte unpaused: 0x286A98;
	byte chiefstate: 0x2AC5B4; //tracks if chief in vehi or cutscene
}

startup //settings for which splits you want to use
{
settings.Add("Pre-Marines", true, "split on first encounter");
settings.Add("Welcome", true, "split on marines' welcome");
settings.Add("Free ship", true, "split on mission_first_wave_2");
settings.Add("Last Ship", true, "split on mission_first_wave_6");
settings.Add("Echo419", true, "split on Foehammer chiming in");
settings.Add("Warthog", true, "split upon entering the hog");
settings.Add("NF", true, "split on NF");
settings.Add("Bridge Button", true, "split upon activating the bridge button");
settings.Add("Reunion", true, "split upon reunion tour");
settings.Add("Cliff Start", true, "split on entering Cliff");
settings.Add("Cliff End", true, "split on all marines saved");
settings.Add("Rubble Start", true, "split upon entering Rubble");
settings.Add("Rubble End", true, "split on all marines saved");
settings.Add("River Start", true, "split on entering River");
settings.Add("River Spirit", true, "split on mission_river_wave_3?");
settings.Add("Last of them", true, "split on 'That's the last of 'em'");
}

init
{
vars.indexoffset = 0;
}

start 	//starts timer
{
vars.indexoffset = 0;
return (current.letterbox == 0 && old.letterbox == 1 && current.tickcounter1 < 190 && current.levelname == 3158881 && current.unpaused == 1 && current.cutsceneskip == 0); //starts timer on specific tick that chief hits the ground
}

split
{
int checkindex = timer.CurrentSplitIndex + vars.indexoffset;
	switch (checkindex)
	{
		case 0:
		if (!(settings["Pre-Marines"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.mission_first == 255);
		break;
		
		case 1:
		if (!(settings["Welcome"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.first_welcome == 11 && old.first_welcome == 218);
		break;
		
		case 2:
		if (!(settings["Free ship"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.mission_first_wave_2 == 14);
		break;
		
		case 3: 
		if (!(settings["Last Ship"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.mission_first_wave_6 == 110);
		break;
		
		case 4:
		if (!(settings["Echo419"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.echo419 == 64);
		break;
		
		case 5:
		if (!(settings["Warthog"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.chiefstate == 2 && old.chiefstate != 2);
		break;

		case 6:
		if (!(settings["NF"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.NF == 64);
		break;
		
		case 7: 
		if (!(settings["Bridge Button"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.bridge_button == 1);
		break;
		
		case 8: 
		if (!(settings["Reunion"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.reunion_tour == 145);
		break;
		
		case 9:
		if (!(settings["Cliff Start"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.cliff_abandon == 240);
		break;
		
		case 10:
		if (!(settings["Cliff End"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.cliff_end == 28);
		break;
		
		case 11:
		if (!(settings["Rubble Start"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.xpos >= -426 & current.xpos <= -408 && current.ypos >= 137 && current.ypos <= 150);
		break;
		
		case 12:
		if (!(settings["Rubble End"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.ypos <= 180 && current.xpos <= -426 && current.ypos >= 150);
		break;
		
		case 13:
		if (!(settings["River Start"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.river_marine == 157);
		break;
		
		case 14:
		if (!(settings["River Spirit"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.river_spirit == 48);
		break;
		
		case 15:
		if (!(settings["Last of them"]))
		{
		vars.indexoffset++;
		break;
		}
		return (current.river_extraction == 16);
		break;
		
		default:	//splits on level end
		return (old.cutsceneskip == 0 && current.cutsceneskip == 1 && current.bspstate == 1);
		break;
	}
}
reset
{
return (current.tickcounter1 < 180 && current.levelname == 3158881 && current.unpaused == 1);
}