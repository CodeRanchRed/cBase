-- ==========================================
--  cBase - RPC (Remote Procedure Call) System
--  Based on: https://github.com/nbredikhin/fivem-rpc
-- ==========================================

local pendingCallbacks = {}
local callbackId = 0
local registeredMethods = {}

if IsDuplicityVersion() then
    RegisterServerEvent("rpc:call")
    RegisterServerEvent("rpc:response")
else
    RegisterNetEvent("rpc:call")
    RegisterNetEvent("rpc:response")
end

local function GetNextId()
    callbackId = callbackId + 1
    return callbackId
end

local function TriggerRemoteEvent(eventName, source, ...)
    if IsDuplicityVersion() then
        TriggerClientEvent(eventName, source or -1, ...)
    else
        TriggerServerEvent(eventName, ...)
    end
end

local function GetResponseFunction(id)
    if not id then
        return function () end
    end
    return function(...)
        TriggerRemoteEvent("rpc:response", source, id, ...)
    end
end


function CallRemoteMethod(name, params, callback, source)
    assert(type(name) == "string", "[RPC] CallRemoteMethod: Invalid method name. Expected string, got "..type(name))
    assert(type(params) == "table", "[RPC] CallRemoteMethod: Invalid params. Expected table, got "..type(params))

    local id = false
    if callback then
        id = GetNextId()
        pendingCallbacks[id] = callback
    end

    return TriggerRemoteEvent("rpc:call", source, id, name, params)
end


function RegisterMethod(name, callback)
    assert(type(name) == "string", "[RPC] RegisterMethod: Invalid method name. Expected string, got "..type(name))
    assert(callback, "[RPC] RegisterMethod: Invalid callback. Expected callback, got "..type(callback))

    registeredMethods[name] = callback
    return true
end


AddEventHandler("rpc:call", function (id, name, params)
    if type(name) ~= "string" then return end
    if not registeredMethods[name] then return end

    local returnValues = {registeredMethods[name](params, source, GetResponseFunction(id))}
    if #returnValues > 0 and id then
        TriggerRemoteEvent("rpc:response", source, id, table.unpack(returnValues))
    end
end)


AddEventHandler("rpc:response", function (id, ...)
    if not id then return end
    if not pendingCallbacks[id] then return end
    pendingCallbacks[id](...)
    pendingCallbacks[id] = nil
end)



cBase = cBase or {}

cBase.RPC = {
    Register = function(name, callback)
        RegisterMethod(name, function(params, source, ret)
            callback(params, ret, source)
        end)
    end,

    Call = function(name, params, callback, source)
        CallRemoteMethod(name, params or {}, callback, source)
    end,

    Notify = function(name, params, source)
        CallRemoteMethod(name, params or {}, nil, source)
    end,

    CallAsync = function(name, params, source)
        local p = promise.new()
        CallRemoteMethod(name, params or {}, function(...)
            p:resolve({...})
        end, source)
        return table.unpack(Citizen.Await(p))
    end
}
