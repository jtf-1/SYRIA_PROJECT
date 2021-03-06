--//////////////////////////////////////////////////////////
-- Name: Operation Scarlet Dawn - Generals Module
-- Author: Surrexen    à¼¼ ã�¤ â—•_â—• à¼½ã�¤    (ã�¥ï½¡â—•â€¿â—•ï½¡)ã�¥ 
--//////////////////////////////////////////////////////////

--[[
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
]]--

-------------------------------------------------------------------------------------------------------------------------------------------------
--////VARIABLES

IranianCICName 				= "Major General Seyyed Abdolrahim Mousavi"
IranianAirforceGeneralName 	= "Brigadier General Aziz Nasirzadeh"
IranianNavyAdmiralName 		= "Rear Admiral Hossein Khanzadi"
RussianCICName 				= "General of the Army Valery Vasilyevich Gerasimov"
RussianAirforceGeneralName 	= "Colonel General Sergei Vladimirovich Surovikin"
RussianNavyAdmiralName 		= "Admiral Nikolai Yevmenov"
USAFCICName					= "President Donald Trump"
USAFAirforceGeneralName		= "General David Goldfein"
USAFNavyAdmiralName			= "Admiral Michael Gilday"
SyAAFCICName				= "Bashar al-Assad"
SyAAFAirforceGeneralName	= "General Issam Hallaq"

BlueStrikeFrequencyMin 	= 900	
BlueStrikeFrequencyMax 	= 1200	
RedStrikeFrequencyMin 	= 7200	
RedStrikeFrequencyMax 	= 86400

SYAAFAN26BGROUPNAME = ""
IRIAFMI8GROUPNAME = ""
USAFC130GROUPNAME = ""
USAFUH60AGROUPNAME = ""
SYAAFSU24MGROUPNAME = ""
VVSSU25TGROUPNAME = ""
VVSTU95MSGROUPNAME = ""
VVSTU160GROUPNAME = ""
VVSTU22M3GROUPNAME = ""

CaptureMessageLockout = 300

AutomatedBlueStrikes = 0

CustomSoundsEnabled = 0

-------------------------------------------------------------------------------------------------------------------------------------------------
--////TABLES

SEF_AIRBASES = {
  --"Abu al-Duhur",
  --"Adana Sakirpasa",
  --"Aleppo",
  "Al-Dumayr",
  "Al Qusayr",
  "An Nasiriyah",
  --"Bassel Al-Assad",
  "Beirut-Rafic Hariri",
  "Damascus",
  "Eyn Shemer",
  --"Gaziantep",
  "H4",
  "Haifa",
  --"Hama",
  --"Hatay",
  --"Incirlik",
  --"Jirah",
  "King Hussein Air College",
  "Kiryat Shmona",
  "Khalkhalah",
  --"Kuweires",
  "Marj as Sultan North",
  "Marj as Sultan South",
  "Marj Ruhayyil",
  "Megiddo",
  "Mezzeh",
  --"Minakh",
  "Naqoura",
  "Palmyra",
  "Qabr as Sitt",
  "Ramat David",
  "Rayak",
  "Rene Mouawad",
  "Rosh Pina",
  "Sayqal",
  "Shayrat",
  --"Tabqa",
  --"Taftanaz",
  "Tiyas",
  "Tha'lah",
  "Wujah Al Hajar"
}

SEF_OFFLIMITSAIRBASESFORRED   = { "Aleppo", "Ramat David", "Megiddo", "Abu al-Duhur", "Adana Sakirpasa", "Bassel Al-Assad", "Gaziantep", "Hama", "Hatay", "Incirlik", "Jirah", "Kuweires", "Minakh", "Tabqa", "Taftanaz" }
              
SEF_OFFLIMITSAIRBASESFORBLUE  = { "Aleppo", "Palmyra", "Abu al-Duhur", "Adana Sakirpasa", "Bassel Al-Assad", "Gaziantep", "Hama", "Hatay", "Incirlik", "Jirah", "Kuweires", "Minakh", "Tabqa", "Taftanaz"  }
  							
CurrentRedAirbases ={}						-- All current red airbases
CurrentBlueAirbases ={}						-- All current blue airbases
CurrentNeutralAirbases ={}					-- All current neutral airbases
CurrentNonRedAirbases = {}					-- All current non-red airbases
CurrentNonBlueAirbases = {}					-- All current non-blue airbases

CurrentRedNeighbours = {}					-- All non red airfields connected to existing red airfields
CurrentBlueNeighbours = {}					-- All non blue airfields connected to existing blue airfields
CurrentNonRedNeighbours = {}
CurrentNonBlueNeighbours = {}

SortedNoDuplicatesResult = {}
FinalAirbaseSelectionList = {}				-- List filtered against 'off limits' airbases such as Incirlik

-------------------------------------------------------------------------------------------------------------------------------------------------
--////FUNCTIONS

function SEF_GETREDAIRBASES(AirbaseList)
	CurrentRedAirbases ={}
	
	for i, ab in ipairs(AirbaseList) do
		local airbase = Airbase.getByName(ab)
		if ( airbase:getCoalition() == 1 ) then
			table.insert(CurrentRedAirbases, ab)
		end	
	end	
end

function SEF_GETBLUEAIRBASES(AirbaseList)
	CurrentBlueAirbases ={}
	
	for i, ab in ipairs(AirbaseList) do
		local airbase = Airbase.getByName(ab)
		if ( airbase:getCoalition() == 2 ) then
			table.insert(CurrentBlueAirbases, ab)
		end	
	end
end

function SEF_GETNEUTRALAIRBASES(AirbaseList)
	CurrentNeutralAirbases ={}
	
	for i, ab in ipairs(AirbaseList) do
		local airbase = Airbase.getByName(ab)
		if ( airbase:getCoalition() == 0 ) then
			table.insert(CurrentNeutralAirbases, ab)
		end	
	end
end

function SEF_GETNONREDAIRBASES(AirbaseList)
	CurrentNonRedAirbases = {}
	
	for i, ab in ipairs(AirbaseList) do
		local airbase = Airbase.getByName(ab)
		if ( airbase:getCoalition() == 0 or airbase:getCoalition() == 2 ) then
			table.insert(CurrentNonRedAirbases, ab)
		end
	end	
end

function SEF_GETNONBLUEAIRBASES(AirbaseList)
	CurrentNonBlueAirbases = {}
	
	for i, ab in ipairs(AirbaseList) do
		local airbase = Airbase.getByName(ab)
		if ( airbase:getCoalition() == 0 or airbase:getCoalition() == 1 ) then
			table.insert(CurrentNonBlueAirbases, ab)
		end
	end	
end

function SEF_LISTREDAIRBASES()
	
	if ( CurrentRedAirbases[1] ~= nil ) then
	
		trigger.action.outText("Current Red Airbases Are:",15)
		
		for x, y in ipairs(CurrentRedAirbases) do
			trigger.action.outText(y,15)	
		end
	else
		trigger.action.outText("Red Coalition Does Not Have Any Airbases",15)
	end	
end

function SEF_LISTFRONTLINEREDAIRBASES()
	
	if ( CurrentRedAirbases[1] ~= nil ) then
	
		trigger.action.outText("Current Red Front Line Airbases Are:",15)
		
		for x, y in ipairs(CurrentRedAirbases) do
			trigger.action.outText(y,15)	
		end
	else
		trigger.action.outText("Red Coalition Does Not Have Any Front Line Airbases, Which Means Something Is Horribly Wrong",15)
	end	
end

function SEF_LISTBLUEAIRBASES()
	
	if ( CurrentBlueAirbases[1] ~= nil ) then
		trigger.action.outText("Current Blue Airbases Are:",15)
		
		for x, y in ipairs(CurrentBlueAirbases) do
			trigger.action.outText(y,15)	
		end
	else
		trigger.action.outText("Blue Coalition Does Not Have Any Airbases, Which Means Something Is Horribly Wrong",15)
	end	
end

function SEF_LISTNEUTRALAIRBASES()
	
	if ( CurrentNeutralAirbases[1] ~= nil ) then
		trigger.action.outText("Current Neutral Airbases Are:",15)
		
		for x, y in ipairs(CurrentNeutralAirbases) do
			trigger.action.outText(y,15)	
		end
	else
		trigger.action.outText("Neutral Coalition Does Not Have Any Airbases",15)
	end	
end

function SEF_LISTNONREDAIRBASES()
	
	if ( CurrentNonRedAirbases[1] ~= nil ) then
		trigger.action.outText("Current Non-Red Airbases Are:",15)
		
		for x, y in ipairs(CurrentNonRedAirbases) do
			trigger.action.outText(y,15)	
		end
	else
		trigger.action.outText("There Are Currently No Non-Red Airbases",15)
	end	
end

function SEF_LISTNONBLUEAIRBASES()
	
	if ( CurrentNonBlueAirbases[1] ~= nil ) then
		trigger.action.outText("Current Non-Blue Airbases Are:",15)
		
		for x, y in ipairs(CurrentNonBlueAirbases) do
			trigger.action.outText(y,15)	
		end
	else
		trigger.action.outText("There Are Currently No Non-Blue Airbases",15)
	end	
end

-------------------------------------------------------------------------------------------------------------------------------------------------

function SEF_GETTABLELENGTH(Table)
		local TableLengthCount = 0
		for _ in pairs(Table) do TableLengthCount = TableLengthCount + 1 end
		return TableLengthCount		
end

function SEF_CHOOSERANDOMFROMTABLE(Table)
	
	if ( Table[1] ~= nil ) then
		local TableLength = SEF_GETTABLELENGTH(Table)
		local Randomiser = math.random(1,TableLength)		
		return Table[Randomiser]
	else		
		return nil
	end	
end

-------------------------------------------------------------------------------------------------------------------------------------------------

function SEF_GETREDCURRENTNEIGHBOURS()
	
	if ( CurrentRedAirbases[1] ~= nil ) then
				
		CurrentRedNeighbours = {}
				
		for a, b in ipairs(CurrentRedAirbases) do			
			for x, y in ipairs(SEF_AIRBASEINFORMATION) do
				Name = SEF_AIRBASEINFORMATION[x].AirbaseName
				
				if ( Name == b ) then					
					for i=1, #(SEF_AIRBASEINFORMATION[x].Neighbours) do						
						table.insert(CurrentRedNeighbours, SEF_AIRBASEINFORMATION[x].Neighbours[i])					
					end
				else
				end	
			end		
		end	
		SEF_GETREDCURRENTNEIGHBOURSNODUPLICATES()		
	else
		trigger.action.outText("Cannot acquire neighbouring airfields for red coalition as red does not have any airbases", 15)
	end	
end

function SEF_GETBLUECURRENTNEIGHBOURS()
	
	if ( CurrentBlueAirbases[1] ~= nil ) then		
		
		CurrentBlueNeighbours = {}		
		
		for a, b in ipairs(CurrentBlueAirbases) do			
			for x, y in ipairs(SEF_AIRBASEINFORMATION) do
				Name = SEF_AIRBASEINFORMATION[x].AirbaseName
				
				if ( Name == b ) then				
					
					for i=1, #(SEF_AIRBASEINFORMATION[x].Neighbours) do						
						table.insert(CurrentBlueNeighbours, SEF_AIRBASEINFORMATION[x].Neighbours[i])					
					end
				else
				end	
			end		
		end	
		SEF_GETBLUECURRENTNEIGHBOURSNODUPLICATES()		
	else
		trigger.action.outText("Cannot acquire neighbouring airfields for blue coalition as blue does not have any airbases", 15)
	end	
end

function SEF_GETNONREDCURRENTNEIGHBOURS()
	
	if ( CurrentNonRedAirbases[1] ~= nil ) then		
		
		CurrentNonRedNeighbours = {}		
		
		for a, b in ipairs(CurrentNonRedAirbases) do			
			for x, y in ipairs(SEF_AIRBASEINFORMATION) do
				Name = SEF_AIRBASEINFORMATION[x].AirbaseName
				
				if ( Name == b ) then				
					
					for i=1, #(SEF_AIRBASEINFORMATION[x].Neighbours) do						
						table.insert(CurrentNonRedNeighbours, SEF_AIRBASEINFORMATION[x].Neighbours[i])					
					end
				else
				end	
			end		
		end	
		SEF_GETNONREDCURRENTNEIGHBOURSNODUPLICATES()		
	else
		trigger.action.outText("Cannot acquire neighbouring airfields for non-red coalition as non-red does not have any airbases", 15)
	end	
