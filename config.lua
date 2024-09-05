Config = {
    jobNum = 10,
    jobs = { "tuamadre", "tuanonna", "gesooo", "erlupetto", },
    debugMode = true -- Prints actions in console
}

function Debug(str)
    if Config.debugMode then
        print(str)
    end
end