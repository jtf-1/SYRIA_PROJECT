env.info("Kill Box Starting", false)

function KillBoxSpawn (group)
KBspawnVF = SPAWN:New(group)
  :InitLimit( 25, 1 )
  :InitRandomizeZones( "Kill Box VF" )
  :Spawn()
end

env.info("Kill Box Complete", false)




-- BEGIN ACM/BFM SECTION

BfmAcm = {}
BfmAcm.Menu = {}

--local SpawnBfm.groupName = nil

-- BFM/ACM Zones
BfmAcm.BoxZone = ZONE_POLYGON:New( "Polygon_Box", GROUP:FindByName("zone_box") )
BfmAcm.ZoneMenu = ZONE_POLYGON:New( "Polygon_BFM_ACM", GROUP:FindByName("COYOTEABC") )
BfmAcm.ExitZone = ZONE:FindByName("Zone_BfmAcmExit")
BfmAcm.Zone = ZONE:FindByName("Zone_BfmAcmFox")

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

local function BfmAddMenu()

  local devMenuBfm = false -- if true, BFM menu available outside BFM zone

  SetClient:ForEachClient(function(client)
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
  end)
  timer.scheduleFunction(BfmAddMenu,nil,timer.getTime() + 5)

end

BfmAddMenu()

-- END ACM/BFM SECTION

--- BEGIN BVR SECTION

---   BVR Menu map
--
--    AI BVR/GCI (menu level 0)
--      |_Group Size (menu level 1)
--        |_Altitude (menu level 2)
--          |_Formation (menu level 3)
--            |_Distance (menu level 4)
--              |_Aircraft Type (level 4 command) 
--      |_Remove Adversaries (level 2 command)

--- BVRGCI table - settings, defaults and spawnable adversaries
-- @type BVRGCI
-- @field #table Menu root BVR/GCI F10 menu.
-- @field #table SubMenu BVR/GCI submenus.
-- @field #string ZoneBvr ME Zone object name for BVRGCI area boundary.
-- @field #string ZoneBvrSpawn ME Zone object name for adversary spawn point.
-- @field #string ZoneWp1 ME Zone object name for adversary spawn waypoint 1.
-- @field #table Altitude Altitude name, Altitude in metres for adversary spawns.
-- @field #table Adversary Adversary text name, adversary spawn template.
-- @field #boolean Destroy switch to activate Destroy() method for all spawned BVRGCI adversaries.
BVRGCI = {
  Menu = {},
  SubMenu = {},
  ZoneBvr = ZONE:FindByName("ZONE_BVR"),
  ZoneBvrSpawn = ZONE:FindByName("ZONE_BVR_SPAWN"),
  ZoneBvrWp1 = ZONE:FindByName("ZONE_BVR_WP1"),
  Size = {
    Pair = 2,
    Four = 4,
  },
  Altitude = {
    High = 9144, -- 30,000ft
    Medium = 6096, -- 20,000ft
    Low = 3048, -- 10,000ft
    },
  Adversary = { 
    {"F4", "BVR_F4"},
    {"MIG23", "BVR_MIG23"},
  },
  Destroy = false,
}

