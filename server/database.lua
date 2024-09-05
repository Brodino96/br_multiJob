RegisterNetEvent("onResourceStart")
AddEventHandler("onResourceStart", function (name)
    if name ~= GetCurrentResourceName() then
        return
    end

    local jobs = ""
    for i = 1, Config.jobNum do
        jobs = jobs.."`job"..i.."` LONGTEXT NOT NULL, "
    end

    local query = [[
        CREATE TABLE IF NOT EXISTS `br_multiJobs` (
        `identifier` VARCHAR(46) NOT NULL,]]..jobs..[[
        PRIMARY KEY (`identifier`) )
    ]]

    Debug("Query: "..query)

    local response = MySQL.transaction.await({query})

    if response then
        TriggerClientEvent("br_multiJobs:syncTables", -1)
        return print("^0[^2INFO^0] La connessione con il database è avvenuta con successo")
    end

    return print("^0[^1ERROR^0] Lo script non è riuscito a collegarsi al database")
end)