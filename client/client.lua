StartNPC, HasGold = {}
local WashInProgress = false
local CurrentlyWashing = false
local MWashCooldown =  false

Citizen.CreateThread(function()
    StartNPC = SpawnNPC(START_NPC.ped.model, START_NPC.ped.coords, START_NPC.ped.heading)
    FreezeEntityPosition(StartNPC, true)
    SetEntityInvincible(StartNPC, true)
    SetBlockingOfNonTemporaryEvents(StartNPC, true)
    TaskStartScenarioInPlace(StartNPC, "WORLD_HUMAN_SMOKING", 0, true)

    if InteractionType == "qb-target" then
        exports['qb-target']:AddTargetEntity(StartNPC, {
            options = {
                {
                    event = "azakit_moneywash:StartMoneyWash",
                    label = _("start_npc"),
                    icon = "fas fa-dollar-sign"
                }
            },
            distance = 2.0
        })
    elseif InteractionType == "ox_target" then
        exports.ox_target:addLocalEntity(StartNPC, {
            {
                name = "azakit_moneywash:StartMoneyWash",
                event = "azakit_moneywash:StartMoneyWash",
                label = _("start_npc"),
                icon = "fas fa-dollar-sign",
                distance = 2.0
            }
        })
    elseif InteractionType == "3dtext" then
        local playerPed = PlayerPedId()
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                local playerCoords = GetEntityCoords(playerPed)
                local npcCoords = GetEntityCoords(StartNPC)
                local distance = #(playerCoords - npcCoords)

                if distance <= 2.0 then
                    Draw3DText(npcCoords.x, npcCoords.y, npcCoords.z, "[E] " .. _("start_npc"))
                    if IsControlJustReleased(0, 38) then -- E key
                        TriggerEvent("azakit_moneywash:StartMoneyWash")
                    end
                else
                    Citizen.Wait(500)
                end
            end
        end)
    end
end)


RegisterNetEvent("azakit_moneywash:StartMoneyWash")
AddEventHandler("azakit_moneywash:StartMoneyWash", function()
    if MWashCooldown then
        lib.notify({
            title = _("Cooldown"),
            position = 'top',
            type = 'error'
        })
        return
    end

    TriggerServerEvent('azakit_moneywash:Start')
end)


RegisterNetEvent('azakit_moneywash:policeCheckResult')
AddEventHandler('azakit_moneywash:policeCheckResult', function(copsAvailable)
    if copsAvailable then
		TriggerEvent('azakit_moneywash:Check')
    else
            lib.notify({
                position = 'top',
                title = _("nopolice"),
                type = 'error'
              })
    end
end)


RegisterNetEvent('azakit_moneywash:Check', function()
   
    local hasItem = true
    lib.notify({
        position = 'top',
        title = _("check"),
        type = 'info'
      })
    
    if ITEM then
        hasItem = false
        
        TriggerServerCallback('azakit_moneywash:itemTaken', function(cb)
        hasItem = cb
        
        end)
        Wait(1000)
    end
    if hasItem then
        onjob = true
        TriggerEvent('azakit_moneywash:startdeli')
    else
        lib.notify({
            position = 'top',
            title = _("noitem"),
            type = 'error'
          })
    end
end)

