local a = false
cam = nil
local b = 332.219879
local c = "visage"
local d = false
local e = true
local f = false
local g, h
SkinConfig = {}
SkinConfig.Locale = "en"
Locales = {}
Locales["en"] = {
    ["sex"] = "sex",
    ["face"] = "face",
    ["skin"] = "skin",
    ["wrinkles"] = "wrinkles",
    ["wrinkle_thickness"] = "wrinkle thickness",
    ["beard_type"] = "beard type",
    ["beard_size"] = "beard size",
    ["beard_color_1"] = "beard color 1",
    ["beard_color_2"] = "beard color 2",
    ["hair_1"] = "hair 1",
    ["hair_2"] = "hair 2",
    ["hair_color_1"] = "hair color 1",
    ["hair_color_2"] = "hair color 2",
    ["eye_color"] = "eye color",
    ["eyebrow_type"] = "eyebrow type",
    ["eyebrow_size"] = "eyebrow size",
    ["eyebrow_color_1"] = "eyebrow color 1",
    ["eyebrow_color_2"] = "eyebrow color 2",
    ["makeup_type"] = "makeup type",
    ["makeup_thickness"] = "makeup thickness",
    ["makeup_color_1"] = "makeup color 1",
    ["makeup_color_2"] = "makeup color 2",
    ["lipstick_type"] = "lipstick type",
    ["lipstick_thickness"] = "lipstick thickness",
    ["lipstick_color_1"] = "lipstick color 1",
    ["lipstick_color_2"] = "lipstick color 2",
    ["ear_accessories"] = "ear accessories",
    ["ear_accessories_color"] = "ear accessories color",
    ["tshirt_1"] = "t-Shirt 1",
    ["tshirt_2"] = "t-Shirt 2",
    ["torso_1"] = "torso 1",
    ["torso_2"] = "torso 2",
    ["decals_1"] = "decals 1",
    ["decals_2"] = "decals 2",
    ["arms"] = "arms",
    ["arms_2"] = "arms 2",
    ["pants_1"] = "pants 1",
    ["pants_2"] = "pants 2",
    ["shoes_1"] = "shoes 1",
    ["shoes_2"] = "shoes 2",
    ["mask_1"] = "mask 1",
    ["mask_2"] = "mask 2",
    ["bproof_1"] = "bulletproof vest 1",
    ["bproof_2"] = "bulletproof vest 2",
    ["chain_1"] = "chain 1",
    ["chain_2"] = "chain 2",
    ["helmet_1"] = "helmet 1",
    ["helmet_2"] = "helmet 2",
    ["watches_1"] = "watches 1",
    ["watches_2"] = "watches 2",
    ["bracelets_1"] = "bracelets 1",
    ["bracelets_2"] = "bracelets 2",
    ["glasses_1"] = "glasses 1",
    ["glasses_2"] = "glasses 2",
    ["bag"] = "bag",
    ["bag_color"] = "bag color",
    ["blemishes"] = "blemishes",
    ["blemishes_size"] = "blemishes thickness",
    ["ageing"] = "ageing",
    ["ageing_1"] = "ageing thickness",
    ["blush"] = "blush",
    ["blush_1"] = "blush thickness",
    ["blush_color"] = "blush color",
    ["complexion"] = "complexion",
    ["complexion_1"] = "complexion thickness",
    ["sun"] = "sun",
    ["sun_1"] = "sun thickness",
    ["freckles"] = "freckles",
    ["freckles_1"] = "freckles thickness",
    ["chest_hair"] = "chest hair",
    ["chest_hair_1"] = "chest hair thickness",
    ["chest_color"] = "chest hair color",
    ["bodyb"] = "body blemishes",
    ["bodyb_size"] = "body blemishes thickness"
}
function _(i, ...)
    if Locales[SkinConfig.Locale] ~= nil then
        if Locales[SkinConfig.Locale][i] ~= nil then
            return string.format(Locales[SkinConfig.Locale][i], ...)
        else
            return "Translation [" .. SkinConfig.Locale .. "][" .. i .. "] does not exist"
        end
    else
        return "Locale [" .. SkinConfig.Locale .. "] does not exist"
    end
