local lang = CORRUPT.lang
--Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)

MySQL.createCommand("CORRUPT/money_init_user","INSERT IGNORE INTO corrupt_user_moneys(user_id,wallet,bank) VALUES(@user_id,@wallet,@bank)")
MySQL.createCommand("CORRUPT/get_money","SELECT wallet,bank FROM corrupt_user_moneys WHERE user_id = @user_id")
MySQL.createCommand("CORRUPT/set_money","UPDATE corrupt_user_moneys SET wallet = @wallet, bank = @bank WHERE user_id = @user_id")

function CORRUPT.getMoney(user_id)
  local tmp = CORRUPT.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

-- set money
function CORRUPT.setMoney(user_id,value)
  local tmp = CORRUPT.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
  end

  -- update client display
  local source = CORRUPT.getUserSource(user_id)
  if source ~= nil then
    CORRUPTclient.setDivContent(source,{"money",lang.money.display({Comma(CORRUPT.getMoney(user_id))})})
    TriggerClientEvent('CORRUPT:initMoney', source, CORRUPT.getMoney(user_id), CORRUPT.getBankMoney(user_id))
  end
end

-- try a payment
-- return true or false (debited if true)
function CORRUPT.tryPayment(user_id,amount)
  local money = CORRUPT.getMoney(user_id)
  if amount >= 0 and money >= amount then
    CORRUPT.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

function CORRUPT.tryBankPayment(user_id,amount)
  local bank = CORRUPT.getBankMoney(user_id)
  if amount >= 0 and bank >= amount then
    CORRUPT.setBankMoney(user_id,bank-amount)
    return true
  else
    return false
  end
end

-- give money
function CORRUPT.giveMoney(user_id,amount)
  local money = CORRUPT.getMoney(user_id)
  CORRUPT.setMoney(user_id,money+amount)
end

-- get bank money
function CORRUPT.getBankMoney(user_id)
  local tmp = CORRUPT.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- set bank money
function CORRUPT.setBankMoney(user_id,value)
  local tmp = CORRUPT.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
  end
  local source = CORRUPT.getUserSource(user_id)
  if source ~= nil then
    CORRUPTclient.setDivContent(source,{"bmoney",lang.money.bdisplay({Comma(CORRUPT.getBankMoney(user_id))})})
    TriggerClientEvent('CORRUPT:initMoney', source, CORRUPT.getMoney(user_id), CORRUPT.getBankMoney(user_id))
  end
end

-- give bank money
function CORRUPT.giveBankMoney(user_id,amount)
  if amount > 0 then
    local money = CORRUPT.getBankMoney(user_id)
    CORRUPT.setBankMoney(user_id,money+amount)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function CORRUPT.tryWithdraw(user_id,amount)
  local money = CORRUPT.getBankMoney(user_id)
  if amount > 0 and money >= amount then
    CORRUPT.setBankMoney(user_id,money-amount)
    CORRUPT.giveMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function CORRUPT.tryDeposit(user_id,amount)
  if amount > 0 and CORRUPT.tryPayment(user_id,amount) then
    CORRUPT.giveBankMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function CORRUPT.tryFullPayment(user_id,amount)
  local money = CORRUPT.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return CORRUPT.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if CORRUPT.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return CORRUPT.tryPayment(user_id, amount)
    end
  end

  return false
end

AddEventHandler("CORRUPT:playerJoin",function(user_id,source,name,last_login)
  local tmp = CORRUPT.getUserTmpTable(user_id)
  if tmp then
    CORRUPT.StartingMoney(user_id)
    MySQL.query("CORRUPT/get_money", {user_id = user_id}, function(rows, affected)
      if #rows > 0 then
        tmp.bank = rows[1].bank
        tmp.wallet = rows[1].wallet
      end
    end)
  end
end)

function CORRUPT.getAllMoney(user_id)
  local money = CORRUPT.getMoney(user_id)
  local bank = CORRUPT.getBankMoney(user_id)
  return money + bank
