local cfg = {}

cfg.locations = {
    ["Morgue"] = {
        sides = {
            { -- Top Floor
                safePositions = {
                    vector3(247.13032531738, -1371.6429443359, 39.534332275391),
                    vector3(243.35469055176, -1376.2249755859, 39.534332275391)
                },
                pastGates = {
                    vector3(253.64044189453, -1363.8403320312, 39.534366607666),
                },
                gunStores = {
                    ["police"] = {
                        { "Organ Heist Small Arms", "policeSmallArms", vector3(229.17727661133, -1368.5501708984, 38.534297943115) },
                        { "Organ Heist Large Arms", "policeLargeArms", vector3(253.12821960449, -1387.9049072266, 38.534397125244) }
                    },
                    ["civ"] = {
                        { "Organ Heist Large Arms", "LargeArmsDealer", vector3(253.12821960449, -1387.9049072266, 38.534397125244) }
                    }
                },
                atmLocation = vector3(246.65653991699, -1384.5322265625, 39.534397125244)
            },
            { -- Bottom Floor
                safePositions = {
                    vector3(279.53131103516, -1336.73046875, 24.53777885437),
                    vector3(292.75506591797,-1349.1447753906,24.537817001343)
                },
                pastGates = {
                    vector3(243.51522827148, -1366.9970703125, 24.537815093994),
                },
                gunStores = {
                    ["police"] = {
                        { "Organ Heist Small Arms", "policeSmallArms", vector3(295.27334594727, -1351.6274414062, 23.534603118896) },
                        { "Organ Heist Large Arms", "policeLargeArms", vector3(285.91827392578, -1351.0128173828, 23.534603118896) }
                    },
                    ["civ"] = {
                        { "Organ Heist Large Arms", "LargeArmsDealer", vector3(285.91827392578, -1351.0128173828, 23.534603118896) }
                    }
                },
                atmLocation = vector3(294.95745849609, -1347.8728027344, 24.534603118896)
            }
        }
    },
    ["Abandoned Silo"] = {
        sides = {
            { -- Front End
                safePositions = {
                    vector3(569.11688232422, 5962.5517578125, -158.08581542969),
                    vector3(573.60113525391, 5961.6494140625, -158.08381652832)
                },
                pastGates = {
                    vector3(518.94403076172, 5919.232421875, -158.29566955566),
                },
                gunStores = {
                    ["police"] = {
                        { "Organ Heist Small Arms", "policeSmallArms", vector3(565.16070556641, 5942.6586914062, -159.08728027344) },
                        { "Organ Heist Large Arms", "policeLargeArms", vector3(571.04095458984, 5942.1025390625, -158.78784179688) }
                    },
                    ["civ"] = {
                        { "Organ Heist Large Arms", "LargeArmsDealer", vector3(571.04095458984, 5942.1025390625, -158.78784179688) }
                    }
                },
                atmLocation = vector3(575.4677734375, 5946.9716796875, -157.69018554688),
                interiorId = 268289,
                roomKey = -117021936
            },
            { -- Rear End
                safePositions = {
                    vector3(312.97689819336, 5945.4672851562, -158.2717590332),
                    vector3(314.65393066406, 5953.2099609375, -158.28521728516)
                },
                pastGates = {
                    vector3(440.00463867188, 5953.0498046875, -158.25993347168),
                    vector3(329.63888549805, 5923.6225585938, -158.25216674805)
                },
                gunStores = {
                    ["police"] = {
                        { "Organ Heist Small Arms", "policeSmallArms", vector3(335.59881591797, 5955.1450195312, -159.27177429199) },
                        { "Organ Heist Large Arms", "policeLargeArms", vector3(339.07601928711, 5950.896484375, -159.27177429199) }
                    },
                    ["civ"] = {
                        { "Organ Heist Large Arms", "LargeArmsDealer", vector3(339.07601928711, 5950.896484375, -159.27177429199) }
                    }
                },
                atmLocation = vector3(330.03457641602, 5954.736328125, -158.27177429199),
                interiorId = 265473,
                roomKey = 1714842308
            }
        },
        fakeCollisions = {
            {`prop_fnclink_10b`, vector3(586.3961, 5955.873, -159.0794), vector4(0.0, 0.0, 0.8870108, -0.4617486)},
            {`prop_fnclink_10b`, vector3(579.0892, 5945.438, -159.0764), vector4(0.0, 0.0, -0.8870109, 0.4617486)},
            {`prop_fnclink_10b`, vector3(307.9827, 5960.946, -159.0737), vector4(0.0, 0.0, 0.04361939, 0.9990482)},
            {`prop_fnclink_10b`, vector3(327.5648, 5919.182, -159.6559), vector4(0.0, 0.0, -0.5735765, 0.8191521)}
        }
    }
}

return cfg