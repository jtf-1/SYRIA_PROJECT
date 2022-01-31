--[[

-- Add vector and range to starting message
-- Add random low % hostile
-- move to carrier rather than static zone
-- Add despawn if intercept unit reaches carrier


]]--

env.info("Intercept Loading", false)

---------------------------------------------------------------------------------------------------
--- Variables
---------------------------------------------------------------------------------------------------
InterceptName = "RedIntercept"

InterceptGrp = { 
          "VVS Tu-95MS",
          "VVS Tu-160",
          "VVS Tu-22M3",
          "IL-76MD",
          "H-6J",
          "B-2",
          "Mig-28",
          "MQ-9",
          "V-22",
          "B-1B",
          "B-52H",
          } 
   
SoundEnabled = 1   
   
InterceptZone = ZONE:FindByName("Intercept")
InterceptAttackZone = ZONE:FindByName("InterceptAttackZone") 



function SEF_SOUNDTOGGLE()

  if ( SoundEnabled == 1 ) then   
    SoundEnabled = 0
    trigger.action.outText("Intercept Sound Files Disabled", 15)    
  elseif ( SoundEnabled == 0 ) then     
    SoundEnabled = 1
    trigger.action.outText("Intercept Sound Files Enabled", 15)
  else
  end 
end
              
---------------------------------------------------------------------------------------------------
--- Spawn/Delete Functions
---------------------------------------------------------------------------------------------------
 function SEF_SPAWNINTERCEPT ()
  
  if ( Group.getByName("RedIntercept#001") ) then
  GroupName = GROUP:FindByName("RedIntercept#001")
  GroupName:Destroy(true)-- remove group
  end
  
  function SEF_SOUND()
    MESSAGE:New('--- USS Theodore Roosevelt --- \n \nALERT ALERT ALERT \n \nHOSTILE AIRCRAFT IDENTIFIED APPROACHING THE CARRIER GROUP FROM THE NORTH WEST \n \nINTERCEPT THE AIRCRAFT BEFORE THEY CAN THREATEN THE CERRIER GROUP \n \nSCRAMBLE ALL ALERT AIRCRAFT', 30, 'Info'):ToBlue()
    if (SoundEnabled == 1) then
      local InterceptAlarm = USERSOUND:New( "WarningSir_BBC-Historical_3sec.wav" )
      InterceptAlarm:ToCoalition( coalition.side.BLUE )
    scramble_alert_aircraft= SCHEDULER:New( nil,
     function()
       local InterceptScramble = USERSOUND:New( "Scramble Alert Aircraft.ogg" )
       InterceptScramble:ToCoalition( coalition.side.BLUE )
     end
     , {}, 4, 0)
   end
  end 
  
  timer.scheduleFunction(SEF_SOUND, nil, timer.getTime() + 1) 
  
  
  Bandit = SPAWN:NewWithAlias("InterceptPlane", InterceptName)
    :InitRandomizeTemplate(InterceptGrp)
    :OnSpawnGroup(
    
      function (groupSpawned)
        bandit_zone = ZONE_GROUP:New( "SWITCH_ZONE", groupSpawned, 5000 )
        bandit_in_zone = SCHEDULER:New( nil,

            function()
              bandit_zone:Scan( {Object.Category.UNIT}, {Unit.Category.AIRPLANE} ) -- SCAN: Look for airplanes in Zone
              --BASE:E(bandit_zone.ScanData) -- DEBUG: LOG SCAN DATA
              --SCHEDULER:New(nil,(bandit_zone:DrawZone(-1, {1,0,0}, 1, {1,0,0}, 0.15, 1)), 5, 15) -- DEBUG: SEE MOVING ZONE
              if bandit_zone:CheckScannedCoalition(coalition.side.BLUE) == true then -- SCAN: If Blue in zone, RTB Bandit
                MESSAGE:New('You have sucessfully intercepted the Bandit and it is returning to base. Mission completed.', 30, 'Info'):ToBlue()
                Patrol:RTB()
              end
            end
          , {}, 0, 10)
      end
      
    )
   :SpawnInZone(InterceptZone, true, 2000, 12000)
   --Patrol = AI_A2A_CAP:New(Bandit, InterceptZone, 3000, 12000, 400, 600, 600, 1600) -- For Agreesive CAP when implemented
   --Patrol:SetHomeAirbase(AIRBASE.Syria.Gazipasa)-- For Agreesive CAP when implemented
   Patrol = AI_PATROL_ZONE:New( CAPZoneBlueCarrier, 5500, 12000, 500, 1000 )  -- CAPZoneBlueCarrier dependant on loading after Airforce lua
   Patrol:ManageFuel( 0.1, 60 )
   Patrol:SetControllable( Bandit )
   Patrol:__Start( 20 )
end


function SEF_PatrolDEL ()
  GroupName = GROUP:FindByName("RedIntercept#001")
  Patrol:Stop()
  GroupName:Destroy(true)-- remove group
  MESSAGE:New("Intercept has been removed", 15):ToAll()--and send message to coallition 
end

---------------------------------------------------------------------------------------------------
--- Menu
---------------------------------------------------------------------------------------------------
InterceptMenuTop = MENU_COALITION:New(coalition.side.BLUE, "CARRIER INTERCEPT SPAWNS")

function addInterceptMenu()

  MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Carrier Intercept Group", InterceptMenuTop, SEF_SPAWNINTERCEPT)
  MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Delete Red Intercept Group", InterceptMenuTop, SEF_PatrolDEL)
  MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Toggle Intercept Sounds", InterceptMenuTop, SEF_SOUNDTOGGLE)
  
  
end

addInterceptMenu()

env.info("Intercept Complete", false)

