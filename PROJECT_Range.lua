env.info("Range Loading", false)

-- XXX RANGE SCRIPT SECTION (MOOSE)

local jtf1RangeControlCommon = 250.000

-- BEGIN WE01 Range
local bombtarget_WE01 = {"WE01_village1",
  "WE01_village2",
  "WE01_village3",
  "WE01_village4",
  "WE01_village5",
  "WE01_village6",
  "WE01_village7",
  "WE01_village8",
  "WE01_village9",
  "WE01_village10",
  "WE01_village11",
  "WE01_village12",
  "WE01_village13",
  "WE01_village14",
  "WE01_village15"
  }

Range_ME01 = RANGE:New("ME01 Range")
Range_ME01:AddBombingTargets(bombtarget_WE01, 25)
Range_ME01:SetSoundfilesPath("Range Soundfiles/")
--Range_ME01:SetInstructorRadio(jtf1RangeControlCommon)
Range_ME01:SetRangeControl(250.100)
Range_ME01:Start()

-- END WE01 Range

-- BEGIN VE91 Range
local strafepit_VE91_NORTH={"RANGE_VE91_strafepit_A",
  "RANGE_VE91_strafepit_B"
  }
local strafepit_VE91_SOUTH={"RANGE_VE91_strafepit_C",
  "RANGE_VE91_strafepit_D"
  }
local bombtarget_VE91={"RANGE_VE91_SOUTH_bombing", 
  "RANGE_VE91_NORTH_bombing"
  }

Range_VE91 = RANGE:New("VE91 Range")
fouldist_VE91AB = Range_VE91:GetFoullineDistance("RANGE_VE91_strafepit_A", "RANGE_VE91_FoulLine_AB")
fouldist_VE91CD = Range_VE91:GetFoullineDistance("RANGE_VE91_strafepit_A", "RANGE_VE91_FoulLine_CD")
Range_VE91:AddStrafePit(strafepit_VE91_NORTH, 3000, 300, nil, true, 20, fouldist_VE91AB)
Range_VE91:AddStrafePit(strafepit_VE91_SOUTH, 3000, 300, nil, true, 20, fouldist_VE91CD)
Range_VE91:AddBombingTargets(bombtarget_VE91, 50)
Range_VE91:SetSoundfilesPath("Range Soundfiles/")
--Range_VE91:SetInstructorRadio(jtf1RangeControlCommon)
Range_VE91:SetRangeControl(250.200)
Range_VE91:Start()

-- END VE91 Range

-- BEGIN WE00 Range
local bombtarget_WE00 = {"WE00_lake-1",
  "WE00_lake-2",
  "WE00_lake-3",
  "WE00_lake-4",
  "WE00_lake-5",
  "WE00_lake-6",
  "WE00_lake-7",
  "WE00_lake-8",
  "WE00_lake-9",
  "WE00_lake-10",
  "WE00_lake-11",
  "WE00_lake-12",
  "WE00_lake-13",
  "WE00_lake-14",
  "WE00_lake-15",
  "WE00_lake-16",
  "WE00_lake-17",
  "WE00_lake-18",
  "WE00_lake-19",
  "WE00_lake-20"  
  }

Range_WE00 = RANGE:New("WE00 Range")
Range_WE00:AddBombingTargets(bombtarget_WE00, 50)
Range_WE00:SetSoundfilesPath("Range Soundfiles/")
--Range_WE00:SetInstructorRadio(jtf1RangeControlCommon)
Range_WE00:SetRangeControl(250.300)
Range_WE00:Start()

-- END WE00 Range


-- BEGIN VE90 Range

local bombtarget_VE90 = {"RANGE_VE90_STATIC-1",
  "RANGE_VE90_STATIC-2",
  "RANGE_VE90_STATIC-3",
  "RANGE_VE90_STATIC-4",
  "RANGE_VE90_STATIC-5",
  "RANGE_VE90_MOBILE-1",
  "RANGE_VE90_MOBILE-2",
  "RANGE_VE90_MOBILE-3",
  "RANGE_VE90_MOBILE-4",
  "RANGE_VE90_MOBILE-5"
  }
  
Range_VE90 = RANGE:New("VE90 Range")
Range_VE90:AddBombingTargets(bombtarget_VE90, 50)
Range_VE90:SetSoundfilesPath("Range Soundfiles/")
--Range_WE00:SetInstructorRadio(jtf1RangeControlCommon)
Range_VE90:SetRangeControl(250.400)
Range_VE90:Start()

-- END VE90 Range

-- BEGIN xx Range
-- END xx Range


-- END RANGE SCRIPT SECTION
env.info("Range Complete", false)