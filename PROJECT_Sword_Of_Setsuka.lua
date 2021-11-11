env.info("Sword of Setsuke Loading", false)

--[[
	USAFAWACSGROUPNAME
	TEXACOGROUPNAME
	SHELLGROUPNAME
	ARCOGROUPNAME
	
	REDSQUADRON1GROUPNAME
	REDSQUADRON2GROUPNAME
	REDSQUADRON3GROUPNAME
	REDSQUADRON4GROUPNAME
	REDSQUADRON5GROUPNAME
	BLUESQUADRON1GROUPNAME
	BLUESQUADRON2GROUPNAME
	BLUESQUADRON3GROUPNAME
	BLUESQUADRON4GROUPNAME
	BLUESQUADRON4GROUPNAME
	
	USAEFCAPGROUPNAME
	USAEFSEADGROUPNAME
	USAEFCASGROUPNAME
	USAEFASSGROUPNAME
	USAEFPINGROUPNAME
	USAEFDRONEGROUPNAME
	
	SYAAFAN26BGROUPNAME
	IRIAFMI8GROUPNAME
	USAFC130GROUPNAME
	USAFUH60AGROUPNAME
	SYAAFSU24MGROUPNAME
	VVSSU25TGROUPNAME
	VVSTU95MSGROUPNAME
	VVSTU160GROUPNAME
	VVSTU22M3GROUPNAME
	
	27 Elements
]]--

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--////FUNCTIONS

function SEF_SetukasSword()

	env.info("Setsuka's Sword - Monitoring For Inactivity", false)
