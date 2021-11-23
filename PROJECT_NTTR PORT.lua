env.info("BFM Loading", false)
               

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- BEGIN ACM/BFM SECTION
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local BfmAcm = {}
BfmAcm.Menu = {}

--local SpawnBfm.groupName = nil

-- BFM/ACM Zones
BfmAcm.BoxZone  = ZONE_POLYGON:New( "Polygon_Box", GROUP:FindByName("zone_box") )
BfmAcm.ZoneMenu = ZONE_POLYGON:New( "Polygon_BFM_ACM", GROUP:FindByName("COYOTEABC") )
BfmAcm.ExitZone = ZONE:FindByName("Zone_BfmAcmExit")
BfmAcm.Zone     = ZONE:FindByName("Zone_BfmAcmFox")

-- Spawn Objects
AdvF4 = SPAWN:New( "ADV_F4" )   
Adv28 = SPAWN:New( "ADV_MiG28" )  
Adv27 = SPAWN:New( "ADV_Su27" )
Adv23 = SPAWN:New( "ADV_MiG23" )
Adv16 = SPAWN:New( "ADV_F16" )
Adv18 = SPAWN:New( "ADV_F18" )

function BfmSpawnAdv(adv,qty,group,rng,unit)

  playerName = (unit:GetPlayerName() and unit:GetPlayerName() or "Unknown") 
  range = rng * 1852
  hdg = unit:GetHeading()
  pos = unit:GetPointVec2()
  spawnPt = pos:Translate(range, hdg, true)
  spawnVec3 = spawnPt:GetVec3()
  if BfmAcm.BoxZone:IsVec3InZone(spawnVec3) then
    MESSAGE:New(playerName .. " - Cannot spawn adversary aircraft in The Box.\nChange course or increase your range from The Box, and try again."):ToGroup(group)
  else
    adv:InitGrouping(qty)
      :InitHeading(hdg + 180)
      :OnSpawnGroup(
        function ( SpawnGroup )
          local CheckAdversary = SCHEDULER:New( SpawnGroup, 
          function (CheckAdversary)
            if SpawnGroup then
              if SpawnGroup:IsNotInZone( BfmAcm.ZoneMenu ) then
                MESSAGE:New("Adversary left BFM Zone and was removed!"):ToAll()
                SpawnGroup:Destroy()
                SpawnGroup = nil
              end
            end
          end,
          {}, 0, 5 )
        end
      )
      :SpawnFromVec3(spawnVec3)
    MESSAGE:New(playerName .. " has spawned Adversary."):ToGroup(group)
  end

end

function BfmBuildMenuCommands (AdvMenu, MenuGroup, MenuName, BfmMenu, AdvType, AdvQty, unit)

  _G[AdvMenu] = MENU_GROUP:New( MenuGroup, MenuName, BfmMenu)
    _G[AdvMenu .. "_rng5"] = MENU_GROUP_COMMAND:New( MenuGroup, "5 nmi", _G[AdvMenu], BfmSpawnAdv, AdvType, AdvQty, MenuGroup, 5, unit)
    _G[AdvMenu .. "_rng10"] = MENU_GROUP_COMMAND:New( MenuGroup, "10 nmi", _G[AdvMenu], BfmSpawnAdv, AdvType, AdvQty, MenuGroup, 10, unit)
    _G[AdvMenu .. "_rng20"] = MENU_GROUP_COMMAND:New( MenuGroup, "20 nmi", _G[AdvMenu], BfmSpawnAdv, AdvType, AdvQty, MenuGroup, 20, unit)

end

function BfmBuildMenus(AdvQty, MenuGroup, MenuName, SpawnBfmGroup, unit)

  local AdvSuffix = "_" .. tostring(AdvQty)
  BfmMenu = MENU_GROUP:New(MenuGroup, MenuName, SpawnBfmGroup)
    BfmBuildMenuCommands("SpawnBfmA4menu" .. AdvSuffix, MenuGroup, "Adversary A-4", BfmMenu, AdvF4, AdvQty, unit)
    BfmBuildMenuCommands("SpawnBfm28menu" .. AdvSuffix, MenuGroup, "Adversary MiG-28", BfmMenu, Adv28, AdvQty, unit)
    BfmBuildMenuCommands("SpawnBfm23menu" .. AdvSuffix, MenuGroup, "Adversary MiG-23", BfmMenu, Adv23, AdvQty, unit)
    BfmBuildMenuCommands("SpawnBfm27menu" .. AdvSuffix, MenuGroup, "Adversary Su-27", BfmMenu, Adv27, AdvQty, unit)
    BfmBuildMenuCommands("SpawnBfm16menu" .. AdvSuffix, MenuGroup, "Adversary F-16", BfmMenu, Adv16, AdvQty, unit)
    BfmBuildMenuCommands("SpawnBfm18menu" .. AdvSuffix, MenuGroup, "Adversary F-18", BfmMenu, Adv18, AdvQty, unit)   
      
