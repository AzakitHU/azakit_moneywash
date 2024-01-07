StartNPC, HasGold = {},

Citizen.CreateThread(function()       
    StartNPC = SpawnNPC(START_NPC.ped.model, START_NPC.ped.coords, START_NPC.ped.heading)
    FreezeEntityPosition(StartNPC, true)
    SetEntityInvincible(StartNPC, true)
    SetBlockingOfNonTemporaryEvents(StartNPC, true)
    TaskStartScenarioInPlace(StartNPC, "WORLD_HUMAN_SMOKING", 0, true)    
    AddEntityMenuItem({
        entity = StartNPC,
        event = "azakit_moneywash:Check",
        desc = _("start_npc")
    })
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

local CurrentlyWashing = false
local InsideLaundry = true
local MWashCooldown =  false

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
			local WashLicense = exports.ox_inventory:Search('count','moneywashlicense')
			local WashLicense2 = exports.ox_inventory:Search('count','moneywashlicense2')
			local WashLicense3 = exports.ox_inventory:Search('count','moneywashlicense3')
			local WashTicket = exports.ox_inventory:Search('count','moneywashticket')
			local WashTicket2 = exports.ox_inventory:Search('count','moneywashticket2')
			local WashTicket3 = exports.ox_inventory:Search('count','moneywashticket3')
			if WashLicense >= 1 then
				if not MWashCooldown then 
					SetEntityHeading(PlayerPedId(), 246.5098)
					lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@', 10)
					TaskPlayAnim(PlayerPedId(), 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0)
					local input = lib.inputDialog(_("Amount"), {_("Amount2")})
		
					if not input then return end
					local WashAmount = tonumber(input[1])	
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
					SetEntityHeading(PlayerPedId(), 246.5098)
					lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@', 10)
					TaskPlayAnim(PlayerPedId(), 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0)
					local input = lib.inputDialog(_("Amount"), {_("Amount2")})
		
					if not input then return end
					local WashAmount = tonumber(input[1])	
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
					SetEntityHeading(PlayerPedId(), 246.5098)
					lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@', 10)
					TaskPlayAnim(PlayerPedId(), 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0)
					local input = lib.inputDialog(_("Amount"), {_("Amount2")})
		
					if not input then return end
					local WashAmount = tonumber(input[1])	
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
					SetEntityHeading(PlayerPedId(), 246.5098)
					lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@', 10)
					TaskPlayAnim(PlayerPedId(), 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0)
					local input = lib.inputDialog(_("Amount"), {_("Amount2")})
		
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
			elseif WashTicket2 >= 1 then
				if not MWashCooldown then 
					SetEntityHeading(PlayerPedId(), 246.5098)
					lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@', 10)
					TaskPlayAnim(PlayerPedId(), 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0)
					local input = lib.inputDialog(_("Amount"), {_("Amount2")})
		
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
			elseif WashTicket3 >= 1 then
				if not MWashCooldown then 
					SetEntityHeading(PlayerPedId(), 246.5098)
					lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@', 10)
					TaskPlayAnim(PlayerPedId(), 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0)
					local input = lib.inputDialog(_("Amount"), {_("Amount2")})
		
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
				local input = lib.inputDialog(_("Amount"), {_("Amount2")})
	
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
AddEventHandler('azakit_moneywash:moneywashactions', function()
	CurrentlyWashing = true
	lib.notify({
		title = _("MoneywashStart"),
		position = "top",
		type = 'inform'
	})
	Wait(1000)
	if lib.progressCircle({
        duration = WashDuration,
        label = _("Moneywash"),
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
        },
        --anim = {
         --   dict = '',
           -- clip = ''
       -- },
	}) then lib.notify({title = _("Reward"), position = 'top', duration = 7000, type = 'inform'}) end
	CurrentlyWashing = false
    Cooldown()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        emez = true
		if delitgestart then
			local coords = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(coords, co.x, co.y, co.z, true) < 3 then
				emez = false
				DrawScriptText(vector3(co.x,co.y,co.z+0.2), _("Draw"))
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
                        exports.ox_target:addSphereZone({
                        coords = vec3(co.x, co.y, co.z),
                        radius = 1,
                        debug = drawZones,
                        options = {
                            {
                                name = 'wash',
                                icon = 'fa-solid fa-money-bill',
                                label = _("Peephole"),
                                canInteract = function()
                                    return InsideLaundry
                                end,
                                onSelect = function()
                                    WashMoney()
                                end
                            }
                        }    
                    })	
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
			else
				emez = true
			end
		end
	end
    if emez then
        Wait(500)
    end
end)

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
