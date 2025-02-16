local outfitCodes = {}

RegisterNetEvent("CORRUPT:saveWardrobeOutfit")
AddEventHandler("CORRUPT:saveWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    CORRUPT.getUData(user_id, "CORRUPT:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        CORRUPTclient.getCustomization(source,{},function(custom)
            sets[outfitName] = custom
            CORRUPT.setUData(user_id,"CORRUPT:home:wardrobe",json.encode(sets))
            CORRUPT.notify(source,{"~g~Saved outfit "..outfitName.." to wardrobe!"})
            TriggerClientEvent("CORRUPT:refreshOutfitMenu", source, sets)
        end)
    end)
end)

RegisterNetEvent("CORRUPT:deleteWardrobeOutfit")
AddEventHandler("CORRUPT:deleteWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    CORRUPT.getUData(user_id, "CORRUPT:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        sets[outfitName] = nil
        CORRUPT.setUData(user_id,"CORRUPT:home:wardrobe",json.encode(sets))
        CORRUPT.notify(source,{"Remove outfit "..outfitName.." from wardrobe!"})
        TriggerClientEvent("CORRUPT:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("CORRUPT:equipWardrobeOutfit")
AddEventHandler("CORRUPT:equipWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    CORRUPT.getUData(user_id, "CORRUPT:home:wardrobe", function(data)
        local sets = json.decode(data)
        CORRUPTclient.setCustomization(source, {sets[outfitName]})
        CORRUPTclient.getHairAndTats(source, {})
    end)
end)

RegisterNetEvent("CORRUPT:initWardrobe")
AddEventHandler("CORRUPT:initWardrobe", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    CORRUPT.getUData(user_id, "CORRUPT:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        TriggerClientEvent("CORRUPT:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("CORRUPT:getCurrentOutfitCode")
AddEventHandler("CORRUPT:getCurrentOutfitCode", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    CORRUPTclient.getCustomization(source,{},function(custom)
        local uuid = string.upper(generateUUID("outfitcode", 5, "alphanumeric"))
        outfitCodes[uuid] = custom
        CORRUPTclient.copyToClipboard(source, {uuid})
        CORRUPT.notify(source, {"~g~Outfit code copied to clipboard."})
        CORRUPT.notify(source, {"The code ~y~"..uuid.."~w~ will persist until restart."})
    end)
end)

RegisterNetEvent("CORRUPT:applyOutfitCode")
AddEventHandler("CORRUPT:applyOutfitCode", function(outfitCode)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if outfitCodes[outfitCode] ~= nil then
        CORRUPTclient.setCustomization(source, {outfitCodes[outfitCode]})
        CORRUPT.notify(source, {"~g~Outfit code applied."})
        CORRUPTclient.getHairAndTats(source, {})
    else
        CORRUPT.notify(source, {"Outfit code not found."})
    end
end)

RegisterCommand('wardrobe', function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, 'Founder') or CORRUPT.hasGroup(user_id, 'Developer') or CORRUPT.hasGroup(user_id, 'Lead Developer') then
        TriggerClientEvent("CORRUPT:openOutfitMenu", source)
    end
end)

RegisterCommand('copyfit', function(source, args)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local permid = tonumber(args[1])
    if CORRUPT.hasGroup(user_id, 'Founder') or CORRUPT.hasGroup(user_id, 'Developer') or CORRUPT.hasGroup(user_id, 'Lead Developer') then
        CORRUPTclient.getCustomization(CORRUPT.getUserSource(permid),{},function(custom)
            CORRUPTclient.setCustomization(source, {custom})
        end)
    end
end)