env.info("Kill Box Starting", false)


ZoneVF = ZONE:FindByName("Kill Box VF")
ZoneWF = ZONE:FindByName("Kill Box WF") 
ZoneBA = ZONE:FindByName("Kill Box BA") 
ZoneBV = ZONE:FindByName("Kill Box BV") 


local menuKILLBOXTop = MENU_COALITION:New(coalition.side.BLUE, "KILL BOX VF")

-- SAM spawn emplates
KB_SA10 = "kbSAM-SA10"
KB_SA11 = "kbSAM-SA11"
KB_SA2 = "kbSAM-SA2"
KB_SA3 = "kbSAM-SA3"
KB_SA6 = "kbSAM-SA6"
KB_RAPIER = "kbSAM-Rapier"
KB_HAWK = "kbSAM-Hawk"
KB_AAA_IR = "kbSAM-AAA-IRsam"

-- Zone in which threat will be spawned
--zoneKILLBOX7769 = ZONE:FindByName("KILLBOX_ZONE_7769")

local KILLBOX = {}
KILLBOX.ActiveSite = {}
KILLBOX.rIADS = nil


function activateKILLBOXThreat(samTemplate, samZone, activeThreat, isReset)

  -- remove threat selection menu options
  if not isReset then
    commandActivateSa10:Remove()
    commandActivateSa2:Remove()
    commandActivateSa3:Remove()
    commandActivateSa6:Remove()
    commandActivateSa8:Remove()
    commandActivateSa15:Remove()
  end
  
  -- spawn threat in KILLBOX zone
  local KILLBOXSpawn = SPAWN:New(samTemplate)
  KILLBOXSpawn:OnSpawnGroup(
      function (spawnGroup)
        commandDeactivateKILLBOX = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Deactivate Kill Box", menuKILLBOXTop, resetKILLBOXThreat, spawnGroup, KILLBOXSpawn, activeThreat, false)
        commandRefreshKILLBOX = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Reset Kill Box", menuKILLBOXTop, resetKILLBOXThreat, spawnGroup, KILLBOXSpawn, activeThreat, true, samZone)
        MESSAGE:New("Kill Box VF is active with " .. activeThreat):ToAll()
        KILLBOX.rIADS = SkynetIADS:create("KILLBOX")
        KILLBOX.rIADS:setUpdateInterval(5)
        --KILLBOX.rIADS:addEarlyWarningRadar("GCI2")
        KILLBOX.rIADS:addSAMSite(spawnGroup.GroupName)
        KILLBOX.rIADS:getSAMSiteByGroupName(spawnGroup.GroupName):setGoLiveRangeInPercent(80)
        KILLBOX.rIADS:activate()        
      end
      , menuKILLBOXTop, rangePrefix, KILLBOXSpawn, activeThreat, samZone
    )
    :SpawnInZone(samZone, true)
end

function resetKILLBOXThreat(spawnGroup, KILLBOXSpawn, activeThreat, refreshKILLBOX, samZone)

  commandDeactivateKILLBOX:Remove() -- remove KILLBOX active menus
  commandRefreshKILLBOX:Remove()
  
  if KILLBOX.rIADS ~= nil then
    KILLBOX.rIADS:deactivate()
    KILLBOX.rIADS = nil
  end

  if spawnGroup:IsAlive() then
    spawnGroup:Destroy()
  end

  if refreshKILLBOX then
    KILLBOXSpawn:SpawnInZone(samZone, true)
  else
    addKILLBOXThreatMenu()
    MESSAGE:New("Kill Box VF "  .. activeThreat .." has been deactived."):ToAll()
  end    

end

function addKILLBOXThreatMenu()

  -- [threat template], [threat zone], [active threat]
  commandActivateSa10 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Activate SA-10", menuKILLBOXTop ,activateKILLBOXThreat, KB_SA10, ZoneVF, "SA-10")
  commandActivateSa2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Activate SA-2", menuKILLBOXTop ,activateKILLBOXThreat, KB_SA2, ZoneVF, "SA-2")
  commandActivateSa3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Activate SA-3", menuKILLBOXTop ,activateKILLBOXThreat, KB_SA3, ZoneVF, "SA-3")
  commandActivateSa6 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Activate SA-6", menuKILLBOXTop ,activateKILLBOXThreat, KB_SA6, ZoneVF, "SA-6")
  commandActivateRapier = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Activate Rapier", menuKILLBOXTop ,activateKILLBOXThreat, KB_RAPIER, ZoneVF, "Rapier")
  commandActivateSa11 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Activate SA-11", menuKILLBOXTop ,activateKILLBOXThreat, KB_SA11, ZoneVF, "SA-11")
  commandActivateHawk = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Activate Hawk", menuKILLBOXTop ,activateKILLBOXThreat, KB_HAWK, ZoneVF, "Hawk")
  commandActivateAAAIR = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Activate AAA/IR SAM", menuKILLBOXTop ,activateKILLBOXThreat, KB_AAA_IR, ZoneVF, "AAA/IR")
  

end

addKILLBOXThreatMenu()





--==============================================================================================================
--==============================================================================================================
--==============================================================================================================





--[[

--- Add BVR/GCI MENU Group Size. --->> Qty 
function KILLBOX.BuildMenuZone(Zone, MenuName, ParentMenu)
  MenuText = MenuName
  KILLBOX.SubMenu[MenuName] = MENU_COALITION:New(coalition.side.BLUE, MenuText, ParentMenu)
  KILLBOX.Spawn.Zone = Zone
  -- Build Level menus
  KILLBOX.BuildMenuQty(1, "One",  KILLBOX.SubMenu[MenuName])
  KILLBOX.BuildMenuQty(2, "Two",  KILLBOX.SubMenu[MenuName])
  KILLBOX.BuildMenuQty(3, "Three",  KILLBOX.SubMenu[MenuName])
  KILLBOX.BuildMenuQty(4, "Four",  KILLBOX.SubMenu[MenuName])
  KILLBOX.BuildMenuQty(5, "Five",  KILLBOX.SubMenu[MenuName])
end

--- Add KILLBOX MENU Root. --->> Zone
function KILLBOX.BuildMenuRoot()
  KILLBOX.Menu = MENU_COALITION:New(coalition.side.BLUE, "Kill Box Spawnable")
    -- Build group zone menus
    KILLBOX.BuildMenuZone(KILLBOX.ZoneVF, "Kill Box VF", KILLBOX.Menu)
    KILLBOX.BuildMenuZone(KILLBOX.ZoneWF, "Kill Box WF", KILLBOX.Menu)
    KILLBOX.BuildMenuZone(KILLBOX.ZoneBA, "Kill Box BA", KILLBOX.Menu)
    KILLBOX.BuildMenuZone(KILLBOX.ZoneBV, "Kill Box BV", KILLBOX.Menu)
    -- level 2 command
    KILLBOX.MenuRemoveAdversaries = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Remove Kill Box Adversaries", KILLBOX.Menu, KILLBOX.RemoveAdversaries)
end

KILLBOX.BuildMenuRoot()

--- END KILLBOX SECTION

]]--


env.info("Kill Box Complete", false)
