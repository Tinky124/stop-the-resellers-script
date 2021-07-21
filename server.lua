AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local identifiers = GetPlayerIdentifiers(source)
    deferrals.defer()

    Wait(0)

    deferrals.update(string.format("Hello %s. Your Discord ID is being checked across https://stoptheresellers.xyz", name))

    for _, v in pairs(identifiers) do
        if string.find(v, "discord") then
            discord = v:sub(9)
            PerformHttpRequest(string.format("https://stoptheresellers.xyz/api/checkuser.php?id=%s", discord), function (err, res)
             if(res) then
                local data = json.decode(res)
                if(data["blacklisted"] == true) then
                    deferrals.done("You are blacklisted at https://stoptheresellers.xyz and can't join the server.")
                else
                    deferrals.done()
                end
             end  
            end)              
            break
        end
    end

    Wait(0)

    if not discord then
        deferrals.done("You don't have discord linked, please restart your FiveM and link your discord.")
    end
end)

