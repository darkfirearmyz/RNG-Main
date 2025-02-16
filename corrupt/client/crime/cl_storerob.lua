local a = {}
local b = {}
local c = "rotation.clockwise"
local d = ""
local e = ""
local f = ""
local g
local h
local i
local j = GetGameTimer()
local k = 100
local l = 0.48
local m = 0.3
local n = ""
local o = 0
local p = nil
local q = false
local r = {
    ["paleto_twentyfourseven"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(1728.7196044922, 6417.0654296875, 34.037220001221),
        shopNpcHeading = 236.55,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(1736.289, 6418.842, 34.80501),
        safeHeading = 242.48239135742,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(1736.702, 6418.888, 34.14135),
        moneyPos2 = vector3(1736.702, 6418.888, 34.14135) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(1736.835, 6419.24, 34.10043),
        moneyPos4 = vector3(1736.798, 6418.982, 34.851775),
        moneyHeading = 331.59808349609,
        moneyHeading2 = 331.59808349609,
        moneyHeading3 = 335.39840698242,
        moneyHeading4 = 242.181640625,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["sandyshores_twentyfoursever"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(1959.0535888672, 3741.7045898438, 31.3437995910641),
        shopNpcHeading = 291.55,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(1961.656, 3748.989, 32.11159),
        safeHeading = 299.89376831055,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(1961.845, 3749.336, 31.44533),
        moneyPos2 = vector3(1961.845, 3749.336, 31.44533) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(1961.586, 3749.646, 31.44697),
        moneyPos4 = vector3(1961.822, 3749.47, 32.22634),
        moneyHeading = 297.69305419922,
        moneyHeading2 = 297.69305419922,
        moneyHeading3 = 300.09353637695,
        moneyHeading4 = 299.99301147461,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["bar_one"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(1984.4356689453, 3054.7565917969, 47.215145111084),
        shopNpcHeading = 230.0,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(1994.318, 3043.54, 46.98114),
        safeHeading = 147.29058837891,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(1994.307, 3043.096, 46.32116),
        moneyPos2 = vector3(1994.307, 3043.096, 46.32116) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(1994.6, 3042.91, 46.3018),
        moneyPos4 = vector3(1994.398, 3043.013, 47.12325),
        moneyHeading = 326.9977722168,
        moneyHeading2 = 326.9977722168,
        moneyHeading3 = 327.59765625,
        moneyHeading4 = 147.67221069336,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["littleseoul_twentyfourseven"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(-706.16192626953, -913.20764160156, 18.215581893921),
        shopNpcHeading = 90.0,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(-707.8496, -904.0402, 18.98337),
        safeHeading = 0.0,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(-708.0876, -903.588, 18.21714),
        moneyPos2 = vector3(-708.0876, -903.588, 18.21714) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(-708.4515, -903.6274, 18.31876),
        moneyPos4 = vector3(-708.1865, -903.655, 19.10827),
        moneyHeading = 0.0,
        moneyHeading2 = 0.0,
        moneyHeading3 = 0.0,
        moneyHeading4 = 0.0,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["asda"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(24.493055343628, -1345.4788818359, 28.497024536133),
        shopNpcHeading = 262.55,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(30.84683, -1340.337, 29.26481),
        safeHeading = 269.98638916016,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(31.25762, -1340.125, 28.53858),
        moneyPos2 = vector3(31.232, -1340.124, 28.68855),
        moneyPos3 = vector3(31.20064, -1339.752, 28.540),
        moneyPos4 = vector3(31.22769, -1339.963, 29.36968),
        moneyHeading = 0.099,
        moneyHeading2 = 0.099,
        moneyHeading3 = 0.099,
        moneyHeading4 = 269.28741455078,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["southlossantos_twentyfourseven"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(-46.450626373291, -1757.5461425781, 28.420984268188),
        shopNpcHeading = 45.0,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(-41.91652, -1749.63, 29.18883),
        safeHeading = 319.69720458984,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(-41.84, -1749.16, 28.42251),
        moneyPos2 = vector3(-41.84, -1749.16, 28.42251) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(-42.17047, -1748.993, 28.5542),
        moneyPos4 = vector3(-41.94428, -1749.123, 29.30364),
        moneyHeading = 318.39709472656,
        moneyHeading2 = 318.39709472656,
        moneyHeading3 = 323.59747314453,
        moneyHeading4 = 319.59719848633,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["vinewood_twentyfourseven"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(372.95562744141, 328.26510620117, 102.56648254395),
        shopNpcHeading = 253.0,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(380.0088, 331.7921, 103.3343),
        safeHeading = 255.58413696289,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(380.4388, 331.9152, 102.678),
        moneyPos2 = vector3(380.4388, 331.9152, 102.678) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(380.5645, 332.2422, 102.6495),
        moneyPos4 = vector3(380.4466, 332.0624, 103.4792),
        moneyHeading = 346.39916992188,
        moneyHeading2 = 346.39916992188,
        moneyHeading3 = 323.59747314453,
        moneyHeading4 = 346.79919433594,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["eastlossantos_robsliquor"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(1134.2801513672, -982.96826171875, 45.415786743164),
        shopNpcHeading = 273.0,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(1126.477, -980.8321, 45.18349),
        safeHeading = 7.4999785423279,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(1126.212, -980.4645, 44.48732),
        moneyPos2 = vector3(1126.212, -980.4645, 44.48732) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(1125.856, -980.6199, 44.49899),
        moneyPos4 = vector3(1126.078, -980.4662, 45.28833),
        moneyHeading = 6.8999700546265,
        moneyHeading2 = 6.8999700546265,
        moneyHeading3 = 9.5999689102173,
        moneyHeading4 = 7.19988489151,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["sandyshores_twentyfourseven"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(2676.5114746094, 3280.2993164063, 54.241176605225),
        shopNpcHeading = 335.0,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(2674.81, 3288.004, 55.00899),
        safeHeading = 330.4999785423279,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(2674.765, 3288.448, 54.3227),
        moneyPos2 = vector3(2674.765, 3288.448, 54.3227) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(2674.424, 3288.59, 54.33434),
        moneyPos4 = vector3(2674.656, 3288.501, 55.12368),
        moneyHeading = 331.39813232422,
        moneyHeading2 = 331.39813232422,
        moneyHeading3 = 332.49816894531,
        moneyHeading4 = 331.19812011719,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["grapeseed_gasstop"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(1698.5382080078, 4922.6352539063, 41.063629150391),
        shopNpcHeading = 320.0,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(1706.851, 4918.958, 41.83147),
        safeHeading = 234.4807434082,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(1707.324, 4918.907, 41.1652),
        moneyPos2 = vector3(1707.324, 4918.907, 41.16527) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(1707.568, 4919.194, 41.13685),
        moneyPos4 = vector3(1707.366, 4919.027, 41.94618),
        moneyHeading = 325.39755249023,
        moneyHeading2 = 325.39755249023,
        moneyHeading3 = 332.49816894531,
        moneyHeading4 = 322.59429931641,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["morningwood_robsliquor"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(-1486.6450195313, -377.64117431641, 39.16344833374),
        shopNpcHeading = 128.0,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(-1479.141, -374.8521, 38.93123),
        safeHeading = 226.1791229248,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(-1478.691, -374.9853, 38.23492),
        moneyPos2 = vector3(-1478.691, -374.9853, 38.23492) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(-1478.475, -374.6764, 38.26654),
        moneyPos4 = vector3(-1478.643, -374.8643, 39.04589),
        moneyHeading = 315.29690551758,
        moneyHeading2 = 315.29690551758,
        moneyHeading3 = 315.49691772461,
        moneyHeading4 = 225.37908935547,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["chumash_robsliquor"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(-2966.4086914063, 391.35339355469, 14.043314933777),
        shopNpcHeading = 80.0,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(-2959.265, 387.6957, 13.81098),
        safeHeading = 176.69169616699,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(-2959.014, 387.3654, 13.14629),
        moneyPos2 = vector3(-2959.014, 387.3654, 13.14629) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(-2958.639, 387.3448, 13.09645),
        moneyPos4 = vector3(-2958.927, 387.2768, 13.91958),
        moneyHeading = 356.49978637695,
        moneyHeading2 = 356.49978637695,
        moneyHeading3 = 0.0,
        moneyHeading4 = 177.27951049805,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["burgershot"] = {
        shopNpcModel = "csb_burgerdrug",
        shopNpcPosition = vector3(-1194.9146728516, -893.99810791016, 12.995297431946),
        shopNpcHeading = 302.0,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(-1195.902, -901.0758, 13.7631),
        safeHeading = 213.98210144043,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(-1195.492, -901.282, 13.09685),
        moneyPos2 = vector3(-1195.492, -901.282, 13.09685) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(-1195.205, -901.0581, 13.04849),
        moneyPos4 = vector3(-1195.392, -901.2319, 13.88797),
        moneyHeading = 305.89276123047,
        moneyHeading2 = 305.89276123047,
        moneyHeading3 = 35.399585723877,
        moneyHeading4 = 214.77911376953,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["eastlossantos_gasstop"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(1164.5863037109, -322.3291015625, 68.205024719238),
        shopNpcHeading = 96.0,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(1161.396, -313.4418, 68.97283),
        safeHeading = 12.599948883057,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(1161.073, -313.0523, 68.25655),
        moneyPos2 = vector3(1161.073, -313.0523, 68.25655) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(1160.752, -313.2396, 68.25839),
        moneyPos4 = vector3(1160.989, -313.1646, 69.10003),
        moneyHeading = 12.599948883057,
        moneyHeading2 = 12.599948883057,
        moneyHeading3 = 13.399929046631,
        moneyHeading4 = 13.49991607666,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["tongva_gasstop"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(-1820.384765625, 794.54663085938, 137.08973693848),
        shopNpcHeading = 126.0,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(-1827.91, 800.1599, 137.9252),
        safeHeading = 41.699321746826,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(-1828.359, 800.326, 137.1943),
        moneyPos2 = vector3(-1828.359, 800.326, 137.1943) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(-1828.556, 800.006, 137.2565),
        moneyPos4 = vector3(-1828.442, 800.2554, 138.0441),
        moneyHeading = 311.09548950195,
        moneyHeading2 = 311.09548950195,
        moneyHeading3 = 44.199123382568,
        moneyHeading4 = 41.498989105225,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["tataviam_twentyfourseven"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(2555.5571289063, 380.84866333008, 107.62292480469),
        shopNpcHeading = 352.0,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(2550.434, 386.8382, 108.3907),
        safeHeading = 358.39990234375,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(2550.21, 387.2356, 107.6346),
        moneyPos2 = vector3(2550.21, 387.2356, 107.6346) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(2549.838, 387.221, 107.7061),
        moneyPos4 = vector3(2550.109, 387.2408, 108.5108),
        moneyHeading = 358.89993286133,
        moneyHeading2 = 358.89993286133,
        moneyHeading3 = 0.0,
        moneyHeading4 = 358.0998840332,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    },
    ["cayoperico"] = {
        shopNpcModel = "mp_m_shopkeep_01",
        shopNpcPosition = vector3(4466.423828125, -4463.7529296875, 4.2491989135742),
        shopNpcHeading = 200.81,
        shopNpcHandler = 0,
        prop_safe = "v_ilev_gangsafe",
        prop_door = "v_ilev_gangsafedoor",
        safePosition = vector3(4464.9482421875, -4460.5083007812, 4.0420001029968),
        safeHeading = 110.0,
        money_prop = "bkr_prop_moneypack_03a",
        money_prop2 = "bkr_prop_moneypack_03a",
        money_prop3 = "prop_poly_bag_money",
        money_prop4 = "prop_cash_case_01",
        moneyPos = vector3(4464.7482421875, -4461.0083007812, 3.29200010299686),
        moneyPos2 = vector3(4464.7482421875, -4461.0083007812, 3.2920001029968) + vector3(0.0, 0.0, 0.15),
        moneyPos3 = vector3(4464.7482421875, -4461.0083007812, 3.2920001029968),
        moneyPos4 = vector3(4464.7482421875, -4461.0083007812, 4.0920001029968),
        moneyHeading = 110.89993286133,
        moneyHeading2 = 110.89993286133,
        moneyHeading3 = 0.0,
        moneyHeading4 = 110.0998840332,
        safeHandler = 0,
        doorHandler = 0,
        moneyHandler = 0,
        moneyHandler2 = 0,
        moneyHandler3 = 0,
        moneyHandler4 = 0,
        distanceToPlayer = 1000.0,
        insideStore = false,
        robberyInProgress = false
    }
}
function holdup_DisplayHelpText(s)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(s)
    EndTextCommandPrint(1000, 1)
end
function holdup_DisplayHelpText2(s)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(s)
    EndTextCommandDisplayHelp(0, false, true, -1)
end
RegisterNetEvent(
    "CORRUPT:updateStoreRobBlips",
    function(p)
        refreshStoreBlips(p)
    end
)
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(t, u)
        if u then
            TriggerServerEvent("CORRUPT:getStoreRobBlips")
            while p == nil do
                Wait(0)
            end
            while true do
                for v, w in pairs(r) do
                    local x = w.shopNpcHandler
                    if x ~= 0 then
                        playStorePedCashRegisterAnimation(x, w, v)
                    end
                end
                Wait(1000)
            end
        end
    end
)
function playStorePedCashRegisterAnimation(x, w, v)
    if not IsPedDeadOrDying(x, false) then
        if IsEntityPlayingAnim(x, "mp_am_hold_up", "holdup_victim_20s", 3) then
            PlayPedAmbientSpeechNative(x, "SHOP_SCARED", "SPEECH_PARAMS_FORCE")
            local y = GetGameTimer() + 10800
            while y >= GetGameTimer() do
                if IsPedDeadOrDying(x, false) then
                    break
                end
                Wait(0)
            end
            if not IsPedDeadOrDying(x, false) then
                local z = GetEntityCoords(x)
                local A = GetClosestObjectOfType(z.x, z.y, z.z, 5.0, `prop_till_01`, false, false, false)
                if DoesEntityExist(A) then
                    local B = GetEntityCoords(A)
                    CreateModelSwap(B.x,B.y,B.z,0.5,`prop_till_01`,`prop_till_01_dam`,false)
                end
                y = GetGameTimer() + 200
                while y >= GetGameTimer() do
                    if IsPedDeadOrDying(x, false) then
                        break
                    end
                    Wait(0)
                end
                local C = CORRUPT.loadModel("prop_poly_bag_01")
                local D = GetEntityCoords(x)
                local E = CreateObject(C, D.x, D.y, D.z, false, false, false)
                SetModelAsNoLongerNeeded(C)
                PlayPedAmbientSpeechNative(x, "SHOP_HURRYING", "SPEECH_PARAMS_FORCE")
                AttachEntityToEntity(
                    E,
                    x,
                    GetPedBoneIndex(x, 60309),
                    0.1,
                    -0.11,
                    0.08,
                    0.0,
                    -75.0,
                    -75.0,
                    1,
                    1,
                    0,
                    0,
                    2,
                    1
                )
                Wait(10000)
                if not IsPedDeadOrDying(x, false) then
                    PlayPedAmbientSpeechNative(x, "SCREAM_PANIC", "SPEECH_PARAMS_FORCE")
                    DetachEntity(E, true, false)
                    Wait(0)
                    SetEntityHeading(E, w.shopNpcHeading)
                    ApplyForceToEntity(E, 3, 0.0, 50.0, 20.0, 0.0, 0.0, 50.0, 0, true, true, false, false, true)
                    q = false
                    Citizen.CreateThread(
                        function()
                            while true do
                                Wait(5)
                                if DoesEntityExist(E) then
                                    if #(GetEntityCoords(CORRUPT.getPlayerPed()) - GetEntityCoords(E)) <= 1.5 then
                                        PlaySoundFrontend(
                                            -1,
                                            "ROBBERY_MONEY_TOTAL",
                                            "HUD_FRONTEND_CUSTOM_SOUNDSET",
                                            true
                                        )
                                        TriggerServerEvent("CORRUPT:pickupCashFromApu", v)
                                        DeleteObject(E)
                                        break
                                    end
                                else
                                    break
                                end
                            end
                        end
                    )
                else
                    DeleteObject(E)
                end
                loadAnimDict("mp_am_hold_up")
                TaskPlayAnim(x, "mp_am_hold_up", "cower_intro", 8.0, -8.0, -1, 0, 0, false, false, false)
                y = GetGameTimer() + 2500
                while y >= GetGameTimer() do
                    Wait(0)
                end
                TaskPlayAnim(x, "mp_am_hold_up", "cower_loop", 8.0, -8.0, -1, 1, 0, false, false, false)
                local F = GetGameTimer() + 120000
                while F >= GetGameTimer() do
                    Wait(50)
                end
                if IsEntityPlayingAnim(x, "mp_am_hold_up", "cower_loop", 3) then
                    ClearPedTasks(x)
                end
            end
        end
    end
end
Citizen.CreateThread(
    function()
        while true do
            local G = GetEntityCoords(CORRUPT.getPlayerPed(), true)
            if r ~= nil then
                for v, w in pairs(r) do
                    if w.distanceToPlayer < 10.0 and not w.insideStore then
                        PlayPedAmbientSpeechNative(w.shopNpcHandler, "SHOP_GREET", "SPEECH_PARAMS_FORCE")
                    end
                    if w.distanceToPlayer < 10.0 then
                        r[v]["insideStore"] = true
                    else
                        r[v]["insideStore"] = false
                    end
                end
            end
            Wait(500)
        end
    end
)
currentStoreRobBlips = {}
function refreshStoreBlips(H)
    p = H
    for I, J in pairs(currentStoreRobBlips) do
        if J ~= nil then
            tvRP.removeBlip(J)
        end
    end
    currentStoreRobBlips = {}
    for I, J in pairs(p) do
        local K = J.position
        if J.beingrobbed == true then
            tempBlip = tvRP.addBlip(K.x, K.y, K.z, 52, 1, "Robbable Store [BEING ROBBED]")
        else
            tempBlip = tvRP.addBlip(K.x, K.y, K.z, 52, 2, "Robbable Store")
        end
        currentStoreRobBlips[I] = tempBlip
    end
end
Citizen.CreateThread(
    function()
        for v, w in pairs(r) do
            local L = CORRUPT.loadModel(w.shopNpcModel)
            local M =
                CreatePed(
                26,
                L,
                w.shopNpcPosition.x,
                w.shopNpcPosition.y,
                w.shopNpcPosition.z,
                w.shopNpcHeading,
                false,
                true
            )
            r[v].shopNpcHandler = M
            SetModelAsNoLongerNeeded(L)
            SetEntityAsMissionEntity(M, true, true)
            SetPedHearingRange(M, 0.0)
            SetPedSeeingRange(M, 0.0)
            SetPedAlertness(M, 0.0)
            SetPedFleeAttributes(M, 0, 0)
            SetBlockingOfNonTemporaryEvents(M, true)
            SetPedCombatAttributes(M, 46, true)
            SetPedFleeAttributes(M, 0, 0)
            local N = CORRUPT.loadModel(w.prop_safe)
            local O = CORRUPT.loadModel(w.prop_door)
            local P = CORRUPT.loadModel(w.money_prop)
            local Q = CORRUPT.loadModel(w.money_prop2)
            local R = CORRUPT.loadModel(w.money_prop3)
            local S = CORRUPT.loadModel(w.money_prop4)
            local T = CreateObject(N, w.safePosition.x, w.safePosition.y, w.safePosition.z - 0.8, false, false, true)
            r[v]["safeHandler"] = T
            SetEntityHeading(T, r[v].safeHeading)
            SetEntityInvincible(T, true)
            FreezeEntityPosition(T, true)
            local U = CreateObject(O, w.safePosition.x, w.safePosition.y, w.safePosition.z - 0.7, false, false, true)
            r[v]["doorHandler"] = U
            SetEntityHeading(U, r[v].safeHeading)
            SetEntityInvincible(U, true)
            FreezeEntityPosition(U, true)
            local V = CreateObject(P, w.moneyPos.x, w.moneyPos.y, w.moneyPos.z, false, false, true)
            r[v]["moneyHandler"] = V
            SetEntityHeading(V, r[v].moneyHeading)
            SetEntityInvincible(V, true)
            FreezeEntityPosition(V, true)
            local W = CreateObject(Q, w.moneyPos2.x, w.moneyPos2.y, w.moneyPos2.z, false, false, true)
            r[v]["moneyHandler2"] = W
            SetEntityHeading(W, r[v].moneyHeading2)
            SetEntityInvincible(W, true)
            FreezeEntityPosition(W, true)
            local X = CreateObject(R, w.moneyPos3.x, w.moneyPos3.y, w.moneyPos3.z, false, false, true)
            r[v]["moneyHandler3"] = X
            SetEntityHeading(X, r[v].moneyHeading3)
            SetEntityInvincible(X, true)
            FreezeEntityPosition(X, true)
            local Y = CreateObject(S, w.moneyPos4.x, w.moneyPos4.y, w.moneyPos4.z, false, false, true)
            r[v]["moneyHandler4"] = Y
            SetEntityHeading(Y, r[v].moneyHeading4)
            SetEntityInvincible(Y, true)
            FreezeEntityPosition(Y, true)
            SetModelAsNoLongerNeeded(N)
            SetModelAsNoLongerNeeded(O)
            SetModelAsNoLongerNeeded(P)
            SetModelAsNoLongerNeeded(Q)
            SetModelAsNoLongerNeeded(R)
            SetModelAsNoLongerNeeded(S)
        end
        while true do
            local Z = GetEntityCoords(CORRUPT.getPlayerPed())
            for v, w in pairs(r) do
                local _ = #(Z - w.safePosition)
                w.distanceToPlayer = _
            end
            Wait(250)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            local a0 = CORRUPT.getPlayerPed()
            for v, w in pairs(r) do
                if w.distanceToPlayer < 10.0 then
                    local a1 = w.shopNpcHandler
                    if a1 ~= 0 then
                        if IsPlayerFreeAimingAtEntity(PlayerId(), a1) then
                            if
                                HasEntityClearLosToEntityInFront(a0, a1) and not IsPedDeadOrDying(a1, false) and
                                    #(GetEntityCoords(a0) - GetEntityCoords(a1)) <= 5.0
                             then
                                if not q then
                                    if GetSelectedPedWeapon(CORRUPT.getPlayerPed()) == `WEAPON_UNARMED` then
                                        tvRP.notify("~r~You need a weapon in your hands to rob this store!")
                                    else
                                        TriggerServerEvent("CORRUPT:initiateStoreRobbery", v)
                                        r[v].robberyInProgress = true
                                        Wait(40000)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            Citizen.Wait(0)
        end
    end
)
RegisterNetEvent(
    "CORRUPT:beginStoreRobbingAnimations",
    function(v)
        local a1 = r[v].shopNpcHandler
        SetEntityCoords(a1, r[v].shopNpcPosition)
        SetEntityHeading(a1, r[v].shopNpcHeading)
        loadAnimDict("mp_am_hold_up")
        TaskPlayAnim(a1, "mp_am_hold_up", "holdup_victim_20s", 8.0, -8.0, -1, 2, 0, false, false, false)
    end
)
RegisterNetEvent(
    "CORRUPT:storeRobberyInProgress",
    function(a2, v)
        q = a2
        local a3 = GetEntityCoords(CORRUPT.getPlayerPed())
        while q do
            local Z = GetEntityCoords(CORRUPT.getPlayerPed())
            if #(a3 - Z) > 20 then
                TriggerServerEvent("CORRUPT:forceEndRobbery", v)
                r[v].robberyInProgress = false
                break
            end
            Wait(100)
        end
    end
)
RegisterNetEvent(
    "CORRUPT:resetStorePed",
    function(v)
        r[v].robberyInProgress = false
        local a1 = r[v].shopNpcHandler
        if DoesEntityExist(a1) then
            DeleteEntity(a1)
        end
        local L = CORRUPT.loadModel(r[v].shopNpcModel)
        local M =
            CreatePed(
            26,
            L,
            r[v].shopNpcPosition.x,
            r[v].shopNpcPosition.y,
            r[v].shopNpcPosition.z,
            r[v].shopNpcHeading,
            false,
            true
        )
        r[v].shopNpcHandler = M
        SetModelAsNoLongerNeeded(L)
        SetEntityAsMissionEntity(M, true, true)
        SetPedHearingRange(M, 0.0)
        SetPedSeeingRange(M, 0.0)
        SetPedAlertness(M, 0.0)
        SetPedFleeAttributes(M, 0, 0)
        SetBlockingOfNonTemporaryEvents(M, true)
        SetPedCombatAttributes(M, 46, true)
        SetPedFleeAttributes(M, 0, 0)
    end
)
Citizen.CreateThread(
    function()
        while true do
            local Z = GetEntityCoords(CORRUPT.getPlayerPed())
            for v, w in pairs(r) do
                if w.distanceToPlayer < 2.0 then
                    if safeCrackingState == "complete" then
                        holdup_DisplayHelpText2("Press ~INPUT_CONTEXT~ to grab the money!")
                        if IsControlJustReleased(1, 51) then
                            DeleteObject(w.moneyHandler)
                            DeleteObject(w.moneyHandler2)
                            DeleteObject(w.moneyHandler3)
                            DeleteObject(w.moneyHandler4)
                            TriggerServerEvent("CORRUPT:completeSafeCracking", v)
                            r[v].robberyInProgress = false
                            safeCrackingState = "setup"
                            Wait(5000)
                            TriggerServerEvent("CORRUPT:syncCloseSafeDoor", v)
                        end
                    elseif w.robberyInProgress then
                        holdup_DisplayHelpText2("Press ~INPUT_CONTEXT~ to start cracking the safe!")
                        if IsControlJustReleased(1, 51) then
                            tvRP.notify("~g~Started cracking safe..")
                            LoadResources()
                            math.randomseed(GetGameTimer())
                            local a4 = math.random(0, 100)
                            i = 3.6 * a4
                            f = c
                            safeCrackingInProgress = true
                            safeCrackingState = "setup"
                            RunMiniGame(v, w.safeHandler, w.doorHandler)
                        end
                    end
                end
            end
            Wait(0)
        end
    end
)
function drawSafeCrackingInstructionals()
    local a5 = RequestScaleformMovie("instructional_buttons")
    if not HasScaleformMovieLoaded(a5) then
        while not HasScaleformMovieLoaded(a5) do
            Wait(0)
        end
    end
    local a6 = {
        {["label"] = "Attempt combination", ["button"] = "~INPUT_CELLPHONE_UP~"},
        {["label"] = "Turn combination right", ["button"] = "~INPUT_CELLPHONE_RIGHT~"},
        {["label"] = "Turn combination left", ["button"] = "~INPUT_CELLPHONE_LEFT~"},
        {["label"] = "Cancel", ["button"] = "~INPUT_CELLPHONE_CANCEL~"}
    }
    BeginScaleformMovieMethod(a5, "CLEAR_ALL")
    BeginScaleformMovieMethod(a5, "TOGGLE_MOUSE_BUTTONS")
    ScaleformMovieMethodAddParamBool(0)
    EndScaleformMovieMethod()
    for a7, a8 in ipairs(a6) do
        BeginScaleformMovieMethod(a5, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(a7 - 1)
        ScaleformMovieMethodAddParamPlayerNameString(a8["button"])
        ScaleformMovieMethodAddParamTextureNameString(a8["label"])
        EndScaleformMovieMethod()
    end
    BeginScaleformMovieMethod(a5, "DRAW_INSTRUCTIONAL_BUTTONS")
    ScaleformMovieMethodAddParamInt(-1)
    EndScaleformMovieMethod()
    DrawScaleformMovieFullscreen(a5, 255, 255, 255, 255, 0)
end
AddEventHandler(
    "onResourceStop",
    function(a9)
        if a9 == GetCurrentResourceName() then
            for I, J in pairs(r) do
                DeleteObject(J.safeHandler)
                DeleteObject(J.doorHandler)
                DeleteObject(J.moneyHandler)
                DeleteObject(J.moneyHandler2)
                DeleteObject(J.moneyHandler3)
                DeleteObject(J.moneyHandler4)
            end
        end
    end
)
function InitializeSafe(aa, ab, ac, ad)
    local aa = aa
    local ab = ab
    PlaySoundFrontend(-1, "TUMBLER_RESET", "SAFE_CRACK_SOUNDSET", true)
end
function getRandomSafeCombination(ae)
    local ac = {}
    math.randomseed(GetGameTimer())
    for af = 1, ae, 1 do
        ac[af] = math.random(1, 99)
    end
    return ac
end
function RunMiniGame(v, ag, ah)
    local ai = 1
    local a = getRandomSafeCombination(10)
    local b = InitSafeLocks(a)
    while safeCrackingInProgress do
        if safeCrackingState == "setup" then
            h = GetEntityHeading(ag)
            g = GetSafeDoorAnimOffsetPosition(GetEntityCoords(ag), h, "intro_dont_work")
            PlaySafeCrackIntroAnim(g, h)
            g = GetSafeDoorAnimOffsetPosition(GetEntityCoords(ag), h, "cracking")
        elseif safeCrackingState == "cracking" then
            drawSafeCrackingInstructionals()
            local aj = GetEntityHealth(CORRUPT.getPlayerPed())
            if aj <= 102 or tvRP.isHandcuffed() then
                safeCrackingInProgress = false
            else
                HandleSafeDialMovement()
                local ak = GetCurrentSafeDialNumber(i)
                if IsControlJustPressed(0, 172) then
                    if ak == a[ai] then
                        b[ai] = false
                        ai = ai + 1
                        ReleaseCurrentPin(b, ai)
                        if IsSafeUnlocked(b, ai) then
                            EndMiniGame(v, ah)
                            safeCrackingState = "complete"
                            safeCrackingInProgress = false
                            ClearPedTasksImmediately(CORRUPT.getPlayerPed())
                        end
                    else
                        ai = 1
                        b = InitSafeLocks(a)
                        a = getRandomSafeCombination(10)
                        PlaySoundFrontend(-1, "TUMBLER_RESET", "SAFE_CRACK_SOUNDSET", true)
                        HandleIncorrectMovement(ai, b)
                        d = "idle"
                        f = c
                        Wait(3500)
                        ClearPedTasksImmediately(CORRUPT.getPlayerPed())
                    end
                elseif IsControlJustPressed(0, 177) then
                    safeCrackingInProgress = false
                    ClearPedTasksImmediately(CORRUPT.getPlayerPed())
                end
                if safeCrackingState ~= "complete" then
                    local al = GetDialProximityToTargetPin(ak, a, ai)
                    SetDialSpriteShake(al)
                    DrawSprites()
                end
            end
        end
        Wait(0)
    end
    RemoveAnimDict("mini@safe_cracking")
end
function GetSafeDoorAnimOffsetPosition(am, an, ao)
    local ap
    local aq
    local ar
    local as
    if ao == "intro" then
        ap = 0.8
        aq = -0.35
        ar = -0.35
        as = -0.8
    else
        ap = 0.53
        aq = -0.6
        ar = -0.6
        as = -0.53
    end
    local at = ap * math.sin(an * math.pi / 180) + aq * math.cos(an * math.pi / 180)
    local au = ar * math.sin(an * math.pi / 180) + as * math.cos(an * math.pi / 180)
    return vector3(am.x + at, am.y + au, GetEntityCoords(CORRUPT.getPlayerPed()).z)
end
function PlaySafeCrackIntroAnim(av, h)
    local aw = "mini@safe_cracking"
    local ax = "step_into"
    loadAnimDict(aw)
    TaskPlayAnimAdvanced(CORRUPT.getPlayerPed(), aw, ax, av.x, av.y, av.z, 0.0, 0.0, h, 8.0, 8.0, -1, 2, 0.7, 0, 0)
    RemoveAnimDict(aw)
    Wait(0)
    Wait(1000)
    safeCrackingState = "cracking"
end
function HandleSafeDialMovement()
    local ay = CORRUPT.getPlayerPed()
    local aw = "mini@safe_cracking"
    local az = ""
    if IsEntityPlayingAnim(ay, aw, "dial_turn_fail_3", 3) or IsEntityPlayingAnim(ay, aw, "dial_turn_fail_4", 3) then
        return
    end
    if IsControlJustPressed(0, 174) then
        k = 100
        j = GetGameTimer()
        az = "dial_turn_anti_normal"
        RotateSafeDial("rotation.anticlockwise")
    elseif IsControlJustPressed(0, 175) then
        k = 100
        j = GetGameTimer()
        az = "dial_turn_clock_normal"
        RotateSafeDial("rotation.clockwise")
    elseif IsControlPressed(0, 174) then
        if j >= GetGameTimer() - k then
            return
        end
        k = 10
        j = GetGameTimer()
        az = "dial_turn_anti_fast"
        RotateSafeDial("rotation.anticlockwise")
    elseif IsControlPressed(0, 175) then
        if j >= GetGameTimer() - k then
            return
        end
        k = 10
        j = GetGameTimer()
        az = "dial_turn_clock_fast"
        RotateSafeDial("rotation.clockwise")
    else
        d = "rotation.idle"
        if
            IsEntityPlayingAnim(ay, aw, "dial_turn_anti_normal", 3) or
                IsEntityPlayingAnim(ay, aw, "dial_turn_clock_normal", 3) or
                IsEntityPlayingAnim(ay, aw, "dial_turn_anti_fast", 3) or
                IsEntityPlayingAnim(ay, aw, "dial_turn_clock_fast", 3) or
                IsEntityPlayingAnim(ay, aw, "idle_base", 3) or
                IsEntityPlayingAnim(ay, aw, "idle_heavy_breathe", 3) or
                IsEntityPlayingAnim(ay, aw, "idle_look_around", 3)
         then
            return
        end
        local aA = GetGameTimer() % 3
        local aB
        if aA == 2 then
            aB = "idle_heavy_breathe"
        elseif aA == 1 then
            aB = "idle_look_around"
        else
            aB = "idle_base"
        end
        az = aB
    end
    if az == "" or az == nil then
        return
    end
    loadAnimDict(aw)
    if not IsEntityPlayingAnim(CORRUPT.getPlayerPed(), aw, az, 3) then
        TaskPlayAnimAdvanced(CORRUPT.getPlayerPed(), aw, az, g.x, g.y, g.z, 0.0, 0.0, h, 8.0, 8.0, -1, 1, 1.0, 0, 0)
    end
end
function HandleIncorrectMovement(ai, b)
    local aw = "mini@safe_cracking"
    local aC = ""
    if GetGameTimer() % 2 == 0 then
        aC = "dial_turn_fail_3"
    else
        aC = "dial_turn_fail_4"
    end
    loadAnimDict(aw)
    TaskPlayAnimAdvanced(CORRUPT.getPlayerPed(), aw, aC, g.x, g.y, g.z, 0.0, 0.0, h, 8.0, 8.0, -1, 1, 1.0, 0, 0)
    RemoveAnimDict(aw)
    d = "rotation.idle"
end
function ReleaseCurrentPin(b, ai)
    if f == "rotation.anticlockwise" then
        f = "rotation.clockwise"
    else
        f = "rotation.anticlockwise"
    end
    if IsSafeUnlocked(b, ai) then
        PlaySoundFrontend(-1, "TUMBLER_PIN_FALL_FINAL", "SAFE_CRACK_SOUNDSET", true)
    else
        PlaySoundFrontend(-1, "TUMBLER_PIN_FALL", "SAFE_CRACK_SOUNDSET", true)
    end
end
function DrawSprites()
    local aD = "MPSafeCracking"
    _aspectRatio = GetAspectRatio(true)
    DrawSprite(aD, "Dial_BG", l, m, 0.3, _aspectRatio * 0.3, 0, 255, 255, 255, 255)
    DrawSprite(aD, "Dial", l, m, 0.3 * 0.5, _aspectRatio * 0.3 * 0.5, i, 255, 255, 255, 255)
end
function IsSafeUnlocked(b, ai)
    return b[ai] == nil
end
function CloseSafeDoor(ag, am)
    if #(CORRUPT.getPlayerCoords() - am) < 15.0 then
        PlaySoundFrontend(-1, "SAFE_DOOR_CLOSE", "SAFE_CRACK_SOUNDSET", true)
    end
    for af = 0, 90, 1 do
        local aE = GetEntityHeading(ag)
        SetEntityHeading(ag, aE - 1.0)
        Wait(16)
    end
end
function OpenSafeDoor(ag, am)
    local aF = 500
    Wait(aF)
    if #(CORRUPT.getPlayerCoords() - am) < 15.0 then
        PlaySoundFrontend(-1, "SAFE_DOOR_OPEN", "SAFE_CRACK_SOUNDSET", true)
    end
    for af = 0, 90, 1 do
        local aE = GetEntityHeading(ag)
        SetEntityHeading(ag, aE + 1.0)
        Wait(16)
    end
end
function RelockSafe(ai, b)
    ai = 1
    b = {}
    b = InitSafeLocks()
end
function GetCurrentSafeDialNumber(aG)
    local aH = math.round(100 * aG / 360)
    aH = math.abs(aH)
    if aH > 100 and aH < 200 then
        aH = aH - 100
    elseif aH >= 200 and aH < 300 then
        aH = aH - 200
    elseif aH >= 300 and aH < 400 then
        aH = aH - 300
    elseif aH >= 400 and aH < 500 then
        aH = aH - 400
    elseif aH >= 500 and aH < 600 then
        aH = aH - 500
    elseif aH >= 600 and aH < 700 then
        aH = aH - 600
    elseif aH >= 700 and aH < 800 then
        aH = aH - 700
    elseif aH >= 800 and aH < 900 then
        aH = aH - 800
    elseif aH >= 900 and aH < 1000 then
        aH = aH - 900
    elseif aH >= 1000 and aH < 1100 then
        aH = aH - 1000
    end
    return aH
end
function RotateSafeDial(aI)
    if aI == "rotation.anticlockwise" or aI == "rotation.clockwise" then
        local aJ = 1
        local aK
        if aI == "rotation.anticlockwise" then
            aK = 1
        else
            aK = -1
        end
        local aL = aK * aJ
        i = i + aL
        PlaySoundFrontend(-1, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", true)
    end
    d = aI
    e = aI
end
RegisterNetEvent(
    "CORRUPT:syncOpenSafeDoor",
    function(v)
        local aM = r[v].doorHandler
        local am = r[v].safePosition
        OpenSafeDoor(aM, am)
    end
)
RegisterNetEvent(
    "CORRUPT:syncCloseSafeDoor",
    function(v)
        local aM = r[v].doorHandler
        local am = r[v].safePosition
        CloseSafeDoor(aM, am)
    end
)
function EndMiniGame(v, ag)
    ClearPedTasks(CORRUPT.getPlayerPed())
    local aw = "mini@safe_cracking"
    loadAnimDict(aw)
    TaskPlayAnimAdvanced(
        CORRUPT.getPlayerPed(),
        aw,
        "door_open_succeed_stand",
        g.x,
        g.y,
        g.z,
        0.0,
        0.0,
        h,
        8.0,
        8.0,
        -1,
        2,
        0.3,
        0,
        0
    )
    RemoveAnimDict(aw)
    FreezeEntityPosition(CORRUPT.getPlayerPed(), false)
    Wait(2500)
    TriggerServerEvent("CORRUPT:syncOpenSafeDoor", v)
    safeCrackingState = "setup"
    _initRelockCountdown = true
end
function UnloadSafeCountdown()
    for af = 0, 12, 1 do
        if not _initRelockCountdown then
            break
        end
    end
    if _initRelockCountdown then
        RelockSafe()
    end
end
function InitSafeLocks(ac)
    local aN = {}
    for af = 1, #ac, 1 do
        aN[af] = true
    end
    return aN
end
function LoadResources()
    RequestStreamedTextureDict("MPSafeCracking", false)
    RequestAnimDict("mini@safe_cracking")
    local aO = 0
    while not HasStreamedTextureDictLoaded("MPSafeCracking") or not RequestAmbientAudioBank("SAFE_CRACK", false) or
        not HasAnimDictLoaded("mini@safe_cracking") do
        Wait(0)
    end
end
function GetDialProximityToTargetPin(ak, a, ai)
    local aP = a[ai]
    local aQ
    if d == "rotation.anticlockwise" or e == "rotation.anticlockwise" then
        aQ = aP - ak
    elseif d == "rotation.clockwise" or e == "rotation.clockwise" then
        aQ = ak - aP
    else
        aQ = 100
    end
    if aQ < 0 then
        aQ = aQ + 100
    end
    return aQ
end
function SetDialSpriteShake(aR)
    if aR == 5 or aR == 4 or aR == 95 or aR == 96 then
        l = math.random((0.48 - 0.00025) * 1000000000, (0.48 + 0.0005) * 1000000000) / 1000000000
        m = math.random((0.3 - 0.00025) * 1000000000, (0.3 + 0.0005) * 1000000000) / 1000000000
    elseif aR == 3 or aR == 2 or aR == 97 or aR == 98 then
        l = math.random((0.48 - 0.0005) * 1000000000, (0.48 + 0.0005) * 1000000000) / 1000000000
        m = math.random((0.3 - 0.0005) * 1000000000, (0.3 + 0.0005) * 1000000000) / 1000000000
    elseif aR == 1 or aR == 99 then
        l = math.random((0.48 - 0.001) * 1000000000, (0.48 + 0.001) * 1000000000) / 1000000000
        m = math.random((0.3 - 0.001) * 1000000000, (0.3 + 0.001) * 1000000000) / 1000000000
    elseif aR == 0 then
        l = math.random((0.48 - 0.002) * 1000000000, (0.48 + 0.002) * 1000000000) / 1000000000
        m = math.random((0.3 - 0.002) * 1000000000, (0.3 + 0.002) * 1000000000) / 1000000000
    else
        l = 0.48
        m = 0.3
    end
end
