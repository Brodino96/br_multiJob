Debug = {
    success = function (str)
        if Config.debugMode then
            print("[^2SUCCESS^0] "..str)
        end
    end,
    working = function (str)
        if Config.debugMode then
            print("[^3WORKING^0] "..str)
        end
    end,
    error = function (str)
        if Config.debugMode then
            print("[^1ERROR^0] "..str)
        end
    end
}

Locale = {}

function L(str)
    return Locale[Config.locale][str]
end