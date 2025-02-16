local cfg = module("cfg/cfg_quests")

MySQL.createCommand("quests/add_id", "INSERT IGNORE INTO corrupt_quests SET user_id = @user_id")
MySQL.createCommand("quests/get_quests", "SELECT * FROM corrupt_quests WHERE user_id = @user_id")
MySQL.createCommand("quests/set_quests", "UPDATE corrupt_quests SET ? = @normal WHERE user_id = @user_id")

local maxFigurine = #cfg.quests["FIGURINE14"]
local maxHalloween = #cfg.quests["HALLOWEEN"]
local maxChristmas = #cfg.quests["CHRISTMAS"]

local function getDayAndMonth()
    local month = tonumber(os.date("%m"))
    local day = tonumber(os.date("%d"))
    return { month = month, day = day }
end

local function GiveReward(user_id, quest, count, maxCount, location)
    local source = CORRUPT.getUserSource(user_id)
    if quest == "FIGURINE14" or quest == "CHRISTMAS" then
        if count == maxCount then
            CORRUPT.GivePlatinumDays(user_id, 14)
            TriggerClientEvent("CORRUPT:questCollected", source, true, quest, location, count)
        else
            TriggerClientEvent("CORRUPT:questCollected", source, false, quest, location, count)
        end
    elseif quest == "HALLOWEEN" then
        CORRUPT.giveInventoryItem(user_id, "sweet", 1, true)
        if count == maxCount then
            TriggerClientEvent("CORRUPT:halloweenQuestCompleted", source, quest, location)
        end
    end
end

AddEventHandler("CORRUPTcli:playerSpawned", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    MySQL.query("quests/get_quests", { user_id = user_id }, function(rows, affected)
        if rows[1] then
            local completedQuests = {}
            local Normal = json.decode(rows[1].normal)
            local Halloween = json.decode(rows[1].halloween)
            local Christmas = json.decode(rows[1].christmas)
            if Normal then completedQuests["FIGURINE14"] = Normal end
            if Halloween then completedQuests["HALLOWEEN"] = Halloween end
            if Christmas then completedQuests["CHRISTMAS"] = Christmas end
            TriggerClientEvent("CORRUPT:questSendCompletedPositions", source, completedQuests, getDayAndMonth())
        else
            MySQL.execute("quests/add_id", { user_id = user_id })
            TriggerClientEvent("CORRUPT:questSendCompletedPositions", source, {}, getDayAndMonth())
        end
    end)
end)

RegisterServerEvent("CORRUPT:setQuestCompleted")
AddEventHandler("CORRUPT:setQuestCompleted", function(quest, location)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    MySQL.query("quests/get_quests", { user_id = user_id }, function(rows, affected)
        if rows[1] then
            local normal = json.decode(rows[1].normal)
            local halloween = json.decode(rows[1].halloween)
            local christmas = json.decode(rows[1].christmas)

            local function handleQuestCompletion(questType, questData, maxCount, rewardFunction, location)
                if not questData then questData = {} end
                if not table.has(questData, location) then
                    table.insert(questData, location)
                    rewardFunction(user_id, questType, #questData, maxCount, location)
                    local encodedData = json.encode(questData)
                    local sqlquest = "normal"
                    if questType == "CHRISTMAS" then
                        sqlquest = "christmas"
                    elseif questType == "HALLOWEEN" then
                        sqlquest = "halloween"
                    end  
                    exports["corrupt"]:execute("UPDATE corrupt_quests SET " .. sqlquest .. " = @data WHERE user_id = @user_id", { user_id = user_id, data = encodedData }, function() end)
                else
                    return
                end
            end
            if quest == "FIGURINE14" then
                handleQuestCompletion("FIGURINE14", normal, maxFigurine, GiveReward, location)
            elseif quest == "HALLOWEEN" then
                handleQuestCompletion("HALLOWEEN", halloween, maxHalloween, GiveReward, location)
            elseif quest == "CHRISTMAS" then
                handleQuestCompletion("CHRISTMAS", christmas, maxChristmas, GiveReward, location)
            end
        end
    end)
end)
