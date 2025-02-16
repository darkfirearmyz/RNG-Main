local cfg = {}

cfg.items = {
  -- Copper
  ["copperore"] = {"Copper Ore", "", nil, 1}, 
  ["Copper"] = {"Copper", "", nil, 4},
  -- Limestone
  ["limestoneore"] = {"Limestone Ore", "", nil, 1}, 
  ["Limestone"] = {"Limestone", "", nil, 4},
  -- Weed
  ["dirtyweed"] = {"Weed leaf", "", nil, 1}, 
  ["Weed"] = {"Weed", "", nil, 4},
  -- Gold
  ["goldore"] = {"Gold Ore", "", nil, 1}, 
  ["Gold"] = {"Gold", "", nil, 4},
  -- Cocaine
  ["dirtycocaine"] = {"Coca leaf", "", nil, 1}, 
  ["Cocaine"] = {"Cocaine", "", nil, 4},
  -- Heroin
  ["dirtyheroin"] = {"Opium Poppy", "", nil, 1}, 
  ["Heroin"] = {"Heroin", "", nil, 4},
  -- Meth
  ["dirtymeth"] = {"Ephedra", "", nil, 1}, 
  ["Meth"] = {"Meth", "", nil, 4},
  -- Diamond
  ["uncutdiamond"] = {"Uncut Diamond", "", nil, 1}, 
  ["Diamond"] = {"Diamond", "", nil, 4},
  -- LSD
  ["dirtylsd"] = {"Frogs legs", "", nil, 1},
  ["refinedlsd"] = {"Lysergic Acid Amide", "", nil, 1}, 
  ["LSD"] = {"LSD", "", nil, 4},
  -- Bags
  ["Green Hiking Backpack (+40kg)"] = {"Green Hiking Backpack (+40kg)", "", nil, 5.00},
  ["Tan Hiking Backpack (+40kg)"] = {"Tan Hiking Backpack (+40kg)", "", nil, 5.00}, 
  ["Gucci Bag (+20kg)"] = {"Gucci Bag (+20kg)", "Just A Louis Vuitton Bag", nil, 5.00},
  ["Off White Bag (+15kg)"] = {"Off White Bag (+15kg)", "", nil, 5.00},
  ["Nike Bag (+30kg)"] = {"Nike Bag (+30kg)", "", nil, 5.00},
  ["Hunting Backpack (+35kg)"] = {"Hunting Backpack (+35kg)", "", nil, 5.00},
  ["Primark Bag (+30kg)"] = {"Primark Bag (+30kg)", "", nil, 5.00},
  ["Rebel Backpack (+70kg)"] = {"Rebel Backpack (+70kg)", "", nil, 5.00},
}

local function load_item_pack(name)
  local items = module("cfg/item/"..name)
  if items then
    for k,v in pairs(items) do
      cfg.items[k] = v
    end
  else
    print("[CORRUPT] item pack ["..name.."] not found")
  end
end

-- PACKS
load_item_pack("required")
load_item_pack("drugs")

return cfg
