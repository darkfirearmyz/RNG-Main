local htmlEntities = module("lib/htmlEntities")

local cfg = module("cfg/cfg_identity")
local lang = CORRUPT.lang

local sanitizes = module("cfg/sanitizes")

-- this module describe the identity system

-- init sql


MySQL.createCommand("CORRUPT/get_user_identity","SELECT * FROM corrupt_user_identities WHERE user_id = @user_id")
MySQL.createCommand("CORRUPT/init_user_identity","INSERT IGNORE INTO corrupt_user_identities(user_id,registration,phone,firstname,name,age) VALUES(@user_id,@registration,@phone,@firstname,@name,@age)")
MySQL.createCommand("CORRUPT/update_user_identity","UPDATE corrupt_user_identities SET firstname = @firstname, name = @name, age = @age, registration = @registration, phone = @phone WHERE user_id = @user_id")
MySQL.createCommand("CORRUPT/get_userbyreg","SELECT user_id FROM corrupt_user_identities WHERE registration = @registration")
MySQL.createCommand("CORRUPT/get_userbyphone","SELECT user_id FROM corrupt_user_identities WHERE phone = @phone")
MySQL.createCommand("CORRUPT/update_user_phone","UPDATE corrupt_user_identities SET phone = @phone WHERE user_id = @user_id")



-- api

-- cbreturn user identity
function CORRUPT.getUserIdentity(user_id, cbr)
    local task = Task(cbr)
    if cbr then 
        MySQL.query("CORRUPT/get_user_identity", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then 
              task({rows[1]})
            else 
               task({})
            end
        end)
    else 
        print('Mis usage detected! CBR Does not exist')
    end
end

-- cbreturn user_id by registration or nil
function CORRUPT.getUserByRegistration(registration, cbr)
  local task = Task(cbr)

  MySQL.query("CORRUPT/get_userbyreg", {registration = registration or ""}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].user_id})
    else
      task()
    end
  end)
end

-- cbreturn user_id by phone or nil
function CORRUPT.getUserByPhone(phone, cbr)
  local task = Task(cbr)

  MySQL.query("CORRUPT/get_userbyphone", {phone = phone or ""}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].user_id})
    else
      task()
    end
  end)
end

function CORRUPT.generateStringNumber(format) -- (ex: DDDLLL, D => digit, L => letter)
  local abyte = string.byte("A")
  local zbyte = string.byte("0")

  local number = ""
  for i=1,#format do
    local char = string.sub(format, i,i)
    if char == "D" then number = number..string.char(zbyte+math.random(0,9))
    elseif char == "L" then number = number..string.char(abyte+math.random(0,25))
    else number = number..char end
  end

  return number
end

-- cbreturn a unique registration number
function CORRUPT.generateRegistrationNumber(cbr)
  local task = Task(cbr)

  local function search()
    -- generate registration number
    local registration = CORRUPT.generateStringNumber("DDDLLL")
    CORRUPT.getUserByRegistration(registration, function(user_id)
      if user_id ~= nil then
        search() -- continue generation
      else
        task({registration})
      end
    end)
  end

  search()
end

-- cbreturn a unique phone number (0DDDDD, D => digit)
function CORRUPT.generatePhoneNumber(cbr)
  local task = Task(cbr)

  local function search()
    -- generate phone number
    local phone = CORRUPT.generateStringNumber(cfg.phone_format)
    CORRUPT.getUserByPhone(phone, function(user_id)
      if user_id ~= nil then
        search() -- continue generation
      else
        task({phone})
      end
    end)
  end

  search()
end

