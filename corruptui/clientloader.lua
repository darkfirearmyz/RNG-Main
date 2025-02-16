local CORRUPTEncryptionMethods = {}
local alreadyLoadedClientFiles = {}

CORRUPTEncryptionMethods.ResourceName = GetCurrentResourceName()
CORRUPTEncryptionMethods.MetadataString = "corrupt"
CORRUPTEncryptionMethods.NumResourceMetadata = GetNumResourceMetadata(CORRUPTEncryptionMethods.ResourceName, CORRUPTEncryptionMethods.MetadataString)

CORRUPTEncryptionMethods.Events = {
    Server = {
        requestFromServer = string.format("%s:requestFromServer", CORRUPTEncryptionMethods.ResourceName)
    },
    Client = {
        sendToClient = string.format("%s:sendToClient", CORRUPTEncryptionMethods.ResourceName),
        clientLoaded = string.format("%s:clientLoaded", CORRUPTEncryptionMethods.ResourceName)
    }
}

CORRUPTEncryptionMethods.Encrypt = function(value, cryptKey)
    local output = {}
    for i = 1, #value do
        output[i] = string.byte(value, i) * cryptKey
    end
    return output
end

CORRUPTEncryptionMethods.Decrypt = function(value, cryptKey)
    local output = {}
    for i = 1, #value do
        output[i] = string.char(math.floor(value[i] / cryptKey))
    end
    return table.concat(output)
end
if CORRUPTEncryptionMethods.NumResourceMetadata > 0 then
    if IsDuplicityVersion() then
        CORRUPTEncryptionMethods.LoadedPlayers = {}
        CORRUPTEncryptionMethods.LoadedClientFiles = {}
        RegisterNetEvent(CORRUPTEncryptionMethods.Events.Server.requestFromServer, function()
            while not CORRUPTEncryptionMethods.ClientFilesLoaded do Wait(1000) end
            if CORRUPTEncryptionMethods.LoadedPlayers[source] == nil then
                CORRUPTEncryptionMethods.LoadedPlayers[source] = false
            end
            if not CORRUPTEncryptionMethods.LoadedPlayers[source] then
                CORRUPTEncryptionMethods.LoadedPlayers[source] = true
                TriggerClientEvent(CORRUPTEncryptionMethods.Events.Client.sendToClient, source, CORRUPTEncryptionMethods.LoadedClientFiles)
            end
        end)
        CreateThread(function()
            local maxFiles = CORRUPTEncryptionMethods.NumResourceMetadata
            local loadedFiles = 0
            for i = 0, CORRUPTEncryptionMethods.NumResourceMetadata do
                local fileName = GetResourceMetadata(CORRUPTEncryptionMethods.ResourceName, CORRUPTEncryptionMethods.MetadataString, i)
                if fileName and not alreadyInTable(CORRUPTEncryptionMethods.LoadedClientFiles, fileName) then
                    local clientFile = LoadResourceFile(CORRUPTEncryptionMethods.ResourceName, fileName)
                    if clientFile then
                        local cryptKey = math.random(0x133769)
                        table.insert(CORRUPTEncryptionMethods.LoadedClientFiles, { name = fileName, code = CORRUPTEncryptionMethods.Encrypt(clientFile, cryptKey), cryptKey = cryptKey })
                        loadedFiles = loadedFiles + 1
                    end
                end
            end
            CORRUPTEncryptionMethods.ClientFilesLoaded = true
        end)
    else
        CORRUPTEncryptionMethods.ClientFilesLoading = false
        TriggerServerEvent(CORRUPTEncryptionMethods.Events.Server.requestFromServer)
        CreateThread(function()
            while true do
                Wait(0)
                if CORRUPTEncryptionMethods.ClientFilesLoaded then break end
                TriggerServerEvent(CORRUPTEncryptionMethods.Events.Server.requestFromServer)
                Wait(2500)
            end
        end)
        RegisterNetEvent(CORRUPTEncryptionMethods.Events.Client.sendToClient, function(clientFiles)
            if GetInvokingResource() or CORRUPTEncryptionMethods.ClientFilesLoading or CORRUPTEncryptionMethods.ClientFilesLoaded then return end
            CORRUPTEncryptionMethods.ClientFilesLoading = true
            for _, v in ipairs(clientFiles) do
                local fileLoaded = pcall(load(CORRUPTEncryptionMethods.Decrypt(v.code, v.cryptKey), v.name, "bt"))
            end
            TriggerEvent(CORRUPTEncryptionMethods.Events.Client.clientLoaded)
            CORRUPTEncryptionMethods.ClientFilesLoaded = true
            CORRUPTEncryptionMethods.ClientFilesLoading = false
        end)
    end
end

function alreadyInTable(files, fileName)
    for _, file in ipairs(files) do
        if file.name == fileName then
            return true
        end
    end
    return false
end

function printRed(message)
    print(string.format("^1[ERROR] ^0%s^0", message))
end