end

local initCash = 55000
local initBank = 100000000

function CORRUPT.StartingMoney(user_id)
  exports['corrupt']:execute('SELECT * FROM corrupt_user_moneys WHERE user_id = @user_id', {user_id = user_id}, function(result)
    if not result[1] then
      exports['corrupt']:execute('INSERT INTO corrupt_user_moneys (user_id, wallet, bank, startingcash) VALUES (@user_id, @wallet, @bank, @startingcash)', {user_id = user_id, wallet = initCash, bank = initBank, startingcash = 1})
    elseif result[1] and result[1].startingcash == false then
      exports['corrupt']:execute('UPDATE corrupt_user_moneys SET wallet = @wallet, bank = @bank, startingcash = @startingcash WHERE user_id = @user_id', {user_id = user_id, wallet = initCash, bank = initBank, startingcash = 1})
    end
  end)
end




-- save money on leave
AddEventHandler("CORRUPT:playerLeave",function(user_id,source)
  -- (wallet,bank)
  local tmp = CORRUPT.getUserTmpTable(user_id)
  if tmp and tmp.wallet ~= nil and tmp.bank ~= nil then
    MySQL.execute("CORRUPT/set_money", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank})
  end
end)

-- save money (at same time that save datatables)
AddEventHandler("CORRUPT:save", function()
  for k,v in pairs(CORRUPT.user_tmp_tables) do
    if v.wallet ~= nil and v.bank ~= nil then
      MySQL.execute("CORRUPT/set_money", {user_id = k, wallet = v.wallet, bank = v.bank})
    end
  end
end)

RegisterNetEvent('CORRUPT:giveCashToPlayer')
AddEventHandler('CORRUPT:giveCashToPlayer', function(nplayer)
  local source = source
  local user_id = CORRUPT.getUserId(source)
  if user_id ~= nil then
    if nplayer ~= nil then
      local nuser_id = CORRUPT.getUserId(nplayer)
      if nuser_id ~= nil then
        CORRUPT.prompt(source,lang.money.give.prompt(),"",function(source,amount)
          local amount = parseInt(amount)
          if amount > 0 and CORRUPT.tryPayment(user_id,amount) then
            CORRUPT.giveMoney(nuser_id,amount)
            CORRUPT.notify(source,{lang.money.given({getMoneyStringFormatted(math.floor(amount))})})
            CORRUPT.notify(nplayer,{lang.money.received({getMoneyStringFormatted(math.floor(amount))})})
            CORRUPT.sendWebhook('give-cash', "Corrupt Give Cash Logs", "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Target Name: **"..CORRUPT.getPlayerName(nplayer).."**\n> Target PermID: **"..nuser_id.."**\n> Amount: **£"..getMoneyStringFormatted(amount).."**")
          else
            CORRUPT.notify(source,{lang.money.not_enough()})
          end
        end)
      else
        CORRUPT.notify(source,{lang.common.no_player_near()})
      end
    else
      CORRUPT.notify(source,{lang.common.no_player_near()})
    end
  end
end)