-- events, init user identity at connection
AddEventHandler("CORRUPT:playerJoin",function(user_id,source,name,last_login)
  CORRUPT.getUserIdentity(user_id, function(identity)
    if identity == nil then
      CORRUPT.generateRegistrationNumber(function(registration)
        CORRUPT.generatePhoneNumber(function(phone)
          MySQL.execute("CORRUPT/init_user_identity", {
            user_id = user_id,
            registration = registration,
            phone = phone,
            firstname = cfg.random_first_names[math.random(1,#cfg.random_first_names)],
            name = cfg.random_last_names[math.random(1,#cfg.random_last_names)],
            age = math.random(25,40)
          })
        end)
      end)
    end
  end)
end)

RegisterNetEvent("CORRUPT:getIdentity")
AddEventHandler("CORRUPT:getIdentity", function()
  local source = source
  local user_id = CORRUPT.getUserId(source)
  if user_id ~= nil then
    CORRUPT.getUserIdentity(user_id, function(identity)
      TriggerClientEvent('CORRUPT:gotCurrentIdentity', source, identity['firstname'], identity['name'], identity['age'])
    end)
  end
end)

RegisterNetEvent("CORRUPT:getNewIdentity")
AddEventHandler("CORRUPT:getNewIdentity", function()
  local source = source
  local user_id = CORRUPT.getUserId(source)
  if user_id ~= nil then
    CORRUPT.prompt(source, 'First Name:', '', function(source,firstname)
      if firstname == '' then return end
      if string.len(firstname) >= 2 and string.len(firstname) < 50 then
        local firstname = sanitizeString(firstname, sanitizes.name[1], sanitizes.name[2])
       CORRUPT.prompt(source, 'Last Name:', '', function(source, lastname)
          if lastname == '' then return end
          if string.len(lastname) >= 2 and string.len(lastname) < 50 then
            local lastname = sanitizeString(lastname, sanitizes.name[1], sanitizes.name[2])
            CORRUPT.prompt(source, 'Age:', '', function(source,age)
              if age == '' then return end
              age = parseInt(age)
              if age >= 18 and age <= 150 then
                TriggerClientEvent('CORRUPT:gotNewIdentity', source, firstname, lastname, age)
              else
                CORRUPT.notify(source, {'Invalid age'})
              end
            end)
          else
            CORRUPT.notify(source, {'Invalid Last Name'})
          end
        end)
      else
        CORRUPT.notify(source, {'Invalid First Name'})
      end
    end)
  end
end)

MySQL.createCommand("CORRUPT/set_identity","UPDATE corrupt_user_identities SET firstname = @firstname, name = @name, age = @age WHERE user_id = @user_id")


RegisterNetEvent("CORRUPT:ChangeIdentity")
AddEventHandler("CORRUPT:ChangeIdentity", function(first, second, age)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if user_id ~= nil then
        if CORRUPT.tryBankPayment(user_id,5000) then
            MySQL.execute("CORRUPT/set_identity", {user_id = user_id, firstname = first, name = second, age = age})
            CORRUPT.notifyPicture(source,{"CHAR_FACEBOOK",1,"GOV.UK",false,"You have purchased a new identity!"})
            TriggerClientEvent("CORRUPT:PlaySound", source, "playMoney")
        else
            CORRUPT.notify(source,{"You don't have enough money!"})
        end
    end
end)


RegisterServerEvent("CORRUPT:askId")
AddEventHandler("CORRUPT:askId", function(nplayer)
  local player = source
  local playerid = CORRUPT.getUserId(source)
  local nuser_id = CORRUPT.getUserId(nplayer)
  if nuser_id ~= nil then
    CORRUPT.notify(player,{'~g~Request sent.'})
    CORRUPT.request(nplayer,"Do you want to give your ID card ?",15,function(nplayer,ok)
      if ok then
        CORRUPT.getUserIdentity(nuser_id, function(identity)
          if identity then
            TriggerClientEvent('CORRUPT:showIdentity', player, nplayer, true, identity.firstname, identity.name, '19/01/1990', identity.phone, '10/02/2015', '10/02/2025', {})
            TriggerClientEvent('CORRUPT:setNameFields', player, identity.name, identity.firstname)
            CORRUPT.request(player, "Hide the ID card.", 1000, function(player,ok)
              TriggerClientEvent('CORRUPT:hideIdentity', player)
            end)
          end
        end)
      else
        CORRUPT.notify(player,{"Request refused."})
      end
    end)
  else
    CORRUPT.notify(player,{"No player near you."})
  end
end)