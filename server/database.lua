RegisterNetEvent("onResourceStart")
AddEventHandler("onResourceStart", function (name)
    if name == GetCurrentResourceName() then
        CreateThread(function ()
            local response = MySQL.transaction.await({[[
                CREATE TABLE IF NOT EXISTS `fakejobs` (
                `identifier` VARCHAR(46) NOT NULL,
                `job1` LONGTEXT NOT NULL,
                `job2` LONGTEXT NOT NULL,
                `job3` LONGTEXT NOT NULL,
                PRIMARY KEY (`identifier`) )
            ]]})
            if response then
                print("^2La connessione con il database è avvenuta con successo^0")
            else
                print("^1Lo script non è riuscito a collegarsi al database^0")
            end
        end)
    end
end)