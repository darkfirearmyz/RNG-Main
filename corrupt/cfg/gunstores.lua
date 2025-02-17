local cfg = {}

cfg.GunStores={
    ["policeLargeArms"]={
        ["_config"]={{vector3(1840.6104736328,3691.4741210938,33.350730895996),vector3(461.43179321289,-982.66412353516,29.689668655396),vector3(-437.9034, 5988.211, 30.73618),vector3(-1102.5059814453,-820.62091064453,13.282785415649)},110,5,"MET Police Large Arms",{"police.onduty.permission","police.loadshop2"},false,true}, 
        ["WEAPON_FLASHBANG"]={"Flashbang",0,0,"N/A","w_ex_flashbang"},
        ["WEAPON_G36K"]={"G36K",0,0,"N/A","w_ar_g36k"}, 
        ["WEAPON_M4A1"]={"M4 Carbine",0,0,"N/A","w_ar_m4a1"}, 
        ["WEAPON_MP5"]={"MP5",0,0,"N/A","w_sb_mp5"},
        ["WEAPON_REMINGTON700"]={"Remington 700",0,0,"N/A","w_sr_remington700"}, 
        ["WEAPON_SIGMCX"]={"SigMCX",0,0,"N/A","w_ar_sigmcx"},
        ["WEAPON_SMOKEGRENADEARMAPD"]={"Smoke Grenade",0,0,"N/A","w_ex_smokegrenadearma"},
        ["WEAPON_SPAR17"]={"SPAR17",0,0,"N/A","w_ar_spar17"},
        ["WEAPON_STING"]={"Sting 9mm",0,0,"N/A","w_sb_sting"},
    },
    ["policeSmallArms"]={
        ["_config"]={{vector3(461.53082275391,-979.35876464844,29.689668655396),vector3(1842.9096679688,3690.7692871094,33.267082214355),vector3(-439.7851, 5992.254, 30.73618),vector3(-1104.5264892578,-821.70153808594,13.282785415649)},110,5,"MET Police Small Arms",{"police.onduty.permission"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
        ["WEAPON_PDGLOCK"]={"Glock",0,0,"N/A","w_pi_glock"},
        ["WEAPON_NIGHTSTICK"]={"Police Baton",0,0,"N/A","w_me_nightstick"},
        ["WEAPON_REMINGTON870"]={"Remington 870",0,0,"N/A","w_sg_remington870"},
        ["WEAPON_STAFFGUN"]={"Speed Gun",0,0,"N/A","w_pi_staffgun"},
        ["WEAPON_STUNGUN"]={"Tazer",0,0,"N/A","w_pi_stungun"},
        ["WEAPON_PAVA"]={"PAVA",0,0,"N/A","w_am_pava"},
        ["item|pd_armour_plate"]={"Police Armour Plate",100000,0,"N/A","prop_armour_pickup"},
    },
    ["prisonArmoury"]={
        ["_config"]={{vector3(1779.3741455078,2542.5639648438,44.8177828979)},110,5,"Prison Armoury",{"prisonguard.onduty.permission"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
        ["WEAPON_PDGLOCK"]={"Glock",0,0,"N/A","w_pi_glock"},
        ["WEAPON_NIGHTSTICK"]={"Police Baton",0,0,"N/A","w_me_nightstick"},
        ["WEAPON_NONLETHALSHOTGUN"]={"HMP NonLethal Shotgun",0,0,"N/A","w_sg_nonlethalmossberg"},
        ["WEAPON_STUNGUN"]={"Tazer",0,0,"N/A","w_pi_stungun"},
        ["WEAPON_PAVA"]={"PAVA",0,0,"N/A","w_am_pava"},
    },
    ["NHS"]={
        ["_config"]={{vector3(340.41757202148,-582.71209716797,27.973259765625),vector3(-435.27032470703,-318.29010009766,34.08971484375)},110,5,"NHS Armoury",{"nhs.onduty.permission"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
        ["WEAPON_PAVA"]={"PAVA",0,0,"N/A","w_am_pava"},
    },
    ["LFB"]={
        ["_config"]={{vector3(1210.193359375,-1484.1494140625,34.241326171875),vector3(216.63296508789,-1648.6680908203,29.0179375)},110,5,"LFB Armoury",{"lfb.onduty.permission"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
        ["WEAPON_FIREAXE"]={"Fireaxe",0,0,"N/A","w_me_fireaxe"},
        ["WEAPON_PAVA"]={"PAVA",0,0,"N/A","w_am_pava"},
    },
    ["VIP"]={
        ["_config"]={{vector3(-2151.6000976562,5192.17578125,15.715698242188)},110,5,"VIP Gun Store",{"vip.gunstore"},true},
        ["WEAPON_GOLDAK"]={"Golden AK-47",750000,0,"N/A","w_ar_goldak"},
        ["WEAPON_FIREEXTINGUISHER"]={"Fire Extinguisher",10000,0,"N/A","prop_fire_exting_1b"},
        ["WEAPON_MJOLNIR"]={"Mjlonir",10000,0,"N/A","w_me_mjolnir"},
        --["WEAPON_MOLOTOV"]={"Molotov Cocktail",5000,0,"N/A","w_ex_molotov"},
        ["WEAPON_SMOKEGRENADEARMA"]={"Smoke Grenade",5000,0,"N/A","w_ex_smokegrenadearma"},
        ["WEAPON_SNOWBALL"]={"Snowball",10000,0,"N/A","w_ex_snowball"},
        ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup",nil,25000},
        ["item2"]={"LVL 2 Armour",50000,0,"N/A","prop_bodyarmour_02",nil,50000},
        ["item3"]={"LVL 3 Armour",75000,0,"N/A","prop_bodyarmour_03"},
        ["item4"]={"LVL 4 Armour",100000,0,"N/A","prop_bodyarmour_04"},
        ["item|fillUpArmour"]={"Replenish Armour",100000,0,"N/A","prop_armour_pickup"},
    },
    ["Rebel"]={
        ["_config"]={{vector3(1545.2554931641,6331.5532226562,23.078569412231),vector3(4925.6259765625,-5243.0908203125,1.524599313736)},110,5,"Rebel Gun Store",{"rebellicense.whitelisted"},true},
        ["GADGET_PARACHUTE"]={"Parachute",1000,0,"N/A","p_parachute_s"},
        ["WEAPON_AK200"]={"AK-200",750000,0,"N/A","w_ar_akkal"},
        ["WEAPON_AKM"]={"AKM",700000,0,"N/A","w_ar_akm"},
        ["WEAPON_REVOLVER357"]={"Rebel Revolver",200000,0,"N/A","w_pi_revolver357"},
        ["WEAPON_SPAZ"]={"Spaz 12",400000,0,"N/A","w_sg_spaz"},
        ["WEAPON_WINCHESTER12"]={"Winchester 12",350000,0,"N/A","w_sg_winchester12"},
        ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup"},
        ["item2"]={"LVL 2 Armour",50000,0,"N/A","prop_bodyarmour_02"},
        ["item3"]={"LVL 3 Armour",75000,0,"N/A","prop_bodyarmour_03"},
        ["item4"]={"LVL 4 Armour",100000,0,"N/A","prop_bodyarmour_04"},
        ["item|fillUpArmour"]={"Replenish Armour",100000,0,"N/A","prop_armour_pickup"},
    },
    ["LargeArmsDealer"]={
        ["_config"]={{vector3(-1108.3199462891,4934.7392578125,217.35540771484),vector3(5065.6201171875,-4591.3857421875,1.8652405738831)},110,1,"Large Arms Dealer",{"gang.whitelisted"},false},
        ["WEAPON_AK74"]={"AK-74 Assault Rifle",750000,0,"N/A","w_ar_ak74",nil,750000},
        ["WEAPON_MOSIN"]={"Mosin Bolt-Action",950000,0,"N/A","w_ar_mosin",nil,950000},
        ["WEAPON_OLYMPIA"]={"Olympia Shotgun",400000,0,"N/A","w_sg_olympia",nil,400000},
        ["WEAPON_UMP45"]={"UMP-45",300000,0,"N/A","w_sb_ump45",nil,300000},
        ["WEAPON_UZI"]={"Uzi",250000,0,"N/A","w_sb_uzi",nil,250000},
        ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup",nil,25000},
        ["item2"]={"LVL 2 Armour",50000,0,"N/A","prop_bodyarmour_02",nil,50000},
    },
    ["CorruptDealer"]={ 
        ["_config"]={{vector3(-379.95166015625,6087.6396484375,39.608764648438),vector3(-254.10989379883,6322.03515625,39.659301757812)},110,1,"Corrupt Dealer",{""},true},
        ["WEAPON_SCORPIONBLUE"]={"Scorpion Blue",700000,0,"N/A","w_sb_scorpionblue"},
        --["armourplate"]={"Armour Plate",100000,0,"N/A","prop_armour_pickup"},
        ["WEAPON_MOSIN"]={"Mosin Bolt-Action",1000000,0,"N/A","w_ar_mosin"},
        ["WEAPON_MK14"]={"MK14",1850000,0,"N/A","w_sr_mk14"},
        ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup"},
        ["item2"]={"LVL 2 Armour",50000,0,"N/A","prop_bodyarmour_02"},
        ["item3"]={"LVL 3 Armour",75000,0,"N/A","prop_bodyarmour_03"},
        ["item4"]={"LVL 4 Armour",100000,0,"N/A","prop_bodyarmour_04"},
        ["item|fillUpArmour"]={"Replenish Armour",100000,0,"N/A","prop_armour_pickup"},
    },
    ["SmallArmsDealer"]={
        ["_config"]={{vector3(2437.5708007813,4966.5610351563,41.34761428833),vector3(-1500.4978027344,-216.72758483887,46.889373779297),vector3(1242.791,-426.7525,67.93467)},110,1,"Small Arms Dealer",{""},true},
        ["WEAPON_BERETTA"]={"Berreta M9 Pistol",60000,0,"N/A","w_pi_beretta"},
        ["WEAPON_M1911"]={"M1911 Pistol",60000,0,"N/A","w_pi_m1911"},
        ["WEAPON_MPX"]={"MPX",300000,0,"N/A","w_ar_mpx"},
        ["WEAPON_PYTHON"]={"Python .357 Revolver",50000,0,"N/A","w_pi_python"},
        ["WEAPON_ROOK"]={"Rook 9mm",60000,0,"N/A","w_pi_rook"},
        ["WEAPON_TEC9"]={"Tec-9",50000,0,"N/A","w_sb_tec9"},
        ["WEAPON_UMP45"]={"UMP-45",300000,0,"N/A","w_sb_ump45"},
        ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup"},
    },
    ["Legion"]={
        ["_config"]={{vector3(-3171.5241699219,1087.5402832031,19.838747024536),vector3(-330.56484985352,6083.6059570312,30.454759597778),vector3(2567.6704101562,294.36923217773,107.70868457031)},154,1,"B&Q Tool Shop",{""},true},
        ["WEAPON_BROOM"]={"Broom",2500,0,"N/A","w_me_broom"},
        ["WEAPON_BASEBALLBAT"]={"Baseball Bat",2500,0,"N/A","w_me_baseballbat"},
        ["WEAPON_MACHETE2"]={"Machete",7500,0,"N/A","w_me_machete2"},
        ["WEAPON_CLEAVER"]={"Cleaver",7500,0,"N/A","w_me_cleaver"},
        ["WEAPON_CRICKETBAT"]={"Cricket Bat",2500,0,"N/A","w_me_cricketbat"},
        ["WEAPON_DILDO"]={"Dildo",2500,0,"N/A","w_me_dildo"},
        ["WEAPON_FIREAXE"]={"Fireaxe",2500,0,"N/A","w_me_fireaxe"},
        ["WEAPON_GUITAR"]={"Guitar",2500,0,"N/A","w_me_guitar"},
        ["WEAPON_HAMAXEHAM"]={"Hammer Axe Hammer",2500,0,"N/A","w_me_hamaxeham"},
        ["WEAPON_KITCHENKNIFE"]={"Kitchen Knife",7500,0,"N/A","w_me_kitchenknife"},
        ["WEAPON_SHANK"]={"Shank",7500,0,"N/A","w_me_shank"},
        ["WEAPON_SLEDGEHAMMER"]={"Sledge Hammer",2500,0,"N/A","w_me_sledgehammer"},
        ["WEAPON_TOILETBRUSH"]={"Toilet Brush",2500,0,"N/A","w_me_toiletbrush"},
        ["WEAPON_TRAFFICSIGN"]={"Traffic Sign",2500,0,"N/A","w_me_trafficsign"},
        ["WEAPON_SHOVEL"]={"Shovel",2500,0,"N/A","w_me_shovel"},
        ["WEAPON_CROWBAR"]={"Crowbar",50000,0,"N/A","w_me_crowbar"},
    },
}

cfg.whitelistedGuns = {
    ["policeLargeArms"]={
    },
    ["policeSmallArms"]={
    },
    ["prisonArmoury"]={
    },
    ["VIP"]={
        ["WEAPON_WESTYARES"]={"Westy Ares",2000000,0,"N/A","w_mg_westyares"},
        ["WEAPON_T5GLOW"]={"T5 Glow",450000,0,"N/A","w_sb_t5glow"},
        ["WEAPON_ANIMEM16"]={"UWU AR",500000,0,"N/A","w_ar_animem16"},
        ["WEAPON_CBHONEYBADGER"]={"CB Honey Badger",1,0,"N/A","w_sb_cbhoneybadger"},
        ["WEAPON_YELLOWM4A1S"]={"Yellow Demon M4A1-S",900000,0,"N/A","w_ar_yellowm4a1s"},
        ["WEAPON_SCORPBLUE"]={"Scorpion Blue",350000,0,"N/A","w_sb_scorpionblue"},
        ["WEAPON_M4A1SPURPLE"]={"M4A1-S Purple",900000,0,"N/A","w_ar_m4a1spurple"},
        ["WEAPON_BARRET50NRP"]={"Barret 50 Cal",1000000,0,"N/A", "w_sr_barret50cal"},
        ["WEAPON_WAZEYCHAINSLMG"]={"Wazey Cum Blaster",2000000,0,"N/A","w_mg_wazeychains"},
        ["WEAPON_MP5TACTICALBLUE"]={"MP5 Tactical Blue",0,0,"N/A","w_sb_mp5tacticalblue"},
    },
    ["Rebel"]={
        ["WEAPON_CALSNAGANT"]={"Cals Nagant",1000000,0,"N/A","w_sr_calsnagant"},
    },
    ["LargeArmsDealer"] = {
        ["WEAPON_CBHONEYBADGER"]={"CB Honey Badger",450000,0,"N/A","w_sb_cbhoneybadger"},
        ["WEAPON_BREENYSINGULARITY"]={"Breenysingularity",2000000,0,"N/A","w_mg_breenysingularity"},
        ["WEAPON_T5GLOW"]={"T5 Glow",450000,0,"N/A","w_sb_t5glow"},
        ["WEAPON_WESTYARES"]={"Westy Ares",2000000,0,"N/A","w_mg_westyares"},
        ["WEAPON_616LMG"]={"616 LMG",2000000,0,"N/A","w_mg_616lmg"},
        ["WEAPON_M82BLOSSOM"]={"M82 Blossom",2000000,0,"N/A","w_sr_m82blossom"},
        ["WEAPON_RAALV2"]={"RAAL V2",2000000,0,"N/A","w_mg_raalv2"},
        ["WEAPON_TEMPERED"]={"Tempered M249",2000000,0,"N/A","w_mg_m249tempered"},
        ["WEAPON_ANIMEM16"]={"Anime M16",900000,0,"N/A","w_ar_animem16"},
        ["WEAPON_SPACEFLIGHTMP5"]={"Space Flight MP5",450000,0,"N/A","w_sb_spaceflightmp5"},
        ["WEAPON_YELLOWM4A1S"]={"Yellow Demon M4A1-S",900000,0,"N/A","w_ar_yellowm4a1s"},
        ["WEAPON_HINEDERE"]={"Hinedere",900000,0,"N/A","w_ar_hinedere"},
        ["WEAPON_SINGULARITYPHANTOM"]={"Singularity Phantom",900000,0,"N/A","w_ar_singularityphantom"},
        ["WEAPON_SCORPIONBLUE"]={"Scorpion Blue",350000,0,"N/A","w_sb_scorpionblue"},
        ["WEAPON_M4A1SPURPLE"]={"M4A1-S Purple",900000,0,"N/A","w_ar_m4a1spurple"},
        ["WEAPON_GRAU"]={"Grau",900000,0,"N/A","w_ar_grau"},
        ["WEAPON_1928BAR"]={"1928 Browning",900000,0,"N/A","w_ar_1928bar"},
        ["WEAPON_BARRET50NRP"]={"Barret 50 Cal",1000000,0,"N/A", "w_sr_barret50cal"},
        ["WEAPON_WAZEYCHAINSLAMB"]={"Wazey Cum Blaster",2000000,0,"N/A","w_mg_wazeychains"},
        ["WEAPON_M249PLAYMAKER"]={"M249 Playmaker",2000000,0,"N/A","w_mg_m249playmaker"},
        ["WEAPON_RAUDNIMP5CMG"]={"Sad MP5K",450000,0,"N/A","w_sb_raudnimp5k"},
        ["WEAPON_LILUZI"]={"LIL UZI SMG",450000,0,"N/A","w_sb_liluzi"},
        ["WEAPON_GLC"]={"Glacier Mosin",1000000,0,"N/A","w_ar_glmosin"},
        ["WEAPON_LVMOSIN"]={"Louis Vuitton Mosin",1000000,0,"N/A","w_ar_lvmosin"},
        ["WEAPON_UNI"]={"Uni Mosin",1000000,0,"N/A","w_ar_soimosin"},
        ["WEAPON_MP5K"]={"MP5K",0,0,"N/A","w_sb_mp5k"},
        ["WEAPON_CHERRYMOSIN"]={"CHERRY BLOSSOM MOSIN",1000000,0,"N/A","w_ar_cherrymosin"},
        ["WEAPON_NERFMOSIN"]={"NERF MOSIN",1000000,0,"N/A","w_ar_nerfmosin"},
        ["WEAPON_MANORMOSIN"]={"MANOR MOSIN",1000000,0,"N/A","w_ar_manormosin"},
        ["WEAPON_AYRESSYMOSIN"]={"Ayresyys Nagant",1000000,0,"N/A","w_ar_ayressymosin"},
        ["WEAPON_REDLVMOSIN"]={"Red LV Mosin",1000000,0,"N/A","w_ar_redlvmosin"}, -- 
        ["WEAPON_NOVMOSIN"]={"NO VANITY MOSIN",1000000,0,"N/A","w_ar_novmosin"},
        ["WEAPON_M82BLOSSOM"]={"M82 BLOSSOM",2500000,0,"N/A","w_sr_m82blossom"},
        ["WEAPON_CMPCARBINE"]={"CMP CARBINE",750000,0,"N/A","w_ar_cmpcarbine"},
        ["WEAPON_ANONYMOUSAR"]={"ANONYMOUS AR",750000,0,"N/A","w_ar_anonymousar"},
        ["WEAPON_LR300WHITE"]={"LR 300 WHITE",750000,0,"N/A","w_ar_lr300white"},
        ["WEAPON_M4A1NIGHTMARE"]={"M4A1-S Nightmare",900000,0,"N/A","w_ar_m4a1nightmare"},
        ["WEAPON_CALSNAGANT"]={"Cals Nagant",1000000,0,"N/A","w_sr_calsnagant"},
        ["WEAPON_KITTYSNIPER"]={"Ohio's Kitty",1000000,0,"N/A","w_sr_kittysniper"},
        ["WEAPON_APPISTOL"]={"AP Pistol",500000,0,"N/A","w_pi_appistol"},
        ["WEAPON_M4A1SPURPLE"]={"M4A1-S Purple",900000,0,"N/A","w_ar_m4a1spurple"},
        ["WEAPON_CBMOSIN"]={"CB Mosin",1000000,0,"N/A","w_sr_cbmosin"},
        ["WEAPON_BLACKICEMOSIN"]={"Black Ice Mosin",1000000,0,"N/A","w_sr_blackicemosin"},
        ["WEAPON_CORRUPTKILLERSNIPER"]={"KrepZz's Killer",1000000,0,"N/A","w_sr_corruptkillersniper"},
        ["WEAPON_BLOODHAUND"]={"Blood Hound LMG",3000000,0,"N/A","w_mg_bloodhaund"},
    },
    ["CorruptDealer"]={
        ["WEAPON_CBHONEYBADGER"]={"CB Honey Badger",450000,0,"N/A","w_sb_cbhoneybadger"},
        ["WEAPON_BREENYSINGULARITY"]={"Breenysingularity",2000000,0,"N/A","w_mg_breenysingularity"},
        ["WEAPON_T5GLOW"]={"T5 Glow",450000,0,"N/A","w_sb_t5glow"},
        ["WEAPON_WESTYARES"]={"Westy Ares",2000000,0,"N/A","w_mg_westyares"},
        ["WEAPON_616LMG"]={"616 LMG",2000000,0,"N/A","w_mg_616lmg"},
        ["WEAPON_M82BLOSSOM"]={"M82 Blossom",2000000,0,"N/A","w_sr_m82blossom"},
        ["WEAPON_RAALV2"]={"RAAL V2",2000000,0,"N/A","w_mg_raalv2"},
        ["WEAPON_TEMPERED"]={"Tempered M249",2000000,0,"N/A","w_mg_m249tempered"},
        ["WEAPON_ANIMEM16"]={"Anime M16",900000,0,"N/A","w_ar_animem16"},
        ["WEAPON_SPACEFLIGHTMP5"]={"Space Flight MP5",450000,0,"N/A","w_sb_spaceflightmp5"},
        ["WEAPON_YELLOWM4A1S"]={"Yellow Demon M4A1-S",900000,0,"N/A","w_ar_yellowm4a1s"},
        ["WEAPON_HINEDERE"]={"Hinedere",900000,0,"N/A","w_ar_hinedere"},
        ["WEAPON_SINGULARITYPHANTOM"]={"Singularity Phantom",900000,0,"N/A","w_ar_singularityphantom"},
        ["WEAPON_SCORPIONBLUE"]={"Scorpion Blue",350000,0,"N/A","w_sb_scorpionblue"},
        ["WEAPON_M4A1SPURPLE"]={"M4A1-S Purple",900000,0,"N/A","w_ar_m4a1spurple"},
        ["WEAPON_GRAU"]={"Grau",900000,0,"N/A","w_ar_grau"},
        ["WEAPON_1928BAR"]={"1928 Browning",900000,0,"N/A","w_ar_1928bar"},
        ["WEAPON_BARRET50NRP"]={"Barret 50 Cal",1000000,0,"N/A", "w_sr_barret50cal"},
        ["WEAPON_WAZEYCHAINSLAMB"]={"Wazey Cum Blaster",2000000,0,"N/A","w_mg_wazeychains"},
        ["WEAPON_M249PLAYMAKER"]={"M249 Playmaker",2000000,0,"N/A","w_mg_m249playmaker"},
        ["WEAPON_RAUDNIMP5CMG"]={"Sad MP5K",450000,0,"N/A","w_sb_raudnimp5k"},
        ["WEAPON_LILUZI"]={"LIL UZI SMG",450000,0,"N/A","w_sb_liluzi"},
        ["WEAPON_GLC"]={"Glacier Mosin",1000000,0,"N/A","w_ar_glmosin"},
        ["WEAPON_LVMOSIN"]={"Louis Vuitton Mosin",1000000,0,"N/A","w_ar_lvmosin"},
        ["WEAPON_UNI"]={"Uni Mosin",1000000,0,"N/A","w_ar_soimosin"},
        ["WEAPON_MP5K"]={"MP5K",0,0,"N/A","w_sb_mp5k"},
        ["WEAPON_CHERRYMOSIN"]={"CHERRY BLOSSOM MOSIN",1000000,0,"N/A","w_ar_cherrymosin"},
        ["WEAPON_NERFMOSIN"]={"NERF MOSIN",1000000,0,"N/A","w_ar_nerfmosin"},
        ["WEAPON_MANORMOSIN"]={"MANOR MOSIN",1000000,0,"N/A","w_ar_manormosin"},
        ["WEAPON_NOVMOSIN"]={"NO VANITY MOSIN",1000000,0,"N/A","w_ar_novmosin"},
        ["WEAPON_M82BLOSSOM"]={"M82 BLOSSOM",2500000,0,"N/A","w_sr_m82blossom"},
        ["WEAPON_CMPCARBINE"]={"CMP CARBINE",750000,0,"N/A","w_ar_cmpcarbine"},
        ["WEAPON_ANONYMOUSAR"]={"ANONYMOUS AR",750000,0,"N/A","w_ar_anonymousar"},
        ["WEAPON_LR300WHITE"]={"LR 300 WHITE",750000,0,"N/A","w_ar_lr300white"},
        ["WEAPON_M4A1NIGHTMARE"]={"M4A1-S Nightmare",900000,0,"N/A","w_ar_m4a1nightmare"},
        ["WEAPON_CALSNAGANT"]={"Cals Nagant",1000000,0,"N/A","w_sr_calsnagant"},
        ["WEAPON_KITTYSNIPER"]={"Ohio's Kitty",1000000,0,"N/A","w_sr_kittysniper"},
        ["WEAPON_APPISTOL"]={"AP Pistol",500000,0,"N/A","w_pi_appistol"},
        ["WEAPON_M4A1SPURPLE"]={"M4A1-S Purple",900000,0,"N/A","w_ar_m4a1spurple"},
        ["WEAPON_CBMOSIN"]={"CB Mosin",1000000,0,"N/A","w_sr_cbmosin"},
        ["WEAPON_BLACKICEMOSIN"]={"Black Ice Mosin",1000000,0,"N/A","w_sr_blackicemosin"},
        ["WEAPON_BLOODHAUND"]={"Blood Hound LMG",3000000,0,"N/A","w_mg_bloodhaund"},
    },
    ["SmallArmsDealer"] = {
        ["WEAPON_APPISTOL"]={"AP Pistol",500000,0,"N/A","w_pi_appistol"},
    },
    ["Legion"] = {
    },
}

cfg.VIPWithPlat = {
    ["item|Morphine"]={"Morphine",50000,0,"N/A",""},
    ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup"},
    ["item2"]={"LVL 2 Armour",50000,0,"N/A","prop_bodyarmour_02"},
    ["item3"]={"LVL 3 Armour",75000,0,"N/A","prop_bodyarmour_03"},
    ["item4"]={"LVL 4 Armour",100000,0,"N/A","prop_bodyarmour_04"},
    ["item|fillUpArmour"]={"Replenish Armour",100000,0,"N/A","prop_armour_pickup"},
}

cfg.RebelWithAdvanced = {
    ["WEAPON_MXM"]={"MXM",950000,0,"N/A","w_ar_mxm"},
    ["WEAPON_SPAR16"]={"Spar 16",900000,0,"N/A","w_ar_spar16"},
    ["WEAPON_SVD"]={"Dragunov SVD",2500000,0,"N/A","w_sr_svd"},
    ["WEAPON_MK14"]={"MK14",1850000,0,"N/A","w_sr_mk14"},
}

cfg.items = {
    {item = "Morphine", weight = 1},
}

return cfg