end
function _U(i, ...)
    return tostring(_(i, ...):gsub("^%l", string.upper))
end
local j = {
    {label = _U("sex"), name = "sex", value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65},
    {label = _U("face"), name = "face", value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65},
    {label = _U("skin"), name = "skin", value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65},
    {label = _U("hair_1"), name = "hair_1", value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65},
    {label = _U("hair_2"), name = "hair_2", value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65},
    {label = _U("hair_color_1"), name = "hair_color_1", value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65},
    {label = _U("hair_color_2"), name = "hair_color_2", value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65},
    {label = _U("tshirt_1"), name = "tshirt_1", value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15},
    {
        label = _U("tshirt_2"),
        name = "tshirt_2",
        value = 0,
        min = 0,
        zoomOffset = 0.75,
        camOffset = 0.15,
        textureof = "tshirt_1"
    },
    {label = _U("torso_1"), name = "torso_1", value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15},
    {
        label = _U("torso_2"),
        name = "torso_2",
        value = 0,
        min = 0,
        zoomOffset = 0.75,
        camOffset = 0.15,
        textureof = "torso_1"
    },
    {label = _U("decals_1"), name = "decals_1", value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15},
    {
        label = _U("decals_2"),
        name = "decals_2",
        value = 0,
        min = 0,
        zoomOffset = 0.75,
        camOffset = 0.15,
        textureof = "decals_1"
    },
    {label = _U("arms"), name = "arms", value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15},
    {label = _U("arms_2"), name = "arms_2", value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15},
    {label = _U("pants_1"), name = "pants_1", value = 0, min = 0, zoomOffset = 0.8, camOffset = -0.5},
    {
        label = _U("pants_2"),
        name = "pants_2",
        value = 0,
        min = 0,
        zoomOffset = 0.8,
        camOffset = -0.5,
        textureof = "pants_1"
    },
    {label = _U("shoes_1"), name = "shoes_1", value = 0, min = 0, zoomOffset = 0.8, camOffset = -0.8},
    {
        label = _U("shoes_2"),
        name = "shoes_2",
        value = 0,
        min = 0,
        zoomOffset = 0.8,
        camOffset = -0.8,
        textureof = "shoes_1"
    },
    {label = _U("mask_1"), name = "mask_1", value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65},
    {
        label = _U("mask_2"),
        name = "mask_2",
        value = 0,
        min = 0,
        zoomOffset = 0.6,
        camOffset = 0.65,
        textureof = "mask_1"
    },
    {label = _U("bproof_1"), name = "bproof_1", value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15},
    {
        label = _U("bproof_2"),
        name = "bproof_2",
        value = 0,
        min = 0,
        zoomOffset = 0.75,
        camOffset = 0.15,
        textureof = "bproof_1"
    },
    {label = _U("chain_1"), name = "chain_1", value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65},
    {
        label = _U("chain_2"),
        name = "chain_2",
        value = 0,
        min = 0,
        zoomOffset = 0.6,
        camOffset = 0.65,
        textureof = "chain_1"
    },
    {
        label = _U("helmet_1"),
        name = "helmet_1",
        value = -1,
        min = -1,
        zoomOffset = 0.6,
        camOffset = 0.65,
        componentId = 0
    },
    {
        label = _U("helmet_2"),
        name = "helmet_2",
        value = 0,
        min = 0,
        zoomOffset = 0.6,
        camOffset = 0.65,
        textureof = "helmet_1"
    },
    {label = _U("glasses_1"), name = "glasses_1", value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65},
    {
        label = _U("glasses_2"),
        name = "glasses_2",
        value = 0,
        min = 0,
        zoomOffset = 0.6,
        camOffset = 0.65,
        textureof = "glasses_1"
    },
    {label = _U("watches_1"), name = "watches_1", value = -1, min = -1, zoomOffset = 0.75, camOffset = 0.15},
    {
        label = _U("watches_2"),
        name = "watches_2",
        value = 0,
        min = 0,
        zoomOffset = 0.75,
        camOffset = 0.15,
        textureof = "watches_1"
    },
    {label = _U("bracelets_1"), name = "bracelets_1", value = -1, min = -1, zoomOffset = 0.75, camOffset = 0.15},
    {
        label = _U("bracelets_2"),
        name = "bracelets_2",
        value = 0,
        min = 0,
        zoomOffset = 0.75,
        camOffset = 0.15,
        textureof = "bracelets_1"
    },
    {label = _U("bag"), name = "bags_1", value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15},
    {
        label = _U("bag_color"),
        name = "bags_2",
        value = 0,
        min = 0,
        zoomOffset = 0.75,
        camOffset = 0.15,
        textureof = "bags_1"
    },
    {label = _U("eye_color"), name = "eye_color", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("eyebrow_size"), name = "eyebrows_2", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("eyebrow_type"), name = "eyebrows_1", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("eyebrow_color_1"), name = "eyebrows_3", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("eyebrow_color_2"), name = "eyebrows_4", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("makeup_type"), name = "makeup_1", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("makeup_thickness"), name = "makeup_2", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("makeup_color_1"), name = "makeup_3", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("makeup_color_2"), name = "makeup_4", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("lipstick_type"), name = "lipstick_1", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("lipstick_thickness"), name = "lipstick_2", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("lipstick_color_1"), name = "lipstick_3", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("lipstick_color_2"), name = "lipstick_4", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("ear_accessories"), name = "ears_1", value = -1, min = -1, zoomOffset = 0.4, camOffset = 0.65},
    {
        label = _U("ear_accessories_color"),
        name = "ears_2",
        value = 0,
        min = 0,
        zoomOffset = 0.4,
        camOffset = 0.65,
        textureof = "ears_1"
    },
    {label = _U("chest_hair"), name = "chest_1", value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15},
    {label = _U("chest_hair_1"), name = "chest_2", value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15},
    {label = _U("chest_color"), name = "chest_3", value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15},
    {label = _U("bodyb"), name = "bodyb_1", value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15},
    {label = _U("bodyb_size"), name = "bodyb_2", value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15},
    {label = _U("wrinkles"), name = "age_1", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("wrinkle_thickness"), name = "age_2", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("blemishes"), name = "blemishes_1", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("blemishes_size"), name = "blemishes_2", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("blush"), name = "blush_1", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("blush_1"), name = "blush_2", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("blush_color"), name = "blush_3", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("complexion"), name = "complexion_1", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("complexion_1"), name = "complexion_2", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("sun"), name = "sun_1", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("sun_1"), name = "sun_2", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("freckles"), name = "moles_1", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("freckles_1"), name = "moles_2", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("beard_type"), name = "beard_1", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("beard_size"), name = "beard_2", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("beard_color_1"), name = "beard_3", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65},
    {label = _U("beard_color_2"), name = "beard_4", value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65}
}
local k = {}
for l = 1, #j, 1 do
    k[j[l].name] = j[l].value
