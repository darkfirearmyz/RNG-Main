RMenu.Add(
    "mainmenu",
    "cinematic",
    RageUI.CreateMenu("", "", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "new_editor", "r_editor_header")
)
RMenu:Get("mainmenu", "cinematic"):SetSubtitle("~b~CORRUPT Cinematic Editor")
RMenu.Add(
    "load_scene",
    "cinematic",
    RageUI.CreateSubMenu(
        RMenu:Get("mainmenu", "cinematic"),
        "",
        "",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "new_editor",
        "r_editor_header"
    )
)
RMenu:Get("load_scene", "cinematic"):SetSubtitle("~b~Load Scene")
RMenu.Add(
    "scene_manager",
    "cinematic",
    RageUI.CreateSubMenu(
        RMenu:Get("load_scene", "cinematic"),
        "",
        "",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "new_editor",
        "r_editor_header"
    )
)
RMenu:Get("scene_manager", "cinematic"):SetSubtitle("~b~Scene Manager")
RMenu.Add(
    "camera_manager",
    "cinematic",
    RageUI.CreateSubMenu(
        RMenu:Get("scene_manager", "cinematic"),
        "",
        "",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "new_editor",
        "r_editor_header"
    )
)
RMenu:Get("camera_manager", "cinematic"):SetSubtitle("~b~Camera Manager")
RMenu.Add(
    "screeneffect_manager",
    "cinematic",
    RageUI.CreateSubMenu(
        RMenu:Get("camera_manager", "cinematic"),
        "",
        "",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "new_editor",
        "r_editor_header"
    )
)
RMenu:Get("screeneffect_manager", "cinematic"):SetSubtitle("~b~Screen Effect Manager")
RMenu.Add(
    "timecycle_manager",
    "cinematic",
    RageUI.CreateSubMenu(
        RMenu:Get("camera_manager", "cinematic"),
        "",
        "",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "new_editor",
        "r_editor_header"
    )
)
RMenu:Get("timecycle_manager", "cinematic"):SetSubtitle("~b~Timecycle Effect Manager")
RMenu.Add(
    "shake_manager",
    "cinematic",
    RageUI.CreateSubMenu(
        RMenu:Get("camera_manager", "cinematic"),
        "",
        "",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "new_editor",
        "r_editor_header"
    )
)
RMenu:Get("shake_manager", "cinematic"):SetSubtitle("~b~Shake Effect Manager")
RMenu.Add(
    "add_camera",
    "cinematic",
    RageUI.CreateSubMenu(
        RMenu:Get("camera_manager", "cinematic"),
        "",
        "",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "new_editor",
        "r_editor_header"
    )
)
RMenu:Get("add_camera", "cinematic"):SetSubtitle("~b~Add Camera")
RMenu.Add(
    "camera_focus_manager",
    "cinematic",
    RageUI.CreateSubMenu(
        RMenu:Get("camera_manager", "cinematic"),
        "",
        "",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "new_editor",
        "r_editor_header"
    )
)
RMenu:Get("camera_focus_manager", "cinematic"):SetSubtitle("~b~Camera Focus")
RMenu.Add(
    "weather_time_manager",
    "cinematic",
    RageUI.CreateSubMenu(
        RMenu:Get("mainmenu", "cinematic"),
        "",
        "",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "new_editor",
        "r_editor_header"
    )
)
RMenu:Get("weather_time_manager", "cinematic"):SetSubtitle("~b~Time/Weather Manager")
RMenu.Add(
    "dof_manager",
    "cinematic",
    RageUI.CreateSubMenu(
        RMenu:Get("camera_manager", "cinematic"),
        "",
        "",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "new_editor",
        "r_editor_header"
    )
)
RMenu:Get("dof_manager", "cinematic"):SetSubtitle("~b~Depth of Field Manager")
local function a(b)
    RageUI.CloseAll()
    RageUI.Visible(RMenu:Get("mainmenu", "cinematic"), b)
