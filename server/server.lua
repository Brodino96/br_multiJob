------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------

ESX = exports["es_extended"]:getSharedObject()

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Functions

local function checkJob(job)
    for i = 1, #Config.jobs do
        if job == Config.jobs[i] or job == "" then
            Debug.success("Job is valid")
            return true
        end
    end
    Debug.error("Specified job wasn't valid ("..job..")")
    return false
end

local function getPlayerJobs(id)
    Debug.working("Fetching jobs for player with id: ["..id.."]")
    local response = MySQL.query.await("SELECT * FROM `br_multiJobs` WHERE `identifier` = ?", { ESX.GetPlayerFromId(id).getIdentifier() })[1]
    local arr = {}

    for i = 1, Config.jobNum do
        arr[i] = response["job"..i]
    end
    Debug.success("Player with id ["..id.."] has: "..json.encode(arr))
    return arr
end

-- /setjob1 [id] [job]
local function setJob(id, slot, job, source)
    Debug.working("Setting a new job for player with id ["..id.."]")
    if not checkJob(job) then
        return TriggerClientEvent("ox_lib:notify", source, {
            type = "error", title = L("notify:wrong_job")
        })
    end
    local mysqlString = "UPDATE `br_multiJobs` SET `job"..tostring(slot).."` = ? WHERE `identifier` = ?"
    MySQL.update.await(mysqlString, {job, ESX.GetPlayerFromId(id).getIdentifier()})
    Debug.success("Player with id ["..id.."] job"..slot.." is now: "..job)
    TriggerClientEvent("ox_lib:notify", source, { type = "success", title = L("notify:job_changed") })
end

function CreateRows()
    Debug.working("Creating missing database rows...")
    local xPlayers = ESX.GetExtendedPlayers()
    for i = 1, #xPlayers do
        MySQL.insert.await("INSERT IGNORE INTO `br_multiJobs` (identifier) VALUES (?)", { xPlayers[i].getIdentifier() })
    end
    Debug.success("Database rows created")
end

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Commands

Debug.working("Registering commands")
for i = 1, Config.jobNum do
    RegisterCommand("setjob"..i, function (source, args)
        setJob(args[1], i, args[2], source)
    end, true)
end

RegisterCommand("jobmanager", function (source)
    TriggerClientEvent("br_multiJobs:openJobManager", source)
end, true)
Debug.success("Commands successfully registered")

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Callbacks

lib.callback.register("br_multiJobs:getPlayers", function (source)
    Debug.working("Generating list of all online players requested by id ["..source.."]")
    local list = {}
    local xPlayers = ESX.GetExtendedPlayers()

    for i = 1, #xPlayers do
        local xPlayer = xPlayers[i]
        list[i] = {
            name = xPlayer.getName(),
            id = xPlayer.source
        }
    end

    Debug.success("Returning list of players "..json.encode(list))
    return list
end)

lib.callback.register("br_multiJobs:getJobs", function (source, target)
    local id = target or source
    return getPlayerJobs(id)
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Events

RegisterNetEvent("br_multiJobs:setJob")
AddEventHandler("br_multiJobs:setJob", function (id, slot, job)
    setJob(id, slot, job, source)
end)

RegisterNetEvent("br_multiJobs:removeJob")
AddEventHandler("br_multiJobs:removeJob", function (id, slot)
    setJob(id, slot, "", source)
end)

RegisterNetEvent("br_multiJobs:CreateTables")
AddEventHandler("br_multiJobs:CreateTables", function ()
    MySQL.insert.await("INSERT IGNORE INTO `br_multiJobs` (identifier) VALUES (?)", { ESX.GetPlayerFromId(source).getIdentifier() })
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------
-- Exports

exports("getJobs", function (id)
    Debug.working("Job list of id ["..id.."] requested by server export")
    return getPlayerJobs(id)
end)

------------------ # ------------------ # ------------------ # ------------------ # ------------------ # ------------------