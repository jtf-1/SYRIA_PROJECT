------------------------
-- ATIS SECTION START --
------------------------
--
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