RegisterNetEvent("azakit_moneywash:startdeli")
AddEventHandler("azakit_moneywash:startdeli", function()

	lib.notify({
		position = 'top',
		title = _("gotodelivery"),
		type = 'success'
	  })

	local itslocation = math.random(1, #Delilocations)
    co = Delilocations[itslocation]
	BlipMaken(co)
	delitgestart = true
end)

BlipMaken = function()
    deliblip = AddBlipForCoord(co.x, co.y, co.z)
    SetBlipSprite (deliblip, blipsprite)
    SetBlipDisplay(deliblip, 4)
    SetBlipScale  (deliblip, blipscale)
    SetBlipAsShortRange(deliblip, true)
    SetBlipColour (deliblip, blipcolour)
    SetBlipRoute(deliblip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_("deliblipname"))
    EndTextCommandSetBlipName(deliblip)
end


local function Cooldown()
	MWashCooldown = true
	Wait(Cooldowntime)
	MWashCooldown = false
end

function WashMoney()
    if CurrentlyWashing then
        lib.notify({
            title = _("Inprogress"),
            position = 'top',
            type = 'error'
        })
    else
        if License or Tickets then
            local WashLicense = exports.ox_inventory:Search('count', 'moneywashlicense')
            local WashLicense2 = exports.ox_inventory:Search('count', 'moneywashlicense2')
            local WashLicense3 = exports.ox_inventory:Search('count', 'moneywashlicense3')
            local WashTicket = exports.ox_inventory:Search('count', 'moneywashticket')
            local WashTicket2 = exports.ox_inventory:Search('count', 'moneywashticket2')
            local WashTicket3 = exports.ox_inventory:Search('count', 'moneywashticket3')

            local animDict = 'anim@gangops@facility@servers@bodysearch@'
            lib.requestAnimDict(animDict, 10)

            while not HasAnimDictLoaded(animDict) do
                Citizen.Wait(100)
            end

            
            if not HasAnimDictLoaded(animDict) then
                lib.notify({
                    title = _("AnimDictFailed"),
                    position = 'top',
                    type = 'error'
                })
                return
            end

            SetEntityHeading(PlayerPedId(), 246.5098)
            TaskPlayAnim(PlayerPedId(), animDict, 'player_search', 8.0, -8.0, -1, 48, 0)

            local input = lib.inputDialog(_("Amount"), { _("Amount2") })
            if not input then return end
            local WashAmount = tonumber(input[1])

            if WashLicense >= 1 then
                if not MWashCooldown then 
                    TriggerServerEvent('azakit_moneywash:moneywashlic', WashAmount)
                    Wait(500)
                    ClearPedTasksImmediately(PlayerPedId())
                else
                    lib.notify({
                        title = _("Cooldown"),
                        position = 'top',
                        type = 'error'
                    })
                end
            elseif WashLicense2 >= 1 then
                if not MWashCooldown then
                    TriggerServerEvent('azakit_moneywash:moneywashlic', WashAmount)
                    Wait(500)
                    ClearPedTasksImmediately(PlayerPedId())
                else
                    lib.notify({
                        title = _("Cooldown"),
                        position = 'top',
                        type = 'error'
                    })
                end
            elseif WashLicense3 >= 1 then
                if not MWashCooldown then
                    TriggerServerEvent('azakit_moneywash:moneywashlic', WashAmount)
                    Wait(500)
                    ClearPedTasksImmediately(PlayerPedId())
                else
                    lib.notify({
                        title = _("Cooldown"),
                        position = 'top',
                        type = 'error'
                    })
                end
            elseif WashTicket >= 1 then
                if not MWashCooldown then
                    TriggerServerEvent('azakit_moneywash:moneywash', WashAmount)
                    Wait(500)
                    ClearPedTasksImmediately(PlayerPedId())
                else
                    lib.notify({
                        title = _("Cooldown"),
                        position = 'top',
                        type = 'error'
                    })
                end
            elseif WashTicket2 >= 1 then
                if not MWashCooldown then
                    TriggerServerEvent('azakit_moneywash:moneywash', WashAmount)
                    Wait(500)
                    ClearPedTasksImmediately(PlayerPedId())
                else
                    lib.notify({
                        title = _("Cooldown"),
                        position = 'top',
                        type = 'error'
                    })
                end
            elseif WashTicket3 >= 1 then
                if not MWashCooldown then
                    TriggerServerEvent('azakit_moneywash:moneywash', WashAmount)
                    Wait(500)
                    ClearPedTasksImmediately(PlayerPedId())
                else
                    lib.notify({
                        title = _("Cooldown"),
                        position = 'top',
                        type = 'error'
                    })
                end
            else
                lib.notify({
                    title = _("Noticket"),
                    position = 'top',
                    type = 'error'
                })
            end
        else
            if not MWashCooldown then
                SetEntityHeading(PlayerPedId(), 246.5098)
                lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@', 10)
                TaskPlayAnim(PlayerPedId(), 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0)
                local input = lib.inputDialog(_("Amount"), { _("Amount2") })
                if not input then return end
                local WashAmount = tonumber(input[1])
                TriggerServerEvent('azakit_moneywash:moneywash', WashAmount)
                Wait(500)
                ClearPedTasksImmediately(PlayerPedId())
            else
                lib.notify({
                    title = _("Cooldown"),
                    position = 'top',
                    type = 'error'
                })
            end
        end
    end
end



RegisterNetEvent('azakit_moneywash:moneywashactions')
AddEventHandler('azakit_moneywash:moneywashactions', function(WashTotal)
    if WashInProgress then
        lib.notify({
            title = _("WashAlreadyInProgress"),
            position = "top",
            type = 'error'
        })
        return
    end

    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)

    local closestLocation = nil
    local minDistance = nil

    for _, loc in ipairs(Delilocations) do
        local distance = #(playerPos - vector3(loc.x, loc.y, loc.z))
        if not minDistance or distance < minDistance then
            closestLocation = vector3(loc.x, loc.y, loc.z)
            minDistance = distance
        end
    end

    local startPos = closestLocation
    local washStartedTime = GetGameTimer()
    local playerInsideWashArea = true
    WashInProgress = true

    lib.notify({
        title = _("MoneywashStart"),
        position = "top",
        type = 'info'
    })

    Citizen.CreateThread(function()
        while GetGameTimer() - washStartedTime < WashDuration do
            Citizen.Wait(500)

            local currentPos = GetEntityCoords(playerPed)
            local distanceToWashArea = #(currentPos - startPos)

            if distanceToWashArea > WashAreaRadius then
                if playerInsideWashArea then
                    playerInsideWashArea = false
                    lib.notify({
                        title = _("LeftArea"),
                        position = 'top',
                        type = 'error'
                    })
                    TriggerServerEvent('azakit_moneywash:cancelMoneywash')
                    WashInProgress = false
                    playerInsideWashArea = false
                    CurrentlyWashing = false
                    Cooldown()
                    break
                end
            end
        end

        if playerInsideWashArea then
            lib.notify({
                title = _("RewardAvailable"),
                position = 'top',
                duration = 7000,
                type = 'info'
            })

            TriggerEvent("azakit_moneywash:EnableRewardPickup", WashTotal, startPos)
        end
    end)
end)



