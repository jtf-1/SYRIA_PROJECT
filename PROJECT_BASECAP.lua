env.info("BASECAP Loading", false)


function SEF_BASECAP_REMOVE ()
  env.info("BASECAP Remove Starting", false)
  
  BlueBaseCAP=SET_GROUP:New():FilterPrefixes("bSAM-BASECAP#"):FilterActive(true):FilterOnce()
  BluebSAM1=SET_GROUP:New():FilterPrefixes("bSAM-1"):FilterActive(true):FilterOnce() 
  BluebSAM2=SET_GROUP:New():FilterPrefixes("bSAM-2"):FilterActive(true):FilterOnce()
  Crates=SET_STATIC:New():FilterPrefixes("Cargo Static Group"):FilterOnce()
   
  
  --All=SET_GROUP:New():FilterActive(true):FilterStart()
  
  --=====================================================================================
  
  local BlueBaseCAPcount=BlueBaseCAP:Count()
    for i = 1, BlueBaseCAPcount do
      local grpObj = BlueBaseCAP:GetRandom()
      --env.info(grpObj:GetName())
      grpObj:Destroy(true)
    end
   
  BlueBaseCAP=SET_GROUP:New():FilterPrefixes("bSAM-BASECAP#"):FilterActive(true):FilterOnce()
    
  local BlueBaseCAPcount=BlueBaseCAP:Count()
    for i = 1, BlueBaseCAPcount do
      local grpObj = BlueBaseCAP:GetRandom()
      --env.info(grpObj:GetName())
      grpObj:Destroy(true)
    end    
   
  local BluebSAM1count=BluebSAM1:Count()
    for i = 1, BluebSAM1count do
      local grpObj = BluebSAM1:GetRandom()
      --env.info(grpObj:GetName())
      grpObj:Destroy(true)
    end 
    
  local BluebSAM2count=BluebSAM2:Count()
    for i = 1, BluebSAM2count do
      local grpObj = BluebSAM2:GetRandom()
      --env.info(grpObj:GetName())
      grpObj:Destroy(true)
    end   
     
    local Cratescount=Crates:Count()
    for i = 1, Cratescount do
      local grpObj = Crates:GetRandom()
      --env.info(grpObj:GetName())
      grpObj:Destroy(true)
    end
         
  timer.scheduleFunction(SEF_BASECAP_REMOVE, nil, timer.getTime() + 7200)
  env.info("BASECAP Remove Complete", false)
end

function SEF_BASECAP_RESPAWN ()
  env.info("BASECAP Repawn Starting", false)
     if file_exists("SyriaAirbases.lua") then

    dofile("SyriaAirbases.lua")
  
    AirbaseTableLength = SEF_GetTableLength(SyriaAirbases)
  
    for i = 1, AirbaseTableLength do
     BaseName = SyriaAirbases[i].Airbase
     BaseCoalition = SyriaAirbases[i].Coalition
    
     if ( BaseCoalition == 1) then
     elseif ( BaseCoalition == 2 ) then      
      SEF_CAPAIRBASE(BaseName, 2)  
      else      
      end
    end
  else
    SyriaAirbases = {}
    AirbaseTableLength = 0
  end
  env.info("BASECAP Respawn Complete", false) 
  timer.scheduleFunction(SEF_BASECAP_RESPAWN, nil, timer.getTime() + 7200)
end
  
timer.scheduleFunction(SEF_BASECAP_REMOVE, nil, timer.getTime() + 15)
timer.scheduleFunction(SEF_BASECAP_RESPAWN, nil, timer.getTime() + 20)

env.info("BASECAP Complete", false)

