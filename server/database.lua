RegisterNetEvent("onResourceStart")
AddEventHandler("onResourceStart", function (name)
    if name == GetCurrentResourceName() then
        CreateThread(function ()
            local response = MySQL.transaction.await({[[
                CREATE TABLE IF NOT EXISTS `br_multiJobs` (
                `identifier` VARCHAR(46) NOT NULL,
                `job1` LONGTEXT NOT NULL,
                `job2` LONGTEXT NOT NULL,
                `job3` LONGTEXT NOT NULL,
                PRIMARY KEY (`identifier`) )
            ]]})
            if response then
                print("^0[^2INFO^0] La connessione con il database è avvenuta con successo")
                TriggerClientEvent("br_multiJobs:syncTables", -1)
            else
                print("^0[^1ERROR^0] Lo script non è riuscito a collegarsi al database")
            end
        end)
    end
end)