end
local c = {
    "Default",
    "DeadlineNeon",
    "PPPurple",
    "PPOrange",
    "PPGreen",
    "InchPickup",
    "InchOrange",
    "MP_Bull_tost",
    "CrossLine",
    "ArenaWheelPurple",
    "SwitchHUDOut",
    "FocusIn",
    "FocusOut",
    "MinigameEndNeutral",
    "MinigameEndTrevor",
    "MinigameEndFranklin",
    "MinigameEndMichael",
    "MinigameTransitionOut",
    "MinigameTransitionIn",
    "SwitchShortNeutralIn",
    "SwitchShortFranklinIn",
    "SwitchShortTrevorIn",
    "SwitchShortMichaelIn",
    "SwitchOpenMichaelIn",
    "SwitchOpenFranklinIn",
    "SwitchOpenTrevorIn",
    "SwitchHUDMichaelOut",
    "SwitchHUDFranklinOut",
    "SwitchHUDTrevorOut",
    "SwitchShortFranklinMid",
    "SwitchShortMichaelMid",
    "SwitchShortTrevorMid",
    "DeathFailOut",
    "CamPushInNeutral",
    "CamPushInFranklin",
    "CamPushInMichael",
    "CamPushInTrevor",
    "SwitchOpenMichaelIn",
    "SwitchSceneFranklin",
    "SwitchSceneTrevor",
    "SwitchSceneMichael",
    "SwitchSceneNeutral",
    "MP_Celeb_Win",
    "MP_Celeb_Win_Out",
    "MP_Celeb_Lose",
    "MP_Celeb_Lose_Out",
    "DeathFailNeutralIn",
    "DeathFailMPDark",
    "DeathFailMPIn",
    "MP_Celeb_Preload_Fade",
    "PeyoteEndOut",
    "PeyoteEndIn",
    "PeyoteIn",
    "PeyoteOut",
    "MP_race_crash",
    "SuccessFranklin",
    "SuccessTrevor",
    "SuccessMichael",
    "DrugsMichaelAliensFightIn",
    "DrugsMichaelAliensFight",
    "DrugsMichaelAliensFightOut",
    "DrugsTrevorClownsFightIn",
    "DrugsTrevorClownsFight",
    "DrugsTrevorClownsFightOut",
    "HeistCelebPass",
    "HeistCelebPassBW",
    "HeistCelebEnd",
    "HeistCelebToast",
    "MenuMGHeistIn",
    "MenuMGTournamentIn",
    "MenuMGSelectionIn",
    "ChopVision",
    "DMT_flight_intro",
    "DMT_flight",
    "DrugsDrivingIn",
    "DrugsDrivingOut",
    "SwitchOpenNeutralFIB5",
    "HeistLocate",
    "MP_job_load",
    "RaceTurbo",
    "MP_intro_logo",
    "HeistTripSkipFade",
    "MenuMGHeistOut",
    "MP_corona_switch",
    "MenuMGSelectionTint",
    "SuccessNeutral",
    "ExplosionJosh3",
    "SniperOverlay",
    "RampageOut",
    "Rampage",
    "Dont_tazeme_bro",
    "DeathFailOut"
}
local d = {
    "None",
    "AP1_01_B_IntRefRange",
    "AP1_01_C_NoFog",
    "AirRaceBoost01",
    "AirRaceBoost02",
    "AmbientPUSH",
    "ArenaEMP",
    "ArenaEMP_Blend",
    "ArenaWheelPurple01",
    "ArenaWheelPurple02",
    "Bank_HLWD",
    "Barry1_Stoned",
    "BarryFadeOut",
    "BeastIntro01",
    "BeastIntro02",
    "BeastLaunch01",
    "BeastLaunch02",
    "BikerFilter",
    "BikerForm01",
    "BikerFormFlash",
    "Bikers",
    "BikersSPLASH",
    "BlackOut",
    "BleepYellow01",
    "BleepYellow02",
    "Bloom",
    "BloomLight",
    "BloomMid",
    "BombCam01",
    "BombCamFlash",
    "Broken_camera_fuzz",
    "BulletTimeDark",
    "BulletTimeLight",
    "CAMERA_BW",
    "CAMERA_secuirity",
    "CAMERA_secuirity_FUZZ",
    "CH3_06_water",
    "CHOP",
    "CS1_railwayB_tunnel",
    "CS3_rail_tunnel",
    "CUSTOM_streetlight",
    "Carpark_MP_exit",
    "CopsSPLASH",
    "CrossLine01",
    "CrossLine02",
    "DONT_overide_sunpos",
    "DRUG_2_drive",
    "DRUG_gas_huffin",
    "DeadlineNeon01",
    "DefaultColorCode",
    "Dont_tazeme_bro",
    "DrivingFocusDark",
    "DrivingFocusLight",
    "Drone_FishEye_Lens",
    "Drug_deadman",
    "Drug_deadman_blend",
    "Drunk",
    "EXTRA_bouncelight",
    "EXT_FULLAmbientmult_art",
    "ExplosionJosh",
    "FIB_5",
    "FIB_6",
    "FIB_A",
    "FIB_B",
    "FIB_interview",
    "FIB_interview_optimise",
    "FORdoron_delete",
    "FRANKLIN",
    "Facebook_NEW",
    "FinaleBank",
    "FinaleBankMid",
    "FinaleBankexit",
    "Forest",
    "FrankilinsHOUSEhills",
    "FranklinColorCode",
    "FranklinColorCodeBasic",
    "FranklinColorCodeBright",
    "FullAmbientmult_interior",
    "Glasses_BlackOut",
    "Hanger_INTmods",
    "Hicksbar",
    "HicksbarNEW",
    "Hint_cam",
    "IMpExt_Interior_02",
    "IMpExt_Interior_02_stair_cage",
    "INT_FULLAmbientmult_art",
    "INT_FULLAmbientmult_both",
    "INT_FullAmbientmult",
    "INT_NO_fogALPHA",
    "INT_NOdirectLight",
    "INT_NoAmbientmult",
    "INT_NoAmbientmult_art",
    "INT_NoAmbientmult_both",
    "INT_garage",
    "INT_mall",
    "INT_nowaterREF",
    "INT_posh_hairdresser",
    "INT_smshop",
    "INT_smshop_inMOD",
    "INT_smshop_indoor_bloom",
    "INT_smshop_outdoor_bloom",
    "INT_streetlighting",
    "INT_trailer_cinema",
    "ImpExp_Interior_01",
    "InchOrange01",
    "InchOrange02",
    "InchPickup01",
    "InchPickup02",
    "InchPurple01",
    "InchPurple02",
    "KT_underpass",
    "Kifflom",
    "LIGHTSreduceFALLOFF",
    "LODmult_HD_orphan_LOD_reduce",
    "LODmult_HD_orphan_reduce",
    "LODmult_LOD_reduce",
    "LODmult_SLOD1_reduce",
    "LODmult_SLOD2_reduce",
    "LODmult_SLOD3_reduce",
    "LODmult_global_reduce",
    "LODmult_global_reduce_NOHD",
    "LectroDark",
    "LectroLight",
    "LifeInvaderLOD",
    "LightPollutionHills",
    "LostTimeDark",
    "LostTimeFlash",
    "LostTimeLight",
    "METRO_Tunnels",
    "METRO_Tunnels_entrance",
    "METRO_platform",
    "MPApartHigh",
    "MPApartHigh_palnning",
    "MPApart_H_01",
    "MPApart_H_01_gym",
    "MP_Arena_VIP",
    "MP_Arena_theme_atlantis",
    "MP_Arena_theme_evening",
    "MP_Arena_theme_hell",
    "MP_Arena_theme_midday",
    "MP_Arena_theme_morning",
    "MP_Arena_theme_night",
    "MP_Arena_theme_saccharine",
    "MP_Arena_theme_sandstorm",
    "MP_Arena_theme_scifi_night",
    "MP_Arena_theme_storm",
    "MP_Arena_theme_toxic",
    "MP_Bull_tost",
    "MP_Bull_tost_blend",
    "MP_Garage_L",
    "MP_H_01_Bathroom",
    "MP_H_01_Bedroom",
    "MP_H_01_New",
    "MP_H_01_New_Bathroom",
    "MP_H_01_New_Bedroom",
    "MP_H_01_New_Study",
    "MP_H_01_Study",
    "MP_H_02",
    "MP_H_04",
    "MP_H_06",
    "MP_Killstreak",
    "MP_Killstreak_blend",
    "MP_Loser",
    "MP_Loser_blend",
    "MP_MedGarage",
    "MP_Powerplay",
    "MP_Powerplay_blend",
    "MP_Studio_Lo",
    "MP_corona_heist",
    "MP_corona_heist_BW",
    "MP_corona_heist_BW_night",
    "MP_corona_heist_DOF",
    "MP_corona_heist_blend",
    "MP_corona_heist_night",
    "MP_corona_heist_night_blend",
    "MP_corona_selection",
    "MP_corona_switch",
    "MP_corona_tournament",
    "MP_corona_tournament_DOF",
    "MP_death_grade",
    "MP_death_grade_blend01",
    "MP_death_grade_blend02",
    "MP_deathfail_night",
    "MP_heli_cam",
    "MP_intro_logo",
    "MP_job_end_night",
    "MP_job_load",
    "MP_job_load_01",
    "MP_job_load_02",
    "MP_job_lose",
    "MP_job_preload",
    "MP_job_preload_blend",
    "MP_job_preload_night",
    "MP_job_win",
    "MP_lowgarage",
    "MP_race_finish",
    "MP_select",
    "MichaelColorCode",
    "MichaelColorCodeBasic",
    "MichaelColorCodeBright",
    "MichaelsDarkroom",
    "MichaelsDirectional",
    "MichaelsNODirectional",
    "Mp_Stilts",
    "Mp_Stilts2",
    "Mp_Stilts2_bath",
    "Mp_Stilts_gym",
    "Mp_Stilts_gym2",
    "Mp_apart_mid",
    "Multipayer_spectatorCam",
    "NEW_abattoir",
    "NEW_jewel",
    "NEW_jewel_EXIT",
    "NEW_lesters",
    "NEW_ornate_bank",
    "NEW_ornate_bank_entrance",
    "NEW_ornate_bank_office",
    "NEW_ornate_bank_safe",
    "NEW_shrinksOffice",
    "NEW_station_unfinished",
    "NEW_trevorstrailer",
    "NEW_tunnels",
    "NEW_tunnels_ditch",
    "NEW_tunnels_hole",
    "NEW_yellowtunnels",
    "NG_blackout",
    "NG_deathfail_BW_base",
    "NG_deathfail_BW_blend01",
    "NG_deathfail_BW_blend02",
    "NG_filmic01",
    "NG_filmic02",
    "NG_filmic03",
    "NG_filmic04",
    "NG_filmic05",
    "NG_filmic06",
    "NG_filmic07",
    "NG_filmic08",
    "NG_filmic09",
    "NG_filmic10",
    "NG_filmic11",
    "NG_filmic12",
    "NG_filmic13",
    "NG_filmic14",
    "NG_filmic15",
    "NG_filmic16",
    "NG_filmic17",
    "NG_filmic18",
    "NG_filmic19",
    "NG_filmic20",
    "NG_filmic21",
    "NG_filmic22",
    "NG_filmic23",
    "NG_filmic24",
    "NG_filmic25",
    "NG_filmnoir_BW01",
    "NG_filmnoir_BW02",
    "NG_first",
    "NO_coronas",
    "NO_fog_alpha",
    "NO_streetAmbient",
    "NO_weather",
    "NOdirectLight",
    "NOrain",
    "NeutralColorCode",
    "NeutralColorCodeBasic",
    "NeutralColorCodeBright",
    "NeutralColorCodeLight",
    "NewMicheal",
    "NewMicheal_night",
    "NewMicheal_upstairs",
    "NewMichealgirly",
    "NewMichealstoilet",
    "NewMichealupstairs",
    "New_sewers",
    "NoAmbientmult",
    "NoAmbientmult_interior",
    "NoPedLight",
    "OrbitalCannon",
    "PERSHING_water_reflect",
    "PORT_heist_underwater",
    "PPFilter",
    "PPGreen01",
    "PPGreen02",
    "PPOrange01",
    "PPOrange02",
    "PPPink01",
    "PPPink02",
    "PPPurple01",
    "PPPurple02",
    "Paleto",
    "PennedInDark",
    "PennedInLight",
    "PlayerSwitchNeutralFlash",
    "PlayerSwitchPulse",
    "PoliceStation",
    "PoliceStationDark",
    "Prologue_shootout_opt",
    "REDMIST",
    "REDMIST_blend",
    "RaceTurboDark",
    "RaceTurboFlash",
    "RaceTurboLight",
    "ReduceDrawDistance",
    "ReduceDrawDistanceMAP",
    "ReduceDrawDistanceMission",
    "ReduceSSAO",
    "RemixDrone",
    "RemoteSniper",
    "SALTONSEA",
    "SAWMILL",
    "SP1_03_drawDistance",
    "STRIP_changing",
    "STRIP_nofog",
    "STRIP_office",
    "STRIP_stage",
    "SheriffStation",
    "Shop247",
    "Shop247_none",
    "SmugglerCheckpoint01",
    "SmugglerCheckpoint02",
    "SmugglerFlash",
    "Sniper",
    "StadLobby",
    "StreetLighting",
    "StreetLightingJunction",
    "StreetLightingtraffic",
    "StuntFastDark",
    "StuntFastLight",
    "StuntSlowDark",
    "StuntSlowLight",
    "TREVOR",
    "TUNNEL_green",
    "TUNNEL_green_ext",
    "TUNNEL_orange",
    "TUNNEL_orange_exterior",
    "TUNNEL_white",
    "TUNNEL_yellow",
    "TUNNEL_yellow_ext",
    "TinyGreen01",
    "TinyGreen02",
    "TinyPink01",
    "TinyPink02",
    "TinyRacerMoBlur",
    "TransformFlash",
    "TransformRaceFlash",
    "TrevorColorCode",
    "TrevorColorCodeBasic",
    "TrevorColorCodeBright",
    "Trevors_room",
    "Tunnel",
    "Tunnel_green1",
    "VAGOS_new_garage",
    "VAGOS_new_hangout",
    "VC_tunnel_entrance",
    "V_Abattoir_Cold",
    "V_CIA_Facility",
    "V_FIB_IT3",
    "V_FIB_IT3_alt",
    "V_FIB_IT3_alt5",
    "V_FIB_stairs",
    "V_Metro2",
    "V_Metro_station",
    "V_Office_smoke",
    "V_Office_smoke_Fire",
    "V_Office_smoke_ext",
    "V_Solomons",
    "V_recycle_dark",
    "V_recycle_light",
    "V_recycle_mainroom",
    "V_strip_nofog",
    "V_strip_office",
    "Vagos",
    "VagosSPLASH",
    "VolticBlur",
    "VolticFlash",
    "VolticGold",
    "WATER_lab_cooling",
    "WATER_CH2_06_01_03",
    "WATER_CH2_06_02",
    "WATER_CH2_06_04",
    "WATER_ID2_21",
    "WATER_REF_malibu",
    "WATER_RichmanStuntJump",
    "WATER_cove",
    "WATER_hills",
    "WATER_lab",
    "WATER_militaryPOOP",
    "WATER_muddy",
    "WATER_port",
    "WATER_refmap_high",
    "WATER_refmap_hollywoodlake",
    "WATER_refmap_low",
    "WATER_refmap_med",
    "WATER_refmap_off",
    "WATER_refmap_poolside",
    "WATER_refmap_silverlake",
    "WATER_refmap_venice",
    "WATER_refmap_verylow",
    "WATER_resevoir",
    "WATER_river",
    "WATER_salton",
    "WATER_salton_bottom",
    "WATER_shore",
    "WATER_silty",
    "WATER_silverlake",
    "WarpCheckpoint",
    "WeaponUpgrade",
    "WhiteOut",
    "baseTONEMAPPING",
    "blackNwhite",
    "buggy_shack",
    "buildingTOP",
    "cBank_back",
    "cBank_front",
    "canyon_mission",
    "carMOD_underpass",
    "carpark",
    "carpark_dt1_02",
    "carpark_dt1_03",
    "cashdepot",
    "cashdepotEMERGENCY",
    "ch2_tunnel_whitelight",
    "cinema",
    "cinema_001",
    "cops",
    "crane_cam",
    "crane_cam_cinematic",
    "damage",
    "default",
    "dont_tazeme_bro_b",
    "downtown_FIB_cascades_opt",
    "drug_drive_blend01",
    "drug_drive_blend02",
    "drug_flying_01",
    "drug_flying_02",
    "drug_flying_base",
    "drug_wobbly",
    "dying",
    "eatra_bouncelight_beach",
    "epsilion",
    "exile1_exit",
    "exile1_plane",
    "ext_int_extlight_large",
    "eyeINtheSKY",
    "facebook_serveroom",
    "fireDEPT",
    "fp_vig_black",
    "fp_vig_blue",
    "fp_vig_brown",
    "fp_vig_gray",
    "fp_vig_green",
    "fp_vig_red",
    "frankilnsAUNTS_SUNdir",
    "frankilnsAUNTS_new",
    "gallery_refmod",
    "garage",
    "gen_bank",
    "glasses_Darkblue",
    "glasses_Scuba",
    "glasses_VISOR",
    "glasses_black",
    "glasses_blue",
    "glasses_brown",
    "glasses_green",
    "glasses_orange",
    "glasses_pink",
    "glasses_purple",
    "glasses_red",
    "glasses_yellow",
    "gorge_reflection_gpu",
    "gorge_reflectionoffset",
    "gorge_reflectionoffset2",
    "graveyard_shootout",
    "grdlc_int_02",
    "grdlc_int_02_trailer_cave",
    "gunclub",
    "gunclubrange",
    "gunshop",
    "gunstore",
    "half_direct",
    "hangar_lightsmod",
    "heathaze",
    "heist_boat",
    "heist_boat_engineRoom",
    "heist_boat_norain",
    "heliGunCam",
    "helicamfirst",
    "hillstunnel",
    "hitped",
    "hud_def_Franklin",
    "hud_def_Michael",
    "hud_def_Trevor",
    "hud_def_blur",
    "hud_def_blur_switch",
    "hud_def_colorgrade",
    "hud_def_desat_Franklin",
    "hud_def_desat_Michael",
    "hud_def_desat_Neutral",
    "hud_def_desat_Trevor",
    "hud_def_desat_cold",
    "hud_def_desat_cold_kill",
    "hud_def_desat_switch",
    "hud_def_desatcrunch",
    "hud_def_flash",
    "hud_def_focus",
    "hud_def_lensdistortion",
    "hud_def_lensdistortion_subtle",
    "id1_11_tunnel",
    "impexp_interior_01_lift",
    "int_Barber1",
    "int_ClothesHi",
    "int_ControlTower_none",
    "int_ControlTower_small",
    "int_Farmhouse_none",
    "int_Farmhouse_small",
    "int_FranklinAunt_small",
    "int_GasStation",
    "int_Hospital2_DM",
    "int_Hospital_Blue",
    "int_Hospital_BlueB",
    "int_Hospital_DM",
    "int_Lost_none",
    "int_Lost_small",
    "int_amb_mult_large",
    "int_arena_01",
    "int_arena_Mod",
    "int_arena_Mod_garage",
    "int_arena_VIP",
    "int_carmod_small",
    "int_carrier_control",
    "int_carrier_control_2",
    "int_carrier_hanger",
    "int_carrier_rear",
    "int_carrier_stair",
    "int_carshowroom",
    "int_chopshop",
    "int_clean_extlight_large",
    "int_clean_extlight_none",
    "int_clean_extlight_small",
    "int_clotheslow_large",
    "int_cluckinfactory_none",
    "int_cluckinfactory_small",
    "int_dockcontrol_small",
    "int_extlght_sm_cntrst",
    "int_extlight_large",
    "int_extlight_large_fog",
    "int_extlight_none",
    "int_extlight_none_dark",
    "int_extlight_none_dark_fog",
    "int_extlight_none_fog",
    "int_extlight_small",
    "int_extlight_small_clipped",
    "int_extlight_small_fog",
    "int_hanger_none",
    "int_hanger_small",
    "int_hospital_dark",
    "int_hospital_small",
    "int_lesters",
    "int_methlab_small",
    "int_motelroom",
    "int_office_Lobby",
    "int_office_LobbyHall",
    "int_tattoo",
    "int_tattoo_B",
    "int_tunnel_none_dark",
    "interior_WATER_lighting",
    "introblue",
    "jewel_gas",
    "jewel_optim",
    "jewelry_entrance",
    "jewelry_entrance_INT",
    "jewelry_entrance_INT_fog",
    "lab_none",
    "lab_none_dark",
    "lab_none_dark_OVR",
    "lab_none_dark_fog",
    "lab_none_exit",
    "lab_none_exit_OVR",
    "li",
    "lightning",
    "lightning_cloud",
    "lightning_strong",
    "lightning_weak",
    "lightpolution",
    "lodscaler",
    "maxlodscaler",
    "metro",
    "micheal",
    "micheals_lightsOFF",
    "michealspliff",
    "michealspliff_blend",
    "michealspliff_blend02",
    "militarybase_nightlight",
    "mineshaft",
    "morebloom",
    "morgue_dark",
    "morgue_dark_ovr",
    "mp_battle_int01",
    "mp_battle_int01_dancefloor",
    "mp_battle_int01_dancefloor_OFF",
    "mp_battle_int01_entry",
    "mp_battle_int01_garage",
    "mp_battle_int01_office",
    "mp_battle_int02",
    "mp_battle_int03",
    "mp_battle_int03_tint1",
    "mp_battle_int03_tint2",
    "mp_battle_int03_tint3",
    "mp_battle_int03_tint4",
    "mp_battle_int03_tint5",
    "mp_battle_int03_tint6",
    "mp_battle_int03_tint7",
    "mp_battle_int03_tint8",
    "mp_battle_int03_tint9",
    "mp_bkr_int01_garage",
    "mp_bkr_int01_small_rooms",
    "mp_bkr_int01_transition",
    "mp_bkr_int02_garage",
    "mp_bkr_int02_hangout",
    "mp_bkr_int02_small_rooms",
    "mp_bkr_ware01",
    "mp_bkr_ware02_dry",
    "mp_bkr_ware02_standard",
    "mp_bkr_ware02_upgrade",
    "mp_bkr_ware03_basic",
    "mp_bkr_ware03_upgrade",
    "mp_bkr_ware04",
    "mp_bkr_ware05",
    "mp_exec_office_01",
    "mp_exec_office_02",
    "mp_exec_office_03",
    "mp_exec_office_03C",
    "mp_exec_office_03_blue",
    "mp_exec_office_04",
    "mp_exec_office_05",
    "mp_exec_office_06",
    "mp_exec_warehouse_01",
    "mp_gr_int01_black",
    "mp_gr_int01_grey",
    "mp_gr_int01_white",
    "mp_h_05",
    "mp_h_07",
    "mp_h_08",
    "mp_imx_intwaremed",
    "mp_imx_intwaremed_office",
    "mp_imx_mod_int_01",
    "mp_lad_day",
    "mp_lad_judgment",
    "mp_lad_night",
    "mp_nightshark_shield_fp",
    "mp_smg_int01_han",
    "mp_smg_int01_han_blue",
    "mp_smg_int01_han_red",
    "mp_smg_int01_han_yellow",
    "mp_x17dlc_base",
    "mp_x17dlc_base_dark",
    "mp_x17dlc_base_darkest",
    "mp_x17dlc_facility",
    "mp_x17dlc_facility2",
    "mp_x17dlc_facility_conference",
    "mp_x17dlc_in_sub",
    "mp_x17dlc_in_sub_no_reflection",
    "mp_x17dlc_int_01",
    "mp_x17dlc_int_01_tint1",
    "mp_x17dlc_int_01_tint2",
    "mp_x17dlc_int_01_tint3",
    "mp_x17dlc_int_01_tint4",
    "mp_x17dlc_int_01_tint5",
    "mp_x17dlc_int_01_tint6",
    "mp_x17dlc_int_01_tint7",
    "mp_x17dlc_int_01_tint8",
    "mp_x17dlc_int_01_tint9",
    "mp_x17dlc_int_02",
    "mp_x17dlc_int_02_hangar",
    "mp_x17dlc_int_02_outdoor_intro_camera",
    "mp_x17dlc_int_02_tint1",
    "mp_x17dlc_int_02_tint2",
    "mp_x17dlc_int_02_tint3",
    "mp_x17dlc_int_02_tint4",
    "mp_x17dlc_int_02_tint5",
    "mp_x17dlc_int_02_tint6",
    "mp_x17dlc_int_02_tint7",
    "mp_x17dlc_int_02_tint8",
    "mp_x17dlc_int_02_tint9",
    "mp_x17dlc_int_02_vehicle_avenger_camera",
    "mp_x17dlc_int_02_vehicle_workshop_camera",
    "mp_x17dlc_int_02_weapon_avenger_camera",
    "mp_x17dlc_int_silo",
    "mp_x17dlc_int_silo_escape",
    "mp_x17dlc_lab",
    "mp_x17dlc_lab_loading_bay",
    "mugShot",
    "mugShot_lineup",
    "multiplayer_ped_fight",
    "nervousRON_fog",
    "new_MP_Garage_L",
    "new_bank",
    "new_stripper_changing",
    "new_tunnels_entrance",
    "nextgen",
    "nightvision",
    "overwater",
    "paleto_nightlight",
    "paleto_opt",
    "phone_cam",
    "phone_cam1",
    "phone_cam10",
    "phone_cam11",
    "phone_cam12",
    "phone_cam13",
    "phone_cam2",
    "phone_cam3",
    "phone_cam3_REMOVED",
    "phone_cam4",
    "phone_cam5",
    "phone_cam6",
    "phone_cam7",
    "phone_cam8",
    "phone_cam8_REMOVED",
    "phone_cam9",
    "plane_inside_mode",
    "player_transition",
    "player_transition_no_scanlines",
    "player_transition_scanlines",
    "plaza_carpark",
    "polluted",
    "poolsidewaterreflection2",
    "powerplant_nightlight",
    "powerstation",
    "prison_nightlight",
    "projector",
    "prologue",
    "prologue_ending_fog",
    "prologue_ext_art_amb",
    "prologue_reflection_opt",
    "prologue_shootout",
    "pulse",
    "ranch",
    "reducelightingcost",
    "reducewaterREF",
    "refit",
    "reflection_correct_ambient",
    "resvoire_reflection",
    "rply_brightness",
    "rply_brightness_neg",
    "rply_contrast",
    "rply_contrast_neg",
    "rply_motionblur",
    "rply_saturation",
    "rply_saturation_neg",
    "rply_vignette",
    "rply_vignette_neg",
    "sandyshore_nightlight",
    "scanline_cam",
    "scanline_cam_cheap",
    "scope_zoom_in",
    "scope_zoom_out",
    "secret_camera",
    "services_nightlight",
    "shades_pink",
    "shades_yellow",
    "ship_explosion_underwater",
    "ship_lighting",
    "sleeping",
    "spectator1",
    "spectator10",
    "spectator2",
    "spectator3",
    "spectator4",
    "spectator5",
    "spectator6",
    "spectator7",
    "spectator8",
    "spectator9",
    "stc_coroners",
    "stc_deviant_bedroom",
    "stc_deviant_lounge",
    "stc_franklinsHouse",
    "stc_trevors",
    "stoned",
    "stoned_aliens",
    "stoned_cutscene",
    "stoned_monkeys",
    "subBASE_water_ref",
    "sunglasses",
    "superDARK",
    "switch_cam_1",
    "switch_cam_2",
    "telescope",
    "torpedo",
    "traffic_skycam",
    "trailer_explosion_optimise",
    "trevorspliff",
    "trevorspliff_blend",
    "trevorspliff_blend02",
    "tunnel_entrance",
    "tunnel_entrance_INT",
    "tunnel_id1_11",
    "ufo",
    "ufo_deathray",
    "underwater",
    "underwater_deep",
    "underwater_deep_clear",
    "v_abattoir",
    "v_bahama",
    "v_cashdepot",
    "v_dark",
    "v_foundry",
    "v_janitor",
    "v_jewel2",
    "v_metro",
    "v_michael",
    "v_michael_lounge",
    "v_recycle",
    "v_rockclub",
    "v_strip3",
    "v_strpchangerm",
    "v_sweat",
    "v_sweat_NoDirLight",
    "v_sweat_entrance",
    "v_torture",
    "vagos_extlight_small",
    "vehicle_subint",
    "venice_canal_tunnel",
    "vespucci_garage",
    "warehouse",
    "whitenightlighting",
    "winning_room",
    "yacht_DLC",
    "yell_tunnel_nodirect"
}
local e = 1
local f = {}
for g = 0.1, 2.00, 0.1 do
    table.insert(f, g)