end
function GetMaxVals()
    local m = PlayerPedId()
    local n = {
        sex = 1,
        face = 45,
        skin = 45,
        age_1 = GetPedHeadOverlayNum(3) - 1,
        age_2 = 10,
        beard_1 = GetPedHeadOverlayNum(1) - 1,
        beard_2 = 10,
        beard_3 = GetNumHairColors() - 1,
        beard_4 = GetNumHairColors() - 1,
        hair_1 = GetNumberOfPedDrawableVariations(m, 2) - 1,
        hair_2 = GetNumberOfPedTextureVariations(m, 2, k["hair_1"]) - 1,
        hair_color_1 = GetNumHairColors() - 1,
        hair_color_2 = GetNumHairColors() - 1,
        eye_color = 31,
        eyebrows_1 = GetPedHeadOverlayNum(2) - 1,
        eyebrows_2 = 10,
        eyebrows_3 = GetNumHairColors() - 1,
        eyebrows_4 = GetNumHairColors() - 1,
        makeup_1 = GetPedHeadOverlayNum(4) - 1,
        makeup_2 = 10,
        makeup_3 = GetNumHairColors() - 1,
        makeup_4 = GetNumHairColors() - 1,
        lipstick_1 = GetPedHeadOverlayNum(8) - 1,
        lipstick_2 = 10,
        lipstick_3 = GetNumHairColors() - 1,
        lipstick_4 = GetNumHairColors() - 1,
        blemishes_1 = GetPedHeadOverlayNum(0) - 1,
        blemishes_2 = 10,
        blush_1 = GetPedHeadOverlayNum(5) - 1,
        blush_2 = 10,
        blush_3 = GetNumHairColors() - 1,
        complexion_1 = GetPedHeadOverlayNum(6) - 1,
        complexion_2 = 10,
        sun_1 = GetPedHeadOverlayNum(7) - 1,
        sun_2 = 10,
        moles_1 = GetPedHeadOverlayNum(9) - 1,
        moles_2 = 10,
        chest_1 = GetPedHeadOverlayNum(10) - 1,
        chest_2 = 10,
        chest_3 = GetNumHairColors() - 1,
        bodyb_1 = GetPedHeadOverlayNum(11) - 1,
        bodyb_2 = 10,
        ears_1 = GetNumberOfPedPropDrawableVariations(m, 1) - 1,
        ears_2 = GetNumberOfPedPropTextureVariations(m, 1, k["ears_1"] - 1),
        tshirt_1 = GetNumberOfPedDrawableVariations(m, 8) - 1,
        tshirt_2 = GetNumberOfPedTextureVariations(m, 8, k["tshirt_1"]) - 1,
        torso_1 = GetNumberOfPedDrawableVariations(m, 11) - 1,
        torso_2 = GetNumberOfPedTextureVariations(m, 11, k["torso_1"]) - 1,
        decals_1 = GetNumberOfPedDrawableVariations(m, 10) - 1,
        decals_2 = GetNumberOfPedTextureVariations(m, 10, k["decals_1"]) - 1,
        arms = GetNumberOfPedDrawableVariations(m, 3) - 1,
        arms_2 = 10,
        pants_1 = GetNumberOfPedDrawableVariations(m, 4) - 1,
        pants_2 = GetNumberOfPedTextureVariations(m, 4, k["pants_1"]) - 1,
        shoes_1 = GetNumberOfPedDrawableVariations(m, 6) - 1,
        shoes_2 = GetNumberOfPedTextureVariations(m, 6, k["shoes_1"]) - 1,
        mask_1 = GetNumberOfPedDrawableVariations(m, 1) - 1,
        mask_2 = GetNumberOfPedTextureVariations(m, 1, k["mask_1"]) - 1,
        bproof_1 = GetNumberOfPedDrawableVariations(m, 9) - 1,
        bproof_2 = GetNumberOfPedTextureVariations(m, 9, k["bproof_1"]) - 1,
        chain_1 = GetNumberOfPedDrawableVariations(m, 7) - 1,
        chain_2 = GetNumberOfPedTextureVariations(m, 7, k["chain_1"]) - 1,
        bags_1 = GetNumberOfPedDrawableVariations(m, 5) - 1,
        bags_2 = GetNumberOfPedTextureVariations(m, 5, k["bags_1"]) - 1,
        helmet_1 = GetNumberOfPedPropDrawableVariations(m, 0) - 1,
        helmet_2 = GetNumberOfPedPropTextureVariations(m, 0, k["helmet_1"]) - 1,
        glasses_1 = GetNumberOfPedPropDrawableVariations(m, 1) - 1,
        glasses_2 = GetNumberOfPedPropTextureVariations(m, 1, k["glasses_1"] - 1),
        watches_1 = GetNumberOfPedPropDrawableVariations(m, 6) - 1,
        watches_2 = GetNumberOfPedPropTextureVariations(m, 6, k["watches_1"]) - 1,
        bracelets_1 = GetNumberOfPedPropDrawableVariations(m, 7) - 1,
        bracelets_2 = GetNumberOfPedPropTextureVariations(m, 7, k["bracelets_1"] - 1)
    }
    return n
