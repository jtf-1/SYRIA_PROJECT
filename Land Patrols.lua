EinElkorumPatrol= ZONE_POLYGON:New( "EinElkorumPatrolZone", GROUP:FindByName( "EinElkorumZone" ) )
PatrolEinElkorum = GROUP:FindByName ("Patrol - Ein_Elkorum")
PatrolEinElkorum:PatrolZones({EinElkorumPatrol}, 20, "On Road")

Lake_QaraounPatrol= ZONE_POLYGON:New( "Lake_QaraounPatrolZone", GROUP:FindByName( "Lake_QaraounZone" ) )
PatrolLake_Qaraoun = GROUP:FindByName ("Patrol - Lake_Qaraoun")
PatrolLake_Qaraoun:PatrolZones({Lake_QaraounPatrol}, 20, "On Road")