--- Spawns adversary aircraft selected in BFM/ACM menu at chosen distance directly ahead of client.
-- @param #string type spawn template name.
-- @param #number qty quantity to spawn.
-- @param #string name text neame for type.
-- @param #number formation formation ID number.
function BVRGCI.SpawnAdv(type, qty, name, formation, altitude) 

  -- if no altitude param is passed, set default altitude
  altitude = altitude and altitude or BVRGCI.Altitude
  -- Vec3 coordinates for spawnpoint from ZoneWp1
  spawnWp1Vec3 = COORDINATE:NewFromVec3(BVRGCI.ZoneWp1:GetPointVec3())
  -- Vec3 coordintates for waypoint 1
  spawnWp2Vec3 = COORDINATE:NewFromVec3(BVRGCI.ZoneWp2:GetPointVec3())
  -- Heading from ZoneWp1 to ZoneWp2
  spawnDirectionVec3 = spawnWp1Vec3:GetDirectionVec3(spawnWp2Vec3)
  spawnHeading = BVRGCI.Heading
  
  spawnAdversary = SPAWN:New(type)
    spawnAdversary:InitGrouping(qty) 
    spawnAdversary:InitHeading(spawnHeading)
    spawnAdversary:InitHeight(altitude)
    spawnAdversary:OnSpawnGroup(
        function ( SpawnGroup, formation )
          -- reset despawn flag
          BVRGCI.Destroy = false
          -- set formation for spawned AC
          SpawnGroup:SetOption(AI.Option.Air.id.FORMATION, formation)
          -- add scheduled funtion, 5 sec interval
          local CheckAdversary = SCHEDULER:New( SpawnGroup, 
          function (CheckAdversary)
            if SpawnGroup then
              -- remove adversary group if it has left the BVR/GCI zone, or the remove all adversaries menu option has been selected
              if (SpawnGroup:IsNotInZone(BVRGCI.ZoneBvr) or (BVRGCI.Destroy)) then 
                MESSAGE:New(BVRGCI.Destroy and "All BVR adversaries removed" or "BVR adversary left zone and was removed"):ToAll()
                SpawnGroup:Destroy()
                SpawnGroup = nil
              end
            end
          end,
          {}, 0, 5 )
        end,
        formation
      )
    spawnAdversary:SpawnFromVec3(spawnWp1Vec3)
  
  local _msg = tostring(qty) .. "x " .. name .. " BVR Adversary spawned."
  MESSAGE:New(_msg):ToAll()
 
end

--- Build level 3 submenus and add spawn commands.
-- Step through BVRGCI.Adversary table,
-- add BVR/GCI submenus for formation distance, and
-- add commands to submenus for each aircraft type.
-- @param #object ParentMenu menu to which submenus and menu commands should be applied.
-- @param #number Qty Quantity of adversaries to spawn.
-- @param #string Level Altitude at which to spawn group.
-- @param #string Formation Formation in which to spawn group. 
function BVRGCI.BuildMenuCommands(ParentMenu, Qty, Level, Formation) 

  -- submenu for Group formation spacing.
  commandMenuGroup = MENU_COALITION:New(coalition.side.BLUE, "Group", ParentMenu)  
  -- submenu for Close formation spacing.
  commandMenuClose = MENU_COALITION:New(coalition.side.BLUE, "Close", ParentMenu)  
  -- submenu for Open formation spacing.
  commandMenuOpen = MENU_COALITION:New(coalition.side.BLUE, "Open", ParentMenu)  

  for i, v in ipairs(BVRGCI.Adversary) do
    typeName = v[1]
    typeSpawn = v[2]
  
    if GROUP:FindByName(typeSpawn) ~= nil then
        MENU_COALITION_COMMAND:New( coalition.side.BLUE, typeName, commandMenuGroup, BVRGCI.SpawnAdv, typeSpawn, Qty, typeName, ENUMS.Formation.FixedWing[Formation].Group)
        MENU_COALITION_COMMAND:New( coalition.side.BLUE, typeName, commandMenuClose, BVRGCI.SpawnAdv, typeSpawn, Qty, typeName, ENUMS.Formation.FixedWing[Formation].Close)
        MENU_COALITION_COMMAND:New( coalition.side.BLUE, typeName, commandMenuOpen, BVRGCI.SpawnAdv, typeSpawn, Qty, typeName, ENUMS.Formation.FixedWing[Formation].Open)
    else
      _msg = "Spawn template " .. typeSpawn .. " was not found and could not be added to menu."
      MESSAGE:New(_msg):ToAll()
    end
  end  
end

