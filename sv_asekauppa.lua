ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local webhook = "WEBHOOK" -- dc logit

local kaupat = {
    [1] = {
        pos = vector3(coordi, coordi, coordi),
        raha = "puhdas", -- jos haluat että kauppa toimii likaisella rahalla niin laita puhtaan tilalle "likainen"
        aseet = {
            {label = "Tikari", ase = "WEAPON_DAGGER", hinta = 15000},
            {label = "Pesismaila", ase = "WEAPON_BAT", hinta = 10000},
            {label = "Sorkkarauta", ase = "WEAPON_CROWBAR", hinta = 5000},
            {label = "Puukko", ase = "WEAPON_KNIFE", hinta = 12000},
            {label = "Viidakkoveitsi", ase = "WEAPON_MACHETE", hinta = 5000},
            {label = "Vasara", ase = "WEAPON_HAMMER", hinta = 2000},
            {label = "Colfmaila", ase = "WEAPON_GOLFCLUB", hinta = 8000},
            {label = "Putkipihdit", ase = "WEAPON_WRENCH", hinta = 4500}
        },
        itemit = {
        }
    }
}

RegisterNetEvent("asekauppa:osta")
AddEventHandler("asekauppa:osta", function(tavara, tapa, raha, hinta22, label22)
    local xPlayer = ESX.GetPlayerFromId(source)
    local massit = xPlayer.getMoney()
    local likaset = xPlayer.getAccount('black_money').money
    if raha == "likainen" then
        if likaset >= hinta22 then
            xPlayer.removeAccountMoney("black_money", hinta22)
            if tapa == "ase" then
                xPlayer.addWeapon(tavara, 420)
            end
            if tapa == "itemi" then
                xPlayer.addInventoryItem(tavara, 1)
            end
            TriggerClientEvent("asekauppa:notifi", source, "Ostit: "..label22.. " hintaan: ~g~$" ..hinta22.."")
            Log("**Ase**: " .. label22.. "\n**Hinta**: " ..hinta22.. "$", '3863105', GetPlayerName(source), "Lyoma asekauppa")
        else
            local puuttuva = hinta22 - likaset
            TriggerClientEvent("asekauppa:notifi", source, "Sinulta puuttuu vielä: ~g~$" ..puuttuva.."")
        end
    end
    if raha == "puhdas" then
        if massit >= hinta22 then
            xPlayer.removeMoney(hinta22)
            if tapa == "ase" then
                xPlayer.addWeapon(tavara, 420)
            end
            if tapa == "itemi" then
                xPlayer.addInventoryItem(tavara, 1)
            end
            TriggerClientEvent("asekauppa:notifi", source, "Ostit: "..label22.. " hintaan: ~g~$" ..hinta22.."")
            Log("**Item**: " .. label22.. "\n**Price**: " ..hinta22.. "$", '3863105', GetPlayerName(source), "Weapon shop logs")
        else
            local puuttuva = hinta22 - massit
            TriggerClientEvent("asekauppa:notifi", source, "Sinulta puuttuu vielä: ~g~$" ..puuttuva.."")
        end
    end

end)

function Log(m, c, t, n)
    local co = {
        {
            ["color"] = c,
            ["title"] = t,
            ["description"] = m,
            ["footer"] = {
                ["text"] = os.date("%x | %X")
            },
        }
    }

    PerformHttpRequest(webhook, 
        function(status, text, headers)
            if status ~= 204 then
                print("Error while making log [POST] request!\n" .. err)
            end
        end, 'POST', json.encode({username = n, embeds = co}), { ['Content-Type'] = 'application/json'}
    )
end

RegisterNetEvent("asekauppa:lol")
AddEventHandler("asekauppa:lol", function()
    TriggerClientEvent("asekauppa:dumpperitpois", source, kaupat)
end)
