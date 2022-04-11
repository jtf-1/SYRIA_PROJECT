env.info("ApacheCAS Loading", false)


function ApacheCAS()

  SetApacheCASClient:ForEachClient(function(client)
   if (client ~= nil) and (client:IsAlive()) then 
      local group = client:GetGroup()
      local groupName = group:GetName()
      if (group:IsPartlyOrCompletelyInZone(ApacheCASzone)) then
        if _G["SpawnApacheCAS" .. groupName] == nil then --check if menu already exists for client
          MenuGroup = group
          _G["SpawnpacheCAS" .. groupName] = MENU_GROUP:New( MenuGroup, "ApacheCAS Zone1", MenuTop ) -- top menu
            BuildMenus(1, MenuGroup, "coordiantes go here", _G["SpawnApacheCAS" .. groupName]) -- Group size Single [spawn qty], [client group], [menu text], [menu name .. group name] 
          MESSAGE:New("message goes here."):ToGroup(group)
          env.info("ApacheCAS entry Player name: " ..client:GetPlayerName()) -- debug log entry
          env.info("ApacheCAS entry Group Name: " ..group:GetName())  -- debug log entry
        end
      end
    end
  end)
  timer.scheduleFunction(ApacheCAS,nil,timer.getTime() + 5) --check for clients inside the zone in T+5

end
-- 
function ApacheCAS()


  local devMenuBfm = false -- if true, BFM menu available outside BFM zone

  SetBfmAcmClient:ForEachClient(function(client) -- iterate through each client in the list
   if (client ~= nil) and (client:IsAlive()) then 
      local group = client:GetGroup()
      local groupName = group:GetName()
      if (group:IsPartlyOrCompletelyInZone(BfmAcmZoneMenu) or devMenuBfm) then -- if group has entered the BFM/ACM menu zone,  add the menus. Explicit add if not in zone and devMenuBfm is true.
        if _G["SpawnBfm" .. groupName] == nil then --check if menu already exists for client
          MenuGroup = group
          _G["SpawnBfm" .. groupName] = MENU_GROUP:New( MenuGroup, "BFM/ACM", MenuTop ) -- top menu
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

ApacheCAS()

-- END ACM/BFM SECTION



env.info("ApacheCAS Complete", false)


function ApacheCAS()

  SetApacheCASClient:ForEachClient(function(client)
   if (client ~= nil) and (client:IsAlive()) then 
      local group = client:GetGroup()
      local groupName = group:GetName()
      if (group:IsPartlyOrCompletelyInZone(ApacheCASzone)) then
        --if _G["SpawnApacheCAS" .. groupName] == nil then --check if menu already exists for client
          --MenuGroup = group
          --_G["SpawnpacheCAS" .. groupName] = MENU_GROUP:New( MenuGroup, "ApacheCAS Zone1" ) -- top menu
            --BuildMenus(1, MenuGroup, "coordiantes go here", _G["SpawnApacheCAS" .. groupName])
          MESSAGE:New("Marauder this is Hammer, we got you visual over Ash-Shughur. Reference point is Ash-Shughur city center. Report ready for tasking."):ToGroup(group)
        --end
      end
    end
  end)
  timer.scheduleFunction(ApacheCAS,nil,timer.getTime() + 5) --check for clients inside the zone in T+5

end

function ApacheCAS()

  SetApacheCASClient:ForEachClient(function(client)
   if (client ~= nil) and (client:IsAlive()) then 
      local group = client:GetGroup()
      local groupName = group:GetName()
      if (group:IsPartlyOrCompletelyInZone(ApacheCASzone)) then
          MESSAGE:New("Marauder this is Hammer, we got you visual over Ash-Shughur. Reference point is Ash-Shughur city center. Report ready for tasking."):ToGroup(group)
      end
    end
  end)
  timer.scheduleFunction(ApacheCAS,nil,timer.getTime() + 5) --check for clients inside the zone in T+5

end