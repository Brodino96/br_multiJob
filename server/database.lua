RegisterNetEvent("onResourceStart")
AddEventHandler("onResourceStart", function (name)
    if name ~= GetCurrentResourceName() then
        return
    end

    Debug.working("Script is trying to connect to database")

    local jobs = ""
    for i = 1, Config.jobNum do
        jobs = jobs.."`job"..i.."` LONGTEXT NOT NULL, "
    end

    local query = [[
        CREATE TABLE IF NOT EXISTS `br_multiJobs` (
        `identifier` VARCHAR(46) NOT NULL,]]..jobs..[[
        PRIMARY KEY (`identifier`) )
    ]]

    local response = MySQL.transaction.await({query})

    if response then
        CreateRows()
        return Debug.success("Database connection established")
    end

    return Debug.error("Couln't connect to the database")
end)