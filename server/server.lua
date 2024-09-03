------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------

ESX = exports["es_extended"]:getSharedObject()

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Functions

local function checkJob(job)
    local val = false
    for i = 1, #Config.jobs do
        if Config.jobs[i] == job then
            val = true
        end
    end
    return val
end

local function getPlayerJobs(id)
    local response = MySQL.query.await("SELECT * FROM `fakejobs` WHERE `identifier` = ?", { ESX.GetPlayerFromId(id).getIdentifier() })
    if response then
        return response[1]
    end
end

-- /setjob1 [id] [job]
local function setJob(id, slot, job)
    if not checkJob(job) then
        return print("Il job inserito non risulta valido")
    end
    local mysqlString = "UPDATE `fakejobs` SET `job"..tostring(slot).."` = ? WHERE `identifier` = ?"
    MySQL.update.await(mysqlString, {job, ESX.GetPlayerFromId(id).getIdentifier()})
end

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Commands

RegisterCommand("setjob1", function (source, args) setJob(args[1], 1, args[2]) end, true)
RegisterCommand("setjob2", function (source, args) setJob(args[1], 2, args[2]) end, true)
RegisterCommand("setjob3", function (source, args) setJob(args[1], 3, args[2]) end, true)

RegisterCommand("jobmanager", function (source)
    TriggerClientEvent("brfakejobs:openJobManager", source)
end, true)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Callbacks

lib.callback.register("brfakejobs:getPlayers", function ()
    local list = {}
    local xPlayers = ESX.GetExtendedPlayers()

    for i = 1, #xPlayers do
        local xPlayer = xPlayers[i]
        list[i] = {
            name = xPlayer.getName(),
            id = xPlayer.source
        }
    end

    return list
end)

lib.callback.register("brfakejobs:getSlots", function (source, target)
    return getPlayerJobs(target)
end)

lib.callback.register("brfakejobs:getJobs", function (source)
    return getPlayerJobs(source)
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Events

RegisterNetEvent("brfakejobs:setJob")
AddEventHandler("brfakejobs:setJob", setJob)

RegisterNetEvent("brfakejobs:removeJob")
AddEventHandler("brfakejobs:removeJob", setJob)

RegisterNetEvent("brfakejobs:CreateTables")
AddEventHandler("brfakejobs:CreateTables", function ()
    MySQL.insert.await("INSERT IGNORE INTO `fakejobs` (identifier) VALUES (?)", { ESX.GetPlayerFromId(source).getIdentifier() })
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------

exports("getJobs", function (id)
    local arr = getPlayerJobs(id)
    return { [1] = arr.job1, [2] = arr.job2, [3] = arr.job3 }
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------