end
local h = {
    "DEATH_FAIL_IN_EFFECT_SHAKE",
    "DRUNK_SHAKE",
    "FAMILY5_DRUG_TRIP_SHAKE",
    "HAND_SHAKE",
    "JOLT_SHAKE",
    "LARGE_EXPLOSION_SHAKE",
    "MEDIUM_EXPLOSION_SHAKE",
    "SMALL_EXPLOSION_SHAKE",
    "ROAD_VIBRATION_SHAKE",
    "SKY_DIVING_SHAKE",
    "VIBRATE_SHAKE",
    "KILL_SHOT_SHAKE"
}
local i = {}
for g = 1, 135, 1 do
    table.insert(i, g)
end
local j = {"Static Camera", "Interpolation Camera"}
local k = {"Curved", "Smooth"}
local l = {["Smooth"] = 0, ["Curved"] = 5}
local m = {}
local n = ""
local o = false
local p = false
local q = 1
local r
local s
local t
local u = false
local v = false
local w = ""
local x = 1
local y = 1
local z = ""
local A
local B = 1
local C = false
local D = {}
local E = 0
for g = 0, 23 do
    D[g] = g
end
local F = {}
for g = 0, 59 do
    F[g] = g
end
local G = 0
local H = {}
for g = 0, 59 do
    H[g] = g
