ESX = nil
local label,label2,hinta,hinta2

local cordinaatit = {
    --mee vittuu saatanan motaaja
}



CreateThread(function()
    while ESX == nil do
        Wait(10)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
    TriggerServerEvent("asekauppa:lol")
    Wait(300) 
    while true do
        local wait = 1500
        local coords = GetEntityCoords(PlayerPedId())
        for i=1, #cordinaatit do
            local aika = GetClockHours()
            local asekauppa = #(cordinaatit[i].pos - coords) 
            if asekauppa < 1.5 then 
                wait = 5
                if aika < 24 or aika >= 1 then
                    ESX.ShowHelpNotification(" ~INPUT_CONTEXT~ Asekauppa")
                    if IsControlJustPressed(0, 38) then
                        menu(i)
                    end
                else
                    ESX.ShowHelpNotification("Tule takaisin ~g~12.00-22.00")
                end
            end
        end
        Wait(wait)
    end
end)


menu = function(kauppa)
    local elements = {}
    for i=1, #cordinaatit[kauppa].aseet do 
        local tykki = cordinaatit[kauppa].aseet[i].ase
        label = cordinaatit[kauppa].aseet[i].label
        hinta = cordinaatit[kauppa].aseet[i].hinta
        table.insert(elements, {label = label.. '  <span style = "color:green;">$' ..cordinaatit[kauppa].aseet[i].hinta.."</span>", value = tykki, lol = "ase", hinta = hinta, label22 = label})
    end
    for i=1, #cordinaatit[kauppa].itemit do 
        local itemi = cordinaatit[kauppa].itemit[i].itemi
        label2 = cordinaatit[kauppa].itemit[i].label
        hinta2 = cordinaatit[kauppa].itemit[i].hinta
        table.insert(elements, {label = label2.. '  <span style = "color:green;">$' ..cordinaatit[kauppa].itemit[i].hinta.."</span>", value = itemi, lol = "itemi", hinta = hinta2, label22 = label2})
    end
    local raha = cordinaatit[kauppa].raha
    ESX.UI.Menu.Open(
	    'default', GetCurrentResourceName(), 'npc',
	    {
	        title    = 'Asekauppa',
	        align    = 'bottom',
	        elements = elements, 
	    },
		function(data, menu)
        local a = data.current.value
        local b = data.current.lol
        local c = data.current.hinta
        local d = data.current.label22
        if b == "ase" then
            TriggerServerEvent("asekauppa:osta", a, b, raha, c, d)
        end
        if b == "itemi" then
            TriggerServerEvent("asekauppa:osta", a, b, raha, c, d)
        end
    end,
	function(data, menu)  
		menu.close()
    end)
    CreateThread(function() 
        while true do
            Wait(1000)
            local nopeus = GetEntitySpeed(PlayerPedId())
            if nopeus > 1.6 then
                ESX.UI.Menu.CloseAll()
                break 
            end
        end
    end)
end

RegisterNetEvent("asekauppa:notifi")
AddEventHandler("asekauppa:notifi", function(msg)
    ESX.ShowAdvancedNotification('Asekauppa', msg, '', "CHAR_AMMUNATION", 1)
end)

RegisterNetEvent("asekauppa:dumpperitpois")
AddEventHandler("asekauppa:dumpperitpois", function(mad)
    cordinaatit = mad
end)
