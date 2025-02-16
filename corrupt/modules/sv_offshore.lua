CreateThread(function()
    Wait(1000)
    exports['corrupt']:execute('CREATE TABLE IF NOT EXISTS corrupt_offshore (user_id VARCHAR(50) NOT NULL, balance INT NOT NULL DEFAULT 0, PRIMARY KEY (user_id));', {})
end)

RegisterServerEvent('CORRUPT:depositOffshoreMoney')
AddEventHandler('CORRUPT:depositOffshoreMoney', function(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local amount = tonumber(amount)
    if CORRUPT.tryBankPayment(user_id, amount) then
        exports['corrupt']:execute('UPDATE corrupt_offshore SET balance = balance + @amount WHERE user_id = @user_id', {
            ['@user_id'] = user_id,
            ['@amount'] = amount - amount * 0.01
        })
        local formatted = getMoneyStringFormatted(amount - amount * 0.01)
        CORRUPT.notify(source, {"~g~You have deposited £" .. formatted .. " with a 1% fee into your offshore account."})
        initOffshoreMoney(source, user_id)
    else
        exports["lb-phone"]:SendNotification(source, {
            app = "offshore",
            title = "Offshore",
            content = "You Do Not Have Enough Money",
            icon = "https://cdn.discordapp.com/attachments/1200853764018544700/1208530865479622746/icon.png?ex=65e39f13&is=65d12a13&hm=2c4b97db3f7c0f1673121b1ec073983da3fc6766276eda904be6630a44db609f&"
        }, function(res)
        end)
    end
end)

RegisterServerEvent('CORRUPT:withdrawOffshoreMoney')
AddEventHandler('CORRUPT:withdrawOffshoreMoney', function(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local amount = tonumber(amount)
    exports['corrupt']:execute('SELECT balance FROM corrupt_offshore WHERE user_id = @user_id', {['@user_id'] = user_id}, function(result)
        local offshore = result[1].balance
        if amount > offshore then
            exports["lb-phone"]:SendNotification(source, {
                app = "offshore",
                title = "Offshore",
                content = "You Do Not Have Enough Money",
                icon = "https://cdn.discordapp.com/attachments/1200853764018544700/1208530865479622746/icon.png?ex=65e39f13&is=65d12a13&hm=2c4b97db3f7c0f1673121b1ec073983da3fc6766276eda904be6630a44db609f&"
            }, function(res)
            end)
        else
            exports['corrupt']:execute('UPDATE corrupt_offshore SET balance = balance - @amount WHERE user_id = @user_id', {
                ['@user_id'] = user_id,
                ['@amount'] = amount
            })
            CORRUPT.notify(source, {"~g~You have withdrawn £" .. getMoneyStringFormatted(amount) .. " from your offshore account."})
            CORRUPT.giveBankMoney(user_id, amount)
            initOffshoreMoney(source, user_id)
        end
    end)
end)

RegisterServerEvent('CORRUPT:depositAllOffshoreMoney')
AddEventHandler('CORRUPT:depositAllOffshoreMoney', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local bank = CORRUPT.getBankMoney(user_id)
    local amount = tonumber(bank)
    if CORRUPT.tryBankPayment(user_id, amount) then
        exports['corrupt']:execute('UPDATE corrupt_offshore SET balance = balance + @amount WHERE user_id = @user_id', {
            ['@user_id'] = user_id,
            ['@amount'] = amount - tonumber(bank) * 0.01
        })
        local formatted = getMoneyStringFormatted(amount - tonumber(bank) * 0.01)
        CORRUPT.notify(source, {"~g~You have deposited £" .. formatted .. " with a 1% fee into your offshore account."})
        initOffshoreMoney(source, user_id)
    else
        exports["lb-phone"]:SendNotification(source, {
            app = "offshore",
            title = "Offshore",
            content = "You Do Not Have Enough Money",
            icon = "https://cdn.discordapp.com/attachments/1200853764018544700/1208530865479622746/icon.png?ex=65e39f13&is=65d12a13&hm=2c4b97db3f7c0f1673121b1ec073983da3fc6766276eda904be6630a44db609f&"
        }, function(res)
        end)
    end
end)

RegisterServerEvent('CORRUPT:withdrawAllOffshoreMoney')
AddEventHandler('CORRUPT:withdrawAllOffshoreMoney', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    exports['corrupt']:execute('SELECT balance FROM corrupt_offshore WHERE user_id = @user_id', {['@user_id'] = user_id}, function(result)
        local offshore = result[1].balance
        exports['corrupt']:execute('UPDATE corrupt_offshore SET balance = balance - @amount WHERE user_id = @user_id', {
            ['@user_id'] = user_id,
            ['@amount'] = offshore
        })
        CORRUPT.notify(source, {"~g~You have withdrawn £" .. getMoneyStringFormatted(offshore) .. " from your offshore account."})
        CORRUPT.giveBankMoney(user_id, offshore)
        initOffshoreMoney(source, user_id)
    end)
end)

AddEventHandler("CORRUPTcli:playerSpawned", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    initOffshoreMoney(source, user_id)
end)

function initOffshoreMoney(source, user_id)
    Citizen.Wait(500)
    exports['corrupt']:execute('SELECT balance FROM corrupt_offshore WHERE user_id = @user_id', {
        ['@user_id'] = user_id
    }, function(result)
        if result[1] then
            TriggerClientEvent("CORRUPT:setDisplayOffshore", source, result[1].balance)
        else
            exports['corrupt']:execute('INSERT INTO corrupt_offshore (user_id, balance) VALUES (@user_id, 0)', {
                ['@user_id'] = user_id
            })
            TriggerClientEvent("CORRUPT:setDisplayOffshore", source, 0)
        end
    end)
end