RegisterNetEvent("azakit_moneywash:EnableRewardPickup")
AddEventHandler("azakit_moneywash:EnableRewardPickup", function(WashTotal, startPos)
    if rewardPickedUp then
        lib.notify({
            title = _("AlreadyCollected"),
            position = 'top',
            type = 'error'
        })
        return
    end

    local targetCoords = vec3(startPos.x, startPos.y, startPos.z)

    if InteractionType == "ox_target" then
        exports['ox_target']:addSphereZone({
            coords = targetCoords,
            radius = 1,
            options = {
                {
                    name = 'pickup_reward',
                    icon = 'fa-solid fa-money-bill',
                    label = _("CollectWashedMoney"),
                    onSelect = function()
                        if not rewardPickedUp then
                            rewardPickedUp = true
                            TriggerServerEvent('azakit_moneywash:collectReward', WashTotal)
                        else
                            lib.notify({
                                title = _("AlreadyCollected"),
                                position = 'top',
                                type = 'error'
                            })
                        end
                    end
                }
            }
        })
	elseif InteractionType == "qb-target" then
		exports['qb-target']:RemoveZone("moneywash_zone")
	
		exports['qb-target']:AddCircleZone("moneywash_zone", targetCoords, 1.5, {
			name = "moneywash_zone",
			debugPoly = drawZones,
			useZ = true
		}, {
			options = {
				{
					event = "azakit_moneywash:collectReward", 
					label = _("CollectWashedMoney"),
					icon = "fas fa-money-bill",
					action = function()
						if not rewardPickedUp then
							rewardPickedUp = true
							TriggerServerEvent("azakit_moneywash:collectReward", WashTotal) 
						else
							lib.notify({
								title = _("AlreadyCollected"),
								position = 'top',
								type = 'error'
							})
						end
					end
				}
			},
			distance = 2.0
		})	
    elseif InteractionType == "3dtext" then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                local playerCoords = GetEntityCoords(PlayerPedId())
                local distance = #(playerCoords - targetCoords)

                if distance <= 3.0 then
                    Draw3DText(targetCoords.x, targetCoords.y, targetCoords.z + 0.5, "[E] " .. _("CollectWashedMoney"))
                    if IsControlJustReleased(0, 38) then
                        if not rewardPickedUp then
                            rewardPickedUp = true
                            TriggerServerEvent('azakit_moneywash:collectReward', WashTotal)
                        else
                            lib.notify({
                                title = _("AlreadyCollected"),
                                position = 'top',
                                type = 'error'
                            })
                        end
                    end
                end
            end
        end)
    end
