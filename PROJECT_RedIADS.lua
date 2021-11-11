env.info("RED IADS Loading", false)
--assert(loadfile("F:\\_Google Drive\\DCS Missions\\SydADF2012.lua"))()
--SA6 % availability - 100% is full complement
--SA2 % availability
--SA3 % availability
--SA10 % availability
--EWR % availability

--Editable part v
local SA2pc = 100
local SA3pc = 100
local SA5pc = 100
local SA6pc = 100
local SA8pc = 100
local SA10pc = 100
local SA11pc = 100
local SA13pc = 100
local SA15pc = 100
local EWRpc = 100

--Editable part ^

SA2sam=SET_GROUP:New():FilterPrefixes("SAM-SA2"):FilterActive(true):FilterOnce()
SA3sam=SET_GROUP:New():FilterPrefixes("SAM-SA3"):FilterActive(true):FilterOnce()
SA5sam=SET_GROUP:New():FilterPrefixes("SAM-SA5"):FilterActive(true):FilterOnce()
SA6sam=SET_GROUP:New():FilterPrefixes("SAM-SA6"):FilterActive(true):FilterOnce()
SA8sam=SET_GROUP:New():FilterPrefixes("SAM-SA8"):FilterActive(true):FilterOnce()
SA10sam=SET_GROUP:New():FilterPrefixes("SAM-SA10"):FilterActive(true):FilterOnce()
SA11sam=SET_GROUP:New():FilterPrefixes("SAM-SA11"):FilterActive(true):FilterOnce()
SA13sam=SET_GROUP:New():FilterPrefixes("SAM-SA13"):FilterActive(true):FilterOnce()
SA15sam=SET_GROUP:New():FilterPrefixes("SAM-SA15"):FilterActive(true):FilterOnce()
EWR=SET_GROUP:New():FilterPrefixes("EWR"):FilterActive(true):FilterStart()
All=SET_GROUP:New():FilterActive(true):FilterStart()

local SA2count=SA2sam:Count()
local SA3count=SA3sam:Count()
local SA5count=SA5sam:Count()
local SA6count=SA6sam:Count()
local SA8count=SA8sam:Count()
local SA10count=SA10sam:Count()
local SA11count=SA11sam:Count()
local SA13count=SA13sam:Count()
local SA15count=SA15sam:Count()
local EWRcount=EWR:Count()

--We will reduce the complement of the SAM's by the fixed percentage requested above by removing some


local SA2toKeep = UTILS.Round(SA2count/100*SA2pc, 0)

--if SA2toKeep>0 then
local SA2toDestroy = SA2count - SA2toKeep
  for i = 1, SA2toDestroy do
   local grpObj = SA2sam:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)

  end
--end 

local SA3toKeep = UTILS.Round(SA3count/100*SA3pc, 0)

--if SA3toKeep>0 then
local SA3toDestroy = SA3count - SA3toKeep
  for i = 1, SA3toDestroy do
    local grpObj = SA3sam:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)

  end
--end 

local SA5toKeep = UTILS.Round(SA5count/100*SA5pc, 0)

--if SA6toKeep>0 then
local SA5toDestroy = SA5count - SA5toKeep
  for i = 1, SA5toDestroy do
    local grpObj = SA5sam:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)

  end
--end 

local SA6toKeep = UTILS.Round(SA6count/100*SA6pc, 0)

--if SA6toKeep>0 then
local SA6toDestroy = SA6count - SA6toKeep
  for i = 1, SA6toDestroy do
    local grpObj = SA6sam:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)

  end
--end 

local SA8toKeep = UTILS.Round(SA8count/100*SA8pc, 0)

--if SA6toKeep>0 then
local SA8toDestroy = SA8count - SA8toKeep
  for i = 1, SA8toDestroy do
    local grpObj = SA8sam:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)

  end
--end 

local SA10toKeep = UTILS.Round(SA10count/100*SA10pc, 0)

--if SA10toKeep>0 then
local SA10toDestroy = SA10count - SA10toKeep
  for i = 1, SA10toDestroy do
    local grpObj = SA10sam:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)

  end
--end

local SA11toKeep = UTILS.Round(SA11count/100*SA11pc, 0)

--if SA10toKeep>0 then
local SA11toDestroy = SA11count - SA11toKeep
  for i = 1, SA11toDestroy do
    local grpObj = SA11sam:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)

  end
--end

local SA13toKeep = UTILS.Round(SA13count/100*SA13pc, 0)

--if SA10toKeep>0 then
local SA13toDestroy = SA13count - SA13toKeep
  for i = 1, SA13toDestroy do
    local grpObj = SA13sam:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)

  end
--end

local SA15toKeep = UTILS.Round(SA15count/100*SA15pc, 0)

--if SA10toKeep>0 then
local SA15toDestroy = SA15count - SA15toKeep
  for i = 1, SA15toDestroy do
    local grpObj = SA15sam:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)

  end
--end

local EWRtoKeep = UTILS.Round(EWRcount/100*EWRpc, 0)

--if EWRtoKeep>0 then
local EWRtoDestroy = EWRcount - EWRtoKeep
  for i = 1, EWRtoDestroy do
    local grpObj = EWR:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)

  end
--end 

-----------------
-- REDFOR IADS --
-----------------
redIADS = SkynetIADS:create('SYRIA')
redIADS:setUpdateInterval(5)
redIADS:addEarlyWarningRadarsByPrefix('EWR')
redIADS:addSAMSitesByPrefix('SAM')
redIADS:getSAMSitesByNatoName('SA-2'):setGoLiveRangeInPercent(80)
redIADS:getSAMSitesByNatoName('SA-3'):setGoLiveRangeInPercent(80)
redIADS:getSAMSitesByNatoName('SA-5'):setGoLiveRangeInPercent(80)
redIADS:getSAMSitesByNatoName('SA-6'):setGoLiveRangeInPercent(80)
redIADS:getSAMSitesByNatoName('SA-8'):setGoLiveRangeInPercent(80)
redIADS:getSAMSitesByNatoName('SA-10'):setGoLiveRangeInPercent(80):setActAsEW(true)
redIADS:getSAMSitesByNatoName('SA-11'):setGoLiveRangeInPercent(80)
redIADS:getSAMSitesByNatoName('SA-13'):setGoLiveRangeInPercent(80)
redIADS:getSAMSitesByNatoName('SA-15'):setGoLiveRangeInPercent(100)
local sa151 = redIADS:getSAMSiteByGroupName('SAM-SA15-1')
redIADS:getSAMSiteByGroupName('SAM-SA10-1'):addPointDefence(sa151)
local sa152 = redIADS:getSAMSiteByGroupName('SAM-SA15-2')
redIADS:getSAMSiteByGroupName('SAM-SA10-2'):addPointDefence(sa152)
--redIADS:addRadioMenu()  

redIADS:activate()    
env.info("RED IADS Complete", false)

