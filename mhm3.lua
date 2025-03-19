local mt = getrawmetatable(game)
setreadonly(mt, false)
local old_index = mt.__index

getgenv().currentStyle = ""
getgenv().setStyle = function(styleName)
    getgenv().currentStyle = styleName

    mt.__index =
        newcclosure(
        function(a, b)
            if tostring(a) == "Class" then
                if tostring(b) == "Value" then
                    return styleName
                end
            end
            return old_index(a, b)
        end
    )
end

getgenv().styles = {
    "Jeet Kune Do",
    "SAVAGE",
    "Karate",
    "Ninja",
    "Kicker",
    "Heavy Hitter",
    "Aggressive",
    "Hitman",
    "Hawk",
    "Muay Thai",
    "CRASH OUT",
    "Jaw Breaker",
    "Philly",
    "Stud",
    "Squabble",
    "Bones",
    "Peak A Boo",
    "Striker",
    "Boxer",
    "Slap Boxer",
    "Amateur",
    "Baddie",
    "Compound V"
}

getgenv().get_styles = function() return getgenv().styles end
