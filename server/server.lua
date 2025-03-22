Start = false
local ESX, QBCore = nil, nil

if FrameworkType == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()
elseif FrameworkType == "QBCore" then
    QBCore = exports['qb-core']:GetCoreObject()
end

function PoliceCount()
    local count = 0
    if FrameworkType == "ESX" then
        local players = ESX.GetPlayers()
        for i = 1, #players do
            local xPlayer = ESX.GetPlayerFromId(players[i])
            if xPlayer and xPlayer.job then
              --  print("Player job: " .. xPlayer.job.name) -- Debug: check the player's job
                if xPlayer.job.name == 'police' then
                    count = count + 1
                end
            end
        end
    elseif FrameworkType == "QBCore" then
        local players = QBCore.Functions.GetPlayers()
        for i = 1, #players do
            local xPlayer = QBCore.Functions.GetPlayer(players[i])
            if xPlayer then
                if xPlayer.PlayerData and xPlayer.PlayerData.job and xPlayer.PlayerData.job.name then
                 --   print("Player job: " .. xPlayer.PlayerData.job.name) -- Debug: check the player's job
                    
                    -- Ha a játékos munkája rendőr (pl. 'police' vagy 'officer')
                    if xPlayer.PlayerData.job.name == 'police' or xPlayer.PlayerData.job.name == 'officer' then
                        count = count + 1
                    end
                else
                  --  print("No job data for player ID: " .. players[i])
                end
            else
             --   print("xPlayer is nil for player ID: " .. players[i])
            end
        end
    end
    -- Debug:
    -- print("Police count: " .. count)
    return count
end

RegisterNetEvent('azakit_moneywash:Start')
AddEventHandler('azakit_moneywash:Start', function()
    local src = source
    local policeCount = PoliceCount()
 --   print("Police count: " .. policeCount) -- Debug: Police count
    local copsAvailable = policeCount >= POLICE_REQ
    TriggerClientEvent('azakit_moneywash:policeCheckResult', src, copsAvailable)
end)


RegisterServerCallback('azakit_moneywash:itemTaken', function(source, cb)
    local src = source
    local player = nil

    if FrameworkType == "ESX" then
        player = ESX.GetPlayerFromId(src)
    elseif FrameworkType == "QBCore" then
        player = QBCore.Functions.GetPlayer(src)
    end
    
    if not player then
        cb(false)
        return
    end
    
    local item = nil
    local itemtick = nil

    if FrameworkType == "ESX" then
        item = player.getInventoryItem(ITEM)
        itemtick = player.getInventoryItem(TICKETITEM)
    elseif FrameworkType == "QBCore" then
        item = player.Functions.GetItemByName(ITEM)
        itemtick = player.Functions.GetItemByName(TICKETITEM)
    end

    -- Debug 
  --  if item then print("Item count: " .. (item.count or 0)) end
   -- if itemtick then print("Ticket item count: " .. (itemtick.amount or 0)) end
    
    if TICKETITEM_REQ then
        if FrameworkType == "ESX" then
            if item and item.count >= ITEM_AMOUNT and itemtick and itemtick.count >= TICKETITEM_AMOUNT then
                player.removeInventoryItem(TICKETITEM, TICKETITEM_AMOUNT)
                cb(true)
            else
                cb(false)
            end
        elseif FrameworkType == "QBCore" then
            if item and item.amount >= ITEM_AMOUNT and itemtick and itemtick.amount >= TICKETITEM_AMOUNT then
                player.Functions.RemoveItem(TICKETITEM, TICKETITEM_AMOUNT)
                cb(true)
            else
                cb(false)
            end
        end
    else
        if FrameworkType == "ESX" then
            if item and item.count >= ITEM_AMOUNT then
                player.removeInventoryItem(ITEM, ITEM_AMOUNT)
                cb(true)
            else
                cb(false)
            end
        elseif FrameworkType == "QBCore" then
            if item and item.amount >= ITEM_AMOUNT then
                player.Functions.RemoveItem(ITEM, ITEM_AMOUNT)
                cb(true)
            else
                cb(false)
            end
        end
    end
end)