end
AddEventHandler(
    "skinchanger:getData",
    function(o)
        local p = json.decode(json.encode(j))
        for q, v in pairs(k) do
            for l = 1, #p, 1 do
                if q == p[l].name then
                    p[l].value = v
                end
            end
        end
        o(p, GetMaxVals())
    end
)
RegisterNUICallback(
    "updateLeftWristComponent",
    function(n)
        n.componentID = math.floor(n.componentID + 0)
        SetPedPropIndex(GetPlayerPed(-1), 6, n.componentID, 0, 2)
    end
)
RegisterNUICallback(
    "updateLeftWristTexture",
    function(n)
        n.componentID = math.floor(n.componentID - 1)
        n.textureID = math.floor(n.textureID + 0)
        SetPedPropIndex(GetPlayerPed(-1), 6, n.componentID, n.textureID, 2)
    end
)
RegisterNUICallback(
    "updateRightWristComponent",
    function(n)
        n.componentID = math.floor(n.componentID + 0)
        SetPedPropIndex(GetPlayerPed(-1), 7, n.componentID, 0, 2)
    end
)
RegisterNUICallback(
    "updateRightWristTexture",
    function(n)
        n.componentID = math.floor(n.componentID - 1)
        n.textureID = math.floor(n.textureID + 0)
        SetPedPropIndex(GetPlayerPed(-1), 7, n.componentID, n.textureID, 2)
    end
)
RegisterNUICallback(
    "updateSkin",
    function(n)
        v = n.value
        dad = tonumber(n.dad)
        mum = tonumber(n.mum)
        dadmumpercent = tonumber(n.dadmumpercent)
        skin = tonumber(n.skin)
        eyecolor = tonumber(n.eyecolor)
        acne = tonumber(n.acne)
        skinproblem = tonumber(n.skinproblem)
        freckle = tonumber(n.freckle)
        wrinkle = tonumber(n.wrinkle)
        wrinkleopacity = tonumber(n.wrinkleopacity)
        hair = tonumber(n.hair)
        haircolor = tonumber(n.haircolor)
        eyebrow = tonumber(n.eyebrow)
        eyebrowopacity = tonumber(n.eyebrowopacity)
        beard = tonumber(n.beard)
        beardopacity = tonumber(n.beardopacity)
        beardcolor = tonumber(n.beardcolor)
        hats = tonumber(n.hats)
        hats_texture = tonumber(n.hats_texture)
        glasses = tonumber(n.glasses)
        glasses_texture = tonumber(n.glasses_texture)
        ears = tonumber(n.ears)
        tops = tonumber(n.tops)
        pants = tonumber(n.pants)
        shoes = tonumber(n.shoes)
        watches = tonumber(n.watches)
        lipstick = tonumber(n.lipstick)
        lipstickcolour = tonumber(n.lipstickcolour)
        eyeshadow = tonumber(n.eyeshadow)
        eyeshadowcolour = tonumber(n.eyeshadowcolour)
        facepaints = tonumber(n.facepaints) + 16
        facepaintscolour = tonumber(n.facepaintscolour)
        if v == true then
            CloseSkinCreator()
        else
            local r = nil
            local s = GetEntityModel(GetPlayerPed(-1))
            if s == `mp_m_freemode_01` then
                r = "mp_m_freemode_01"
                if dadmumpercent > 5 then
                    local t = PlayerId()
                    local s = `mp_f_freemode_01`
                    RequestModel(s)
                    while not HasModelLoaded(s) do
                        Wait(100)
                    end
                    SetModelAsNoLongerNeeded(s)
                end
            elseif s == `mp_f_freemode_01` then
                r = "mp_f_freemode_01"
                if dadmumpercent <= 5 then
                    local t = PlayerId()
                    local s = `mp_m_freemode_01`
                    RequestModel(s)
                    while not HasModelLoaded(s) do
                        Wait(100)
                    end
                    SetModelAsNoLongerNeeded(s)
                end
            end
            dadmumpercent = tonumber(n.dadmumpercent) / 10 + 0.0
            SetPedHeadBlendData(
                GetPlayerPed(-1),
                dad,
                mum,
                0,
                skin,
                skin,
                skin,
                dadmumpercent,
                dadmumpercent,
                0.0,
                false
            )
            SetPedEyeColor(GetPlayerPed(-1), eyecolor)
            if acne == 0 then
                SetPedHeadOverlay(GetPlayerPed(-1), 0, acne, 0.0)
            else
                SetPedHeadOverlay(GetPlayerPed(-1), 0, acne, 1.0)
            end
            SetPedHeadOverlay(GetPlayerPed(-1), 6, skinproblem, 1.0)
            if freckle == 0 then
                SetPedHeadOverlay(GetPlayerPed(-1), 9, freckle, 0.0)
            else
                SetPedHeadOverlay(GetPlayerPed(-1), 9, freckle, 1.0)
            end
            SetPedHeadOverlay(GetPlayerPed(-1), 3, wrinkle, wrinkleopacity * 0.1)
            SetPedComponentVariation(GetPlayerPed(-1), 2, hair, 0, 2)
            SetPedHairColor(GetPlayerPed(-1), haircolor, haircolor)
            SetPedHeadOverlay(GetPlayerPed(-1), 2, eyebrow, eyebrowopacity * 0.1)
            SetPedHeadOverlay(GetPlayerPed(-1), 1, beard, beardopacity * 0.1)
            SetPedHeadOverlayColor(GetPlayerPed(-1), 1, 1, beardcolor, beardcolor)
            SetPedHeadOverlayColor(GetPlayerPed(-1), 2, 1, beardcolor, beardcolor)
            eyeShadowOpacity = 1.0
            if eyeshadow == 0 then
                eyeShadowOpacity = 0.0
            end
            lipstickOpacity = 1.0
            if lipstick == 0 then
                lipstickOpacity = 0.0
            end
            SetPedHeadOverlay(GetPlayerPed(-1), 4, eyeshadow, eyeShadowOpacity)
            SetPedHeadOverlay(GetPlayerPed(-1), 8, lipstick, lipstickOpacity)
            SetPedHeadOverlayColor(GetPlayerPed(-1), 4, 1, eyeshadowcolour, eyeshadowcolour)
            SetPedHeadOverlayColor(GetPlayerPed(-1), 8, 1, lipstickcolour, lipstickcolour)
            SetPedHeadOverlay(GetPlayerPed(-1), 4, facepaints, 1.0)
            SetPedHeadOverlayColor(GetPlayerPed(-1), 4, 1, facepaintscolour, 0)
            SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 2)
            faceSaveData = {}
            faceSaveData["dad"] = dad
            faceSaveData["mum"] = mum
            faceSaveData["skin"] = skin
            faceSaveData["dadmumpercent"] = dadmumpercent
            faceSaveData["eyecolor"] = eyecolor
            faceSaveData["acne"] = acne
            faceSaveData["skinproblem"] = skinproblem
            faceSaveData["freckle"] = freckle
            faceSaveData["wrinkle"] = wrinkle
            faceSaveData["wrinkleopacity"] = wrinkleopacity
            faceSaveData["hair"] = hair
            faceSaveData["haircolor"] = haircolor
            faceSaveData["eyebrow"] = eyebrow
            faceSaveData["eyebrowopacity"] = eyebrowopacity
            faceSaveData["beard"] = beard
            faceSaveData["beardopacity"] = beardopacity
            faceSaveData["beardcolor"] = beardcolor
            faceSaveData["eyeshadow"] = eyeshadow
            faceSaveData["lipstick"] = lipstick
            faceSaveData["eyeshadowcolour"] = eyeshadowcolour
            faceSaveData["lipstickcolour"] = lipstickcolour
            faceSaveData["facepaints"] = facepaints
            faceSaveData["facepaintscolour"] = facepaintscolour
            TriggerServerEvent("CORRUPT:saveFaceData", faceSaveData)
        end
    end
)
RegisterNUICallback(
    "rotateleftheading",
    function(n)
        local u = GetEntityHeading(GetPlayerPed(-1))
        SetEntityHeading(GetPlayerPed(-1), u - 10)
    end
)
RegisterNUICallback(
    "rotaterightheading",
    function(n)
        local u = GetEntityHeading(GetPlayerPed(-1))
        SetEntityHeading(GetPlayerPed(-1), u + 10)
    end
)
RegisterNUICallback(
    "zoom",
    function(n)
        c = n.zoom
        local w, x, y = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
        if c == "visage" or c == "pilosite" then
            SetCamCoord(cam, w + 0.2, x + 0.5, y + 0.7)
            SetCamRot(cam, 0.0, 0.0, 150.0, 2)
        elseif c == "vetements" then
            SetCamCoord(cam, w + 0.3, x + 2.0, y + 0.3)
            SetCamRot(cam, 0.0, 0.0, 170.0, 2)
        end
    end
)
RegisterNUICallback(
    "zoomin",
    function(n)
        local w, x, y = table.unpack(GetCamCoord(cam))
        SetCamFov(cam, GetCamFov(cam) - 1.0)
    end
)
RegisterNUICallback(
    "zoomout",
    function(n)
        local w, x, y = table.unpack(GetCamCoord(cam))
        SetCamFov(cam, GetCamFov(cam) + 1.0)
    end
)
function CloseSkinCreator()
    local z = PlayerPedId()
    a = false
    ShowSkinCreator(false)
    d = false
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil
    SetPlayerInvincible(z, false)
