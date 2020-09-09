local x, y = client.screen_size()
local wishstupid = ui.reference
local wishmonkey = ui.new_combobox
local wishdog = ui.new_color_picker
local wishuseless = ui.new_slider
local wishdumbass = ui.new_checkbox
local wishfat = ui.get
local wishreallynn = wishstupid("RAGE", "Aimbot", "Minimum damage")
local wishfuckoff = wishstupid("RAGE", "Aimbot", "Minimum hit chance")
local wishisfag = renderer.indicator
local wishchinese = renderer.text
local wishfan = client.set_event_callback
local wishbraindead = wishdumbass("VISUALS", "Effects", "HC & DMG indicators")
local wishinviteseller = wishdumbass("VISUALS", "EFFECTS", "Static")
local wishdumbo = wishdog("VISUALS", "Effects", "Aaish")
local wishaaish = wishmonkey("VISUALS", "EFFECTS", "Color", "Static", "Rainbow")
local wishx = wishuseless("VISUALS", "EFFECTS", "Width", 0, x, 1000, false, wi)
local wishy = wishuseless("VISUALS", "EFFECTS", "Height", 0, y, 1000, false, sh)
local wishassr, wishassg, wishassb, wishassa
local wishdick
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

local function func_rgb_rainbowize(frequency, rgb_split_ratio)
    local r, g, b, a = hsv_to_rgb(globals.realtime() * frequency, 1, 1, 1)

    r = r * rgb_split_ratio
    g = g * rgb_split_ratio
    b = b * rgb_split_ratio

    return r, g, b
end

local function wishnn(ctx) 
	renderer.measure_text("+", "free2886")
	
	if wishfat(wishreallynn) > 100 then
		wishdick = "HP+" .. wishfat(wishreallynn) - 100
	else
		wishdick = wishfat(wishreallynn)
	end
	
	if wishfat(wishaaish) == "Rainbow" then
		wishassr, wishassg, wishassb = func_rgb_rainbowize(0.1, 1)
	else
		wishassr, wishassg, wishassb, wishassa = wishfat(wishdumbo)
	end
	if wishfat(wishbraindead) then
		if wishfat(wishinviteseller) then
			wishisfag(wishassr, wishassg, wishassb, wishassa, "DMG: ", wishdick)
			wishisfag(wishassr, wishassg, wishassb, wishassa, "HC: ", wishfat(wishfuckoff),"%")
		else
			wishchinese(wishfat(wishx), wishfat(wishy) + 36, wishassr, wishassg, wishassb, wishassa, "+", 0, "DMG: ", wishdick)
			wishchinese(wishfat(wishx), wishfat(wishy), wishassr, wishassg, wishassb, wishassa, "+", 0, "HC: ", wishfat(wishfuckoff),"%")
		end
	end
end
wishfan("paint", wishnn)