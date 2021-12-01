env.info("ATIS Loading", false)
------------------------
-- ATIS SECTION START --
------------------------

--[[
atisIncirlik=ATIS:New(AIRBASE.Syria.Incirlik, 129.65)
atisIncirlik:SetRadioRelayUnitName("ATIS Relay - Incirlik")
atisIncirlik:SetSRS("C:\\Program~Files\\DCS-SimpleRadio-Standalone~2", "male", "en-US")
atisIncirlik:SetTACAN(21)
atisIncirlik:Start()

atisRamat_David=ATIS:New(AIRBASE.Syria.Ramat_David, 125.8)
atisRamat_David:SetRadioRelayUnitName("ATIS Relay - Ramat David")
atisRamat_David:SetSRS("C:\\Program~Files\\DCS-SimpleRadio-Standalone~2", "male", "en-US")
atisRamat_David:SetTACAN(45)
atisRamat_David:Start()

atisHaifa=ATIS:New(AIRBASE.Syria.Haifa, 135.4)
atisHaifa:SetRadioRelayUnitName("ATIS Relay - Haifa")
atisHaifa:SetSRS("C:\\Program~Files\\DCS-SimpleRadio-Standalone~2", "male", "en-US")
atisHaifa:SetTACAN(38)
atisHaifa:Start()
]]--

atisAkrotiri=ATIS:New("Akrotiri", 125, radio.modulation.AM)
atisAkrotiri:SetTACAN(107)
atisAkrotiri:AddILS(109.70,28)
atisAkrotiri:SetTowerFrequencies(128,4.625,40.15,251.7)
atisAkrotiri:SetSRS("C:\\Program Files\\DCS-SimpleRadio-Standalone3", "male", "en-US")
atisAkrotiri:Start()

env.info("ATIS Complete", false)