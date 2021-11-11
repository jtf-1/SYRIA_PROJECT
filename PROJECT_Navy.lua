env.info("Navy Loading", false)

--////CARRIER GROUP PATROL ROUTE
--////Set Carrier Group To Patrol Waypoints Indefinately
--[[
if ( Group.getByName("CVN-71 Theodore Roosevelt") ) then
GROUP:FindByName("CVN-71 Theodore Roosevelt"):PatrolRoute()
end

if ( Group.getByName("LHA-1") ) then
GROUP:FindByName("LHA-1"):PatrolRoute()
end
]]--
if ( Group.getByName("Tripoli-Sub") ) then
GROUP:FindByName("Tripoli-Sub"):PatrolRoute()
end

if ( Group.getByName("Tartus-Speedboats") ) then
GROUP:FindByName("Tartus-Speedboats"):PatrolRoute()
end

if ( Group.getByName("Latakia - Navy") ) then
	GROUP:FindByName("Latakia - Navy"):PatrolRoute()
end

if ( Group.getByName("Tartus - Navy") ) then
	GROUP:FindByName("Tartus - Navy"):PatrolRoute()
end

--[[
function SpawnSupport (SupportSpawn) -- spawnobject, spawnzone

  --local SupportSpawn = _args[1]
  local SupportSpawnObject = SPAWN:New( SupportSpawn.spawnobject )
    
  SupportSpawnObject:InitLimit( 1, 50 )
  
    :OnSpawnGroup(
      function ( SpawnGroup )
        local SpawnIndex = SupportSpawnObject:GetSpawnIndexFromGroup( SpawnGroup )
        local CheckTanker = SCHEDULER:New( nil, 
        function ()
      if SpawnGroup then
        if SpawnGroup:IsNotInZone( SupportSpawn.spawnzone ) then
          SupportSpawnObject:ReSpawn( SpawnIndex )
        end
      end
        end,
        {}, 0, 60 )
      end
    )
    :InitRepeatOnLanding()
    :Spawn()

end -- function
]]--
-------------------------------------------------------------------------------------------

---------------------
-- RECOVERY TANKER --
---------------------

local ArcoRoosevelt=RECOVERYTANKER:New(UNIT:FindByName("CVN-71 Theodore Roosevelt"), "Tanker_S3-B_Arco1")
ArcoRoosevelt:SetTakeoffAir()
ArcoRoosevelt:SetTACAN(106, "ARC")
ArcoRoosevelt:SetRadio(251.500, "AM")
ArcoRoosevelt:SetCallsign(2,1)
ArcoRoosevelt:Start()

---------------------
    -- CARRIER --
---------------------