end
function ShowSkinCreator(A)
    local B = {}
    TriggerEvent(
        "skinchanger:getData",
        function(p, C)
            local D = {}
            for l = 1, #p, 1 do
                D[l] = p[l]
            end
            for l = 1, #D, 1 do
                local E = D[l].value
                local F = D[l].componentId
                if F == 0 then
                    E = GetPedPropIndex(PlayerPedId(), D[l].componentId)
                end
                local n = {label = D[l].label, name = D[l].name, value = E, min = D[l].min}
                for q, v in pairs(C) do
                    if q == D[l].name then
                        n.max = v
                        break
                    end
                end
                table.insert(B, n)
            end
        end
    )
    SetNuiFocus(A, A)
    SendNUIMessage({openSkinCreator = A})
    for G, n in ipairs(B) do
        local H, I
        for J, E in pairs(n) do
            if J == "name" then
                H = E
            end
            if J == "max" then
                I = E
            end
        end
        SendNUIMessage({type = "updateMaxVal", classname = H, maxVal = I})
    end
end
function SkinCreator(A)
    local z = GetPlayerPed(-1)
    ShowSkinCreator(A)
    if A == true then
        DisableControlAction(2, 14, true)
        DisableControlAction(2, 15, true)
        DisableControlAction(2, 16, true)
        DisableControlAction(2, 17, true)
        DisableControlAction(2, 30, true)
        DisableControlAction(2, 31, true)
        DisableControlAction(2, 32, true)
        DisableControlAction(2, 33, true)
        DisableControlAction(2, 34, true)
        DisableControlAction(2, 35, true)
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 24, true)
        if IsDisabledControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 142) then
            SendNUIMessage({type = "click"})
        end
        SetPlayerInvincible(z, true)
        RenderScriptCams(false, false, 0, 1, 0)
        Citizen.CreateThread(
            function()
                cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                local K = GetEntityCoords(GetPlayerPed(-1))
                SetCamCoord(cam, K.x, K.y, K.z)
                SetCamRot(cam, 0.0, 0.0, 0.0, 2)
                SetCamActive(cam, true)
                RenderScriptCams(true, false, 0, true, true)
                SetCamCoord(cam, K.x, K.y, K.z)
                local w, x, y = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
                if c == "visage" or c == "pilosite" then
                    SetCamCoord(cam, w + 0.2, x + 0.5, y + 0.7)
                    SetCamRot(cam, 0.0, 0.0, 150.0, 2)
                elseif c == "vetements" then
                    SetCamCoord(cam, w + 0.3, x + 2.0, y - 1.0)
                    SetCamRot(cam, 0.0, 0.0, 170.0, 2)
                end
            end
        )
    else
        FreezeEntityPosition(z, false)
        SetPlayerInvincible(z, false)
    end
end
Citizen.CreateThread(
    function()
        while true do
            if a then
                InvalidateIdleCam()
            end
            Wait(1000)
        end
    end
)
AddEventHandler(
    "CORRUPT:openBarbershop",
    function()
        if not a then
            d = true
            SkinCreator(true)
        end
    end
)
