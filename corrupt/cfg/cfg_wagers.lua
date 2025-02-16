cfg = {}

cfg.settings = {
    wagerStartLoc = vector3(93.30989074707,6357.1254882812,31.369262695312),
    wagerBetAmount = 100000,
    wagerMinBet = 100000,
    wagerMaxBet = 100000000,
    categoryIndex = 1,
    maxTeamPlayers = 2,
    ["categories"] = {
        "Pistols",
        "Shotguns",
        "SMGs",
        "Assault Rifles",
        "Snipers",
    },
    weaponInCategoryIndex = 1,
    ["weapons_in_category"] = {
        ["Pistols"] = {
            ["WEAPON_M1911"] = "",
            ["WEAPON_ROOK"] = "",
            ["WEAPON_TEC9"] = "",
        },
        ["Shotguns"] = {
            ["WEAPON_OLYMPIA"] = "",
            ["WEAPON_SPAZ"] = "",
            ["WEAPON_WINCHESTER12"] = "",
        },
        ["SMGs"] = {
            ["WEAPON_MPX"] = "",
            ["WEAPON_UMP45"] = "",
            ["WEAPON_UZI"] = "",
        },
        ["Assault Rifles"] = {
            ["WEAPON_AK74KASHNAR"] = "",
            ["WEAPON_AK200"] = "",
            ["WEAPON_AK74"] = "",
            ["WEAPON_AKM"] = "",
            ["WEAPON_SPAR16"] = "",
            ["WEAPON_MXM"] = "",
            ["WEAPON_MK1EMR"] = "",
        },
        ["Snipers"] = {
            ["WEAPON_MOSIN"] = "",
            ["WEAPON_M82BLOSSOM"] = "",
            ["WEAPON_MK14"] = "",
            ["WEAPON_SCOPEDMOSIN"] = "",
        },
    },
    armour_index = 1,
    ["armour_values"] = {
        "0%",
        "25%",
        "50%",
        "75%",
        "100%",
    },
    best_ofIndex = 1,
    ["best_of"] = {
        "1",
        "3",
        "5",
    },
    locationIndex = 1,
    ["locations"] = {
        ["heroin"] = "Heroin",
        ["rooftop"] = "Roof Top",
        ["large_arms"] = "Large Arms",
        ["ramps"] = "Ramps",
    },
    ["location_coords"] = {
        -- [key] = {A = vector3(x, y, z), B = vector3(x, y, z)}
        ["heroin"] = {A = vector3(3622.259521, 3707.805908, 35.066059), B = vector3(3445.039307, 3773.092529, 30.520403)},
        ["large_arms"] = {A = vector3(-1159.465942, 4925.105469, 222.721100), B = vector3(-1049.638794, 4920.305664, 209.682175)},
        ["rooftop"] = {A = vector3(-56.627361297607,177.79515075684,140.1782989502), B = vector3(-34.070983886719,152.03785705566,140.17835998535)},
        ["ramps"] = {A = vector3(-932.51867675781,-780.03955078125,15.91796875), B = vector3(-949.87249755859,-803.14288330078,15.91796875)},
    }
}

return cfg