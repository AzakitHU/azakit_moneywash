RegisterServerCallback('azakit_moneywash:itemTaken',function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(ITEM) 
    local itemtick = xPlayer.getInventoryItem(TICKETITEM) 
    if TICKETITEM_REQ then 
        if item.count >= ITEM_AMOUNT and itemtick.count >= TICKETITEM_AMOUNT then
            xPlayer.removeInventoryItem(TICKETITEM, TICKETITEM_AMOUNT)
            local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. xPlayer.identifier .. "\n**ID:** " .. src .. "\n**Log:** Started Moneywash StartNPC. Player got the address."
            discordLog(message, Webhook)
        cb(true)
         else
        cb(false)
         end   
    else
        if item.count >= ITEM_AMOUNT then
            local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. xPlayer.identifier .. "\n**ID:** " .. src .. "\n**Log:** Started Moneywash StartNPC. Player got the address."
            discordLog(message, Webhook)
        cb(true)
         else
        cb(false)
         end   
    end     
end)

local ox_inventory = exports.ox_inventory

RegisterServerEvent('azakit_moneywash:moneywash')
AddEventHandler('azakit_moneywash:moneywash', function(Amount)
local Player = source
local src = source
local xPlayer = ESX.GetPlayerFromId(src)
local MWashTax = Amount * Tax
local MWashTax2 = Amount * Tax2
local MWashTax3 = Amount * Tax3
local WashTotal = Amount - MWashTax
local WashTotal2 = Amount - MWashTax2
local WashTotal3 = Amount - MWashTax3
local black_money = exports.ox_inventory:Search(Player, 'count','black_money')
local moneywashticket =  exports.ox_inventory:Search(Player, 'count','moneywashticket')
local moneywashticket2 =  exports.ox_inventory:Search(Player, 'count','moneywashticket2')
local moneywashticket3 =  exports.ox_inventory:Search(Player, 'count','moneywashticket3')
    if black_money >= Amount then
        if Tickets then
            if moneywashticket3 >= 1 then
                exports.ox_inventory:RemoveItem(Player, 'black_money', Amount)
                exports.ox_inventory:RemoveItem(Player, 'moneywashticket3', 1)
                TriggerClientEvent('azakit_moneywash:moneywashactions', Player)
                Citizen.Wait(WashDuration)
                exports.ox_inventory:AddItem(Player, 'money', WashTotal3) 
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. xPlayer.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash Tickets 3: " ..Amount.. " black money and earned " ..WashTotal3.." money."
                discordLog(message, Webhook)
            elseif moneywashticket2 >= 1 then
                exports.ox_inventory:RemoveItem(Player, 'black_money', Amount)
                exports.ox_inventory:RemoveItem(Player, 'moneywashticket2', 1)
                TriggerClientEvent('azakit_moneywash:moneywashactions', Player)
                Citizen.Wait(WashDuration)
                exports.ox_inventory:AddItem(Player, 'money', WashTotal2) 
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. xPlayer.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash Tickets 2: " ..Amount.. " black money and earned " ..WashTotal2.." money."
                discordLog(message, Webhook)
            elseif moneywashticket >= 1 then
                exports.ox_inventory:RemoveItem(Player, 'black_money', Amount)
                exports.ox_inventory:RemoveItem(Player, 'moneywashticket', 1)
                TriggerClientEvent('azakit_moneywash:moneywashactions', Player)
                Citizen.Wait(WashDuration)
                exports.ox_inventory:AddItem(Player, 'money', WashTotal)
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. xPlayer.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash Tickets 1: " ..Amount.. " black money and earned " ..WashTotal.." money."
                discordLog(message, Webhook)
            else
                TriggerClientEvent('ox_lib:notify', Player, {title = _("Noticket2"), position = 'top', type = 'error'})
            end
        else
            exports.ox_inventory:RemoveItem(Player, 'black_money', Amount)
            exports.ox_inventory:RemoveItem(Player, 'moneywashticket', 1)
            TriggerClientEvent('azakit_moneywash:moneywashactions', Player)
            Citizen.Wait(WashDuration)
            exports.ox_inventory:AddItem(Player, 'money', WashTotal)
            local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. xPlayer.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash: " ..Amount.. " black money and earned " ..WashTotal.." money."
            discordLog(message, Webhook)
        end
    else
      TriggerClientEvent('ox_lib:notify', Player, {title = _("Noblackmoney"), position = 'top', type = 'error'})
    end
end)

