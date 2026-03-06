cBase = cBase or {}
cBase.framework = nil
cBase.framework_obj = nil

-- Detects and initializes the active framework
Citizen.CreateThread(function()
    local RedemRP = GetResourceState("redem_roleplay")
    local VorpCore = GetResourceState("vorp_core")
    local QBRCore = GetResourceState("qbr-core")
    local RSG = GetResourceState("rsg-core")
    -- local customcore = GetResourceState("your_core_resource_name")

    if RedemRP == "started" then
        cBase.framework = "redemrp"
        cBase.framework_obj = exports["redem_roleplay"]:RedEM()
    elseif VorpCore == "started" then
        cBase.framework = "vorp"
        cBase.framework_obj = exports.vorp_core:GetCore()
    elseif QBRCore == "started" then
        cBase.framework = "qbrcore"
    elseif RSG == "started" then
        cBase.framework = "rsg"
        cBase.framework_obj = exports['rsg-core']:GetCoreObject()
    end
    cBase.Log("Framework detected: " .. tostring(cBase.framework), "success")
end)

local function GetBase()
    return cBase
end

local function LangPreference()
    return Config.LangPreference
end

exports("GetBase", GetBase)
exports("GetLangPreference", LangPreference)

-- RegisterCommand("testwebhook", function()
--     exports['cBase']:SendLog("test", "Transfer completed", "green", "Bank Transaction", {
--         { name = "Player", value = "John Doe", inline = true },
--         { name = "Amount", value = "$5000",    inline = true },
--     })

-- end)