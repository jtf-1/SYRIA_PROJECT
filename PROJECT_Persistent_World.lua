env.info("Persistent World Loading", false)

----------------------------------------------------------
SaveScheduleUnits = 300 --Seconds between each table write
----------------------------------------------------------
  
function IntegratedbasicSerialize(s)
    if s == nil then
    return "\"\""
    else
    if ((type(s) == 'number') or (type(s) == 'boolean') or (type(s) == 'function') or (type(s) == 'table') or (type(s) == 'userdata') ) then
      return tostring(s)
    elseif type(s) == 'string' then
      return string.format('%q', s)
    end
    end
end
  
-- imported slmod.serializeWithCycles (Speed)
function IntegratedserializeWithCycles(name, value, saved)
    local basicSerialize = function (o)
    if type(o) == "number" then
      return tostring(o)
    elseif type(o) == "boolean" then
      return tostring(o)
    else -- assume it is a string
      return IntegratedbasicSerialize(o)
    end
  end

    local t_str = {}
    saved = saved or {}       -- initial value
    if ((type(value) == 'string') or (type(value) == 'number') or (type(value) == 'table') or (type(value) == 'boolean')) then
    table.insert(t_str, name .. " = ")
      if type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
        table.insert(t_str, basicSerialize(value) ..  "\n")
      else
        if saved[value] then    -- value already saved?
          table.insert(t_str, saved[value] .. "\n")
        else
          saved[value] = name   -- save name for next time
          table.insert(t_str, "{}\n")
            for k,v in pairs(value) do      -- save its fields
              local fieldname = string.format("%s[%s]", name, basicSerialize(k))
              table.insert(t_str, IntegratedserializeWithCycles(fieldname, v, saved))
            end
        end
      end
    return table.concat(t_str)
    else
    return ""
    end
end

function file_exists(name) --check if the file already exists for writing
  if lfs.attributes(name) then
    return true
    else
    return false end 
end

function writemission(data, file)--Function for saving to file (commonly found)
  File = io.open(file, "w")
  File:write(data)
  File:close()
end

function SEF_GetTableLength(Table)
  local TableLengthCount = 0
  for _ in pairs(Table) do TableLengthCount = TableLengthCount + 1 end
  return TableLengthCount
end

--////SAVE FUNCTION FOR UNITS
--[[
function SEF_SaveUnitIntermentTable(timeloop, time)
  IntermentMissionStr = IntegratedserializeWithCycles("SyriaUnitInterment", SyriaUnitInterment)
  writemission(IntermentMissionStr, "SyriaUnitInterment.lua")
  --trigger.action.outText("Progress Has Been Saved", 15) 
  return time + SaveScheduleUnits
end

function SEF_SaveUnitIntermentTableNoArgs()
  IntermentMissionStr = IntegratedserializeWithCycles("SyriaUnitInterment", SyriaUnitInterment)
  writemission(IntermentMissionStr, "SyriaUnitInterment.lua")   
end

--////SAVE FUNCTION FOR STATICS
function SEF_SaveStaticIntermentTable(timeloop, time)
  IntermentMissionStrStatic = IntegratedserializeWithCycles("SyriaStaticInterment", SyriaStaticInterment)
  writemission(IntermentMissionStrStatic, "SyriaStaticInterment.lua")
  --trigger.action.outText("Progress Has Been Saved", 15) 
  return time + SaveScheduleUnits
end

function SEF_SaveStaticIntermentTableNoArgs()
  IntermentMissionStrStatic = IntegratedserializeWithCycles("SyriaStaticInterment", SyriaStaticInterment)
  writemission(IntermentMissionStrStatic, "SyriaStaticInterment.lua") 
end
]]--

function SEF_SaveAirbasesTable(timeloop, time)
  SEF_PERSISTENTAIRBASES(PersistentAirbases)
  AirbaseStr = IntegratedserializeWithCycles("SyriaAirbases", SyriaAirbases)
  writemission(AirbaseStr, "SyriaAirbases.lua")
  return time + SaveScheduleUnits
end

function SEF_SaveAirbasesTableNoArgs()
  SEF_PERSISTENTAIRBASES(PersistentAirbases)
  AirbaseStr = IntegratedserializeWithCycles("SyriaAirbases", SyriaAirbases)
  writemission(AirbaseStr, "SyriaAirbases.lua") 
end

