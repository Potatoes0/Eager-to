local modes = {"Rainbow", "Breath", "Christmas"} -- Color mode
local white, red = {255, 255, 255, 255}, {255, 0, 0, 255}
local shouldRepeat, cycle = false, true

-- Options for the lua.
local options = { 
    header = ui.new_label("LUA", "B", "-===== Colorful Menu Color =====-"),
    enabled = ui.new_checkbox("LUA", "B", "| Enabled"),
    mode = ui.new_combobox("LUA", "B", "| Color Mode", modes),
    speed_slider = ui.new_slider("LUA", "B", "| Speed", 1, 100, 0.3, true, "%", 1),
    breath_color_picker = ui.new_color_picker("LUA", "B", "| Base Color", 255, 0, 0, 255),
    christmas_delay = ui.new_slider("LUA", "B", "| Refresh Delay", 0.1, 100, 0.1, true, "s", 0.01),
    info = ui.new_label("LUA", "B", "| Made by UltraPanda with love"),
    footer = ui.new_label("LUA", "B", "-===== Colorful Menu Color =====-"),
}
-- Use ui.reference method to get menu color picker object.
local menu_color_picker = ui.reference("MISC", "Settings", "Menu color")

-- Convert hsv to rgb.
local function hsv_to_rgb(h, s, v, a)
    local r, g, b

    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q    
    end

    return r * 255, g * 255, b * 255, a * 255
end

-- Rainbow color.
local function func_rgb_rainbowize(frequency, rgb_split_ratio)
    local r, g, b, a = hsv_to_rgb(globals.realtime() * frequency, 1, 1, 1)

    r = r * rgb_split_ratio
    g = g * rgb_split_ratio
    b = b * rgb_split_ratio

    return r, g, b
end

local function do_repeat()
    if(cycle == true) then
        cycle = false
    else
        cycle = true
    end

    if(shouldRepeat) then
        local delay_fix = ui.get(options.christmas_delay) / 100
        if(delay_fix == 0) then 
            delay_fix = 0.01 
            ui.set(options.christmas_delay, 0.01)
        end

        client.delay_call(delay_fix, do_repeat)
    end
end

local function update_visiblity()
    if(ui.get(options.enabled) == true) then
        ui.set_visible(menu_color_picker, false)
    else
        ui.set_visible(menu_color_picker, true)
    end

    ui.set_visible(options.speed_slider, false)
    ui.set_visible(options.breath_color_picker, false)
    ui.set_visible(options.christmas_delay, false)
    shouldRepeat = false

    local current_mode = ui.get(options.mode)
    if(current_mode == "Rainbow") then 
        ui.set_visible(options.speed_slider, true)
        shouldRepeat = false
    elseif(current_mode == "Breath") then
        ui.set_visible(options.breath_color_picker, true)
        ui.set_visible(options.speed_slider, true)
        shouldRepeat = false
    elseif(current_mode == "Christmas") then
        ui.set_visible(options.christmas_delay, true)
        shouldRepeat = true
        do_repeat()
    end
end
update_visiblity()

ui.set_callback(options.mode, update_visiblity)
ui.set_callback(options.enabled, update_visiblity)
client.set_event_callback("paint", function()
    -- It's probably good for the performance?
    if(ui.get(options.enabled) ~= true or ui.is_menu_open() ~= true) then return end

    if(ui.get(options.mode) == "Rainbow") then
        local r, g, b = func_rgb_rainbowize(ui.get(options.speed_slider) / 100, 1)
        ui.set(menu_color_picker, r, g, b, 255)
    elseif(ui.get(options.mode) == "Breath") then
        local r, g, b = func_rgb_rainbowize(ui.get(options.speed_slider) / 100, 1)
        local rr, gg, bb = ui.get(options.breath_color_picker)
        if(r < 70) then r = 70 end

        ui.set(menu_color_picker, rr, gg, bb, r)
    elseif(ui.get(options.mode) == "Christmas") then
        if(cycle == true) then
            ui.set(menu_color_picker, 255, 255, 255, 255)
        else
            ui.set(menu_color_picker, 255, 0, 0, 255)
        end
    end
end)