end
-- CLIENTS
-- BLUFOR = SET_GROUP:New():FilterCoalitions( "blue" ):FilterStart()

-- SPAWN AIR MENU

function BfmAddMenu()

  local devMenuBfm = false -- if true, BFM menu available outside BFM zone

  SetClient:ForEachClient(
    function(client)
     if (client ~= nil) and (client:IsAlive()) then 
        local group = client:GetGroup()
        local groupName = group:GetName()
        local unit = client:GetClientGroupUnit()
        local playerName = client:GetPlayer()
        
        if (unit:IsInZone(BfmAcm.ZoneMenu) or devMenuBfm) then
          if _G["SpawnBfm" .. groupName] == nil then
            MenuGroup = group
            _G["SpawnBfm" .. groupName] = MENU_GROUP:New( MenuGroup, "AI BFM/ACM" )
              BfmBuildMenus(1, MenuGroup, "Single", _G["SpawnBfm" .. groupName], unit)
              BfmBuildMenus(2, MenuGroup, "Pair", _G["SpawnBfm" .. groupName], unit)
            MESSAGE:New(playerName .. " has entered the BFM/ACM zone.\nUse F10 menu to spawn adversaries."):ToGroup(group)
            --env.info("BFM/ACM entry Player name: " ..client:GetPlayerName())
            --env.info("BFM/ACM entry Group Name: " ..group:GetName())
          end
        elseif _G["SpawnBfm" .. groupName] ~= nil then
          if unit:IsNotInZone(BfmAcm.ZoneMenu) then
            _G["SpawnBfm" .. groupName]:Remove()
            _G["SpawnBfm" .. groupName] = nil
            MESSAGE:New(playerName .. " has left the ACM/BFM zone."):ToGroup(group)
            --env.info("BFM/ACM exit Group Name: " ..group:GetName())
          end
        end
      end
    end
  )
  timer.scheduleFunction(BfmAddMenu,nil,timer.getTime() + 5)

end

BfmAddMenu()

--- END ACMBFM SECTION

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- BEGIN BVRGCI SECTION.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- Each Menu level has an associated function which;
-- 1) adds the menu item for the level
-- 2) calls the function for the next level
--
-- Functions fit into the following menu map;
--
-- AI BVRGCI (menu root)
--   |_Group Size (menu level 1)
--     |_Altitude (menu level 2)
--       |_Formation (menu level 3)
--         |_Spacing (menu level 4)
--           |_Aircraft Type (command level 4) 
--   |_Remove Adversaries (command level 2)

--- BVRGCI default settings and values.
-- @type BVRGCI
-- @field #table Menu root BVRGCI F10 menu
-- @field #table SubMenu BVRGCI submenus
-- @field #number headingDefault Default heading for adversary spawns
-- @field #boolean Destroy When set to true, spawned adversary groups will be removed
local BVRGCI = {
  Menu            = {},
  SubMenu         = {},
  Spawn           = {},
  headingDefault  = 150,
  Destroy         = false,
}
 
--- ME Zone object for BVRGCI area boundary
-- @field #string ZoneBvr 
BVRGCI.ZoneBvr = ZONE:FindByName("ZONE_BVR")
--- ME Zone object for adversary spawn point
-- @field #string ZoneBvrSpawn 
BVRGCI.ZoneBvrSpawn = ZONE:FindByName("ZONE_BVR_SPAWN")
--- ME Zone object for adversary spawn waypoint 1
-- @field #string ZoneBvrWp1 
BVRGCI.ZoneBvrWp1 = ZONE:FindByName("ZONE_BVR_WP1")

--- Sizes of adversary groups
-- @type BVRGCI.Size
-- @field #number Pair Section size group.
-- @field #number Four Flight size group.
BVRGCI.Size = {
  Pair = 2,
  Four = 4,
}

