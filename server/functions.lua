-- ==========================================
--  cBase - Server Functions
-- ==========================================

cBase = cBase or {}

local prefix = "^3[^4cBase^3]^0"

function cBase.Log(message, logType)
    if logType == "error" then
        print(prefix .. " ^1" .. tostring(message) .. "^0")
    elseif logType == "success" then
        print(prefix .. " ^2" .. tostring(message) .. "^0")
    else
        print(prefix .. " " .. tostring(message))
    end
end

function cBase.GetUserIdentifier(src)
    if not src then
        return cBase.Log("The user source parameter has not been provided!", "error")
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        local Player = frameworkObject.GetPlayer(src)
        return Player.identifier
    elseif cBase.framework == "vorp" then
        local Player = frameworkObject.getUser(src)
        local character = Player.getUsedCharacter
        return character.identifier
    elseif cBase.framework == "qbrcore" then
        local Player = exports['qbr-core']:GetPlayer(src)
        return Player.PlayerData.citizenid
    elseif cBase.framework == "rsg" then
        local Player = frameworkObject.Functions.GetPlayer(src)
        return Player.PlayerData.citizenid
    end
end

local _charIdCache = {} -- [source] = charIdentifier
local _charNameCache = {} -- [source] = fullname

AddEventHandler("vorp:SelectedCharacter", function(source, character)
    if source and character then
        if character.charIdentifier then
            _charIdCache[source] = character.charIdentifier
        end
        if character.firstname and character.lastname then
            _charNameCache[source] = character.firstname .. " " .. character.lastname
        end
    end
end)

AddEventHandler("playerDropped", function()
    _charIdCache[source] = nil
    _charNameCache[source] = nil
end)

function cBase.GetUserCharIdentifier(src)
    if not src then
        return cBase.Log("The user source parameter has not been provided!", "error")
    end
    if _charIdCache[src] then
        return _charIdCache[src]
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "vorp" then
        local Player = frameworkObject.getUser(src)
        local character = Player.getUsedCharacter
        return character.charIdentifier
    end
    return 1
end

function cBase.GetUserFullName(src)
    if not src then
        return cBase.Log("The user source parameter has not been provided!", "error")
    end
    if _charNameCache[src] then
        return _charNameCache[src]
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        local Player = frameworkObject.GetPlayer(src)
        local fname = Player.GetFirstName()
        local lname = Player.GetLastName()
        return fname.." "..lname
    elseif cBase.framework == "vorp" then
        local Player = frameworkObject.getUser(src)
        local character = Player.getUsedCharacter
        return character.firstname.." "..character.lastname
    elseif cBase.framework == "qbrcore" then
        local Player = exports['qbr-core']:GetPlayer(src)
        return Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname
    elseif cBase.framework == "rsg" then
        local Player = frameworkObject.Functions.GetPlayer(src)
        return Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname
    end
end

function cBase.AddItem(src, itemName, count)
    if not src then
        return cBase.Log("The user source parameter has not been provided!", "error")
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        local inv_data = {}
        TriggerEvent("redemrp_inventory:getData",function(call)
            while not inv_data do
                Citizen.Wait(100)
                inv_data = call
            end
        end)
        local ItemData = inv_data.getItem(src, itemName)
        if not ItemData.AddItem(count) then
            return cBase.Log("The user don't have enought space for adding item! "..src, "error")
        end
    elseif cBase.framework == "vorp" then
        return exports.vorp_inventory:addItem(src, itemName, count)
    elseif cBase.framework == "qbrcore" then
        local Player = exports['qbr-core']:GetPlayer(src)
        if not Player.Functions.AddItem(itemName, count) then return cBase.Log("The user don't have enought space for adding item! "..src, "error") end
    elseif cBase.framework == "rsg" then
        exports['rsg-inventory']:AddItem(src, itemName, count)
    end
end