end

function SEF_LISTCURRENTREDNEIGHBOURS()

	for key,value in ipairs(CurrentRedNeighbours) do
		trigger.action.outText(key.." "..value.."", 15)   
	end
end

function SEF_LISTCURRENTBLUENEIGHBOURS()

	for key,value in ipairs(CurrentBlueNeighbours) do
		trigger.action.outText(key.." "..value.."", 15)   
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------

function SEF_SORTREMOVEDUPLICATES(Table)
	
	if ( Table[1] ~= nil ) then
		local TempTable = Table
		table.sort(TempTable)
		SortedNoDuplicatesResult = {}

		for key,value in ipairs(TempTable) do
			if value ~=TempTable[key+1] then
				table.insert(SortedNoDuplicatesResult,value)
			end
		end	
		--Debug Text
		--for key,value in ipairs(SortedNoDuplicatesResult) do
		--	trigger.action.outText(key.." "..value.."", 15)   
		--end				
	else
		trigger.action.outText("Cannot sort table as the table is empty",15)
	end	
end

-------------------------------------------------------------------------------------------------------------------------------------------------

function SEF_REFRESHAIRBASETABLES()
	--Populate the tables to get the current situation, potentially these tables could be empty
	SEF_GETREDAIRBASES(SEF_AIRBASES)
	SEF_GETBLUEAIRBASES(SEF_AIRBASES)
	SEF_GETNEUTRALAIRBASES(SEF_AIRBASES)
	SEF_GETNONREDAIRBASES(SEF_AIRBASES)
	SEF_GETNONBLUEAIRBASES(SEF_AIRBASES)
end

function SEF_GETREDCURRENTNEIGHBOURSNODUPLICATES()
	
	SEF_SORTREMOVEDUPLICATES(CurrentRedNeighbours)	
	CurrentRedNeighbours = SortedNoDuplicatesResult	
end

function SEF_GETBLUECURRENTNEIGHBOURSNODUPLICATES()
	
	SEF_SORTREMOVEDUPLICATES(CurrentBlueNeighbours)	
	CurrentBlueNeighbours = SortedNoDuplicatesResult	
end

function SEF_GETNONREDCURRENTNEIGHBOURSNODUPLICATES()
	
	SEF_SORTREMOVEDUPLICATES(CurrentNonRedNeighbours)	
	CurrentNonRedNeighbours = SortedNoDuplicatesResult	
end

-------------------------------------------------------------------------------------------------------------------------------------------------

function SEF_REDGENERAL_SELECTNEUTRALTARGETAIRBASE()
	
	SEF_REFRESHAIRBASETABLES()
	local NeutralTargetAirbase	= nil
	
	SEF_GETREDCURRENTNEIGHBOURS()																--Get the neighbours list and removes duplicates from itself															
	SEF_GETNEUTRALAIRBASES(CurrentRedNeighbours)												--Get the neutral airbases from the search results																		
	SEF_FINALFILTER(CurrentNeutralAirbases, SEF_OFFLIMITSAIRBASESFORRED)						--Filter list against anything off limits
	NeutralTargetAirbase = SEF_CHOOSERANDOMFROMTABLE(FinalAirbaseSelectionList)					--Pick the random one out of the list of neutrals that are not off limits
	
	--if ( NeutralTargetAirbase ~= nil ) then
	--	trigger.action.outText("Picking Neutral Airbase "..NeutralTargetAirbase,15)
	--end	
	
	return NeutralTargetAirbase	
end

function SEF_REDGENERAL_SELECTBLUETARGETAIRBASE()
	
	SEF_REFRESHAIRBASETABLES()																
	local BlueTargetAirbase = nil
	
	SEF_GETREDCURRENTNEIGHBOURS()	
	SEF_GETBLUEAIRBASES(CurrentRedNeighbours)
	SEF_FINALFILTER(CurrentBlueAirbases, SEF_OFFLIMITSAIRBASESFORRED)
	BlueTargetAirbase = SEF_CHOOSERANDOMFROMTABLE(FinalAirbaseSelectionList)	

	--trigger.action.outText("Picking Defended "..BlueTargetAirbase,15)
	
	return BlueTargetAirbase	
end

function SEF_BLUEGENERAL_SELECTNEUTRALTARGETAIRBASE()
			
	SEF_REFRESHAIRBASETABLES()
	local NeutralTargetAirbase	= nil
	
	SEF_GETBLUECURRENTNEIGHBOURS()																--Get the neighbours list and removes duplicates from itself															
	SEF_GETNEUTRALAIRBASES(CurrentBlueNeighbours)												--Get the neutral airbases from the search results															
	SEF_FINALFILTER(CurrentNeutralAirbases, SEF_OFFLIMITSAIRBASESFORBLUE)						--Filter list against anything off limits
	NeutralTargetAirbase = SEF_CHOOSERANDOMFROMTABLE(FinalAirbaseSelectionList)					--Pick the random one out of the list of neutrals that are not off limits
	
	--if ( NeutralTargetAirbase ~= nil ) then
	--	trigger.action.outText("Picking Neutral Airbase "..NeutralTargetAirbase,15)
	--end	
	
	return NeutralTargetAirbase
end

function SEF_BLUEGENERAL_SELECTREDTARGETAIRBASE()
			
	SEF_REFRESHAIRBASETABLES()																
	local RedTargetAirbase = nil
	
	SEF_GETBLUECURRENTNEIGHBOURS()	
	SEF_GETREDAIRBASES(CurrentBlueNeighbours)
	SEF_FINALFILTER(CurrentRedAirbases, SEF_OFFLIMITSAIRBASESFORBLUE)
	RedTargetAirbase = SEF_CHOOSERANDOMFROMTABLE(FinalAirbaseSelectionList)	

	--trigger.action.outText("Picking Defended "..RedTargetAirbase,15)
	
	return RedTargetAirbase	
end

function SEF_REDGENERAL_CHOOSEDEPARTUREAIRBASE()
	
	SEF_REFRESHAIRBASETABLES()
	
	SEF_GETBLUECURRENTNEIGHBOURS()
	SEF_GETNONBLUEAIRBASES(CurrentBlueNeighbours)
	SEF_GETREDAIRBASES(CurrentNonBlueAirbases)	
	RedDepartureAirbase = SEF_CHOOSERANDOMFROMTABLE(CurrentRedAirbases)
	
	if RedDepartureAirbase ~= nil then	
		--trigger.action.outText(SyAAFAirforceGeneralName.." Is Choosing "..RedDepartureAirbase.." As The Origin", 15)
	else
		RedDepartureAirbase = "Palmyra"
		--trigger.action.outText(SyAAFAirforceGeneralName.." Is Choosing "..RedDepartureAirbase.." As The Origin", 15)
	end
	
	return RedDepartureAirbase
end

function SEF_BLUEGENERAL_CHOOSEDEPARTUREAIRBASE()
	
	SEF_REFRESHAIRBASETABLES()
	
	SEF_GETREDCURRENTNEIGHBOURS()
	SEF_GETNONREDAIRBASES(CurrentRedNeighbours)
	SEF_GETBLUEAIRBASES(CurrentNonRedAirbases)	
	BlueDepartureAirbase = SEF_CHOOSERANDOMFROMTABLE(CurrentBlueAirbases)
	
	if BlueDepartureAirbase ~= nil then	
		--trigger.action.outText(USAFAirforceGeneralName.." Is Choosing "..BlueDepartureAirbase.." As The Origin", 15)
	else
		BlueDepartureAirbase = "Incirlik"
		--trigger.action.outText(USAFAirforceGeneralName.." Is Choosing "..BlueDepartureAirbase.." As The Origin", 15)
	end
	
	return BlueDepartureAirbase
end

function SEF_REDGENERAL_ATTACKAIRBASE(TimeLoop, time)	
	
	if ( Group.getByName(SYAAFAN26BGROUPNAME) ) then		
		if ( GROUP:FindByName(SYAAFAN26BGROUPNAME):InAir() == false and GROUP:FindByName(SYAAFAN26BGROUPNAME):GetVelocityKMH() < 8 ) then
			--Transport plane must be inactive, remove it
			Group.getByName(SYAAFAN26BGROUPNAME):destroy()					
		elseif ( Group.getByName(VVSSU25TGROUPNAME) or Group.getByName(SYAAFSU24MGROUPNAME) or Group.getByName(VVSTU95MSGROUPNAME) or Group.getByName(VVSTU160GROUPNAME) or Group.getByName(VVSTU22M3GROUPNAME) ) then
			--Wait some more we still have planes in the air						
		else			
			--Wait some more the transport is still in the air									
		end		
	elseif ( Group.getByName(IRIAFMI8GROUPNAME) ) then
		if ( GROUP:FindByName(IRIAFMI8GROUPNAME):InAir() == false and GROUP:FindByName(IRIAFMI8GROUPNAME):GetVelocityKMH() < 8 ) then
			--Transport helo must be inactive, remove it
			Group.getByName(IRIAFMI8GROUPNAME):destroy()					
		elseif ( Group.getByName(VVSSU25TGROUPNAME) or Group.getByName(SYAAFSU24MGROUPNAME) or Group.getByName(VVSTU95MSGROUPNAME) or Group.getByName(VVSTU160GROUPNAME) or Group.getByName(VVSTU22M3GROUPNAME) ) then
			--Wait some more we still have planes in the air								
		else	
			--Wait some more the transport is still in the air							
		end						
	elseif ( Group.getByName(VVSSU25TGROUPNAME) or Group.getByName(SYAAFSU24MGROUPNAME) or Group.getByName(VVSTU95MSGROUPNAME) or Group.getByName(VVSTU160GROUPNAME) or Group.getByName(VVSTU22M3GROUPNAME) ) then
		--Wait some more we still have planes in the air				
	else	
		AttackUndefended 	= SEF_REDGENERAL_SELECTNEUTRALTARGETAIRBASE()
		AttackDefended 		= SEF_REDGENERAL_SELECTBLUETARGETAIRBASE()
		Origin 				= AIRBASE.Syria.Palmyra --SEF_REDGENERAL_CHOOSEDEPARTUREAIRBASE()	
		
		if ( AttackUndefended ~= nil and ( AttackDefended ~= nil or AttackDefended == nil) ) then	
			--Try to capitalise on an undefended (neutral) airbase as priority			
			if ( AttackUndefended ~= nil and Origin ~= nil ) then
				--trigger.action.outText(SyAAFAirforceGeneralName.." Is Selecting "..AttackUndefended.." As The Target Airbase And "..Origin.." As The Departure Airbase For A C-130 Mission", 60)
				trigger.action.outText("Intelligence Reports Indicate "..SyAAFAirforceGeneralName.." Is Mobilising Aircraft", 60)
				SEF_SYAAFAN26BSPAWN(Origin, AttackUndefended)				
			elseif ( AttackUndefended ~= nil and Origin == nil ) then
				--trigger.action.outText(SyAAFAirforceGeneralName..": No available options for an attack origin on C-130 misson, passing this round",60)				
			elseif ( AttackUndefended == nil and Origin ~= nil ) then
				--trigger.action.outText(SyAAFAirforceGeneralName..": No available options for an attack destination on C-130 misson, passing this round",60)				
			else
				--trigger.action.outText(SyAAFAirforceGeneralName..": No options for an attack destination or an attack origin on C-130 misson, passing this round",60)				
			end
		elseif ( AttackUndefended == nil and AttackDefended ~= nil ) then
			--There are no undefended (neutral) airbases to attack, so we need to send a helo instead as we can't land on a defended airfield. Also consider launching SEAD/CAS.
			if ( AttackDefended ~= nil and Origin ~= nil ) then
				trigger.action.outText("Intelligence Reports Indicate "..SyAAFAirforceGeneralName.." Is Mobilising Aircraft", 60)
				SEF_IRIAFMI8SPAWN(Origin, AttackDefended)
				SEF_REDSTRIKE(Origin, AttackDefended)				
			elseif ( AttackDefended ~= nil and Origin == nil ) then
				--trigger.action.outText(SyAAFAirforceGeneralName..": No available options for an attack origin on strike mission, passing this round",60)				
			elseif ( AttackDefended == nil and Origin ~= nil ) then
				--trigger.action.outText(SyAAFAirforceGeneralName..": No available options for an attack destination on strike mission, passing this round",60)				
			else
				--trigger.action.outText(SyAAFAirforceGeneralName..": No options for an attack destination or an attack origin on strike mission, passing this round",60)				
			end
		else
			--trigger.action.outText(SyAAFAirforceGeneralName..": No options for an C-130 mission, or strike mission, passing this round",60)			
		end				
	end	
	return time + math.random(RedStrikeFrequencyMin, RedStrikeFrequencyMax)	
