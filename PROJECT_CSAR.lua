env.info("CSAR Loading", false)

-- Instantiate and start a CSAR for the blue side, with template "Downed Pilot" and alias "Luftrettung"
   local syria_csar = CSAR:New(coalition.side.BLUE,"Downed Pilot","Downed Pilot")
   -- options
   syria_csar.allowDownedPilotCAcontrol = false -- Set to false if you don\'t want to allow control by Combined Arms.
   syria_csar.allowFARPRescue = true -- allows pilots to be rescued by landing at a FARP or Airbase. Else MASH only!
   syria_csar.autosmoke = true -- automatically smoke a downed pilot\'s location when a heli is near.
   syria_csar.autosmokedistance = 1000 -- distance for autosmoke
   syria_csar.coordtype = 1 -- Use Lat/Long DDM (0), Lat/Long DMS (1), MGRS (2), Bullseye imperial (3) or Bullseye metric (4) for coordinates.
   syria_csar.csarOncrash = true -- (WIP) If set to true, will generate a downed pilot when a plane crashes as well.
   syria_csar.enableForAI = false -- set to false to disable AI pilots from being rescued.
   syria_csar.pilotRuntoExtractPoint = true -- Downed pilot will run to the rescue helicopter up to syria_csar.extractDistance in meters. 
   syria_csar.extractDistance = 500 -- Distance the downed pilot will start to run to the rescue helicopter.
   syria_csar.immortalcrew = true -- Set to true to make wounded crew immortal.
   syria_csar.invisiblecrew = false -- Set to true to make wounded crew insvisible.
   syria_csar.loadDistance = 75 -- configure distance for pilots to get into helicopter in meters.
   syria_csar.mashprefix = {"MASH"} -- prefixes of #GROUP objects used as MASHes.
   syria_csar.max_units = 6 -- max number of pilots that can be carried if #CSAR.AircraftType is undefined.
   syria_csar.messageTime = 15 -- Time to show messages for in seconds. Doubled for long messages.
   syria_csar.radioSound = "beacon.ogg" -- the name of the sound file to use for the pilots\' radio beacons. 
   syria_csar.smokecolor = 4 -- Color of smokemarker, 0 is green, 1 is red, 2 is white, 3 is orange and 4 is blue.
   syria_csar.useprefix = true  -- Requires CSAR helicopter #GROUP names to have the prefix(es) defined below.
   syria_csar.csarPrefix = { "helicargo", "MEDEVAC", "zz"} -- #GROUP name prefixes used for useprefix=true - DO NOT use # in helicopter names in the Mission Editor! 
   syria_csar.verbose = 0 -- set to > 1 for stats output for debugging.
   -- (added 0.1.4) limit amount of downed pilots spawned by **ejection** events
   syria_csar.limitmaxdownedpilots = true
   syria_csar.maxdownedpilots = 10 
   -- (added 0.1.8) - allow to set far/near distance for approach and optionally pilot must open doors
   syria_csar.approachdist_far = 5000 -- switch do 10 sec interval approach mode, meters
   syria_csar.approachdist_near = 3000 -- switch to 5 sec interval approach mode, meters
   syria_csar.pilotmustopendoors = false -- switch to true to enable check of open doors
   -- start the FSM
   syria_csar:__Start(5)

env.info("CSAR Complete", false)