function cBase.RemoveItem(src, itemName, count)
    if not src then
        return cBase.Log("The user source parameter has not been provided!", "error")
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        local inv_data = {}
        TriggerEvent("redemrp_inventory:getData",function(call)
            while not inv_data do
                Citizen.Wait(100)
                inv_data = call
            end
        end)
        local ItemData = inv_data.getItem(src, itemName)
        if not ItemData.ItemAmount >= count then
            return cBase.Log("The user does not have enough items! "..src, "error")
        end
        ItemData.RemoveItem(count)
    elseif cBase.framework == "vorp" then
        return exports.vorp_inventory:subItem(src, itemName, count)
    elseif cBase.framework == "qbrcore" then
        local Player = exports['qbr-core']:GetPlayer(src)
        if not Player.Functions.RemoveItem(itemName, count) then return cBase.Log("The user don't have enought space for adding item! "..src, "error") end
    elseif cBase.framework == "rsg" then
        exports['rsg-inventory']:RemoveItem(src, itemName, count)
    end
end


function cBase.GetTotalFunds(src, fund_type)
    if not src then
        return cBase.Log("The user source parameter has not been provided!", "error")
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        local Player = frameworkObject.GetPlayer(src)
        if fund_type == "bank" then
            return Player.bankmoney
        else
            return Player.money
        end
    elseif cBase.framework == "vorp" then
        local Player = frameworkObject.getUser(src)
        local character = Player.getUsedCharacter
        if fund_type == "bank" then
            local characterId = character.charIdentifier
            local total = MySQL.scalar.await("SELECT SUM(money) FROM bank_users WHERE charidentifier = @characterId", { characterId = characterId })
            return total or 0
        else
            return character.money
        end
    elseif cBase.framework == "qbrcore" then
        local Player = exports['qbr-core']:GetPlayer(src)
        if fund_type == "bank" then
            return Player.PlayerData.money["bank"]
        else
            return Player.PlayerData.money["cash"]
        end
    elseif cBase.framework == "rsg" then
        local Player = frameworkObject.Functions.GetPlayer(src)
        if fund_type == "bank" then
            return Player.PlayerData.money["bank"]
        else
            return Player.PlayerData.money["cash"]
        end
    end
end



function cBase.AddFunds(src, fund_type, amount)
    if not src then
        return cBase.Log("The user source parameter has not been provided!", "error")
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        local Player = frameworkObject.GetPlayer(src)
        if fund_type == "bank" then
            Player.AddBankMoney(amount)
        else
            Player.AddMoney(amount)
        end
    elseif cBase.framework == "vorp" then
        local Player = frameworkObject.getUser(src)
        local character = Player.getUsedCharacter
        if fund_type == "bank" then
            local characterId = character.charIdentifier
            local result = MySQL.query.await("SELECT name, money FROM bank_users WHERE charidentifier = @characterId LIMIT 1", { characterId = characterId })
            local bankName
            if not result or not result[1] then
                local identifier = GetPlayerIdentifier(src, 0) or ""
                MySQL.insert.await("INSERT INTO bank_users (name, identifier, charidentifier, money, gold, items, invspace) VALUES (@name, @identifier, @characterId, @money, 0, '[]', 10)", {
                    name = "Valentine",
                    identifier = identifier,
                    characterId = characterId,
                    money = amount
                })
                bankName = "Valentine"
                cBase.Log("New bank record created for character: " .. characterId .. " at Valentine", "success")
            else
                bankName = result[1].name
                local newBalance = result[1].money + amount
                MySQL.update.await("UPDATE bank_users SET money = @newBalance WHERE charidentifier = @characterId AND name = @bankName", { newBalance = newBalance, characterId = characterId, bankName = bankName })
            end
            return bankName
        else
            character.addCurrency(0, amount)
        end
    elseif cBase.framework == "qbrcore" then
        local Player = exports['qbr-core']:GetPlayer(src)
        if fund_type == "bank" then
            return Player.Functions.AddMoney("bank", amount)
        else
            return Player.Functions.AddMoney("cash", amount)
        end
    elseif cBase.framework == "rsg" then
    local Player = frameworkObject.Functions.GetPlayer(src)
        if fund_type == "bank" then
            return Player.Functions.AddMoney("bank", amount)
        else
            return Player.Functions.AddMoney("cash", amount)
        end
    end
end