--- Levels at which adversary groups may be spawned
-- @type BVRGCI.Altitude Altitude name, Altitude in metres for adversary spawns.
-- @field #number High Altitude, in metres, for High Level spawn.
-- @field #number Medium Altitude, in metres, for Medium Level spawns.
-- @field #number Low Altitude, in metres, for Low Level spawns.
BVRGCI.Altitude = {
  High    = 9144, -- 30,000ft
  Medium  = 6096, -- 20,000ft
  Low     = 3048, -- 10,000ft
}
    
--- Adversary types
-- @type BVRGCI.Adversary 
-- @list <#string> Display name for adversary type.
-- @list <#string> Name of spawn template for adversary type.
BVRGCI.Adversary = { 
  {"F-4", "BVR_F4"},
  {"F-14A", "BVR_F14A" },
  {"MiG-21", "BVR_MIG21"},
  {"MiG-23", "BVR_MIG23"},
  {"MiG-29A", "BVR_MIG29A"},
  {"Su-25", "BVR_SU25"},
  {"Su-34", "BVR_SU34"},
}

-- @field #table BVRGCI.BvrSpawnVec3 Vec3 coordinates for spawnpoint.
BVRGCI.BvrSpawnVec3 = COORDINATE:NewFromVec3(BVRGCI.ZoneBvrSpawn:GetPointVec3())
-- @field #table BvrWp1Vec3 Vec3 coordintates for wp1.
BVRGCI.BvrWp1Vec3 = COORDINATE:NewFromVec3(BVRGCI.ZoneBvrWp1:GetPointVec3())
-- @field #number Heading Heading from spawn point to wp1.
BVRGCI.Heading = COORDINATE:GetAngleDegrees(BVRGCI.BvrSpawnVec3:GetDirectionVec3(BVRGCI.BvrWp1Vec3))

--- Spawn adversary aircraft with menu tree selected parameters.
-- @param #string typeName Aircraft type name.
-- @param #string typeSpawnTemplate Airctraft type spawn template.
-- @param #number Qty Quantity to spawn.
-- @param #number Altitude Alititude at which to spawn adversary group.
-- @param #number Formation ID for Formation, and spacing, in which to spawn adversary group.
function BVRGCI.SpawnType(typeName, typeSpawnTemplate, Qty, Altitude, Formation) 
  local spawnHeading = BVRGCI.Heading
  local spawnVec3 = BVRGCI.BvrSpawnVec3
  spawnVec3.y = Altitude
  local spawnAdversary = SPAWN:New(typeSpawnTemplate)
  spawnAdversary:InitGrouping(Qty) 
  spawnAdversary:InitHeading(spawnHeading)
  spawnAdversary:OnSpawnGroup(
      function ( SpawnGroup, Formation, typeName )
        -- reset despawn flag
        BVRGCI.Destroy = false
        -- set formation for spawned AC
        SpawnGroup:SetOption(AI.Option.Air.id.FORMATION, Formation)
        -- add scheduled funtion, 5 sec interval
        local CheckAdversary = SCHEDULER:New( SpawnGroup, 
          function (CheckAdversary)
            if SpawnGroup then
              -- remove adversary group if it has left the BVR/GCI zone, or the remove all adversaries menu option has been selected
              if (SpawnGroup:IsNotInZone(BVRGCI.ZoneBvr) or (BVRGCI.Destroy)) then 
                local groupName = SpawnGroup.GroupName
                local msgDestroy = "BVR adversary group " .. groupName .. " removed."
                local msgLeftZone = "BVR adversary group " .. groupName .. " left zone and was removed."
                SpawnGroup:Destroy()
                SpawnGroup = nil
                MESSAGE:New(BVRGCI.Destroy and msgDestroy or msgLeftZone):ToAll()
              end
            end
          end,
        {}, 0, 5 )
      end,
      Formation, typeName
    )
  spawnAdversary:SpawnFromVec3(spawnVec3)
  local _msg = "BVR Adversary group spawned."
  MESSAGE:New(_msg):ToAll()
end

--- Remove all spawned BVRGCI adversaries
function BVRGCI.RemoveAdversaries()
  BVRGCI.Destroy = true
end

