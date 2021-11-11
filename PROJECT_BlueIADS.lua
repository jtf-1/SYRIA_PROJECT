env.info("BLUE IADS Loading", false)

--assert(loadfile("F:\\_Google Drive\\DCS Missions\\SydADF2012.lua"))()
--SA6 % availability - 100% is full complement
--SA2 % availability
--SA3 % availability
--SA10 % availability
--EWR % availability
--[[
--Editable part v
local Patriotpc = 100
local Hawkpc = 100
local BASECAPpc = 100
local bEWRpc = 100


--Editable part ^

Patriotsam=SET_GROUP:New():FilterPrefixes("bSAM-Patriot"):FilterActive(true):FilterOnce()
Hawksam=SET_GROUP:New():FilterPrefixes("bSAM-Hawk"):FilterActive(true):FilterOnce()
BASECAPsam=SET_GROUP:New():FilterPrefixes("bSAM-BASECAP#"):FilterActive(true):FilterOnce()
bEWR=SET_GROUP:New():FilterPrefixes("blueEWR"):FilterActive(true):FilterStart()

All=SET_GROUP:New():FilterActive(true):FilterStart()

local Patriotcount=Patriotsam:Count()
local Hawkcount=Hawksam:Count()
local BASECAPcount=BASECAPsam:Count()
local bEWRcount=bEWR:Count()


--We will reduce the complement of the SAM's by the fixed percentage requested above by removing some


local PatriottoKeep = UTILS.Round(Patriotcount/100*Patriotpc, 0)

--if SA2toKeep>0 then
local PatriottoDestroy = Patriotcount - PatriottoKeep
  for i = 1, PatriottoDestroy do
   local grpObj = Patriotsam:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)

  end
--end 

local HawktoKeep = UTILS.Round(Hawkcount/100*Hawkpc, 0)

--if SA3toKeep>0 then
local HawktoDestroy = Hawkcount - HawktoKeep
  for i = 1, HawktoDestroy do
    local grpObj = Hawksam:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)

  end
--end 

local BASECAPtoKeep = UTILS.Round(BASECAPcount/100*BASECAPpc, 0)

--if SA6toKeep>0 then
local BASECAPtoDestroy = BASECAPcount - BASECAPtoKeep
  for i = 1, BASECAPtoDestroy do
    local grpObj = BASECAPsam:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)

  end
--end 

local bEWRtoKeep = UTILS.Round(bEWRcount/100*bEWRpc, 0)

--if EWRtoKeep>0 then
local bEWRtoDestroy = bEWRcount - bEWRtoKeep
  for i = 1, bEWRtoDestroy do
    local grpObj = bEWR:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)

  end
--end 
]]--
-----------------
-- BLUE IADS --
-----------------

function SEF_ReaddIADS ()
  env.info("Adding Respawns to IADS", false)
  blueIADS = SkynetIADS:create('BlueSAM')
  blueIADS:setUpdateInterval(5)
  blueIADS:addEarlyWarningRadarsByPrefix('blueEWR')
  blueIADS:addSAMSitesByPrefix('bSAM')
  blueIADS:getSAMSitesByNatoName('Patriot'):setActAsEW(true)
  blueIADS:getSAMSitesByNatoName('Hawk'):setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE)
  --blueIADS:addRadioMenu()  
  blueIADS:activate()    
  env.info("Respawns integrated into IADS", false)
  timer.scheduleFunction(SEF_ReaddIADS, nil, timer.getTime() + 1800)  --1800
end

timer.scheduleFunction(SEF_ReaddIADS, nil, timer.getTime() + 45)

env.info("BLUE IADS Complete", false)
