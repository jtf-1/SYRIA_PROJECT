env.info("Unit Sanitize Starting", false)

BlueBase=SET_GROUP:New():FilterPrefixes("bSAM-BASECAP#"):FilterActive(true):FilterOnce()
Blue1=SET_GROUP:New():FilterPrefixes("bSAM-1"):FilterActive(true):FilterOnce()
Blue2=SET_GROUP:New():FilterPrefixes("bSAM-2"):FilterActive(true):FilterOnce()
Blue3=SET_GROUP:New():FilterPrefixes("bSAM-3"):FilterActive(true):FilterOnce()
Blue4=SET_GROUP:New():FilterPrefixes("bSAM-4"):FilterActive(true):FilterOnce()
Blue5=SET_GROUP:New():FilterPrefixes("bSAM-5"):FilterActive(true):FilterOnce()
Blue6=SET_GROUP:New():FilterPrefixes("bSAM-6"):FilterActive(true):FilterOnce()
Blue7=SET_GROUP:New():FilterPrefixes("bSAM-7"):FilterActive(true):FilterOnce()
Blue8=SET_GROUP:New():FilterPrefixes("bSAM-8"):FilterActive(true):FilterOnce()
Blue9=SET_GROUP:New():FilterPrefixes("bSAM-9"):FilterActive(true):FilterOnce()
Red1=SET_GROUP:New():FilterPrefixes("rSAM-1"):FilterActive(true):FilterOnce()
Red2=SET_GROUP:New():FilterPrefixes("rSAM-2"):FilterActive(true):FilterOnce()
Red3=SET_GROUP:New():FilterPrefixes("rSAM-3"):FilterActive(true):FilterOnce()
Red4=SET_GROUP:New():FilterPrefixes("rSAM-4"):FilterActive(true):FilterOnce()
Red5=SET_GROUP:New():FilterPrefixes("rSAM-5"):FilterActive(true):FilterOnce()
Red6=SET_GROUP:New():FilterPrefixes("rSAM-6"):FilterActive(true):FilterOnce()
Red7=SET_GROUP:New():FilterPrefixes("rSAM-7"):FilterActive(true):FilterOnce()
Red8=SET_GROUP:New():FilterPrefixes("rSAM-8"):FilterActive(true):FilterOnce()
Red9=SET_GROUP:New():FilterPrefixes("rSAM-9"):FilterActive(true):FilterOnce()
RedBase=SET_GROUP:New():FilterPrefixes("rSAM-BASECAP#"):FilterActive(true):FilterOnce()
DownedPilot=SET_GROUP:New():FilterPrefixes("Downed Pilot"):FilterActive(true):FilterOnce()
Crates=SET_STATIC:New():FilterPrefixes("Cargo Static Group"):FilterOnce()

--=====================================================================================

local BlueBasecount=BlueBase:Count()
  for i = 1, BlueBasecount do
    local grpObj = BlueBase:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end

BlueBase=SET_GROUP:New():FilterPrefixes("bSAM-BASECAP#"):FilterActive(true):FilterOnce()

local BlueBasecount=BlueBase:Count()
  for i = 1, BlueBasecount do
    local grpObj = BlueBase:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end
  
BlueBase=SET_GROUP:New():FilterPrefixes("bSAM-BASECAP#"):FilterActive(true):FilterOnce()

local BlueBasecount=BlueBase:Count()
  for i = 1, BlueBasecount do
    local grpObj = BlueBase:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end 

local Blue1count=Blue1:Count()
  for i = 1, Blue1count do
    local grpObj = Blue1:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end
  
local Blue2count=Blue2:Count()
  for i = 1, Blue2count do
    local grpObj = Blue2:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end

local Blue3count=Blue3:Count()
  for i = 1, Blue3count do
    local grpObj = Blue3:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end
  
local Blue4count=Blue4:Count()
  for i = 1, Blue4count do
    local grpObj = Blue4:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end
  
local Blue5count=Blue5:Count()
  for i = 1, Blue5count do
    local grpObj = Blue5:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end
  
local Blue6count=Blue6:Count()
  for i = 1, Blue6count do
    local grpObj = Blue6:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end
  
local Blue7count=Blue7:Count()
  for i = 1, Blue7count do
    local grpObj = Blue7:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end            

local Blue8count=Blue8:Count()
  for i = 1, Blue8count do
    local grpObj = Blue8:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end
  
local Blue9count=Blue9:Count()
  for i = 1, Blue9count do
    local grpObj = Blue9:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end  

local RedBasecount=RedBase:Count()
  for i = 1, RedBasecount do
    local grpObj = RedBase:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end

local Red1count=Red1:Count()
  for i = 1, Red1count do
    local grpObj = Red1:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end
  
local Red2count=Red2:Count()
  for i = 1, Red2count do
    local grpObj = Red2:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end

local Red3count=Red3:Count()
  for i = 1, Red3count do
    local grpObj = Red3:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end
  
local Red4count=Red4:Count()
  for i = 1, Red4count do
    local grpObj = Red4:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end
  
local Red5count=Red5:Count()
  for i = 1, Red5count do
    local grpObj = Red5:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end
  
local Red6count=Red6:Count()
  for i = 1, Red6count do
    local grpObj = Red6:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end
  
local Red7count=Red7:Count()
  for i = 1, Red7count do
    local grpObj = Red7:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end            

local Red8count=Red8:Count()
  for i = 1, Red8count do
    local grpObj = Red8:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end
  
local Red9count=Red9:Count()
  for i = 1, Red9count do
    local grpObj = Red9:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end  

local DownedPilotcount=DownedPilot:Count()
  for i = 1, DownedPilotcount do
    local grpObj = DownedPilot:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end

local Cratescount=Crates:Count()
  for i = 1, Cratescount do
    local grpObj = Crates:GetRandom()
    --env.info(grpObj:GetName())
    grpObj:Destroy(true)
  end

env.info("Unit Sanitize Complete", false)