--- Add BVR/GCI MENU Adversary Type.
-- @param #table ParentMenu Parent menu with which each command should be associated.
function BVRGCI.BuildMenuType(ParentMenu)
  for i, v in ipairs(BVRGCI.Adversary) do
    local typeName = v[1]
    local typeSpawnTemplate = v[2]
    -- add Type spawn commands if spawn template exists, else send message that it doesn't
    if GROUP:FindByName(typeSpawnTemplate) ~= nil then
        MENU_COALITION_COMMAND:New(coalition.side.BLUE, typeName, ParentMenu, BVRGCI.SpawnType, typeName, typeSpawnTemplate, BVRGCI.Spawn.Qty, BVRGCI.Spawn.Level, ENUMS.Formation.FixedWing[BVRGCI.Spawn.Formation][BVRGCI.Spawn.Spacing])
    else
      _msg = "Spawn template " .. typeName .. " was not found and could not be added to menu."
      MESSAGE:New(_msg):ToAll()
    end
  end
end

--- Add BVR/GCI MENU Formation Spacing.
-- @param #string Spacing Spacing to apply to adversary group formation.
-- @param #string MenuText Text to display for menu option.
-- @param #object ParentMenu Parent menu with which this menu should be associated.
function BVRGCI.BuildMenuSpacing(Spacing, ParentMenu)
  local MenuName = Spacing
  local MenuText = Spacing
  BVRGCI.SubMenu[MenuName] = MENU_COALITION:New(coalition.side.BLUE, MenuText, ParentMenu)
  BVRGCI.Spawn.Spacing = Spacing
  -- Build Type menus
  BVRGCI.BuildMenuType(BVRGCI.SubMenu[MenuName])
end

--- Add BVR/GCI MENU Formation.
-- @param #string Formation Name of formation in which adversary group should fly.
-- @param #string MenuText Text to display for menu option.
-- @param #object ParentMenu Parent menu with which this menus should be associated.
function BVRGCI.BuildMenuFormation(Formation, MenuText, ParentMenu)
  local MenuName = Formation
  BVRGCI.SubMenu[MenuName] = MENU_COALITION:New(coalition.side.BLUE, MenuText, ParentMenu)
  BVRGCI.Spawn.Formation = Formation
  -- Build formation spacing menus
  BVRGCI.BuildMenuSpacing("Open", BVRGCI.SubMenu[MenuName])
  BVRGCI.BuildMenuSpacing("Close", BVRGCI.SubMenu[MenuName])
  BVRGCI.BuildMenuSpacing("Group", BVRGCI.SubMenu[MenuName])
end

--- Add BVR/GCI MENU Level.
-- @param #number Altitude Altitude, in metres, at which to adversary group should spawn
-- @param #string MenuName
function BVRGCI.BuildMenuLevel(Altitude, MenuName, MenuText, ParentMenu)
  BVRGCI.SubMenu[MenuName] = MENU_COALITION:New(coalition.side.BLUE, MenuText, ParentMenu)
  BVRGCI.Spawn.Level = Altitude
  --Build Formation menus
  BVRGCI.BuildMenuFormation("LineAbreast", "Line Abreast", BVRGCI.SubMenu[MenuName])
  BVRGCI.BuildMenuFormation("Trail", "Trail", BVRGCI.SubMenu[MenuName])
  BVRGCI.BuildMenuFormation("Wedge", "Wedge", BVRGCI.SubMenu[MenuName])
  BVRGCI.BuildMenuFormation("EchelonRight", "Echelon Right", BVRGCI.SubMenu[MenuName])
  BVRGCI.BuildMenuFormation("EchelonLeft", "Echelon Left", BVRGCI.SubMenu[MenuName])
  BVRGCI.BuildMenuFormation("FingerFour", "Finger Four", BVRGCI.SubMenu[MenuName])
  BVRGCI.BuildMenuFormation("Spread", "Spread", BVRGCI.SubMenu[MenuName])
  BVRGCI.BuildMenuFormation("BomberElement", "Diamond", BVRGCI.SubMenu[MenuName])
end

--- Add BVR/GCI MENU Group Size.
function BVRGCI.BuildMenuQty(Qty, MenuName, ParentMenu)
  MenuText = MenuName
  BVRGCI.SubMenu[MenuName] = MENU_COALITION:New(coalition.side.BLUE, MenuText, ParentMenu)
  BVRGCI.Spawn.Qty = Qty
  -- Build Level menus
  BVRGCI.BuildMenuLevel(BVRGCI.Altitude.High, "High", "High Level",  BVRGCI.SubMenu[MenuName])
  BVRGCI.BuildMenuLevel(BVRGCI.Altitude.Medium, "Medium", "Medium Level",  BVRGCI.SubMenu[MenuName])
  BVRGCI.BuildMenuLevel(BVRGCI.Altitude.Low, "Low", "Low Level",  BVRGCI.SubMenu[MenuName])
