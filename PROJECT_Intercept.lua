env.info("Intercept Loading", false)

---------------------------------------------------------------------------------------------------
--- Variables
---------------------------------------------------------------------------------------------------
InterceptName = "RedIntercept"

InterceptGrp = { 
          "VVS Tu-95MS",
          "VVS Tu-160",
          "VVS Tu-22M3",
          "SyAAF An-26B",
          "IRIAF F-14A",
          "IRIAF F-4E",
          } 
   
InterceptZone = ZONE:FindByName("Intercept") 
              
---------------------------------------------------------------------------------------------------
--- Spawn/Delete Functions
---------------------------------------------------------------------------------------------------
function SEF_SPAWNINTERCEPT ()
  Bandit = SPAWN:NewWithAlias("InterceptPlane", InterceptName)
    :InitRandomizeTemplate(InterceptGrp)
    :OnSpawnGroup(
    
      function (groupSpawned)
        bandit_zone = ZONE_GROUP:New( "SWITCH_ZONE", groupSpawned, 1610 )
        bandit_in_zone = SCHEDULER:New( nil,

            function()
              bandit_zone:Scan( {Object.Category.UNIT}, {Unit.Category.AIRPLANE} ) -- SCAN: Look for airplanes in Zone
              --BASE:E(bandit_zone.ScanData) -- DEBUG: LOG SCAN DATA
              --SCHEDULER:New(nil,(bandit_zone:DrawZone(-1, {1,0,0}, 1, {1,0,0}, 0.15, 1)), 5, 15) -- DEBUG: SEE MOVING ZONE
              if bandit_zone:CheckScannedCoalition(coalition.side.BLUE) == true then -- SCAN: If Blue in zone, RTB Bandit
                MESSAGE:New('Bandit sucessfully intercepted', 30, 'Info'):ToAll()
                Patrol:RTB()
              end
            end
          , {}, 0, 10)
          
      end
      
    )
   :SpawnInZone(InterceptZone, true, 2000, 12000)
   --Patrol = AI_A2A_CAP:New(Bandit, InterceptZone, 3000, 12000, 400, 600, 600, 1600) -- For Agreesive CAP when implemented
   --Patrol:SetHomeAirbase(AIRBASE.Syria.Gazipasa)-- For Agreesive CAP when implemented
   Patrol = AI_PATROL_ZONE:New( InterceptZone, 3000, 12000, 400, 600 )
   Patrol:ManageFuel( 0.1, 60 )
   Patrol:SetControllable( Bandit )
   Patrol:__Start( 20 )
end


function SEF_PatrolDEL ()
  GroupName = GROUP:FindByName("RedIntercept#001")
  Patrol:Stop()
  GroupName:Destroy(true)-- Send group above to RTB
  MESSAGE:New("Intercept has been removed", 15):ToAll()--and send message to coallition 
end

---------------------------------------------------------------------------------------------------
--- Menu
---------------------------------------------------------------------------------------------------
InterceptMenuTop = MENU_COALITION:New(coalition.side.BLUE, "INTERCEPT SPAWNS")

function addInterceptMenu()

  MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Intercept Group", InterceptMenuTop, SEF_SPAWNINTERCEPT)
  MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Delete Intercept Unit", InterceptMenuTop, SEF_PatrolDEL)
  
end

addInterceptMenu()

env.info("Intercept Complete", false)