end

function SEF_BLUEGENERAL_ATTACKAIRBASE(TimeLoop, time)
	
	--trigger.action.outText("Blue Attack Airbase Function Called", 15)
	
	if ( Group.getByName(USAFC130GROUPNAME) ) then 		
		if ( GROUP:FindByName(USAFC130GROUPNAME):InAir() == false and GROUP:FindByName(USAFC130GROUPNAME):GetVelocityKMH() < 8 ) then
			--Transport plane must be inactive, remove it
			Group.getByName(USAFC130GROUPNAME):destroy()							
		else
			--Do nothing the transport is still in the air
			--trigger.action.outText(USAFAirforceGeneralName.." Is Awaiting The Result Of The Current Mission",15)			
		end	
	elseif ( Group.getByName(USAFUH60AGROUPNAME) ) then
		if ( GROUP:FindByName(USAFUH60AGROUPNAME):InAir() == false and GROUP:FindByName(USAFUH60AGROUPNAME):GetVelocityKMH() < 8 ) then
			--Transport helo must be inactive, remove it
			Group.getByName(USAFUH60AGROUPNAME):destroy()			
		else
			--trigger.action.outText(USAFAirforceGeneralName.." Is Awaiting The Result Of The Current Mission",15)						
		end	
	else	
		AttackUndefended 	= SEF_BLUEGENERAL_SELECTNEUTRALTARGETAIRBASE()
		AttackDefended 		= SEF_BLUEGENERAL_SELECTREDTARGETAIRBASE()
		Origin 				= AIRBASE.Syria.Ramat_David --SEF_BLUEGENERAL_CHOOSEDEPARTUREAIRBASE()

		if ( AttackUndefended ~= nil and ( AttackDefended ~= nil or AttackDefended == nil) ) then	
			--Try to capitalise on an undefended (neutral) airbase as priority	
			if ( AttackUndefended ~= nil and Origin ~= nil ) then
				--trigger.action.outText(USAFAirforceGeneralName.." Is Commencing A Mission To Capture "..AttackUndefended.." From "..Origin, 60)
				SEF_USAFC130SPAWN(Origin, AttackUndefended)				
			elseif ( AttackUndefended ~= nil and Origin == nil ) then
				--trigger.action.outText(USAFAirforceGeneralName..": No available options for an attack origin on C-130 misson, passing this round",60)				
			elseif ( AttackUndefended == nil and Origin ~= nil ) then
				--trigger.action.outText(USAFAirforceGeneralName..": No available options for an attack destination on C-130 misson, passing this round",60)				
			else
				--trigger.action.outText(USAFAirforceGeneralName..": No options for an attack destination or an attack origin on C-130 misson, passing this round",60)				
			end
		elseif ( AttackUndefended == nil and AttackDefended ~= nil ) then
			if ( AttackDefended ~= nil and Origin ~= nil ) then
				--trigger.action.outText(USAFAirforceGeneralName.." Is Commencing A Mission To Capture "..AttackDefended.." From "..Origin, 60)
				SEF_USAFUH60ASPAWN(Origin, AttackDefended)				
				--SEF_USAFC130SPAWN(Origin, AttackDefended)
				--SEF_BLUESTRIKE(Origin, AttackDefended)
			elseif ( AttackDefended ~= nil and Origin == nil ) then
				--trigger.action.outText(USAFAirforceGeneralName..": No available options for an attack origin on a UH-60A mission, passing this round",60)				
			elseif ( AttackDefended == nil and Origin ~= nil ) then
				--trigger.action.outText(USAFAirforceGeneralName..": No available options for an attack destination on a UH-60A mission, passing this round",60)				
			else
				--trigger.action.outText(USAFAirforceGeneralName..": No options for an attack destination or an attack origin on a UH-60A mission, passing this round",60)				
			end
		else
			--trigger.action.outText(USAFAirforceGeneralName..": No options for a C-130 mission, or a UH-60A mission, passing this round",60)			
		end		
	end	
	return time + math.random(BlueStrikeFrequencyMin, BlueStrikeFrequencyMax)	
end

function SEF_FINALFILTER(AirbaseList, OffLimitsList)
	
	if ( AirbaseList[1] ~= nil and OffLimitsList[1] ~= nil ) then
		
		FinalAirbaseSelectionList = {}
		MatchFound = false

		for k, v in ipairs(AirbaseList) do			
			
			MatchFound = false
			
			for x, y in ipairs(OffLimitsList) do
				Name = OffLimitsList[x]
				
				if Name == v then
				   MatchFound = true
				end
			end
			
			if (MatchFound == false) then
				table.insert(FinalAirbaseSelectionList, v)
			end
		end    
	else
		FinalAirbaseSelectionList = AirbaseList
	end

	--Debug
	--for x, y in ipairs(FinalAirbaseSelectionList) do
	--	trigger.action.outText(FinalAirbaseSelectionList[x], 15)
	--end
end

-------------------------------------------------------------------------------------------------------------------------------------------------