PersistentAirbases = {

  "Al-Dumayr",
  "Al Qusayr",
  "An Nasiriyah",
  "Beirut-Rafic Hariri",
  "Damascus",
  "Eyn Shemer",
  "H4",
  "Haifa",
  "King Hussein Air College",
  "Kiryat Shmona",
  "Khalkhalah",
  "Marj as Sultan North",
  "Marj as Sultan South",
  "Marj Ruhayyil",
  "Megiddo",
  "Mezzeh",
  "Naqoura",
  "Palmyra",
  "Qabr as Sitt",
  "Ramat David",
  "Rayak",
  "Rene Mouawad",
  "Rosh Pina",
  "Sayqal",
  "Shayrat",
  "Tiyas",
  "Tha'lah",
  "Wujah Al Hajar"
}

REDCAPTURELIST = { "rSAM-BASECAP",
"rSAM-BASECAP2",
"rSAM-BASECAP3",
"rSAM-BASECAP4",
"rSAM-BASECAP5"
}
REDCAPTURETEAM = SPAWN:New("rSAM-BASECAP")
--REDCAPTURETEAM = SPAWN:InitRandomizeTemplate(REDCAPTURELIST)
REDCAPNAME = "rSAM-BASECAP"
BLUECAPTURETEAM = SPAWN:New("bSAM-BASECAP")
BLUELOGISTICS = SPAWNSTATIC:NewFromStatic( "logistic", country.id.USA ):InitNamePrefix("logistic")

function SEF_PERSISTENTAIRBASES(AirbaseList)
  SyriaAirbases = {}
  
  for i, ab in ipairs(AirbaseList) do
    local AirbaseObject = Airbase.getByName(ab)
    local AirbaseCoalition = AirbaseObject:getCoalition()
    
    TempAirbaseTable = {
      ["Airbase"]=ab,
      ["Coalition"]=AirbaseCoalition
    }
    table.insert(SyriaAirbases, TempAirbaseTable )      
  end 
end

function SEF_CAPAIRBASE(Airbase, Coalition)
  
  if ( Coalition == 1 ) then
    RedHeloSpawnVec2 = ZONE:FindByName(Airbase.." LZ Red"):GetVec2()
        REDCAPTURETEAM:InitRandomizeTemplate(REDCAPTURELIST):SpawnFromVec2(RedHeloSpawnVec2)  
  elseif ( Coalition == 2 ) then
    BlueHeloSpawnVec2 = ZONE:FindByName(Airbase.." LZ Blue"):GetVec2()
    BLUECAPTURETEAM:SpawnFromVec2(BlueHeloSpawnVec2)    
    local BlueLogiSpawn = ZONE:FindByName(Airbase.." pickzone")
    local logi = BLUELOGISTICS:SpawnFromZone(BlueLogiSpawn, 0)
    BlueLogiSpawn:Scan( {Object.Category.STATIC} , {Unit.Category.GROUND_UNIT} )
    BASE:E(BlueLogiSpawn.ScanData)
  else
  end
end


--[[
function SEF_CAPAIRBASE(Airbase, Coalition)
  
  if ( Coalition == 1 ) then
    RedHeloSpawnVec2 = ZONE:FindByName(Airbase.." LZ Red"):GetVec2()
    REDCAPTURETEAM:SpawnFromVec2(RedHeloSpawnVec2)  
  elseif ( Coalition == 2 ) then
    BlueHeloSpawnVec2 = ZONE:FindByName(Airbase.." LZ Blue"):GetVec2()
    BLUECAPTURETEAM:SpawnFromVec2(BlueHeloSpawnVec2)    
  else
  end
end

]]--
-------------------------------------------------------------------------------------------------------------------------------------
--////MAIN

SEFDeletedUnitCount = 0
SEFDeletedStaticCount = 0

--////LOAD AIRBASES
if file_exists("SyriaAirbases.lua") then

  dofile("SyriaAirbases.lua")
  
  AirbaseTableLength = SEF_GetTableLength(SyriaAirbases)
  
  for i = 1, AirbaseTableLength do
    BaseName = SyriaAirbases[i].Airbase
    BaseCoalition = SyriaAirbases[i].Coalition
    
    if ( BaseCoalition == 1) then     
      SEF_CAPAIRBASE(BaseName, 1)
    elseif ( BaseCoalition == 2 ) then      
      SEF_CAPAIRBASE(BaseName, 2)
      
    else      
    end
  end
else
  SyriaAirbases = {}
  AirbaseTableLength = 0
end

---------------------------------------------------------------------------------------------------------------------------------------------------

--SCHEDULE

timer.scheduleFunction(SEF_SaveAirbasesTable, 53, timer.getTime() + (SaveScheduleUnits + 5))

---------------------------------------------------------------------------------------------------------------------------------------------------
env.info("Persistent World Complete", false)
