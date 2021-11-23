env.info("BFM Loading", false)
               
            
--- BEGIN ACM/BFM SECTION

bfmAcmAdvRemove = false -- if set to true by admin client, all BFM/ACM sapwns will be removed within six seconds. 

-- CLIENT LIST

SetBfmAcmClient = SET_CLIENT:New() -- dynamic list of occupied client slots
  SetBfmAcmClient:FilterActive()
  SetBfmAcmClient:FilterCoalitions("blue")
  SetBfmAcmClient:FilterStart() -- Upadating filter. Create a list of all clients

-- BFM/ACM Zones
BfmAcmZoneFox = ZONE:FindByName("Zone_BfmAcmFox") -- zone within which missiles fired at players will be destroyed prior to impact
BfmAcmZoneMenu = ZONE:FindByName("Zone_BfmAcmMenu") -- zone on entry to which BFM/ACM menu will be added. Entry will be announced to player. 
BfmAcmZoneExit = ZONE:FindByName("Zone_BfmAcmExit") -- zone on exit from which BFM/ACM menu will be removed. Exit will be announced to player.

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

--[[
--BVR WEST
bvr14A = SPAWN:New( "AI BVR F-14A" )
bvr14B = SPAWN:New( "AI BVR F-14B" )
bvr15 = SPAWN:New( "AI BVR F-15" )
bvr16 = SPAWN:New( "AI BVR F-16" )
bvrF5 = SPAWN:New( "AI BVR F-5" )
bvrF18 = SPAWN:New( "AI BVR F-18" )  
bvrM2K = SPAWN:New( "AI BVR M-2000" )

--BVR EAST
bvrJ17 = SPAWN:New( "AI BVR JF-17" )
bvrM21 = SPAWN:New( "AI BVR Mig-21" )
bvrM23 = SPAWN:New( "AI BVR Mig-23" )
bvr29A = SPAWN:New( "AI BVR Mig-29A" )
bvr29S = SPAWN:New( "AI BVR Mig-29S" )
bvrM31 = SPAWN:New( "AI BVR Mig-31" )
bvrS25 = SPAWN:New( "AI BVR Su-25" )
bvrS27 = SPAWN:New( "AI BVR Su-27" )
bvrS34 = SPAWN:New( "AI BVR Su-34" )
]]--
--[[
--- MISSILE TRAINER
-- Missile trainer will destroy missiles prior to hitting target client
-- Missiles launched at AI are not affected
function MTstart()

fox=FOX:New() -- Create a new missile trainer object.

-- Add training zones.
fox:AddSafeZone(BfmAcmZoneFox)
fox:AddLaunchZone(BfmAcmZoneMenu) -- zone in which missiles will be tracked and messages displayed to client

-- FOX settings
fox:SetExplosionDistance(300) -- disatnce from client at which the tracked missile will be destroyed
--fox:SetDisableF10Menu()
fox:SetDebugOnOff()

-- Start missile trainer.
fox:Start()
fox:Status()
end

MarianasMToptions = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Missile Trainer", nil)
  
MarianasMT = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Turn on Missile Trainer", MarianasMToptions, function() MTstart() end, nil)

--- END MISSILE TRAINER
]]--

function SpawnAdv(adv,qty,group,rng) -- spawns adversary aircraft selected in BFM/ACM menu at chosen distance directly ahead of client

  range = rng * 1852 -- separation from client group  
  hdg = group:GetHeading() -- client group's current heading
  pos = group:GetPointVec2() -- client group's position on map
  spawnPt = pos:Translate(range, hdg, true) -- calculate the point at which to spawn the adversary group
  spawnVec3 = spawnPt:GetVec3() -- convert point to Vec3
 
  adv:InitGrouping(qty) -- set qty of adversaries to spawn
  adv:InitHeading(hdg + 180) -- set heading to point at client
  adv:OnSpawnGroup(
      function ( SpawnGroup )
        local CheckAdversary = SCHEDULER:New( SpawnGroup, -- add schedule, 5 sec interval, to check whether spawned AC has left the BFM/ACM zone
        function (CheckAdversary)
          if SpawnGroup then
            if (SpawnGroup:IsNotInZone(BfmAcmZoneMenu) or (bfmAcmAdvRemove)) then -- remove adversary group if it has left the zone, or Admin has selected the remove all command
              MESSAGE:New(bfmAcmAdvRemove and "All BFM/ACM adversaries removed" or "BFM/ACM adversary left zone and was removed"):ToAll()
              SpawnGroup:Destroy()
              SpawnGroup = nil
            end
          end
        end,
        {}, 0, 5 )
      end
    )
  adv:SpawnFromVec3(spawnVec3)
  
  MESSAGE:New("Adversary spawned."):ToGroup(group)
 
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