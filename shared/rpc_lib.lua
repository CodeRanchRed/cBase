

cBase = cBase or {}
cBase.RPC = {}


cBase.RPC.isWaitingForResourceStart = true

local pendingExportCalls = {}
local isResourceStarted = false


local function CallExport(name, ...)
    if isResourceStarted or not cBase.RPC.isWaitingForResourceStart then
        return exports["cBase"][name](exports["cBase"], ...)
    else
        table.insert(pendingExportCalls, {
            name = name,
            args = {...}
        })
    end
end


AddEventHandler(("on%sResourceStart"):format(IsDuplicityVersion() and "Server" or "Client"), function (resource)
    if GetCurrentResourceName() ~= resource then return end

    for i, c in ipairs(pendingExportCalls) do
        exports["cBase"][c.name](exports["cBase"], table.unpack(c.args))
    end

    isResourceStarted = true
end)


function cBase.RPC.Register(name, callback)
    return CallExport("RegisterMethod", name, callback)
end

function cBase.RPC.Notify(name, params, source)
    if not params then
        params = {}
    end
    return CallExport("CallRemoteMethod", name, params, nil, source)
end

function cBase.RPC.Call(name, params, callback, source)
    if not params then
        params = {}
    end
    return CallExport("CallRemoteMethod", name, params, callback, source)
end

function cBase.RPC.CallAsync(name, params, source)
    if not params then
        params = {}
    end
    local p = promise.new()

    CallExport("CallRemoteMethod", name, params, function (...)
        p:resolve({...})
    end, source)

    return table.unpack(Citizen.Await(p))
end