local airbossRoosevelt=AIRBOSS:New("CVN-71 Theodore Roosevelt")
airbossRoosevelt:SetSoundfilesFolder("Airboss Soundfiles/")
airbossRoosevelt:SetVoiceOversLSOByRaynor()
airbossRoosevelt:SetVoiceOversMarshalByRaynor()
airbossRoosevelt:SetRespawnAI(true)
airbossRoosevelt:SetStaticWeather(true)
airbossRoosevelt:SetRecoveryTanker(ArcoRoosevelt)
airbossRoosevelt:SetTACAN(71, "X", "RSV")
airbossRoosevelt:SetICLS(1, "RSV")
airbossRoosevelt:SetBeaconRefresh(300)
airbossRoosevelt:SetLSORadio(308.475, AM)
airbossRoosevelt:SetMarshalRadio(285.675, AM)
airbossRoosevelt:SetCarrierControlledArea(50)
airbossRoosevelt:SetCarrierControlledZone(10)
airbossRoosevelt:SetCollisionDistance(10)
--[[
airbossRoosevelt:AddRecoveryWindow("23:15", "23:45", 3, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("00:15", "00:45", 3, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("01:15", "01:45", 3, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("02:15", "02:45", 3, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("03:15", "03:45", 3, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("04:15", "04:45", 3, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("05:15", "05:45", 3, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("06:15", "06:45", 1, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("07:15", "07:45", 1, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("08:15", "08:45", 1, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("09:15", "09:45", 1, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("10:15", "10:45", 1, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("11:15", "11:45", 1, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("12:15", "12:45", 1, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("13:15", "13:45", 1, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("14:15", "14:45", 1, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("15:15", "15:45", 1, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("16:15", "16:45", 1, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("17:15", "17:45", 1, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("18:15", "18:45", 1, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("19:15", "19:45", 1, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("20:15", "20:45", 3, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("21:15", "21:45", 3, nil, true, 30)
airbossRoosevelt:AddRecoveryWindow("22:15", "22:45", 3, nil, true, 30)
]]--
airbossRoosevelt:SetPatrolAdInfinitum(true)
airbossRoosevelt:SetDefaultPlayerSkill("Flight Student")
airbossRoosevelt:SetWelcomePlayers(false)
airbossRoosevelt:SetMenuSmokeZones(false)
airbossRoosevelt:SetMenuMarkZones(false)
airbossRoosevelt:SetMenuRecovery(45, 30, true, 30)
airbossRoosevelt:SetAirbossNiceGuy(true)
airbossRoosevelt:Load(nil, "Syria_Roosevelt_LSOgrades.csv")
airbossRoosevelt:SetAutoSave(nil, "Syria_Roosevelt_LSOgrades.csv")

--airbossRoosevelt:SetDebugModeON()
--airbossRoosevelt:TraceOnOff(true)
--airbossRoosevelt:TraceLevel(3)
--airbossRoosevelt:TraceClass("AIRBOSS")

airbossRoosevelt:Start()

---------------------
    -- TARAWA --
---------------------

local airbossTarawa=AIRBOSS:New("LHA-1")
airbossTarawa:SetSoundfilesFolder("Airboss Soundfiles/")
airbossTarawa:SetVoiceOversLSOByRaynor()
airbossTarawa:SetVoiceOversMarshalByRaynor()
airbossTarawa:SetRespawnAI(true)
airbossTarawa:SetStaticWeather(true)
--airbossTarawa:SetRecoveryTanker(ArcoRoosevelt)
airbossTarawa:SetTACAN(1, "X", "LHA")
airbossTarawa:SetICLS(2, "LHA")
airbossTarawa:SetBeaconRefresh(300)
airbossTarawa:SetLSORadio(255.725, AM)
airbossTarawa:SetMarshalRadio(285.675, AM)
airbossTarawa:SetCarrierControlledArea(50)
airbossTarawa:SetCarrierControlledZone(10)
airbossTarawa:SetCollisionDistance(10)
--[[
airbossTarawa:AddRecoveryWindow("23:15", "23:45", 3, nil, true, 30)
airbossTarawa:AddRecoveryWindow("00:15", "00:45", 3, nil, true, 30)
airbossTarawa:AddRecoveryWindow("01:15", "01:45", 3, nil, true, 30)
airbossTarawa:AddRecoveryWindow("02:15", "02:45", 3, nil, true, 30)
airbossTarawa:AddRecoveryWindow("03:15", "03:45", 3, nil, true, 30)
airbossTarawa:AddRecoveryWindow("04:15", "04:45", 3, nil, true, 30)
airbossTarawa:AddRecoveryWindow("05:15", "05:45", 3, nil, true, 30)
airbossTarawa:AddRecoveryWindow("06:15", "06:45", 1, nil, true, 30)
airbossTarawa:AddRecoveryWindow("07:15", "07:45", 1, nil, true, 30)
airbossTarawa:AddRecoveryWindow("08:15", "08:45", 1, nil, true, 30)
airbossTarawa:AddRecoveryWindow("09:15", "09:45", 1, nil, true, 30)
airbossTarawa:AddRecoveryWindow("10:15", "10:45", 1, nil, true, 30)
airbossTarawa:AddRecoveryWindow("11:15", "11:45", 1, nil, true, 30)
airbossTarawa:AddRecoveryWindow("12:15", "12:45", 1, nil, true, 30)
airbossTarawa:AddRecoveryWindow("13:15", "13:45", 1, nil, true, 30)
airbossTarawa:AddRecoveryWindow("14:15", "14:45", 1, nil, true, 30)
airbossTarawa:AddRecoveryWindow("15:15", "15:45", 1, nil, true, 30)
airbossTarawa:AddRecoveryWindow("16:15", "16:45", 1, nil, true, 30)
airbossTarawa:AddRecoveryWindow("17:15", "17:45", 1, nil, true, 30)
airbossTarawa:AddRecoveryWindow("18:15", "18:45", 1, nil, true, 30)
airbossTarawa:AddRecoveryWindow("19:15", "19:45", 1, nil, true, 30)
airbossTarawa:AddRecoveryWindow("20:15", "20:45", 3, nil, true, 30)
airbossTarawa:AddRecoveryWindow("21:15", "21:45", 3, nil, true, 30)
airbossTarawa:AddRecoveryWindow("22:15", "22:45", 3, nil, true, 30)
]]--
airbossTarawa:SetPatrolAdInfinitum(true)
airbossTarawa:SetDefaultPlayerSkill("Flight Student")
airbossTarawa:SetWelcomePlayers(false)
airbossTarawa:SetMenuSmokeZones(false)
airbossTarawa:SetMenuMarkZones(false)
airbossTarawa:SetMenuRecovery(45, 15, true, 30)
airbossTarawa:SetAirbossNiceGuy(true)
airbossTarawa:Load(nil, "Syria_Tarawa_LSOgrades.csv")
airbossTarawa:SetAutoSave(nil, "Syria_Tarawa_LSOgrades.csv")

--airbossTarawa:SetDebugModeON()
--airbossTarawa:TraceOnOff(true)
--airbossTarawa:TraceLevel(3)
--airbossTarawa:TraceClass("AIRBOSS")

airbossTarawa:Start()


env.info("Navy Complete", false)