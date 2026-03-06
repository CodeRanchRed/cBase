cBase = cBase or {}

function cBase.DrawText3D(x, y, z, text, color)
    local r, g, b, a = 255, 255, 255, 255
    if color then
        r, g, b, a = table.unpack(color)
    end
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local str = VarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    if onScreen then
        SetTextScale(0.4, 0.4)
        SetTextFontForCurrentCommand(25) 
        SetTextColor(r, g, b, a)
        SetTextCentre(1)
        DisplayText(str, _x, _y)
        local factor = (string.len(text)) / 100 
        DrawSprite("feeds", "toast_bg", _x, _y + 0.0125, 0.015 + factor, 0.03, 0.1, 0, 0, 0, 200, false)
    end
end