RegisterServerEvent('azakit_moneywash:moneywash')
AddEventHandler('azakit_moneywash:moneywash', function(Amount)
    local src = source
    local player = nil
    if FrameworkType == "ESX" then
        player = ESX.GetPlayerFromId(src)
    elseif FrameworkType == "QBCore" then
        player = QBCore.Functions.GetPlayer(src)
    end
    
    local MWashTax = Amount * Tax
    local MWashTax2 = Amount * Tax2
    local MWashTax3 = Amount * Tax3
    local WashTotal = Amount - MWashTax
    local WashTotal2 = Amount - MWashTax2
    local WashTotal3 = Amount - MWashTax3

    local black_money = nil
    if FrameworkType == "ESX" then
        black_money = player.getInventoryItem('black_money')
    elseif FrameworkType == "QBCore" then
        black_money = player.Functions.GetItemByName('black_money')
    end    
        
    local moneywashticket = nil
    local moneywashticket2 = nil
    local moneywashticket3 = nil
    if FrameworkType == "ESX" then
        moneywashticket = player.getInventoryItem('moneywashticket')
        moneywashticket2 = player.getInventoryItem('moneywashticket2')
        moneywashticket3 = player.getInventoryItem('moneywashticket3')
    elseif FrameworkType == "QBCore" then
        moneywashticket = player.Functions.GetItemByName('moneywashticket')
        moneywashticket2 = player.Functions.GetItemByName('moneywashticket2')
        moneywashticket3 = player.Functions.GetItemByName('moneywashticket3')
    end
    
    if FrameworkType == "ESX" then
    if black_money and black_money.count >= Amount then
        if Tickets then
            if moneywashticket3 and moneywashticket3.count >= 1 then
                player.removeInventoryItemm('black_money', Amount)
                player.removeInventoryItem('moneywashticket3', 1)
                TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal3)
                Citizen.Wait(WashDuration)
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash Tickets 3: " ..Amount.. " black money and earned " ..WashTotal3.." money."
                discordLog(message, Webhook)
            elseif moneywashticket2 and moneywashticket2.count >= 1 then
                player.removeInventoryItem('black_money', Amount)
                player.removeInventoryItem('moneywashticket2', 1)
                TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal2)
                Citizen.Wait(WashDuration)
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash Tickets 2: " ..Amount.. " black money and earned " ..WashTotal2.." money."
                discordLog(message, Webhook)
            elseif moneywashticket and moneywashticket.count >= 1 then
                player.removeInventoryItem('black_money', Amount)
                player.removeInventoryItem('moneywashticket', 1)
                TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal)
                Citizen.Wait(WashDuration)
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash Tickets 1: " ..Amount.. " black money and earned " ..WashTotal.." money."
                discordLog(message, Webhook)
            else
                TriggerClientEvent('ox_lib:notify', src, {title = _("Noticket2"), position = 'top', type = 'error'})
            end
        else
            player.removeInventoryItem('black_money', Amount)
            TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal)
            Citizen.Wait(WashDuration)
            local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash: " ..Amount.. " black money and earned " ..WashTotal.." money."
            discordLog(message, Webhook)
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {title = _("Noblackmoney"), position = 'top', type = 'error'})
    end