RegisterServerEvent('azakit_moneywash:moneywashlic')
AddEventHandler('azakit_moneywash:moneywashlic', function(Amount)
local Player = source
local src = source
local xPlayer = ESX.GetPlayerFromId(src)
local MWashTax = Amount * Tax
local MWashTax2 = Amount * Tax2
local MWashTax3 = Amount * Tax3
local WashTotal = Amount - MWashTax
local WashTotal2 = Amount - MWashTax2
local WashTotal3 = Amount - MWashTax3
local black_money = exports.ox_inventory:Search(Player, 'count','black_money')
local moneywashlicense =  exports.ox_inventory:Search(Player, 'count','moneywashlicense')
local moneywashlicense2 =  exports.ox_inventory:Search(Player, 'count','moneywashlicense2')
local moneywashlicense3 =  exports.ox_inventory:Search(Player, 'count','moneywashlicense3')
    if black_money >= Amount then
        if License then
            if moneywashlicense3 >= 1 then
                exports.ox_inventory:RemoveItem(Player, 'black_money', Amount)
                TriggerClientEvent('azakit_moneywash:moneywashactions', Player)
                Citizen.Wait(WashDuration)
                exports.ox_inventory:AddItem(Player, 'money', WashTotal3) 
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. xPlayer.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash License 3: " ..Amount.. " black money and earned " ..WashTotal3.." money."
                discordLog(message, Webhook)
            elseif moneywashlicense2 >= 1 then
                exports.ox_inventory:RemoveItem(Player, 'black_money', Amount)
                TriggerClientEvent('azakit_moneywash:moneywashactions', Player)
                Citizen.Wait(WashDuration)
                exports.ox_inventory:AddItem(Player, 'money', WashTotal2) 
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. xPlayer.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash License 2: " ..Amount.. " black money and earned " ..WashTotal2.." money."
                discordLog(message, Webhook)
            elseif moneywashlicense >= 1 then
                exports.ox_inventory:RemoveItem(Player, 'black_money', Amount)
                TriggerClientEvent('azakit_moneywash:moneywashactions', Player)
                Citizen.Wait(WashDuration)
                exports.ox_inventory:AddItem(Player, 'money', WashTotal) 
                local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. xPlayer.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash License 1: " ..Amount.. " black money and earned " ..WashTotal.." money."
                discordLog(message, Webhook)
            else
                TriggerClientEvent('ox_lib:notify', Player, {title = _("Noticket2"), position = 'top', type = 'error'})
            end
       else
            exports.ox_inventory:RemoveItem(Player, 'black_money', Amount)
            exports.ox_inventory:RemoveItem(Player, 'moneywashticket', 1)
            TriggerClientEvent('azakit_moneywash:moneywashactions', Player)
            Citizen.Wait(WashDuration)
            exports.ox_inventory:AddItem(Player, 'money', WashTotal)
            local message = "**Steam:** " .. GetPlayerName(src) .. "\n**Identifier:** " .. xPlayer.identifier .. "\n**ID:** " .. src .. "\n**Log:** Moneywash: " ..Amount.. " black money and earned " ..WashTotal.." money."
            discordLog(message, Webhook)
        end
    else
      TriggerClientEvent('ox_lib:notify', Player, {title = _("Noblackmoney"), position = 'top', type = 'error'})
    end
end)

function discordLog(message, webhook)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = 'AzakitBOT', embeds = {{["description"] = "".. message .."",["footer"] = {["text"] = "Azakit Development - https://discord.com/invite/DmsF6DbCJ9",["icon_url"] = "https://cdn.discordapp.com/attachments/1150477954430816456/1192512440215277688/azakitdevelopmentlogoavatar.png?ex=65a958c1&is=6596e3c1&hm=fc6638bef39209397047b55d8afbec6e8a5d4ca932d8b49aec74cb342e2910dc&",},}}, avatar_url = "https://cdn.discordapp.com/attachments/1150477954430816456/1192512440215277688/azakitdevelopmentlogoavatar.png?ex=65a958c1&is=6596e3c1&hm=fc6638bef39209397047b55d8afbec6e8a5d4ca932d8b49aec74cb342e2910dc&"}), { ['Content-Type'] = 'application/json' })
end