function cBase.RemoveFunds(src, fund_type, amount, cb)
    if not src then
        cBase.Log("The user source parameter has not been provided!", "error")
        return cb and cb(false)
    end
    if not cBase.framework then
        cBase.Log("The framework object has not been provided! (unknown framework)", "error")
        return cb and cb(false)
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        local Player = frameworkObject.GetPlayer(src)
        if fund_type == "bank" then
            if Player.bankmoney >= amount then
                Player.RemoveBankMoney(amount)
                return cb and cb(true)
            end
            return cb and cb(false)
        else
            if Player.money >= amount then
                Player.RemoveMoney(amount)
                return cb and cb(true)
            end
            return cb and cb(false)
        end
    elseif cBase.framework == "vorp" then
        local Player = frameworkObject.getUser(src)
        local character = Player.getUsedCharacter
        if fund_type == "bank" then
            local characterId = character.charIdentifier
            local result = MySQL.query.await("SELECT name, money FROM bank_users WHERE charidentifier = @characterId LIMIT 1", { characterId = characterId })
            if not result or not result[1] then
                cBase.Log("No bank record found for character: " .. characterId, "error")
                return cb and cb(false)
            end
            local bankMoney = result[1].money
            if bankMoney < amount then
                return cb and cb(false)
            end
            local bankName = result[1].name
            MySQL.update.await("UPDATE bank_users SET money = @newBalance WHERE charidentifier = @characterId AND name = @bankName", {
                newBalance = bankMoney - amount,
                characterId = characterId,
                bankName = bankName
            })
            return cb and cb(true)
        else
            if character.money < amount then
                return cb and cb(false)
            end
            character.removeCurrency(0, amount)
            return cb and cb(true)
        end
    elseif cBase.framework == "qbrcore" then
        local Player = exports['qbr-core']:GetPlayer(src)
        if fund_type == "bank" then
            local success = Player.Functions.RemoveMoney("bank", amount)
            return cb and cb(success)
        else
            local success = Player.Functions.RemoveMoney("cash", amount)
            return cb and cb(success)
        end
    elseif cBase.framework == "rsg" then
        local Player = frameworkObject.Functions.GetPlayer(src)
        if fund_type == "bank" then
            local success = Player.Functions.RemoveMoney("bank", amount)
            return cb and cb(success)
        else
            local success = Player.Functions.RemoveMoney("cash", amount)
            return cb and cb(success)
        end
    end
end




function cBase.GetItemCount(src, itemName)
    if not src then
        return cBase.Log("The user source parameter has not been provided!", "error")
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        local inv_data = {}
        TriggerEvent("redemrp_inventory:getData", function(call)
            while not inv_data do
                Citizen.Wait(100)
                inv_data = call
            end
        end)
        local ItemData = inv_data.getItem(src, itemName)
        return ItemData.ItemAmount or 0
    elseif cBase.framework == "vorp" then
        local p = promise:new()
        exports.vorp_inventory:getItemCount(src, function(result)
            p:resolve(result)
        end, itemName)
        return Citizen.Await(p)
    elseif cBase.framework == "qbrcore" then
        local Player = exports['qbr-core']:GetPlayer(src)
        local item = Player.Functions.GetItemByName(itemName)
        return item and item.amount or 0
    elseif cBase.framework == "rsg" then
        local Player = frameworkObject.Functions.GetPlayer(src)
        local item = Player.Functions.GetItemByName(itemName)
        return item and item.amount or 0
    end
end



function cBase.GetJob(src)
    if not src then
        return cBase.Log("The user source parameter has not been provided!", "error")
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        local Player = frameworkObject.GetPlayer(src)
        return Player.job
    elseif cBase.framework == "vorp" then
        local Player = frameworkObject.getUser(src)
        local character = Player.getUsedCharacter
        return character.jobLabel
    elseif cBase.framework == "qbrcore" then
        local Player = exports['qbr-core']:GetPlayer(src)
        return Player.PlayerData.job.name
    elseif cBase.framework == "rsg" then
        local Player = frameworkObject.Functions.GetPlayer(src)
        return Player.PlayerData.job.name
    end
end