end
local I = 0
local J = {}
for g = 1, 300, 1 do
    J[g] = (g - 1) * 10 + 0.001
end
local K = 1
local L = 1
local M = 1
local N = 1
local O = {
    "EXTRASUNNY",
    "CLEAR",
    "NEUTRAL",
    "SMOG",
    "FOGGY",
    "OVERCAST",
    "CLOUDS",
    "CLEARING",
    "RAIN",
    "THUNDER",
    "SNOW",
    "BLIZZARD",
    "SNOWLIGHT",
    "XMAS",
    "HALLOWEEN"
}
local P = 1
Citizen.CreateThread(
    function()
        m = json.decode(GetResourceKvpString("corrupt_scenedata") or "{}")
    end
)
RegisterNetEvent(
    "CORRUPT:openCinematicMenu",
    function()
        a(true)
    end
)
function CORRUPT.createCinematicScene(Q)
    m[Q] = {}
    SetResourceKvp("corrupt_scenedata", json.encode(m))
    tvRP.notify("~g~Scene created & saved.")
end
function CORRUPT.deleteCinematicScene(Q)
    m[Q] = nil
    SetResourceKvp("corrupt_scenedata", json.encode(m))
    tvRP.notify("~g~Scene deleted & saved.")
end
function CORRUPT.createCamera(Q, R)
    if #m[Q] == 0 then
        R.transition = 100
    end
    table.insert(m[Q], R)
    q = #m[Q]
    if m[n][q].type == "Static Camera" then
        x = 1
    elseif m[n][q].type == "Interpolation Camera" then
        x = 2
    end
    if m[n][q].blending == 0 then
        y = 2
    elseif m[n][q].blending == 5 then
        y = 1
    end
    SetResourceKvp("corrupt_scenedata", json.encode(m))
    tvRP.notify("~g~Camera created & saved.")