elseif FrameworkType == "QBCore" then
    if black_money and black_money.amount >= Amount then
        if Tickets then
            if moneywashticket3 and moneywashticket3.amount >= 1 then
                player.Functions.RemoveItem('black_money', Amount)
                player.Functions.RemoveItem('moneywashticket3', 1)
                TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal3)
                Citizen.Wait(WashDuration)
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.PlayerData.citizenid .. "\n**ID:** " .. src .. "\n**Log:** Moneywash Tickets 3: " ..Amount.. " black money and earned " ..WashTotal3.." money."
                discordLog(message, Webhook)
            elseif moneywashticket2 and moneywashticket2.amount >= 1 then
                player.Functions.RemoveItem('black_money', Amount)
                player.Functions.RemoveItem('moneywashticket2', 1)
                TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal2)
                Citizen.Wait(WashDuration)
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.PlayerData.citizenid .. "\n**ID:** " .. src .. "\n**Log:** Moneywash Tickets 2: " ..Amount.. " black money and earned " ..WashTotal2.." money."
                discordLog(message, Webhook)
            elseif moneywashticket and moneywashticket.amount >= 1 then
                player.Functions.RemoveItem('black_money', Amount)
                player.Functions.RemoveItem('moneywashticket', 1)
                TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal)
                Citizen.Wait(WashDuration)
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.PlayerData.citizenid .. "\n**ID:** " .. src .. "\n**Log:** Moneywash Tickets 1: " ..Amount.. " black money and earned " ..WashTotal.." money."
                discordLog(message, Webhook)
            else
                TriggerClientEvent('ox_lib:notify', src, {title = _("Noticket2"), position = 'top', type = 'error'})
            end
        else
            player.Functions.RemoveItem('black_money', Amount)
            TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal)
            Citizen.Wait(WashDuration)
            local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.PlayerData.citizenid .. "\n**ID:** " .. src .. "\n**Log:** Moneywash: " ..Amount.. " black money and earned " ..WashTotal.." money."
            discordLog(message, Webhook)
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {title = _("Noblackmoney"), position = 'top', type = 'error'})
    end
end
end)

RegisterServerEvent('azakit_moneywash:collectReward')
AddEventHandler('azakit_moneywash:collectReward', function(WashTotal)
    local src = source
    local player = nil
print(WashTotal)
    if FrameworkType == "ESX" then
        player = ESX.GetPlayerFromId(src)
    elseif FrameworkType == "QBCore" then
        player = QBCore.Functions.GetPlayer(src)
    end

    
        if FrameworkType == "ESX" then
            player.addInventoryItem('cash', WashTotal)
        elseif FrameworkType == "QBCore" then
            player.Functions.AddMoney('cash', WashTotal)
        end
        TriggerClientEvent('azakit_moneywash:collectReward', src)

        local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.identifier .. "\n**ID:** " .. src .. "\n**Log:** Collected washed money: " .. WashTotal .. " cash."
        discordLog(message, Webhook)

end)



RegisterServerEvent('azakit_moneywash:moneywashlic')
AddEventHandler('azakit_moneywash:moneywashlic', function(Amount)
    local src = source
    local player = nil
    
    if FrameworkType == "ESX" then
        player = ESX.GetPlayerFromId(src)
    elseif FrameworkType == "QBCore" then
        player = QBCore.Functions.GetPlayer(src)
    end
    
    local MWashTax = Amount * Tax
    local MWashTax2 = Amount * Tax2
    local MWashTax3 = Amount * Tax3
    local WashTotal = Amount - MWashTax
    local WashTotal2 = Amount - MWashTax2
    local WashTotal3 = Amount - MWashTax3

    local black_money = nil
    if FrameworkType == "ESX" then
        black_money = player.getInventoryItem('black_money')
    elseif FrameworkType == "QBCore" then
        black_money = player.Functions.GetItemByName('black_money')
    end
    
    local moneywashlicense = nil
    local moneywashlicense2 = nil
    local moneywashlicense3 = nil
    if FrameworkType == "ESX" then
        moneywashlicense = player.getInventoryItem('moneywashlicense')
        moneywashlicense2 = player.getInventoryItem('moneywashlicense2')
        moneywashlicense3 = player.getInventoryItem('moneywashlicense3')
    elseif FrameworkType == "QBCore" then
        moneywashlicense = player.Functions.GetItemByName('moneywashlicense')
        moneywashlicense2 = player.Functions.GetItemByName('moneywashlicense2')
        moneywashlicense3 = player.Functions.GetItemByName('moneywashlicense3')
    end
    
    if FrameworkType == "ESX" then
    if black_money and black_money.count >= Amount then
        if License then
            if moneywashlicense3 and moneywashlicense3.count >= 1 then
                player.removeInventoryItem('black_money', Amount)
                TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal3)
                Citizen.Wait(WashDuration)
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash License 3: " .. Amount .. " black money and earned " .. WashTotal3 .. " money."
                discordLog(message, Webhook)
            elseif moneywashlicense2 and moneywashlicense2.count >= 1 then
                player.removeInventoryItem('black_money', Amount)
                TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal2)
                Citizen.Wait(WashDuration)
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash License 2: " .. Amount .. " black money and earned " .. WashTotal2 .. " money."
                discordLog(message, Webhook)
            elseif moneywashlicense and moneywashlicense.count >= 1 then
                player.removeInventoryItem('black_money', Amount)
                TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal)
                Citizen.Wait(WashDuration)
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash License 1: " .. Amount .. " black money and earned " .. WashTotal .. " money."
                discordLog(message, Webhook)
            else
                TriggerClientEvent('ox_lib:notify', src, {title = _("Noticket2"), position = 'top', type = 'error'})
            end
        else
            player.removeInventoryItem('black_money', Amount)
            TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal)
            Citizen.Wait(WashDuration)
            local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash: " .. Amount .. " black money and earned " .. WashTotal .. " money."
            discordLog(message, Webhook)
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {title = _("Noblackmoney"), position = 'top', type = 'error'})
    end
