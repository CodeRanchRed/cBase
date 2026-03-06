
cBase = cBase or {}

local function GetColor(color)
    if not color then return Config.DiscordLog.Colors.white end
    if type(color) == "number" then return color end
    return Config.DiscordLog.Colors[color] or Config.DiscordLog.Colors.white
end


local function GetTimestamp()
    return os.date("!%Y-%m-%dT%H:%M:%SZ")
end

function SendLog(webhook, message, color, title, fields, image)
    local webhookUrl = Config.DiscordLog.Webhooks[webhook]
    if not webhookUrl or webhookUrl == "" then
        return cBase.Log("Webhook not found: '" .. tostring(webhook) .. "' - Add it to Config.DiscordLog.Webhooks!", "error")
    end

    local embed = {
        title       = title,
        description = tostring(message),
        color       = GetColor(color),
        timestamp   = GetTimestamp(),
        footer      = {
            text     = Config.DiscordLog.FooterText,
            icon_url = Config.DiscordLog.FooterIcon
        }
    }

    if fields then
        embed.fields = {}
        for _, field in ipairs(fields) do
            embed.fields[#embed.fields + 1] = {
                name   = tostring(field.name),
                value  = tostring(field.value),
                inline = field.inline or false
            }
        end
    end

    if image then
        embed.image = { url = image }
    end

    PerformHttpRequest(webhookUrl, function() end, "POST", json.encode({
        username   = Config.DiscordLog.BotName,
        avatar_url = Config.DiscordLog.BotAvatar,
        embeds     = { embed }
    }), { ["Content-Type"] = "application/json" })
end