function Comma(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

RegisterServerEvent("CORRUPT:takeAmount")
AddEventHandler("CORRUPT:takeAmount", function(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.tryFullPayment(user_id,amount) then
      CORRUPT.notify(source,{'~g~Paid £'..getMoneyStringFormatted(amount)..'.'})
      return
    end
end)

local lasttransfer = {}

RegisterServerEvent("CORRUPT:transferMoneyViaPermID")
AddEventHandler("CORRUPT:transferMoneyViaPermID", function(id, amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local target_id = tonumber(id)
    local transfer_amount = tonumber(amount)
    local target_source = CORRUPT.getUserSource(target_id)
    local cooldown = 10
    
    if lasttransfer[source] and GetGameTimer() - lasttransfer[source] < cooldown * 1000 then
        return
    end
    
    lasttransfer[source] = GetGameTimer()
    if source == target_source then
        exports["lb-phone"]:SendNotification(source, {
            app = "monzo",
            title = "Monzo",
            content = "You cannot transfer money to yourself.",
            icon = "https://cdn.discordapp.com/attachments/1200853764018544700/1208530894500003850/icon.png"
        })
        return
    end
    if target_source then
        if CORRUPT.tryBankPayment(user_id, transfer_amount) then
            exports["lb-phone"]:SendNotification(target_source, {
                app = "monzo",
                title = "Monzo",
                content = "£" .. getMoneyStringFormatted(transfer_amount) .. " From Perm ID: " .. user_id,
                icon = "https://cdn.discordapp.com/attachments/1200853764018544700/1208530894500003850/icon.png"
            })
            
            CORRUPT.giveBankMoney(target_id, transfer_amount)
            CORRUPT.sendWebhook('bank-transfer', "Monzo Bank Transfer Logs", 
                "> Player Name: **" .. CORRUPT.getPlayerName(source) .. "**\n" ..
                "> Player PermID: **" .. user_id .. "**\n" ..
                "> Target Name: **" .. CORRUPT.getPlayerName(target_source) .. "**\n" ..
                "> Target PermID: **" .. target_id .. "**\n" ..
                "> Amount: **£"..getMoneyStringFormatted(transfer_amount).."**"
            )
        else
            exports["lb-phone"]:SendNotification(source, {
                app = "monzo",
                title = "Monzo",
                content = "You do not have enough money.",
                icon = "https://cdn.discordapp.com/attachments/1200853764018544700/1208530894500003850/icon.png"
            })
        end
    else
        exports["lb-phone"]:SendNotification(source, {
            app = "monzo",
            title = "Monzo",
            content = "Player is not online.",
            icon = "https://cdn.discordapp.com/attachments/1200853764018544700/1208530894500003850/icon.png"
        })
    end
end)


RegisterServerEvent('CORRUPT:requestPlayerBankBalance')
AddEventHandler('CORRUPT:requestPlayerBankBalance', function()
    local user_id = CORRUPT.getUserId(source)
    local bank = CORRUPT.getBankMoney(user_id)
    local wallet = CORRUPT.getMoney(user_id)
    TriggerClientEvent('CORRUPT:setDisplayMoney', source, wallet)
    TriggerClientEvent('CORRUPT:setDisplayBankMoney', source, bank)
    TriggerClientEvent('CORRUPT:initMoney', source, wallet, bank)
end)

RegisterServerEvent('CORRUPT:LB:Phone')
AddEventHandler('CORRUPT:LB:Phone', function(source)
    local user_id = CORRUPT.getUserId(source)
    local bank = CORRUPT.getBankMoney(user_id)
    local wallet = CORRUPT.getMoney(user_id)
    TriggerClientEvent('CORRUPT:setDisplayMoney', source, wallet)
    TriggerClientEvent('CORRUPT:setDisplayBankMoney', source, bank)
    TriggerClientEvent('CORRUPT:initMoney', source, wallet, bank)
end)



RegisterServerEvent('CORRUPT:phonebalance')
AddEventHandler('CORRUPT:phonebalance', function()
    local bankM = CORRUPT.getBankMoney(user_id)
    TriggerClientEvent('CORRUPT:initMoney', source, bankM)
end)

RegisterServerEvent("CORRUPT:addbankphone")
AddEventHandler("CORRUPT:addbankphone", function(id, amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local id = tonumber(id)
    local amount = tonumber(amount)
    if CORRUPT.getUserSource(id) then
      CORRUPT.giveBankMoney(id, amount)
    end
end)

RegisterServerEvent("CORRUPT:removebankphone")
AddEventHandler("CORRUPT:removebankphone", function(id, amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local id = tonumber(id)
    local amount = tonumber(amount)
    if CORRUPT.getUserSource(id) then
      CORRUPT.tryBankPayment(id, amount)
    end
end)