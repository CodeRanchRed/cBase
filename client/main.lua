--[[]]


function GetBase()
    return cBase
end

function GetLangPreference()
    return Config.LangPreference
end

Citizen.CreateThread(function()
    exports["cBase"]:CallRemoteMethod("cBase:GetFramework", {}, function(data)
        framework = data.framework
    end)
end)
