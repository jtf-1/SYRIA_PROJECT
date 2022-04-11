function ApacheCAS()

  SetApacheCASClient:ForEachClient(function(client)
   if (client ~= nil) and (client:IsAlive()) then 
      local group = client:GetGroup()
      local groupName = group:GetName()
      if (group:IsPartlyOrCompletelyInZone(ApacheCASzone)) then
        if _G["SpawnApacheCAS" .. groupName] == nil then --check if menu already exists for client
          MenuGroup = group
          _G["SpawnpacheCAS" .. groupName] = MENU_GROUP:New( MenuGroup, "ApacheCAS Zone1" ) -- top menu
            BuildMenus(1, MenuGroup, "coordiantes go here", _G["SpawnApacheCAS" .. groupName]) -- Group size Single [spawn qty], [client group], [menu text], [menu name .. group name] 
          MESSAGE:New("Marauder this is Hammer, we got you visual over Ash-Shughur. Reference point is Ash-Shughur city center. Report ready for tasking."):ToGroup(group)
        end
      end
    end
  end)
  timer.scheduleFunction(ApacheCAS,nil,timer.getTime() + 5) --check for clients inside the zone in T+5

end