end
function CORRUPT.modifyCamera(Q, R, S)
    m[Q][S] = R
    SetResourceKvp("corrupt_scenedata", json.encode(m))
    tvRP.notify("~g~Camera modified & saved.")
end
function CORRUPT.deleteCamera(Q, T)
    table.remove(m[Q], T)
    SetResourceKvp("corrupt_scenedata", json.encode(m))
    tvRP.notify("~g~Camera deleted & saved.")
end
function CORRUPT.modifyTransition(n, q, U)
    m[n][q].transition = tonumber(U)
    SetResourceKvp("corrupt_scenedata", json.encode(m))
    tvRP.notify("~g~Transition change saved.")
end
function CORRUPT.modifyCameraBlending(n, q, V)
    m[n][q].blending = l[V]
    SetResourceKvp("corrupt_scenedata", json.encode(m))
    tvRP.notify("~g~Camera Blending change saved.")
end
function CORRUPT.modifyScreeneffect(n, q, W)
    m[n][q].screeneffect = W
    SetResourceKvp("corrupt_scenedata", json.encode(m))
    tvRP.notify("~g~Screeneffect change saved.")
end
function CORRUPT.modifyTimecycleEffect(n, q, X)
    m[n][q].timecycleEffect = X
    SetResourceKvp("corrupt_scenedata", json.encode(m))
    tvRP.notify("~g~Timecycle Effect change saved.")
end
function CORRUPT.setTimecycleIntensity(n, q, f)
    m[n][q].timecycleIntensity = f
    SetResourceKvp("corrupt_scenedata", json.encode(m))
    tvRP.notify("~g~Timecycle intensity change saved.")
end
function CORRUPT.modifyShakeEffect(n, q, Y)
    m[n][q].shake = Y
    SetResourceKvp("corrupt_scenedata", json.encode(m))
    tvRP.notify("~g~Shake change saved.")
end
function CORRUPT.modifyCameraType(n, q, type)
    m[n][q].type = type
    SetResourceKvp("corrupt_scenedata", json.encode(m))
    tvRP.notify("~g~Camera type change saved.")
end
function CORRUPT.addCameraFocus(n, q, Z, _)
    m[n][q].focusType = Z
    m[n][q].focusData = _
    SetResourceKvp("corrupt_scenedata", json.encode(m))
    tvRP.notify("~g~Follow player change saved.")
end
function CORRUPT.setCameraFov(n, q)
    m[n][q].fov = i[B]
    SetResourceKvp("corrupt_scenedata", json.encode(m))
    tvRP.notify("~g~FOV change saved.")
end
local function a0(S, a1)
    if a1.position == nil then
        m[n][S].position = GetEntityCoords(PlayerPedId())
    end
    if a1.rotation == nil then
        m[n][S].rotation = GetGameplayCamRot(0)
    end
    if a1.transition == nil then
        m[n][S].transition = 5000
    end
    if a1.type == nil then
        m[n][S].type = w
    end
    if a1.screeneffect == nil then
        m[n][S].screeneffect = ""
    end
    if a1.timecycleEffect == nil then
        m[n][S].timecycleEffect = ""
    end
    if a1.timecycleIntensity == nil then
        m[n][S].timecycleIntensity = 1.0
    end
    if a1.focusType == nil then
        m[n][S].focusType = ""
    end
    if a1.focusData == nil then
        m[n][S].focusData = 0
    end
    if a1.shake == nil then
        m[n][S].shake = ""
    end
    if a1.fov == nil then
        m[n][S].fov = 65.0
    end