function cBase.GetJobGrade(src)
    if not src then
        return cBase.Log("The user source parameter has not been provided!", "error")
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        local Player = frameworkObject.GetPlayer(src)
        return Player.jobgrade
    elseif cBase.framework == "vorp" then
        local Player = frameworkObject.getUser(src)
        local character = Player.getUsedCharacter
        return character.jobGrade
    elseif cBase.framework == "qbrcore" then
        local Player = exports['qbr-core']:GetPlayer(src)
        return Player.PlayerData.job.grade.level
    elseif cBase.framework == "rsg" then
        local Player = frameworkObject.Functions.GetPlayer(src)
        return Player.PlayerData.job.grade.level
    end
end


function cBase.GetUserByIdentifier(identifier)
    if not identifier then
        return cBase.Log("The identifier parameter has not been provided!", "error")
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        return frameworkObject.GetPlayerByIdentifier(identifier)
    elseif cBase.framework == "vorp" then
        local result = MySQL.query.await("SELECT * FROM characters WHERE identifier = @identifier LIMIT 1", { identifier = identifier })
        if result and result[1] then
            return result[1]
        end
        return nil
    elseif cBase.framework == "qbrcore" then
        return exports['qbr-core']:GetPlayerByCitizenId(identifier)
    elseif cBase.framework == "rsg" then
        return frameworkObject.Functions.GetPlayerByCitizenId(identifier)
    end
end



-- TODODODODOD
function cBase.GetItemLabel(itemName)
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj

    if cBase.framework == "redemrp" then
        return "Unknown"
    elseif cBase.framework == "vorp" then
        local itemdata = exports.vorp_inventory:getItemDB(itemName)
        return itemdata.label
    elseif cBase.framework == "qbrcore" then
        local items = frameworkObject.Shared.Items
        for k,v in pairs(items) do
            if v.name == itemName then
                return v.label
            end
        end
        return "Unknown"
    elseif cBase.framework == "rsg" then
        local items = frameworkObject.Shared.Items
        for k,v in pairs(items) do
            if v.name == itemName then
                return v.label
            end
        end
        return "Unknown"
    end
end

function cBase.CanCarryItem(src, itemName, count)
    if not src then
        return cBase.Log("The user source parameter has not been provided!", "error")
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        return true -- to do i cant find
    elseif cBase.framework == "vorp" then
        return exports.vorp_inventory:canCarryItem(src, itemName, count)
    elseif cBase.framework == "qbrcore" then
       return true
    elseif cBase.framework == "rsg" then
        return exports["rsg-inventory"]:CanAddItem(src, itemName, count)
    end
end

function cBase.SendNotification(src, text, notificationType, timer)
    if not src then
        return cBase.Log("The user source parameter has not been provided!", "error")
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    if Config.UseCodeRanchUISystem then
        TriggerClientEvent('coderanch-ui:createNotification',src, notificationType, text, timer)
        return
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        TriggerClientEvent("redem_roleplay:Tip", src, text , timer)
    elseif cBase.framework == "vorp" then
        TriggerClientEvent("vorp:TipBottom", src, text, timer)
    elseif cBase.framework == "qbrcore" then
       TriggerClientEvent('QBCore:Notify', src, 9, text, timer, 0, 'mp_lobby_textures', notificationType)
    elseif cBase.framework == "rsg" then
        TriggerClientEvent('ox_lib:notify', src, { title = text, type = notificationType, duration = timer })
    end
end


function cBase.RegisterUsableItem(itemName, cb)
    if not itemName then
        return cBase.Log("The item name parameter has not been provided!", "error")
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end

    if cBase.framework == "redemrp" then
        AddEventHandler("redemrp_inventory:useItem:" .. itemName, function(src)
            cb(src)
        end)
    elseif cBase.framework == "vorp" then
        exports.vorp_inventory:registerUsableItem(itemName, function(data)
            cb(data.source or data)
        end)
    elseif cBase.framework == "qbrcore" then
        local QBCore = exports['qbr-core']:GetCoreObject()
        QBCore.Functions.CreateUseableItem(itemName, function(src)
            cb(src)
        end)
    elseif cBase.framework == "rsg" then
        local frameworkObject = cBase.framework_obj
        frameworkObject.Functions.CreateUseableItem(itemName, function(src)
            cb(src)
        end)
    end

    cBase.Log("Registered usable item: " .. tostring(itemName), "success")
end