elseif FrameworkType == "QBCore" then
    if black_money and black_money.amount >= Amount then
        if License then
            if moneywashlicense3 and moneywashlicense3.amount >= 1 then
                player.Functions.RemoveItem('black_money', Amount)
                TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal3)
                Citizen.Wait(WashDuration)
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.PlayerData.citizenid .. "\n**ID:** " .. src .. "\n**Log:** Moneywash License 3: " .. Amount .. " black money and earned " .. WashTotal3 .. " money."
                discordLog(message, Webhook)
            elseif moneywashlicense2 and moneywashlicense2.amount >= 1 then
                player.Functions.RemoveItem('black_money', Amount)
                TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal2)
                Citizen.Wait(WashDuration)
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.PlayerData.citizenid .. "\n**ID:** " .. src .. "\n**Log:** Moneywash License 2: " .. Amount .. " black money and earned " .. WashTotal2 .. " money."
                discordLog(message, Webhook)
            elseif moneywashlicense and moneywashlicense.amount >= 1 then
                player.Functions.RemoveItem('black_money', Amount)
                TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal)
                Citizen.Wait(WashDuration)
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.PlayerData.citizenid .. "\n**ID:** " .. src .. "\n**Log:** Moneywash License 1: " .. Amount .. " black money and earned " .. WashTotal .. " money."
                discordLog(message, Webhook)
            else
                TriggerClientEvent('ox_lib:notify', src, {title = _("Noticket2"), position = 'top', type = 'error'})
            end
        else
            player.Functions.RemoveItem('black_money', Amount)
            TriggerClientEvent('azakit_moneywash:moneywashactions', src, WashTotal)
            Citizen.Wait(WashDuration)
            local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. player.PlayerData.citizenid .. "\n**ID:** " .. src .. "\n**Log:** Moneywash: " .. Amount .. " black money and earned " .. WashTotal .. " money."
            discordLog(message, Webhook)
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {title = _("Noblackmoney"), position = 'top', type = 'error'})
    end
end
end)

function discordLog(message, webhook)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = 'AzakitBOT', embeds = {{["description"] = "".. message .."",["footer"] = {["text"] = "Azakit Development - https://discord.com/invite/DmsF6DbCJ9",["icon_url"] = "https://cdn.discordapp.com/attachments/1150477954430816456/1192512440215277688/azakitdevelopmentlogoavatar.png?ex=65a958c1&is=6596e3c1&hm=fc6638bef39209397047b55d8afbec6e8a5d4ca932d8b49aec74cb342e2910dc&",},}}, avatar_url = "https://cdn.discordapp.com/attachments/1150477954430816456/1192512440215277688/azakitdevelopmentlogoavatar.png?ex=65a958c1&is=6596e3c1&hm=fc6638bef39209397047b55d8afbec6e8a5d4ca932d8b49aec74cb342e2910dc&"}), { ['Content-Type'] = 'application/json' })
end
