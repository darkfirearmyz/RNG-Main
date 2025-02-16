local cfg = {}
local weapons = module("corrupt-assets", "cfg/weapons").weapons

cfg.kits = {
    ["shotgun"] = {
        name = "Shotgun Package",
        weapons = {
            "WEAPON_SPAZ",
            "WEAPON_OLYMPIA",
        },
        armour = 15,
        cooldown = 15,
        categoryAmmo = 100,
    },
    ["smg"] = {
        name = "SMG Package",
        weapons = {
            "WEAPON_SPACEFLIGHTMP5",
            "WEAPON_UMP45",
        },
        armour = 25,
        cooldown = 30,
        categoryAmmo = 250,
    },
    ["assault_rifle"] = {
        name = "Assault Rifle Package",
        weapons = {
            "WEAPON_AK74KASHNAR",
            "WEAPON_SPAR16",
        },
        armour = 100,
        cooldown = 45,
        categoryAmmo = 250,
    },
    ["sniper"] = {
        name = "Sniper Package",
        weapons = {
            "WEAPON_MOSIN",
            "WEAPON_MK14",
        },
        armour = 100,
        cooldown = 30,
        categoryAmmo = 100,
    }
    -- ["category_name"] = {
    --     name = "kit_name",
    --     weapons = {
    --         "WEAPON_SPAWNCODES",
    --     },
    --     armour = 15, -- as a % so 15 is 15% armour
    --     cooldown = 15, -- in minutes so 15 is 15 minutes between each kit redeem
    --     categoryAmmo = 100, -- amount of ammo each gun gets
    -- },
}

for k, v in pairs(cfg.kits) do
    local weaponNames = {}
    for _, weaponId in ipairs(v.weapons) do
        if weapons[weaponId] then
            table.insert(weaponNames, weapons[weaponId].name)
        else
            print("Could not find name of weapon: "..weaponId)
        end
    end
    v.includes = string.format("This Package Includes:\nWeapons: %s\nArmour: %d%%\nCooldown: %s",
    table.concat(weaponNames, ", "),
    v.armour,
    v.cooldown < 60 and string.format("%d minutes", v.cooldown) or "1 Hour")    
    local newWeaponsFormat = {}
    for _, weaponId in ipairs(v.weapons) do
        newWeaponsFormat[weaponId] = {name = weapons[weaponId].name}
    end
    v.weapons = newWeaponsFormat
end

-- https://i.imgur.com/64rg4P3.jpeg

return cfg