end

--- Add BVRGCI MENU Root.
function BVRGCI.BuildMenuRoot()
  BVRGCI.Menu = MENU_COALITION:New(coalition.side.BLUE, "AI BVR/GCI")
    -- Build group size menus
    BVRGCI.BuildMenuQty(2, "Pair", BVRGCI.Menu)
    BVRGCI.BuildMenuQty(4, "Four", BVRGCI.Menu)
    -- level 2 command
    BVRGCI.MenuRemoveAdversaries = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Remove BVR Adversaries", BVRGCI.Menu, BVRGCI.RemoveAdversaries)
end

BVRGCI.BuildMenuRoot()

--- END BVRGCI SECTION







--============================================================================================================================================================================================================
--============================================================================================================================================================================================================
--============================================================================================================================================================================================================




            
--- BEGIN ACM/BFM SECTION

bfmAcmAdvRemove = false -- if set to true by admin client, all BFM/ACM sapwns will be removed within six seconds. 

-- CLIENT LIST

SetBfmAcmClient = SET_CLIENT:New() -- dynamic list of occupied client slots
  SetBfmAcmClient:FilterActive()
  SetBfmAcmClient:FilterCoalitions("blue")
  SetBfmAcmClient:FilterStart() -- Upadating filter. Create a list of all clients

-- BFM/ACM Zones
BfmAcm.BoxZone  = ZONE:FindByName("Zone_BfmAcmRedSpawn")
BfmAcm.Zone = ZONE:FindByName("Zone_BfmAcmFox") -- zone within which missiles fired at players will be destroyed prior to impact
BfmAcm.ZoneMenu = ZONE:FindByName("Zone_BfmAcmMenu") -- zone on entry to which BFM/ACM menu will be added. Entry will be announced to player. 
BfmAcm.ExitZone = ZONE:FindByName("Zone_BfmAcmExit") -- zone on exit from which BFM/ACM menu will be removed. Exit will be announced to player.

-- SPAWN TEMPLATES

--WVR WEST
wvr14A = SPAWN:New( "AI WVR F-14A" )
wvr14B = SPAWN:New( "AI WVR F-14B" )
wvr15 = SPAWN:New( "AI WVR F-15" )
wvr16 = SPAWN:New( "AI WVR F-16" )
wvrF5 = SPAWN:New( "AI WVR F-5" )
wvrF18 = SPAWN:New( "AI WVR F-18" )  
wvrM2K = SPAWN:New( "AI WVR M-2000" )

--WVR EAST
wvrJ17 = SPAWN:New( "AI WVR JF-17" )
wvrM21 = SPAWN:New( "AI WVR Mig-21" )
wvrM23 = SPAWN:New( "AI WVR Mig-23" )
wvr29A = SPAWN:New( "AI WVR Mig-29A" )
wvr29S = SPAWN:New( "AI WVR Mig-29S" )
wvrM31 = SPAWN:New( "AI WVR Mig-31" )
wvrS25 = SPAWN:New( "AI WVR Su-25" )
wvrS27 = SPAWN:New( "AI WVR Su-27" )
--wvrS34 = SPAWN:New( "AI WVR Su-34" )

