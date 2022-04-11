function ApacheCAS()

ApacheCASSet = SET_ZONE:New()
ApacheCASSet:FilterPrefixes("ApacheCASzone")
ApacheCASGroup = SET_GROUP:New()
ApacheCASGroup:FilterZones(ApacheCASSet)

timer.scheduleFunction(ApacheCAS,nil,timer.getTime() + 5) --check for clients inside the zone in T+5

end

ApacheCAS()

--[[

if ApacheCASGroup:AnyPartlyInZone(ApacheCASzone) then
  MESSAGE:New("At least one GROUP has at least one UNIT in zone !", 10):ToAll()
end

]]--