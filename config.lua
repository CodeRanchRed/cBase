Config = {}

Config.LangPreference = "en" -- en, tr, ar, fr, it, es

Config.UseCodeRanchUISystem = false

Config.DiscordLog = {
    -- Webhook URLs: Add your own webhook names and URLs here.
    -- You can use any name you want, then call it from your scripts.
    -- Example: exports['cBase']:SendLog("bank", "John deposited $500")
    --
    -- Usage examples from other scripts:
    --
    --   Basic (webhook name + message only):
    --     exports['cBase']:SendLog("bank", "John deposited $500")
    --
    --   With color:
    --     exports['cBase']:SendLog("bank", "John deposited $500", "green")
    --
    --   With color + title:
    --     exports['cBase']:SendLog("bank", "John deposited $500", "green", "Bank Deposit")
    --
    --   With fields (detailed info):
    --     exports['cBase']:SendLog("bank", "Transfer completed", "green", "Bank Transaction", {
    --         { name = "Player", value = "John Doe", inline = true },
    --         { name = "Amount", value = "$5000",    inline = true },
    --     })
    --
    --   With image:
    --     exports['cBase']:SendLog("admin", "Player banned", "red", "BAN", {
    --         { name = "Admin",  value = "John",  inline = true },
    --         { name = "Target", value = "John", inline = true },
    --         { name = "Reason", value = "Cheating" },
    --     }, "https://example.com/screenshot.png")
    --
    Webhooks = {
        ["market"]       = "https://discord.com/api/webhooks/..."
    },

    -- Bot appearance
    BotName   = "cBase Logs",
    BotAvatar = "https://cdn.discordapp.com/attachments/1429025018599313458/1431313292579569674/1024x1024.png?ex=69aafbe1&is=69a9aa61&hm=f11ca9888117b9e6845e15ffd23755ecf419940f5fd95fdbb34210fe99380814&",

    -- Footer
    FooterText = "cBase Log System",
    FooterIcon = "https://cdn.discordapp.com/attachments/1429025018599313458/1431313292579569674/1024x1024.png?ex=69aafbe1&is=69a9aa61&hm=f11ca9888117b9e6845e15ffd23755ecf419940f5fd95fdbb34210fe99380814&",

    -- Embed colors (decimal values)
    -- Available color names: red, green, blue, yellow, orange, purple, pink, cyan, white, grey
    Colors = {
        red     = 16711680,  -- #FF0000
        green   = 65280,     -- #00FF00
        blue    = 255,       -- #0000FF
        yellow  = 16776960,  -- #FFFF00
        orange  = 16744448,  -- #FF8C00
        purple  = 10494192,  -- #A020F0
        pink    = 16738740,  -- #FF69B4
        cyan    = 65535,     -- #00FFFF
        white   = 16777215,  -- #FFFFFF
        grey    = 8421504,   -- #808080
    },
}