function SpawnAdv(adv,qty,group,rng) -- spawns adversary aircraft selected in BFM/ACM menu at chosen distance directly ahead of client

  playerName = (unit:GetPlayerName() and unit:GetPlayerName() or "Unknown") 
  range = rng * 1852 -- separation from client group  
  hdg = group:GetHeading() -- client group's current heading
  pos = group:GetPointVec2() -- client group's position on map
  spawnPt = pos:Translate(range, hdg, true) -- calculate the point at which to spawn the adversary group
  spawnVec3 = spawnPt:GetVec3() -- convert point to Vec3
  if BfmAcm.BoxZone:IsVec3InZone(spawnVec3) then
    MESSAGE:New(playerName .. " - Cannot spawn adversary aircraft in The Box.\nChange course or increase your range from The Box, and try again."):ToGroup(group)
  else   
  adv:InitGrouping(qty) -- set qty of adversaries to spawn
    :InitHeading(hdg + 180) -- set heading to point at client
    :OnSpawnGroup(
      function ( SpawnGroup )
        local CheckAdversary = SCHEDULER:New( SpawnGroup, -- add schedule, 5 sec interval, to check whether spawned AC has left the BFM/ACM zone
        function (CheckAdversary)
          if SpawnGroup then
            if (SpawnGroup:IsNotInZone(BfmAcm.ZoneMenu) or (bfmAcmAdvRemove)) then -- remove adversary group if it has left the zone, or Admin has selected the remove all command
              MESSAGE:New(bfmAcmAdvRemove and "All BFM/ACM adversaries removed" or "BFM/ACM adversary left zone and was removed"):ToAll()
              SpawnGroup:Destroy()
              SpawnGroup = nil
            end
          end
        end,
        {}, 0, 5 )
      end
    )
    :SpawnFromVec3(spawnVec3)
  MESSAGE:New(playerName .. " has spawned Adversary."):ToGroup(group)
 end
end

function BuildMenuCommands (AdvMenu, MenuGroup, MenuName, BfmMenu, AdvType, AdvQty, Wvr) -- adds BFM/ACM menu spawn commands for player group

  _G[AdvMenu] = MENU_GROUP:New( MenuGroup, MenuName, BfmMenu)
    if Wvr then
      _G[AdvMenu .. "_rng10"] = MENU_GROUP_COMMAND:New( MenuGroup, "10 nmi", _G[AdvMenu], SpawnAdv, AdvType, AdvQty, MenuGroup, 10) -- [client group to which command apoplies], [menu text], [parent menu], [spawn function], [spawn template], {spawn qty], [client group], [separation in miles] 
      _G[AdvMenu .. "_rng20"] = MENU_GROUP_COMMAND:New( MenuGroup, "20 nmi", _G[AdvMenu], SpawnAdv, AdvType, AdvQty, MenuGroup, 20)
    else
      _G[AdvMenu .. "_rng40"] = MENU_GROUP_COMMAND:New( MenuGroup, "40 nmi", _G[AdvMenu], SpawnAdv, AdvType, AdvQty, MenuGroup, 40)
      _G[AdvMenu .. "_rng60"] = MENU_GROUP_COMMAND:New( MenuGroup, "60 nmi", _G[AdvMenu], SpawnAdv, AdvType, AdvQty, MenuGroup, 60)
      _G[AdvMenu .. "_rng80"] = MENU_GROUP_COMMAND:New( MenuGroup, "80 nmi", _G[AdvMenu], SpawnAdv, AdvType, AdvQty, MenuGroup, 80)
    end    

end