--- Add BVR/GCI level 2, 3 and 4 submenus.
function BVRGCI._BuildMenus(Level, MenuText, ParentMenu)

 -- menu level 2
 BVRGCI.SubMenu[Level] = MENU_COALITION:New(coalition.side.BLUE, MenuText, ParentMenu)
 
  --- Add level 3 and 4 menus
  -- Add commands to menu level 4
  -- @param #numnber Qty Quantity of aircraft to spawn as a group.
  -- @param #string MenuName Name of submenu.
  -- @param #object ParentMenu Parent menu to which submenus should be applied.
  -- @param #string Level Name of Altitude at which to spwan adversaries.
  -- @param #number Altitude Altitude at which to spawn adversaries.
  function BuildSubMenus(Qty, Level, MenuName, ParentMenu)
    -- menu level 3
    BVRGCI.SubMenu[MenuName] = MENU_COALITION:New(coalition.side.BLUE, MenuName, ParentMenu)
      -- menus level 4
      BVRGCI.SubMenu[MenuName].Lab = MENU_COALITION:New(coalition.side.BLUE, "Line Abreast", BVRGCI.SubMenu[MenuName])
      BVRGCI.SubMenu[MenuName].Trail = MENU_COALITION:New(coalition.side.BLUE, "Trail", BVRGCI.SubMenu[MenuName])
      BVRGCI.SubMenu[MenuName].Wedge = MENU_COALITION:New(coalition.side.BLUE, "Wedge", BVRGCI.SubMenu[MenuName])
      BVRGCI.SubMenu[MenuName].EchelonRight = MENU_COALITION:New(coalition.side.BLUE, "EchelonRight", BVRGCI.SubMenu[MenuName])
      BVRGCI.SubMenu[MenuName].EchelonLeft = MENU_COALITION:New(coalition.side.BLUE, "EchelonLeft", BVRGCI.SubMenu[MenuName])
      BVRGCI.SubMenu[MenuName].FingerFour = MENU_COALITION:New(coalition.side.BLUE, "FingerFour", BVRGCI.SubMenu[MenuName])
      BVRGCI.SubMenu[MenuName].Spread = MENU_COALITION:New(coalition.side.BLUE, "Spread", BVRGCI.SubMenu[MenuName])
        -- menu commands
        BVRGCI.BuildMenuCommands(BVRGCI.SubMenu[MenuName].Lab, Qty, Level, "LineAbreast")
        BVRGCI.BuildMenuCommands(BVRGCI.SubMenu[MenuName].Trail, Qty, Level, "Trail")
        BVRGCI.BuildMenuCommands(BVRGCI.SubMenu[MenuName].Wedge, Qty, Level, "Wedge")
        BVRGCI.BuildMenuCommands(BVRGCI.SubMenu[MenuName].EchelonRight, Level, Qty, "EchelonRight")
        BVRGCI.BuildMenuCommands(BVRGCI.SubMenu[MenuName].EchelonLeft, Level, Qty, "EchelonLeft")
        BVRGCI.BuildMenuCommands(BVRGCI.SubMenu[MenuName].FingerFour, Level, Qty, "FingerFour")
        BVRGCI.BuildMenuCommands(BVRGCI.SubMenu[MenuName].Spread, Qty, Level, "Spread")
  end

  BVRGCI.BuildSubMenus(2, "Pair", BVRGCI.SubMenu[Level])
  BVRGCI.BuildSubMenus(4, "Four", BVRGCI.SubMenu[Level])

end

--- Set flag to remove all spawned BVR adversaries.
function BVRGCI.RemoveAdversaries()
  BVRGCI.Destroy = true 
end

--- BVR/GCI F10 menu
-- menu level 1
BVRGCI.Menu = MENU_COALITION:New(coalition.side.BLUE, "AI BVR/GCI")
  -- add submenus
  BVRGCI.BuildMenus("High", "High Level", BVRGCI.Menu)
  BVRGCI.BuildMenus("Medium", "Medium Level", BVRGCI.Menu)
  BVRGCI.BuildMenus("Low", "Low Level", BVRGCI.Menu)
  --BVRGCI.BuildMenus(BVRGCI.Menu)
  -- menu level 2
  BVRGCI.MenuRemoveAdversaries = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Remove BVR Adversaries",BVRGCI.Menu,BVRGCI.RemoveAdversaries)
  

--- END BVR/GCI