env.info("Mission Loading", false)

--////VARIABLES

USAEFCAPGROUPNAME = ""
USAEFSEADGROUPNAME = ""
USAEFCASGROUPNAME = ""
USAEFASSGROUPNAME = ""
USAEFPINGROUPNAME = ""
USAEFDRONEGROUPNAME = ""
USAFAWACSGROUPNAME = ""
TEXACOGROUPNAME = ""
SHELLGROUPNAME = ""
ARCOGROUPNAME = ""

--[[
--////MISSION LOGIC FUNCTIONS
function SEF_MissionSelector()	
	
	if ( NumberOfCompletedMissions >= TotalScenarios ) then
			
		OperationComplete = true
		trigger.action.outText("Operation Scarlet Dawn - Operation Has Been Successful", 60)
		--WRITE PROGRESS TABLES TO EMPTY AND SAVE WITH NO ARGUMENTS
		ScarletDawnUnitInterment = {}
		SEF_SaveUnitIntermentTableNoArgs()
		ScarletDawnStaticInterment = {}
		SEF_SaveStaticIntermentTableNoArgs()
		SyriaAirbases = {}
		SEF_SaveAirbasesTableNoArgs()
		--VICTORY -- SET FLAG FOR MISSION EDITOR TRIGGER RESTART
		trigger.action.setUserFlag(1337,1)
		--trigger.action.outText("Operation Scarlet Dawn - Server Will Restart In 5 Minutes", 60)
	else
		Randomiser = math.random(1,TotalScenarios)
		if ( trigger.misc.getUserFlag(Randomiser) > 0 ) then
			--SELECTED MISSION [Randomiser] ALREADY DONE, FLAG VALUE >=1, SELECT ANOTHER ONE
			SEF_MissionSelector()
		elseif ( trigger.misc.getUserFlag(Randomiser) == 0 ) then
			--SELECTED MISSION [Randomiser] IS AVAILABLE TO START, SET TO STARTED AND VALIDATE
			trigger.action.setUserFlag(Randomiser,1)
			SEF_RetrieveMissionInformation(Randomiser)
			--trigger.action.outText("Validating Mission Number "..Randomiser.." For Targeting", 15)
			SEF_ValidateMission()										
		else
			trigger.action.outText("Mission Selection Error", 15)
		end
	end		
end

function SEF_RetrieveMissionInformation ( MissionNumber )
	
	--SET GLOBAL VARIABLES TO THE SELECTED MISSION
	ScenarioNumber = MissionNumber
	AGMissionTarget = OperationScarletDawn_AG[MissionNumber].TargetName
	AGTargetTypeStatic = OperationScarletDawn_AG[MissionNumber].TargetStatic
	AGMissionBriefingText = OperationScarletDawn_AG[MissionNumber].TargetBriefing		
end

function SEF_ValidateMission()
	
	--CHECK TARGET TO SEE IF IT IS ALIVE OR NOT
	if ( AGTargetTypeStatic == false and AGMissionTarget ~= nil ) then
		--TARGET IS NOT STATIC					
		if ( GROUP:FindByName(AGMissionTarget):IsAlive() == true ) then
			--GROUP VALID
			if ( CustomSoundsEnabled == 1) then
				trigger.action.outSound('That Is Our Target.ogg')
			else
			end
			trigger.action.outText(AGMissionBriefingText,15)			
		elseif ( GROUP:FindByName(AGMissionTarget):IsAlive() == false or GROUP:FindByName(AGMissionTarget):IsAlive() == nil ) then
			--GROUP NOT VALID
			trigger.action.setUserFlag(ScenarioNumber,4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1
			AGMissionTarget = nil
			AGMissionBriefingText = nil
			SEF_MissionSelector()						
		else			
			trigger.action.outText("Mission Validation Error - Unexpected Result In Group Size", 15)						
		end		
	elseif ( AGTargetTypeStatic == true and AGMissionTarget ~= nil ) then		
		--TARGET IS STATIC		
		if ( StaticObject.getByName(AGMissionTarget) ~= nil and StaticObject.getByName(AGMissionTarget):isExist() == true ) then
			--STATIC IS VALID
			if ( CustomSoundsEnabled == 1) then
				trigger.action.outSound('That Is Our Target.ogg')
			else
			end	
			trigger.action.outText(AGMissionBriefingText,15)								
		elseif ( StaticObject.getByName(AGMissionTarget) == nil or StaticObject.getByName(AGMissionTarget):isExist() == false ) then
			--STATIC TARGET NOT VALID, ASSUME TARGET ALREADY DESTROYED			
			trigger.action.setUserFlag(ScenarioNumber,4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1	
			AGMissionTarget = nil
			AGMissionBriefingText = nil
			SEF_MissionSelector()
		else
			trigger.action.outText("Mission Validation Error - Unexpected Result In Static Test", 15)	
		end		
	elseif ( OperationComplete == true ) then
		trigger.action.outText("The Operation Is Complete - No Further Targets To Validate For Mission Assignment", 15)
	else		
		trigger.action.outText("Mission Validation Error - Mission Validation Unavailable, No Valid Targets", 15)
	end
end

function SEF_SkipScenario()	
	--CHECK MISSION IS NOT SUDDENLY FLAGGED AS STATE 4 (COMPLETED)
	if ( trigger.misc.getUserFlag(ScenarioNumber) >= 1 and trigger.misc.getUserFlag(ScenarioNumber) <= 3 ) then
		--RESET MISSION TO STATE 0 (NOT STARTED), CLEAR TARGET INFORMATION AND REROLL A NEW MISSION
		trigger.action.setUserFlag(ScenarioNumber,0) 
		AGMissionTarget = nil
		AGMissionBriefingText = nil
		SEF_MissionSelector()
	elseif ( OperationComplete == true ) then
		trigger.action.outText("The Operation Has Been Completed, All Objectives Have Been Met", 15)
	else		
		trigger.action.outText("Unable To Skip As Current Mission Is In A Completion State", 15)
	end
end

function MissionSuccess()
	
	--SET GLOBALS TO NIL
	AGMissionTarget = nil
	AGMissionBriefingText = nil
	
	if ( CustomSoundsEnabled == 1) then
		local RandomMissionSuccessSound = math.random(1,5)
		trigger.action.outSound('AG Kill ' .. RandomMissionSuccessSound .. '.ogg')
	else
	end	
end

function SEF_MissionTargetStatus(TimeLoop, time)

	if (AGTargetTypeStatic == false and AGMissionTarget ~= nil) then
		--TARGET IS NOT STATIC
					
		if (GROUP:FindByName(AGMissionTarget):IsAlive() == true) then
			--GROUP STILL ALIVE
						
			return time + 10			
		elseif (GROUP:FindByName(AGMissionTarget):IsAlive() == false or GROUP:FindByName(AGMissionTarget):IsAlive() == nil) then 
			--GROUP DEAD
			trigger.action.outText("Mission Update - Mission Successful", 15)
			trigger.action.setUserFlag(ScenarioNumber,4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1
			MissionSuccess()
			timer.scheduleFunction(SEF_MissionSelector, {}, timer.getTime() + 20)
			
			return time + 30			
		else			
			trigger.action.outText("Mission Target Status - Unexpected Result, Monitor Has Stopped", 15)						
		end		
	elseif (AGTargetTypeStatic == true and AGMissionTarget ~= nil) then
		--TARGET IS STATIC
		if ( StaticObject.getByName(AGMissionTarget) ~= nil and StaticObject.getByName(AGMissionTarget):isExist() == true ) then 
			--STATIC ALIVE
			
			return time + 10				
		else				
			--STATIC DESTROYED
			trigger.action.outText("Mission Update - Mission Successful", 15)
			trigger.action.setUserFlag(ScenarioNumber,4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1
			MissionSuccess()
			timer.scheduleFunction(SEF_MissionSelector, {}, timer.getTime() + 20)
			
			return time + 30				
		end		
	else		
		return time + 10
	end	
end

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////MISSION TARGET TABLE

function SEF_InitializeMissionTable()
	
	OperationScarletDawn_AG = {}	
	
	--////EWR
	OperationScarletDawn_AG[1] = {				
		TargetName = "Aleppo - EWR",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Early Warning Radar At Aleppo\nAleppo Sector - Grid CA40",
	}
	OperationScarletDawn_AG[2] = {				
		TargetName = "EWR-Al Bab",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Early Warning Radar At Al Bab\nAleppo Sector - Grid CA52",
	}
	OperationScarletDawn_AG[3] = {				
		TargetName = "EWR - Dar Ta'izzah",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Early Warning Radar At Dar Ta'izzah\nAleppo Sector - Grid CA01",
	}
	OperationScarletDawn_AG[4] = {				
		TargetName = "EWR - Idlib",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Early Warning Radar North-West Of Idlib\nIdlib Sector - Grid BV79",
	}
	OperationScarletDawn_AG[5] = {				
		TargetName = "EWR - Tabqa",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Early Warning Radar At Tabqa Airfield\nTabqa Sector - Grid DV65",
	}	
	OperationScarletDawn_AG[6] = {				
		TargetName = "Qaranjah - EWR South",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Early Warning Radar At Qaranjah\nLatakia Sector - Grid YE56",
	}
	OperationScarletDawn_AG[7] = {				
		TargetName = "EWR - Sett Markho",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Early Warning Radar At Sett Markho\nLatakia Sector - Grid YE54",
	}
	OperationScarletDawn_AG[8] = {				
		TargetName = "EWR - Baniyas",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Early Warning Radar At Baniyas\nBaniyas Sector - Grid YD79",
	}
	OperationScarletDawn_AG[9] = {				
		TargetName = "EWR - Tartus - East",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Early Warning Radar At Tartus\nTartus Sector - Grid YD76",
	}
	OperationScarletDawn_AG[10] = {				
		TargetName = "EWR - Homs",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Early Warning Radar At Homs\nHoms Sector - Grid BU93",
	}
	OperationScarletDawn_AG[11] = {				
		TargetName = "EWR - Hama",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Early Warning Radar At Hama\nHama Sector - Grid BU97",
	}
 	OperationScarletDawn_AG[12] = {				
		TargetName = "Palmyra - EWR",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Early Warning Radar At Palmyra\nPalmyra Sector - Grid DU32",
	}			
 	OperationScarletDawn_AG[13] = {				
		TargetName = "EWR - Busra",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Early Warning Radar At Busra\nGolan Heights Sector - Grid BS53",
	}					
 	OperationScarletDawn_AG[14] = {				
		TargetName = "EWR - Marj Ruhayyil",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Early Warning Radar At Marj Ruhayyil\nDamascus Sector - Grid BS58",
	}					
 	OperationScarletDawn_AG[15] = {				
		TargetName = "EWR - Damascus - South",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Southern Early Warning Radar At Damascus\nDamascus Sector - Grid BS49",
	}				
 	OperationScarletDawn_AG[16] = {				
		TargetName = "EWR - Damascus - North",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Northern Early Warning Radar At Damascus\nDamascus Sector - Grid BT41",
	}						
 	OperationScarletDawn_AG[17] = {				
		TargetName = "EWR - Damascus - East",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Eastern Early Warning Radar At Damascus\nDamascus Sector - Grid BT60",
	}						
 	OperationScarletDawn_AG[18] = {				
		TargetName = "Al Dumayr - EWR North",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Northern Early Warning Radar At Al-Dumayr\nDuma Sector - Grid BT92",
	}					
 	OperationScarletDawn_AG[19] = {				
		TargetName = "Al Dumayr - EWR South",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Southern Early Warning Radar At Al-Dumayr\nDuma Sector - Grid BT92",
	}					
 	OperationScarletDawn_AG[20] = {				
		TargetName = "EWR - Al Dumayr - West",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Western Early Warning Radar At Al-Dumayr\nDuma Sector - Grid BT71",
	} 				
 	--////SA-5 SITES			
	OperationScarletDawn_AG[21] = {				
		TargetName = "SAM-SA5 - Damascus",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-5 Site At Damascus\nDamascus Sector - Grid BT81",
	}
	OperationScarletDawn_AG[22] = {				
		TargetName = "SAM-SA5 - Khalkhalah",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-5 Site At Khalkhalah\nKhalkhalah Sector - Grid BS77",
	}
	OperationScarletDawn_AG[23] = {				
		TargetName = "SAM-SA5 - Homs",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-5 Site At Homs\nHoms Sector - Grid BU93",
	}
	OperationScarletDawn_AG[24] = {				
		TargetName = "SAM-SA5 - Masyaf",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-5 Site At Masyaf\nMasyaf Sector - Grid BU59",
	}
	--////SA-2 SITES
	OperationScarletDawn_AG[25] = {				
		TargetName = "SAM-SA2 - Al Safirah",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-2 Site At Al Safirah\nAleppo Sector - Grid CV59",
	}	
	OperationScarletDawn_AG[26] = {				
		TargetName = "SAM-SA2 - Latakia - North",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-2 Site North Of Latakia\nLatakia Sector - Grid YE55",
	}
	OperationScarletDawn_AG[27] = {				
		TargetName = "SAM-SA2 - Bassel Al-Assad",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-2 Site At Bassel Al-Assad Airbase\nBassel Al-Assad Sector - Grid YE62",
	}
	OperationScarletDawn_AG[28] = {				
		TargetName = "SAM-SA2 - Tartus - South",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-2 Site At Tartus\nTartus Sector - Grid YD65",
	}
	OperationScarletDawn_AG[29] = {				
		TargetName = "SAM-SA2 - Hama - North-West",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-2 Site North-West Of Hama\nHama Sector - Grid BU89",
	}
	OperationScarletDawn_AG[30] = {				
		TargetName = "SAM-SA2 - Homs - West",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-2 Site West Of Homs\nHoms Sector - Grid BU74",
	}
	OperationScarletDawn_AG[31] = {				
		TargetName = "SAM-SA2 - Khirbet Ghazaleh - North",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-2 Site North Of Khirbet Ghazaleh\nGolan Heights Sector - Grid BS33",
	}
	OperationScarletDawn_AG[32] = {				
		TargetName = "Al Dumayr - SA-2 East 1",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-2 Site East Of Al-Dumayr\nDuma Sector - Grid CT02",
	}
	OperationScarletDawn_AG[33] = {				
		TargetName = "SAM-SA2 - Damascus",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-2 Site At Damascus\nDamascus Sector - Grid BT60",
	}
	OperationScarletDawn_AG[34] = {				
		TargetName = "SAM-SA2 - Mezzeh - West",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-2 Site West Of Mezzeh Airbase\nMezzeh Sector - Grid BS39",
	} 				
 	--////SA-3 SITES			
	OperationScarletDawn_AG[35] = {				
		TargetName = "SAM-SA3- Latakia - South-East",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-3 Site South-East Of Latakia\nLatakia Sector - Grid YE53",
	} 
	OperationScarletDawn_AG[36] = {				
		TargetName = "SAM-SA3 - Bassel Al-Assad",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-3 Site At Bassel Al-Assad Airbase\nBassel Al-Assad Sector - Grid YE62",
	} 
	OperationScarletDawn_AG[37] = {				
		TargetName = "SAM-SA3 - Tartus - South-East",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-3 Site South-East Of Tartus\nTartus Sector - Grid YD76",
	} 
	OperationScarletDawn_AG[38] = {				
		TargetName = "SAM-SA3 - Homs - East",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-3 Site East Of Homs\nHoms Sector - Grid BU94",
	}
	OperationScarletDawn_AG[39] = {				
		TargetName = "SAM-SA3 - Hama - North-East",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-3 Site North-East Of Hama\nHama Sector - Grid CV01",
	}
	OperationScarletDawn_AG[40] = {				
		TargetName = "SAM-SA3 - Aleppo - East",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-3 Site East Of Aleppo\nAleppo Sector - Grid CA60",
	}
	OperationScarletDawn_AG[41] = {				
		TargetName = "SAM-SA3 - El Hajar Al Aswad",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-3 Site East At El Hajar Al Aswad\nDamascus Sector - Grid BT50",
	}
 	OperationScarletDawn_AG[42] = {				
		TargetName = "SAM-SA3 - Hayjanah",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-3 Site At Hayjanah\nDamascus Sector - Grid BS79",
	}			
	OperationScarletDawn_AG[43] = {				
		TargetName = "Al Dumayr - SA-3 South",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-3 Site South Of Al-Dumayr\nDuma Sector - Grid BT91",
	}
	OperationScarletDawn_AG[44] = {				
		TargetName = "SAM-SA3 - Jasim - South-East",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-3 Site South-East Of Jasim\nGolan Heights Sector - Grid BS34",
	}	
	--////SA-6 SITES
	OperationScarletDawn_AG[45] = {				
		TargetName = "SAM-SA6 - Homs - South",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-6 Site South Of Homs\nHoms Sector - Grid BU93",
	}
	OperationScarletDawn_AG[46] = {				
		TargetName = "SAM-SA6 - Hama - South",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-6 Site South Of Hama\nHama Sector - Grid BU98",
	}
	OperationScarletDawn_AG[47] = {				
		TargetName = "SAM-SA6 - Mezzeh - South-West",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-6 Site South-West Of Mezzeh Airbase\nMezzeh Sector - Grid BS39",
	}
	OperationScarletDawn_AG[48] = {				
		TargetName = "SAM-SA6 - Otaybah - North",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-6 Site North Of Otaybah\nDamascus Sector - Grid BT71",
	}
	OperationScarletDawn_AG[49] = {				
		TargetName = "SAM-SA-6 - Otaybah - South-East",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-6 Site South-East Of Otaybah\nDamascus Sector - Grid BT80",
	}
	OperationScarletDawn_AG[50] = {				
		TargetName = "SAM-SA6 - Kanaker - East",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-6 Site East Of Kanaker\nDamascus Sector - Grid BS38",
	}
	OperationScarletDawn_AG[51] = {				
		TargetName = "SAM-SA6 - Izra - East",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-6 Site East Of Izra\nGolan Heights Sector - Grid BS43",
	}
	OperationScarletDawn_AG[52] = {				
		TargetName = "SAM-SA6 - Izra - West",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-6 Site West Of Izra\nGolan Heights Sector - Grid BS43",
	}
	--////SA-8 SITES
	OperationScarletDawn_AG[53] = {				
		TargetName = "SAM-SA6 - Al Qutayfah",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-6 At Al Qutayfah\nAn Nasiriyah Sector - Grid BT83",
	}
	OperationScarletDawn_AG[54] = {				
		TargetName = "SAM-SA8 - Damascus",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-8 At Damascus\nDamascus Sector - Grid BT41",
	}
	OperationScarletDawn_AG[55] = {				
		TargetName = "SAM-SA8 - Mezzeh",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-8 At Mezzeh Airbase\nMezzeh Sector - Grid BT40",
	}	
	OperationScarletDawn_AG[56] = {				
		TargetName = "SAM-SA8 - Latakia",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-8 North Of Latakia\nLatakia Sector - Grid YE55",
	}
	--////SA-13 SITES
	OperationScarletDawn_AG[57] = {				
		TargetName = "SAM-SA13 - An Nasiriyah",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-13 At An Nasiriyah\nAn Nasiriyah Sector - Grid CT05",
	}
	OperationScarletDawn_AG[58] = {				
		TargetName = "SAM-SA13 - Khalkhalah",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-13 At Khalkhalah\nKhalkhalah Sector - Grid BS76",
	}	
	--////SHIPPING
	OperationScarletDawn_AG[59] = {				
		TargetName = "Latakia - Navy",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Naval Warships Patrolling Near Latakia\nLatakia Sector - Grid YE",
	}
	OperationScarletDawn_AG[60] = {				
		TargetName = "Tartus - Navy",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Naval Warships Patrolling Near Tartus\nTartus Sector - Grid YE/YD",
	}
	OperationScarletDawn_AG[61] = {				
		TargetName = "Latakia - Speedboat",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Armed Speedboats At Latakia\nLatakia Sector - Grid YE43/53",
	}
	OperationScarletDawn_AG[62] = {				
		TargetName = "Tartus - Speedboat",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Armed Speedboats At Tartus\nTartus Sector - Grid YD66",
	}
	OperationScarletDawn_AG[63] = {				
		TargetName = "Latakia - Cargo Ship",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Cargo Ships At Latakia\nLatakia Sector - Grid YE53",
	}
	OperationScarletDawn_AG[64] = {				
		TargetName = "Tartus - Cargo Ship",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Cargo Ships At Tartus\nTartus Sector - Grid YD66",
	}
	--////COMMS TOWERS
	OperationScarletDawn_AG[65] = {				
		TargetName = "Aleppo - Communications",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Communications Tower At Aleppo\nAleppo Sector - Grid CA30",
	}	
	OperationScarletDawn_AG[66] = {				
		TargetName = "Latakia - Communications",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Communications Tower At Latakia\nLatakia Sector - Grid YE53",
	}
	OperationScarletDawn_AG[67] = {				
		TargetName = "Tartus - Communications",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Communications Tower At Tartus\nTartus Sector - Grid YD66",
	}
	OperationScarletDawn_AG[68] = {				
		TargetName = "Homs - Communications",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Communications Tower At Homs\nHoms Sector - Grid BU84",
	}
	OperationScarletDawn_AG[69] = {				
		TargetName = "Hama - Communications",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Communications Tower At Hama\nHama Sector - Grid BU96",
	}
	OperationScarletDawn_AG[70] = {				
		TargetName = "Damascus - Communications West",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Western Communications Tower At Damascus\nDamascus Sector - Grid BT41",
	}
	OperationScarletDawn_AG[71] = {				
		TargetName = "Damascus - Communications East",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Eastern Communications Tower At Damascus\nDamascus Sector - Grid BT60",
	}
	OperationScarletDawn_AG[72] = {				
		TargetName = "Golan Heights - Communications",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Communications Tower Near The Golan Heights\nGolan Heights Sector - Grid YB65",
	}
	--////AAA
	OperationScarletDawn_AG[73] = {				
		TargetName = "AAA - Aleppo",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy AAA Assets At Aleppo\nAleppo Sector - Grid CA20/21/30/31",
	}
	OperationScarletDawn_AG[74] = {				
		TargetName = "AAA - Al Safira",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy AAA Assets At Al Safira\nAleppo Sector - Grid CV49/59",
	}
	OperationScarletDawn_AG[75] = {				
		TargetName = "AAA - Latakia",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy AAA Assets At Latakia\nLatakia Sector - Grid YE43/53",
	}
	OperationScarletDawn_AG[76] = {				
		TargetName = "Latakia - AAA",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy AAA Assets At Tartus\nTartus Sector - Grid YD66",
	}
	OperationScarletDawn_AG[77] = {				
		TargetName = "AAA - Homs",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy AAA Assets At Homs\nHoms Sector - Grid BU84/94",
	}
	OperationScarletDawn_AG[78] = {				
		TargetName = "AAA - Homs - South",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy AAA Assets South Of Homs\nHoms Sector - Grid BU93",
	}
	OperationScarletDawn_AG[79] = {				
		TargetName = "AAA - Hama",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy AAA Assets At Hama\nHama Sector - Grid BU89/98/99",
	}
	OperationScarletDawn_AG[80] = {				
		TargetName = "AAA - Mezzeh",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy AAA Assets At Mezzeh\nMezzeh Sector - Grid BS39/49/BT40/50",
	}
	OperationScarletDawn_AG[81] = {				
		TargetName = "AAA - Damascus",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy AAA Assets At Damascus\nDamascus Sector - Grid BT41/50/60",
	}
	OperationScarletDawn_AG[82] = {				
		TargetName = "AAA - Al Dumayr",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy AAA Assets At Al Dumayr\nDuma Sector - Grid BT81/91",
	}
	OperationScarletDawn_AG[83] = {				
		TargetName = "AAA - Golan Heights",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy AAA Assets At The Golan Heights\nGolan Heights Sector - Grid BS33/34/43",
	}
	OperationScarletDawn_AG[84] = {				
		TargetName = "AAA - Bassel Al-Assad",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy AAA Assets At Bassel Al-Assad\nBassel Al-Assad Sector - Grid YE62",
	}
	OperationScarletDawn_AG[85] = {				
		TargetName = "AAA - Khalkhalah",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy AAA Assets At Khalkhalah\nKhalkhalah Sector - Grid BS76",
	}
	--////ARMOR
	OperationScarletDawn_AG[86] = {				
		TargetName = "Armor - Aleppo",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Armored Vehicles At Aleppo\nAleppo Sector - Grid CA20/31/40",
	}
	OperationScarletDawn_AG[87] = {				
		TargetName = "Armor - Latakia",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Armored Vehicles At Latakia\nLatakia Sector - Grid YE53",
	}
	OperationScarletDawn_AG[88] = {				
		TargetName = "Armor - Tartus",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Armored Vehicles At Tartus\nTartus Sector - Grid YD66",
	}
	OperationScarletDawn_AG[89] = {				
		TargetName = "Armor - Homs",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Armored Vehicles At Homs\nHoms Sector - Grid BU74/94",
	}
	OperationScarletDawn_AG[90] = {				
		TargetName = "Armor - Homs - South",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Armored Vehicles South Of Homs\nHoms Sector - Grid BU93",
	}
	OperationScarletDawn_AG[91] = {				
		TargetName = "Armor - Hama",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Armored Vehicles At Hama\nHama Sector - Grid BU89/98/99",
	}
	OperationScarletDawn_AG[92] = {				
		TargetName = "Armor - Mezzeh",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Armored Vehicles At Mezzeh\nMezzeh Sector - Grid BT30",
	}
	OperationScarletDawn_AG[93] = {				
		TargetName = "Armor - Al Dumayr",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Armored Vehicles At Al Dumayr\nDuma Sector - Grid BT82",
	}
	OperationScarletDawn_AG[94] = {				
		TargetName = "Armor - Damascus",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Armored Vehicles At Damascus\nDamascus Sector - Grid BS49/59",
	}
	OperationScarletDawn_AG[95] = {				
		TargetName = "Khirbet Ghazaleh - Armor",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Armored Vehicles At Khirbet Ghazaleh\nGolan Heights Sector - Grid BS32",
	}
	--////ARTILLERY AND Missiles
	OperationScarletDawn_AG[96] = {				
		TargetName = "Silkworm - Latakia",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Silkworm Site At Latakia\nLatakia Sector - Grid YE43/53",
	}
	OperationScarletDawn_AG[97] = {				
		TargetName = "Silkworm - Tartus",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Silkworm Site At Tartus\nTartus Sector - Grid YD67",
	}	
	OperationScarletDawn_AG[98] = {				
		TargetName = "Scud Launcher - Mezzeh",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Scud Launchers At The Artillery Base Near Mezzeh\nMezzeh Sector - Grid BT30",
	}
	OperationScarletDawn_AG[99] = {				
		TargetName = "Artillery - Homs",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy Artillery Assets At Homs\nHoms Sector - Grid BU93",
	}
	OperationScarletDawn_AG[100] = {				
		TargetName = "Artillery - Hama",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy Artillery Assets At Hama\nHama Sector - Grid BU98",
	}
	OperationScarletDawn_AG[101] = {				
		TargetName = "Artillery - Aleppo",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy Artillery Assets At Aleppo\nAleppo Sector - Grid CA40",
	}
	OperationScarletDawn_AG[102] = {				
		TargetName = "Izra - Scud Launcher",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Scud Launchers At Izra\nGolan Heights Sector - Grid BS43",
	}
	OperationScarletDawn_AG[103] = {				
		TargetName = "Artillery - Al Dumayr",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy Artillery Assets At Al-Dumayr\nDuma Sector - Grid BT92",
	}
	--////Statics
	OperationScarletDawn_AG[104] = {				
		TargetName = "Al Safirah - Barracks",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Military Barracks At Al Safirah\nAleppo Sector - Grid CV59",
	}
	OperationScarletDawn_AG[105] = {				
		TargetName = "Al Safirah - Research Hangar",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Research Hangar At Al Safirah\nAleppo Sector - Grid CV58",
	}
	OperationScarletDawn_AG[106] = {				
		TargetName = "Latakia - Naval Warehouse",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Naval Warehouse At Latakia\nLatakia Sector - Grid YE53",
	}
	OperationScarletDawn_AG[107] = {				
		TargetName = "Tartus - Naval Warehouse",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Naval Warehouse At Tartus\nTartus Sector - Grid YD66",
	}
	OperationScarletDawn_AG[108] = {				
		TargetName = "Homs - Military HQ",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Military HQ At Homs\nHoms Sector - Grid BU93",
	}
	OperationScarletDawn_AG[109] = {				
		TargetName = "Mezzeh - Missile Storage",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Missile Storage Facility At Mezzeh\nMezzeh Sector - Grid BT30",
	}
	OperationScarletDawn_AG[110] = {				
		TargetName = "Alsqublh - Barracks",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Military Barracks North-East Of Alsqublh\nMasyaf Sector - Grid BU39",
	}
	OperationScarletDawn_AG[111] = {				
		TargetName = "Alsqublh - Military HQ",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Military HQ North-East Of Alsqublh\nMasyaf Sector - Grid BU39",
	}
	OperationScarletDawn_AG[112] = {				
		TargetName = "Barisha - Compound",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Suspected ISIS Compound At Barisha\nBarisha Sector - Grid BA80",
	}
	OperationScarletDawn_AG[113] = {				
		TargetName = "Jarmaya - Weapons Hangar",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Weapons Hangar At Jarmaya\nDamascus Sector - Grid BT41",
	}
	OperationScarletDawn_AG[114] = {				
		TargetName = "Masyaf - Weapons Hangar South",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Weapons Hangar South-West Of Masyaf\nMasyaf Sector - Grid BU58",
	}
	OperationScarletDawn_AG[115] = {				
		TargetName = "Masyaf - Weapons Hangar North",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Weapons Hangar North Of Masyaf\nMasyaf Sector - Grid BU58",
	}
	OperationScarletDawn_AG[116] = {				
		TargetName = "Aleppo - Repair Workshop",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Repair Workshop At Aleppo\nAleppo Sector - Grid CA40",
	}
	OperationScarletDawn_AG[117] = {				
		TargetName = "Latakia - Ammunition Warehouse",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Ammunition Storage Warehouse At Latakia\nLatakia Sector - Grid YE53",
	}
	OperationScarletDawn_AG[118] = {				
		TargetName = "Raqqa - ISIS HQ",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The ISIS HQ Building At Raqqa\nRaqqa Sector - Grid EV07",
	}
	OperationScarletDawn_AG[119] = {				
		TargetName = "Hama - Warehouse",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Weapons Storage Warehouse At Hama\nHama Sector - Grid BU98",
	}
	--////UNARMED
	OperationScarletDawn_AG[120] = {				
		TargetName = "Masyaf - Supply Truck South",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Supply Trucks South-West Of Masyaf\nMasyaf Sector - Grid BU58",
	}
	OperationScarletDawn_AG[121] = {				
		TargetName = "Masyaf - Supply Truck North",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Supply Trucks North Of Masyaf\nMasyaf Sector - Grid BU58",
	}
	OperationScarletDawn_AG[122] = {				
		TargetName = "Hama - Supply Truck",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Supply Trucks At Hama\nHama Sector - Grid BU98",
	}
	OperationScarletDawn_AG[123] = {				
		TargetName = "Al Safirah - Supply Truck",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Supply Trucks At Al Safira\nAleppo Sector - Grid BV59",
	}	
	OperationScarletDawn_AG[124] = {				
		TargetName = "Mezzeh - Supply Truck",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Supply Trucks At Mezzeh\nMezzeh Sector - Grid BT30",
	}
	--////SPECIAL NAMED
	OperationScarletDawn_AG[125] = {				
		TargetName = "Abu Bakr al-Baghdadi",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Seek And Destroy High Priority Target: Abu Bark al-Baghdadi. Intelligence Reports Target Is Located Near Barisha\nBarisha Sector - Grid BA80",
	}	
	OperationScarletDawn_AG[126] = {				
		TargetName = "Abu Muhammad al-Halabi",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Seek And Destroy High Priority Target: Abu Muhammad al-Halabi. Intelligence Reports Target Is Located Near Barisha\nBarisha Sector - Grid BA80",
	}	
	--////SPECIAL GROUPS
	OperationScarletDawn_AG[127] = {				
		TargetName = "Insurgent - Barisha",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy ISIS Units Reported Near Barisha\nBarisha Sector - Grid BA80",
	}
	OperationScarletDawn_AG[128] = {				
		TargetName = "Armor - Raqqa - ISIS",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy ISIS Armored Units At Raqqa\nRaqqa Sector - Grid EV07",
	}
	OperationScarletDawn_AG[129] = {				
		TargetName = "Raqqa - ISIS Igla",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy ISIS Anti-Aircraft Infantry At Raqqa\nRaqqa Sector - Grid EV07",
	}
	OperationScarletDawn_AG[130] = {				
		TargetName = "AAA - Raqqa - ISIS",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy ISIS AAA Assets At Raqqa\nRaqqa Sector - Grid DV97/EV07",
	}	
	--////XPACK1
	OperationScarletDawn_AG[131] = {				
		TargetName = "SAM-SA2 - Saraqib",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-2 Site At Saraqib\nIdlib Sector - Grid CV07",
	}
	OperationScarletDawn_AG[132] = {				
		TargetName = "SAM-SA3 - Abu al-Duhur",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-3 Site At Abu al-Duhur\nIdlib Sector - Grid CV25\nN 35.43.45 E 37.06.58 \nALT 820 ft",
	}
	OperationScarletDawn_AG[133] = {				
		TargetName = "AAA - Idlib",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy AAA Assets At Idlib\nIdlib Sector - Grid BV87",
	}
	OperationScarletDawn_AG[134] = {				
		TargetName = "Armor - Idlib",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Armored Vehicles At Idlib\nIdlib Sector - Grid BV87",
	}
	OperationScarletDawn_AG[135] = {				
		TargetName = "Idlib - Supply Truck",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The Supply Trucks At Idlib\nIdlib Sector - Grid BV87",
	}
	OperationScarletDawn_AG[136] = {				
		TargetName = "Idlib - Military HQ",
		TargetStatic = true,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The ISIS Headquarters At Idlib\nIdlib Sector - Grid BV87",
	}
	--////SA-15
	OperationScarletDawn_AG[137] = {				
		TargetName = "SAM-SA15 - Latakia",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-15 At Latakia\nLatakia Sector - Grid YE53",
	}
	OperationScarletDawn_AG[138] = {				
		TargetName = "SAM-SA15 - Tartus",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-15 At Tartus\nTartus Sector - Grid YD65",
	}
	OperationScarletDawn_AG[139] = {				
		TargetName = "SAM-SA15 - Aleppo",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-15 At Aleppo\nAleppo Sector - Grid CA50",
	}
	OperationScarletDawn_AG[140] = {				
		TargetName = "SAM-SA15 - Damascus",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-15 At Damascus\nDamascus Sector - Grid BT50",
	}
	OperationScarletDawn_AG[141] = {				
		TargetName = "SAM-SA15 - Izra",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-15 At Izra\nGolan Heights Sector - Grid BS33",
	}
	OperationScarletDawn_AG[142] = {				
		TargetName = "SAM-SA2 - Aleppo - South",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-2 Site South Of Aleppo\nAleppo Sector - Grid CV39",
	}	
	OperationScarletDawn_AG[143] = {				
		TargetName = "SAM-SA3 - Aleppo - West",
		TargetStatic = false,
		TargetBriefing = "Mission Update \nPrimary Objective - Destroy The SA-3 Site On The Western Side Of Aleppo\nAleppo Sector - Grid CA20/21",
	}	
	OperationScarletDawn_AG[144] = {
    TargetName = "Ein_Elkorum - Patrol",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: ISIL CONVOY \n\nOUR DEEP COVER OPERATIVE HAS SENT WORD THAT AN ISIL CONVOY HAS BEEN PATROLLING THE CITY OF EIN EIKORUM IN ORDER TO RECRUIT AND CONTROL THE REMAINING POPULATE. TAKE OUT THE CONVOY PATROLLING THE CITY WITH WHATEVER MEANS NECESSARY. \n\nPORT LOCATION: N 35.22.11 E 36.24.22 (MAP GRID: BV61) \n\nSUGGESTED MUNITION(S): LASER GUIDED MUNITIONS, ROCKETS, RETARDED BOMBS",
  }     
  OperationScarletDawn_AG[145] = {
    TargetName = "Armor - Al_Tanf",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nMAY 18, 2017 \nTARGET: MILITIA ARMOR & TROOPS \n\nA U.S. AIRCRAFT CONDUCTED AIRSTRIKES AGAINST VEHICLES, INCLUDING A TANK AND BULLDOZER BELONGING TO PRO-GOVERNMENT MILITIAS THAT WERE SETTING UP FIGHTING POSITIONS WITHIN THE AL-TANF DECONFLICTION ZONE. \n\nLOCATION: N 33.32.19 E 38.07.34 (MAP GRID: DT11) \nSUGGESTED MUNITION(S): ARMOR PIERCING & CLUSTER MUNITIONS.",
  }           
  OperationScarletDawn_AG[146] = {
    TargetName = "Barzah_SciCtr-1",
    TargetStatic = true,
    TargetBriefing = "MISSION UPDATE \n\n13 APRIL 2018 \nTARGET: BARZAH SCIENCE CENTER \n\nA SYRIAN GOVERNMENT OFFENSIVE TO RECAPTURE THE REBEL-HELD EASTERN GHOUTA SUBURB BEGAN IN FEBRUARY 2018. THE OFFENSIVE WAS CONDEMNED BY WESTERN MEDIA AND GOVERNMENTS FOR ITS USE OF CHEMICAL WEAPONS. IN RETALIATION THE US JOIN CHIEFS TARGETED 3 LOCATIONS, ONE OF WHICH IS THE BARZAH SCIENCE CENTER IN NORTHERN DAMASCUS. THE CENTER WAS FOUND TO BE THE CENTER RESPONSIBLE FOR SYRIA'S CHEMICAL WEAPONS PROGRAM. IN APRIL 2018, A LONG RANGE STRIKE USING MULTIPLE CRUISE MISSILES WAS CARRIED OUT. \n\nLOCATION: N 33.32.43 E 36.18.14 (MAP GRID: BT41) \n\nSUGGESTED MUNITION(S): CRUISE MISSILES / LONG RANGE GLIDE BOMBS / LASER GUIDED MUNITIONS \nNOTES: JTAC1 IS ON STATION FOR SPOTTING & LASING AND WILL ACTIVATE WHEN ON STATION.",
  }         
  OperationScarletDawn_AG[147] = {
    TargetName = "Him_Shanshar-1",
    TargetStatic = true,
    TargetBriefing = "MISSION UPDATE \n\n13 APRIL 2018 \nTARGET: HIM_SHANSHAR WAREHOUSES \n\nA SYRIAN GOVERNMENT OFFENSIVE TO RECAPTURE THE REBEL-HELD EASTERN GHOUTA SUBURB BEGAN IN FEBRUARY 2018. THE OFFENSIVE WAS CONDEMNED BY WESTERN MEDIA AND GOVERNMENTS FOR ITS USE OF CHEMICAL WEAPONS. IN RETALIATION THE US JOIN CHIEFS TARGETED 3 LOCATIONS, ONE OF WHICH WERE 3 WAREHOUSES IN HIM_SHANSHAR. THE WAREHOUSES CONTAINED PARTS OF SYRIA’S CHEMICAL WEAPONS CACHE. IN APRIL 2018, A LONG RANGE STRIKE USING MULTIPLE CRUISE MISSILES WAS CARRIED OUT. \n\nLOCATION: N 34.41.23 E 36.29.03 (MAP GRID: BU64) \n\nSUGGESTED MUNITION(S): CRUISE MISSILES / LONG RANGE GLIDE BOMBS",
  }
  OperationScarletDawn_AG[148] = {
    TargetName = "Russian-Cargo",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: RUSSIAN CARGO VESSEL \n\nDESPITE GLOBAL SANCTIONS AGAINST SYRIA, RUSSIA HAS BEEN SENDING ARMS AND SUPPLIES TO THE CURRENT SYRIAN REGIME. A RUSSIAN CARGO SHIP IS CURRENTLY ON ROUTE FROM THE SOUTHWEST AND INTEL SUGGEST IT PLANS TO UNLOAD ITS CARGO IN THE PORT OF LATAKIA. STOP THIS VESSEL AT ALL COSTS FROM REACHING THE PORT. \n\nPORT LOCATION: N 35.31.15 E 35.45.38 (MAP GRID: YE53) \n\nSUGGESTED MUNITION(S): HARPOON(S) & LASER GUIDED MUNITIONS",
  }
  OperationScarletDawn_AG[149] = {
    TargetName = "Busra-Train-9",
    TargetStatic = true,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: LOCOMOTIVE \n\nA TRAIN SUSPECTED OF TRANSPORTING NUCLEAR MACHINERY NEEDED TO DEVELOP THE SYRIAN NUCLEAR WEAPONS PROGRAM IS PREPARING TO LEAVE THE CITY OF BUSRA IN SOUTH SYRIA. THE CITY IS HEAVILY GUARDED WITH MANPADS AND AAA. YOUR PRIMARY MISSION IS TO DESTROY THE LOCOMOTIVE AND CRIPPLE THE TRAIN. \n\nLOCATION: N 32.31.05 E 36.28.38 (MAP GRID: BS60) \n\nSUGGESTED MUNITION(S): UNGUIDED BOMBS MK-83/MK-84",
  }
  OperationScarletDawn_AG[150] = {
    TargetName = "AAA - Busra",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: MANPADS & AAA \n\nSYRIAN TROOPS HAVE FORTIFIED THE CITY OF BUSRA TO GUARD A TRAIN SUSPECTED OF TRANSPORTING NUCLEAR MACHINERY NEEDED TO DEVELOP THE SYRIAN NUCLEAR WEAPONS PROGRAM. YOUR PRIMARY MISSION IS TO DESTROY ALL OF THE MANPADS & AAA IN THE CITY. \n\nLOCATION: N 32.31.5 E 36.28.38 (MAP GRID: BS60) \n\nSUGGESTED MUNITION(S): UNGUIDED BOMBS",
  }
    OperationScarletDawn_AG[151] = {
    TargetName = "Armor - Palmyra_Roman_Theatre",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: SYRIAN MOBILE AIR DEFENSES & AAA IN PALMYRA \n\nSYRIAN MOBILE AIR DEFENSES HAVE MOVED INTO THE ROMAN THEATER RUINS IN THE CITY OF PALMYRA. THESE AIR DEFENSE ASSETS ARE GUARDING THE PALMYRA AIRPORT WHICH IS A STAGING POINT FOR SYRIAN AIR FORCE. YOUR MISSION IS TO ELIMINATE ALL OF THE AIR DEFENSES. IF POSSIBLE, PRESERVE AS MUCH OF THE THEATER RUINS AS YOU CAN \n\nLOCATION: N 34.33.05 E 38.16.09(MAP GRID: DU32) \n\nSUGGESTED MUNITION(S): STAND OFF WEAPONS",
  }
  
  OperationScarletDawn_AG[152] = {
    TargetName = "Artillery - Palmyra_Castle",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: MILITIA MORTAR SITES \n\nTWO MORTAR SITES HAVE BEEN SPOTTED IN OUR MOST RECENT SATALLITE PASS AROUND THE CASTLE IN THE CITY OF PALMYRA. YOUR MISSION IS TO DESTORY BOTH LOCATIONS AHEAD OF INBOUND ALLIED FORCES.\n\nLOCATION: N 34.33.45 E 38.15.26 (MAP GRID: DU32) \n\nSUGGESTED MUNITION(S): STAND OFF WEAPONS",
  }
   OperationScarletDawn_AG[153] = {
    TargetName = "Scud Launcher - al-Thawra_Dam",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: THREE MISSILE LAUNCHERS \n\nSYRIAN FORCES HAVE CAPTURED THREE MEDIUM RANGE BALLISTIC MISSILE LAUNCHERS THAT WERE BEING MOVED BY TURKISH FORCES IN THE AREA. AT THE TIME NO WARHEADS WERE INSTALLED ON THE MISSLES. WE NEED YOU TO KNOCK OUT THOSE LAUNCHERS BEFORE SYRIAN FORCERS CAN OBTAIN ANY WARHEADS. THE LAUNCHERS ARE CURRENTLY BEING STAGED AT THE AL-THAWRA DAM. THE LAUNCHERS ARE BEING PROTECTED BY MULTIPLE AIR DEFENSES.\n\nLOCATION: N 35.51.41 E 38.33.31 (MAP GRID: DU32) \n\nSUGGESTED MUNITION(S): STAND OFF WEAPONS",
  }
   OperationScarletDawn_AG[154] = {
    TargetName = "Damascus-VIP",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: CONVOY CARRYING VIP TARGET \n\nDEEP COVER INTELLIGENCE HAS LEAREND THAT A PRIORITY TARGET, CODENAME INDIGO RAILROAD, IS FLYING IN TO DAMASCUS FOR A MEETING AT THE PRESIDENTIAL PALACE. YOUR MISSION IS TO DESTROY THE CONVOY TRAVELING BETWEEN THE MEZZEH AIRPORT AND THE PRESIDENTIAL PALACE TO THE NORTH.\n\nLOCATION: N 33.31.3 E 36.14.52 (MAP GRID: BT40-41) \n\nSUGGESTED MUNITION(S): PRECISION GUIDED WEAPONS",
  }
  OperationScarletDawn_AG[155] = {
    TargetName = "Tartus–Speedboats",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: SPEEDBOATS PATROLLING TARTUS HARBOR \n\n TWO SPEEDBOATS HAVE BEEN REPORTED PATROLLING TARTUS PORT AT HIGH SPEED. LOCATE AND DESTROY/DISABLE THE BOATS. \n\nLOCATION: N 34.54.16 E 35.51.46 (MAP GRID: YD66) \n\nSUGGESTED MUNITION(S): LASER GUIDED BOMBS, ROCKETS, GUNS",
  }
  OperationScarletDawn_AG[156] = {
    TargetName = "Tripoli-Sub",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: UNKNOWN SUBMARINE \n\n AN UNKNOWN SUBMARINE HAS BEEN SPOTTED NEAR TRIPOLI. WE DON’T HAVE ANY AVAILABLE VESSELS THAT CAN BE TASKED WITH A SEARCH AN DSTROY MISSION. YOU RMISSION IS TO LOCATE THE SUB AND IF POSSIBLE DISABLE IT. \n\nLOCATION: N 34.30.13 E 35.50.18 (MAP GRID: YD51-62) \n\nSUGGESTED MUNITION(S): LASER GUIDED BOMBS, ROCKETS, GUNS",
  }
  OperationScarletDawn_AG[157] = {
    TargetName = "Insurgent - Baalbek",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: ISIL TRAINING CAMP \n\n SATELLITE IMAGING FOUND A ISIL TRAINING CAMP SETUP IN THE HILLS SOUTH OF BAALBEK IN THE SOUTHERN ZONE OF SYRIA. TAKE OUT ALL INSURGENTS AND VEHICLES AT THIS LOCATION. \n\nLOCATION: N 33.55.11 E 36.13.52 (MAP GRID: BT45) \n\nSUGGESTED MUNITION(S): UNGUIDED MUNITIONS",
  }
  OperationScarletDawn_AG[158] = {
    TargetName = "FakeUNcargo",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: TWIN PROP CARGO PLANE \n\n OUR SOURCES HAVE DISCOVERED THAT A SYRIAN CARGO PLANE IS FLYING FROM KHALKHALAH AIRPORT TO RYAK AIRPORT IN SOUTHERN SYRIA. WE BELIEVE THEY ARE RUNNING WEAPONS INTO THE AREA SUPPORTING LOCAL TERRORISTS GROUPS STATIONED IN BERUIT. FIND AND VISUALLY IDENTIFY THE PLANE, THEN TRY AND FORCE THEM TO LAND. IF THEY WILL NOT LAND, YOU ARE AUTHORIZED TO BRING THEM DOWN. \n\nLOCATION: SOUTHERN SYRIA (MAP GRID: BS76-YC74) \n\nSUGGESTED MUNITION(S): IR GUIDED MISSLES OR GUNS",
  }
   OperationScarletDawn_AG[159] = {
    TargetName = "Outpost - Beirut",
    TargetStatic = true,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: INSURGENT ROAD OUTPOST \n\n INSURGETS HAVE SETUP A ROAD OUTPOST ON HWY-30, A 3MI ESE OUT OF BEIRUT. DESTORY THE OUTPOST WITH MINIMAL COLLATERAL DAMAGE. \n\nLOCATION: N 33.48.48 E 35.37.11 (MAP GRID: YC44) \n\nSUGGESTED MUNITION(S): LIGHT PRECISION GUIDED MUNITIONS",
  }
  OperationScarletDawn_AG[160] = {
    TargetName = "Bomber1",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: 2x SU-24M Bombers \n\n A SYRIAN FLIGHT OF SU-24 BOMBERS HAS BEEN SPOTTED RUNNING A NORTH/SOUTH PATTERN FROM MARJ RUHAYYIL TO HAMA. INTERCEPT THE BOMBERS BEOFRE THEY CAN STRIKE ALLIED ASSETS. \n\nSUGGESTED MUNITION(S): MEDIUM-RANGE AIR-TO-AIR MISSILE",
  }
  OperationScarletDawn_AG[161] = {
    TargetName = "Patrol - Lake_Qaraoun",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: ARMORED PATROL \n\n AN ARMORED PATROL CONVOY HAS CROSSED THE SYRIA/LEBANON BORDER AND HAS BEEN SPOTTED PATROLLING AROUND LAKE QARAUON. THE LEBANESE PRIME MINISTER HAS ASKED THE US TO STEP IN AND ELIMINATE THE AGRESSORS. FIND AND DESTORY THE CONVOY.\n\nLOCATION: N 33.34.35 E 35.42.00 (MAP GRID: YC51-52) \n\nSUGGESTED MUNITION(S): LASER GUIDED MUNITIONS, ROCKETS, UNGUIDED BOMBS",
  }
  OperationScarletDawn_AG[162] = {
    TargetName = "Infrantry - Jisr-ATTK",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: INSURGETNS IN CONTACT WITH ALLIED PATROL \n\n AN US CONVOY PUSHING SOUTH FROM HATAY HAS REQUESTD CAS SUPPORT IN THE TOWN OF JISR ASH-SHUGHUR. CONTACT WARRIOR 1-1 ON LEFT 10 (294.700 AM) WHEN ON STATION. \n\nLOCATION: N 35.48.52 E 36.19.04 (MAP GRID: BV56) \n\nSUGGESTED MUNITION(S): UNRESTRICTED",
  }
  OperationScarletDawn_AG[163] = {
    TargetName = "Tartus–Subs",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: TWO SUBS \n\n A PAIR OF RUSSIAN ATTACK SUBS HAVE BEEN SPOTTED BUNKERING IN TARTUS HARBOR. IF RUSSIAN SUBS ARE TAKING PORT IN SYRAIA WE SHOULD EXPECT TO SEE OTHER RUSSIAN FORCES SOON. \n\nLOCATION: N 34.54.16 E 35.51.46 (MAP GRID: YD66) \n\nSUGGESTED MUNITION(S): MEDIUM & HEAVY BOMBS",
  }
  OperationScarletDawn_AG[164] = {
    TargetName = "Tartus–Cargo",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: THREE CARGO VESSELS IN PORT \n\n ONE OF OUR SOURCES HAVE CONFIRMED THAT RUSSIA IS OFFLOADING WEAPONS AND PROVISIONS IN TARTUS HARBOR DESPITE SYRIAN SANCTIONS. ELIMINATE THE THREE (3) SHIPS IN THE HARBOR.\n\nLOCATION: N 34.54.16 E 35.51.46 (MAP GRID: YD66) \n\nSUGGESTED MUNITION(S): MEDIUM & HEAVY BOMBS",
  }
  OperationScarletDawn_AG[165] = {
    TargetName = "WestFarp-Mi8",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: TWO MI-8 \n\n TWO MI-8 HELOS ARE RUNNING SUPPLIES FROM THE KUZNETSOV BG TO THE RUSSIAN FARP. ELIMINATE THE HELOS.\n\nLOCATION: APROX N 35.50.23 E 31.31.08 (MAP GRID: N/A) \n\nSUGGESTED MUNITION(S): MEDIUM-RANGE AIR-TO-AIR MISSILE",
  }
  OperationScarletDawn_AG[166] = {
    TargetName = "WestFarp-Mi24",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: TWO MI-24 \n\n TWO MI-24 HELOS HAVE BEEN SPOTTED ON RADAR PATROLLING THE TURKISH COAST TO THE EAST OF THE RUSSIN FARM. ELIMINATE THE HELOS.\n\nLOCATION: APROX N 36.08.17 E 33.12.29 (MAP GRID: N/A) \n\nSUGGESTED MUNITION(S): MEDIUM-RANGE AIR-TO-AIR MISSILE",
  }
  OperationScarletDawn_AG[167] = {
    TargetName = "WestFarp-Command_Post",
    TargetStatic = true,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: FARP COMMAND POST \n\n WE NEED TO SLOW DOWN OPERATIONS AT THE RUSSIAN FARP. DESTORY THE COMMAND POST NEAR THE FARP.\n\nLOCATION: APROX N 36.13.27 E 32.20.22 (MAP GRID: N/A) \n\nSUGGESTED MUNITION(S): GBU-31 OR EQUIVILENT",
  }	
  OperationScarletDawn_AG[168] = {
    TargetName = "Infantry - Aleppo-Citadel",
    TargetStatic = false,
    TargetBriefing = "MISSION UPDATE \n\nTARGET: ISIL MILITANTS IN AND AROUND ALEPPO CITADEL \n\nISIL TROOPS HAVE TAKEN OVER THE CITIDEL IN THE CITY OF ALEPPO. YOUR PRIMARY TARGETS ARE THE INFANTRY IN AND AROUND THE CITADEL. YOUR SECONDARY OBJECTIVE IS A SUSPECTED WEAPONS CONTAINER WITHIN THE CITIDEL ITSELF. AS THIS IS A NATION MONUMENT, MINIMAL DAMAGE TO THE STRUCTURES IS REQUIRED. \n\nLOCATION: N 36.11.57 E 37.09.46 (MAP GRID: CA30) \n\nSUGGESTED MUNITION(S): GUNS OR ROCKETS",
  }
end

--////End Mission Target Table
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////ON DEMAND MISSION INFORMATION

local function CheckObjectiveRequest()
	
	if ( AGMissionBriefingText ~= nil ) then
		trigger.action.outText(AGMissionBriefingText, 15)
		if ( CustomSoundsEnabled == 1) then
			trigger.action.outSound('That Is Our Target.ogg')
		else
		end	
	elseif ( OperationComplete == true ) then
		trigger.action.outText("The Operation Has Been Completed, There Are No Further Objectives", 15)
	elseif ( AGMissionBriefingText == nil and OperationComplete == false ) then
		trigger.action.outText("Check Objective Request Error - No Briefing Available And Operation Is Not Completed", 15)
	else
		trigger.action.outText("Check Objective Request Error - Unexpected Result Occured", 15)
	end	
end

function TargetReport()
			
	if (AGTargetTypeStatic == false and AGMissionTarget ~=nil) then
		TargetGroup = GROUP:FindByName(AGMissionTarget)	
		
		if (GROUP:FindByName(AGMissionTarget):IsAlive() == true) then
		
			TargetRemainingUnits = Group.getByName(AGMissionTarget):getSize()	
			
			MissionPlayersBlue = SET_CLIENT:New():FilterCoalitions("blue"):FilterActive():FilterOnce()
			
			MissionPlayersBlue:ForEachClient(
				function(Client)
					if Client:IsAlive() == true then
						ClientPlayerName = Client:GetPlayerName()	  
						ClientUnitName = Client:GetName()			  
						ClientGroupName = Client:GetClientGroupName() 			
						ClientGroupID = Client:GetClientGroupID()	   	
				
						PlayerUnit = UNIT:FindByName(ClientUnitName)		
					
						PlayerCoord = PlayerUnit:GetCoordinate()
						TargetCoord = TargetGroup:GetCoordinate()
						TargetHeight = math.floor(TargetGroup:GetCoordinate():GetLandHeight() * 100)/100
						TargetHeightFt = math.floor(TargetHeight * 3.28084)
						PlayerDistance = PlayerCoord:Get2DDistance(TargetCoord)

						TargetVector = PlayerCoord:GetDirectionVec3(TargetCoord)
						TargetBearing = PlayerCoord:GetAngleRadians (TargetVector)	
					
						PlayerBR = PlayerCoord:GetBRText(TargetBearing, PlayerDistance, SETTINGS:SetImperial())
					
						--List the amount of units remaining in the group
						if (TargetRemainingUnits > 1) then
							SZMessage = "There are "..TargetRemainingUnits.." targets remaining for this mission" 
						elseif (TargetRemainingUnits == 1) then
							SZMessage = "There is "..TargetRemainingUnits.." target remaining for this mission" 
						elseif (TargetRemainingUnits == nil) then					
							SZMessage = "Unable To Determine Group Size"
						else			
							SZMessage = "Nothing to report"		
						end		
					
						BRMessage = "Target bearing "..PlayerBR
						ELEMessage = "Elevation "..TargetHeight.."m".." / "..TargetHeightFt.."ft"
					
						_SETTINGS:SetLL_Accuracy(0)
						CoordStringLLDMS = TargetCoord:ToStringLLDMS(SETTINGS:SetImperial())
						_SETTINGS:SetLL_Accuracy(3)
						CoordStringLLDDM = TargetCoord:ToStringLLDDM(SETTINGS:SetImperial())
						_SETTINGS:SetLL_Accuracy(2)
						CoordStringLLDMSDS = TargetCoord:ToStringLLDMSDS(SETTINGS:SetImperial())
						
						trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText.."\n"..BRMessage.."\n"..SZMessage.."\n"..CoordStringLLDMS.."\n"..CoordStringLLDDM.."\n"..CoordStringLLDMSDS.."\n"..ELEMessage, 30)							
					else						
					end				
				end
			)
		else
			trigger.action.outText("Target Report Unavailable", 15)
		end
		
	elseif (AGTargetTypeStatic == true and AGMissionTarget ~=nil) then
		TargetGroup = STATIC:FindByName(AGMissionTarget, false)
		
		MissionPlayersBlue = SET_CLIENT:New():FilterCoalitions("blue"):FilterActive():FilterOnce()

		MissionPlayersBlue:ForEachClient(
			function(Client)
				if Client:IsAlive() == true then
					ClientPlayerName = Client:GetPlayerName()	
					ClientUnitName = Client:GetName()			
					ClientGroupName = Client:GetClientGroupName()				
					ClientGroupID = Client:GetClientGroupID()
				
					PlayerUnit = UNIT:FindByName(ClientUnitName)		
					
					PlayerCoord = PlayerUnit:GetCoordinate()
					TargetCoord = TargetGroup:GetCoordinate()
					TargetHeight = math.floor(TargetGroup:GetCoordinate():GetLandHeight() * 100)/100
					TargetHeightFt = math.floor(TargetHeight * 3.28084)
					PlayerDistance = PlayerCoord:Get2DDistance(TargetCoord)
					
					TargetVector = PlayerCoord:GetDirectionVec3(TargetCoord)
					TargetBearing = PlayerCoord:GetAngleRadians (TargetVector)	
										
					PlayerBR = PlayerCoord:GetBRText(TargetBearing, PlayerDistance, SETTINGS:SetImperial())

					BRMessage = "Target bearing "..PlayerBR
					ELEMessage = "Elevation "..TargetHeight.."m".." / "..TargetHeightFt.."ft"
					
					_SETTINGS:SetLL_Accuracy(0)
					CoordStringLLDMS = TargetCoord:ToStringLLDMS(SETTINGS:SetImperial())
					_SETTINGS:SetLL_Accuracy(3)
					CoordStringLLDDM = TargetCoord:ToStringLLDDM(SETTINGS:SetImperial())
					_SETTINGS:SetLL_Accuracy(2)
					CoordStringLLDMSDS = TargetCoord:ToStringLLDMSDS(SETTINGS:SetImperial())
					
					trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText.."\n"..BRMessage.."\n"..CoordStringLLDMS.."\n"..CoordStringLLDDM.."\n"..CoordStringLLDMSDS.."\n"..ELEMessage, 30)							
				else
				end				
			end
		)		
	elseif ( OperationComplete == true ) then
		trigger.action.outText("The Operation Has Been Completed, There Are No Further Targets", 15)	
	else
		trigger.action.outText("No Target Information Available", 15)
	end
end

]]--

--////End On Demand Mission Information
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////AI SUPPORT FLIGHT FUNCTIONS

--////COMBAT AIR PATROL FIGHTER SCREEN
function AbortCAPMission()

	if ( GROUP:FindByName(USAEFCAPGROUPNAME) ~= nil and GROUP:FindByName(USAEFCAPGROUPNAME):IsAlive() ) then
		--If Alive, Perform RTB command
		local RTB = {}
		--RTB.fromWaypointIndex = 2
		RTB.goToWaypointIndex = 5
								
		local RTBTask = {id = 'SwitchWaypoint', params = RTB}
		Group.getByName(USAEFCAPGROUPNAME):getController():setOption(0, 3) -- (0, 4) is weapons hold, (0, 3) is return fire
		Group.getByName(USAEFCAPGROUPNAME):getController():setCommand(RTBTask)	
			
		trigger.action.outText("Fighter Screen Is Returning To Base",15)
	else
		trigger.action.outText("Fighter Screen Does Not Have Fighters To Recall",15)
	end	
end
--////CLOSE AIR SUPPORT
function AbortCASMission()

	if ( GROUP:FindByName(USAEFCASGROUPNAME) ~= nil and GROUP:FindByName(USAEFCASGROUPNAME):IsAlive() ) then
		--If Alive, Perform RTB command
		local RTB = {}
		--RTB.fromWaypointIndex = 2
		RTB.goToWaypointIndex = 5
								
		local RTBTask = {id = 'SwitchWaypoint', params = RTB}
		Group.getByName(USAEFCASGROUPNAME):getController():setOption(0, 3) -- (0, 4) is weapons hold, (0, 3) is return fire
		Group.getByName(USAEFCASGROUPNAME):getController():setCommand(RTBTask)	
			
		trigger.action.outText("Close Air Support Is Returning To Base",15)
	else
		trigger.action.outText("Close Air Support Does Not Have Planes To Recall",15)
	end	
end
--////ANTI-SHIPPING
function AbortASSMission()

	if ( GROUP:FindByName(USAEFASSGROUPNAME) ~= nil and GROUP:FindByName(USAEFASSGROUPNAME):IsAlive() ) then
		--If Alive, Perform RTB command
		local RTB = {}
		--RTB.fromWaypointIndex = 2
		RTB.goToWaypointIndex = 5
								
		local RTBTask = {id = 'SwitchWaypoint', params = RTB}
		Group.getByName(USAEFASSGROUPNAME):getController():setOption(0, 3) -- (0, 4) is weapons hold, (0, 3) is return fire
		Group.getByName(USAEFASSGROUPNAME):getController():setCommand(RTBTask)	
			
		trigger.action.outText("Anti-Shipping Support Is Returning To Base",15)
	else
		trigger.action.outText("Anti-Shipping Support Does Not Have Planes To Recall",15)
	end	
end
--////SEAD
function AbortSEADMission()

	if ( GROUP:FindByName(USAEFSEADGROUPNAME) ~= nil and GROUP:FindByName(USAEFSEADGROUPNAME):IsAlive() ) then
		--If Alive, Perform RTB command
		local RTB = {}
		--RTB.fromWaypointIndex = 2
		RTB.goToWaypointIndex = 4
								
		local RTBTask = {id = 'SwitchWaypoint', params = RTB}
		Group.getByName(USAEFSEADGROUPNAME):getController():setOption(0, 3) -- (0, 4) is weapons hold, (0, 3) is return fire
		Group.getByName(USAEFSEADGROUPNAME):getController():setCommand(RTBTask)	
			
		trigger.action.outText("SEAD Support Is Returning To Base",15)
	else
		trigger.action.outText("SEAD Support Does Not Have Planes To Recall",15)
	end	
end

function AbortPINMission()

	if ( GROUP:FindByName(USAEFPINGROUPNAME) ~= nil and GROUP:FindByName(USAEFPINGROUPNAME):IsAlive() ) then
		--If Alive, Perform RTB command
		local RTB = {}
		--RTB.fromWaypointIndex = 2
		RTB.goToWaypointIndex = 5
								
		local RTBTask = {id = 'SwitchWaypoint', params = RTB}
		Group.getByName(USAEFPINGROUPNAME):getController():setOption(0, 3) -- (0, 4) is weapons hold, (0, 3) is return fire
		Group.getByName(USAEFPINGROUPNAME):getController():setCommand(RTBTask)	
			
		trigger.action.outText("Pinpoint Strike Support Is Returning To Base",15)
	else
		trigger.action.outText("Pinpoint Strike Support Does Not Have Planes To Recall",15)
	end	
end

function SEF_PinpointStrikeTargetAcquisition()
	
	--See https://wiki.hoggitworld.com/view/DCS_task_bombing for further details
	--CHECK TARGET IS WITHIN THE SAME GENERAL AREA THE FLIGHT WAS CALLED TO, GET DETAILS IF IT IS AND ABORT IF NOT
	if ( AGMissionTarget ~= nil ) then
		if ( AGTargetTypeStatic == true ) then
			if ( StaticObject.getByName(AGMissionTarget):isExist() == true ) then
				TargetGroupPIN = STATIC:FindByName(AGMissionTarget, false)
				TargetCoordForStrike = TargetGroupPIN:GetCoordinate():GetVec2()
					
				local StrikeGroup = GROUP:FindByName(USAEFPINGROUPNAME):GetCoordinate()
				local StrikeCoord = TargetGroupPIN:GetCoordinate()
				local StrikeDistanceToTarget = StrikeGroup:Get2DDistance(StrikeCoord)
				
				if ( StrikeDistanceToTarget < 75000 ) then				
					local target = {}
					target.point = TargetCoordForStrike
					target.expend = "Two"
					target.weaponType = 14
					target.attackQty = 1
					target.groupAttack = true
					local engage = {id = 'Bombing', params = target}
					Group.getByName(USAEFPINGROUPNAME):getController():pushTask(engage)
					trigger.action.outText("The Pinpoint Strike Flight Reports Target Coordinates Are Locked In", 15)
				else
					trigger.action.outText("Pinpoint Strike Reports Target Is Too Far Away, Aborting Mission", 15)
					AbortPINMission()
				end	
			else
				trigger.action.outText("Pinpoint Strike Mission Unable To Locate Target, Aborting Mission", 15)
				AbortPINMission()
			end
		elseif ( AGTargetTypeStatic == false ) then
			if ( GROUP:FindByName(AGMissionTarget):IsAlive() == true ) then
				TargetGroupPIN = GROUP:FindByName(AGMissionTarget, false)
				TargetCoordForStrike = TargetGroupPIN:GetCoordinate():GetVec2()
					
				local StrikeGroup = GROUP:FindByName(USAEFPINGROUPNAME):GetCoordinate()
				local StrikeCoord = TargetGroupPIN:GetCoordinate()
				local StrikeDistanceToTarget = StrikeGroup:Get2DDistance(StrikeCoord)
				
				if ( StrikeDistanceToTarget < 50000 ) then
					local target = {}
					target.point = TargetCoordForStrike
					target.expend = "Two"
					target.weaponType = 14 -- See https://wiki.hoggitworld.com/view/DCS_enum_weapon_flag for other weapon launch codes
					target.attackQty = 1
					target.groupAttack = true
					local engage = {id = 'Bombing', params = target}
					Group.getByName(USAEFPINGROUPNAME):getController():pushTask(engage)
					trigger.action.outText("The Pinpoint Strike Flight Reports Target Coordinates Are Locked In", 15)
				else
					trigger.action.outText("Pinpoint Strike Reports Target Is Too Far Away, Aborting Mission", 15)
					AbortPINMission()
				end		
			else
				trigger.action.outText("Pinpoint Strike Mission Unable To Locate Target", 15)
				AbortPINMission()
			end
		else
			trigger.action.outText("Pinpoint Strike Mission Unable To Locate Target", 15)
			AbortPINMission()
		end
	else
		trigger.action.outText("The Pinpoint Strike Flight Reports They Have Not Been Given Any Target Information From High Command, Aborting Mission", 15)
		AbortPINMission()		
	end	
end

--////MQ-9 Aerial Drone
function AbortDroneMission()

	if ( GROUP:FindByName(USAEFDRONEGROUPNAME) ~= nil and GROUP:FindByName(USAEFDRONEGROUPNAME):IsAlive() ) then
			
		Group.getByName(USAEFDRONEGROUPNAME):destroy()
			
		trigger.action.outText("MQ-9 Reaper Aerial Drone Self-Destruct Engaged",15)
	else
		trigger.action.outText("MQ-9 Reaper Aerial Drone Is Unable To Be Recalled",15)
	end	
end

function SEF_USAEFCAPSPAWN(DepartureAirbaseName, DestinationAirbaseName)
	
	if ( GROUP:FindByName(USAEFCAPGROUPNAME) ~= nil and GROUP:FindByName(USAEFCAPGROUPNAME):IsAlive() ) then
		trigger.action.outText("Fighter Screen Is Currently Active, Further Support Is Unavailable",15)	
	else
		USAEFCAP_DATA[1].Vec2 = nil
		USAEFCAP_DATA[1].TimeStamp = nil
		USAEFCAP_DATA[2].Vec2 = nil
		USAEFCAP_DATA[2].TimeStamp = nil
		
		local SpawnZone = AIRBASE:FindByName(DepartureAirbaseName):GetZone()
		local DestinationZone = AIRBASE:FindByName(DestinationAirbaseName):GetZone()	
		
		USAEFCAP = SPAWN
			:New("USAEF F-15C")
			:InitLimit( 2, 2 )					
			:OnSpawnGroup(
				function( SpawnGroup )						
					USAEFCAPGROUPNAME = SpawnGroup.GroupName
					USAEFCAPGROUP = GROUP:FindByName(SpawnGroup.GroupName)							
					
					local DepartureZoneVec2 = SpawnZone:GetVec2()
					local TargetZoneVec2 	= DestinationZone:GetVec2()
					local WP0X = DepartureZoneVec2.x
					local WP0Y = DepartureZoneVec2.y
					
					local WP1X = DepartureZoneVec2.x + 1000
					local WP1Y = DepartureZoneVec2.y
					
					--Orbit Start Point (offset Y to 12.5km West of the zone midpoint)
					local WP2X = TargetZoneVec2.x
					local WP2Y = TargetZoneVec2.y - 12500
					
					--Orbit End Point (offset Y to 12.5km East of the zone midpoint)
					local WP3X = TargetZoneVec2.x
					local WP3Y = TargetZoneVec2.y + 12500
					
					local WP4X = DepartureZoneVec2.x
					local WP4Y = DepartureZoneVec2.y				
								
							--////CAP Mission Profile, Engage Targets Along Route Within 50km, With Orbit For 20 Minutes Between WP2 and WP3
							Mission = {
								["id"] = "Mission",
								["params"] = {		
									["route"] = 
									{
										["points"] = 
										{
											[1] = 
											{
												["alt"] = 7000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 222.22222222222,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 0,
												["ETA_locked"] = true,
												["y"] = WP0Y,
												["x"] = WP0X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [1]
											[2] = 
											{
												["alt"] = 7000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 222.22222222222,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
															[1] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 1,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "EPLRS",
																		["params"] = 
																		{
																			["value"] = true,
																			["groupId"] = 0,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [1]
															[2] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "EngageTargets",
																["number"] = 2,
																["params"] = 
																{
																	["targetTypes"] = 
																	{
																		[1] = "Air",
																	}, -- end of ["targetTypes"]
																	["priority"] = 0,
																	["value"] = "Air;",
																	["noTargetTypes"] = 
																	{
																		[1] = "Cruise missiles",
																		[2] = "Antiship Missiles",
																		[3] = "AA Missiles",
																		[4] = "AG Missiles",
																		[5] = "SA Missiles",
																	}, -- end of ["noTargetTypes"]
																	["maxDistEnabled"] = true,
																	["maxDist"] = 50000,
																}, -- end of ["params"]
															}, -- end of [2]
															[3] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 3,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = 3,
																			["name"] = 1,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [3]
															[4] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 4,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = 264241152,
																			["name"] = 10,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [4]
															[5] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 5,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = true,
																			["name"] = 19,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [5]
															[6] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 6,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["variantIndex"] = 1,
																			["name"] = 5,
																			["formationIndex"] = 6,
																			["value"] = 393217,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [6]
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 46.425096732112,
												["ETA_locked"] = false,
												["y"] = WP1Y,
												["x"] = WP1X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [2]
											[3] = 
											{
												["alt"] = 7000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 222.22222222222,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
															[1] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "ControlledTask",
																["number"] = 1,
																["params"] = 
																{
																	["task"] = 
																	{
																		["id"] = "Orbit",
																		["params"] = 
																		{
																			["altitude"] = 7000,
																			["pattern"] = "Race-Track",
																			["speed"] = 222.22222222222,
																			["speedEdited"] = true,
																		}, -- end of ["params"]
																	}, -- end of ["task"]
																	["stopCondition"] = 
																	{
																		["duration"] = 1200,
																	}, -- end of ["stopCondition"]
																}, -- end of ["params"]
															}, -- end of [1]
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 382.40941284629,
												["ETA_locked"] = false,
												["y"] = WP2Y,
												["x"] = WP2X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [3]
											[4] = 
											{
												["alt"] = 7000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 222.22222222222,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 467.40499648103,
												["ETA_locked"] = false,
												["y"] = WP3Y,
												["x"] = WP3X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [4]
											[5] = 
											{
												["alt"] = 7000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 222.22222222222,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 806.47990963086,
												["ETA_locked"] = false,
												["y"] = WP4Y,
												["x"] = WP4X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [5]
										}, -- end of ["points"]
									}, -- end of ["route"]
								}, --end of ["params"]
							}--end of Mission				
					USAEFCAPGROUP:SetTask(Mission)				
				end
			)
		if ( DepartureAirbaseName == "Ramat David" ) then
			USAEFCAP:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot, nil, AIRBASE.TerminalType.OpenBig )
		else
			USAEFCAP:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
		end		
		--:SpawnInZone( SpawnZone, false, 7000, 7000 )
		--:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot ) --SPAWN.Takeoff.Hot SPAWN.Takeoff.Cold SPAWN.Takeoff.Runway
		--:SpawnAtAirbase( AIRBASE:FindByName( "Ramat David" ), SPAWN.Takeoff.Hot, nil, AIRBASE.TerminalType.OpenBig )
		trigger.action.outText("Fighter Screen Launched",15)	
	end
end

function SEF_USAEFSEADSPAWN(DepartureAirbaseName, DestinationAirbaseName)
	
	if ( GROUP:FindByName(USAEFSEADGROUPNAME) ~= nil and GROUP:FindByName(USAEFSEADGROUPNAME):IsAlive() ) then
		trigger.action.outText("SEAD Is Currently Active, Further Support Is Unavailable",15)	
	else
		USAEFSEAD_DATA[1].Vec2 = nil
		USAEFSEAD_DATA[1].TimeStamp = nil
		USAEFSEAD_DATA[2].Vec2 = nil
		USAEFSEAD_DATA[2].TimeStamp = nil
		
		local SpawnZone = AIRBASE:FindByName(DepartureAirbaseName):GetZone()
		local DestinationZone = AIRBASE:FindByName(DestinationAirbaseName):GetZone()	
		
		USAEFSEAD = SPAWN
			:New("USAEF F-16C")
			:InitLimit( 2, 2 )		
			:OnSpawnGroup(
				function( SpawnGroup )						
					USAEFSEADGROUPNAME = SpawnGroup.GroupName
					USAEFSEADGROUP = GROUP:FindByName(SpawnGroup.GroupName)							
					
					local DepartureZoneVec2 = SpawnZone:GetVec2()
					local TargetZoneVec2 	= DestinationZone:GetVec2()
					local WP0X = DepartureZoneVec2.x
					local WP0Y = DepartureZoneVec2.y
					
					local WP1X = DepartureZoneVec2.x + 1000
					local WP1Y = DepartureZoneVec2.y 
					
					local WP2X = TargetZoneVec2.x
					local WP2Y = TargetZoneVec2.y
					
					local WP3X = DepartureZoneVec2.x
					local WP3Y = DepartureZoneVec2.y				
								
							--////SEAD Mission Profile, Engage Targets Along Route Within 50km
							Mission = {
								["id"] = "Mission",
								["params"] = {		
									["route"] = 
									{
										["points"] = 
										{
											[1] = 
											{
												["alt"] = 6000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 219.44444444444,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 0,
												["ETA_locked"] = true,
												["y"] = WP0Y,
												["x"] = WP0X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [1]
											[2] = 
											{
												["alt"] = 6000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 219.44444444444,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
															[1] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 1,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "EPLRS",
																		["params"] = 
																		{
																			["value"] = true,
																			["groupId"] = 0,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [1]
															[2] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "EngageTargets",
																["number"] = 2,
																["params"] = 
																{
																	["targetTypes"] = 
																	{
																		[1] = "Air Defence",
																	}, -- end of ["targetTypes"]
																	["priority"] = 0,
																	["value"] = "Air Defence;",
																	["noTargetTypes"] = 
																	{
																	}, -- end of ["noTargetTypes"]
																	["maxDistEnabled"] = true,
																	["maxDist"] = 50000,
																}, -- end of ["params"]
															}, -- end of [2]
															[3] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 3,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = 2,
																			["name"] = 1,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [3]
															[4] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 4,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = 4161536,
																			["name"] = 10,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [4]
															[5] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 5,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = true,
																			["name"] = 19,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [5]
															[6] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 6,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["variantIndex"] = 1,
																			["name"] = 5,
																			["formationIndex"] = 6,
																			["value"] = 393217,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [6]
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 56.032485482896,
												["ETA_locked"] = false,
												["y"] = WP1Y,
												["x"] = WP1X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [2]
											[3] = 
											{
												["alt"] = 6000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 219.44444444444,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 507.63523208217,
												["ETA_locked"] = false,
												["y"] = WP2Y,
												["x"] = WP2X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [3]
											[4] = 
											{
												["alt"] = 6000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 219.44444444444,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 957.4992496166,
												["ETA_locked"] = false,
												["y"] = WP3Y,
												["x"] = WP3X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [4]
										}, -- end of ["points"]
									}, -- end of ["route"]
								}, --end of ["params"]
							}--end of Mission				
					USAEFSEADGROUP:SetTask(Mission)				
				end
			)
		if ( DepartureAirbaseName == "Ramat David" ) then
			USAEFSEAD:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot, nil, AIRBASE.TerminalType.OpenBig )
		else
			USAEFSEAD:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
		end		
		--:SpawnInZone( SpawnZone, false, 6000, 6000 )
		--:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
		--:SpawnAtAirbase( AIRBASE:FindByName( "Ramat David" ), SPAWN.Takeoff.Hot, nil, AIRBASE.TerminalType.OpenBig )
		trigger.action.outText("SEAD Mission Launched",15)	
	end	
end

function SEF_USAEFCASSPAWN(DepartureAirbaseName, DestinationAirbaseName)
	
	if ( GROUP:FindByName(USAEFCASGROUPNAME) ~= nil and GROUP:FindByName(USAEFCASGROUPNAME):IsAlive() ) then
		trigger.action.outText("Close Air Support Is Currently Active, Further Support Is Unavailable",15)	
	else		
		USAEFCAS_DATA[1].Vec2 = nil
		USAEFCAS_DATA[1].TimeStamp = nil
		USAEFCAS_DATA[2].Vec2 = nil
		USAEFCAS_DATA[2].TimeStamp = nil
		
		local SpawnZone = AIRBASE:FindByName(DepartureAirbaseName):GetZone()
		local DestinationZone = AIRBASE:FindByName(DestinationAirbaseName):GetZone()	
		
		USAEFCAS = SPAWN
			:New("USAEF A-10C")
			:InitLimit( 2, 2 )		
			:OnSpawnGroup(
				function( SpawnGroup )						
					USAEFCASGROUPNAME = SpawnGroup.GroupName
					USAEFCASGROUP = GROUP:FindByName(SpawnGroup.GroupName)							
					
					local DepartureZoneVec2 = SpawnZone:GetVec2()
					local TargetZoneVec2 	= DestinationZone:GetVec2()
					local WP0X = DepartureZoneVec2.x
					local WP0Y = DepartureZoneVec2.y
					
					local WP1X = DepartureZoneVec2.x + 1000
					local WP1Y = DepartureZoneVec2.y
					
					--Orbit Start Point (offset Y to 12.5km West of the zone midpoint)
					local WP2X = TargetZoneVec2.x
					local WP2Y = TargetZoneVec2.y - 12500
					
					--Orbit End Point (offset Y to 12.5km East of the zone midpoint)
					local WP3X = TargetZoneVec2.x
					local WP3Y = TargetZoneVec2.y + 12500
					
					local WP4X = DepartureZoneVec2.x
					local WP4Y = DepartureZoneVec2.y				
								
							--////SEAD Mission Profile, Engage Targets Along Route Within 50km
							Mission = {
								["id"] = "Mission",
								["params"] = {		
									["route"] = 
									{
										["points"] = 
										{
											[1] = 
											{
												["alt"] = 3500,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["properties"] = 
												{
													["vnav"] = 1,
													["scale"] = 0,
													["vangle"] = 0,
													["angle"] = 0,
													["steer"] = 2,
												}, -- end of ["properties"]
												["speed"] = 155.55555555556,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 0,
												["ETA_locked"] = true,
												["y"] = WP0Y,
												["x"] = WP0X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [1]
											[2] = 
											{
												["alt"] = 3500,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["properties"] = 
												{
													["vnav"] = 1,
													["scale"] = 0,
													["vangle"] = 0,
													["angle"] = 0,
													["steer"] = 2,
												}, -- end of ["properties"]
												["speed"] = 155.55555555556,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
															[1] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 1,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "EPLRS",
																		["params"] = 
																		{
																			["value"] = true,
																			["groupId"] = 0,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [1]
															[2] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "EngageTargets",
																["number"] = 2,
																["params"] = 
																{
																	["targetTypes"] = 
																	{
																		[1] = "All",
																	}, -- end of ["targetTypes"]
																	["priority"] = 0,
																	["value"] = "All;",
																	["noTargetTypes"] = 
																	{
																	}, -- end of ["noTargetTypes"]
																	["maxDistEnabled"] = true,
																	["maxDist"] = 25000,
																}, -- end of ["params"]
															}, -- end of [2]
															[3] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 3,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = 2,
																			["name"] = 1,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [3]
															[4] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 4,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = true,
																			["name"] = 15,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [4]
															[5] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 5,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = true,
																			["name"] = 19,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [5]
															[6] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 6,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["variantIndex"] = 1,
																			["name"] = 5,
																			["formationIndex"] = 6,
																			["value"] = 393217,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [6]
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 50.97769941928,
												["ETA_locked"] = false,
												["y"] = WP1Y,
												["x"] = WP1X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [2]
											[3] = 
											{
												["alt"] = 2000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["properties"] = 
												{
													["vnav"] = 1,
													["scale"] = 0,
													["vangle"] = 0,
													["angle"] = 0,
													["steer"] = 2,
												}, -- end of ["properties"]
												["speed"] = 155.55555555556,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
															[1] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "ControlledTask",
																["number"] = 1,
																["params"] = 
																{
																	["task"] = 
																	{
																		["id"] = "Orbit",
																		["params"] = 
																		{
																			["altitude"] = 3500,
																			["pattern"] = "Race-Track",
																			["speed"] = 155.55555555556,
																			["speedEdited"] = true,
																		}, -- end of ["params"]
																	}, -- end of ["task"]
																	["stopCondition"] = 
																	{
																		["duration"] = 900,
																	}, -- end of ["stopCondition"]
																}, -- end of ["params"]
															}, -- end of [1]
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 265.03232675467,
												["ETA_locked"] = false,
												["y"] = WP2Y,
												["x"] = WP2X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [3]
											[4] = 
											{
												["alt"] = 2000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["properties"] = 
												{
													["vnav"] = 1,
													["scale"] = 0,
													["vangle"] = 0,
													["angle"] = 0,
													["steer"] = 2,
												}, -- end of ["properties"]
												["speed"] = 155.55555555556,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 349.12890903278,
												["ETA_locked"] = false,
												["y"] = WP3Y,
												["x"] = WP3X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [4]
											[5] = 
											{
												["alt"] = 3500,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["properties"] = 
												{
													["vnav"] = 1,
													["scale"] = 0,
													["vangle"] = 0,
													["angle"] = 0,
													["steer"] = 2,
												}, -- end of ["properties"]
												["speed"] = 155.55555555556,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 564.44241411897,
												["ETA_locked"] = false,
												["y"] = WP4Y,
												["x"] = WP4X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [5]
										}, -- end of ["points"]
									}, -- end of ["route"]
								}, --end of ["params"]
							}--end of Mission				
					USAEFCASGROUP:SetTask(Mission)				
				end
			)
		if ( DepartureAirbaseName == "Ramat David" ) then
			USAEFCAS:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot, nil, AIRBASE.TerminalType.OpenBig )
		else
			USAEFCAS:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
		end
		--:SpawnInZone( SpawnZone, false, 3500, 3500 )
		--:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )		
		trigger.action.outText("Close Air Support Mission Launched",15)	
	end
end

function SEF_USAEFASSSPAWN(DepartureAirbaseName, DestinationAirbaseName)
	
	if ( GROUP:FindByName(USAEFASSGROUPNAME) ~= nil and GROUP:FindByName(USAEFASSGROUPNAME):IsAlive() ) then
		trigger.action.outText("Anti-Shipping Support Is Currently Active, Further Support Is Unavailable",15)	
	else
		USAEFASS_DATA[1].Vec2 = nil
		USAEFASS_DATA[1].TimeStamp = nil
		USAEFASS_DATA[2].Vec2 = nil
		USAEFASS_DATA[2].TimeStamp = nil
		
		local SpawnZone = AIRBASE:FindByName(DepartureAirbaseName):GetZone()
		local DestinationZone = AIRBASE:FindByName(DestinationAirbaseName):GetZone()	
		
		USAEFASS = SPAWN
			:New("USAEF F/A-18C")
			:InitLimit( 2, 2 )					
			:OnSpawnGroup(
				function( SpawnGroup )						
					USAEFASSGROUPNAME = SpawnGroup.GroupName
					USAEFASSGROUP = GROUP:FindByName(SpawnGroup.GroupName)							
					
					local DepartureZoneVec2 = SpawnZone:GetVec2()
					local TargetZoneVec2 	= DestinationZone:GetVec2()
					--Spawn Point
					local WP0X = DepartureZoneVec2.x
					local WP0Y = DepartureZoneVec2.y
					--Initialisation Point
					local WP1X = DepartureZoneVec2.x + 1000
					local WP1Y = DepartureZoneVec2.y 
					--Ingress Point
					local WP2X = TargetZoneVec2.x - 50000
					local WP2Y = TargetZoneVec2.y
					--Target Zone Flyover Point
					local WP3X = TargetZoneVec2.x
					local WP3Y = TargetZoneVec2.y
					--Return Point
					local WP4X = DepartureZoneVec2.x
 					local WP4Y = DepartureZoneVec2.y
								
							--////Anti-Ship Mission Profile, Standard Anti-Ship Behaviour At Ingress Point
							Mission = {
								["id"] = "Mission",
								["params"] = {		
									["route"] = {
										["points"] = {
											[1] = 
											{
												["alt"] = 3000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 231.59317779244,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 0,
												["ETA_locked"] = true,
												["y"] = WP0Y,
												["x"] = WP0X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [1]
											[2] = 
											{
												["alt"] = 3000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 231.59317779244,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
															[1] = 
															{
																["number"] = 1,
																["auto"] = false,
																["id"] = "WrappedAction",
																["enabled"] = true,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "EPLRS",
																		["params"] = 
																		{
																			["value"] = true,
																			["groupId"] = 0,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [1]
															[2] = 
															{
																["number"] = 2,
																["auto"] = false,
																["id"] = "WrappedAction",
																["enabled"] = true,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = 2,
																			["name"] = 1,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [2]
															[3] = 
															{
																["number"] = 3,
																["auto"] = false,
																["id"] = "WrappedAction",
																["enabled"] = true,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = true,
																			["name"] = 15,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [3]
															[4] = 
															{
																["number"] = 4,
																["auto"] = false,
																["id"] = "WrappedAction",
																["enabled"] = true,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = 65536,
																			["name"] = 10,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [4]
															[5] = 
															{
																["number"] = 5,
																["auto"] = false,
																["id"] = "WrappedAction",
																["enabled"] = true,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = true,
																			["name"] = 19,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [5]
															[6] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 6,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["variantIndex"] = 1,
																			["name"] = 5,
																			["formationIndex"] = 6,
																			["value"] = 393217,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [6]
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 7.8583458925594,
												["ETA_locked"] = false,
												["y"] = WP1Y,
												["x"] = WP1X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [2]
											[3] = 
											{
												["alt"] = 3000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 231.59317779244,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
															[1] = 
															{
																["number"] = 1,
																["key"] = "AntiShip",
																["id"] = "EngageTargets",
																["auto"] = false,
																["enabled"] = true,
																["params"] = 
																{
																	["targetTypes"] = 
																	{
																		[1] = "Ships",
																	}, -- end of ["targetTypes"]
																	["priority"] = 0,
																}, -- end of ["params"]
															}, -- end of [1]
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 32.788983863136,
												["ETA_locked"] = false,
												["y"] = WP2Y,
												["x"] = WP2X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [3]
											[4] = 
											{
												["alt"] = 3000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 231.59317779244,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 70.734853282445,
												["ETA_locked"] = false,
												["y"] = WP3Y,
												["x"] = WP3X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [4]
											[5] = 
											{
												["alt"] = 3000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 231.59317779244,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 136.09696113708,
												["ETA_locked"] = false,
												["y"] = WP4Y,
												["x"] = WP4X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [5]
										}, -- end of ["points"]
									}, -- end of ["route"]
								}, --end of ["params"]
							}--end of Mission				
					USAEFASSGROUP:SetTask(Mission)				
				end
			)
		if ( DepartureAirbaseName == "Ramat David" ) then
			USAEFASS:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot, nil, AIRBASE.TerminalType.OpenBig )
		else
			USAEFASS:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
		end
		--:SpawnInZone( SpawnZone, false, 3000, 3000 )
		--:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
		trigger.action.outText("Anti-Shipping Mission Launched",15)	
	end
end

function SEF_USAEFPINSPAWN(DepartureAirbaseName, DestinationAirbaseName)
	
	if ( GROUP:FindByName(USAEFPINGROUPNAME) ~= nil and GROUP:FindByName(USAEFPINGROUPNAME):IsAlive() ) then
		trigger.action.outText("Pinpoint Strike Support Is Currently Active, Further Support Is Unavailable",15)	
	else
		USAEFPIN_DATA[1].Vec2 = nil
		USAEFPIN_DATA[1].TimeStamp = nil
		USAEFPIN_DATA[2].Vec2 = nil
		USAEFPIN_DATA[2].TimeStamp = nil
		
		local SpawnZone = AIRBASE:FindByName(DepartureAirbaseName):GetZone()
		local DestinationZone = AIRBASE:FindByName(DestinationAirbaseName):GetZone()	
		
		local TypeSelection = math.random(1,3)
		
		if ( TypeSelection == 1 ) then		
			USAEFPIN = SPAWN
				:New("USAEF F-15E")			
				:InitLimit( 2, 2 )				
				:OnSpawnGroup(
					function( SpawnGroup )						
						USAEFPINGROUPNAME = SpawnGroup.GroupName
						USAEFPINGROUP = GROUP:FindByName(SpawnGroup.GroupName)							
						
						local DepartureZoneVec2 = SpawnZone:GetVec2()
						local TargetZoneVec2 	= DestinationZone:GetVec2()
						
						--Spawn Point
						local WP0X = DepartureZoneVec2.x
						local WP0Y = DepartureZoneVec2.y
						
						--WP1
						local WP1X = DepartureZoneVec2.x + 1000
						local WP1Y = DepartureZoneVec2.y 
						
						--Target Acquisition Point --Offset from Target Vector By 25km
						local WP2X = TargetZoneVec2.x - 25000
						local WP2Y = TargetZoneVec2.y
						
						--Target Flyover Point
						local WP3X = TargetZoneVec2.x
						local WP3Y = TargetZoneVec2.y

						--Return Point	
						local WP4X = DepartureZoneVec2.x
						local WP4Y = DepartureZoneVec2.y		
									
								--////Anti-Ship Mission Profile, Standard Anti-Ship Behaviour
								Mission = {
									["id"] = "Mission",
									["params"] = {		
										["route"] = {
											["points"] = {
												[1] = {
													["alt"] = 5000,
													["action"] = "Turning Point",
													["alt_type"] = "BARO",
													["speed"] = 242.16987839118,
													["task"] = 
													{
														["id"] = "ComboTask",
														["params"] = 
														{
															["tasks"] = 
															{
															}, -- end of ["tasks"]
														}, -- end of ["params"]
													}, -- end of ["task"]
													["type"] = "Turning Point",
													["ETA"] = 0,
													["ETA_locked"] = true,
													["y"] = WP0Y,
													["x"] = WP0X,
													["formation_template"] = "",
													["speed_locked"] = true,
												}, -- end of [1]
												[2] = 
												{
													["alt"] = 5000,
													["action"] = "Turning Point",
													["alt_type"] = "BARO",
													["speed"] = 242.16987839118,
													["task"] = 
													{
														["id"] = "ComboTask",
														["params"] = 
														{
															["tasks"] = 
															{
																[1] = 
																{
																	["enabled"] = true,
																	["auto"] = false,
																	["id"] = "WrappedAction",
																	["number"] = 1,
																	["params"] = 
																	{
																		["action"] = 
																		{
																			["id"] = "EPLRS",
																			["params"] = 
																			{
																				["value"] = true,
																				["groupId"] = 0,
																			}, -- end of ["params"]
																		}, -- end of ["action"]
																	}, -- end of ["params"]
																}, -- end of [1]
																[2] = 
																{
																	["enabled"] = true,
																	["auto"] = false,
																	["id"] = "WrappedAction",
																	["number"] = 2,
																	["params"] = 
																	{
																		["action"] = 
																		{
																			["id"] = "Option",
																			["params"] = 
																			{
																				["value"] = 2,
																				["name"] = 1,
																			}, -- end of ["params"]
																		}, -- end of ["action"]
																	}, -- end of ["params"]
																}, -- end of [2]
																[3] = 
																{
																	["enabled"] = true,
																	["auto"] = false,
																	["id"] = "WrappedAction",
																	["number"] = 3,
																	["params"] = 
																	{
																		["action"] = 
																		{
																			["id"] = "Option",
																			["params"] = 
																			{
																				["value"] = true,
																				["name"] = 15,
																			}, -- end of ["params"]
																		}, -- end of ["action"]
																	}, -- end of ["params"]
																}, -- end of [3]
																[4] = 
																{
																	["enabled"] = true,
																	["auto"] = false,
																	["id"] = "WrappedAction",
																	["number"] = 4,
																	["params"] = 
																	{
																		["action"] = 
																		{
																			["id"] = "Option",
																			["params"] = 
																			{
																				["value"] = 14,
																				["name"] = 10,
																			}, -- end of ["params"]
																		}, -- end of ["action"]
																	}, -- end of ["params"]
																}, -- end of [4]
																[5] = 
																{
																	["enabled"] = true,
																	["auto"] = false,
																	["id"] = "WrappedAction",
																	["number"] = 5,
																	["params"] = 
																	{
																		["action"] = 
																		{
																			["id"] = "Option",
																			["params"] = 
																			{
																				["value"] = true,
																				["name"] = 19,
																			}, -- end of ["params"]
																		}, -- end of ["action"]
																	}, -- end of ["params"]
																}, -- end of [5]
																[6] = 
																{
																	["enabled"] = true,
																	["auto"] = false,
																	["id"] = "WrappedAction",
																	["number"] = 6,
																	["params"] = 
																	{
																		["action"] = 
																		{
																			["id"] = "Option",
																			["params"] = 
																			{
																				["variantIndex"] = 1,
																				["name"] = 5,
																				["formationIndex"] = 6,
																				["value"] = 393217,
																			}, -- end of ["params"]
																		}, -- end of ["action"]
																	}, -- end of ["params"]
																}, -- end of [6]
															}, -- end of ["tasks"]
														}, -- end of ["params"]
													}, -- end of ["task"]
													["type"] = "Turning Point",
													["ETA"] = 5.9436704052568,
													["ETA_locked"] = false,
													["y"] = WP1Y,
													["x"] = WP1X,
													["formation_template"] = "",
													["speed_locked"] = true,
												}, -- end of [2]
												[3] = 
												{
													["alt"] = 5000,
													["action"] = "Turning Point",
													["alt_type"] = "BARO",
													["speed"] = 242.16987839118,
													["task"] = 
													{
														["id"] = "ComboTask",
														["params"] = 
														{
															["tasks"] = 
															{
																[1] = 
																{
																	["enabled"] = true,
																	["auto"] = false,
																	["id"] = "WrappedAction",
																	["number"] = 1,
																	["params"] = 
																	{
																		["action"] = 
																		{
																			["id"] = "Script",
																			["params"] = 
																			{
																				["command"] = "SEF_PinpointStrikeTargetAcquisition()",
																			}, -- end of ["params"]
																		}, -- end of ["action"]
																	}, -- end of ["params"]
																}, -- end of [1]
															}, -- end of ["tasks"]
														}, -- end of ["params"]
													}, -- end of ["task"]
													["type"] = "Turning Point",
													["ETA"] = 29.768321504821,
													["ETA_locked"] = false,
													["y"] = WP2Y,
													["x"] = WP2X,
													["formation_template"] = "",
													["speed_locked"] = true,
												}, -- end of [3]
												[4] = 
												{
													["alt"] = 5000,
													["action"] = "Turning Point",
													["alt_type"] = "BARO",
													["speed"] = 242.16987839118,
													["task"] = 
													{
														["id"] = "ComboTask",
														["params"] = 
														{
															["tasks"] = 
															{
															}, -- end of ["tasks"]
														}, -- end of ["params"]
													}, -- end of ["task"]
													["type"] = "Turning Point",
													["ETA"] = 67.432273852435,
													["ETA_locked"] = false,
													["y"] = WP3Y,
													["x"] = WP3X,
													["formation_template"] = "",
													["speed_locked"] = true,
												}, -- end of [4]
												[5] = 
												{
													["alt"] = 5000,
													["action"] = "Turning Point",
													["alt_type"] = "BARO",
													["speed"] = 242.16987839118,
													["task"] = 
													{
														["id"] = "ComboTask",
														["params"] = 
														{
															["tasks"] = 
															{
															}, -- end of ["tasks"]
														}, -- end of ["params"]
													}, -- end of ["task"]
													["type"] = "Turning Point",
													["ETA"] = 131.71119538513,
													["ETA_locked"] = false,
													["y"] = WP4Y,
													["x"] = WP4X,
													["formation_template"] = "",
													["speed_locked"] = true,
												}, -- end of [5]
											}, -- end of ["points"]
										}, -- end of ["route"]
									}, --end of ["params"]
								}--end of Mission				
						USAEFPINGROUP:SetTask(Mission)				
					end
				)
			if ( DepartureAirbaseName == "Ramat David" ) then
				USAEFPIN:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot, nil, AIRBASE.TerminalType.OpenBig )
			else
				USAEFPIN:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
			end
			--:SpawnInZone( SpawnZone, false, 5000, 5000 )
			--:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
		elseif ( TypeSelection == 2 ) then		
			USAEFPIN = SPAWN
			:New("USAEF F-117A")			
			:InitLimit( 2, 2 )			
			:OnSpawnGroup(
				function( SpawnGroup )						
					USAEFPINGROUPNAME = SpawnGroup.GroupName
					USAEFPINGROUP = GROUP:FindByName(SpawnGroup.GroupName)							
					
					local DepartureZoneVec2 = SpawnZone:GetVec2()
					local TargetZoneVec2 	= DestinationZone:GetVec2()
					
					--Spawn Point
					local WP0X = DepartureZoneVec2.x
					local WP0Y = DepartureZoneVec2.y
					
					--WP1
					local WP1X = DepartureZoneVec2.x + 1000
					local WP1Y = DepartureZoneVec2.y 
					
					--Target Acquisition Point --Offset from Target Vector By 25km
					local WP2X = TargetZoneVec2.x - 25000
					local WP2Y = TargetZoneVec2.y
					
					--Target Flyover Point
					local WP3X = TargetZoneVec2.x
					local WP3Y = TargetZoneVec2.y

					--Return Point	
					local WP4X = DepartureZoneVec2.x
					local WP4Y = DepartureZoneVec2.y		
								
							--////Anti-Ship Mission Profile, Standard Anti-Ship Behaviour
							Mission = {
								["id"] = "Mission",
								["params"] = {		
									["route"] = {
										["points"] = {
											[1] = {
												["alt"] = 5000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 242.16987839118,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 0,
												["ETA_locked"] = true,
												["y"] = WP0Y,
												["x"] = WP0X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [1]
											[2] = 
											{
												["alt"] = 5000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 242.16987839118,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
															[1] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 1,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "EPLRS",
																		["params"] = 
																		{
																			["value"] = true,
																			["groupId"] = 0,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [1]
															[2] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 2,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = 2,
																			["name"] = 1,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [2]
															[3] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 3,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = true,
																			["name"] = 15,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [3]
															[4] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 4,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = 14,
																			["name"] = 10,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [4]
															[5] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 5,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = true,
																			["name"] = 19,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [5]
															[6] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 6,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["variantIndex"] = 1,
																			["name"] = 5,
																			["formationIndex"] = 6,
																			["value"] = 393217,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [6]
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 5.9436704052568,
												["ETA_locked"] = false,
												["y"] = WP1Y,
												["x"] = WP1X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [2]
											[3] = 
											{
												["alt"] = 5000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 242.16987839118,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
															[1] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 1,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Script",
																		["params"] = 
																		{
																			["command"] = "SEF_PinpointStrikeTargetAcquisition()",
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [1]
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 29.768321504821,
												["ETA_locked"] = false,
												["y"] = WP2Y,
												["x"] = WP2X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [3]
											[4] = 
											{
												["alt"] = 5000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 242.16987839118,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 67.432273852435,
												["ETA_locked"] = false,
												["y"] = WP3Y,
												["x"] = WP3X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [4]
											[5] = 
											{
												["alt"] = 5000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 242.16987839118,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 131.71119538513,
												["ETA_locked"] = false,
												["y"] = WP4Y,
												["x"] = WP4X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [5]
										}, -- end of ["points"]
									}, -- end of ["route"]
								}, --end of ["params"]
							}--end of Mission				
					USAEFPINGROUP:SetTask(Mission)				
				end
			)
			if ( DepartureAirbaseName == "Ramat David" ) then
				USAEFPIN:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot, nil, AIRBASE.TerminalType.OpenBig )
			else
				USAEFPIN:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
			end
			--:SpawnInZone( SpawnZone, false, 5000, 5000 )
			--:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
		else		
			USAEFPIN = SPAWN
			:New("RAF Tornado GR4")			
			:InitLimit( 2, 2 )			
			:OnSpawnGroup(
				function( SpawnGroup )						
					USAEFPINGROUPNAME = SpawnGroup.GroupName
					USAEFPINGROUP = GROUP:FindByName(SpawnGroup.GroupName)							
					
					local DepartureZoneVec2 = SpawnZone:GetVec2()
					local TargetZoneVec2 	= DestinationZone:GetVec2()
					
					--Spawn Point
					local WP0X = DepartureZoneVec2.x
					local WP0Y = DepartureZoneVec2.y
					
					--WP1
					local WP1X = DepartureZoneVec2.x + 1000
					local WP1Y = DepartureZoneVec2.y 
					
					--Target Acquisition Point --Offset from Target Vector By 25km
					local WP2X = TargetZoneVec2.x - 25000
					local WP2Y = TargetZoneVec2.y
					
					--Target Flyover Point
					local WP3X = TargetZoneVec2.x
					local WP3Y = TargetZoneVec2.y

					--Return Point	
					local WP4X = DepartureZoneVec2.x
					local WP4Y = DepartureZoneVec2.y		
								
							--////Anti-Ship Mission Profile, Standard Anti-Ship Behaviour
							Mission = {
								["id"] = "Mission",
								["params"] = {		
									["route"] = {
										["points"] = {
											[1] = {
												["alt"] = 5000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 242.16987839118,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 0,
												["ETA_locked"] = true,
												["y"] = WP0Y,
												["x"] = WP0X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [1]
											[2] = 
											{
												["alt"] = 5000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 242.16987839118,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
															[1] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 1,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "EPLRS",
																		["params"] = 
																		{
																			["value"] = true,
																			["groupId"] = 0,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [1]
															[2] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 2,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = 2,
																			["name"] = 1,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [2]
															[3] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 3,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = true,
																			["name"] = 15,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [3]
															[4] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 4,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = 14,
																			["name"] = 10,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [4]
															[5] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 5,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = true,
																			["name"] = 19,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [5]
															[6] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 6,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["variantIndex"] = 1,
																			["name"] = 5,
																			["formationIndex"] = 6,
																			["value"] = 393217,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [6]
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 5.9436704052568,
												["ETA_locked"] = false,
												["y"] = WP1Y,
												["x"] = WP1X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [2]
											[3] = 
											{
												["alt"] = 5000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 242.16987839118,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
															[1] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 1,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Script",
																		["params"] = 
																		{
																			["command"] = "SEF_PinpointStrikeTargetAcquisition()",
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [1]
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 29.768321504821,
												["ETA_locked"] = false,
												["y"] = WP2Y,
												["x"] = WP2X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [3]
											[4] = 
											{
												["alt"] = 5000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 242.16987839118,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 67.432273852435,
												["ETA_locked"] = false,
												["y"] = WP3Y,
												["x"] = WP3X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [4]
											[5] = 
											{
												["alt"] = 5000,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 242.16987839118,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 131.71119538513,
												["ETA_locked"] = false,
												["y"] = WP4Y,
												["x"] = WP4X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [5]
										}, -- end of ["points"]
									}, -- end of ["route"]
								}, --end of ["params"]
							}--end of Mission				
					USAEFPINGROUP:SetTask(Mission)				
				end
			)
			if ( DepartureAirbaseName == "Ramat David" ) then
				USAEFPIN:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot, nil, AIRBASE.TerminalType.OpenBig )
			else
				USAEFPIN:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
			end
			--:SpawnInZone( SpawnZone, false, 5000, 5000 )
			--:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
		end		
		trigger.action.outText("Pinpoint Strike Mission Launched",15)	
	end
end

function SEF_USAEFDRONESPAWN(DepartureAirbaseName, DestinationAirbaseName)
	
	if ( GROUP:FindByName(USAEFDRONEGROUPNAME) ~= nil and GROUP:FindByName(USAEFDRONEGROUPNAME):IsAlive() ) then
		trigger.action.outText("MQ-9 Aerial Drone Is Currently Active, Further Support Is Unavailable",15)	
	else
		USAEFDRONE_DATA[1].Vec2 = nil
		USAEFDRONE_DATA[1].TimeStamp = nil
		
		local SpawnZone = AIRBASE:FindByName(DepartureAirbaseName):GetZone()
		local DestinationZone = AIRBASE:FindByName(DestinationAirbaseName):GetZone()	
		local TargetZoneVec2Point = DestinationZone:GetVec2()
		local SpawnX = TargetZoneVec2Point.x - 10000
		local SpawnY = TargetZoneVec2Point.y		
		local DroneStartVec3 = { x = SpawnX, y = 6448, z = SpawnY }
		
		USAEFDRONE = SPAWN
			:New("USAEF MQ-9 Aerial Drone")
			:InitLimit( 1, 1 )		
			:OnSpawnGroup(
				function( SpawnGroup )						
					USAEFDRONEGROUPNAME = SpawnGroup.GroupName
					USAEFDRONEGROUP = GROUP:FindByName(SpawnGroup.GroupName)							
					
					local DepartureZoneVec2 = SpawnZone:GetVec2()
					local TargetZoneVec2 	= DestinationZone:GetVec2()
					
					local WP0X = TargetZoneVec2.x - 10000
					local WP0Y = TargetZoneVec2.y
										
					local WP1X = WP0X + 1000
					local WP1Y = WP0Y					
					
					--Orbit Start Point
					local WP2X = TargetZoneVec2.x
					local WP2Y = TargetZoneVec2.y								
								
							--////Aerial Drone Mission Profile, Orbit Target Zone For 4 Hours
							Mission = {
								["id"] = "Mission",
								["params"] = {		
									["route"] = 
									{
										["points"] = 
										{
											[1] = 
											{
												["alt"] = 6448,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 86.9444,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 0,
												["ETA_locked"] = true,
												["y"] = WP0Y,
												["x"] = WP0X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [1]
											[2] = 
											{
												["alt"] = 6448,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 86.9444,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
															[1] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "FAC",
																["number"] = 1,
																["params"] = 
																{
																	["number"] = 9,
																	["designation"] = "Auto",
																	["modulation"] = 0,
																	["callname"] = 8,
																	["datalink"] = true,
																	["frequency"] = 272000000,
																}, -- end of ["params"]
															}, -- end of [1]
															[2] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 2,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "EPLRS",
																		["params"] = 
																		{
																			["value"] = true,
																			["groupId"] = 0,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [2]
															[3] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 3,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "SetInvisible",
																		["params"] = 
																		{
																			["value"] = true,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [3]
															[4] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "WrappedAction",
																["number"] = 4,
																["params"] = 
																{
																	["action"] = 
																	{
																		["id"] = "Option",
																		["params"] = 
																		{
																			["value"] = 0,
																			["name"] = 1,
																		}, -- end of ["params"]
																	}, -- end of ["action"]
																}, -- end of ["params"]
															}, -- end of [4]
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 53.765858988616,
												["ETA_locked"] = false,
												["y"] = WP1Y,
												["x"] = WP1X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [2]
											[3] = 
											{
												["alt"] = 6448,
												["action"] = "Turning Point",
												["alt_type"] = "BARO",
												["speed"] = 86.9444,
												["task"] = 
												{
													["id"] = "ComboTask",
													["params"] = 
													{
														["tasks"] = 
														{
															[1] = 
															{
																["enabled"] = true,
																["auto"] = false,
																["id"] = "ControlledTask",
																["number"] = 1,
																["params"] = 
																{
																	["task"] = 
																	{
																		["id"] = "Orbit",
																		["params"] = 
																		{
																			["altitude"] = 6448,
																			["pattern"] = "Circle",
																			["speed"] = 66.111111111111,
																			["speedEdited"] = true,
																		}, -- end of ["params"]
																	}, -- end of ["task"]
																	["stopCondition"] = 
																	{
																		["duration"] = 14400,
																	}, -- end of ["stopCondition"]
																}, -- end of ["params"]
															}, -- end of [1]
														}, -- end of ["tasks"]
													}, -- end of ["params"]
												}, -- end of ["task"]
												["type"] = "Turning Point",
												["ETA"] = 269.74317967324,
												["ETA_locked"] = false,
												["y"] = WP2Y,
												["x"] = WP2X,
												["formation_template"] = "",
												["speed_locked"] = true,
											}, -- end of [3]
										}, -- end of ["points"]
									}, -- end of ["route"]
								}, --end of ["params"]
							}--end of Mission				
					USAEFDRONEGROUP:SetTask(Mission)				
				end
			)
		--:SpawnInZone( SpawnZone, false, 6448, 6448 )
		:SpawnFromVec3( DroneStartVec3 )
		--SPAWN:SpawnFromVec3(Vec3, SpawnIndex) --Vec3 point to spawn at(just south of target group) SpawnIndex is optional
		trigger.action.outText("MQ-9 Aerial Drone Launched",15)	
	end
end

--////End Support Functions
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////Radio Menu 

function SEF_RadioMenuSetup()
	--////Set Up Menu
	-- table missionCommands.addSubMenuForCoalition(enum coalition.side, string name , table path)
	-- table missionCommands.addCommand(string name, table/nil path, function functionToRun , any anyArguement)
	-- table missionCommands.addCommandForCoalition(enum coalition.side, string name, table/nil path, function functionToRun , any anyArguement)
   
    --////Setup Top Level Menus
   
   DynamicZoneMain = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Dynamic Zone", nil)
   
   --BFMACMMENU = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "BFM/ACM Options", nil)

	--////Setup Submenu For Support Requests
			SupportMenuMain = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request Support", DynamicZoneMain)
	SupportMenuAbort = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Abort Support", DynamicZoneMain)
	SupportMenuCAP  = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request Fighter Support", SupportMenuMain)
	SupportMenuCAS  = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request Close Air Support", SupportMenuMain)
	SupportMenuSEAD = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request SEAD Support", SupportMenuMain)
	SupportMenuASS = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request Anti-Shipping Support", SupportMenuMain)
	SupportMenuPIN = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request Pinpoint Strike", SupportMenuMain)
	SupportMenuDRONE = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request MQ-9 Reaper Drone", SupportMenuMain)
	
		--////Objective Options
  ObjectiveInfo = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Objective Info", DynamicZoneMain)
  missionCommands.addCommandForCoalition(coalition.side.BLUE, "Check Current Objective", ObjectiveInfo, function() CheckObjectiveRequest() end, nil)
  missionCommands.addCommandForCoalition(coalition.side.BLUE, "Target Report", ObjectiveInfo, function() TargetReport() end, nil)
  missionCommands.addCommandForCoalition(coalition.side.BLUE, "Smoke Current Objective", ObjectiveInfo, function() SEF_TargetSmoke() end, nil)
  --ScarletDawnPhaseCheck  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Check Battle Phase", ObjectiveInfo, function() SEF_BattlePhaseCheck() end, nil)
  ScarletDawnSkipScenario  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Skip This Mission", ObjectiveInfo, function() SEF_SkipScenario() end, nil)
	
	--////AI Support Flights Mission Abort Codes
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission Fighter Screen", SupportMenuAbort, function() AbortCAPMission() end, nil)	
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission Close Air Support", SupportMenuAbort, function() AbortCASMission() end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission Anti-Shipping", SupportMenuAbort, function() AbortASSMission() end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission SEAD", SupportMenuAbort, function() AbortSEADMission() end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission Pinpoint Strike", SupportMenuAbort, function() AbortPINMission() end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission MQ-9 Reaper Drone", SupportMenuAbort, function() AbortDroneMission() end, nil)	
	
	--////Syria Mission Options
	SyriaOptions = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Syria Options", DynamicZoneMain)
	SyriaCAPOptions = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Syria CAP Options", DynamicZoneMain)
	--SyriaSNDOptions = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Syria Sound Options", SyriaOptions)
	SyriaBLUECAPToggle = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Toggle Allied AI CAP Flights", SyriaCAPOptions, function() SEF_BLUESQUADRONSTOGGLE() end, nil)
	SyriaHARDCAPToggle = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Toggle HARD RED CAP Flights", SyriaCAPOptions, function() SEF_HARDSQUADRONSTOGGLE() end, nil)  
	--SyriaToggleCustomSounds = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Toggle Custom Sounds", SyriaSNDOptions, function() SEF_ToggleCustomSounds() end, nil)	
	ScarletDawnClearCarrierFighters  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Clear Carrier Deck Of Fighters", nil, function() SEF_ClearAIFightersFromCarrierDeck() end, nil)
	--ScarletDawnClearCarrierTankers  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Clear Carrier Deck Of Tankers", SyriaOptions, function() SEF_ClearAITankersFromCarrierDeck() end, nil)
	--ScarletDawnPhaseCheck  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Check Battle Phase", SyriaOptions, function() SEF_BattlePhaseCheck() end, nil)
	--ScarletDawnSkipScenario  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Skip This Mission", SyriaOptions, function() SEF_SkipScenario() end, nil)	
  BFMAWACSOptions = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "BFM AWACS Options", nil)
  ProjectCLEARFIGHTERS = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Remove All AI BFM Fighters", BFMAWACSOptions, function() SEF_CLEARALLRED() end, nil)
  ProjectSPAWNBLUEAWACS = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Spawn BFM Blue AWACS", BFMAWACSOptions, function() SEF_SPAWNBLUEAWACS() end, nil)
  ProjectCLEARBLUEAWACS = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Clear BFM Blue AWACS", BFMAWACSOptions, function() SEF_CLEARBLUEAWACS() end, nil)
  ProjectSPAWNREDAWACS = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Spawn BFM Red AWACS", BFMAWACSOptions, function() SEF_SPAWNREDAWACS() end, nil)
  ProjectCLEARREDAWACS = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Clear BFM Redmm AWACS", BFMAWACSOptions, function() SEF_CLEARREDAWACS() end, nil)
		 
	 --////Setup Menu Option To Get The Current Objective
  --ScarletDawnCheckObj = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Check Current Objective", SyriaOptions, function() CheckObjectiveRequest() end, nil)
  --////Target Report to get target numbers and coordinates 
  --ScarletDawnTargetReport = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Target Report", SyriaOptions, function() TargetReport() end, nil)
  --////Drop Smoke On The Target
  --ScarletDawnSmokeObj = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Smoke Current Objective", SyriaOptions, function() SEF_TargetSmoke() end, nil)
  AdminOptions = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Admin Options", DynamicZoneMain)
  RemoveBlueBaseCAP  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Remove BLUE BASECAP", AdminOptions, function() SEF_BASECAP_REMOVE () end, nil)
  RespawnBlueBaseCAP  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Respawn BLUE BASECAP", AdminOptions, function() SEF_BASECAP_RESPAWN () end, nil)
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--////CAP FLIGHTS
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	--SupportMenuCAP_INC = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Departing Incirlik", SupportMenuCAP)
	--SupportMenuCAP_RD = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Departing Ramat David", SupportMenuCAP)
	
	--////CAP Support Sector List
	
	--SupportMenuCAP_INC_Turkey = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Turkish Sectors", SupportMenuCAP_INC)
	--SupportMenuCAP_INC_Isreal = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Israeli Jordanian And Lebanese Sectors", SupportMenuCAP_INC)
	--SupportMenuCAP_INC_North = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Northern And Central Syrian Sectors", SupportMenuCAP_INC)
	--SupportMenuCAP_INC_South = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Southern Syrian Sectors", SupportMenuCAP_INC)
	
	--SupportMenuCAP_RD_Turkey = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Turkish Sectors", SupportMenuCAP_RD)
	SupportMenuCAP_RD_Isreal = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Israeli Jordanian And Lebanese Sectors", SupportMenuCAP) -- removed _RD
  --SupportMenuCAP_RD_North = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Northern And Central Syrian Sectors", SupportMenuCAP_RD)
	SupportMenuCAP_RD_South = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Southern Syrian Sectors", SupportMenuCAP)  -- removed _RD
	
	--////DEPARTING INCIRLIK
	--[[
	--////TURKEY
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Adana Sakirpasa", SupportMenuCAP_INC_Turkey, function() SEF_USAEFCAPSPAWN("Incirlik", "Adana Sakirpasa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Hatay", SupportMenuCAP_INC_Turkey, function() SEF_USAEFCAPSPAWN("Incirlik", "Hatay") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Incirlik", SupportMenuCAP_INC_Turkey, function() SEF_USAEFCAPSPAWN("Incirlik", "Incirlik") end, nil)
	
	--////ISREAL JORDAN LEBANON
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Beirut", SupportMenuCAP_INC_Isreal, function() SEF_USAEFCAPSPAWN("Incirlik", "Beirut-Rafic Hariri") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Eyn Shemer", SupportMenuCAP_INC_Isreal, function() SEF_USAEFCAPSPAWN("Incirlik", "Eyn Shemer") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Haifa", SupportMenuCAP_INC_Isreal, function() SEF_USAEFCAPSPAWN("Incirlik", "Haifa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector King Hussein Air College", SupportMenuCAP_INC_Isreal, function() SEF_USAEFCAPSPAWN("Incirlik", "King Hussein Air College") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kiryat Shmona", SupportMenuCAP_INC_Isreal, function() SEF_USAEFCAPSPAWN("Incirlik", "Kiryat Shmona") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Megiddo", SupportMenuCAP_INC_Isreal, function() SEF_USAEFCAPSPAWN("Incirlik", "Megiddo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ramat David", SupportMenuCAP_INC_Isreal, function() SEF_USAEFCAPSPAWN("Incirlik", "Ramat David") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rayak", SupportMenuCAP_INC_Isreal, function() SEF_USAEFCAPSPAWN("Incirlik", "Rayak") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rene Mouawad", SupportMenuCAP_INC_Isreal, function() SEF_USAEFCAPSPAWN("Incirlik", "Rene Mouawad") end, nil)
	--SupportMenuCAP_INC_IsrealMore = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "More Sectors", SupportMenuCAP_INC_Isreal)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Wujah Al Hajar", SupportMenuCAP_INC_Isreal, function() SEF_USAEFCAPSPAWN("Incirlik", "Wujah Al Hajar") end, nil)
	
	--////NORTHERN AND CENTRAL SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu al-Duhur", SupportMenuCAP_INC_North, function() SEF_USAEFCAPSPAWN("Incirlik", "Abu al-Duhur") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Aleppo", SupportMenuCAP_INC_North, function() SEF_USAEFCAPSPAWN("Incirlik", "Aleppo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al Qusayr", SupportMenuCAP_INC_North, function() SEF_USAEFCAPSPAWN("Incirlik", "Al Qusayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bassel Al-Assad", SupportMenuCAP_INC_North, function() SEF_USAEFCAPSPAWN("Incirlik", "Bassel Al-Assad") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Jirah", SupportMenuCAP_INC_North, function() SEF_USAEFCAPSPAWN("Incirlik", "Jirah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kuweires", SupportMenuCAP_INC_North, function() SEF_USAEFCAPSPAWN("Incirlik", "Kuweires") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minakh", SupportMenuCAP_INC_North, function() SEF_USAEFCAPSPAWN("Incirlik", "Minakh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Taftanaz", SupportMenuCAP_INC_North, function() SEF_USAEFCAPSPAWN("Incirlik", "Taftanaz") end, nil)
	
	--////SOUTHERN SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al-Dumayr", SupportMenuCAP_INC_South, function() SEF_USAEFCAPSPAWN("Incirlik", "Al-Dumayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector An Nasiriyah", SupportMenuCAP_INC_South, function() SEF_USAEFCAPSPAWN("Incirlik", "An Nasiriyah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Damascus", SupportMenuCAP_INC_South, function() SEF_USAEFCAPSPAWN("Incirlik", "Damascus") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Khalkhalah", SupportMenuCAP_INC_South, function() SEF_USAEFCAPSPAWN("Incirlik", "Khalkhalah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan North", SupportMenuCAP_INC_South, function() SEF_USAEFCAPSPAWN("Incirlik", "Marj as Sultan North") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan South", SupportMenuCAP_INC_South, function() SEF_USAEFCAPSPAWN("Incirlik", "Marj as Sultan South") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj Ruhayyil", SupportMenuCAP_INC_South, function() SEF_USAEFCAPSPAWN("Incirlik", "Marj Ruhayyil") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Mezzeh", SupportMenuCAP_INC_South, function() SEF_USAEFCAPSPAWN("Incirlik", "Mezzeh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qabr as Sitt", SupportMenuCAP_INC_South, function() SEF_USAEFCAPSPAWN("Incirlik", "Qabr as Sitt") end, nil)
	]]--
	--////DEPARTING RAMAT DAVID
	--[[
	--////TURKEY
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Adana Sakirpasa", SupportMenuCAP_RD_Turkey, function() SEF_USAEFCAPSPAWN("Ramat David", "Adana Sakirpasa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Hatay", SupportMenuCAP_RD_Turkey, function() SEF_USAEFCAPSPAWN("Ramat David", "Hatay") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Incirlik", SupportMenuCAP_RD_Turkey, function() SEF_USAEFCAPSPAWN("Ramat David", "Incirlik") end, nil)
	]]--
	--////ISREAL JORDAN LEBANON
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Beirut", SupportMenuCAP_RD_Isreal, function() SEF_USAEFCAPSPAWN("Ramat David", "Beirut-Rafic Hariri") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Eyn Shemer", SupportMenuCAP_RD_Isreal, function() SEF_USAEFCAPSPAWN("Ramat David", "Eyn Shemer") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Haifa", SupportMenuCAP_RD_Isreal, function() SEF_USAEFCAPSPAWN("Ramat David", "Haifa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector King Hussein Air College", SupportMenuCAP_RD_Isreal, function() SEF_USAEFCAPSPAWN("Ramat David", "King Hussein Air College") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kiryat Shmona", SupportMenuCAP_RD_Isreal, function() SEF_USAEFCAPSPAWN("Ramat David", "Kiryat Shmona") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Megiddo", SupportMenuCAP_RD_Isreal, function() SEF_USAEFCAPSPAWN("Ramat David", "Megiddo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ramat David", SupportMenuCAP_RD_Isreal, function() SEF_USAEFCAPSPAWN("Ramat David", "Ramat David") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rayak", SupportMenuCAP_RD_Isreal, function() SEF_USAEFCAPSPAWN("Ramat David", "Rayak") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rene Mouawad", SupportMenuCAP_RD_Isreal, function() SEF_USAEFCAPSPAWN("Ramat David", "Rene Mouawad") end, nil)
	--SupportMenuCAP_RD_IsrealMore = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "More Sectors", SupportMenuCAP_RD_Isreal)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Wujah Al Hajar", SupportMenuCAP_RD_Isreal, function() SEF_USAEFCAPSPAWN("Ramat David", "Wujah Al Hajar") end, nil)
	--[[	
	--////NORTHERN AND CENTRAL SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu al-Duhur", SupportMenuCAP_RD_North, function() SEF_USAEFCAPSPAWN("Ramat David", "Abu al-Duhur") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Aleppo", SupportMenuCAP_RD_North, function() SEF_USAEFCAPSPAWN("Ramat David", "Aleppo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al Qusayr", SupportMenuCAP_RD_North, function() SEF_USAEFCAPSPAWN("Ramat David", "Al Qusayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bassel Al-Assad", SupportMenuCAP_RD_North, function() SEF_USAEFCAPSPAWN("Ramat David", "Bassel Al-Assad") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Jirah", SupportMenuCAP_RD_North, function() SEF_USAEFCAPSPAWN("Ramat David", "Jirah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kuweires", SupportMenuCAP_RD_North, function() SEF_USAEFCAPSPAWN("Ramat David", "Kuweires") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minakh", SupportMenuCAP_RD_North, function() SEF_USAEFCAPSPAWN("Ramat David", "Minakh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Taftanaz", SupportMenuCAP_RD_North, function() SEF_USAEFCAPSPAWN("Ramat David", "Taftanaz") end, nil)
	]]--
	--////SOUTHERN SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al-Dumayr", SupportMenuCAP_RD_South, function() SEF_USAEFCAPSPAWN("Ramat David", "Al-Dumayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector An Nasiriyah", SupportMenuCAP_RD_South, function() SEF_USAEFCAPSPAWN("Ramat David", "An Nasiriyah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Damascus", SupportMenuCAP_RD_South, function() SEF_USAEFCAPSPAWN("Ramat David", "Damascus") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Khalkhalah", SupportMenuCAP_RD_South, function() SEF_USAEFCAPSPAWN("Ramat David", "Khalkhalah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan North", SupportMenuCAP_RD_South, function() SEF_USAEFCAPSPAWN("Ramat David", "Marj as Sultan North") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan South", SupportMenuCAP_RD_South, function() SEF_USAEFCAPSPAWN("Ramat David", "Marj as Sultan South") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj Ruhayyil", SupportMenuCAP_RD_South, function() SEF_USAEFCAPSPAWN("Ramat David", "Marj Ruhayyil") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Mezzeh", SupportMenuCAP_RD_South, function() SEF_USAEFCAPSPAWN("Ramat David", "Mezzeh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qabr as Sitt", SupportMenuCAP_RD_South, function() SEF_USAEFCAPSPAWN("Ramat David", "Qabr as Sitt") end, nil)


	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--////CAS FLIGHTS
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	--SupportMenuCAS_INC = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Departing Incirlik", SupportMenuCAS)
	--SupportMenuCAS_RD = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Departing Ramat David", SupportMenuCAS)
	
	--////CAS Support Sector List
	--[[
	SupportMenuCAS_INC_Turkey = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Turkish Sectors", SupportMenuCAS_INC)
	SupportMenuCAS_INC_Isreal = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Israeli Jordanian And Lebanese Sectors", SupportMenuCAS_INC)
	SupportMenuCAS_INC_North = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Northern And Central Syrian Sectors", SupportMenuCAS_INC)
	SupportMenuCAS_INC_South = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Southern Syrian Sectors", SupportMenuCAS_INC)
	]]--
	--SupportMenuCAS_RD_Turkey = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Turkish Sectors", SupportMenuCAS_RD)
	SupportMenuCAS_RD_Isreal = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Israeli Jordanian And Lebanese Sectors", SupportMenuCAS) -- removed _RD
	--SupportMenuCAS_RD_North = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Northern And Central Syrian Sectors", SupportMenuCAS_RD)
	SupportMenuCAS_RD_South = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Southern Syrian Sectors", SupportMenuCAS) -- removed _RD
	
	--////DEPARTING INCIRLIK
	--[[
	--////TURKEY
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Adana Sakirpasa", SupportMenuCAS_INC_Turkey, function() SEF_USAEFCASSPAWN("Incirlik", "Adana Sakirpasa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Hatay", SupportMenuCAS_INC_Turkey, function() SEF_USAEFCASSPAWN("Incirlik", "Hatay") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Incirlik", SupportMenuCAS_INC_Turkey, function() SEF_USAEFCASSPAWN("Incirlik", "Incirlik") end, nil)
	
	--////ISREAL JORDAN LEBANON
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Beirut", SupportMenuCAS_INC_Isreal, function() SEF_USAEFCASSPAWN("Incirlik", "Beirut-Rafic Hariri") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Eyn Shemer", SupportMenuCAS_INC_Isreal, function() SEF_USAEFCASSPAWN("Incirlik", "Eyn Shemer") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Haifa", SupportMenuCAS_INC_Isreal, function() SEF_USAEFCASSPAWN("Incirlik", "Haifa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector King Hussein Air College", SupportMenuCAS_INC_Isreal, function() SEF_USAEFCASSPAWN("Incirlik", "King Hussein Air College") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kiryat Shmona", SupportMenuCAS_INC_Isreal, function() SEF_USAEFCASSPAWN("Incirlik", "Kiryat Shmona") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Megiddo", SupportMenuCAS_INC_Isreal, function() SEF_USAEFCASSPAWN("Incirlik", "Megiddo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ramat David", SupportMenuCAS_INC_Isreal, function() SEF_USAEFCASSPAWN("Incirlik", "Ramat David") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rayak", SupportMenuCAS_INC_Isreal, function() SEF_USAEFCASSPAWN("Incirlik", "Rayak") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rene Mouawad", SupportMenuCAS_INC_Isreal, function() SEF_USAEFCASSPAWN("Incirlik", "Rene Mouawad") end, nil)
	--SupportMenuCAS_INC_IsrealMore = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "More Sectors", SupportMenuCAS_INC_Isreal)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Wujah Al Hajar", SupportMenuCAS_INC_Isreal, function() SEF_USAEFCASSPAWN("Incirlik", "Wujah Al Hajar") end, nil)
	
	--////NORTHERN AND CENTRAL SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu al-Duhur", SupportMenuCAS_INC_North, function() SEF_USAEFCASSPAWN("Incirlik", "Abu al-Duhur") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Aleppo", SupportMenuCAS_INC_North, function() SEF_USAEFCASSPAWN("Incirlik", "Aleppo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al Qusayr", SupportMenuCAS_INC_North, function() SEF_USAEFCASSPAWN("Incirlik", "Al Qusayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bassel Al-Assad", SupportMenuCAS_INC_North, function() SEF_USAEFCASSPAWN("Incirlik", "Bassel Al-Assad") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Jirah", SupportMenuCAS_INC_North, function() SEF_USAEFCASSPAWN("Incirlik", "Jirah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kuweires", SupportMenuCAS_INC_North, function() SEF_USAEFCASSPAWN("Incirlik", "Kuweires") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minakh", SupportMenuCAS_INC_North, function() SEF_USAEFCASSPAWN("Incirlik", "Minakh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Taftanaz", SupportMenuCAS_INC_North, function() SEF_USAEFCASSPAWN("Incirlik", "Taftanaz") end, nil)
	
	--////SOUTHERN SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al-Dumayr", SupportMenuCAS_INC_South, function() SEF_USAEFCASSPAWN("Incirlik", "Al-Dumayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector An Nasiriyah", SupportMenuCAS_INC_South, function() SEF_USAEFCASSPAWN("Incirlik", "An Nasiriyah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Damascus", SupportMenuCAS_INC_South, function() SEF_USAEFCASSPAWN("Incirlik", "Damascus") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Khalkhalah", SupportMenuCAS_INC_South, function() SEF_USAEFCASSPAWN("Incirlik", "Khalkhalah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan North", SupportMenuCAS_INC_South, function() SEF_USAEFCASSPAWN("Incirlik", "Marj as Sultan North") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan South", SupportMenuCAS_INC_South, function() SEF_USAEFCASSPAWN("Incirlik", "Marj as Sultan South") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj Ruhayyil", SupportMenuCAS_INC_South, function() SEF_USAEFCASSPAWN("Incirlik", "Marj Ruhayyil") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Mezzeh", SupportMenuCAS_INC_South, function() SEF_USAEFCASSPAWN("Incirlik", "Mezzeh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qabr as Sitt", SupportMenuCAS_INC_South, function() SEF_USAEFCASSPAWN("Incirlik", "Qabr as Sitt") end, nil)
	]]--
	--////DEPARTING RAMAT DAVID
	--[[
	--////TURKEY
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Adana Sakirpasa", SupportMenuCAS_RD_Turkey, function() SEF_USAEFCASSPAWN("Ramat David", "Adana Sakirpasa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Hatay", SupportMenuCAS_RD_Turkey, function() SEF_USAEFCASSPAWN("Ramat David", "Hatay") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Incirlik", SupportMenuCAS_RD_Turkey, function() SEF_USAEFCASSPAWN("Ramat David", "Incirlik") end, nil)
	]]--
	--////ISREAL JORDAN LEBANON
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Beirut", SupportMenuCAS_RD_Isreal, function() SEF_USAEFCASSPAWN("Ramat David", "Beirut-Rafic Hariri") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Eyn Shemer", SupportMenuCAS_RD_Isreal, function() SEF_USAEFCASSPAWN("Ramat David", "Eyn Shemer") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Haifa", SupportMenuCAS_RD_Isreal, function() SEF_USAEFCASSPAWN("Ramat David", "Haifa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector King Hussein Air College", SupportMenuCAS_RD_Isreal, function() SEF_USAEFCASSPAWN("Ramat David", "King Hussein Air College") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kiryat Shmona", SupportMenuCAS_RD_Isreal, function() SEF_USAEFCASSPAWN("Ramat David", "Kiryat Shmona") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Megiddo", SupportMenuCAS_RD_Isreal, function() SEF_USAEFCASSPAWN("Ramat David", "Megiddo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ramat David", SupportMenuCAS_RD_Isreal, function() SEF_USAEFCASSPAWN("Ramat David", "Ramat David") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rayak", SupportMenuCAS_RD_Isreal, function() SEF_USAEFCASSPAWN("Ramat David", "Rayak") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rene Mouawad", SupportMenuCAS_RD_Isreal, function() SEF_USAEFCASSPAWN("Ramat David", "Rene Mouawad") end, nil)
	--SupportMenuCAS_RD_IsrealMore = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "More Sectors", SupportMenuCAS_RD_Isreal)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Wujah Al Hajar", SupportMenuCAS_RD_Isreal, function() SEF_USAEFCASSPAWN("Ramat David", "Wujah Al Hajar") end, nil)
	--[[	
	--////NORTHERN AND CENTRAL SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu al-Duhur", SupportMenuCAS_RD_North, function() SEF_USAEFCASSPAWN("Ramat David", "Abu al-Duhur") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Aleppo", SupportMenuCAS_RD_North, function() SEF_USAEFCASSPAWN("Ramat David", "Aleppo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al Qusayr", SupportMenuCAS_RD_North, function() SEF_USAEFCASSPAWN("Ramat David", "Al Qusayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bassel Al-Assad", SupportMenuCAS_RD_North, function() SEF_USAEFCASSPAWN("Ramat David", "Bassel Al-Assad") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Jirah", SupportMenuCAS_RD_North, function() SEF_USAEFCASSPAWN("Ramat David", "Jirah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kuweires", SupportMenuCAS_RD_North, function() SEF_USAEFCASSPAWN("Ramat David", "Kuweires") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minakh", SupportMenuCAS_RD_North, function() SEF_USAEFCASSPAWN("Ramat David", "Minakh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Taftanaz", SupportMenuCAS_RD_North, function() SEF_USAEFCASSPAWN("Ramat David", "Taftanaz") end, nil)
	]]--
	--////SOUTHERN SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al-Dumayr", SupportMenuCAS_RD_South, function() SEF_USAEFCASSPAWN("Ramat David", "Al-Dumayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector An Nasiriyah", SupportMenuCAS_RD_South, function() SEF_USAEFCASSPAWN("Ramat David", "An Nasiriyah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Damascus", SupportMenuCAS_RD_South, function() SEF_USAEFCASSPAWN("Ramat David", "Damascus") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Khalkhalah", SupportMenuCAS_RD_South, function() SEF_USAEFCASSPAWN("Ramat David", "Khalkhalah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan North", SupportMenuCAS_RD_South, function() SEF_USAEFCASSPAWN("Ramat David", "Marj as Sultan North") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan South", SupportMenuCAS_RD_South, function() SEF_USAEFCASSPAWN("Ramat David", "Marj as Sultan South") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj Ruhayyil", SupportMenuCAS_RD_South, function() SEF_USAEFCASSPAWN("Ramat David", "Marj Ruhayyil") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Mezzeh", SupportMenuCAS_RD_South, function() SEF_USAEFCASSPAWN("Ramat David", "Mezzeh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qabr as Sitt", SupportMenuCAS_RD_South, function() SEF_USAEFCASSPAWN("Ramat David", "Qabr as Sitt") end, nil)
	
	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--////SEAD FLIGHTS
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	--SupportMenuSEAD_INC = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Departing Incirlik", SupportMenuSEAD)
	--SupportMenuSEAD_RD = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Departing Ramat David", SupportMenuSEAD)
	
	--////SEAD Support Sector List
	--[[
	SupportMenuSEAD_INC_Turkey = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Turkish Sectors", SupportMenuSEAD_INC)
	SupportMenuSEAD_INC_Isreal = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Israeli Jordanian And Lebanese Sectors", SupportMenuSEAD_INC)
	SupportMenuSEAD_INC_North = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Northern And Central Syrian Sectors", SupportMenuSEAD_INC)
	SupportMenuSEAD_INC_South = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Southern Syrian Sectors", SupportMenuSEAD_INC)
	]]--
	--SupportMenuSEAD_RD_Turkey = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Turkish Sectors", SupportMenuSEAD_RD)
	SupportMenuSEAD_RD_Isreal = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Israeli Jordanian And Lebanese Sectors", SupportMenuSEAD)  -- removed _RD
	--SupportMenuSEAD_RD_North = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Northern And Central Syrian Sectors", SupportMenuSEAD_RD)
	SupportMenuSEAD_RD_South = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Southern Syrian Sectors", SupportMenuSEAD)  -- removed _RD
	
	--////DEPARTING INCIRLIK
	--[[
	--////TURKEY
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Adana Sakirpasa", SupportMenuSEAD_INC_Turkey, function() SEF_USAEFSEADSPAWN("Incirlik", "Adana Sakirpasa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Hatay", SupportMenuSEAD_INC_Turkey, function() SEF_USAEFSEADSPAWN("Incirlik", "Hatay") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Incirlik", SupportMenuSEAD_INC_Turkey, function() SEF_USAEFSEADSPAWN("Incirlik", "Incirlik") end, nil)
	
	--////ISREAL JORDAN LEBANON
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Beirut", SupportMenuSEAD_INC_Isreal, function() SEF_USAEFSEADSPAWN("Incirlik", "Beirut-Rafic Hariri") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Eyn Shemer", SupportMenuSEAD_INC_Isreal, function() SEF_USAEFSEADSPAWN("Incirlik", "Eyn Shemer") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Haifa", SupportMenuSEAD_INC_Isreal, function() SEF_USAEFSEADSPAWN("Incirlik", "Haifa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector King Hussein Air College", SupportMenuSEAD_INC_Isreal, function() SEF_USAEFSEADSPAWN("Incirlik", "King Hussein Air College") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kiryat Shmona", SupportMenuSEAD_INC_Isreal, function() SEF_USAEFSEADSPAWN("Incirlik", "Kiryat Shmona") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Megiddo", SupportMenuSEAD_INC_Isreal, function() SEF_USAEFSEADSPAWN("Incirlik", "Megiddo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ramat David", SupportMenuSEAD_INC_Isreal, function() SEF_USAEFSEADSPAWN("Incirlik", "Ramat David") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rayak", SupportMenuSEAD_INC_Isreal, function() SEF_USAEFSEADSPAWN("Incirlik", "Rayak") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rene Mouawad", SupportMenuSEAD_INC_Isreal, function() SEF_USAEFSEADSPAWN("Incirlik", "Rene Mouawad") end, nil)
	--SupportMenuSEAD_INC_IsrealMore = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "More Sectors", SupportMenuSEAD_INC_Isreal)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Wujah Al Hajar", SupportMenuSEAD_INC_Isreal, function() SEF_USAEFSEADSPAWN("Incirlik", "Wujah Al Hajar") end, nil)
	
	--////NORTHERN AND CENTRAL SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu al-Duhur", SupportMenuSEAD_INC_North, function() SEF_USAEFSEADSPAWN("Incirlik", "Abu al-Duhur") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Aleppo", SupportMenuSEAD_INC_North, function() SEF_USAEFSEADSPAWN("Incirlik", "Aleppo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al Qusayr", SupportMenuSEAD_INC_North, function() SEF_USAEFSEADSPAWN("Incirlik", "Al Qusayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bassel Al-Assad", SupportMenuSEAD_INC_North, function() SEF_USAEFSEADSPAWN("Incirlik", "Bassel Al-Assad") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Jirah", SupportMenuSEAD_INC_North, function() SEF_USAEFSEADSPAWN("Incirlik", "Jirah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kuweires", SupportMenuSEAD_INC_North, function() SEF_USAEFSEADSPAWN("Incirlik", "Kuweires") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minakh", SupportMenuSEAD_INC_North, function() SEF_USAEFSEADSPAWN("Incirlik", "Minakh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Taftanaz", SupportMenuSEAD_INC_North, function() SEF_USAEFSEADSPAWN("Incirlik", "Taftanaz") end, nil)
	
	--////SOUTHERN SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al-Dumayr", SupportMenuSEAD_INC_South, function() SEF_USAEFSEADSPAWN("Incirlik", "Al-Dumayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector An Nasiriyah", SupportMenuSEAD_INC_South, function() SEF_USAEFSEADSPAWN("Incirlik", "An Nasiriyah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Damascus", SupportMenuSEAD_INC_South, function() SEF_USAEFSEADSPAWN("Incirlik", "Damascus") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Khalkhalah", SupportMenuSEAD_INC_South, function() SEF_USAEFSEADSPAWN("Incirlik", "Khalkhalah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan North", SupportMenuSEAD_INC_South, function() SEF_USAEFSEADSPAWN("Incirlik", "Marj as Sultan North") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan South", SupportMenuSEAD_INC_South, function() SEF_USAEFSEADSPAWN("Incirlik", "Marj as Sultan South") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj Ruhayyil", SupportMenuSEAD_INC_South, function() SEF_USAEFSEADSPAWN("Incirlik", "Marj Ruhayyil") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Mezzeh", SupportMenuSEAD_INC_South, function() SEF_USAEFSEADSPAWN("Incirlik", "Mezzeh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qabr as Sitt", SupportMenuSEAD_INC_South, function() SEF_USAEFSEADSPAWN("Incirlik", "Qabr as Sitt") end, nil)
	]]--
	--////DEPARTING RAMAT DAVID
	--[[
	--////TURKEY
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Adana Sakirpasa", SupportMenuSEAD_RD_Turkey, function() SEF_USAEFSEADSPAWN("Ramat David", "Adana Sakirpasa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Hatay", SupportMenuSEAD_RD_Turkey, function() SEF_USAEFSEADSPAWN("Ramat David", "Hatay") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Incirlik", SupportMenuSEAD_RD_Turkey, function() SEF_USAEFSEADSPAWN("Ramat David", "Incirlik") end, nil)
	]]--
	--////ISREAL JORDAN LEBANON
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Beirut", SupportMenuSEAD_RD_Isreal, function() SEF_USAEFSEADSPAWN("Ramat David", "Beirut-Rafic Hariri") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Eyn Shemer", SupportMenuSEAD_RD_Isreal, function() SEF_USAEFSEADSPAWN("Ramat David", "Eyn Shemer") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Haifa", SupportMenuSEAD_RD_Isreal, function() SEF_USAEFSEADSPAWN("Ramat David", "Haifa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector King Hussein Air College", SupportMenuSEAD_RD_Isreal, function() SEF_USAEFSEADSPAWN("Ramat David", "King Hussein Air College") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kiryat Shmona", SupportMenuSEAD_RD_Isreal, function() SEF_USAEFSEADSPAWN("Ramat David", "Kiryat Shmona") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Megiddo", SupportMenuSEAD_RD_Isreal, function() SEF_USAEFSEADSPAWN("Ramat David", "Megiddo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ramat David", SupportMenuSEAD_RD_Isreal, function() SEF_USAEFSEADSPAWN("Ramat David", "Ramat David") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rayak", SupportMenuSEAD_RD_Isreal, function() SEF_USAEFSEADSPAWN("Ramat David", "Rayak") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rene Mouawad", SupportMenuSEAD_RD_Isreal, function() SEF_USAEFSEADSPAWN("Ramat David", "Rene Mouawad") end, nil)
	--SupportMenuSEAD_RD_IsrealMore = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "More Sectors", SupportMenuSEAD_RD_Isreal)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Wujah Al Hajar", SupportMenuSEAD_RD_Isreal, function() SEF_USAEFSEADSPAWN("Ramat David", "Wujah Al Hajar") end, nil)
--[[
	--////NORTHERN AND CENTRAL SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu al-Duhur", SupportMenuSEAD_RD_North, function() SEF_USAEFSEADSPAWN("Ramat David", "Abu al-Duhur") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Aleppo", SupportMenuSEAD_RD_North, function() SEF_USAEFSEADSPAWN("Ramat David", "Aleppo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al Qusayr", SupportMenuSEAD_RD_North, function() SEF_USAEFSEADSPAWN("Ramat David", "Al Qusayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bassel Al-Assad", SupportMenuSEAD_RD_North, function() SEF_USAEFSEADSPAWN("Ramat David", "Bassel Al-Assad") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Jirah", SupportMenuSEAD_RD_North, function() SEF_USAEFSEADSPAWN("Ramat David", "Jirah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kuweires", SupportMenuSEAD_RD_North, function() SEF_USAEFSEADSPAWN("Ramat David", "Kuweires") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minakh", SupportMenuSEAD_RD_North, function() SEF_USAEFSEADSPAWN("Ramat David", "Minakh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Taftanaz", SupportMenuSEAD_RD_North, function() SEF_USAEFSEADSPAWN("Ramat David", "Taftanaz") end, nil)
	]]--
	--////SOUTHERN SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al-Dumayr", SupportMenuSEAD_RD_South, function() SEF_USAEFSEADSPAWN("Ramat David", "Al-Dumayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector An Nasiriyah", SupportMenuSEAD_RD_South, function() SEF_USAEFSEADSPAWN("Ramat David", "An Nasiriyah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Damascus", SupportMenuSEAD_RD_South, function() SEF_USAEFSEADSPAWN("Ramat David", "Damascus") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Khalkhalah", SupportMenuSEAD_RD_South, function() SEF_USAEFSEADSPAWN("Ramat David", "Khalkhalah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan North", SupportMenuSEAD_RD_South, function() SEF_USAEFSEADSPAWN("Ramat David", "Marj as Sultan North") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan South", SupportMenuSEAD_RD_South, function() SEF_USAEFSEADSPAWN("Ramat David", "Marj as Sultan South") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj Ruhayyil", SupportMenuSEAD_RD_South, function() SEF_USAEFSEADSPAWN("Ramat David", "Marj Ruhayyil") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Mezzeh", SupportMenuSEAD_RD_South, function() SEF_USAEFSEADSPAWN("Ramat David", "Mezzeh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qabr as Sitt", SupportMenuSEAD_RD_South, function() SEF_USAEFSEADSPAWN("Ramat David", "Qabr as Sitt") end, nil)
	
	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--////PINPOINT STRIKE FLIGHTS
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	--SupportMenuPIN_INC = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Departing Incirlik", SupportMenuPIN)
	--SupportMenuPIN_RD = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Departing Ramat David", SupportMenuPIN)
	
	--////PIN Support Sector List
	--[[
	SupportMenuPIN_INC_Turkey = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Turkish Sectors", SupportMenuPIN_INC)
	SupportMenuPIN_INC_Isreal = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Israeli Jordanian And Lebanese Sectors", SupportMenuPIN_INC)
	SupportMenuPIN_INC_North = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Northern And Central Syrian Sectors", SupportMenuPIN_INC)
	SupportMenuPIN_INC_South = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Southern Syrian Sectors", SupportMenuPIN_INC)
	]]--
	--SupportMenuPIN_RD_Turkey = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Turkish Sectors", SupportMenuPIN_RD)
	SupportMenuPIN_RD_Isreal = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Israeli Jordanian And Lebanese Sectors", SupportMenuPIN) -- removed _RD
	--SupportMenuPIN_RD_North = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Northern And Central Syrian Sectors", SupportMenuPIN_RD)
	SupportMenuPIN_RD_South = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Southern Syrian Sectors", SupportMenuPIN) -- removed _RD
	
	--////DEPARTING INCIRLIK
	--[[
	--////TURKEY
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Adana Sakirpasa", SupportMenuPIN_INC_Turkey, function() SEF_USAEFPINSPAWN("Incirlik", "Adana Sakirpasa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Hatay", SupportMenuPIN_INC_Turkey, function() SEF_USAEFPINSPAWN("Incirlik", "Hatay") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Incirlik", SupportMenuPIN_INC_Turkey, function() SEF_USAEFPINSPAWN("Incirlik", "Incirlik") end, nil)
	
	--////ISREAL JORDAN LEBANON
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Beirut", SupportMenuPIN_INC_Isreal, function() SEF_USAEFPINSPAWN("Incirlik", "Beirut-Rafic Hariri") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Eyn Shemer", SupportMenuPIN_INC_Isreal, function() SEF_USAEFPINSPAWN("Incirlik", "Eyn Shemer") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Haifa", SupportMenuPIN_INC_Isreal, function() SEF_USAEFPINSPAWN("Incirlik", "Haifa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector King Hussein Air College", SupportMenuPIN_INC_Isreal, function() SEF_USAEFPINSPAWN("Incirlik", "King Hussein Air College") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kiryat Shmona", SupportMenuPIN_INC_Isreal, function() SEF_USAEFPINSPAWN("Incirlik", "Kiryat Shmona") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Megiddo", SupportMenuPIN_INC_Isreal, function() SEF_USAEFPINSPAWN("Incirlik", "Megiddo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ramat David", SupportMenuPIN_INC_Isreal, function() SEF_USAEFPINSPAWN("Incirlik", "Ramat David") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rayak", SupportMenuPIN_INC_Isreal, function() SEF_USAEFPINSPAWN("Incirlik", "Rayak") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rene Mouawad", SupportMenuPIN_INC_Isreal, function() SEF_USAEFPINSPAWN("Incirlik", "Rene Mouawad") end, nil)
	--SupportMenuPIN_INC_IsrealMore = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "More Sectors", SupportMenuPIN_INC_Isreal)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Wujah Al Hajar", SupportMenuPIN_INC_Isreal, function() SEF_USAEFPINSPAWN("Incirlik", "Wujah Al Hajar") end, nil)
	
	--////NORTHERN AND CENTRAL SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu al-Duhur", SupportMenuPIN_INC_North, function() SEF_USAEFPINSPAWN("Incirlik", "Abu al-Duhur") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Aleppo", SupportMenuPIN_INC_North, function() SEF_USAEFPINSPAWN("Incirlik", "Aleppo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al Qusayr", SupportMenuPIN_INC_North, function() SEF_USAEFPINSPAWN("Incirlik", "Al Qusayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bassel Al-Assad", SupportMenuPIN_INC_North, function() SEF_USAEFPINSPAWN("Incirlik", "Bassel Al-Assad") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Jirah", SupportMenuPIN_INC_North, function() SEF_USAEFPINSPAWN("Incirlik", "Jirah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kuweires", SupportMenuPIN_INC_North, function() SEF_USAEFPINSPAWN("Incirlik", "Kuweires") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minakh", SupportMenuPIN_INC_North, function() SEF_USAEFPINSPAWN("Incirlik", "Minakh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Taftanaz", SupportMenuPIN_INC_North, function() SEF_USAEFPINSPAWN("Incirlik", "Taftanaz") end, nil)
	
	--////SOUTHERN SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al-Dumayr", SupportMenuPIN_INC_South, function() SEF_USAEFPINSPAWN("Incirlik", "Al-Dumayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector An Nasiriyah", SupportMenuPIN_INC_South, function() SEF_USAEFPINSPAWN("Incirlik", "An Nasiriyah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Damascus", SupportMenuPIN_INC_South, function() SEF_USAEFPINSPAWN("Incirlik", "Damascus") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Khalkhalah", SupportMenuPIN_INC_South, function() SEF_USAEFPINSPAWN("Incirlik", "Khalkhalah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan North", SupportMenuPIN_INC_South, function() SEF_USAEFPINSPAWN("Incirlik", "Marj as Sultan North") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan South", SupportMenuPIN_INC_South, function() SEF_USAEFPINSPAWN("Incirlik", "Marj as Sultan South") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj Ruhayyil", SupportMenuPIN_INC_South, function() SEF_USAEFPINSPAWN("Incirlik", "Marj Ruhayyil") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Mezzeh", SupportMenuPIN_INC_South, function() SEF_USAEFPINSPAWN("Incirlik", "Mezzeh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qabr as Sitt", SupportMenuPIN_INC_South, function() SEF_USAEFPINSPAWN("Incirlik", "Qabr as Sitt") end, nil)
	]]--
	--////DEPARTING RAMAT DAVID
	--[[
	--////TURKEY
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Adana Sakirpasa", SupportMenuPIN_RD_Turkey, function() SEF_USAEFPINSPAWN("Ramat David", "Adana Sakirpasa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Hatay", SupportMenuPIN_RD_Turkey, function() SEF_USAEFPINSPAWN("Ramat David", "Hatay") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Incirlik", SupportMenuPIN_RD_Turkey, function() SEF_USAEFPINSPAWN("Ramat David", "Incirlik") end, nil)
	]]--
	--////ISREAL JORDAN LEBANON
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Beirut", SupportMenuPIN_RD_Isreal, function() SEF_USAEFPINSPAWN("Ramat David", "Beirut-Rafic Hariri") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Eyn Shemer", SupportMenuPIN_RD_Isreal, function() SEF_USAEFPINSPAWN("Ramat David", "Eyn Shemer") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Haifa", SupportMenuPIN_RD_Isreal, function() SEF_USAEFPINSPAWN("Ramat David", "Haifa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector King Hussein Air College", SupportMenuPIN_RD_Isreal, function() SEF_USAEFPINSPAWN("Ramat David", "King Hussein Air College") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kiryat Shmona", SupportMenuPIN_RD_Isreal, function() SEF_USAEFPINSPAWN("Ramat David", "Kiryat Shmona") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Megiddo", SupportMenuPIN_RD_Isreal, function() SEF_USAEFPINSPAWN("Ramat David", "Megiddo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ramat David", SupportMenuPIN_RD_Isreal, function() SEF_USAEFPINSPAWN("Ramat David", "Ramat David") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rayak", SupportMenuPIN_RD_Isreal, function() SEF_USAEFPINSPAWN("Ramat David", "Rayak") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rene Mouawad", SupportMenuPIN_RD_Isreal, function() SEF_USAEFPINSPAWN("Ramat David", "Rene Mouawad") end, nil)
	--SupportMenuPIN_RD_IsrealMore = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "More Sectors", SupportMenuPIN_RD_Isreal)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Wujah Al Hajar", SupportMenuPIN_RD_Isreal, function() SEF_USAEFPINSPAWN("Ramat David", "Wujah Al Hajar") end, nil)
--[[
	--////NORTHERN AND CENTRAL SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu al-Duhur", SupportMenuPIN_RD_North, function() SEF_USAEFPINSPAWN("Ramat David", "Abu al-Duhur") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Aleppo", SupportMenuPIN_RD_North, function() SEF_USAEFPINSPAWN("Ramat David", "Aleppo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al Qusayr", SupportMenuPIN_RD_North, function() SEF_USAEFPINSPAWN("Ramat David", "Al Qusayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bassel Al-Assad", SupportMenuPIN_RD_North, function() SEF_USAEFPINSPAWN("Ramat David", "Bassel Al-Assad") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Jirah", SupportMenuPIN_RD_North, function() SEF_USAEFPINSPAWN("Ramat David", "Jirah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kuweires", SupportMenuPIN_RD_North, function() SEF_USAEFPINSPAWN("Ramat David", "Kuweires") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minakh", SupportMenuPIN_RD_North, function() SEF_USAEFPINSPAWN("Ramat David", "Minakh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Taftanaz", SupportMenuPIN_RD_North, function() SEF_USAEFPINSPAWN("Ramat David", "Taftanaz") end, nil)
	]]--
	--////SOUTHERN SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al-Dumayr", SupportMenuPIN_RD_South, function() SEF_USAEFPINSPAWN("Ramat David", "Al-Dumayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector An Nasiriyah", SupportMenuPIN_RD_South, function() SEF_USAEFPINSPAWN("Ramat David", "An Nasiriyah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Damascus", SupportMenuPIN_RD_South, function() SEF_USAEFPINSPAWN("Ramat David", "Damascus") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Khalkhalah", SupportMenuPIN_RD_South, function() SEF_USAEFPINSPAWN("Ramat David", "Khalkhalah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan North", SupportMenuPIN_RD_South, function() SEF_USAEFPINSPAWN("Ramat David", "Marj as Sultan North") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan South", SupportMenuPIN_RD_South, function() SEF_USAEFPINSPAWN("Ramat David", "Marj as Sultan South") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj Ruhayyil", SupportMenuPIN_RD_South, function() SEF_USAEFPINSPAWN("Ramat David", "Marj Ruhayyil") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Mezzeh", SupportMenuPIN_RD_South, function() SEF_USAEFPINSPAWN("Ramat David", "Mezzeh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qabr as Sitt", SupportMenuPIN_RD_South, function() SEF_USAEFPINSPAWN("Ramat David", "Qabr as Sitt") end, nil)
	
	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--////ANTI SHIPPING FLIGHTS
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	--SupportMenuASS_INC = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Departing Incirlik", SupportMenuASS)
	--SupportMenuASS_RD = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Departing Ramat David", SupportMenuASS)
	
	--////ASS Support Sector List
	--[[
	SupportMenuASS_INC_Turkey = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Turkish Sectors", SupportMenuASS_INC)
	SupportMenuASS_INC_Isreal = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Israeli Jordanian And Lebanese Sectors", SupportMenuASS_INC)
	SupportMenuASS_INC_North = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Northern And Central Syrian Sectors", SupportMenuASS_INC)
	SupportMenuASS_INC_South = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Southern Syrian Sectors", SupportMenuASS_INC)
	]]--
	--SupportMenuASS_RD_Turkey = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Turkish Sectors", SupportMenuASS_RD)
	SupportMenuASS_RD_Isreal = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Israeli Jordanian And Lebanese Sectors", SupportMenuASS) -- removed _RD
	--SupportMenuASS_RD_North = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Northern And Central Syrian Sectors", SupportMenuASS_RD)
	SupportMenuASS_RD_South = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Southern Syrian Sectors", SupportMenuASS) -- removed _RD
	
	--////DEPARTING INCIRLIK
	--[[
	--////TURKEY
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Adana Sakirpasa", SupportMenuASS_INC_Turkey, function() SEF_USAEFASSSPAWN("Incirlik", "Adana Sakirpasa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Hatay", SupportMenuASS_INC_Turkey, function() SEF_USAEFASSSPAWN("Incirlik", "Hatay") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Incirlik", SupportMenuASS_INC_Turkey, function() SEF_USAEFASSSPAWN("Incirlik", "Incirlik") end, nil)
	
	--////ISREAL JORDAN LEBANON
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Beirut", SupportMenuASS_INC_Isreal, function() SEF_USAEFASSSPAWN("Incirlik", "Beirut-Rafic Hariri") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Eyn Shemer", SupportMenuASS_INC_Isreal, function() SEF_USAEFASSSPAWN("Incirlik", "Eyn Shemer") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Haifa", SupportMenuASS_INC_Isreal, function() SEF_USAEFASSSPAWN("Incirlik", "Haifa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector King Hussein Air College", SupportMenuASS_INC_Isreal, function() SEF_USAEFASSSPAWN("Incirlik", "King Hussein Air College") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kiryat Shmona", SupportMenuASS_INC_Isreal, function() SEF_USAEFASSSPAWN("Incirlik", "Kiryat Shmona") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Megiddo", SupportMenuASS_INC_Isreal, function() SEF_USAEFASSSPAWN("Incirlik", "Megiddo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ramat David", SupportMenuASS_INC_Isreal, function() SEF_USAEFASSSPAWN("Incirlik", "Ramat David") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rayak", SupportMenuASS_INC_Isreal, function() SEF_USAEFASSSPAWN("Incirlik", "Rayak") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rene Mouawad", SupportMenuASS_INC_Isreal, function() SEF_USAEFASSSPAWN("Incirlik", "Rene Mouawad") end, nil)
	--SupportMenuASS_INC_IsrealMore = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "More Sectors", SupportMenuASS_INC_Isreal)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Wujah Al Hajar", SupportMenuASS_INC_Isreal, function() SEF_USAEFASSSPAWN("Incirlik", "Wujah Al Hajar") end, nil)
	
	--////NORTHERN AND CENTRAL SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu al-Duhur", SupportMenuASS_INC_North, function() SEF_USAEFASSSPAWN("Incirlik", "Abu al-Duhur") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Aleppo", SupportMenuASS_INC_North, function() SEF_USAEFASSSPAWN("Incirlik", "Aleppo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al Qusayr", SupportMenuASS_INC_North, function() SEF_USAEFASSSPAWN("Incirlik", "Al Qusayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bassel Al-Assad", SupportMenuASS_INC_North, function() SEF_USAEFASSSPAWN("Incirlik", "Bassel Al-Assad") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Jirah", SupportMenuASS_INC_North, function() SEF_USAEFASSSPAWN("Incirlik", "Jirah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kuweires", SupportMenuASS_INC_North, function() SEF_USAEFASSSPAWN("Incirlik", "Kuweires") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minakh", SupportMenuASS_INC_North, function() SEF_USAEFASSSPAWN("Incirlik", "Minakh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Taftanaz", SupportMenuASS_INC_North, function() SEF_USAEFASSSPAWN("Incirlik", "Taftanaz") end, nil)
	
	--////SOUTHERN SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al-Dumayr", SupportMenuASS_INC_South, function() SEF_USAEFASSSPAWN("Incirlik", "Al-Dumayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector An Nasiriyah", SupportMenuASS_INC_South, function() SEF_USAEFASSSPAWN("Incirlik", "An Nasiriyah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Damascus", SupportMenuASS_INC_South, function() SEF_USAEFASSSPAWN("Incirlik", "Damascus") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Khalkhalah", SupportMenuASS_INC_South, function() SEF_USAEFASSSPAWN("Incirlik", "Khalkhalah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan North", SupportMenuASS_INC_South, function() SEF_USAEFASSSPAWN("Incirlik", "Marj as Sultan North") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan South", SupportMenuASS_INC_South, function() SEF_USAEFASSSPAWN("Incirlik", "Marj as Sultan South") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj Ruhayyil", SupportMenuASS_INC_South, function() SEF_USAEFASSSPAWN("Incirlik", "Marj Ruhayyil") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Mezzeh", SupportMenuASS_INC_South, function() SEF_USAEFASSSPAWN("Incirlik", "Mezzeh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qabr as Sitt", SupportMenuASS_INC_South, function() SEF_USAEFASSSPAWN("Incirlik", "Qabr as Sitt") end, nil)
	]]--
	--////DEPARTING RAMAT DAVID
	--[[
	--////TURKEY
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Adana Sakirpasa", SupportMenuASS_RD_Turkey, function() SEF_USAEFASSSPAWN("Ramat David", "Adana Sakirpasa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Hatay", SupportMenuASS_RD_Turkey, function() SEF_USAEFASSSPAWN("Ramat David", "Hatay") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Incirlik", SupportMenuASS_RD_Turkey, function() SEF_USAEFASSSPAWN("Ramat David", "Incirlik") end, nil)
	]]--
	--////ISREAL JORDAN LEBANON
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Beirut", SupportMenuASS_RD_Isreal, function() SEF_USAEFASSSPAWN("Ramat David", "Beirut-Rafic Hariri") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Eyn Shemer", SupportMenuASS_RD_Isreal, function() SEF_USAEFASSSPAWN("Ramat David", "Eyn Shemer") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Haifa", SupportMenuASS_RD_Isreal, function() SEF_USAEFASSSPAWN("Ramat David", "Haifa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector King Hussein Air College", SupportMenuASS_RD_Isreal, function() SEF_USAEFASSSPAWN("Ramat David", "King Hussein Air College") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kiryat Shmona", SupportMenuASS_RD_Isreal, function() SEF_USAEFASSSPAWN("Ramat David", "Kiryat Shmona") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Megiddo", SupportMenuASS_RD_Isreal, function() SEF_USAEFASSSPAWN("Ramat David", "Megiddo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ramat David", SupportMenuASS_RD_Isreal, function() SEF_USAEFASSSPAWN("Ramat David", "Ramat David") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rayak", SupportMenuASS_RD_Isreal, function() SEF_USAEFASSSPAWN("Ramat David", "Rayak") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rene Mouawad", SupportMenuASS_RD_Isreal, function() SEF_USAEFASSSPAWN("Ramat David", "Rene Mouawad") end, nil)
	--SupportMenuASS_RD_IsrealMore = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "More Sectors", SupportMenuASS_RD_Isreal)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Wujah Al Hajar", SupportMenuASS_RD_Isreal, function() SEF_USAEFASSSPAWN("Ramat David", "Wujah Al Hajar") end, nil)
	--[[	
	--////NORTHERN AND CENTRAL SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu al-Duhur", SupportMenuASS_RD_North, function() SEF_USAEFASSSPAWN("Ramat David", "Abu al-Duhur") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Aleppo", SupportMenuASS_RD_North, function() SEF_USAEFASSSPAWN("Ramat David", "Aleppo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al Qusayr", SupportMenuASS_RD_North, function() SEF_USAEFASSSPAWN("Ramat David", "Al Qusayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bassel Al-Assad", SupportMenuASS_RD_North, function() SEF_USAEFASSSPAWN("Ramat David", "Bassel Al-Assad") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Jirah", SupportMenuASS_RD_North, function() SEF_USAEFASSSPAWN("Ramat David", "Jirah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kuweires", SupportMenuASS_RD_North, function() SEF_USAEFASSSPAWN("Ramat David", "Kuweires") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minakh", SupportMenuASS_RD_North, function() SEF_USAEFASSSPAWN("Ramat David", "Minakh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Taftanaz", SupportMenuASS_RD_North, function() SEF_USAEFASSSPAWN("Ramat David", "Taftanaz") end, nil)
	]]--
	--////SOUTHERN SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al-Dumayr", SupportMenuASS_RD_South, function() SEF_USAEFASSSPAWN("Ramat David", "Al-Dumayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector An Nasiriyah", SupportMenuASS_RD_South, function() SEF_USAEFASSSPAWN("Ramat David", "An Nasiriyah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Damascus", SupportMenuASS_RD_South, function() SEF_USAEFASSSPAWN("Ramat David", "Damascus") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Khalkhalah", SupportMenuASS_RD_South, function() SEF_USAEFASSSPAWN("Ramat David", "Khalkhalah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan North", SupportMenuASS_RD_South, function() SEF_USAEFASSSPAWN("Ramat David", "Marj as Sultan North") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan South", SupportMenuASS_RD_South, function() SEF_USAEFASSSPAWN("Ramat David", "Marj as Sultan South") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj Ruhayyil", SupportMenuASS_RD_South, function() SEF_USAEFASSSPAWN("Ramat David", "Marj Ruhayyil") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Mezzeh", SupportMenuASS_RD_South, function() SEF_USAEFASSSPAWN("Ramat David", "Mezzeh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qabr as Sitt", SupportMenuASS_RD_South, function() SEF_USAEFASSSPAWN("Ramat David", "Qabr as Sitt") end, nil)
	
	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--////DRONE FLIGHTS
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	--SupportMenuDRONE_INC = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Departing Incirlik", SupportMenuDRONE)
	--SupportMenuDRONE_RD = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Departing Ramat David", SupportMenuDRONE)
	
	--////DRONE Support Sector List
	--[[
	SupportMenuDRONE_INC_Turkey = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Turkish Sectors", SupportMenuDRONE_INC)
	SupportMenuDRONE_INC_Isreal = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Israeli Jordanian And Lebanese Sectors", SupportMenuDRONE_INC)
	SupportMenuDRONE_INC_North = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Northern And Central Syrian Sectors", SupportMenuDRONE_INC)
	SupportMenuDRONE_INC_South = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Southern Syrian Sectors", SupportMenuDRONE_INC)
	]]--
	--SupportMenuDRONE_RD_Turkey = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Turkish Sectors", SupportMenuDRONE_RD)
	SupportMenuDRONE_RD_Isreal = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Israeli Jordanian And Lebanese Sectors", SupportMenuDRONE) -- removed _RD
	--SupportMenuDRONE_RD_North = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Northern And Central Syrian Sectors", SupportMenuDRONE_RD)
	SupportMenuDRONE_RD_South = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Southern Syrian Sectors", SupportMenuDRONE) -- removed _RD
	
	--////DEPARTING INCIRLIK
	--[[
	--////TURKEY
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Adana Sakirpasa", SupportMenuDRONE_INC_Turkey, function() SEF_USAEFDRONESPAWN("Incirlik", "Adana Sakirpasa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Hatay", SupportMenuDRONE_INC_Turkey, function() SEF_USAEFDRONESPAWN("Incirlik", "Hatay") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Incirlik", SupportMenuDRONE_INC_Turkey, function() SEF_USAEFDRONESPAWN("Incirlik", "Incirlik") end, nil)
	
	--////ISREAL JORDAN LEBANON
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Beirut", SupportMenuDRONE_INC_Isreal, function() SEF_USAEFDRONESPAWN("Incirlik", "Beirut-Rafic Hariri") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Eyn Shemer", SupportMenuDRONE_INC_Isreal, function() SEF_USAEFDRONESPAWN("Incirlik", "Eyn Shemer") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Haifa", SupportMenuDRONE_INC_Isreal, function() SEF_USAEFDRONESPAWN("Incirlik", "Haifa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector King Hussein Air College", SupportMenuDRONE_INC_Isreal, function() SEF_USAEFDRONESPAWN("Incirlik", "King Hussein Air College") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kiryat Shmona", SupportMenuDRONE_INC_Isreal, function() SEF_USAEFDRONESPAWN("Incirlik", "Kiryat Shmona") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Megiddo", SupportMenuDRONE_INC_Isreal, function() SEF_USAEFDRONESPAWN("Incirlik", "Megiddo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ramat David", SupportMenuDRONE_INC_Isreal, function() SEF_USAEFDRONESPAWN("Incirlik", "Ramat David") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rayak", SupportMenuDRONE_INC_Isreal, function() SEF_USAEFDRONESPAWN("Incirlik", "Rayak") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rene Mouawad", SupportMenuDRONE_INC_Isreal, function() SEF_USAEFDRONESPAWN("Incirlik", "Rene Mouawad") end, nil)
	--SupportMenuDRONE_INC_IsrealMore = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "More Sectors", SupportMenuDRONE_INC_Isreal)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Wujah Al Hajar", SupportMenuDRONE_INC_Isreal, function() SEF_USAEFDRONESPAWN("Incirlik", "Wujah Al Hajar") end, nil)
	
	--////NORTHERN AND CENTRAL SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu al-Duhur", SupportMenuDRONE_INC_North, function() SEF_USAEFDRONESPAWN("Incirlik", "Abu al-Duhur") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Aleppo", SupportMenuDRONE_INC_North, function() SEF_USAEFDRONESPAWN("Incirlik", "Aleppo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al Qusayr", SupportMenuDRONE_INC_North, function() SEF_USAEFDRONESPAWN("Incirlik", "Al Qusayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bassel Al-Assad", SupportMenuDRONE_INC_North, function() SEF_USAEFDRONESPAWN("Incirlik", "Bassel Al-Assad") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Jirah", SupportMenuDRONE_INC_North, function() SEF_USAEFDRONESPAWN("Incirlik", "Jirah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kuweires", SupportMenuDRONE_INC_North, function() SEF_USAEFDRONESPAWN("Incirlik", "Kuweires") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minakh", SupportMenuDRONE_INC_North, function() SEF_USAEFDRONESPAWN("Incirlik", "Minakh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Taftanaz", SupportMenuDRONE_INC_North, function() SEF_USAEFDRONESPAWN("Incirlik", "Taftanaz") end, nil)
	
	--////SOUTHERN SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al-Dumayr", SupportMenuDRONE_INC_South, function() SEF_USAEFDRONESPAWN("Incirlik", "Al-Dumayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector An Nasiriyah", SupportMenuDRONE_INC_South, function() SEF_USAEFDRONESPAWN("Incirlik", "An Nasiriyah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Damascus", SupportMenuDRONE_INC_South, function() SEF_USAEFDRONESPAWN("Incirlik", "Damascus") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Khalkhalah", SupportMenuDRONE_INC_South, function() SEF_USAEFDRONESPAWN("Incirlik", "Khalkhalah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan North", SupportMenuDRONE_INC_South, function() SEF_USAEFDRONESPAWN("Incirlik", "Marj as Sultan North") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan South", SupportMenuDRONE_INC_South, function() SEF_USAEFDRONESPAWN("Incirlik", "Marj as Sultan South") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj Ruhayyil", SupportMenuDRONE_INC_South, function() SEF_USAEFDRONESPAWN("Incirlik", "Marj Ruhayyil") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Mezzeh", SupportMenuDRONE_INC_South, function() SEF_USAEFDRONESPAWN("Incirlik", "Mezzeh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qabr as Sitt", SupportMenuDRONE_INC_South, function() SEF_USAEFDRONESPAWN("Incirlik", "Qabr as Sitt") end, nil)
	]]--
	--////DEPARTING RAMAT DAVID
	--[[
	--////TURKEY
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Adana Sakirpasa", SupportMenuDRONE_RD_Turkey, function() SEF_USAEFDRONESPAWN("Ramat David", "Adana Sakirpasa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Hatay", SupportMenuDRONE_RD_Turkey, function() SEF_USAEFDRONESPAWN("Ramat David", "Hatay") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Incirlik", SupportMenuDRONE_RD_Turkey, function() SEF_USAEFDRONESPAWN("Ramat David", "Incirlik") end, nil)
	]]--
	--////ISREAL JORDAN LEBANON
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Beirut", SupportMenuDRONE_RD_Isreal, function() SEF_USAEFDRONESPAWN("Ramat David", "Beirut-Rafic Hariri") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Eyn Shemer", SupportMenuDRONE_RD_Isreal, function() SEF_USAEFDRONESPAWN("Ramat David", "Eyn Shemer") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Haifa", SupportMenuDRONE_RD_Isreal, function() SEF_USAEFDRONESPAWN("Ramat David", "Haifa") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector King Hussein Air College", SupportMenuDRONE_RD_Isreal, function() SEF_USAEFDRONESPAWN("Ramat David", "King Hussein Air College") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kiryat Shmona", SupportMenuDRONE_RD_Isreal, function() SEF_USAEFDRONESPAWN("Ramat David", "Kiryat Shmona") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Megiddo", SupportMenuDRONE_RD_Isreal, function() SEF_USAEFDRONESPAWN("Ramat David", "Megiddo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ramat David", SupportMenuDRONE_RD_Isreal, function() SEF_USAEFDRONESPAWN("Ramat David", "Ramat David") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rayak", SupportMenuDRONE_RD_Isreal, function() SEF_USAEFDRONESPAWN("Ramat David", "Rayak") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Rene Mouawad", SupportMenuDRONE_RD_Isreal, function() SEF_USAEFDRONESPAWN("Ramat David", "Rene Mouawad") end, nil)
	--SupportMenuDRONE_RD_IsrealMore = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "More Sectors", SupportMenuDRONE_RD_Isreal)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Wujah Al Hajar", SupportMenuDRONE_RD_Isreal, function() SEF_USAEFDRONESPAWN("Ramat David", "Wujah Al Hajar") end, nil)
	--[[
	--////NORTHERN AND CENTRAL SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Abu al-Duhur", SupportMenuDRONE_RD_North, function() SEF_USAEFDRONESPAWN("Ramat David", "Abu al-Duhur") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Aleppo", SupportMenuDRONE_RD_North, function() SEF_USAEFDRONESPAWN("Ramat David", "Aleppo") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al Qusayr", SupportMenuDRONE_RD_North, function() SEF_USAEFDRONESPAWN("Ramat David", "Al Qusayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Bassel Al-Assad", SupportMenuDRONE_RD_North, function() SEF_USAEFDRONESPAWN("Ramat David", "Bassel Al-Assad") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Jirah", SupportMenuDRONE_RD_North, function() SEF_USAEFDRONESPAWN("Ramat David", "Jirah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kuweires", SupportMenuDRONE_RD_North, function() SEF_USAEFDRONESPAWN("Ramat David", "Kuweires") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Minakh", SupportMenuDRONE_RD_North, function() SEF_USAEFDRONESPAWN("Ramat David", "Minakh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Taftanaz", SupportMenuDRONE_RD_North, function() SEF_USAEFDRONESPAWN("Ramat David", "Taftanaz") end, nil)
	]]--
	--////SOUTHERN SYRIA
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Al-Dumayr", SupportMenuDRONE_RD_South, function() SEF_USAEFDRONESPAWN("Ramat David", "Al-Dumayr") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector An Nasiriyah", SupportMenuDRONE_RD_South, function() SEF_USAEFDRONESPAWN("Ramat David", "An Nasiriyah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Damascus", SupportMenuDRONE_RD_South, function() SEF_USAEFDRONESPAWN("Ramat David", "Damascus") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Khalkhalah", SupportMenuDRONE_RD_South, function() SEF_USAEFDRONESPAWN("Ramat David", "Khalkhalah") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan North", SupportMenuDRONE_RD_South, function() SEF_USAEFDRONESPAWN("Ramat David", "Marj as Sultan North") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj as Sultan South", SupportMenuDRONE_RD_South, function() SEF_USAEFDRONESPAWN("Ramat David", "Marj as Sultan South") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Marj Ruhayyil", SupportMenuDRONE_RD_South, function() SEF_USAEFDRONESPAWN("Ramat David", "Marj Ruhayyil") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Mezzeh", SupportMenuDRONE_RD_South, function() SEF_USAEFDRONESPAWN("Ramat David", "Mezzeh") end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Qabr as Sitt", SupportMenuDRONE_RD_South, function() SEF_USAEFDRONESPAWN("Ramat David", "Qabr as Sitt") end, nil)	
end	

--////End Radio Menu Functions
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////OVERRIDE FUNCTIONS

function SEF_ToggleCustomSounds()

	if ( CustomSoundsEnabled == 0 ) then
		CustomSoundsEnabled = 1
		trigger.action.outText("Custom Sounds Are Now Enabled", 15)
	elseif ( CustomSoundsEnabled == 1 ) then
		CustomSoundsEnabled = 0
		trigger.action.outText("Custom Sounds Are Now Disabled", 15)
	else		
	end
end

function SEF_ClearAITankersFromCarrierDeck()
	if ( GROUP:FindByName(ARCOGROUPNAME) ~= nil and GROUP:FindByName(ARCOGROUPNAME):IsAlive() ) then
		Group.getByName(ARCOGROUPNAME):destroy()
		trigger.action.outText("Tanker Arco Has Been Cleared", 15)
	else
		trigger.action.outText("Tanker Arco Is Not Currently Deployed", 15)
	end	
end

--////End Override Functions
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--[[
--////BLUE AWACS/TANKER SPAWN

function SEF_USAFAWACS_SCHEDULER()    
	
	if ( GROUP:FindByName(USAFAWACSGROUPNAME) ~= nil and GROUP:FindByName(USAFAWACSGROUPNAME):IsAlive() ) then				
		timer.scheduleFunction(SEF_USAFAWACS_SCHEDULER, nil, timer.getTime() + 300)			
	else
		SEF_USAFAWACS_SPAWN()		
		timer.scheduleFunction(SEF_USAFAWACS_SCHEDULER, nil, timer.getTime() + 300)
	end		
end

function SEF_USAFAWACS_SPAWN()

	USAFAWACS_DATA[1].Vec2 = nil
	USAFAWACS_DATA[1].TimeStamp = nil
	
	local Phase = SEF_BattlePhaseCheckAwacsTankers()
	
	if ( Phase <= 2 ) then
	
		USAFAWACS = SPAWN
			:New( "USAF AWACS" )
			:InitKeepUnitNames(true)
			:OnSpawnGroup(
				function( SpawnGroup )								
					USAFAWACSGROUPNAME = SpawnGroup.GroupName
					--USAFAWACSGROUPID = Group.getByName(USAFAWACSGROUPNAME):getID()												
				end
			)		
		:Spawn()
		env.info("AWACS Spawned Phase 1/2", false)
	else
		USAFAWACS = SPAWN
			:New( "USAF AWACS" )
			:InitKeepUnitNames(true)
			:OnSpawnGroup(
				function( SpawnGroup )								
					USAFAWACSGROUPNAME = SpawnGroup.GroupName
					--USAFAWACSGROUPID = Group.getByName(USAFAWACSGROUPNAME):getID()												
				end
			)		
		:Spawn()
		env.info("AWACS Spawned Phase 3/4", false)
	end	
end

function SEF_TEXACO_SCHEDULER()    
	
	if ( GROUP:FindByName(TEXACOGROUPNAME) ~= nil and GROUP:FindByName(TEXACOGROUPNAME):IsAlive() ) then				
		timer.scheduleFunction(SEF_TEXACO_SCHEDULER, nil, timer.getTime() + 300)			
	else
		SEF_TEXACO_SPAWN()		
		timer.scheduleFunction(SEF_TEXACO_SCHEDULER, nil, timer.getTime() + 300)
	end		
end

function SEF_TEXACO_SPAWN()	
			
	TEXACO_DATA[1].Vec2 = nil
	TEXACO_DATA[1].TimeStamp = nil
	
	local Phase = SEF_BattlePhaseCheckAwacsTankers()
	
	if ( Phase <= 2 ) then	
		TEXACO = SPAWN
			:New( "22nd ARW Texaco" )
			:InitKeepUnitNames(true)
			:OnSpawnGroup(
				function( SpawnGroup )								
					TEXACOGROUPNAME = SpawnGroup.GroupName
					--TEXACOGROUPID = Group.getByName(TEXACOGROUPNAME):getID()												
				end
			)		
		:Spawn()
		env.info("TEXACO Spawned Phase 1/2", false)
	else
		TEXACO = SPAWN
			:New( "22nd ARW Texaco" )
			:InitKeepUnitNames(true)
			:OnSpawnGroup(
				function( SpawnGroup )								
					TEXACOGROUPNAME = SpawnGroup.GroupName
					--TEXACOGROUPID = Group.getByName(TEXACOGROUPNAME):getID()												
				end
			)		
		:Spawn()
		env.info("TEXACO Spawned Phase 3/4", false)
	end	
end

function SEF_SHELL_SCHEDULER()    
	
	if ( GROUP:FindByName(SHELLGROUPNAME) ~= nil and GROUP:FindByName(SHELLGROUPNAME):IsAlive() ) then				
		timer.scheduleFunction(SEF_SHELL_SCHEDULER, nil, timer.getTime() + 300)			
	else
		SEF_SHELL_SPAWN()		
		timer.scheduleFunction(SEF_SHELL_SCHEDULER, nil, timer.getTime() + 300)
	end		
end

function SEF_SHELL_SPAWN()	
			
	SHELL_DATA[1].Vec2 = nil
	SHELL_DATA[1].TimeStamp = nil
	
	local Phase = SEF_BattlePhaseCheckAwacsTankers()
	
	if ( Phase <= 2 ) then
		SHELL = SPAWN
			:New( "22nd ARW Shell" )
			:InitKeepUnitNames(true)
			:OnSpawnGroup(
				function( SpawnGroup )								
					SHELLGROUPNAME = SpawnGroup.GroupName
					--SHELLGROUPID = Group.getByName(SHELLGROUPNAME):getID()												
				end
			)		
		:Spawn()
		env.info("SHELL Spawned Phase 1/2", false)
	else
		SHELL = SPAWN
			:New( "22nd ARW Shell" )
			:InitKeepUnitNames(true)
			:OnSpawnGroup(
				function( SpawnGroup )								
					SHELLGROUPNAME = SpawnGroup.GroupName
					--SHELLGROUPID = Group.getByName(SHELLGROUPNAME):getID()												
				end
			)		
		:Spawn()
		env.info("SHELL Spawned Phase 3/4", false)
	end
end

function SEF_ARCO_SCHEDULER()    
	
	if ( GROUP:FindByName(ARCOGROUPNAME) ~= nil and GROUP:FindByName(ARCOGROUPNAME):IsAlive() ) then				
		timer.scheduleFunction(SEF_ARCO_SCHEDULER, nil, timer.getTime() + 300)			
	else
		SEF_ARCO_SPAWN()		
		timer.scheduleFunction(SEF_ARCO_SCHEDULER, nil, timer.getTime() + 300)
	end		
end

function SEF_ARCO_SPAWN()	
			
	ARCO_DATA[1].Vec2 = nil
	ARCO_DATA[1].TimeStamp = nil
	
	ARCO = SPAWN
		:New( "22nd ARW Arco" )
		:InitKeepUnitNames(true)
		:OnSpawnGroup(
			function( SpawnGroup )								
				ARCOGROUPNAME = SpawnGroup.GroupName
				--ARCOGROUPID = Group.getByName(ARCOGROUPNAME):getID()												
			end
		)		
	:Spawn()
	env.info("ARCO Spawned", false)
end
]]--
--////End Blue Awacs/Tankers Spawn
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////TARGET SMOKE FUNCTIONS

function SEF_TargetSmokeLock()
	TargetSmokeLockout = 1
end

function SEF_TargetSmokeUnlock()
	TargetSmokeLockout = 0
end

function SEF_TargetSmoke()
	
	if ( TargetSmokeLockout == 0 ) then
		if ( AGTargetTypeStatic == false and AGMissionTarget ~= nil ) then
			--TARGET IS NOT STATIC					
			if ( GROUP:FindByName(AGMissionTarget):IsAlive() == true ) then
				--GROUP VALID
				SEFTargetSmokeGroupCoord = GROUP:FindByName(AGMissionTarget):GetCoordinate()
				SEFTargetSmokeGroupCoord:SmokeRed()
				--SEFTargetSmokeGroupCoord:SmokeBlue()
				--SEFTargetSmokeGroupCoord:SmokeGreen()
				--SEFTargetSmokeGroupCoord:SmokeOrange()
				--SEFTargetSmokeGroupCoord:SmokeWhite()
				
				if ( CustomSoundsEnabled == 1) then
					trigger.action.outSound('Target Smoke.ogg')
				else
				end	
				trigger.action.outText("Target Has Been Marked With Red Smoke", 15)
				SEF_TargetSmokeLock()
				timer.scheduleFunction(SEF_TargetSmokeUnlock, 53, timer.getTime() + 300)				
			else			
				trigger.action.outText("Target Smoke Currently Unavailable - Unable To Acquire Target Group", 15)						
			end		
		elseif ( AGTargetTypeStatic == true and AGMissionTarget ~= nil ) then		
			--TARGET IS STATIC		
			if ( StaticObject.getByName(AGMissionTarget) ~= nil and StaticObject.getByName(AGMissionTarget):isExist() == true ) then
				--STATIC IS VALID
				SEFTargetSmokeStaticCoord = STATIC:FindByName(AGMissionTarget):GetCoordinate()
				SEFTargetSmokeStaticCoord:SmokeRed()
				--SEFTargetSmokeStaticCoord:SmokeBlue()
				--SEFTargetSmokeStaticCoord:SmokeGreen()
				--SEFTargetSmokeStaticCoord:SmokeOrange()
				--SEFTargetSmokeStaticCoord:SmokeWhite()
				if ( CustomSoundsEnabled == 1) then
					trigger.action.outSound('Target Smoke.ogg')
				else
				end		
				trigger.action.outText("Target Has Been Marked With Red Smoke", 15)
				SEF_TargetSmokeLock()
				timer.scheduleFunction(SEF_TargetSmokeUnlock, 53, timer.getTime() + 300)				
			else
				trigger.action.outText("Target Smoke Currently Unavailable - Unable To Acquire Target Building", 15)	
			end			
		else		
			trigger.action.outText("Target Smoke Currently Unavailable - No Valid Targets", 15)
		end
	else
		trigger.action.outText("Target Smoke Currently Unavailable - Smoke Shells Are Being Reloaded", 15)
	end	
end

--////End Target Smoke Functions
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////OTHER FUNCTIONS
--[[
function SEF_BattlePhaseCheck()

--
	"Abu al-Duhur"
	"Adana Sakirpasa"
	"Aleppo"
	"Al-Dumayr"
	"Al Qusayr"
	"An Nasiriyah"
	"Bassel Al-Assad"
	"Beirut-Rafic Hariri"
	"Damascus"
	"Eyn Shemer"
	"Haifa"
	"Hama"
	"Hatay"
	"Incirlik"
	"Jirah"
	"King Hussein Air College"
	"Kiryat Shmona"
	"Khalkhalah"
	"Kuweires"
	"Marj as Sultan North"
	"Marj as Sultan South"
	"Marj Ruhayyil"
	"Megiddo"
	"Mezzeh"
	"Minakh"
	"Palmyra"
	"Qabr as Sitt"
	"Ramat David"
	"Rayak"
	"Rene Mouawad"
	"Tabqa"
	"Taftanaz"
	"Wujah Al Hajar"
--	
	
	if ( 		Airbase.getByName("Adana Sakirpasa"):getCoalition() ~= 2 or
				Airbase.getByName("Hatay"):getCoalition() ~= 2 or			
				Airbase.getByName("Haifa"):getCoalition() ~= 2 or
				Airbase.getByName("Eyn Shemer"):getCoalition() ~= 2 or
				Airbase.getByName("Megiddo"):getCoalition() ~= 2 or
				Airbase.getByName("King Hussein Air College"):getCoalition() ~= 2 or
				Airbase.getByName("Kiryat Shmona"):getCoalition() ~= 2 ) then
			
				--Then we must be in Phase 1
				trigger.action.outText("Mission Objective\n\nPhase 1 - Secure Turkey And Israel\n\nThe Following Territories Must Be Captured And Held:\n\nAdana Sakirpasa\nHatay\nHaifa\nEyn Shemer\nMegiddo\nKing Hussein Air College\nKiryat Shmona", 15)
	
	elseif ( 	Airbase.getByName("Beirut-Rafic Hariri"):getCoalition() ~= 2 or
				Airbase.getByName("Rayak"):getCoalition() ~= 2 or
				Airbase.getByName("Rene Mouawad"):getCoalition() ~= 2 or
				Airbase.getByName("Wujah Al Hajar"):getCoalition() ~= 2 ) then
				
				--Then we must be in Phase 2
				trigger.action.outText("Mission Objective\n\nPhase 2 - Secure Lebanon\n\nThe Following Territories Must Be Captured And Held:\n\nBeirut-Rafic Hariri\nRayak\nRene Mouawad\nWujah Al Hajar", 15)
				
	elseif (	Airbase.getByName("Minakh"):getCoalition() ~= 2 or
				Airbase.getByName("Taftanaz"):getCoalition() ~= 2 or
				Airbase.getByName("Abu al-Duhur"):getCoalition() ~= 2 or 
				Airbase.getByName("Aleppo"):getCoalition() ~= 2 or
				Airbase.getByName("Kuweires"):getCoalition() ~= 2 or
				Airbase.getByName("Jirah"):getCoalition() ~= 2 or
				Airbase.getByName("Bassel Al-Assad"):getCoalition() ~= 2 or
				Airbase.getByName("Hama"):getCoalition() ~= 2 or
				Airbase.getByName("Al Qusayr"):getCoalition() ~= 2 ) then
	
				--Then we must be in Phase 3
				trigger.action.outText("Mission Objective\n\nPhase 3 - Occupation Of Syria\n\nThe Following Territories Must Be Captured And Held:\n\nMinakh\nTaftanaz\nAbu al-Duhur\nAleppo\nKuweires\nJirah\nBassel Al-Assad\nHama\nAl Qusayr", 15)
				
	elseif (	Airbase.getByName("Khalkhalah"):getCoalition() ~= 2 or
				Airbase.getByName("Marj Ruhayyil"):getCoalition() ~= 2 or
				Airbase.getByName("Damascus"):getCoalition() ~= 2 or
				Airbase.getByName("Mezzeh"):getCoalition() ~= 2 or
				Airbase.getByName("Qabr as Sitt"):getCoalition() ~= 2 or
				Airbase.getByName("Marj as Sultan North"):getCoalition() ~= 2 or
				Airbase.getByName("Marj as Sultan South"):getCoalition() ~= 2 or
				Airbase.getByName("Al-Dumayr"):getCoalition() ~= 2 or
				Airbase.getByName("An Nasiriyah"):getCoalition() ~= 2 ) then
				
				--Then we must be in Phase 4
				trigger.action.outText("Mission Objective\n\nPhase 4 - Invasion Of Damascus\n\nThe Following Territories Must Be Captured And Held:\n\nKhalkhalah\nMarj Ruhayyil\nDamascus\nMezzeh\nQabr as Sitt\nMarj as Sultan North\nMarj as Sultan South\nAl-Dumayr\nAn Nasiriyah", 15)
	else
		trigger.action.outText("Unable To Determine Phase", 15)
	end
end
]]--
--[[
function SEF_BattlePhaseCheckAwacsTankers()

	if ( 		Airbase.getByName("Adana Sakirpasa"):getCoalition() ~= 2 or
				Airbase.getByName("Hatay"):getCoalition() ~= 2 or			
				Airbase.getByName("Haifa"):getCoalition() ~= 2 or
				Airbase.getByName("Eyn Shemer"):getCoalition() ~= 2 or
				Airbase.getByName("Megiddo"):getCoalition() ~= 2 or
				Airbase.getByName("King Hussein Air College"):getCoalition() ~= 2 or
				Airbase.getByName("Kiryat Shmona"):getCoalition() ~= 2 ) then
			
				--Then we must be in Phase 1
				return 1
	
	elseif ( 	Airbase.getByName("Beirut-Rafic Hariri"):getCoalition() ~= 2 or
				Airbase.getByName("Rayak"):getCoalition() ~= 2 or
				Airbase.getByName("Rene Mouawad"):getCoalition() ~= 2 or
				Airbase.getByName("Wujah Al Hajar"):getCoalition() ~= 2 ) then
				
				--Then we must be in Phase 2
				return 2
				
	elseif (	Airbase.getByName("Minakh"):getCoalition() ~= 2 or
				Airbase.getByName("Taftanaz"):getCoalition() ~= 2 or
				Airbase.getByName("Abu al-Duhur"):getCoalition() ~= 2 or 
				Airbase.getByName("Aleppo"):getCoalition() ~= 2 or
				Airbase.getByName("Kuweires"):getCoalition() ~= 2 or
				Airbase.getByName("Jirah"):getCoalition() ~= 2 or
				Airbase.getByName("Bassel Al-Assad"):getCoalition() ~= 2 or
				Airbase.getByName("Hama"):getCoalition() ~= 2 or
				Airbase.getByName("Al Qusayr"):getCoalition() ~= 2 ) then
	
				--Then we must be in Phase 3
				return 3
				
	elseif (	Airbase.getByName("Khalkhalah"):getCoalition() ~= 2 or
				Airbase.getByName("Marj Ruhayyil"):getCoalition() ~= 2 or
				Airbase.getByName("Damascus"):getCoalition() ~= 2 or
				Airbase.getByName("Mezzeh"):getCoalition() ~= 2 or
				Airbase.getByName("Qabr as Sitt"):getCoalition() ~= 2 or
				Airbase.getByName("Marj as Sultan North"):getCoalition() ~= 2 or
				Airbase.getByName("Marj as Sultan South"):getCoalition() ~= 2 or
				Airbase.getByName("Al-Dumayr"):getCoalition() ~= 2 or
				Airbase.getByName("An Nasiriyah"):getCoalition() ~= 2 ) then
				
				--Then we must be in Phase 4
				return 4
	else
		return 1
	end
end
]]--

function SEF_TestMissionList()

	--This function should only be run to perform integrity check on the mission list before any targets are killed
	MissionListErrors = 0
	
	for i = 1, #OperationScarletDawn_AG do		
		--trigger.action.outText("Looking at element "..i,15)
		if ( OperationScarletDawn_AG[i].TargetStatic == true ) then
			if ( StaticObject.getByName(OperationScarletDawn_AG[i].TargetName) ~= nil ) then
				--Pass
			else
				trigger.action.outText("Static "..OperationScarletDawn_AG[i].TargetName.." Could Not Be Found", 15)
				MissionListErrors = MissionListErrors + 1
			end			
		else
			if ( Group.getByName(OperationScarletDawn_AG[i].TargetName) ~=nil ) then
				--Pass
			else
				trigger.action.outText("Group "..OperationScarletDawn_AG[i].TargetName.." Could Not Be Found", 15)
				MissionListErrors = MissionListErrors + 1
			end			
		end	
	end
	
	if MissionListErrors > 0 then
		trigger.action.outText("Warning - Mission List "..MissionListErrors.." Errors", 15)
	else
		trigger.action.outText("Mission List Passed Integrity Check", 15)
	end		
end

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- BFM AWACS
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function SEF_SPAWNBLUEAWACS()
  if ( GROUP:FindByName("BFM_BLUE_AWACS") ~= nil and GROUP:FindByName("BFM_BLUE_AWACS"):IsAlive() ) then
    trigger.action.outText("Blue AWACS Already Spawned", 15)
  else
    SPAWN:New("BFM_BLUE_AWACS"):InitLimit(1,99):Spawn()
    trigger.action.outText("Blue AWACS Spawned", 15)
  end
end

function SEF_CLEARBLUEAWACS()

    BlueAWACS=SET_GROUP:New():FilterPrefixes("BFM_BLUE_AWACS"):FilterActive(true):FilterOnce()
    
    local BlueAWACSount=BlueAWACS:Count()
      for i = 1, BlueAWACSount do
        local grpObj = BlueAWACS:GetRandom()
        --env.info(grpObj:GetName())
        grpObj:Destroy(true)
      end    
      trigger.action.outText("Blue AWACS Has Been Cleared", 15)
end

function SEF_SPAWNREDAWACS()
  if ( GROUP:FindByName("BFM_RED_AWACS") ~= nil and GROUP:FindByName("BFM_RED_AWACS"):IsAlive() ) then
    trigger.action.outText("Red AWACS Already Spawned", 15)
  else
    SPAWN:New("BFM_RED_AWACS"):InitLimit(1,99):Spawn()
    trigger.action.outText("Red AWACS Spawned", 15)
    
  end
end

function SEF_CLEARREDAWACS()

    RedAWACS=SET_GROUP:New():FilterPrefixes("BFM_RED_AWACS"):FilterActive(true):FilterOnce()
    
    local RedAWACScount=RedAWACS:Count()
      for i = 1, RedAWACScount do
        local grpObj = RedAWACS:GetRandom()
        --env.info(grpObj:GetName())
        grpObj:Destroy(true)
      end    
      trigger.action.outText("Red AWACS Has Been Cleared", 15)
end

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- RED CLEANUP
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function SEF_CLEARALLRED()

    RedBFM=SET_GROUP:New():FilterPrefixes("AI"):FilterActive(true):FilterOnce()
    
    local RedBFMcount=RedBFM:Count()
      for i = 1, RedBFMcount do
        local grpObj = RedBFM:GetRandom()
        --env.info(grpObj:GetName())
        grpObj:Destroy(true)
      end    
      trigger.action.outText("All Red Fighters Have Been Cleared", 15)
end

--////End Other Functions
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////MAIN

	--////GLOBAL VARIABLE INITIALISATION	
	NumberOfCompletedMissions = 0
	TotalScenarios = 168
	OperationComplete = false
	CustomSoundsEnabled = 0
	SoundLockout = 0
	TargetSmokeLockout = 0	
						
	--////FUNCTIONS
	--SEF_InitializeMissionTable()
	--SEF_TestMissionList()	
	--timer.scheduleFunction(SEF_MissionSelector, 53, timer.getTime() + 17)
	SEF_RadioMenuSetup()
	
	--////START SUPPORT FLIGHT SCHEDULERS, DELAY ARCO BY 15 MINUTES TO ALLOW CARRIER PLANES TO SPAWN AND CLEAR DECK
	--SEF_USAFAWACS_SCHEDULER()	
	--SEF_TEXACO_SCHEDULER()
	--SEF_SHELL_SCHEDULER()	
	--timer.scheduleFunction(SEF_ARCO_SCHEDULER, nil, timer.getTime() + 900)
		
	--////SCHEDULERS
	--MISSION TARGET STATUS
	--timer.scheduleFunction(SEF_MissionTargetStatus, 53, timer.getTime() + 27)		
	
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--[[

--////EARLY WARNING RADARS - 20 (20 units)

Al Bab - EWR 						CA52	*
Aleppo - EWR 						CA40	*
Tabqa - EWR 						DV65	*
Dar Ta'izzah - EWR 					CA01	*
Idlib - EWR 						BV79	*
Qaranjah - EWR South 				YE56	*
Sett Markho - EWR 					YE54	*
Baniyas - EWR 						YD79	*
Tartus - EWR East 					YD76	*
Homs - EWR 							BU93	*
Hama - EWR 							BU97	*
Palmyra - EWR 						DU32	*
Busra - EWR 						BS53	*
Marj Ruhayyil - EWR 				BS58	*
Damascus - EWR South 				BS49	*
Damascus - EWR North 				BT41	*
Damascus - EWR East 				BT60	*
Al Dumayr - EWR North 				BT92	*
Al Dumayr - EWR South 				BT92	*
Al Dumayr - EWR West 				BT71	*

--////SA-5 SITES - 4 (56 units)

Damascus - SA-5 					BT81	*	
Khalkhalah - SA-5 					BS77	*
Homs - SA-5 						BU93	*
Masyaf - SA-5 						BU59	*

--////SA-2 SITES - 11 (97 units)

Latakia - SA-2 North 				YE55	*
Bassel Al-Assad - SA-2 				YE62	*
Tartus - SA-2 South 				YD65	*
Al Safirah - SA-2 					CV59	*
Hama - SA-2 North-West 				BU89	*
Homs - SA-2 West 					BU74	*
Khirbet Ghazaleh - SA-2 North 		BS33	*
Al Dumayr - SA-2 East 1 			CT02	*
Damascus - SA-2 					BT60	*
Mezzeh - SA-2 West 					BS39	*
Saraqib - SA-2						CV07	*
Aleppo - SA-2 South					CV39	*

--////SA-3 SITES - 11 (67 units)

Latakia - SA-3 South-East 			YE53	*
Bassel Al-Assad - SA-3 				YE62	*
Tartus - SA-3 South-East 			YD76	*
Homs - SA-3 East 					BU94	*
Hama - SA-3 North-East 				CV01	*
Aleppo - SA-3 East 					CA60	*
El Hajar Al Aswad - SA-3 			BT50	*
Hayjanah - SA-3 					BS79	*
Al Dumayr - SA-3 South 				BT91	*
Jasim - SA-3 South-East 			BS34	*
Abu al-Duhur - SA-3					CV25	*
Aleppo - SA-3 West					CA20/21	*

--////SA-6 SITES - 8 (48 units)

Homs - SA-6 South 					BU93	*
Hama - SA-6 South 					BU98	*
Mezzeh - SA-6 South-West 			BS39	*
Otaybah - SA-6 North 				BT71	*
Otaybah - SA-6 South-East 			BT80	*
Kanaker - SA-6 East 				BS38	*
Izra - SA-6 East 					BS43	*
Izra - SA-6 West 					BS43	*

--////SA-8 SITES - 4 (4 units)

Al Qutayfah - SA-8 					BT83	*
Damascus - SA-8 					BT41	*
Mezzeh - SA-8 						BT40	*
Latakia - SA-8 						YE55	*


--////SA-13 SITES - 2 (2 units)

An Nasiriyah - SA-13 				CT05	*
Khalkhalah - SA-13 					BS76	*


--////SAMS AND EWR TOTAL 276 UNITS


--////SHIPPING - 6 (17 units)

Latakia - Navy 						YE			*
Tartus - Navy 						YE/YD		*
Latakia - Speedboat 				YE43/53		*
Tartus - Speedboat 					YD66		*
Latakia - Cargo Ship 				YE53		*
Tartus - Cargo Ship 				YD66		*

--////COMMS TOWERS - 8 (8 Statics)

Aleppo - Communications 			CA30	*
Latakia - Communications 			YE53	*
Tartus - Communications 			YD66	*
Homs - Communications 				BU84	*
Hama - Communications 				BU96	*
Damascus - Communications West 		BT41	*
Damascus - Communications East 		BT60	*
Golan Heights - Communications 		YB65	*


--////AAA - 13 (50 Units)

Aleppo - AAA						CA20/21/30/31	5 units		*
Al Safira - AAA						CV49/59			3 units		*
Latakia - AAA						YE43/53			5 units		*
Tartus - AAA						YD66			3 units		*
Homs - AAA							BU84/94			5 units		*
Homs - AAA South					BU93			3 units		*
Hama - AAA							BU89/98/99		5 units		*
Mezzeh - AAA						BS39/49/BT40/50	4 units		*
Damascus - AAA						BT41/50/60		5 units		*
Al Dumayr - AAA						BT81/91			3 units		*
Golan Heights - AAA					BS33/34/43		4 units		*
Bassel Al-Assad - AAA				YE62			3 units		*
Khalkhalah - AAA					BS76			2 units		*

--////ARMOR - 10 (54 Units)

Aleppo - Armor						CA20/31/40		12 units	*
Latakia - Armor						YE53			3 units		*
Tartus - Armor						YD66			3 units		*
Homs - Armor						BU74/94			6 units		*
Homs - Armor South					BU93			2 units		*
Hama - Armor						BU89/98/99		8 units		*
Mezzeh - Armor						BT30			4 units		*
Al Dumayr - Armor					BT82			3 units		*
Damascus - Armor					BS49/59			7 units		*
Khirbet Ghazaleh - Armor			BS32			6 units		*


--////ARTILLERY AND MISSILES - 8 (30 Units)

Latakia - Silkworm					YE43/53			5 units		*
Tartus - Silkworm					YD67			5 units		*
Mezzeh - Scud Launcher				BT30			4 units		*
Homs - Artillery					BU93			3 units		*
Hama - Artillery					BU98			3 units		*
Aleppo - Artillery					CA40			4 units		*
Izra - Scud Launcher				BS43			4 units		*
Al Dumayr - Artillery				BT92			2 units		*

--////INFANTRY - 6 (20 units)

Aleppo - Igla						CA30/40			3 units		Do Not Include In List	
Damascus - Igla						BT41			3 units		Do Not Include In List
Homs - Igla							BU94			3 units		Do Not Include In List
Hama - Igla							BU98/99			3 units		Do Not Include In List	
Latakia - Igla						YE53			2 units		Do Not Include In List
Tartus - Igla						YD66			2 units		Do Not Include In List

--////STATICS - 16 (16 Units)

Al Safirah - Barracks				CV59	*
Al Safirah - Research Hangar		CV58	*
Latakia - Naval Warehouse			YE53	*
Tartus - Naval Warehouse			YD66	*
Homs - Military HQ					BU93	*
Mezzeh - Missile Storage			BT30	*
Alsqublh - Barracks					BU39	*
Alsqublh - Military HQ				BU39	*
Barisha - Compound					BA80	*
Jarmaya - Weapons Hangar			BT41	*
Masyaf - Weapons Hangar	South		BU58	*
Masyaf - Weapons Hangar North		BU58	*
Aleppo - Repair Workshop			CA40	*
Latakia - Ammunition Warehouse		YE53	*
Raqqa - ISIS HQ						EV07	*
Hama - Warehouse					BU98	*



--////UNARMED - 5 (12 Units)

Masyaf - Supply Truck South			BU58 2 Units	*
Masyaf - Supply Truck North			BU58 3 Units	*
Hama - Supply Truck					BU98 3 Units	*
Al Safirah - Supply Truck			CV59 2 Units	*
Mezzeh - Supply Truck				BT30 2 Units	*


--////SPECIAL NAMED UNITS - 2 (2 Units)

Abu Bakr al-Baghdadi				BA80 1 Unit		*	
Abu Muhammad al-Halabi				BA80 1 Unit		*


--////SPECIAL GROUPS - 4 (14 Units)

Barisha - Insurgent 				BA80 5 units		*
Raqqa - ISIS Tank					EV07 4 units		*
Raqqa - ISIS Igla					EV07 2 units		*
Raqqa - ISIS AAA					DV97/EV07 3 units	*



--////IDLIB

Idlib - AAA							BV87 3 units	*
Idlib - Armor						BV87 6 units	*
Idlib - Supply Truck				BV87 3 units	*
Idlib - Military HQ					BV87 1 static	*
Idlib - Igla						BV87 2 units	Do Not Include



--////SA-15

Latakia - SA-15						YE53 (1 unit)
Tartus - SA-15						YD65 (1 unit)
Aleppo - SA-15						CA50 (1 unit)
Damascus - SA-15					BT50 (1 unit)
Izra - SA-15						BS33 (1 unit)


Idlib - Igla Supply
Aleppo - Igla Supply
Latakia - Igla Supply
Tartus - Igla Supply
Damascus - Igla Supply
Homs - Igla Supply
Hama - Igla Supply
Raqqa - ISIS Supply



--AAA
--ARMOR
--ARTILLERY AND MISSILES
--INFANTRY
--UNARMED
--STATICS

ALEPPO
LATAKIA
TARTUS
HOMS
HAMA
MEZZEH
DAMASCUS
AL-DUMAYR
GOLAN HEIGHTS

]]--
env.info("Mission Complete", false)