function BuildMenus(AdvQty, MenuGroup, MenuName, SpawnBfmGroup) -- adds BFM/ACM menus to player group AdvQty, MenuGroup, MenuName, SpawnBfmGroup

  local AdvSuffix = "_" .. tostring(AdvQty)
  
  BfmMenuSize = MENU_GROUP:New(MenuGroup, MenuName, SpawnBfmGroup) -- GROUP Size
  
    BfmMenuWvr = MENU_GROUP:New(MenuGroup, "WVR", BfmMenuSize) -- WVR 
  
      BfmMenuWvrEast = MENU_GROUP:New(MenuGroup, "Eastern AC Types", BfmMenuWvr) -- Eastern AC Types
    
        
        BuildMenuCommands("SpawnBfmJ17menuWvr" .. AdvSuffix, MenuGroup, "Adversary JF-17", BfmMenuWvrEast, wvrJ17, AdvQty, true) --[this menu name .. quantity], [client group to which menu applies], [menu text], [parent menu], [spawn template], [quantity to spawn], [WVR if true, else BVR] 
        BuildMenuCommands("SpawnBfmM2KmenuWvr" .. AdvSuffix, MenuGroup, "Adversary M-2000", BfmMenuWvrEast, wvrM2K, AdvQty, true)
        BuildMenuCommands("SpawnBfmM21menuWvr" .. AdvSuffix, MenuGroup, "Adversary MiG-21", BfmMenuWvrEast, wvrM21, AdvQty, true)
        BuildMenuCommands("SpawnBfmM23menuWvr" .. AdvSuffix, MenuGroup, "Adversary MiG-23", BfmMenuWvrEast, wvrM23, AdvQty, true)
        BuildMenuCommands("SpawnBfm29AmenuWvr" .. AdvSuffix, MenuGroup, "Adversary MiG-29A", BfmMenuWvrEast, wvr29A, AdvQty, true)
        BuildMenuCommands("SpawnBfm29SmenuWvr" .. AdvSuffix, MenuGroup, "Adversary MiG-29S", BfmMenuWvrEast, wvr29S, AdvQty, true)
        BuildMenuCommands("SpawnBfm31menuWvr" .. AdvSuffix, MenuGroup, "Adversary MiG-31", BfmMenuWvrEast, wvrM31, AdvQty, true)
        BuildMenuCommands("SpawnBfmS25menuWvr" .. AdvSuffix, MenuGroup, "Adversary Su-25", BfmMenuWvrEast, wvrS25, AdvQty, true)
        BuildMenuCommands("SpawnBfmS27menuWvr" .. AdvSuffix, MenuGroup, "Adversary Su-27", BfmMenuWvrEast, wvrS27, AdvQty, true)
        --BuildMenuCommands("SpawnBfmS34menuWvr" .. AdvSuffix, MenuGroup, "Adversary Su-34", BfmMenuWvrEast, wvrS34, AdvQty, true)  
  
      BfmMenuWvrWest = MENU_GROUP:New(MenuGroup, "Western AC Types", BfmMenuWvr) -- Western AC Types
        
        BuildMenuCommands("SpawnBfm14AmenuWvr" .. AdvSuffix, MenuGroup, "Adversary F-14A", BfmMenuWvrWest, wvr14A, AdvQty, true)
        BuildMenuCommands("SpawnBfm14BmenuWvr" .. AdvSuffix, MenuGroup, "Adversary F-14B", BfmMenuWvrWest, wvr14B, AdvQty, true)
        BuildMenuCommands("SpawnBfm15menuWvr" .. AdvSuffix, MenuGroup, "Adversary F-15", BfmMenuWvrWest, wvr15, AdvQty, true) 
        BuildMenuCommands("SpawnBfm16menuWvr" .. AdvSuffix, MenuGroup, "Adversary F-16", BfmMenuWvrWest, wvr16, AdvQty, true)
        BuildMenuCommands("SpawnBfmF5menuWvr" .. AdvSuffix, MenuGroup, "Adversary F-5", BfmMenuWvrWest, wvrF5, AdvQty, true)
        BuildMenuCommands("SpawnBfmF18menuWvr" .. AdvSuffix, MenuGroup, "Adversary F-18", BfmMenuWvrWest, wvrF18, AdvQty, true)
 
    BfmMenuBvr = MENU_GROUP:New(MenuGroup, "BVR", BfmMenuSize) -- BVR
  
      BfmMenuBvrEast = MENU_GROUP:New(MenuGroup, "Eastern AC Types", BfmMenuBvr) -- Eastern AC Types

        BuildMenuCommands("SpawnBfmJ17menuBvr" .. AdvSuffix, MenuGroup, "Adversary JF-17", BfmMenuBvrEast, bvrJ17, AdvQty)
        BuildMenuCommands("SpawnBfmM2KmenuBvr" .. AdvSuffix, MenuGroup, "Adversary M-2000", BfmMenuBvrEast, bvrM2K, AdvQty)
        BuildMenuCommands("SpawnBfmM21menuBvr" .. AdvSuffix, MenuGroup, "Adversary MiG-21", BfmMenuBvrEast, bvrM21, AdvQty)
        BuildMenuCommands("SpawnBfmM23menuBvr" .. AdvSuffix, MenuGroup, "Adversary MiG-23", BfmMenuBvrEast, bvrM23, AdvQty)
        BuildMenuCommands("SpawnBfm29AmenuBvr" .. AdvSuffix, MenuGroup, "Adversary MiG-29A", BfmMenuBvrEast, bvr29A, AdvQty)
        BuildMenuCommands("SpawnBfm29SmenuBvr" .. AdvSuffix, MenuGroup, "Adversary MiG-29S", BfmMenuBvrEast, bvr29S, AdvQty)
        BuildMenuCommands("SpawnBfm31menuBvr" .. AdvSuffix, MenuGroup, "Adversary MiG-31", BfmMenuBvrEast, bvrM31, AdvQty)
        BuildMenuCommands("SpawnBfmS25menuBvr" .. AdvSuffix, MenuGroup, "Adversary Su-25", BfmMenuBvrEast, bvrS25, AdvQty)
        BuildMenuCommands("SpawnBfmS27menuBvr" .. AdvSuffix, MenuGroup, "Adversary Su-27", BfmMenuBvrEast, bvrS27, AdvQty)
        --BuildMenuCommands("SpawnBfmS34menuBvr" .. AdvSuffix, MenuGroup, "Adversary Su-34", BfmMenuBvrEast, bvrS34, AdvQty)  

      BfmMenuBvrWest = MENU_GROUP:New(MenuGroup, "Western AC Types", BfmMenuBvr) -- Western AC Types

        BuildMenuCommands("SpawnBfm14AmenuBvr" .. AdvSuffix, MenuGroup, "Adversary F-14A", BfmMenuBvrWest, bvr14A, AdvQty)
        BuildMenuCommands("SpawnBfm14BmenuBvr" .. AdvSuffix, MenuGroup, "Adversary F-14B", BfmMenuBvrWest, bvr14B, AdvQty)
        BuildMenuCommands("SpawnBfm15menuBvr" .. AdvSuffix, MenuGroup, "Adversary F-15", BfmMenuBvrWest, bvr15, AdvQty)
        BuildMenuCommands("SpawnBfm16menuBvr" .. AdvSuffix, MenuGroup, "Adversary F-16", BfmMenuBvrWest, bvr16, AdvQty)
        BuildMenuCommands("SpawnBfmF5menuBvr" .. AdvSuffix, MenuGroup, "Adversary F-5", BfmMenuBvrWest, bvrF5, AdvQty)
        BuildMenuCommands("SpawnBfmF18menuBvr" .. AdvSuffix, MenuGroup, "Adversary F-18", BfmMenuBvrWest, bvrF18, AdvQty)
      