end)


RegisterNetEvent("azakit_moneywash:collectReward")
AddEventHandler("azakit_moneywash:collectReward", function()
    lib.notify({
        title = _("Reward"),
        position = 'top',
        type = 'success'
    })
    WashInProgress = false
    playerInsideWashArea = false
    CurrentlyWashing = false
    Cooldown()
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local emez = true
        if delitgestart then
            local coords = GetEntityCoords(PlayerPedId())
            local distance = GetDistanceBetweenCoords(coords, co.x, co.y, co.z, true)
            
            if distance < 3 then            
                emez = false
                DrawScriptText(vector3(co.x, co.y, co.z + 0.2), _("Draw"))
                if IsControlJustReleased(0, 38) then
                    if lib.progressCircle({
                        duration = Duration,
                        label = _("Knock"),
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            move = true,
                            car = true,
                        },
                        anim = {
                            dict = 'timetable@jimmy@doorknock@',
                            clip = 'knockdoor_idle'
                        },
                    }) then 
                        if InteractionType == "ox_target" then
                            exports.ox_target:addSphereZone({
                                coords = vec3(co.x, co.y, co.z),
                                radius = 1,
                                debug = drawZones,
                                options = {
                                    {
                                        name = 'wash',
                                        icon = 'fa-solid fa-money-bill',
                                        label = _("Peephole"),
                                        onSelect = function()
                                            TriggerEvent("azakit_moneywash:StartWash")
                                        end
                                    }
                                }
                            })
                        elseif InteractionType == "qb-target" then
                            exports['qb-target']:AddCircleZone("moneywash_zone", vector3(co.x, co.y, co.z), 1.5, {
								name = "moneywash_zone",
								debugPoly = drawZones,
								useZ = true
							}, {
								options = {
									{
										event = "azakit_moneywash:StartWash",
										label = _("Peephole"),
										icon = "fas fa-money-bill",
									}
								},
								distance = 2.0
							})							
                        elseif InteractionType == "3dtext" then
                            TriggerEvent("azakit_moneywash:Enable3DTextInteraction", co.x, co.y, co.z)
                        end
                        
                        lib.notify({
                            title = _("Transfer"),
                            position = 'top',
                            duration = 7000,
                            type = 'info'
                        })
                        
                        delitgestart = false
                        RemoveBlip(deliblip)
                    end
                end
            end
        end
        
        if emez then
            Wait(500)
        end
    end
end)

RegisterNetEvent("azakit_moneywash:StartWash")
AddEventHandler("azakit_moneywash:StartWash", function()
    if not WashInProgress and not MWashCooldown then
        WashMoney()
    else
        if WashInProgress then
            lib.notify({
                title = _("WashAlreadyInProgress"),
                position = 'top',
                type = 'warning'  
            })
        elseif MWashCooldown then
            lib.notify({
                title = _("Cooldown"),
                position = 'top',
                type = 'error'  
            })
        end
    end
end)

RegisterNetEvent("azakit_moneywash:Enable3DTextInteraction")
AddEventHandler("azakit_moneywash:Enable3DTextInteraction", function(x, y, z)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - vector3(x, y, z))

            if distance <= 2.0 and not WashInProgress and not MWashCooldown then
                Draw3DText(x, y, z + 0.5, "[E] " .. _("Peephole"))
                if IsControlJustReleased(0, 38) then
                    WashMoney()
                end
            end
        end
    end)
end)

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local scale = 0.35

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0150, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end

function DrawScriptText(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords["x"], coords["y"], coords["z"])

    SetTextScale(0.35, 0.35)
    SetTextFont(2)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = string.len(text) / 370

    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 65)
end