--[[
	--////AWACS
	if ( GROUP:FindByName(AWACS_MAGIC) ~= nil and GROUP:FindByName(AWACS_MAGIC):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(AWACS_MAGIC):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( AWACS_MAGIC_DATA[UnitID].Vec2 ~= nil and AWACS_MAGIC_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if AWACS_MAGIC_DATA[UnitID].Vec2.x == NewVec2.x and AWACS_MAGIC_DATA[UnitID].Vec2.y == NewVec2.y then
						if AWACS_MAGIC_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("AWACS Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							AWACS_MAGIC_DATA[UnitID].Vec2 = nil
							AWACS_MAGIC_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						AWACS_MAGIC_DATA[UnitID].TimeStamp = timer.getTime()
						AWACS_MAGIC_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					AWACS_MAGIC_DATA[UnitID].Vec2 = nil
					AWACS_MAGIC_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then						
						AWACS_MAGIC_DATA[UnitID].TimeStamp = timer.getTime()
						AWACS_MAGIC_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						AWACS_MAGIC_DATA[UnitID].TimeStamp = nil
						AWACS_MAGIC_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					AWACS_MAGIC_DATA[UnitID].TimeStamp = nil
					AWACS_MAGIC_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////AWACS NOT ALIVE SCRUB DATA
	else
		AWACS_MAGIC_DATA[1].Vec2 = nil
		AWACS_MAGIC_DATA[1].TimeStamp = nil		
	end
		
	--////TEXACO
	if ( GROUP:FindByName(AWACS_DARKSTAR) ~= nil and GROUP:FindByName(AWACS_DARKSTAR):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(AWACS_DARKSTAR):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( AWACS_DARKSTAR_DATA[UnitID].Vec2 ~= nil and AWACS_DARKSTAR_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if AWACS_DARKSTAR_DATA[UnitID].Vec2.x == NewVec2.x and AWACS_DARKSTAR_DATA[UnitID].Vec2.y == NewVec2.y then
						if AWACS_DARKSTAR_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("TEXACO Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							AWACS_DARKSTAR_DATA[UnitID].Vec2 = nil
							AWACS_DARKSTAR_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						AWACS_DARKSTAR_DATA[UnitID].TimeStamp = timer.getTime()
						AWACS_DARKSTAR_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					AWACS_DARKSTAR_DATA[UnitID].Vec2 = nil
					AWACS_DARKSTAR_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						AWACS_DARKSTAR_DATA[UnitID].TimeStamp = timer.getTime()
						AWACS_DARKSTAR_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						AWACS_DARKSTAR_DATA[UnitID].TimeStamp = nil
						AWACS_DARKSTAR_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					AWACS_DARKSTAR_DATA[UnitID].TimeStamp = nil
					AWACS_DARKSTAR_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////TEXACO NOT ALIVE SCRUB DATA
	else
		AWACS_DARKSTAR_DATA[1].Vec2 = nil
		AWACS_DARKSTAR_DATA[1].TimeStamp = nil		
	end
	
	--////SHELL
	if ( GROUP:FindByName(SHELLGROUPNAME) ~= nil and GROUP:FindByName(SHELLGROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(SHELLGROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( SHELL_DATA[UnitID].Vec2 ~= nil and SHELL_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if SHELL_DATA[UnitID].Vec2.x == NewVec2.x and SHELL_DATA[UnitID].Vec2.y == NewVec2.y then
						if SHELL_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("SHELL Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							SHELL_DATA[UnitID].Vec2 = nil
							SHELL_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						SHELL_DATA[UnitID].TimeStamp = timer.getTime()
						SHELL_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					SHELL_DATA[UnitID].Vec2 = nil
					SHELL_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						SHELL_DATA[UnitID].TimeStamp = timer.getTime()
						SHELL_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						SHELL_DATA[UnitID].TimeStamp = nil
						SHELL_DATA[UnitID].Vec2 = nil	
					end
				--////In Air
				else
					SHELL_DATA[UnitID].TimeStamp = nil
					SHELL_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////SHELL NOT ALIVE SCRUB DATA
	else
		SHELL_DATA[1].Vec2 = nil
		SHELL_DATA[1].TimeStamp = nil		
	end

	--////ARCO
	if ( GROUP:FindByName(ARCOGROUPNAME) ~= nil and GROUP:FindByName(ARCOGROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(ARCOGROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( ARCO_DATA[UnitID].Vec2 ~= nil and ARCO_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if ARCO_DATA[UnitID].Vec2.x == NewVec2.x and ARCO_DATA[UnitID].Vec2.y == NewVec2.y then
						if ARCO_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("ARCO Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							ARCO_DATA[UnitID].Vec2 = nil
							ARCO_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						ARCO_DATA[UnitID].TimeStamp = timer.getTime()
						ARCO_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////On Carrier Deck And Stationary - Special For Carrier Planes, Don't Base On Vec Point Just Check Speed, Altitude And Timestamp
				elseif (SpawnUnit:InAir() == false and (string.find(SpawnUnitName, "22nd ARW Arco"))) then
					if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 19 and SpawnUnit:GetAltitude() < 25 )) then 
						if ARCO_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then																		
							env.info("ARCO Monitor - Deleting Navy Unit: "..SpawnUnitName.." Due To Inactivity", false)
							ARCO_DATA[UnitID].Vec2 = nil
							ARCO_DATA[UnitID].TimeStamp = nil						
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						ARCO_DATA[UnitID].TimeStamp = timer.getTime()
						ARCO_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()					
					end			
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					ARCO_DATA[UnitID].Vec2 = nil
					ARCO_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						ARCO_DATA[UnitID].TimeStamp = timer.getTime()
						ARCO_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					--Special for Carrier Planes
					elseif (string.find(SpawnUnitName, "22nd ARW Arco")) then
						if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 19 and SpawnUnit:GetAltitude() < 25 )) then
							ARCO_DATA[UnitID].TimeStamp = timer.getTime()
							ARCO_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
						end					
					else
						ARCO_DATA[UnitID].TimeStamp = nil
						ARCO_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					ARCO_DATA[UnitID].TimeStamp = nil
					ARCO_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////ARCO NOT ALIVE SCRUB DATA
	else
		ARCO_DATA[1].Vec2 = nil
		ARCO_DATA[1].TimeStamp = nil		
	end
	]]--
--[[
	--////RED SQUADRON 1
	if ( GROUP:FindByName(REDSQUADRON1GROUPNAME) ~= nil and GROUP:FindByName(REDSQUADRON1GROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(REDSQUADRON1GROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( REDSQUADRON1_DATA[UnitID].Vec2 ~= nil and REDSQUADRON1_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if REDSQUADRON1_DATA[UnitID].Vec2.x == NewVec2.x and REDSQUADRON1_DATA[UnitID].Vec2.y == NewVec2.y then
						if REDSQUADRON1_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("REDSQUADRON1 Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							REDSQUADRON1_DATA[UnitID].Vec2 = nil
							REDSQUADRON1_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						REDSQUADRON1_DATA[UnitID].TimeStamp = timer.getTime()
						REDSQUADRON1_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////On Carrier Deck And Stationary - Special For Carrier Planes, Don't Base On Vec Point Just Check Speed, Altitude And Timestamp
				elseif (SpawnUnit:InAir() == false and (string.find(SpawnUnitName, "Alpha"))) then
					if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 15 and SpawnUnit:GetAltitude() < 25 )) then 
						if REDSQUADRON1_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then																		
							env.info("REDSQUADRON1 Monitor - Deleting Navy Unit: "..SpawnUnitName.." Due To Inactivity", false)
							REDSQUADRON1_DATA[UnitID].Vec2 = nil
							REDSQUADRON1_DATA[UnitID].TimeStamp = nil						
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						REDSQUADRON1_DATA[UnitID].TimeStamp = timer.getTime()
						REDSQUADRON1_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()					
					end			
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					REDSQUADRON1_DATA[UnitID].Vec2 = nil
					REDSQUADRON1_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						REDSQUADRON1_DATA[UnitID].TimeStamp = timer.getTime()
						REDSQUADRON1_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					--Special for Carrier Planes
					elseif (string.find(SpawnUnitName, "Alpha")) then
						if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 15 and SpawnUnit:GetAltitude() < 25 )) then
							REDSQUADRON1_DATA[UnitID].TimeStamp = timer.getTime()
							REDSQUADRON1_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
						end					
					else
						REDSQUADRON1_DATA[UnitID].TimeStamp = nil
						REDSQUADRON1_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					REDSQUADRON1_DATA[UnitID].TimeStamp = nil
					REDSQUADRON1_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////REDSQUADRON1 NOT ALIVE SCRUB DATA
	else
		REDSQUADRON1_DATA[1].Vec2 = nil
		REDSQUADRON1_DATA[1].TimeStamp = nil
		REDSQUADRON1_DATA[2].Vec2 = nil
		REDSQUADRON1_DATA[2].TimeStamp = nil	
	end	
	
	--////RED SQUADRON 2
	if ( GROUP:FindByName(REDSQUADRON2GROUPNAME) ~= nil and GROUP:FindByName(REDSQUADRON2GROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(REDSQUADRON2GROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( REDSQUADRON2_DATA[UnitID].Vec2 ~= nil and REDSQUADRON2_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if REDSQUADRON2_DATA[UnitID].Vec2.x == NewVec2.x and REDSQUADRON2_DATA[UnitID].Vec2.y == NewVec2.y then
						if REDSQUADRON2_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("REDSQUADRON2 Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							REDSQUADRON2_DATA[UnitID].Vec2 = nil
							REDSQUADRON2_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						REDSQUADRON2_DATA[UnitID].TimeStamp = timer.getTime()
						REDSQUADRON2_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////On Carrier Deck And Stationary - Special For Carrier Planes, Don't Base On Vec Point Just Check Speed, Altitude And Timestamp
				elseif (SpawnUnit:InAir() == false and (string.find(SpawnUnitName, "Beta"))) then
					if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 15 and SpawnUnit:GetAltitude() < 25 )) then 
						if REDSQUADRON2_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then																		
							env.info("REDSQUADRON2 Monitor - Deleting Navy Unit: "..SpawnUnitName.." Due To Inactivity", false)
							REDSQUADRON2_DATA[UnitID].Vec2 = nil
							REDSQUADRON2_DATA[UnitID].TimeStamp = nil						
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						REDSQUADRON2_DATA[UnitID].TimeStamp = timer.getTime()
						REDSQUADRON2_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()					
					end			
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					REDSQUADRON2_DATA[UnitID].Vec2 = nil
					REDSQUADRON2_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						REDSQUADRON2_DATA[UnitID].TimeStamp = timer.getTime()
						REDSQUADRON2_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					--Special for Carrier Planes
					elseif (string.find(SpawnUnitName, "Beta")) then
						if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 15 and SpawnUnit:GetAltitude() < 25 )) then
							REDSQUADRON2_DATA[UnitID].TimeStamp = timer.getTime()
							REDSQUADRON2_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
						end					
					else
						REDSQUADRON2_DATA[UnitID].TimeStamp = nil
						REDSQUADRON2_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					REDSQUADRON2_DATA[UnitID].TimeStamp = nil
					REDSQUADRON2_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////REDSQUADRON2 NOT ALIVE SCRUB DATA
	else
		REDSQUADRON2_DATA[1].Vec2 = nil
		REDSQUADRON2_DATA[1].TimeStamp = nil
		REDSQUADRON2_DATA[2].Vec2 = nil
		REDSQUADRON2_DATA[2].TimeStamp = nil		
	end
]]--	
	--////RED SQUADRON 3
	if ( GROUP:FindByName(REDSQUADRON3GROUPNAME) ~= nil and GROUP:FindByName(REDSQUADRON3GROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(REDSQUADRON3GROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( REDSQUADRON3_DATA[UnitID].Vec2 ~= nil and REDSQUADRON3_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if REDSQUADRON3_DATA[UnitID].Vec2.x == NewVec2.x and REDSQUADRON3_DATA[UnitID].Vec2.y == NewVec2.y then
						if REDSQUADRON3_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("REDSQUADRON3 Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							REDSQUADRON3_DATA[UnitID].Vec2 = nil
							REDSQUADRON3_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						REDSQUADRON3_DATA[UnitID].TimeStamp = timer.getTime()
						REDSQUADRON3_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////On Carrier Deck And Stationary - Special For Carrier Planes, Don't Base On Vec Point Just Check Speed, Altitude And Timestamp
				elseif (SpawnUnit:InAir() == false and (string.find(SpawnUnitName, "Gamma"))) then
					if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 15 and SpawnUnit:GetAltitude() < 25 )) then 
						if REDSQUADRON3_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then																		
							env.info("REDSQUADRON3 Monitor - Deleting Navy Unit: "..SpawnUnitName.." Due To Inactivity", false)
							REDSQUADRON3_DATA[UnitID].Vec2 = nil
							REDSQUADRON3_DATA[UnitID].TimeStamp = nil						
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						REDSQUADRON3_DATA[UnitID].TimeStamp = timer.getTime()
						REDSQUADRON3_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()					
					end			
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					REDSQUADRON3_DATA[UnitID].Vec2 = nil
					REDSQUADRON3_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						REDSQUADRON3_DATA[UnitID].TimeStamp = timer.getTime()
						REDSQUADRON3_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					--Special for Carrier Planes
					elseif (string.find(SpawnUnitName, "Gamma")) then
						if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 15 and SpawnUnit:GetAltitude() < 25 )) then
							REDSQUADRON3_DATA[UnitID].TimeStamp = timer.getTime()
							REDSQUADRON3_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
						end					
					else
						REDSQUADRON3_DATA[UnitID].TimeStamp = nil
						REDSQUADRON3_DATA[UnitID].Vec2 = nil	
					end
				--////In Air
				else
					REDSQUADRON3_DATA[UnitID].TimeStamp = nil
					REDSQUADRON3_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////REDSQUADRON3 NOT ALIVE SCRUB DATA
	else
		REDSQUADRON3_DATA[1].Vec2 = nil
		REDSQUADRON3_DATA[1].TimeStamp = nil
		REDSQUADRON3_DATA[2].Vec2 = nil
		REDSQUADRON3_DATA[2].TimeStamp = nil	
	end
	
	--////RED SQUADRON 4
	if ( GROUP:FindByName(REDSQUADRON4GROUPNAME) ~= nil and GROUP:FindByName(REDSQUADRON4GROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(REDSQUADRON4GROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( REDSQUADRON4_DATA[UnitID].Vec2 ~= nil and REDSQUADRON4_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if REDSQUADRON4_DATA[UnitID].Vec2.x == NewVec2.x and REDSQUADRON4_DATA[UnitID].Vec2.y == NewVec2.y then
						if REDSQUADRON4_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("REDSQUADRON4 Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							REDSQUADRON4_DATA[UnitID].Vec2 = nil
							REDSQUADRON4_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						REDSQUADRON4_DATA[UnitID].TimeStamp = timer.getTime()
						REDSQUADRON4_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////On Carrier Deck And Stationary - Special For Carrier Planes, Don't Base On Vec Point Just Check Speed, Altitude And Timestamp
				elseif (SpawnUnit:InAir() == false and (string.find(SpawnUnitName, "Delta"))) then
					if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 15 and SpawnUnit:GetAltitude() < 25 )) then 
						if REDSQUADRON4_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then																		
							env.info("REDSQUADRON4 Monitor - Deleting Navy Unit: "..SpawnUnitName.." Due To Inactivity", false)
							REDSQUADRON4_DATA[UnitID].Vec2 = nil
							REDSQUADRON4_DATA[UnitID].TimeStamp = nil						
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						REDSQUADRON4_DATA[UnitID].TimeStamp = timer.getTime()
						REDSQUADRON4_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()					
					end			
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					REDSQUADRON4_DATA[UnitID].Vec2 = nil
					REDSQUADRON4_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						REDSQUADRON4_DATA[UnitID].TimeStamp = timer.getTime()
						REDSQUADRON4_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					--Special for Carrier Planes
					elseif (string.find(SpawnUnitName, "Delta")) then
						if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 15 and SpawnUnit:GetAltitude() < 25 )) then
							REDSQUADRON4_DATA[UnitID].TimeStamp = timer.getTime()
							REDSQUADRON4_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
						end					
					else
						REDSQUADRON4_DATA[UnitID].TimeStamp = nil
						REDSQUADRON4_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					REDSQUADRON4_DATA[UnitID].TimeStamp = nil
					REDSQUADRON4_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////REDSQUADRON4 NOT ALIVE SCRUB DATA
	else
		REDSQUADRON4_DATA[1].Vec2 = nil
		REDSQUADRON4_DATA[1].TimeStamp = nil
		REDSQUADRON4_DATA[2].Vec2 = nil
		REDSQUADRON4_DATA[2].TimeStamp = nil	
	end
	
	--////RED SQUADRON 5
	if ( GROUP:FindByName(REDSQUADRON5GROUPNAME) ~= nil and GROUP:FindByName(REDSQUADRON5GROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(REDSQUADRON5GROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( REDSQUADRON5_DATA[UnitID].Vec2 ~= nil and REDSQUADRON5_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if REDSQUADRON5_DATA[UnitID].Vec2.x == NewVec2.x and REDSQUADRON5_DATA[UnitID].Vec2.y == NewVec2.y then
						if REDSQUADRON5_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("REDSQUADRON5 Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							REDSQUADRON5_DATA[UnitID].Vec2 = nil
							REDSQUADRON5_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						REDSQUADRON5_DATA[UnitID].TimeStamp = timer.getTime()
						REDSQUADRON5_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////On Carrier Deck And Stationary - Special For Carrier Planes, Don't Base On Vec Point Just Check Speed, Altitude And Timestamp
				elseif (SpawnUnit:InAir() == false and (string.find(SpawnUnitName, "Epsilon"))) then
					if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 15 and SpawnUnit:GetAltitude() < 25 )) then 
						if REDSQUADRON5_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then																		
							env.info("REDSQUADRON5 Monitor - Deleting Navy Unit: "..SpawnUnitName.." Due To Inactivity", false)
							REDSQUADRON5_DATA[UnitID].Vec2 = nil
							REDSQUADRON5_DATA[UnitID].TimeStamp = nil						
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						REDSQUADRON5_DATA[UnitID].TimeStamp = timer.getTime()
						REDSQUADRON5_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()					
					end			
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					REDSQUADRON5_DATA[UnitID].Vec2 = nil
					REDSQUADRON5_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						REDSQUADRON5_DATA[UnitID].TimeStamp = timer.getTime()
						REDSQUADRON5_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					--Special for Carrier Planes
					elseif (string.find(SpawnUnitName, "Epsilon")) then
						if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 15 and SpawnUnit:GetAltitude() < 25 )) then
							REDSQUADRON5_DATA[UnitID].TimeStamp = timer.getTime()
							REDSQUADRON5_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
						end					
					else
						REDSQUADRON5_DATA[UnitID].TimeStamp = nil
						REDSQUADRON5_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					REDSQUADRON5_DATA[UnitID].TimeStamp = nil
					REDSQUADRON5_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////REDSQUADRON5 NOT ALIVE SCRUB DATA
	else
		REDSQUADRON5_DATA[1].Vec2 = nil
		REDSQUADRON5_DATA[1].TimeStamp = nil
		REDSQUADRON5_DATA[2].Vec2 = nil
		REDSQUADRON5_DATA[2].TimeStamp = nil	
	end
		
	--////BLUE SQUADRON 1
	if ( GROUP:FindByName(BLUESQUADRON1GROUPNAME) ~= nil and GROUP:FindByName(BLUESQUADRON1GROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(BLUESQUADRON1GROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( BLUESQUADRON1_DATA[UnitID].Vec2 ~= nil and BLUESQUADRON1_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if BLUESQUADRON1_DATA[UnitID].Vec2.x == NewVec2.x and BLUESQUADRON1_DATA[UnitID].Vec2.y == NewVec2.y then
						if BLUESQUADRON1_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("BLUESQUADRON1 Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							BLUESQUADRON1_DATA[UnitID].Vec2 = nil
							BLUESQUADRON1_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						BLUESQUADRON1_DATA[UnitID].TimeStamp = timer.getTime()
						BLUESQUADRON1_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////On Carrier Deck And Stationary - Special For Carrier Planes, Don't Base On Vec Point Just Check Speed, Altitude And Timestamp
				elseif (SpawnUnit:InAir() == false and (string.find(SpawnUnitName, "USN"))) then
					if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 19 and SpawnUnit:GetAltitude() < 25 )) then 
						if BLUESQUADRON1_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then																		
							env.info("BLUESQUADRON1 Monitor - Deleting Navy Unit: "..SpawnUnitName.." Due To Inactivity", false)
							BLUESQUADRON1_DATA[UnitID].Vec2 = nil
							BLUESQUADRON1_DATA[UnitID].TimeStamp = nil						
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						BLUESQUADRON1_DATA[UnitID].TimeStamp = timer.getTime()
						BLUESQUADRON1_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()					
					end			
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					BLUESQUADRON1_DATA[UnitID].Vec2 = nil
					BLUESQUADRON1_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						BLUESQUADRON1_DATA[UnitID].TimeStamp = timer.getTime()
						BLUESQUADRON1_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					--Special for Carrier Planes
					elseif (string.find(SpawnUnitName, "USN")) then
						if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 19 and SpawnUnit:GetAltitude() < 25 )) then
							BLUESQUADRON1_DATA[UnitID].TimeStamp = timer.getTime()
							BLUESQUADRON1_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
						end					
					else
						BLUESQUADRON1_DATA[UnitID].TimeStamp = nil
						BLUESQUADRON1_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					BLUESQUADRON1_DATA[UnitID].TimeStamp = nil
					BLUESQUADRON1_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////BLUESQUADRON1 NOT ALIVE SCRUB DATA
	else
		BLUESQUADRON1_DATA[1].Vec2 = nil
		BLUESQUADRON1_DATA[1].TimeStamp = nil
		BLUESQUADRON1_DATA[2].Vec2 = nil
		BLUESQUADRON1_DATA[2].TimeStamp = nil	
	end
--[[	
	--////BLUE SQUADRON 2
	if ( GROUP:FindByName(BLUESQUADRON2GROUPNAME) ~= nil and GROUP:FindByName(BLUESQUADRON2GROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(BLUESQUADRON2GROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( BLUESQUADRON2_DATA[UnitID].Vec2 ~= nil and BLUESQUADRON2_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if BLUESQUADRON2_DATA[UnitID].Vec2.x == NewVec2.x and BLUESQUADRON2_DATA[UnitID].Vec2.y == NewVec2.y then
						if BLUESQUADRON2_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("BLUESQUADRON2 Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							BLUESQUADRON2_DATA[UnitID].Vec2 = nil
							BLUESQUADRON2_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						BLUESQUADRON2_DATA[UnitID].TimeStamp = timer.getTime()
						BLUESQUADRON2_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////On Carrier Deck And Stationary - Special For Carrier Planes, Don't Base On Vec Point Just Check Speed, Altitude And Timestamp
				elseif (SpawnUnit:InAir() == false and (string.find(SpawnUnitName, "USN"))) then
					if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 19 and SpawnUnit:GetAltitude() < 25 )) then 
						if BLUESQUADRON2_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then																		
							env.info("BLUESQUADRON2 Monitor - Deleting Navy Unit: "..SpawnUnitName.." Due To Inactivity", false)
							BLUESQUADRON2_DATA[UnitID].Vec2 = nil
							BLUESQUADRON2_DATA[UnitID].TimeStamp = nil						
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						BLUESQUADRON2_DATA[UnitID].TimeStamp = timer.getTime()
						BLUESQUADRON2_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()					
					end			
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					BLUESQUADRON2_DATA[UnitID].Vec2 = nil
					BLUESQUADRON2_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						BLUESQUADRON2_DATA[UnitID].TimeStamp = timer.getTime()
						BLUESQUADRON2_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					--Special for Carrier Planes
					elseif (string.find(SpawnUnitName, "USN")) then
						if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 19 and SpawnUnit:GetAltitude() < 25 )) then
							BLUESQUADRON2_DATA[UnitID].TimeStamp = timer.getTime()
							BLUESQUADRON2_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
						end					
					else
						BLUESQUADRON2_DATA[UnitID].TimeStamp = nil
						BLUESQUADRON2_DATA[UnitID].Vec2 = nil	
					end
				--////In Air
				else
					BLUESQUADRON2_DATA[UnitID].TimeStamp = nil
					BLUESQUADRON2_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////BLUESQUADRON2 NOT ALIVE SCRUB DATA
	else
		BLUESQUADRON2_DATA[1].Vec2 = nil
		BLUESQUADRON2_DATA[1].TimeStamp = nil
		BLUESQUADRON2_DATA[2].Vec2 = nil
		BLUESQUADRON2_DATA[2].TimeStamp = nil
	end
]]--
	--////BLUE SQUADRON 3
	if ( GROUP:FindByName(BLUESQUADRON3GROUPNAME) ~= nil and GROUP:FindByName(BLUESQUADRON3GROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(BLUESQUADRON3GROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( BLUESQUADRON3_DATA[UnitID].Vec2 ~= nil and BLUESQUADRON3_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if BLUESQUADRON3_DATA[UnitID].Vec2.x == NewVec2.x and BLUESQUADRON3_DATA[UnitID].Vec2.y == NewVec2.y then
						if BLUESQUADRON3_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("BLUESQUADRON3 Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							BLUESQUADRON3_DATA[UnitID].Vec2 = nil
							BLUESQUADRON3_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						BLUESQUADRON3_DATA[UnitID].TimeStamp = timer.getTime()
						BLUESQUADRON3_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////On Carrier Deck And Stationary - Special For Carrier Planes, Don't Base On Vec Point Just Check Speed, Altitude And Timestamp
				elseif (SpawnUnit:InAir() == false and (string.find(SpawnUnitName, "USN"))) then
					if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 19 and SpawnUnit:GetAltitude() < 25 )) then 
						if BLUESQUADRON3_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then																		
							env.info("BLUESQUADRON3 Monitor - Deleting Navy Unit: "..SpawnUnitName.." Due To Inactivity", false)
							BLUESQUADRON3_DATA[UnitID].Vec2 = nil
							BLUESQUADRON3_DATA[UnitID].TimeStamp = nil						
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						BLUESQUADRON3_DATA[UnitID].TimeStamp = timer.getTime()
						BLUESQUADRON3_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()					
					end			
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					BLUESQUADRON3_DATA[UnitID].Vec2 = nil
					BLUESQUADRON3_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						BLUESQUADRON3_DATA[UnitID].TimeStamp = timer.getTime()
						BLUESQUADRON3_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					--Special for Carrier Planes
					elseif (string.find(SpawnUnitName, "USN")) then
						if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 19 and SpawnUnit:GetAltitude() < 25 )) then
							BLUESQUADRON3_DATA[UnitID].TimeStamp = timer.getTime()
							BLUESQUADRON3_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
						end					
					else
						BLUESQUADRON3_DATA[UnitID].TimeStamp = nil
						BLUESQUADRON3_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					BLUESQUADRON3_DATA[UnitID].TimeStamp = nil
					BLUESQUADRON3_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////BLUESQUADRON3 NOT ALIVE SCRUB DATA
	else
		BLUESQUADRON3_DATA[1].Vec2 = nil
		BLUESQUADRON3_DATA[1].TimeStamp = nil
		BLUESQUADRON3_DATA[2].Vec2 = nil
		BLUESQUADRON3_DATA[2].TimeStamp = nil
	end
--[[
	 --////BLUE SQUADRON 4
  if ( GROUP:FindByName(BLUESQUADRON4GROUPNAME) ~= nil and GROUP:FindByName(BLUESQUADRON4GROUPNAME):IsAlive() ) then        
    
    local SpawnUnits = GROUP:FindByName(BLUESQUADRON4GROUPNAME):GetUnits()
    
    for UnitID, UnitData in pairs( SpawnUnits ) do
      
      local SpawnUnit = UnitData
      local SpawnUnitName = SpawnUnit:GetName()     
      
      --////Existing Timestamp
      if ( BLUESQUADRON4_DATA[UnitID].Vec2 ~= nil and BLUESQUADRON4_DATA[UnitID].TimeStamp ~= nil ) then
        --////On Ground And Stationary
        if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
          local NewVec2 = SpawnUnit:GetVec2()
          if BLUESQUADRON4_DATA[UnitID].Vec2.x == NewVec2.x and BLUESQUADRON4_DATA[UnitID].Vec2.y == NewVec2.y then
            if BLUESQUADRON4_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then            
              env.info("BLUESQUADRON4 Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
              BLUESQUADRON4_DATA[UnitID].Vec2 = nil
              BLUESQUADRON4_DATA[UnitID].TimeStamp = nil
              Unit.getByName(SpawnUnit:GetName()):destroy()           
            end
          else
            BLUESQUADRON4_DATA[UnitID].TimeStamp = timer.getTime()
            BLUESQUADRON4_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
          end       
        --////On Carrier Deck And Stationary - Special For Carrier Planes, Don't Base On Vec Point Just Check Speed, Altitude And Timestamp
        elseif (SpawnUnit:InAir() == false and (string.find(SpawnUnitName, "USN"))) then
          if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 19 and SpawnUnit:GetAltitude() < 25 )) then 
            if BLUESQUADRON4_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then                                    
              env.info("BLUESQUADRON3 Monitor - Deleting Navy Unit: "..SpawnUnitName.." Due To Inactivity", false)
              BLUESQUADRON4_DATA[UnitID].Vec2 = nil
              BLUESQUADRON4_DATA[UnitID].TimeStamp = nil            
              Unit.getByName(SpawnUnit:GetName()):destroy()           
            end
          else
            BLUESQUADRON4_DATA[UnitID].TimeStamp = timer.getTime()
            BLUESQUADRON4_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()         
          end     
        --////In Air Or On Ground And Moving On Taxi/Takeoff Etc
        else
          BLUESQUADRON4_DATA[UnitID].Vec2 = nil
          BLUESQUADRON4_DATA[UnitID].TimeStamp = nil
        end
      --////No Existing Timestamp
      else
        --////Not In Air
        if SpawnUnit:InAir() == false then          
          if SpawnUnit:GetVelocityKMH() < 1 then
            BLUESQUADRON4_DATA[UnitID].TimeStamp = timer.getTime()
            BLUESQUADRON4_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
          --Special for Carrier Planes
          elseif (string.find(SpawnUnitName, "USN")) then
            if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 19 and SpawnUnit:GetAltitude() < 25 )) then
              BLUESQUADRON4_DATA[UnitID].TimeStamp = timer.getTime()
              BLUESQUADRON4_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
            end         
          else
            BLUESQUADRON4_DATA[UnitID].TimeStamp = nil
            BLUESQUADRON4_DATA[UnitID].Vec2 = nil
          end
        --////In Air
        else
          BLUESQUADRON4_DATA[UnitID].TimeStamp = nil
          BLUESQUADRON4_DATA[UnitID].Vec2 = nil         
        end
      end
    end     
  --////BLUESQUADRON4 NOT ALIVE SCRUB DATA
  else
    BLUESQUADRON4_DATA[1].Vec2 = nil
    BLUESQUADRON4_DATA[1].TimeStamp = nil
    BLUESQUADRON4_DATA[2].Vec2 = nil
    BLUESQUADRON4_DATA[2].TimeStamp = nil
  end
	
	  --////BLUE SQUADRON 5
  if ( GROUP:FindByName(BLUESQUADRON5GROUPNAME) ~= nil and GROUP:FindByName(BLUESQUADRON5GROUPNAME):IsAlive() ) then        
    
    local SpawnUnits = GROUP:FindByName(BLUESQUADRON5GROUPNAME):GetUnits()
    
    for UnitID, UnitData in pairs( SpawnUnits ) do
      
      local SpawnUnit = UnitData
      local SpawnUnitName = SpawnUnit:GetName()     
      
      --////Existing Timestamp
      if ( BLUESQUADRON5_DATA[UnitID].Vec2 ~= nil and BLUESQUADRON5_DATA[UnitID].TimeStamp ~= nil ) then
        --////On Ground And Stationary
        if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
          local NewVec2 = SpawnUnit:GetVec2()
          if BLUESQUADRON5_DATA[UnitID].Vec2.x == NewVec2.x and BLUESQUADRON5_DATA[UnitID].Vec2.y == NewVec2.y then
            if BLUESQUADRON5_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then            
              env.info("BLUESQUADRON4 Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
              BLUESQUADRON5_DATA[UnitID].Vec2 = nil
              BLUESQUADRON5_DATA[UnitID].TimeStamp = nil
              Unit.getByName(SpawnUnit:GetName()):destroy()           
            end
          else
            BLUESQUADRON5_DATA[UnitID].TimeStamp = timer.getTime()
            BLUESQUADRON5_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
          end       
        --////On Carrier Deck And Stationary - Special For Carrier Planes, Don't Base On Vec Point Just Check Speed, Altitude And Timestamp
        elseif (SpawnUnit:InAir() == false and (string.find(SpawnUnitName, "USN"))) then
          if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 19 and SpawnUnit:GetAltitude() < 25 )) then 
            if BLUESQUADRON5_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then                                    
              env.info("BLUESQUADRON3 Monitor - Deleting Navy Unit: "..SpawnUnitName.." Due To Inactivity", false)
              BLUESQUADRON5_DATA[UnitID].Vec2 = nil
              BLUESQUADRON5_DATA[UnitID].TimeStamp = nil            
              Unit.getByName(SpawnUnit:GetName()):destroy()           
            end
          else
            BLUESQUADRON5_DATA[UnitID].TimeStamp = timer.getTime()
            BLUESQUADRON5_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()         
          end     
        --////In Air Or On Ground And Moving On Taxi/Takeoff Etc
        else
          BLUESQUADRON5_DATA[UnitID].Vec2 = nil
          BLUESQUADRON5_DATA[UnitID].TimeStamp = nil
        end
      --////No Existing Timestamp
      else
        --////Not In Air
        if SpawnUnit:InAir() == false then          
          if SpawnUnit:GetVelocityKMH() < 1 then
            BLUESQUADRON5_DATA[UnitID].TimeStamp = timer.getTime()
            BLUESQUADRON5_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
          --Special for Carrier Planes
          elseif (string.find(SpawnUnitName, "USN")) then
            if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 19 and SpawnUnit:GetAltitude() < 25 )) then
              BLUESQUADRON5_DATA[UnitID].TimeStamp = timer.getTime()
              BLUESQUADRON5_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
            end         
          else
            BLUESQUADRON5_DATA[UnitID].TimeStamp = nil
            BLUESQUADRON5_DATA[UnitID].Vec2 = nil
          end
        --////In Air
        else
          BLUESQUADRON5_DATA[UnitID].TimeStamp = nil
          BLUESQUADRON5_DATA[UnitID].Vec2 = nil         
        end
      end
    end     
  --////BLUESQUADRON4 NOT ALIVE SCRUB DATA
  else
    BLUESQUADRON5_DATA[1].Vec2 = nil
    BLUESQUADRON5_DATA[1].TimeStamp = nil
    BLUESQUADRON5_DATA[2].Vec2 = nil
    BLUESQUADRON5_DATA[2].TimeStamp = nil
  end
	
	--////USAEF CAP
	if ( GROUP:FindByName(USAEFCAPGROUPNAME) ~= nil and GROUP:FindByName(USAEFCAPGROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(USAEFCAPGROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( USAEFCAP_DATA[UnitID].Vec2 ~= nil and USAEFCAP_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if USAEFCAP_DATA[UnitID].Vec2.x == NewVec2.x and USAEFCAP_DATA[UnitID].Vec2.y == NewVec2.y then
						if USAEFCAP_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("USAEFCAP Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							USAEFCAP_DATA[UnitID].Vec2 = nil
							USAEFCAP_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						USAEFCAP_DATA[UnitID].TimeStamp = timer.getTime()
						USAEFCAP_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					USAEFCAP_DATA[UnitID].Vec2 = nil
					USAEFCAP_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						USAEFCAP_DATA[UnitID].TimeStamp = timer.getTime()
						USAEFCAP_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						USAEFCAP_DATA[UnitID].TimeStamp = nil
						USAEFCAP_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					USAEFCAP_DATA[UnitID].TimeStamp = nil
					USAEFCAP_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////USAEFCAP NOT ALIVE SCRUB DATA
	else
		USAEFCAP_DATA[1].Vec2 = nil
		USAEFCAP_DATA[1].TimeStamp = nil
		USAEFCAP_DATA[2].Vec2 = nil
		USAEFCAP_DATA[2].TimeStamp = nil
	end
]]--		
	--////USAEF SEAD
	if ( GROUP:FindByName(USAEFSEADGROUPNAME) ~= nil and GROUP:FindByName(USAEFSEADGROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(USAEFSEADGROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( USAEFSEAD_DATA[UnitID].Vec2 ~= nil and USAEFSEAD_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if USAEFSEAD_DATA[UnitID].Vec2.x == NewVec2.x and USAEFSEAD_DATA[UnitID].Vec2.y == NewVec2.y then
						if USAEFSEAD_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("USAEFSEAD Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							USAEFSEAD_DATA[UnitID].Vec2 = nil
							USAEFSEAD_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						USAEFSEAD_DATA[UnitID].TimeStamp = timer.getTime()
						USAEFSEAD_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					USAEFSEAD_DATA[UnitID].Vec2 = nil
					USAEFSEAD_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						USAEFSEAD_DATA[UnitID].TimeStamp = timer.getTime()
						USAEFSEAD_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						USAEFSEAD_DATA[UnitID].TimeStamp = nil
						USAEFSEAD_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					USAEFSEAD_DATA[UnitID].TimeStamp = nil
					USAEFSEAD_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////USAEFSEAD NOT ALIVE SCRUB DATA
	else
		USAEFSEAD_DATA[1].Vec2 = nil
		USAEFSEAD_DATA[1].TimeStamp = nil
		USAEFSEAD_DATA[2].Vec2 = nil
		USAEFSEAD_DATA[2].TimeStamp = nil
	end
	
	--////USAEF CAS
	if ( GROUP:FindByName(USAEFCASGROUPNAME) ~= nil and GROUP:FindByName(USAEFCASGROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(USAEFCASGROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( USAEFCAS_DATA[UnitID].Vec2 ~= nil and USAEFCAS_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if USAEFCAS_DATA[UnitID].Vec2.x == NewVec2.x and USAEFCAS_DATA[UnitID].Vec2.y == NewVec2.y then
						if USAEFCAS_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("USAEFCAS Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							USAEFCAS_DATA[UnitID].Vec2 = nil
							USAEFCAS_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						USAEFCAS_DATA[UnitID].TimeStamp = timer.getTime()
						USAEFCAS_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					USAEFCAS_DATA[UnitID].Vec2 = nil
					USAEFCAS_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						USAEFCAS_DATA[UnitID].TimeStamp = timer.getTime()
						USAEFCAS_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						USAEFCAS_DATA[UnitID].TimeStamp = nil
						USAEFCAS_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					USAEFCAS_DATA[UnitID].TimeStamp = nil
					USAEFCAS_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////USAEFCAS NOT ALIVE SCRUB DATA
	else
		USAEFCAS_DATA[1].Vec2 = nil
		USAEFCAS_DATA[1].TimeStamp = nil
		USAEFCAS_DATA[2].Vec2 = nil
		USAEFCAS_DATA[2].TimeStamp = nil
	end
	
	--////USAEF ASS
	if ( GROUP:FindByName(USAEFASSGROUPNAME) ~= nil and GROUP:FindByName(USAEFASSGROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(USAEFASSGROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( USAEFASS_DATA[UnitID].Vec2 ~= nil and USAEFASS_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if USAEFASS_DATA[UnitID].Vec2.x == NewVec2.x and USAEFASS_DATA[UnitID].Vec2.y == NewVec2.y then
						if USAEFASS_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("USAEFASS Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							USAEFASS_DATA[UnitID].Vec2 = nil
							USAEFASS_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						USAEFASS_DATA[UnitID].TimeStamp = timer.getTime()
						USAEFASS_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					USAEFASS_DATA[UnitID].Vec2 = nil
					USAEFASS_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then
					if SpawnUnit:GetVelocityKMH() < 1 then
						USAEFASS_DATA[UnitID].TimeStamp = timer.getTime()
						USAEFASS_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						USAEFASS_DATA[UnitID].TimeStamp = nil
						USAEFASS_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					USAEFASS_DATA[UnitID].TimeStamp = nil
					USAEFASS_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////USAEFASS NOT ALIVE SCRUB DATA
	else
		USAEFASS_DATA[1].Vec2 = nil
		USAEFASS_DATA[1].TimeStamp = nil
		USAEFASS_DATA[2].Vec2 = nil
		USAEFASS_DATA[2].TimeStamp = nil
	end
	
	--////USAEF PIN
	if ( GROUP:FindByName(USAEFPINGROUPNAME) ~= nil and GROUP:FindByName(USAEFPINGROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(USAEFPINGROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( USAEFPIN_DATA[UnitID].Vec2 ~= nil and USAEFPIN_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if USAEFPIN_DATA[UnitID].Vec2.x == NewVec2.x and USAEFPIN_DATA[UnitID].Vec2.y == NewVec2.y then
						if USAEFPIN_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("USAEFPIN Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							USAEFPIN_DATA[UnitID].Vec2 = nil
							USAEFPIN_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						USAEFPIN_DATA[UnitID].TimeStamp = timer.getTime()
						USAEFPIN_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					USAEFPIN_DATA[UnitID].Vec2 = nil
					USAEFPIN_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						USAEFPIN_DATA[UnitID].TimeStamp = timer.getTime()
						USAEFPIN_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						USAEFPIN_DATA[UnitID].TimeStamp = nil
						USAEFPIN_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					USAEFPIN_DATA[UnitID].TimeStamp = nil
					USAEFPIN_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////USAEFPIN NOT ALIVE SCRUB DATA
	else
		USAEFPIN_DATA[1].Vec2 = nil
		USAEFPIN_DATA[1].TimeStamp = nil
		USAEFPIN_DATA[2].Vec2 = nil
		USAEFPIN_DATA[2].TimeStamp = nil
	end
	
	--////USAEF DRONE
	if ( GROUP:FindByName(USAEFDRONEGROUPNAME) ~= nil and GROUP:FindByName(USAEFDRONEGROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(USAEFDRONEGROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( USAEFDRONE_DATA[UnitID].Vec2 ~= nil and USAEFDRONE_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if USAEFDRONE_DATA[UnitID].Vec2.x == NewVec2.x and USAEFDRONE_DATA[UnitID].Vec2.y == NewVec2.y then
						if USAEFDRONE_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("USAEFDRONE Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							USAEFDRONE_DATA[UnitID].Vec2 = nil
							USAEFDRONE_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						USAEFDRONE_DATA[UnitID].TimeStamp = timer.getTime()
						USAEFDRONE_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					USAEFDRONE_DATA[UnitID].Vec2 = nil
					USAEFDRONE_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						USAEFDRONE_DATA[UnitID].TimeStamp = timer.getTime()
						USAEFDRONE_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						USAEFDRONE_DATA[UnitID].TimeStamp = nil
						USAEFDRONE_DATA[UnitID].Vec2 = nil	
					end
				--////In Air
				else
					USAEFDRONE_DATA[UnitID].TimeStamp = nil
					USAEFDRONE_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////USAEFDRONE NOT ALIVE SCRUB DATA
	else
		USAEFDRONE_DATA[1].Vec2 = nil
		USAEFDRONE_DATA[1].TimeStamp = nil		
	end
	
	--////SYAAF AN-26B
	if ( GROUP:FindByName(SYAAFAN26BGROUPNAME) ~= nil and GROUP:FindByName(SYAAFAN26BGROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(SYAAFAN26BGROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( SYAAFAN26B_DATA[UnitID].Vec2 ~= nil and SYAAFAN26B_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if SYAAFAN26B_DATA[UnitID].Vec2.x == NewVec2.x and SYAAFAN26B_DATA[UnitID].Vec2.y == NewVec2.y then
						if SYAAFAN26B_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("SYAAFAN26B Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							SYAAFAN26B_DATA[UnitID].Vec2 = nil
							SYAAFAN26B_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						SYAAFAN26B_DATA[UnitID].TimeStamp = timer.getTime()
						SYAAFAN26B_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					SYAAFAN26B_DATA[UnitID].Vec2 = nil
					SYAAFAN26B_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						SYAAFAN26B_DATA[UnitID].TimeStamp = timer.getTime()
						SYAAFAN26B_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						SYAAFAN26B_DATA[UnitID].TimeStamp = nil
						SYAAFAN26B_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					SYAAFAN26B_DATA[UnitID].TimeStamp = nil
					SYAAFAN26B_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////SYAAF AN-26B NOT ALIVE SCRUB DATA
	else
		SYAAFAN26B_DATA[1].Vec2 = nil
		SYAAFAN26B_DATA[1].TimeStamp = nil		
	end
	
	--////IRIAF Mi-8
	if ( GROUP:FindByName(IRIAFMI8GROUPNAME) ~= nil and GROUP:FindByName(IRIAFMI8GROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(IRIAFMI8GROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( IRIAFMI8_DATA[UnitID].Vec2 ~= nil and IRIAFMI8_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if IRIAFMI8_DATA[UnitID].Vec2.x == NewVec2.x and IRIAFMI8_DATA[UnitID].Vec2.y == NewVec2.y then
						if IRIAFMI8_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("IRIAFMI8 Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							IRIAFMI8_DATA[UnitID].Vec2 = nil
							IRIAFMI8_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						IRIAFMI8_DATA[UnitID].TimeStamp = timer.getTime()
						IRIAFMI8_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////On Carrier Deck And Stationary - Special For Carrier Planes, Don't Base On Vec Point Just Check Speed, Altitude And Timestamp
				elseif (SpawnUnit:InAir() == false and (string.find(SpawnUnitName, "IRIAF Mi-8"))) then
					if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 15 and SpawnUnit:GetAltitude() < 25 )) then 
						if IRIAFMI8_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then																		
							env.info("IRIAFMI8 Monitor - Deleting Navy Unit: "..SpawnUnitName.." Due To Inactivity", false)
							IRIAFMI8_DATA[UnitID].Vec2 = nil
							IRIAFMI8_DATA[UnitID].TimeStamp = nil						
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						IRIAFMI8_DATA[UnitID].TimeStamp = timer.getTime()
						IRIAFMI8_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()					
					end			
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					IRIAFMI8_DATA[UnitID].Vec2 = nil
					IRIAFMI8_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						IRIAFMI8_DATA[UnitID].TimeStamp = timer.getTime()
						IRIAFMI8_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					--Special for Carrier Planes
					elseif (string.find(SpawnUnitName, "IRIAF Mi-8")) then
						if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 15 and SpawnUnit:GetAltitude() < 25 )) then
							IRIAFMI8_DATA[UnitID].TimeStamp = timer.getTime()
							IRIAFMI8_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
						end					
					else
						IRIAFMI8_DATA[UnitID].TimeStamp = nil
						IRIAFMI8_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					IRIAFMI8_DATA[UnitID].TimeStamp = nil
					IRIAFMI8_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////IRIAFMI8 NOT ALIVE SCRUB DATA
	else
		IRIAFMI8_DATA[1].Vec2 = nil
		IRIAFMI8_DATA[1].TimeStamp = nil		
	end
		
	--////USAF C-130
	if ( GROUP:FindByName(USAFC130GROUPNAME) ~= nil and GROUP:FindByName(USAFC130GROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(USAFC130GROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( USAFC130_DATA[UnitID].Vec2 ~= nil and USAFC130_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if USAFC130_DATA[UnitID].Vec2.x == NewVec2.x and USAFC130_DATA[UnitID].Vec2.y == NewVec2.y then
						if USAFC130_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("USAFC130 Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							USAFC130_DATA[UnitID].Vec2 = nil
							USAFC130_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						USAFC130_DATA[UnitID].TimeStamp = timer.getTime()
						USAFC130_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					USAFC130_DATA[UnitID].Vec2 = nil
					USAFC130_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						USAFC130_DATA[UnitID].TimeStamp = timer.getTime()
						USAFC130_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						USAFC130_DATA[UnitID].TimeStamp = nil
						USAFC130_DATA[UnitID].Vec2 = nil	
					end
				--////In Air
				else
					USAFC130_DATA[UnitID].TimeStamp = nil
					USAFC130_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////USAFC130 NOT ALIVE SCRUB DATA
	else
		USAFC130_DATA[1].Vec2 = nil
		USAFC130_DATA[1].TimeStamp = nil		
	end
		
	--////USAF UH-60A
	if ( GROUP:FindByName(USAFUH60AGROUPNAME) ~= nil and GROUP:FindByName(USAFUH60AGROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(USAFUH60AGROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( USAFUH60A_DATA[UnitID].Vec2 ~= nil and USAFUH60A_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if USAFUH60A_DATA[UnitID].Vec2.x == NewVec2.x and USAFUH60A_DATA[UnitID].Vec2.y == NewVec2.y then
						if USAFUH60A_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("USAFUH60A Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							USAFUH60A_DATA[UnitID].Vec2 = nil
							USAFUH60A_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						USAFUH60A_DATA[UnitID].TimeStamp = timer.getTime()
						USAFUH60A_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////On Carrier Deck And Stationary - Special For Carrier Planes, Don't Base On Vec Point Just Check Speed, Altitude And Timestamp
				elseif (SpawnUnit:InAir() == false and (string.find(SpawnUnitName, "USAF UH-60A"))) then
					if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 19 and SpawnUnit:GetAltitude() < 25 )) then 
						if USAFUH60A_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then																		
							env.info("USAFUH60A Monitor - Deleting Navy Unit: "..SpawnUnitName.." Due To Inactivity", false)
							USAFUH60A_DATA[UnitID].Vec2 = nil
							USAFUH60A_DATA[UnitID].TimeStamp = nil						
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						USAFUH60A_DATA[UnitID].TimeStamp = timer.getTime()
						USAFUH60A_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()					
					end			
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					USAFUH60A_DATA[UnitID].Vec2 = nil
					USAFUH60A_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						USAFUH60A_DATA[UnitID].TimeStamp = timer.getTime()
						USAFUH60A_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					--Special for Carrier Planes
					elseif (string.find(SpawnUnitName, "USAF UH-60A")) then
						if (( SpawnUnit:GetVelocityKMH() > 1 and SpawnUnit:GetVelocityKMH() < 41 ) and ( SpawnUnit:GetAltitude() > 19 and SpawnUnit:GetAltitude() < 25 )) then
							USAFUH60A_DATA[UnitID].TimeStamp = timer.getTime()
							USAFUH60A_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
						end					
					else
						USAFUH60A_DATA[UnitID].TimeStamp = nil
						USAFUH60A_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					USAFUH60A_DATA[UnitID].TimeStamp = nil
					USAFUH60A_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////USAFUH60A NOT ALIVE SCRUB DATA
	else
		USAFUH60A_DATA[1].Vec2 = nil
		USAFUH60A_DATA[1].TimeStamp = nil		
	end
		
	--////SYAAF SU-24M
	if ( GROUP:FindByName(SYAAFSU24MGROUPNAME) ~= nil and GROUP:FindByName(SYAAFSU24MGROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(SYAAFSU24MGROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( SYAAFSU24M_DATA[UnitID].Vec2 ~= nil and SYAAFSU24M_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if SYAAFSU24M_DATA[UnitID].Vec2.x == NewVec2.x and SYAAFSU24M_DATA[UnitID].Vec2.y == NewVec2.y then
						if SYAAFSU24M_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("SYAAFSU24M Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							SYAAFSU24M_DATA[UnitID].Vec2 = nil
							SYAAFSU24M_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						SYAAFSU24M_DATA[UnitID].TimeStamp = timer.getTime()
						SYAAFSU24M_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					SYAAFSU24M_DATA[UnitID].Vec2 = nil
					SYAAFSU24M_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						SYAAFSU24M_DATA[UnitID].TimeStamp = timer.getTime()
						SYAAFSU24M_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						SYAAFSU24M_DATA[UnitID].TimeStamp = nil
						SYAAFSU24M_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					SYAAFSU24M_DATA[UnitID].TimeStamp = nil
					SYAAFSU24M_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////SYAAFSU24M NOT ALIVE SCRUB DATA
	else
		SYAAFSU24M_DATA[1].Vec2 = nil
		SYAAFSU24M_DATA[1].TimeStamp = nil
		SYAAFSU24M_DATA[2].Vec2 = nil
		SYAAFSU24M_DATA[2].TimeStamp = nil
	end
		
	--////VVS SU-25T
	if ( GROUP:FindByName(VVSSU25TGROUPNAME) ~= nil and GROUP:FindByName(VVSSU25TGROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(VVSSU25TGROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( VVSSU25T_DATA[UnitID].Vec2 ~= nil and VVSSU25T_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if VVSSU25T_DATA[UnitID].Vec2.x == NewVec2.x and VVSSU25T_DATA[UnitID].Vec2.y == NewVec2.y then
						if VVSSU25T_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("VVSSU25T Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							VVSSU25T_DATA[UnitID].Vec2 = nil
							VVSSU25T_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						VVSSU25T_DATA[UnitID].TimeStamp = timer.getTime()
						VVSSU25T_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					VVSSU25T_DATA[UnitID].Vec2 = nil
					VVSSU25T_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						VVSSU25T_DATA[UnitID].TimeStamp = timer.getTime()
						VVSSU25T_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						VVSSU25T_DATA[UnitID].TimeStamp = nil
						VVSSU25T_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					VVSSU25T_DATA[UnitID].TimeStamp = nil
					VVSSU25T_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////VVSSU25T NOT ALIVE SCRUB DATA
	else
		VVSSU25T_DATA[1].Vec2 = nil
		VVSSU25T_DATA[1].TimeStamp = nil
		VVSSU25T_DATA[2].Vec2 = nil
		VVSSU25T_DATA[2].TimeStamp = nil
	end
	
	--////VVS TU-95MS
	if ( GROUP:FindByName(VVSTU95MSGROUPNAME) ~= nil and GROUP:FindByName(VVSTU95MSGROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(VVSTU95MSGROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( VVSTU95MS_DATA[UnitID].Vec2 ~= nil and VVSTU95MS_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if VVSTU95MS_DATA[UnitID].Vec2.x == NewVec2.x and VVSTU95MS_DATA[UnitID].Vec2.y == NewVec2.y then
						if VVSTU95MS_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("VVSTU95MS Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							VVSTU95MS_DATA[UnitID].Vec2 = nil
							VVSTU95MS_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						VVSTU95MS_DATA[UnitID].TimeStamp = timer.getTime()
						VVSTU95MS_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					VVSTU95MS_DATA[UnitID].Vec2 = nil
					VVSTU95MS_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						VVSTU95MS_DATA[UnitID].TimeStamp = timer.getTime()
						VVSTU95MS_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						VVSTU95MS_DATA[UnitID].TimeStamp = nil
						VVSTU95MS_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					VVSTU95MS_DATA[UnitID].TimeStamp = nil
					VVSTU95MS_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////VVSTU95MS NOT ALIVE SCRUB DATA
	else
		VVSTU95MS_DATA[1].Vec2 = nil
		VVSTU95MS_DATA[1].TimeStamp = nil		
	end
		
	--////VVS TU-160
	if ( GROUP:FindByName(VVSTU160GROUPNAME) ~= nil and GROUP:FindByName(VVSTU160GROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(VVSTU160GROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( VVSTU160_DATA[UnitID].Vec2 ~= nil and VVSTU160_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if VVSTU160_DATA[UnitID].Vec2.x == NewVec2.x and VVSTU160_DATA[UnitID].Vec2.y == NewVec2.y then
						if VVSTU160_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("VVSTU160 Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							VVSTU160_DATA[UnitID].Vec2 = nil
							VVSTU160_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						VVSTU160_DATA[UnitID].TimeStamp = timer.getTime()
						VVSTU160_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					VVSTU160_DATA[UnitID].Vec2 = nil
					VVSTU160_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						VVSTU160_DATA[UnitID].TimeStamp = timer.getTime()
						VVSTU160_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						VVSTU160_DATA[UnitID].TimeStamp = nil
						VVSTU160_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					VVSTU160_DATA[UnitID].TimeStamp = nil
					VVSTU160_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////VVSTU160 NOT ALIVE SCRUB DATA
	else
		VVSTU160_DATA[1].Vec2 = nil
		VVSTU160_DATA[1].TimeStamp = nil		
	end
	
	--////VVS TU-22M3
	if ( GROUP:FindByName(VVSTU22M3GROUPNAME) ~= nil and GROUP:FindByName(VVSTU22M3GROUPNAME):IsAlive() ) then				
		
		local SpawnUnits = GROUP:FindByName(VVSTU22M3GROUPNAME):GetUnits()
	  
		for UnitID, UnitData in pairs( SpawnUnits ) do
	    
			local SpawnUnit = UnitData
			local SpawnUnitName = SpawnUnit:GetName()			
			
			--////Existing Timestamp
			if ( VVSTU22M3_DATA[UnitID].Vec2 ~= nil and VVSTU22M3_DATA[UnitID].TimeStamp ~= nil ) then
				--////On Ground And Stationary
				if SpawnUnit:InAir() == false and SpawnUnit:GetVelocityKMH() < 1 then
					local NewVec2 = SpawnUnit:GetVec2()
					if VVSTU22M3_DATA[UnitID].Vec2.x == NewVec2.x and VVSTU22M3_DATA[UnitID].Vec2.y == NewVec2.y then
						if VVSTU22M3_DATA[UnitID].TimeStamp + CleanupTime < timer.getTime() then						
							env.info("VVSTU22M3 Monitor - Deleting: "..SpawnUnitName.." Due To Inactivity", false)
							VVSTU22M3_DATA[UnitID].Vec2 = nil
							VVSTU22M3_DATA[UnitID].TimeStamp = nil
							Unit.getByName(SpawnUnit:GetName()):destroy()						
						end
					else
						VVSTU22M3_DATA[UnitID].TimeStamp = timer.getTime()
						VVSTU22M3_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					end    		
				--////In Air Or On Ground And Moving On Taxi/Takeoff Etc
				else
					VVSTU22M3_DATA[UnitID].Vec2 = nil
					VVSTU22M3_DATA[UnitID].TimeStamp = nil
				end
			--////No Existing Timestamp
			else
				--////Not In Air
				if SpawnUnit:InAir() == false then					
					if SpawnUnit:GetVelocityKMH() < 1 then
						VVSTU22M3_DATA[UnitID].TimeStamp = timer.getTime()
						VVSTU22M3_DATA[UnitID].Vec2 = SpawnUnit:GetVec2()
					else
						VVSTU22M3_DATA[UnitID].TimeStamp = nil
						VVSTU22M3_DATA[UnitID].Vec2 = nil
					end
				--////In Air
				else
					VVSTU22M3_DATA[UnitID].TimeStamp = nil
					VVSTU22M3_DATA[UnitID].Vec2 = nil					
				end
			end
		end			
	--////VVSTU22M3 NOT ALIVE SCRUB DATA
	else
		VVSTU22M3_DATA[1].Vec2 = nil
		VVSTU22M3_DATA[1].TimeStamp = nil		
	end
	
	--////REPEAT ALWAYS
	timer.scheduleFunction(SEF_SetukasSword, nil, timer.getTime() + CleanupTime)
end

--////END FUNCTIONS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--////MAIN

SEF_SetukasSword()
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
env.info("Sword of Setsuke Complete", false)
