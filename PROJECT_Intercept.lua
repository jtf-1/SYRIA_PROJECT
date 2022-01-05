env.info("Intercept Loading", false)

---------------------------------------------------------------------------------------------------
--- Variables
---------------------------------------------------------------------------------------------------
InterceptName = "RedIntercept"

InterceptGrp = { 
          --"VVS Tu-95MS",
          "VVS Tu-160",
          "VVS Tu-22M3",
          "SyAAF An-26B",
          --"IRIAF F-14A",
          --"IRIAF F-4E",
          } 
   
InterceptZone = ZONE:FindByName("Intercept") 
              
---------------------------------------------------------------------------------------------------
--- Spawn Function
---------------------------------------------------------------------------------------------------

function SEF_SPAWNINTERCEPT ()
  Bandit = SPAWN:NewWithAlias("InterceptPlane", InterceptName):InitRandomizeTemplate(InterceptGrp)
    :OnSpawnGroup(
    
    function (groupSpawned)
        --local playergrp = GROUP:GetPlayerUnits() --GROUP:FindByName( "Viper" )
        bandit_zone = ZONE_GROUP:New( "SWITCH_ZONE", groupSpawned, 20000 )
        bandit_in_zone = SCHEDULER:New( nil,
            function()
               if ZONE:FindByName("SWITCH_ZONE"):CheckScannedCoalition(coalition.side.BLUE) == true
               then
                  MESSAGE:New('Bandit sucessfully intercepted', 30, 'Info'):ToAll()
                  Bandit:RouteRTB()
              end
            end, 
         {}, 2, 5)
     end
     )
   :Spawn()
end



















--[[
function SEF_PatrolRTB ()
  GroupName = GROUP:FindByName("RedIntercept")
  GroupName:Destroy(true)-- Send group above to RTB
  MESSAGE:New("You have completed the intercept!", 15):ToAll()--and send message to coallition 
end

function SEF_SPAWNINTERCEPT ()

  PatrolSpawn = SPAWN:NewWithAlias("InterceptPlane", InterceptName):InitRandomizeTemplate(InterceptGrp)--:SpawnInZone(InterceptZone, true, 3000, 12000)
  PatrolGroup = PatrolSpawn:Spawn()
  Patrol = AI_PATROL_ZONE:New( InterceptZone, 3000, 12000, 400, 600 )
  Patrol:ManageFuel( 0.1, 60 )
  Patrol:SetControllable( PatrolGroup )
  Patrol:__Start( 5 )
  
  Threat = GROUP:FindByName(InterceptName)
  InterceptZone = ZONE_GROUP:New("RTBzone", Threat, 50000) -- Create zone around intercept target
  GroupObject = GROUP:GetPlayerUnits()  -- Get list of players
  if
    --Zone:E( { "Group is completely in Zone:", GroupObject:IsPartlyInZone( InterceptZone ) } ) -- is player within 3000m of target to force RTB?
  then
    SEF_PatrolRTB ()-- Send group above to RTB 
    --MESSAGE:New("You have intercepted the threat and they are RTB!", 15):ToAll()--and send message to coallition
  end
   
end 
]]--



---------------------------------------------------------------------------------------------------
--- Delete After Land Function
---------------------------------------------------------------------------------------------------

--[[
DeleteLanding = EVENTHANDLER:New()
DeleteLanding:HandleEvent( EVENTS.Land )
function DeleteLanding:OnEventLand( EventData )
ThisGroup = GROUP:FindByName(EventData.IniGroupName)
GroupUnit = ThisGroup:GetDCSUnit(1)
FirstUnit = UNIT:Find(GroupUnit)
  if FirstUnit:GetPlayerName() then
    PlayerName = FirstUnit:GetPlayerName()
    env.info(PlayerName .. " has landed")
  else 
    env.info("Not a player landed, deleting")
    ScheduleDelete(ThisGroup)-- custom schedule to delete a group
  end
end

function ScheduleDelete(group)
  SCHEDULER:New( nil, function() 
    env.info("Fleet: Destroying landed group")
    if group then
    group:Destroy()
    end
    end, {}, 90, 9999, 1, 62)
end
]]--


---------------------------------------------------------------------------------------------------
--- Menu
---------------------------------------------------------------------------------------------------
InterceptMenuTop = MENU_COALITION:New(coalition.side.BLUE, "INTERCEPT SPAWNS")

function addInterceptMenu()

  MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Intercept Group", InterceptMenuTop, SEF_SPAWNINTERCEPT)
  MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Intercept RTB", InterceptMenuTop, SEF_PatrolRTB)
  
end

addInterceptMenu()

env.info("Intercept Complete", false)