end

-- 
function BFMACM()

--    Menu map
--
--    _AI BFM/ACM
--      |_GROUP Size
--        |_WVR/BVR
--          |_Eastern/Western AC Types

  local devMenuBfm = false -- if true, BFM menu available outside BFM zone

  SetBfmAcmClient:ForEachClient(function(client) -- iterate through each client in the list
   if (client ~= nil) and (client:IsAlive()) then 
      local group = client:GetGroup()
      local groupName = group:GetName()
      if (group:IsPartlyOrCompletelyInZone(BfmAcmZoneMenu) or devMenuBfm) then -- if group has entered the BFM/ACM menu zone,  add the menus. Explicit add if not in zone and devMenuBfm is true.
        if _G["SpawnBfm" .. groupName] == nil then --check if menu already exists for client
          MenuGroup = group
          _G["SpawnBfm" .. groupName] = MENU_GROUP:New( MenuGroup, "BFM/ACM" ) -- top menu
            BuildMenus(1, MenuGroup, "Single", _G["SpawnBfm" .. groupName]) -- Group size Single [spawn qty], [client group], [menu text], [menu name .. group name] 
            BuildMenus(2, MenuGroup, "Pair", _G["SpawnBfm" .. groupName]) -- Group size Pair
            BuildMenus(4, MenuGroup, "Division", _G["SpawnBfm" .. groupName]) -- Group size Division
          MESSAGE:New("You have entered the BFM/ACM zone.\nUse F10 menu to spawn adversaries."):ToGroup(group)
          env.info("BFM/ACM entry Player name: " ..client:GetPlayerName()) -- debug log entry
          env.info("BFM/ACM entry Group Name: " ..group:GetName())  -- debug log entry
        end
      elseif _G["SpawnBfm" .. groupName] ~= nil then -- check menu not already removed
        if group:IsNotInZone(BfmAcmZoneExit) then -- if group has left the BFM/ACM exit zone, remove the menus
          _G["SpawnBfm" .. groupName]:Remove()
          _G["SpawnBfm" .. groupName] = nil --destroy the menu object
          MESSAGE:New("You are outside the ACM/BFM zone."):ToGroup(group)
          env.info("BFM/ACM exit Group Name: " .. group:GetName())
        end
      end
    end
  end)
  timer.scheduleFunction(BFMACM,nil,timer.getTime() + 5) --check for clients inside the zone in T+5

end

BFMACM()

-- END ACM/BFM SECTION



env.info("BFM Complete", false)