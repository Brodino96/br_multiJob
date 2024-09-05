Config = {
    jobNum = 10,
    jobs = { "tuamadre", "tuanonna", "gesooo", "erlupetto", },
    debugMode = true -- Prints actions in console
}

Debug = {
    success = function (str)
        if Config.debugMode then
            print("[^2success?0] "..str)
        end
    end,
    working = function (str)
        if Config.debugMode then
            print("[^3working^0] "..str)
        end
    end,
    error = function (str)
        if Config.debugMode then
            print("[^1error^0] "..str)
        end
    end
}