end
RageUI.CreateWhile(
    1.0,
    RMenu:Get("mainmenu", "cinematic"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("mainmenu", "cinematic"),
            true,
            true,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "Create Scene",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(a2, a3, a4)
                        if a4 then
                            local Q = getSearchField("Scene Name")
                            if Q ~= "" then
                                CORRUPT.createCinematicScene(Q)
                            end
                        end
                    end,
                    RMenu:Get("mainmenu", "cinematic")
                )
                RageUI.ButtonWithStyle(
                    "Load Scene",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(a2, a3, a4)
                    end,
                    RMenu:Get("load_scene", "cinematic")
                )
                RageUI.ButtonWithStyle(
                    "Weather/Time Editor",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(a2, a3, a4)
                    end,
                    RMenu:Get("weather_time_manager", "cinematic")
                )
                RageUI.ButtonWithStyle(
                    "Delete Scene",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(a2, a3, a4)
                        if a4 then
                            local Q = getSearchField("Scene Name")
                            if Q ~= "" then
                                CORRUPT.deleteCinematicScene(Q)
                            end
                        end
                    end,
                    RMenu:Get("mainmenu", "cinematic")
                )
                local function a5()
                    ExecuteCommand("hideui")
                    u = true
                end
                local function a6()
                    ExecuteCommand("showui")
                    u = false
                end
                RageUI.Checkbox(
                    "Hide UI",
                    "",
                    u,
                    {Style = RageUI.CheckboxStyle.Car},
                    function(a2, a4, a3, a7)
                    end,
                    a5,
                    a6
                )
                local function a5()
                    ExecuteCommand("hideids")
                    v = true
                end
                local function a6()
                    ExecuteCommand("showids")
                    v = false
                end
                RageUI.Checkbox(
                    "Hide IDs",
                    "",
                    v,
                    {Style = RageUI.CheckboxStyle.Car},
                    function(a2, a4, a3, a7)
                    end,
                    a5,
                    a6
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("load_scene", "cinematic"),
            true,
            true,
            true,
            function()
                for Q, a8 in pairs(m) do
                    RageUI.ButtonWithStyle(
                        Q,
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(a2, a3, a4)
                            if a4 then
                                n = Q
                            end
                        end,
                        RMenu:Get("scene_manager", "cinematic")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("scene_manager", "cinematic"),
            true,
            true,
            true,
            function()
                RageUI.BackspaceMenuCallback(
                    function()
                        previewingCamera = nil
                        unpreviewFromCamera()
                    end
                )
                RageUI.ButtonWithStyle(
                    "Play Scene",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(a2, a3, a4)
                        if a3 then
                            previewingCamera = nil
                            unpreviewFromCamera()
                        end
                        if a4 then
                            a(false)
                            renderCinematicScene(n)
                        end
                    end,
                    RMenu:Get("scene_manager", "cinematic")
                )
                RageUI.ButtonWithStyle(
                    "[Add Camera]",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(a2, a3, a4)
                        if a3 then
                            previewingCamera = nil
                            unpreviewFromCamera()
                        end
                        if a4 then
                        end
                    end,
                    RMenu:Get("add_camera", "cinematic")
                )
                if type(m[n]) == "table" then
                    for S, a1 in pairs(m[n]) do
                        a0(S, a1)
                        RageUI.ButtonWithStyle(
                            "Camera " .. S,
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(a2, a3, a4)
                                if a3 then
                                    previewingCamera = S
                                    if not DoesCamExist(r) then
                                        print("Creating cam because it doesn't exist")
                                        r = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
                                        SetCamActive(r, true)
                                        RenderScriptCams(true, true, 500, 1, 0)
                                    end
                                end
                                if a4 then
                                    q = S
                                    if m[n][q].type == "Static Camera" then
                                        x = 1
                                    elseif m[n][q].type == "Interpolation Camera" then
                                        x = 2
                                    end
                                    if m[n][q].blending == 0 then
                                        y = 2
                                    elseif m[n][q].blending == 5 then
                                        y = 1
                                    end
                                end
                            end,
                            RMenu:Get("camera_manager", "cinematic")
                        )
                    end
                else
                    print("failed, loaded scene was not a table?")
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("camera_manager", "cinematic"),
            true,
            true,
            true,
            function()
                RageUI.BackspaceMenuCallback(
                    function()
                        previewingCamera = nil
                        unpreviewFromCamera()
                    end
                )
                if q and m[n][q] then
                    RMenu:Get("camera_manager", "cinematic"):SetSubtitle("~b~" .. m[n][q].type)
                    RageUI.ButtonWithStyle(
                        "~b~Transition: " .. m[n][q].transition .. "ms",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(a2, a3, a4)
                            if a4 then
                                local U = getSearchField("Transition(in ms):")
                                if tonumber(U) then
                                    CORRUPT.modifyTransition(n, q, U)
                                else
                                    tvRP.notify("~r~Failed to change transition time.")
                                end
                            end
                        end,
                        RMenu:Get("camera_manager", "cinematic")
                    )
                    RageUI.ButtonWithStyle(
                        "Move Camera",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(a2, a3, a4)
                            if a4 then
                                if not o and not p then
                                    previewingCamera = nil
                                    t = GetEntityCoords(PlayerPedId())
                                    unpreviewFromCamera()
                                    tvRP.toggleNoclip()
                                    p = q
                                end
                            end
                        end,
                        RMenu:Get("camera_manager", "cinematic")
                    )
                    RageUI.List(
                        "Camera Type:",
                        j,
                        x,
                        "",
                        {},
                        true,
                        function(a2, a3, a4, a9)
                            if a9 ~= x then
                                x = a9
                                CORRUPT.modifyCameraType(n, q, j[x])
                            end
                        end,
                        function()
                        end,
                        nil
                    )
                    RageUI.List(
                        "Camera Blending:",
                        k,
                        y,
                        "",
                        {},
                        true,
                        function(a2, a3, a4, a9)
                            if a9 ~= y then
                                y = a9
                                CORRUPT.modifyCameraBlending(n, q, k[y])
                            end
                        end,
                        function()
                        end,
                        nil
                    )
                    RageUI.ButtonWithStyle(
                        "Select Camera Focus",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(a2, a3, a4)
                        end,
                        RMenu:Get("camera_focus_manager", "cinematic")
                    )
                    RageUI.ButtonWithStyle(
                        "Screen Effect: " .. (m[n][q].screeneffect or "N/A"),
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(a2, a3, a4)
                        end,
                        RMenu:Get("screeneffect_manager", "cinematic")
                    )
                    RageUI.List(
                        "Timecycle Intensity",
                        f,
                        e,
                        "",
                        {},
                        true,
                        function(a2, a3, a4, a9)
                            RageUI.BackspaceMenuCallback(
                                function()
                                    ClearTimecycleModifier()
                                end
                            )
                            if a9 ~= e then
                                e = a9
                                if m[n][q].timecycleEffect ~= "" then
                                    SetTimecycleModifier(m[n][q].timecycleEffect)
                                    SetTimecycleModifierStrength(m[n][q].timecycleIntensity)
                                    CORRUPT.setTimecycleIntensity(n, q, f[e])
                                end
                            end
                        end,
                        function()
                        end,
                        nil
                    )
                    RageUI.ButtonWithStyle(
                        "Timecycle Effect: " .. (m[n][q].timecycleEffect or "N/A"),
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(a2, a3, a4)
                        end,
                        RMenu:Get("timecycle_manager", "cinematic")
                    )
                    RageUI.ButtonWithStyle(
                        "Shake Effect: " .. (m[n][q].shake or "N/A"),
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(a2, a3, a4)
                        end,
                        RMenu:Get("shake_manager", "cinematic")
                    )
                    RageUI.List(
                        "Field of View (FOV)",
                        i,
                        B,
                        "",
                        {},
                        true,
                        function(a2, a3, a4, a9)
                            if a9 ~= B then
                                B = a9
                                CORRUPT.setCameraFov(n, q)
                            end
                        end,
                        function()
                        end,
                        nil
                    )
                    RageUI.ButtonWithStyle(
                        "Remove Camera",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(a2, a3, a4)
                            if a4 then
                                CORRUPT.deleteCamera(n, q)
                                previewingCamera = nil
                                unpreviewFromCamera()
                                q = nil
                            end
                        end,
                        RMenu:Get("camera_manager", "cinematic")
                    )
                else
                    RageUI.Separator("~r~No Camera ID selected.")
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("add_camera", "cinematic"),
            true,
            true,
            true,
            function()
                RageUI.BackspaceMenuCallback(
                    function()
                    end
                )
                RageUI.ButtonWithStyle(
                    "Add Static Camera",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(a2, a3, a4)
                        if a4 then
                            if o then
                                notify("~r~Can not add a camera whilst you are adding a camera.")
                                return
                            end
                            previewingCamera = nil
                            t = GetEntityCoords(PlayerPedId())
                            unpreviewFromCamera()
                            tvRP.toggleNoclip()
                            o = true
                            w = "Static Camera"
                        end
                    end,
                    RMenu:Get("camera_manager", "cinematic")
                )
                RageUI.ButtonWithStyle(
                    "Add Interpolation Camera",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(a2, a3, a4)
                        if a4 then
                            if o then
                                notify("~r~Can not add a camera whilst you are adding a camera.")
                                return
                            end
                            previewingCamera = nil
                            t = GetEntityCoords(PlayerPedId())
                            unpreviewFromCamera()
                            tvRP.toggleNoclip()
                            o = true
                            w = "Interpolation Camera"
                        end
                    end,
                    RMenu:Get("camera_manager", "cinematic")
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("screeneffect_manager", "cinematic"),
            true,
            true,
            true,
            function()
                RageUI.BackspaceMenuCallback(
                    function()
                        AnimpostfxStopAll()
                    end
                )
                for g = 1, #c do
                    RageUI.ButtonWithStyle(
                        c[g],
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(a2, a3, a4)
                            if a3 then
                                AnimpostfxStopAll()
                                if c[g] ~= "Default" then
                                    AnimpostfxPlay(c[g], 5000, false)
                                end
                            end
                            if a4 then
                                CORRUPT.modifyScreeneffect(n, q, c[g])
                            end
                        end,
                        RMenu:Get("camera_manager", "cinematic")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("timecycle_manager", "cinematic"),
            true,
            true,
            true,
            function()
                RageUI.BackspaceMenuCallback(
                    function()
                        ClearTimecycleModifier()
                    end
                )
                for g = 1, #d do
                    RageUI.ButtonWithStyle(
                        d[g],
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(a2, a3, a4)
                            if a3 then
                                ClearTimecycleModifier()
                                if d[g] ~= "Default" then
                                    SetTimecycleModifier(d[g])
                                end
                            end
                            if a4 then
                                CORRUPT.modifyTimecycleEffect(n, q, d[g])
                            end
                        end,
                        RMenu:Get("camera_manager", "cinematic")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("shake_manager", "cinematic"),
            true,
            true,
            true,
            function()
                RageUI.BackspaceMenuCallback(
                    function()
                        AnimpostfxStopAll()
                    end
                )
                for g = 1, #h do
                    RageUI.ButtonWithStyle(
                        h[g],
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(a2, a3, a4)
                            if a3 then
                                if z == "" or z ~= h[g] then
                                    z = h[g]
                                    SetTimeout(
                                        25000,
                                        function()
                                            z = ""
                                        end
                                    )
                                    ShakeCam(GetRenderingCam(), h[g], 1.0)
                                end
                            end
                            if a4 then
                                CORRUPT.modifyShakeEffect(n, q, h[g])
                            end
                        end,
                        RMenu:Get("camera_manager", "cinematic")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("camera_focus_manager", "cinematic"),
            true,
            true,
            true,
            function()
                RageUI.BackspaceMenuCallback(
                    function()
                        AnimpostfxStopAll()
                    end
                )
                RageUI.Separator("~b~Currently pointed at: " .. m[n][q].focusType .. " : " .. m[n][q].focusData)
                RageUI.ButtonWithStyle(
                    "Player",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(a2, a3, a4)
                        if a4 then
                            local aa = getSearchField("Temp ID:")
                            if aa ~= "" then
                                CORRUPT.addCameraFocus(n, q, "player", aa)
                            end
                        end
                    end,
                    RMenu:Get("camera_manager", "cinematic")
                )
                RageUI.ButtonWithStyle(
                    "Coordinates",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(a2, a3, a4)
                        if a4 then
                            CORRUPT.clientPrompt(
                                "Enter coordinates:",
                                "",
                                function(ab)
                                    local ac = {}
                                    for ad in string.gmatch(
                                        ab:gsub('" y="', ","):gsub('" z="', ",") or "0,0,0",
                                        "[^,]+"
                                    ) do
                                        table.insert(ac, tonumber(ad))
                                    end
                                    if ab == "" then
                                        return
                                    end
                                    local ae, af, ag = 0, 0, 0
                                    if ac[1] ~= nil then
                                        ae = ac[1]
                                    end
                                    if ac[2] ~= nil then
                                        af = ac[2]
                                    end
                                    if ac[3] ~= nil then
                                        ag = ac[3]
                                    end
                                    CORRUPT.addCameraFocus(n, q, "coord", vector3(ae, af, ag))
                                end
                            )
                        end
                    end,
                    RMenu:Get("camera_manager", "cinematic")
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("dof_manager", "cinematic"),
            true,
            true,
            true,
            function()
                RageUI.BackspaceMenuCallback(
                    function()
                    end
                )
                RageUI.Separator("~g~These settings require some fiddling to get the desired result.")
                RageUI.List(
                    "Near Plane Out",
                    J,
                    K,
                    "",
                    {},
                    true,
                    function(a2, a3, a4, a9)
                        if a9 ~= K then
                            K = a9
                            SetHidofOverride(1, 1, J[K], J[L], J[M], J[N])
                        end
                    end,
                    function()
                    end,
                    nil
                )
                RageUI.List(
                    "Near Plane In",
                    J,
                    L,
                    "",
                    {},
                    true,
                    function(a2, a3, a4, a9)
                        if a9 ~= L then
                            L = a9
                            SetHidofOverride(1, 1, J[K], J[L], J[M], J[N])
                        end
                    end,
                    function()
                    end,
                    nil
                )
                RageUI.List(
                    "Far Plane Out",
                    J,
                    M,
                    "",
                    {},
                    true,
                    function(a2, a3, a4, a9)
                        if a9 ~= M then
                            M = a9
                            SetHidofOverride(1, 1, J[K], J[L], J[M], J[N])
                        end
                    end,
                    function()
                    end,
                    nil
                )
                RageUI.List(
                    "Far Plane In",
                    J,
                    N,
                    "",
                    {},
                    true,
                    function(a2, a3, a4, a9)
                        if a9 ~= N then
                            N = a9
                            SetHidofOverride(1, 1, J[K], J[L], J[M], J[N])
                        end
                    end,
                    function()
                    end,
                    nil
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("weather_time_manager", "cinematic"),
            true,
            true,
            true,
            function()
                RageUI.BackspaceMenuCallback(
                    function()
                    end
                )
                local function a5()
                    C = true
                    CORRUPT.overrideTime(D[E], F[G], H[I])
                end
                local function a6()
                    C = false
                    CORRUPT.cancelOverrideTimeWeather()
                end
                RageUI.Checkbox(
                    "Override Weather/Time",
                    "",
                    C,
                    {Style = RageUI.CheckboxStyle.Car},
                    function(a2, a4, a3, a7)
                        C = a7
                    end,
                    a5,
                    a6
                )
                RageUI.List(
                    "Hours",
                    D,
                    E,
                    "",
                    {},
                    true,
                    function(a2, a3, a4, a9)
                        if a9 ~= E then
                            E = a9
                            if C then
                                CORRUPT.overrideTime(D[E], F[G], H[I])
                            end
                        end
                    end,
                    function()
                    end,
                    nil
                )
                RageUI.List(
                    "Minutes",
                    F,
                    G,
                    "",
                    {},
                    true,
                    function(a2, a3, a4, a9)
                        if a9 ~= G then
                            G = a9
                            if C then
                                CORRUPT.overrideTime(D[E], F[G], H[I])
                            end
                        end
                    end,
                    function()
                    end,
                    nil
                )
                RageUI.List(
                    "Seconds",
                    H,
                    I,
                    "",
                    {},
                    true,
                    function(a2, a3, a4, a9)
                        if a9 ~= I then
                            I = a9
                            if C then
                                CORRUPT.overrideTime(D[E], F[G], H[I])
                            end
                        end
                    end,
                    function()
                    end,
                    nil
                )
                RageUI.List(
                    "Weather",
                    O,
                    P,
                    "",
                    {},
                    true,
                    function(a2, a3, a4, a9)
                        if a9 ~= P then
                            P = a9
                            if C then
                                CORRUPT.setWeather(O[P])
                            end
                        end
                    end,
                    function()
                    end,
                    nil
                )
            end,
            function()
            end
        )
    end
)
function unpreviewFromCamera()
    if r then
        DestroyCam(r, 0)
        RenderScriptCams(0, 0, 1, 1, 1)
    end
    ClearFocus()
end
Citizen.CreateThread(
    function()
        DecorRegister("cinematicMode", 2)
        while true do
            local ah = PlayerPedId()
            if C then
                if A == nil and not globalHideUi then
                    drawNativeText("~r~CINEMATIC MODE ENABLED")
                end
                if not DecorExistOn(ah, "cinematicMode") then
                    DecorSetBool(ah, "cinematicMode", true)
                end
            end
            if (o or p) and noclipActive and CORRUPT.getPlayerVehicle() ~= 0 then
                tvRP.notify("~r~You may not noclip when in a vehicle.")
                tvRP.toggleNoclip()
            end
            if o and noclipActive then
                drawNativeText("~g~Press [SPACEBAR] to confirm camera placement.")
                if IsControlJustPressed(0, 22) then
                    local R = {
                        position = GetEntityCoords(ah),
                        rotation = GetGameplayCamRot(0),
                        transition = 5000,
                        type = w,
                        screeneffect = "",
                        timecycleEffect = "",
                        timecycleIntensity = 1.0,
                        focusType = "",
                        focusData = 0,
                        shake = "",
                        fov = 65.0
                    }
                    CORRUPT.createCamera(n, R)
                    tvRP.toggleNoclip()
                    o = false
                    SetEntityCoords(PlayerPedId(), t)
                end
            end
            if p and noclipActive then
                drawNativeText("~g~Press [SPACEBAR] to confirm camera placement.")
                if IsControlJustPressed(0, 22) then
                    local R = {
                        position = GetEntityCoords(ah),
                        rotation = GetGameplayCamRot(0),
                        transition = m[n][p].transition,
                        type = m[n][p].type,
                        screeneffect = m[n][p].screeneffect,
                        timecycleEffect = m[n][p].timecycleEffect,
                        timecycleIntensity = m[n][p].timecycleIntensity,
                        focusType = m[n][p].focusType,
                        focusData = m[n][p].focusData,
                        shake = m[n][p].shake,
                        fov = m[n][p].fov or 65.0
                    }
                    CORRUPT.modifyCamera(n, R, p)
                    tvRP.toggleNoclip()
                    p = false
                    SetEntityCoords(PlayerPedId(), t)
                end
            end
            if previewingCamera ~= nil then
                local a1 = m[n][previewingCamera]
                SetFocusPosAndVel(a1.position.x, a1.position.y, a1.position.z)
                SetCamCoord(r, a1.position.x, a1.position.y, a1.position.z)
                SetCamRot(r, a1.rotation.x, a1.rotation.y, a1.rotation.z)
                SetCamFov(r, (a1.fov or 65.0) + 0.001)
            end
            if A ~= nil then
                local ai = GetCamCoord(A)
                SetFocusPosAndVel(ai.x, ai.y, ai.z)
            end
            Wait(0)
        end
    end
)
function renderCinematicScene(Q)
    Citizen.CreateThread(
        function()
            clearNativeText()
            if s then
                DestroyCam(s, 0)
                RenderScriptCams(0, 0, 1, 1, 1)
            end
            if not DoesCamExist(s) then
                s = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
                SetCamActive(s, true)
                RenderScriptCams(true, true, 0, 1, 0)
            end
            print("initiating render")
            local aj
            for S, a1 in pairs(m[Q]) do
                A =
                    CreateCameraWithParams(
                    "DEFAULT_SCRIPTED_CAMERA",
                    a1.position.x,
                    a1.position.y,
                    a1.position.z,
                    a1.rotation.x,
                    a1.rotation.y,
                    a1.rotation.z,
                    (a1.fov or 65.0) + 0.001,
                    0,
                    2
                )
                if a1.type == "Static Camera" then
                    SetCamActive(A, true)
                elseif a1.type == "Interpolation Camera" then
                    SetCamActiveWithInterp(A, aj, a1.transition, a1.blending or 5, a1.blending or 5)
                end
                if a1.focusType ~= "" then
                    if a1.focusType == "player" then
                        local ak = GetPlayerPed(a1.focusData)
                        if ak then
                            PointCamAtEntity(A, ak, 1, 1, 1, true)
                        else
                            print("[CORRUPT Cinematic] Failed to point cam at player, could not get entity.")
                        end
                    elseif a1.focusType == "coord" then
                        PointCamAtCoord(A, a1.focusData.x, a1.focusData.y, a1.focusData.z)
                    end
                end
                if a1.shake ~= "" then
                    ShakeCam(A, a1.shake, 1.0)
                end
                if a1.screeneffect ~= "Default" and a1.screeneffect ~= "" then
                    AnimpostfxPlay(a1.screeneffect, a1.transition, false)
                end
                if a1.timecycleEffect ~= "Default" and a1.timecycleEffect ~= "" then
                    SetTimecycleModifier(a1.timecycleEffect)
                    SetTimecycleModifierStrength(a1.timecycleIntensity)
                end
                aj = A
                Wait(a1.transition)
                AnimpostfxStopAll()
                ClearTimecycleModifier()
            end
            DestroyCam(A, 0)
            RenderScriptCams(0, 0, 1, 1, 1)
            A = nil
            DestroyCam(aj, 0)
            RenderScriptCams(0, 0, 1, 1, 1)
            ClearFocus()
        end
    )
end
local al = -1
RegisterCommand(
    "setlastvehicleon",
    function()
        local ah = PlayerPedId()
        if not IsPedInAnyVehicle(ah, true) and not IsControlPressed(0, 23) then
            local am = GetVehiclePedIsIn(ah, true)
            if am ~= 0 then
                SetVehicleEngineOn(am, true, true)
                al = am
            end
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            local am, an = CORRUPT.getPlayerVehicle()
            if am ~= 0 and am == al and an then
                SetVehicleEngineOn(am, false, true, true)
                al = -1
            end
            local ao = GetEntityAttachedTo(PlayerPedId())
            if ao ~= 0 and IsEntityAPed(ao) and IsPedAPlayer(ao) and not IsEntityVisible(ao) then
                local ap = NetworkGetPlayerIndexFromPed(ao)
                if ap ~= -1 then
                    local aq = GetPlayerServerId(ap)
                    if aq > 0 then
                        local ar = CORRUPT.clientGetUserIdFromSource(aq)
                        if not CORRUPT.clientGetPlayerIsStaff(ar) then
                            SetEntityVisible(PlayerPedId(), true, true)
                            DetachEntity(PlayerPedId(), true, true)
                        end
                    end
                end
            end
            Citizen.Wait(1000)
        end
    end
)
function getSearchField(a7)
    AddTextEntry("FMMC_MPM_NA", "Search by " .. a7)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Search by " .. a7, "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local a8 = GetOnscreenKeyboardResult()
        if a8 then
            return a8
        else
            return ""
        end
    end
    return ""
end
AddEventHandler(
    "lb-phone:toggleHud",
    function(as)
        if as then
            CORRUPT.hideUI()
        else
            CORRUPT.showUI()
        end
    end
)
