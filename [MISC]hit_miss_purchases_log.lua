
local notifs = { "Log hit/miss dealt", "Weapon purchases" }

local log_misses = ui.reference("RAGE", "Aimbot", "Log misses due to spread")
local log_purchases = ui.reference("MISC", "Miscellaneous", "Log weapon purchases")
local log_damage = ui.reference("MISC", "Miscellaneous", "Log damage dealt")

local active = ui.new_multiselect("MISC", "Miscellaneous", "Notifications", notifs)

local hit = { }
local shot_info = {}
local hitgroup = { "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear" }
hitgroup[0] = "body"

local function contains(tab, val)
    for index, value in ipairs(ui.get(tab)) do
        if value == val then return true end
    end

    return false
end

-- NOTIFICATION LISTENER
client.set_event_callback("paint", function()
    notify:listener()

    if contains(active, notifs[1]) then
        ui.set(log_misses, false)
        ui.set(log_damage, false)
    end

    if contains(active, notifs[2]) then
        ui.set(log_purchases, false)
    end
end)

client.set_event_callback("item_purchase", function(c)
    if not contains(active, notifs[2]) then
        return
    end

    local id = client.userid_to_entindex(c.userid)

    if id ~= entity.get_local_player() and entity.is_enemy(id) then
        local nick = entity.get_player_name(id)
        notify.add(5, true, { 150, 185, 1, string.sub(nick, 0, 28) }, { 255, 255, 255, " bought " }, { 150, 185, 1, c.weapon })
        client.log(string.sub(nick, 0, 28) .. " bought " .. c.weapon)
    end
end)

local function ro(num, n)  return math.floor(num * 10^(n or 0) + 0.5) / 10^(n or 0) end

client.set_event_callback("aim_fire", function(c) shot_info[c.id] = c end)
client.set_event_callback("aim_hit", function(c) hit[c.target] = c.id end)
client.set_event_callback("aim_miss", function(c)
    if not contains(active, notifs[1]) then
        return
    end

    local nick = entity.get_player_name(c.target)
    local shot = shot_info[c.id]

    local reasons = ""
    local flags = {
        shot.teleported and 'T' or '',
        shot.interpolated and 'I' or '',
        shot.extrapolated and 'E' or '',
        shot.boosted and 'B' or '',
        shot.high_priority and 'H' or ''
    }

    notify.setup_color({ 255, 24, 24 })
    notify.add(5, false, 
        { 255, 255, 255, "Missed shot at " },
        { 255, 24, 24, string.sub(nick, 0, 28) },
        { 255, 255, 255, "'s " },
        { 255, 24, 24, hitgroup[c.hitgroup] },
        { 255, 255, 255, " (" },
        { 255, 24, 24, c.reason == "spread" and "Spread" or "Unknown" },
        { 255, 255, 255, ", Flags: ".. table.concat(flags) .. ", Inaccurate: " .. ro(100-c.hit_chance, 1) .. "°)" })
end)

client.set_event_callback("player_hurt", function(c)
    if not contains(active, notifs[1]) then
        return
    end

    local id = client.userid_to_entindex(c.userid)
    local attacker = client.userid_to_entindex(c.attacker)

    if attacker ~= entity.get_local_player() then
        return
    end

    local flags = ""
    if hit[id] ~= nil then
        local shot = shot_info[hit[id]]

        local reasons = ""
        flags = {
            shot.teleported and 'T' or '',
            shot.interpolated and 'I' or '',
            shot.extrapolated and 'E' or '',
            shot.boosted and 'B' or '',
            shot.high_priority and 'H' or ''
        }

        flags = ", " .. table.concat(flags)
    end

    notify.add(5, false, 
        { 255, 255, 255, "Hit " },
        { 150, 185, 1, string.sub(entity.get_player_name(id), 0, 28) },
        { 255, 255, 255, " in the " },
        { 150, 185, 1, hitgroup[c.hitgroup] },
        { 255, 255, 255, " for " },
        { 150, 185, 1, c.dmg_health },
        { 255, 255, 255, " damage (" },
        { 150, 185, 1, c.health .. " health remaining" },
        { 255, 255, 255, flags .. ")" })

    client.log("Hit " .. string.sub(entity.get_player_name(id), 0, 28) .. " in the " .. hitgroup[c.hitgroup] .. " for " .. c.dmg_health .. " damage (" .. c.health .. " health remaining" .. flags .. ")")
end)