function SEF_SYAAFAN26BSPAWN(DepartureAirbaseName, DestinationAirbaseName)
	
	SYAAFAN26B_DATA[1].Vec2 = nil
	SYAAFAN26B_DATA[1].TimeStamp = nil
	
	--////Workaround For Airfields Not Big Enough To Handle Transport Spawns
	if ( DepartureAirbaseName == "Taftanaz" ) then
			if ( Airbase.getByName("Aleppo"):getCoalition() == 1 ) then
				DepartureAirbaseName = "Aleppo"
			elseif ( Airbase.getByName("Abu al-Duhur"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "Abu al-Duhur"
			elseif ( Airbase.getByName("Kuweires"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "Kuweires"		
			elseif ( Airbase.getByName("Jirah"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "Jirah"		
			else
				DepartureAirbaseName = "Tabqa"
			end	
	elseif ( DepartureAirbaseName == "Qabr as Sitt" or DepartureAirbaseName == "Marj as Sultan North" or DepartureAirbaseName == "Marj as Sultan South" or DepartureAirbaseName == "Kiryat Shmona" or DepartureAirbaseName == "Haifa" or DepartureAirbaseName == "Rayak" ) then
			if ( Airbase.getByName("Damascus"):getCoalition() == 1 ) then
				DepartureAirbaseName = "Damascus"
			elseif ( Airbase.getByName("Mezzeh"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "Mezzeh"
			elseif ( Airbase.getByName("Al-Dumayr"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "Al-Dumayr"		
			elseif ( Airbase.getByName("An Nasiriyah"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "An Nasiriyah"		
			else
				DepartureAirbaseName = "Palmyra"
			end	
	else
	end
		
	local SpawnZone = AIRBASE:FindByName(DepartureAirbaseName):GetZone()
	local DestinationZone = AIRBASE:FindByName(DestinationAirbaseName):GetZone()
	
	SYAAFAN26B = SPAWN
		:New("SyAAF An-26B")
		:InitLimit( 1, 1 )		
		:OnSpawnGroup(
			function( SpawnGroup )						
				SYAAFAN26BGROUPNAME = SpawnGroup.GroupName
				SYAAFAN26BGROUP = GROUP:FindByName(SpawnGroup.GroupName)
				
				local DepartureZoneVec2 = SpawnZone:GetVec2()
				local DestinationZoneVec2 	= DestinationZone:GetVec2()
				
				local WP0X = DepartureZoneVec2.x
				local WP0Y = DepartureZoneVec2.y
				local WP1X = DepartureZoneVec2.x - 10000
				local WP1Y = DepartureZoneVec2.y
				local WP2X = DestinationZoneVec2.x + 10000
				local WP2Y = DestinationZoneVec2.y
								
				Mission = {
					["id"] = "Mission",
					["params"] = {				
						["route"] = 
							{								
								["points"] = 
								{
									[1] = 
									{
										["alt"] = 3657.6,
										["action"] = "Turning Point",
										["alt_type"] = "BARO",
										["speed"] = 175,
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
																["id"] = "Option",
																["params"] = 
																{
																	["value"] = 2,
																	["name"] = 1,
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
																	["value"] = true,
																	["name"] = 7,
																}, -- end of ["params"]
															}, -- end of ["action"]
														}, -- end of ["params"]
													}, -- end of [2]
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
										["alt"] = 3657.6,
										["action"] = "Turning Point",
										["alt_type"] = "BARO",
										["speed"] = 175,
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
										["ETA"] = 12.457428824233,
										["ETA_locked"] = false,
										["y"] = WP1Y,
										["x"] = WP1X,
										["formation_template"] = "",
										["speed_locked"] = true,
									}, -- end of [2]
									[3] = 
									{
										["alt"] = 3657.6,
										["action"] = "Turning Point",
										["alt_type"] = "BARO",
										["speed"] = 175,
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
																	["command"] = "SEF_SYAAFAN26BLANDCOMMAND()",
																}, -- end of ["params"]
															}, -- end of ["action"]
														}, -- end of ["params"]
													}, -- end of [1]
												}, -- end of ["tasks"]
											}, -- end of ["params"]
										}, -- end of ["task"]
										["type"] = "Turning Point",
										["ETA"] = 62.255386210095,
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
				SYAAFAN26BGROUP:SetTask(Mission)																							
			end
		)
	--:SpawnInZone( SpawnZone, true, 4000, 5000 )
	:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
	SYAAFAN26BDestinationAirbaseName = DestinationAirbaseName
end

function SEF_SYAAFAN26BLANDCOMMAND()	
	SYAAFAN26BGROUP:RouteRTB( AIRBASE:FindByName(SYAAFAN26BDestinationAirbaseName) )	
end

function SEF_USAFC130SPAWN(DepartureAirbaseName, DestinationAirbaseName)
	
	USAFC130_DATA[1].Vec2 = nil
	USAFC130_DATA[1].TimeStamp = nil
	
	if ( DepartureAirbaseName == "Taftanaz" ) then
			if ( Airbase.getByName("Hatay"):getCoalition() == 2 ) then
				DepartureAirbaseName = "Hatay"
			elseif ( Airbase.getByName("Aleppo"):getCoalition() == 2 ) then	
				DepartureAirbaseName = "Aleppo"
			elseif ( Airbase.getByName("Kuweires"):getCoalition() == 2 ) then	
				DepartureAirbaseName = "Kuweires"		
			elseif ( Airbase.getByName("Abu al-Duhur"):getCoalition() == 2 ) then	
				DepartureAirbaseName = "Abu al-Duhur"		
			else
				DepartureAirbaseName = "Incirlik"
			end	
	elseif ( DepartureAirbaseName == "Qabr as Sitt" or DepartureAirbaseName == "Marj as Sultan North" or DepartureAirbaseName == "Marj as Sultan South" or DepartureAirbaseName == "Kiryat Shmona" or DepartureAirbaseName == "Haifa" or DepartureAirbaseName == "Rayak" ) then
			if ( Airbase.getByName("Damascus"):getCoalition() == 2 ) then
				DepartureAirbaseName = "Damascus"
			elseif ( Airbase.getByName("Mezzeh"):getCoalition() == 2 ) then	
				DepartureAirbaseName = "Mezzeh"
			elseif ( Airbase.getByName("Al-Dumayr"):getCoalition() == 2 ) then	
				DepartureAirbaseName = "Al-Dumayr"		
			elseif ( Airbase.getByName("An Nasiriyah"):getCoalition() == 2 ) then	
				DepartureAirbaseName = "An Nasiriyah"		
			else
				DepartureAirbaseName = "Ramat David"
			end	
	else
	end	
	
	local SpawnZone = AIRBASE:FindByName(DepartureAirbaseName):GetZone()
	local DestinationZone = AIRBASE:FindByName(DestinationAirbaseName):GetZone()
	
	USAFC130 = SPAWN
		:New("USAF C-130")
		:InitLimit( 1, 1 )		
		:OnSpawnGroup(
			function( SpawnGroup )						
				USAFC130GROUPNAME = SpawnGroup.GroupName
				USAFC130GROUP = GROUP:FindByName(SpawnGroup.GroupName)
				
				local DepartureZoneVec2 = SpawnZone:GetVec2()
				local DestinationZoneVec2 	= DestinationZone:GetVec2()
				
				local WP0X = DepartureZoneVec2.x
				local WP0Y = DepartureZoneVec2.y
				local WP1X = DepartureZoneVec2.x + 10000
				local WP1Y = DepartureZoneVec2.y
				local WP2X = DestinationZoneVec2.x - 10000
				local WP2Y = DestinationZoneVec2.y
								
				Mission = {
					["id"] = "Mission",
					["params"] = {				
						["route"] = 
							{								
								["points"] = 
								{
									[1] = 
									{
										["alt"] = 3657.6,
										["action"] = "Turning Point",
										["alt_type"] = "BARO",
										["speed"] = 175,
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
																["id"] = "Option",
																["params"] = 
																{
																	["value"] = 2,
																	["name"] = 1,
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
																	["value"] = true,
																	["name"] = 7,
																}, -- end of ["params"]
															}, -- end of ["action"]
														}, -- end of ["params"]
													}, -- end of [2]
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
										["alt"] = 3657.6,
										["action"] = "Turning Point",
										["alt_type"] = "BARO",
										["speed"] = 175,
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
										["ETA"] = 12.457428824233,
										["ETA_locked"] = false,
										["y"] = WP1Y,
										["x"] = WP1X,
										["formation_template"] = "",
										["speed_locked"] = true,
									}, -- end of [2]
									[3] = 
									{
										["alt"] = 3657.6,
										["action"] = "Turning Point",
										["alt_type"] = "BARO",
										["speed"] = 175,
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
																	["command"] = "SEF_USAFC130LANDCOMMAND()",
																}, -- end of ["params"]
															}, -- end of ["action"]
														}, -- end of ["params"]
													}, -- end of [1]
												}, -- end of ["tasks"]
											}, -- end of ["params"]
										}, -- end of ["task"]
										["type"] = "Turning Point",
										["ETA"] = 62.255386210095,
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
				USAFC130GROUP:SetTask(Mission)																							
			end
		)		
	--:SpawnInZone( SpawnZone, true, 4000, 5000 )
	:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
	USAFC130DestinationAirbaseName = DestinationAirbaseName
end

function SEF_USAFC130LANDCOMMAND()	
	USAFC130GROUP:RouteRTB( AIRBASE:FindByName(USAFC130DestinationAirbaseName) )	
end

function SEF_VVSSU25T(DepartureAirbaseName, DestinationAirbaseName)
	
	VVSSU25T_DATA[1].Vec2 = nil
	VVSSU25T_DATA[1].TimeStamp = nil
	VVSSU25T_DATA[2].Vec2 = nil
	VVSSU25T_DATA[2].TimeStamp = nil
	
	--////Workaround For Airfields Not Big Enough To Handle The Spawns
	if ( DepartureAirbaseName == "Taftanaz" ) then
			if ( Airbase.getByName("Aleppo"):getCoalition() == 1 ) then
				DepartureAirbaseName = "Aleppo"
			elseif ( Airbase.getByName("Abu al-Duhur"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "Abu al-Duhur"
			elseif ( Airbase.getByName("Kuweires"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "Kuweires"		
			elseif ( Airbase.getByName("Jirah"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "Jirah"		
			else
				DepartureAirbaseName = "Tabqa"
			end	
	elseif ( DepartureAirbaseName == "Qabr as Sitt" or DepartureAirbaseName == "Marj as Sultan North" or DepartureAirbaseName == "Marj as Sultan South" or DepartureAirbaseName == "Kiryat Shmona" or DepartureAirbaseName == "Haifa" or DepartureAirbaseName == "Rayak" ) then
			if ( Airbase.getByName("Damascus"):getCoalition() == 1 ) then
				DepartureAirbaseName = "Damascus"
			elseif ( Airbase.getByName("Mezzeh"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "Mezzeh"
			elseif ( Airbase.getByName("Al-Dumayr"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "Al-Dumayr"		
			elseif ( Airbase.getByName("An Nasiriyah"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "An Nasiriyah"		
			else
				DepartureAirbaseName = "Palmyra"
			end	
	else
	end
	
	local SpawnZone = AIRBASE:FindByName(DepartureAirbaseName):GetZone()
	local DestinationZone = AIRBASE:FindByName(DestinationAirbaseName):GetZone()	
	
	VVSSU25T = SPAWN
		:New("VVS Su-25T")
		:InitLimit( 2, 2 )		
		:OnSpawnGroup(
			function( SpawnGroup )						
				VVSSU25TGROUPNAME = SpawnGroup.GroupName
				VVSSU25TGROUP = GROUP:FindByName(SpawnGroup.GroupName)							
				
				local DepartureZoneVec2 = SpawnZone:GetVec2()
				local TargetZoneVec2 	= DestinationZone:GetVec2()
				local WP0X = DepartureZoneVec2.x
				local WP0Y = DepartureZoneVec2.y
				local WP1X = DepartureZoneVec2.x + 18520
				local WP1Y = DepartureZoneVec2.y
				local WP2X = TargetZoneVec2.x
				local WP2Y = TargetZoneVec2.y
				local WP3X = DepartureZoneVec2.x
				local WP3Y = DepartureZoneVec2.y				
							
						--////SEAD Mission Profile, Engage Targets Along Route Within 75km
						Mission = {
							["id"] = "Mission",
							["params"] = {		
								["route"] = 
                                {
                                    ["points"] = 
                                    {
                                        [1] = 
                                        {
                                            ["alt"] = 3000,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 180.55555555556,
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
                                            ["alt"] = 4000,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 180.55555555556,
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
                                                                    ["id"] = "Option",
                                                                    ["params"] = 
                                                                    {
                                                                        ["value"] = 2, 			--Reaction To Threat
                                                                        ["name"] = 1,  			--Evade Fire	
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
                                                                ["maxDist"] = 75000,
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
                                                                        ["value"] = true,		--On
                                                                        ["name"] = 15,			--Restrict Jettison
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
																		["variantIndex"] = 1,
																		["name"] = 5,
																		["formationIndex"] = 6,
																		["value"] = 393217,
																	}, -- end of ["params"]
																}, -- end of ["action"]
															}, -- end of ["params"]
														}, -- end of [4]														
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 81.291205528134,
                                            ["ETA_locked"] = false,
                                            ["y"] = WP1Y,							
                                            ["x"] = WP1X,							
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [2]
                                        [3] = 
                                        {
                                            ["alt"] = 4000,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 180.55555555556,
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
                                            ["ETA"] = 335.83146364775,
                                            ["ETA_locked"] = false,
                                            ["y"] = WP2Y,							
                                            ["x"] = WP2X,							
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [3]
                                        [4] = 
                                        {
                                            ["alt"] = 4000,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 180.55555555556,
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
                                            ["ETA"] = 588.86805106716,
                                            ["ETA_locked"] = false,
                                            ["y"] = WP3Y,							
                                            ["x"] = WP3X,							
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [4]
                                    }, -- end of ["points"]
								},--end of route
							}, --end of ["params"]
						}--end of Mission				
				VVSSU25TGROUP:SetTask(Mission)				
			end
		)
	--:SpawnInZone( SpawnZone, true, 4000, 4000 )
	:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
end

function SEF_SYAAFSU24M(DepartureAirbaseName, DestinationAirbaseName)

	SYAAFSU24M_DATA[1].Vec2 = nil
	SYAAFSU24M_DATA[1].TimeStamp = nil
	SYAAFSU24M_DATA[2].Vec2 = nil
	SYAAFSU24M_DATA[2].TimeStamp = nil
	
	--////Workaround For Airfields Not Big Enough To Handle The Spawns
	if ( DepartureAirbaseName == "Taftanaz" ) then
			if ( Airbase.getByName("Aleppo"):getCoalition() == 1 ) then
				DepartureAirbaseName = "Aleppo"
			elseif ( Airbase.getByName("Abu al-Duhur"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "Abu al-Duhur"
			elseif ( Airbase.getByName("Kuweires"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "Kuweires"		
			elseif ( Airbase.getByName("Jirah"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "Jirah"		
			else
				DepartureAirbaseName = "Tabqa"
			end	
	elseif ( DepartureAirbaseName == "Qabr as Sitt" or DepartureAirbaseName == "Marj as Sultan North" or DepartureAirbaseName == "Marj as Sultan South" or DepartureAirbaseName == "Kiryat Shmona" or DepartureAirbaseName == "Haifa" or DepartureAirbaseName == "Rayak" ) then
			if ( Airbase.getByName("Damascus"):getCoalition() == 1 ) then
				DepartureAirbaseName = "Damascus"
			elseif ( Airbase.getByName("Mezzeh"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "Mezzeh"
			elseif ( Airbase.getByName("Al-Dumayr"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "Al-Dumayr"		
			elseif ( Airbase.getByName("An Nasiriyah"):getCoalition() == 1 ) then	
				DepartureAirbaseName = "An Nasiriyah"		
			else
				DepartureAirbaseName = "Palmyra"
			end	
	else
	end
	
	local SpawnZone = AIRBASE:FindByName(DepartureAirbaseName):GetZone()
	local DestinationZone = AIRBASE:FindByName(DestinationAirbaseName):GetZone()	
	
	SYAAFSU24M = SPAWN
		:New("SyAAF Su-24M")
		:InitLimit( 2, 2 )		
		:OnSpawnGroup(
			function( SpawnGroup )						
				SYAAFSU24MGROUPNAME = SpawnGroup.GroupName
				SYAAFSU24MGROUP = GROUP:FindByName(SpawnGroup.GroupName)				
				
				local DepartureZoneVec2 = SpawnZone:GetVec2()
				local TargetZoneVec2 	= DestinationZone:GetVec2()
				local WP0X = DepartureZoneVec2.x
				local WP0Y = DepartureZoneVec2.y
				local WP1X = DepartureZoneVec2.x + 18520
				local WP1Y = DepartureZoneVec2.y 
				local WP2X = TargetZoneVec2.x
				local WP2Y = TargetZoneVec2.y
				local WP3X = DepartureZoneVec2.x
				local WP3Y = DepartureZoneVec2.y
		
						--////CAS Mission Profile, Engage Targets Along Route Within 75km
						Mission = {
						["id"] = "Mission",
						["params"] = {
							["route"] = 
                                {
                                    ["points"] = 
                                    {
                                        [1] = 
                                        {
                                            ["alt"] = 3000,
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
                                            ["alt"] = 6000,
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
                                                                    ["id"] = "Option",
                                                                    ["params"] = 
                                                                    {
                                                                        ["value"] = 2,
                                                                        ["name"] = 1,
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
                                                                ["maxDist"] = 75000,
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
																		["variantIndex"] = 1,
																		["name"] = 5,
																		["formationIndex"] = 6,
																		["value"] = 393217,
																	}, -- end of ["params"]
																}, -- end of ["action"]
															}, -- end of ["params"]
														}, -- end of [4]
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 81.667335049769,
                                            ["ETA_locked"] = false,
                                            ["y"] = WP1Y,
                                            ["x"] = WP1X,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [2]
                                        [3] = 
                                        {
                                            ["alt"] = 3000, --2000
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
                                            ["ETA"] = 803.32695459455,
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
                                            ["ETA"] = 1531.4264319091,
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
	
			SYAAFSU24MGROUP:SetTask(Mission)
		end
		)
	--:SpawnInZone( SpawnZone, true, 6000, 6000 )
	:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
end

function SEF_VVSTU95MS(DepartureAirbaseName, DestinationAirbaseName)

	VVSTU95MS_DATA[1].Vec2 = nil
	VVSTU95MS_DATA[1].TimeStamp = nil
	
	local SpawnZone = AIRBASE:FindByName(DepartureAirbaseName):GetZone()
	local DestinationZone = AIRBASE:FindByName(DestinationAirbaseName):GetZone()
	local DestinationTargetZoneVec2 = ZONE:FindByName(DestinationAirbaseName.." LZ Blue"):GetVec2()	
	
	VVSTU95MS = SPAWN
		:New("VVS Tu-95MS")
		:InitLimit( 1, 1 )		
		:InitRandomizePosition( true , 1000, 900 )
		:OnSpawnGroup(
			function( SpawnGroup )						
				VVSTU95MSGROUPNAME = SpawnGroup.GroupName
				VVSTU95MSGROUP = GROUP:FindByName(SpawnGroup.GroupName)				
				
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
				local TargetPointX = DestinationTargetZoneVec2.x
				local TargetPointY = DestinationTargetZoneVec2.y
		
						--////Pinpoint Strike Mission Profile, Attack Map Object
						Mission = {
						["id"] = "Mission",
						["params"] = {
							["route"] = 
                                {
                                    ["points"] = 
                                    {
                                        [1] = 
                                        {
                                            ["alt"] = 9144,
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
                                                                    ["id"] = "Option",
                                                                    ["params"] = 
                                                                    {
                                                                        ["value"] = 1,
                                                                        ["name"] = 1,
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
                                                                        ["value"] = true,
                                                                        ["name"] = 15,
                                                                    }, -- end of ["params"]
                                                                }, -- end of ["action"]
                                                            }, -- end of ["params"]
                                                        }, -- end of [2]
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
                                            ["alt"] = 9144,
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
                                                            ["id"] = "Bombing",
                                                            ["number"] = 1,
                                                            ["params"] = 
                                                            {
                                                                ["direction"] = 0,
                                                                ["attackQtyLimit"] = true,
                                                                ["attackQty"] = 1,
                                                                ["expend"] = "Four",
                                                                ["y"] = TargetPointY,
                                                                ["directionEnabled"] = false,
                                                                ["groupAttack"] = false,
                                                                ["altitude"] = 9144,
                                                                ["altitudeEnabled"] = false,
                                                                ["weaponType"] = 2956984318, --4030478 not sure what this weapon profile is
                                                                ["x"] = TargetPointX,
                                                            }, -- end of ["params"]
                                                        }, -- end of [1]
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 16.693279964574,
                                            ["ETA_locked"] = false,
                                            ["y"] = WP1Y,
                                            ["x"] = WP1X,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [2]
                                        [3] = 
                                        {
                                            ["alt"] = 9144,
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
                                            ["ETA"] = 377.52879132558,
                                            ["ETA_locked"] = false,
                                            ["y"] = WP2Y,
                                            ["x"] = WP2X,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [3]
                                        [4] = 
                                        {
                                            ["alt"] = 9144,
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
                                            ["ETA"] = 710.78189235268,
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
	
			VVSTU95MSGROUP:SetTask(Mission)
		end
		)
	:SpawnInZone( SpawnZone, true, 9144, 9144 )
	--:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
end

function SEF_VVSTU160(DepartureAirbaseName, DestinationAirbaseName)

	VVSTU160_DATA[1].Vec2 = nil
	VVSTU160_DATA[1].TimeStamp = nil
	
	local SpawnZone = AIRBASE:FindByName(DepartureAirbaseName):GetZone()
	local DestinationZone = AIRBASE:FindByName(DestinationAirbaseName):GetZone()
	local DestinationTargetZoneVec2 = ZONE:FindByName(DestinationAirbaseName.." LZ Blue"):GetVec2()	
	
	VVSTU160 = SPAWN
		:New("VVS Tu-160")
		:InitLimit( 1, 1 )		
		:InitRandomizePosition( true , 1000, 900 )
		:OnSpawnGroup(
			function( SpawnGroup )						
				VVSTU160GROUPNAME = SpawnGroup.GroupName
				VVSTU160GROUP = GROUP:FindByName(SpawnGroup.GroupName)				
				
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
				local TargetPointX = DestinationTargetZoneVec2.x
				local TargetPointY = DestinationTargetZoneVec2.y
		
						--////Pinpoint Strike Mission Profile, Attack Map Object
						Mission = {
						["id"] = "Mission",
						["params"] = {
							["route"] = 
                                {
                                    ["points"] = 
                                    {
                                        [1] = 
                                        {
                                            ["alt"] = 9144,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 266.667,
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
                                                                    ["id"] = "Option",
                                                                    ["params"] = 
                                                                    {
                                                                        ["value"] = 1,
                                                                        ["name"] = 1,
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
                                                                        ["value"] = true,
                                                                        ["name"] = 15,
                                                                    }, -- end of ["params"]
                                                                }, -- end of ["action"]
                                                            }, -- end of ["params"]
                                                        }, -- end of [2]
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
                                            ["alt"] = 9144,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 266.667,
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
                                                            ["id"] = "Bombing",--"AttackMapObject",
                                                            ["number"] = 1,
                                                            ["params"] = 
                                                            {
                                                                ["direction"] = 0,
                                                                ["attackQtyLimit"] = true,
                                                                ["attackQty"] = 1,
                                                                ["expend"] = "Four",
                                                                ["y"] = TargetPointY,
                                                                ["directionEnabled"] = false,
                                                                ["groupAttack"] = false,
                                                                ["altitude"] = 9144,
                                                                ["altitudeEnabled"] = false,
                                                                ["weaponType"] = 2956984318, --4030478 not sure what this weapon profile is
                                                                ["x"] = TargetPointX,
                                                            }, -- end of ["params"]
                                                        }, -- end of [1]
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 16.693279964574,
                                            ["ETA_locked"] = false,
                                            ["y"] = WP1Y,
                                            ["x"] = WP1X,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [2]
                                        [3] = 
                                        {
                                            ["alt"] = 9144,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 266.667,
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
                                            ["ETA"] = 377.52879132558,
                                            ["ETA_locked"] = false,
                                            ["y"] = WP2Y,
                                            ["x"] = WP2X,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [3]
                                        [4] = 
                                        {
                                            ["alt"] = 9144,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 266.667,
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
                                            ["ETA"] = 710.78189235268,
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
	
			VVSTU160GROUP:SetTask(Mission)
		end
		)
	:SpawnInZone( SpawnZone, true, 9144, 9144 )
	--:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
end

function SEF_VVSTU22M3(DepartureAirbaseName, DestinationAirbaseName)

	VVSTU22M3_DATA[1].Vec2 = nil
	VVSTU22M3_DATA[1].TimeStamp = nil
	
	local SpawnZone = AIRBASE:FindByName(DepartureAirbaseName):GetZone()
	local DestinationZone = AIRBASE:FindByName(DestinationAirbaseName):GetZone()
	local DestinationTargetZoneVec2 = ZONE:FindByName(DestinationAirbaseName.." LZ Blue"):GetVec2()	
	
	VVSTU22M3 = SPAWN
		:New("VVS Tu-22M3")
		:InitLimit( 1, 1 )		
		:InitRandomizePosition( true , 1000, 900 )
		:OnSpawnGroup(
			function( SpawnGroup )						
				VVSTU22M3GROUPNAME = SpawnGroup.GroupName
				VVSTU22M3GROUP = GROUP:FindByName(SpawnGroup.GroupName)				
				
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
				local TargetPointX = DestinationTargetZoneVec2.x
				local TargetPointY = DestinationTargetZoneVec2.y
		
						--////Pinpoint Strike Mission Profile, Attack Map Object
						Mission = {
						["id"] = "Mission",
						["params"] = {
							["route"] = 
                                {
                                    ["points"] = 
                                    {
                                        [1] = 
                                        {
                                            ["alt"] = 9144,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 250,
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
                                                                    ["id"] = "Option",
                                                                    ["params"] = 
                                                                    {
                                                                        ["value"] = 1,
                                                                        ["name"] = 1,
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
                                                                        ["value"] = true,
                                                                        ["name"] = 15,
                                                                    }, -- end of ["params"]
                                                                }, -- end of ["action"]
                                                            }, -- end of ["params"]
                                                        }, -- end of [2]
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
                                            ["alt"] = 9144,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 250,
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
                                                            ["id"] = "Bombing",
                                                            ["number"] = 1,
                                                            ["params"] = 
                                                            {
                                                                ["direction"] = 0,
                                                                ["attackQtyLimit"] = true,
                                                                ["attackQty"] = 1,
                                                                ["expend"] = "All",
                                                                ["y"] = TargetPointY,
                                                                ["directionEnabled"] = false,
                                                                ["groupAttack"] = false,
                                                                ["altitude"] = 9144,
                                                                ["altitudeEnabled"] = false,
                                                                ["weaponType"] = 2956984318, --4030478 not sure what this weapon profile is
                                                                ["x"] = TargetPointX,
                                                            }, -- end of ["params"]
                                                        }, -- end of [1]
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 16.693279964574,
                                            ["ETA_locked"] = false,
                                            ["y"] = WP1Y,
                                            ["x"] = WP1X,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [2]
                                        [3] = 
                                        {
                                            ["alt"] = 9144,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 250,
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
                                            ["ETA"] = 377.52879132558,
                                            ["ETA_locked"] = false,
                                            ["y"] = WP2Y,
                                            ["x"] = WP2X,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [3]
                                        [4] = 
                                        {
                                            ["alt"] = 9144,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "BARO",
                                            ["speed"] = 250,
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
                                            ["ETA"] = 710.78189235268,
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
	
			VVSTU22M3GROUP:SetTask(Mission)
		end
		)
	:SpawnInZone( SpawnZone, true, 9144, 9144 )
	--:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
end

function SEF_IRIAFMI8SPAWN(DepartureAirbaseName, DestinationAirbaseName)

	IRIAFMI8_DATA[1].Vec2 = nil
	IRIAFMI8_DATA[1].TimeStamp = nil
	
	local SpawnZone = AIRBASE:FindByName(DepartureAirbaseName):GetZone()
	local DestinationZone = AIRBASE:FindByName(DestinationAirbaseName):GetZone()	
	local LZZoneVec2 = ZONE:FindByName(DestinationAirbaseName.." LZ Red"):GetVec2()
	
	IRIAFMI8 = SPAWN
		:New("IRIAF Mi-8MTV2")
		:InitLimit( 1, 1 )		
		:OnSpawnGroup(
			function( SpawnGroup )						
				IRIAFMI8GROUPNAME = SpawnGroup.GroupName
				IRIAFMI8GROUP = GROUP:FindByName(SpawnGroup.GroupName)				
				
				local DepartureZoneVec2 = SpawnZone:GetVec2()
				local TargetZoneVec2 	= DestinationZone:GetVec2()
				local WP0X = DepartureZoneVec2.x
				local WP0Y = DepartureZoneVec2.y
				local WP1X = DepartureZoneVec2.x + 100
				local WP1Y = DepartureZoneVec2.y 
				local WP2X = TargetZoneVec2.x
				local WP2Y = TargetZoneVec2.y
				local LZX = LZZoneVec2.x
				local LZY = LZZoneVec2.y			
						
						Mission = {
							["id"] = "Mission",
							["params"] = {	
								["route"] = 
                                {
                                    ["routeRelativeTOT"] = false,
                                    ["points"] = 
                                    {
                                        [1] = 
                                        {
                                            ["alt"] = 304.8, 
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "RADIO",				--BARO
                                            ["speed"] = 62.5,
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
                                            ["alt"] = 304.8,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "RADIO",
                                            ["speed"] = 62.5,
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
                                            ["ETA"] = 66.139437839571,
                                            ["ETA_locked"] = false,
                                            ["y"] = WP1Y,
                                            ["x"] = WP1X,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [2]
                                        [3] = 
                                        {
                                            ["alt"] = 304.8,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "RADIO",
                                            ["speed"] = 62.5,
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
                                                            ["id"] = "Land",
                                                            ["number"] = 1,
                                                            ["params"] = 
                                                            {
                                                                ["y"] = LZY,				
                                                                ["x"] = LZX,				
                                                                ["duration"] = 300,
                                                                ["durationFlag"] = false,
                                                            }, -- end of ["params"]
                                                        }, -- end of [1]
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 475.4943056063,
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
			IRIAFMI8GROUP:SetTask(Mission)
			end
		)
		:SpawnInZone( SpawnZone, true, 304.8, 304.8 )
		--:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
end

function SEF_USAFUH60ASPAWN(DepartureAirbaseName, DestinationAirbaseName)

	USAFUH60A_DATA[1].Vec2 = nil
	USAFUH60A_DATA[1].TimeStamp = nil
	
	local SpawnZone = AIRBASE:FindByName(DepartureAirbaseName):GetZone()
	local DestinationZone = AIRBASE:FindByName(DestinationAirbaseName):GetZone()
	local LZZoneVec2 = ZONE:FindByName(DestinationAirbaseName.." LZ Blue"):GetVec2()	
	
	USAFUH60A = SPAWN
		:New("USAF UH-60A")
		:InitLimit( 1, 1 )		
		:OnSpawnGroup(
			function( SpawnGroup )						
				USAFUH60AGROUPNAME = SpawnGroup.GroupName
				USAFUH60AGROUP = GROUP:FindByName(SpawnGroup.GroupName)				
				
				local DepartureZoneVec2 = SpawnZone:GetVec2()
				local TargetZoneVec2 	= DestinationZone:GetVec2()
				local WP0X = DepartureZoneVec2.x
				local WP0Y = DepartureZoneVec2.y
				local WP1X = DepartureZoneVec2.x + 100
				local WP1Y = DepartureZoneVec2.y 
				local WP2X = TargetZoneVec2.x
				local WP2Y = TargetZoneVec2.y
				local LZX = LZZoneVec2.x
				local LZY = LZZoneVec2.y			
						
						Mission = {
							["id"] = "Mission",
							["params"] = {	
								["route"] = 
                                {
                                    ["routeRelativeTOT"] = false,
                                    ["points"] = 
                                    {
                                        [1] = 
                                        {
                                            ["alt"] = 304.8, --250
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "RADIO",
                                            ["speed"] = 77.7778,
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
                                            ["alt"] = 304.8,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "RADIO",
                                            ["speed"] = 77.7778,
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
                                            ["ETA"] = 66.139437839571,
                                            ["ETA_locked"] = false,
                                            ["y"] = WP1Y,
                                            ["x"] = WP1X,
                                            ["formation_template"] = "",
                                            ["speed_locked"] = true,
                                        }, -- end of [2]
                                        [3] = 
                                        {
                                            ["alt"] = 304.8,
                                            ["action"] = "Turning Point",
                                            ["alt_type"] = "RADIO",
                                            ["speed"] = 77.7778,
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
                                                            ["id"] = "Land",
                                                            ["number"] = 1,
                                                            ["params"] = 
                                                            {
                                                                ["y"] = LZY,				
                                                                ["x"] = LZX,				
                                                                ["duration"] = 300,
                                                                ["durationFlag"] = false,
                                                            }, -- end of ["params"]
                                                        }, -- end of [1]
                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["type"] = "Turning Point",
                                            ["ETA"] = 475.4943056063,
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
			USAFUH60AGROUP:SetTask(Mission)
			end
		)
		:SpawnInZone( SpawnZone, false, 304.8, 304.8 )
		--:SpawnAtAirbase( AIRBASE:FindByName( DepartureAirbaseName ), SPAWN.Takeoff.Hot )
end

function SEF_REDSTRIKE(Origin, AttackDefended)

	if ( Group.getByName(VVSSU25TGROUPNAME) or Group.getByName(SYAAFSU24MGROUPNAME) or Group.getByName(VVSTU95MSGROUPNAME) or Group.getByName(VVSTU160GROUPNAME) or Group.getByName(VVSTU22M3GROUPNAME) ) then
		--trigger.action.outText(IranianAirforceGeneralName.." I Still Have SEAD, CAS or Pinpoint Strike Planes In The Air, I Can't Spare More Planes Yet",15)
	else		
		local ChooseAttackElements = math.random(1,100)
		local ChooseBomberElements = math.random(1,100)
		
		if ( ChooseAttackElements <= 50 ) then
			--SEAD + CAS - Bomber Element
			SEF_VVSSU25T( Origin, AttackDefended )
			SEF_SYAAFSU24M( Origin, AttackDefended )			
		elseif ( ChooseAttackElements > 50 and ChooseAttackElements <= 75 ) then
			--SEAD - CAS + Random Bomber Element With 10% Chance Of No Bomber Element
			SEF_VVSSU25T( Origin, AttackDefended )			
			if ( ChooseBomberElements <= 30 ) then			
				SEF_VVSTU95MS( "Palmyra", AttackDefended )				
			elseif ( ChooseBomberElements > 30 and ChooseBomberElements <= 60 ) then			
				SEF_VVSTU160( "Palmyra", AttackDefended )				
			elseif ( ChooseBomberElements > 60 and ChooseBomberElements <= 90 ) then			
				SEF_VVSTU22M3( "Palmyra", AttackDefended )				
			else						
			end			
		else
			--CAS - SEAD + Random Bomber Element With 10% Chance Of No Bomber Element
			SEF_SYAAFSU24M( Origin, AttackDefended )			
			if ( ChooseBomberElements <= 30 ) then			
				SEF_VVSTU95MS( "Palmyra", AttackDefended )				
			elseif ( ChooseBomberElements > 30 and ChooseBomberElements <= 60 ) then			
				SEF_VVSTU160( "Palmyra", AttackDefended )				
			elseif ( ChooseBomberElements > 60 and ChooseBomberElements <= 90 ) then			
				SEF_VVSTU22M3( "Palmyra", AttackDefended )				
			else							
			end			
		end				
	end	
end
	
function SEF_BLUESTRIKE(Origin, AttackDefended)
	
	if ( AutomatedBlueStrikes == 1 ) then
		if ( Group.getByName(USSTRIKEGROUPNAME) ) then
			--Still have strike planes in the air
		else
			
			--Spawn some shit to attack ahead of the transport			
			
		end		
		--trigger.action.outText("Blue: WIP: This function to spawn attacking planes at the target airbase zone to hopefully clear a path for a transport", 15)
	else
	end	
end

-------------------------------------------------------------------------------------------------------------------------------------------------

function SEF_GETREDFRONTLINEAIRBASES()	
	--//Refresh Tables Then Filter Through To Get The Front Line Airbases Owned By Red Coalition
	SEF_REFRESHAIRBASETABLES()	
	SEF_GETNONREDCURRENTNEIGHBOURS()
	SEF_GETNONBLUEAIRBASES(CurrentNonRedNeighbours)
	SEF_GETREDAIRBASES(CurrentNonBlueAirbases)
	SEF_LISTFRONTLINEREDAIRBASES()
end

-------------------------------------------------------------------------------------------------------------------------------------------------
	
function SEF_REDGENERAL_SCHEDULESTRIKE()	
	timer.scheduleFunction(SEF_REDGENERAL_ATTACKAIRBASE, 53, timer.getTime() + math.random(RedStrikeFrequencyMin, RedStrikeFrequencyMax))	
end

function SEF_BLUEGENERAL_SCHEDULESTRIKE()	
	timer.scheduleFunction(SEF_BLUEGENERAL_ATTACKAIRBASE, 53, timer.getTime() + math.random(BlueStrikeFrequencyMin, BlueStrikeFrequencyMax))	
end

function SEF_FRIENDLYDOWN()
	if ( CustomSoundsEnabled == 1) then
		trigger.action.outSound('Oh Jesus.ogg')
	else
	end	
end

function SEF_REDCAPTURETEAMSPAWN(SpawnVec2)
	REDCAPTURETEAM:SpawnFromVec2(SpawnVec2)
end

function SEF_BLUECAPTURETEAMSPAWN(SpawnVec2)
	BLUECAPTURETEAM:SpawnFromVec2(SpawnVec2)
end

function SEF_CAPAIRBASEWITHHELO(HeloName, Coalition)
	
	local HeloUnit = UNIT:FindByName(HeloName)
	local SpawnVec2 = UNIT:FindByName(HeloName):GetVec2()

	ClosestAirbaseBlue		= nil
	ClosestAirbaseNeutral	= nil
	ClosestAirbaseRed		= nil
	
	if ( Coalition == 1 ) then		
				
		if ( HeloUnit:GetCoordinate():GetClosestAirbase(Airbase.Category.AIRDROME, 2) ~= nil ) then
			ClosestAirbaseBlue = HeloUnit:GetCoordinate():GetClosestAirbase(Airbase.Category.AIRDROME, 2):GetName()				
		else
			ClosestAirbaseBlue = nil			
		end
		if ( HeloUnit:GetCoordinate():GetClosestAirbase(Airbase.Category.AIRDROME, 0) ~= nil ) then
			ClosestAirbaseNeutral = HeloUnit:GetCoordinate():GetClosestAirbase(Airbase.Category.AIRDROME, 0):GetName()			
		else
			ClosestAirbaseNeutral = nil			
		end
		
		if ( ClosestAirbaseBlue ~= nil and ClosestAirbaseNeutral ~= nil ) then		
		
			--trigger.action.outText("Closest Blue Airbase Is "..ClosestAirbaseBlue.."\nClosest Neutral Airbase Is "..ClosestAirbaseNeutral,15)
			
			if ( HeloUnit:IsInZone(ZONE:FindByName(ClosestAirbaseBlue.." LZ Red")) or HeloUnit:IsInZone(ZONE:FindByName(ClosestAirbaseNeutral.." LZ Red")) ) then
				Unit.getByName(HeloName):destroy()
				timer.scheduleFunction(SEF_REDCAPTURETEAMSPAWN, SpawnVec2, timer.getTime() + 2 )
			else
				Unit.getByName(HeloName):destroy()
			end	
		elseif ( ClosestAirbaseBlue ~= nil and ClosestAirbaseNeutral == nil ) then
			
			--trigger.action.outText("Closest Blue Airbase Is "..ClosestAirbaseBlue,15)
			
			if ( HeloUnit:IsInZone(ZONE:FindByName(ClosestAirbaseBlue.." LZ Red"))) then
				Unit.getByName(HeloName):destroy()
				timer.scheduleFunction(SEF_REDCAPTURETEAMSPAWN, SpawnVec2, timer.getTime() + 2 )
			else
				Unit.getByName(HeloName):destroy()
			end	
		elseif ( ClosestAirbaseBlue == nil and ClosestAirbaseNeutral ~= nil ) then
	
			--trigger.action.outText("Closest Neutral Airbase Is "..ClosestAirbaseNeutral,15)
			
			if ( HeloUnit:IsInZone(ZONE:FindByName(ClosestAirbaseNeutral.." LZ Red"))) then
				Unit.getByName(HeloName):destroy()
				timer.scheduleFunction(SEF_REDCAPTURETEAMSPAWN, SpawnVec2, timer.getTime() + 2 )
			else
				Unit.getByName(HeloName):destroy()
			end	
		else
		end	
	elseif ( Coalition == 2 ) then				
		
		if ( HeloUnit:GetCoordinate():GetClosestAirbase(Airbase.Category.AIRDROME, 1) ~= nil ) then
			ClosestAirbaseRed = HeloUnit:GetCoordinate():GetClosestAirbase(Airbase.Category.AIRDROME, 1):GetName()				
		else
			ClosestAirbaseRed = nil			
		end
		if ( HeloUnit:GetCoordinate():GetClosestAirbase(Airbase.Category.AIRDROME, 0) ~= nil ) then
			ClosestAirbaseNeutral = HeloUnit:GetCoordinate():GetClosestAirbase(Airbase.Category.AIRDROME, 0):GetName()			
		else
			ClosestAirbaseNeutral = nil			
		end
				
		if ( ClosestAirbaseRed ~= nil and ClosestAirbaseNeutral ~= nil ) then		
			
			--trigger.action.outText("Closest Red Airbase Is "..ClosestAirbaseRed.."\nClosest Neutral Airbase Is "..ClosestAirbaseNeutral,15)
			
			if (HeloUnit:IsInZone(ZONE:FindByName(ClosestAirbaseRed.." LZ Blue")) or HeloUnit:IsInZone(ZONE:FindByName(ClosestAirbaseNeutral.." LZ Blue"))) then
				Unit.getByName(HeloName):destroy()
				timer.scheduleFunction(SEF_BLUECAPTURETEAMSPAWN, SpawnVec2, timer.getTime() + 2 )
			else
				Unit.getByName(HeloName):destroy()
			end		
		elseif ( ClosestAirbaseRed ~= nil and ClosestAirbaseNeutral == nil ) then
			
			--trigger.action.outText("Closest Red Airbase Is "..ClosestAirbaseRed,15)
			
			if (HeloUnit:IsInZone(ZONE:FindByName(ClosestAirbaseRed.." LZ Blue"))) then
				Unit.getByName(HeloName):destroy()
				timer.scheduleFunction(SEF_BLUECAPTURETEAMSPAWN, SpawnVec2, timer.getTime() + 2 )
			else
				Unit.getByName(HeloName):destroy()
			end		
		elseif ( ClosestAirbaseRed == nil and ClosestAirbaseNeutral ~= nil ) then
			
			--trigger.action.outText("Closest Neutral Airbase Is "..ClosestAirbaseNeutral,15)
			
			if (HeloUnit:IsInZone(ZONE:FindByName(ClosestAirbaseNeutral.." LZ Blue"))) then
				Unit.getByName(HeloName):destroy()
				timer.scheduleFunction(SEF_BLUECAPTURETEAMSPAWN, SpawnVec2, timer.getTime() + 2 )
			else
				Unit.getByName(HeloName):destroy()
			end		
		else			
		end		
	else
	end		
end

-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
--////MAIN
env.info("Surrexen's Event Handlers Loading", false)

--////TEST CASE

--SEF_CAPAIRBASE("Aleppo", 2)

--////END TEST CASE

timer.scheduleFunction(SEF_REDGENERAL_ATTACKAIRBASE, 53, timer.getTime() + math.random(1800, 5400) )--+ math.random(1800, 5400)
timer.scheduleFunction(SEF_BLUEGENERAL_ATTACKAIRBASE, 53, timer.getTime() + math.random(20, 30) )--+ math.random(900, 1200)

--////END MAIN
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
--////EVENT HANDLERS

SEF_LANDINGHANDLER = {}
function SEF_LANDINGHANDLER:onEvent(Event)

	if Event.id == world.event.S_EVENT_LAND then				
		if Event.initiator then			
			local LandedUnit 			= Event.initiator						--The unit object that landed
			local LandedUnitName 		= Event.initiator:getName() 			--The unit name
			local LandedUnitCoalition 	= Event.initiator:getCoalition()		--The unit's coalition
			local LandedUnitGroupName 	= Event.initiator:getGroup():getName()	--The unit's group name
			local LandedUnitTypeName  	= Event.initiator:getTypeName()			--The unit's type name						
			
			if Event.place then
				LandedPlace 			= Event.place:getName()					--The airbase name of the landing
			else
				LandedPlace				= nil
			end
						
			if (LandedUnitCoalition == 1) then																					--Red Air Landed				
				if string.find(LandedUnitGroupName, "SyAAF An%-26B") then
					if ( LandedPlace ~= nil ) then											
						--trigger.action.outText("A Syrian "..LandedUnitTypeName.." Landed At "..LandedPlace, 15)
						SEF_CAPAIRBASE(LandedPlace, LandedUnitCoalition)
					else
						--trigger.action.outText("A Syrian "..LandedUnitTypeName.." Has Landed", 15)
					end										
				elseif string.find(LandedUnitGroupName, "IRIAF Mi%-8MTV2") then
					if ( LandedPlace ~= nil ) then
						--trigger.action.outText("A Syrian "..LandedUnitTypeName.." Has Landed At "..LandedPlace,15) 
						SEF_CAPAIRBASEWITHHELO(LandedUnitName, LandedUnitCoalition)
					else
						--trigger.action.outText("A Syrian "..LandedUnitTypeName.." Has Landed", 15)
						SEF_CAPAIRBASEWITHHELO(LandedUnitName, LandedUnitCoalition)
					end					
				else
					if ( LandedPlace ~= nil ) then											
						--trigger.action.outText("An "..LandedUnitTypeName.." Has Landed At "..LandedPlace,15)					
					end
				end
			elseif (LandedUnitCoalition == 2) then																				--Blue Air Landed					
				if string.find(LandedUnitGroupName, "USAF C%-130") then
					if ( LandedPlace ~= nil ) then					
						--trigger.action.outText("An American "..LandedUnitTypeName.." Landed At "..LandedPlace, 15)
						SEF_CAPAIRBASE(LandedPlace, LandedUnitCoalition)
					else
						--trigger.action.outText("An American "..LandedUnitTypeName.." Has Landed", 15)
					end										
				elseif string.find(LandedUnitGroupName, "USAF UH%-60A") then
					if ( LandedPlace ~= nil ) then
						--trigger.action.outText("An American "..LandedUnitTypeName.." Has Landed At "..LandedPlace,15)											
						SEF_CAPAIRBASEWITHHELO(LandedUnitName, LandedUnitCoalition)
					else
						--trigger.action.outText("An American "..LandedUnitTypeName.." Has Landed", 15)
						SEF_CAPAIRBASEWITHHELO(LandedUnitName, LandedUnitCoalition)
					end				
				else
					if ( LandedPlace ~= nil ) then
						--trigger.action.outText("An "..LandedUnitTypeName.." Has Landed At "..LandedPlace,15)
					else
					end	
				end			
			else																												--Neutral Air Landed
				if ( LandedPlace ~= nil ) then
					--trigger.action.outText("An "..LandedUnitTypeName.." Has Landed At "..LandedPlace,15)
				else
					--trigger.action.outText("An "..LandedUnitTypeName.." Has Landed", 15)
				end	
			end	
		end	
	end	
end
world.addEventHandler(SEF_LANDINGHANDLER)

SEF_CRASHEDHANDLER = {}
function SEF_CRASHEDHANDLER:onEvent(Event)	
	
	if Event.id == world.event.S_EVENT_CRASH then
		if Event.initiator then	
			local CrashedUnit 				= Event.initiator
			local CrashedUnitName 			= Event.initiator:getName()
			local CrashedUnitCoalition 		= Event.initiator:getCoalition()
			local CrashedUnitGroupName 		= Event.initiator:getGroup():getName()
			local CrashedUnitTypeName		= Event.initiator:getTypeName()	
			
			if ( CrashedUnitCoalition == 1 and CrashedUnitTypeName == 'MiG-21Bis' ) then			-- Enemy MiG-21Bis Down
				--trigger.action.outText("A " .. CrashedUnitTypeName .. " Has Been Destroyed!",15)
				
				if CustomSoundsEnabled == 1 then
					local RandomMigSound = math.random(1,2)
					if (RandomMigSound == 1) then 
						trigger.action.outSound('mig21splash-1.ogg')
					else
						trigger.action.outSound('mig21splash-2.ogg')
					end
				end	
				
			elseif ( CrashedUnitCoalition == 1 and CrashedUnitTypeName ~= 'MiG-21Bis' ) then		-- Enemy Non-MiG Down
				--trigger.action.outText("A " .. CrashedUnitTypeName .. " Has Been Destroyed!",15)
				
				if CustomSoundsEnabled == 1 then
					local RandomAAKillSound = math.random(1,6)
					trigger.action.outSound('AA Kill ' .. RandomAAKillSound .. '.ogg')
				end

				if string.find(CrashedUnitGroupName, "SyAAF An%-26B") then
					--trigger.action.outText("A Syrian Antonov An-26B Has Crashed!", 15)					
				elseif string.find(CrashedUnitGroupName, "IRIAF Mi%-8MTV2") then
					--trigger.action.outText("A Syrian Mi-8MTV2 Has Crashed!", 15)					
				else
				end
			elseif ( CrashedUnitCoalition == 2 ) then 												-- Allied Plane Down
				--trigger.action.outText("A " .. CrashedUnitTypeName .. " Has Been Destroyed!",15)
				
				if CustomSoundsEnabled == 1 then
					timer.scheduleFunction(SEF_FRIENDLYDOWN, {}, timer.getTime() + 1)		
				end
				
				if string.find(CrashedUnitGroupName, "USAF C%-130") then
					--trigger.action.outText("Our Hercules Has Crashed!", 15)					
				elseif string.find(CrashedUnitGroupName, "USAF UH%-60A") then
					--trigger.action.outText("Our Blackhawk Has Crashed!", 15)					
				else
				end		
			else
				--trigger.action.outText("A " .. CrashedUnitTypeName .. " Has Been Destroyed!",15)
			end
		end
	end	
end
world.addEventHandler(SEF_CRASHEDHANDLER)

SEF_KILLEDHANDLER = {}
function SEF_KILLEDHANDLER:onEvent(Event)

	if Event.id == world.event.S_EVENT_KILL then
		if Event.initiator then	
			local KillerUnit 				= Event.initiator
			local KillerUnitName 			= Event.initiator:getName()
			--local KillerUnitCoalition 		= Event.initiator:getCoalition()
			--local KillerUnitGroupName 		= Event.initiator:getGroup():getName()
			local KillerUnitTypeName		= Event.initiator:getTypeName()	
			local KillerUnitCategory 		= Event.initiator:getDesc().category			-- 0 AIRPLANE / 1 HELICOPTER / 2 GROUND_UNIT / 3 SHIP / 4 STRUCTURE
			
			local TargetUnit				= Event.target
			local TargetUnitName			= Event.target:getName()
			--local TargetUnitCoalition		= Event.target:getCoalition()
			--local TargetUnitGroupName		= Event.target:getGroup():getName()
			local TargetUnitTypeName		= Event.target:getTypeName()
			local TargetUnitCategory 		= Event.initiator:getDesc().category			-- 0 AIRPLANE / 1 HELICOPTER / 2 GROUND_UNIT / 3 SHIP / 4 STRUCTURE
			
			local WeaponName				= Event.weapon_name
			
			if ( KillerUnitCategory == 0 or KillerUnitCategory == 1 ) then
				if ( TargetUnitCategory == 0 or TargetUnitCategory == 1 ) then
					--trigger.action.outText("A "..KillerUnitTypeName.." Has Killed An "..TargetUnitTypeName, 15)
				else
					--trigger.action.outText("A "..KillerUnitTypeName.." Has Killed An "..TargetUnitName, 15)
				end			
			elseif ( KillerUnitCategory == 2 or KillerUnitCategory == 3 ) then
				if ( TargetUnitCategory == 0 or TargetUnitCategory == 1 ) then
					--trigger.action.outText(KillerUnitName.." Has Killed An "..TargetUnitTypeName, 15)
				else
					--trigger.action.outText(KillerUnitName.." Has Killed An "..TargetUnitTypeName, 15)
				end				
			else
			end			
		end
	end	
end
world.addEventHandler(SEF_KILLEDHANDLER)

SEF_BASECAPTUREDEVENTHANDLER = {}
function SEF_BASECAPTUREDEVENTHANDLER:onEvent(Event)
	
	if Event.id == world.event.S_EVENT_BASE_CAPTURED then
		if Event.initiator then	
			local CapturedBaseName 						= Event.place:getName()	
			local CapturedBaseCapturingUnit 			= Event.initiator
			local CapturedBaseCapturingUnitName 		= Event.initiator:getName()
			local CapturedBaseCapturingUnitCoalition 	= Event.initiator:getCoalition()
			local CapturedBaseCapturingUnitTypeName 	= Event.initiator:getTypeName()	
			
			--////Announcement
			--[[
			if ( CapturedBaseCapturingUnitCoalition == 1 and timer.getAbsTime() >= CaptureMessageLockout + 300 ) then
				trigger.action.outText(CapturedBaseName.." Has Been Captured By The Syrians", 15)
				CaptureMessageLockout = timer.getAbsTime()				
			elseif ( CapturedBaseCapturingUnitCoalition == 2 and timer.getAbsTime() >= CaptureMessageLockout + 300 ) then
				trigger.action.outText(CapturedBaseName.." Has Been Captured By The Allies", 15)
				CaptureMessageLockout = timer.getAbsTime()								
			else		
			end
			]]--
			if ( string.find(CapturedBaseCapturingUnitName, "Navy SEALS") or 
				 string.find(CapturedBaseCapturingUnitName, "DELTA Force") or 
				 string.find(CapturedBaseCapturingUnitName, "USACE 1st") or 
				 string.find(CapturedBaseCapturingUnitName, "USACE 2nd") or 
				 string.find(CapturedBaseCapturingUnitName, "Ã–zel Kuvvetler KomutanlÄ±ÄŸÄ±") or 
				 string.find(CapturedBaseCapturingUnitName, "Shayetet 13") ) then				 
				SEF_CAPAIRBASE(CapturedBaseName, 2)				
			end
			
			--[[
			--////Deal With Particular Airfields Late Activation
			if ( CapturedBaseCapturingUnitCoalition == 1 ) then
				if ( CapturedBaseName == "Whatever" ) then
					--trigger.action.activateGroup(Group.getByName("Whatever"))
				elseif ( CapturedBaseName == "Whatever" ) then
					--trigger.action.activateGroup(Group.getByName("Whatever"))					
				else
				end
			elseif ( CapturedBaseCapturingUnitCoalition == 2 ) then
				if ( CapturedBaseName == "Whatever" ) then					
					--trigger.action.activateGroup(Group.getByName("Whatever"))	
				elseif ( CapturedBaseName == "Whatever" ) then					
					--trigger.action.activateGroup(Group.getByName("Whatever"))					
				else
				end
			else
			end
			]]--
		end		
	end		
end
world.addEventHandler(SEF_BASECAPTUREDEVENTHANDLER)

SEF_SHOTHANDLER = {}
function SEF_SHOTHANDLER:onEvent(Event)
	if Event.id == world.event.S_EVENT_SHOT then
		if Event.initiator then
			local ShootingUnit						= Event.initiator
			local ShootingUnitName					= Event.initiator:getName()
			local ShootingUnitCoalition				= Event.initiator:getCoalition()
			
			local ShotWeapon 						= Event.weapon:getDesc()
			local ShotWeaponCategory 				= ShotWeapon.category	
			local ShotWeaponMissileCategory 		= ShotWeapon.missileCategory
			local ShotWeaponMissileGuidanceType 	= ShotWeapon.guidance
			local ShotWeaponName 					= Event.weapon:getTypeName()			
						
			if ( CustomSoundsEnabled == 1 ) then --Play sound if CustomSoundsEnabled is enabled and not SoundLocked. Set SoundLockout time once a sound starts playing.
				--////Check if Blue Coalition Is The One That Is Firing
				if ( ShootingUnitCoalition == 2 ) then
					--MISSILES		
					if ( ShotWeaponCategory == 1 ) then --Missile, any type		
						if ( ShotWeaponMissileCategory == 1 ) then -- 1 is A2A Missile "Fox"
								if ( ShotWeaponMissileGuidanceType == 4 ) then -- 4 is Fox 1, 2 is Fox 2, 3 is Fox 3
									
									--trigger.action.outText("Fox 1!", 15)				
															
									if ( timer.getAbsTime() >= SoundLockout + 7 ) then
										local RandomFox1Sound = math.random(1,2)
										trigger.action.outSound('Fox1 ' .. RandomFox1Sound .. '.ogg')
										SoundLockout = timer.getAbsTime()
									else
									end	
								
								elseif ( ShotWeaponMissileGuidanceType == 2 ) then
									
									--trigger.action.outText("Fox 2!", 15)
									
									if ( timer.getAbsTime() >= SoundLockout + 7 ) then	
										local RandomFox2Sound = math.random(1,3)
										trigger.action.outSound('Fox2 ' .. RandomFox2Sound .. '.ogg')
										SoundLockout = timer.getAbsTime()
									else
									end		
									
								elseif ( ShotWeaponMissileGuidanceType == 3 ) then
									
									--trigger.action.outText("Fox 3!", 15)
									
									if ( timer.getAbsTime() >= SoundLockout + 7 ) then
										local RandomFox3Sound = math.random(1,5)
										trigger.action.outSound('FoxGeneric ' .. RandomFox3Sound .. '.ogg')
										SoundLockout = timer.getAbsTime()
									else
									end							
								else
								end
						elseif ( ShotWeaponMissileCategory == 4 ) then --4 for Anti-Ship Missile "Bruiser"
							
							--trigger.action.outText("Bruiser!", 15)
							
							--////Can't find any Bruiser sounds yet
							--if ( timer.getAbsTime() >= SoundLockout + 7 ) then
								--local RandomBruiserSound = math.random(1,1)
								--trigger.action.outSound('Bruiser ' .. RandomBruiserSound .. '.ogg')
								--SoundLockout = timer.getAbsTime()
							--else
							--end
							
						elseif ( ShotWeaponMissileCategory == 6 ) then --6 for Other Missile "Rifle" (Maverick, HARM, Harpoon) -- Need to work out how to distinguish between anti-rad 'magnum' and anti-ship 'bruiser'
							
							--trigger.action.outText("Weapon: "..ShotWeaponName, 15)
							
							--Now test for the missile name
							--////ANTI RADIATION
							if ( 	ShotWeaponName == "weapons.missiles.AGM_88" or 
									ShotWeaponName == "weapons.missiles.AGM_122" or 
									ShotWeaponName == "weapons.missiles.X_58" or 
									ShotWeaponName == "weapons.missiles.X_25MP" or 
									ShotWeaponName == "LD-10" 
									) then
								
								--trigger.action.outText("Magnum!", 15)
								
								if ( timer.getAbsTime() >= SoundLockout + 7 ) then
									local RandomMagnumSound = math.random(1,1)
									trigger.action.outSound('Magnum ' .. RandomMagnumSound .. '.ogg')
									SoundLockout = timer.getAbsTime()
								else
								end		
								
							--////ASM's
							elseif ( ShotWeaponName == "weapons.missiles.AGM_65D" or 
									 ShotWeaponName == "weapons.missiles.AGM_65E" or 
									 ShotWeaponName == "weapons.missiles.AGM_65F" or 
									 ShotWeaponName == "weapons.missiles.AGM_65G" or 
									 ShotWeaponName == "weapons.missiles.AGM_65H" or 
									 ShotWeaponName == "weapons.missiles.AGM_65K" or 
									 ShotWeaponName == "weapons.missiles.X_29T" or 
									 ShotWeaponName == "weapons.missiles.X_29L" or 
									 ShotWeaponName == "weapons.missiles.X_25ML" or 
									 ShotWeaponName == "weapons.missiles.S-25L" or 
									 ShotWeaponName == "weapons.missiles.Vikhr_M" or 
									 ShotWeaponName == "weapons.missiles.RB75" or 
									 ShotWeaponName == "weapons.missiles.CM-802AKG" or 
									 ShotWeaponName == "weapons.missiles.C-701T" or 
									 ShotWeaponName == "weapons.missiles.C-701IR" 
									 ) then
								
								--trigger.action.outText("Rifle!", 15)
								
								if ( timer.getAbsTime() >= SoundLockout + 7 ) then
									local RandomRifleSound = math.random(1,1)
									trigger.action.outSound('Rifle ' .. RandomRifleSound .. '.ogg')
									SoundLockout = timer.getAbsTime()
								else
								end		
								
							--////ANTI-SHIP
							elseif (ShotWeaponName == "weapons.missiles.AGM_84D" or 
									ShotWeaponName == "weapons.missiles.C-802AK" or 
									ShotWeaponName == "weapons.missiles.ROBOT" 
									) then
								
								--trigger.action.outText("Bruiser!", 15)
								
								--////Can't find any Bruiser sounds yet
								--if ( timer.getAbsTime() >= SoundLockout + 7 ) then
									--local RandomBruiserSound = math.random(1,1)
									--trigger.action.outSound('Bruiser ' .. RandomBruiserSound .. '.ogg')
									--SoundLockout = timer.getAbsTime()
								--else
								--end						
							else
							end								
						else
						end
					--////ROCKETS	
					elseif ( ShotWeaponCategory == 2 ) then --Rockets, any type
						--Brevity Call Nails ... I think
						--Probably best not to do rockets as so many get fired
						--trigger.action.outText("Nails!", 15)
						
					--////BOMBS	
					elseif ( ShotWeaponCategory == 3 ) then --Bomb, any type
						
						--trigger.action.outText("Pickle!", 15)
						
						if ( timer.getAbsTime() >= SoundLockout + 7 ) then
							local RandomPickleSound = math.random(1,5)
							trigger.action.outSound('Pickle ' .. RandomPickleSound .. '.ogg')		
							SoundLockout = timer.getAbsTime()
						else
						end		
						
					--////SHELLS
					elseif ( ShotWeaponCategory == 0 ) then --Shell, any type
						--No Brevity Call
						--trigger.action.outText("Shell!", 15)	
					else
					end	
				elseif ( ShootingUnitCoalition == 1 ) then
					if ( ShotWeaponMissileCategory == 2 ) then
						
						--trigger.action.outText("SAM Launch!", 15)
						
						if ( timer.getAbsTime() >= SoundLockout + 7 ) then
							local RandomSAMSound = math.random(1,6)
							trigger.action.outSound('SAM ' .. RandomSAMSound .. '.ogg')			
							SoundLockout = timer.getAbsTime()
						else
						end				
					else
					end	
				else
				end
			else
			end
		end	
	end		
end
world.addEventHandler(SEF_SHOTHANDLER)

SEF_ONDEADEVENTHANDLER = {}
function SEF_ONDEADEVENTHANDLER:onEvent(Event)
	
	if Event.id == world.event.S_EVENT_DEAD then
		if Event.initiator then
			if ( Event.initiator:getCategory() == 1 or Event.initiator:getCategory() == 3 ) then 	-- UNIT or STATIC
			
				local DeadUnit 				 = Event.initiator
				local DeadUnitObjectCategory = Event.initiator:getCategory()						-- 1 UNIT / 2 WEAPON / 3 STATIC / 4 BASE / 5 SCENERY / 6 CARGO
				local DeadUnitCategory 		 = Event.initiator:getDesc().category					-- 0 AIRPLANE / 1 HELICOPTER / 2 GROUND_UNIT / 3 SHIP / 4 STRUCTURE
				local DeadUnitCoalition 	 = Event.initiator:getCoalition()
				local DeadUnitName			 = Event.initiator:getName()
				
				if ( DeadUnitCoalition == 1 ) then													-- RED ONLY AT THIS STAGE	
					if ( DeadUnitObjectCategory == 1 ) then 										-- UNIT
						if ( DeadUnitCategory == 2 or DeadUnitCategory == 3 ) then 					-- GROUND_UNIT or SHIP
							if ( string.find(DeadUnitName, "Syrian APC Tigr 233036") ) then  
								--Do nothing we don't want to include these units in the list currently
							else					
								UnitIntermentTableLength = UnitIntermentTableLength + 1				
								ScarletDawnUnitInterment[UnitIntermentTableLength] = DeadUnitName
							end	
						else
						end
					elseif ( DeadUnitObjectCategory == 3 ) then 									-- STATIC
						StaticIntermentTableLength = StaticIntermentTableLength + 1			
						ScarletDawnStaticInterment[StaticIntermentTableLength] = DeadUnitName												
					else
					end
				else
				end
			end	
		end
	end
end
world.addEventHandler(SEF_ONDEADEVENTHANDLER)

--////END EVENT HANDLERS
--trigger.action.outText("Event Handlers Started", 15)
env.info("Surrexen's Event Handlers Loaded Successfully", false)
-------------------------------------------------------------------------------------------------------------------------------------------------