exports("RegisterUsableItem", function(itemName, cb)
    return cBase.RegisterUsableItem(itemName, cb)
end)

local _deadCache = {}

AddEventHandler("vorpCore:playerDeath", function()
    _deadCache[source] = true
end)

AddEventHandler("redemrp:playerDied", function()
    _deadCache[source] = true
end)

AddEventHandler("rsg-ambulancejob:server:SetDeathStatus", function(src, isDead)
    _deadCache[src] = isDead
end)

AddEventHandler("qbrcore:server:setDeadStatus", function(src, isDead)
    _deadCache[src] = isDead
end)

AddEventHandler("vorp_core:Server:OnPlayerRevive", function(src)
    _deadCache[src] = false
end)

AddEventHandler("playerDropped", function()
    _deadCache[source] = nil
end)


function cBase.IsPlayerDead(src)
    if not src then
        return cBase.Log("The user source parameter has not been provided!", "error")
    end
    if _deadCache[src] ~= nil then
        return _deadCache[src]
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        local Player = frameworkObject.GetPlayer(src)
        return Player and Player.isdead or false
    elseif cBase.framework == "vorp" then
        local Player = frameworkObject.getUser(src)
        if not Player then return false end
        local character = Player.getUsedCharacter
        return character and character.isdead or false
    elseif cBase.framework == "qbrcore" then
        local Player = exports['qbr-core']:GetPlayer(src)
        return Player and Player.PlayerData.metadata.isdead or false
    elseif cBase.framework == "rsg" then
        local Player = frameworkObject.Functions.GetPlayer(src)
        return Player and Player.PlayerData.metadata.isdead or false
    end
    return false
end


function cBase.RevivePlayer(src)
    if not src then
        return cBase.Log("The user source parameter has not been provided!", "error")
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        TriggerClientEvent("redemrp:revivePlayer", src)
        _deadCache[src] = false
    elseif cBase.framework == "vorp" then
        local Core = exports.vorp_core:GetCore()
        Core.Player.Revive(src)
        _deadCache[src] = false
    elseif cBase.framework == "qbrcore" then
        local Player = exports['qbr-core']:GetPlayer(src)
        if Player then
            Player.Functions.SetMetaData("isdead", false)
            Player.Functions.SetMetaData("inlaststand", false)
            TriggerClientEvent("hospital:client:Revive", src)
            _deadCache[src] = false
        end
    elseif cBase.framework == "rsg" then
        local RSGCore = frameworkObject
        RSGCore.Player.Revive(src)
        _deadCache[src] = false
    end
    cBase.Log("Revived player: " .. tostring(src), "success")
end


function cBase.HealPlayer(src)
    if not src then
        return cBase.Log("The user source parameter has not been provided!", "error")
    end
    if not cBase.framework then
        return cBase.Log("The framework object has not been provided! (unknown framework)", "error")
    end
    local frameworkObject = cBase.framework_obj
    if cBase.framework == "redemrp" then
        TriggerClientEvent("redemrp:healPlayer", src)
    elseif cBase.framework == "vorp" then
        local Core = exports.vorp_core:GetCore()
        Core.Player.Heal(src)
    elseif cBase.framework == "qbrcore" then
        TriggerClientEvent("hospital:client:Heal", src)
    elseif cBase.framework == "rsg" then
        local RSGCore = frameworkObject
        RSGCore.Player.Heal(src)
    end
    cBase.Log("Healed player: " .. tostring(src), "success")
end

exports("IsPlayerDead", function(src)
    return cBase.IsPlayerDead(src)
end)

exports("RevivePlayer", function(src)
    return cBase.RevivePlayer(src)
end)

exports("HealPlayer", function(src)
    return cBase.HealPlayer(src)
end)

exports("OnPlayerDeath", function(cb)
    AddEventHandler("vorpCore:playerDeath", function()
        cb(source)
    end)
    AddEventHandler("redemrp:playerDied", function()
        cb(source)
    end)
    AddEventHandler("rsg-ambulancejob:server:SetDeathStatus", function(src, isDead)
        if isDead then cb(src) end
    end)
    AddEventHandler("qbrcore:server:setDeadStatus", function(src, isDead)
        if isDead then cb(src) end
    end)
end)
