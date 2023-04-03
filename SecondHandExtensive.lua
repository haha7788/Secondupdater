script_name("SecondHandExtensive")
script_version("04.04.2023")

local enable_autoupdate = true
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/haha7788/Secondupdater/main/version.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/haha7788/Secondupdater/"
        end
    end
end

require "lib.moonloader"
local events = require "lib.samp.events"
local sampev = require 'lib.samp.events'
local imgui = require "imgui"
local requests = require('requests')
local encoding = require "encoding"
local fa = require("fAwesome5")
encoding.default = "CP1251"
u8 = encoding.UTF8
font = renderCreateFont("Century Gothic", 9, 5)

local work = imgui.ImBool(false)
local work_stat = imgui.ImBool(false)
local stat = imgui.ImBool(false)
local render = imgui.ImBool(false)
local ragemod = imgui.ImBool(false)
local begit = imgui.ImBool(false)
local sbiv = imgui.ImBool(false)
local alt = imgui.ImBool(false)
local enter = imgui.ImBool(false)
local collision = imgui.ImBool(false)
local shmot = imgui.ImBool(false)
local obj_col_act = false
local collision_objects = imgui.ImBool(false)
local objects = nil
local sh = imgui.ImBool(false)
local slider = imgui.ImInt(300)
local sliderr = imgui.ImInt(500)

local time = os.clock()
local money = 0
local larci = 0
local sc = 0
local scc = 0
local sccc = 0
local scccc = 0
local sec = 0
local thread = nil
local array = {}
local amount = 0
local sbivala = 0

function runToPoint(tox, toy, isSprint)
    local x, y, z = getCharCoordinates(PLAYER_PED)
    local angle = getHeadingFromVector2d(tox - x, toy - y)
    local xAngle = math.random(-1, 1)/100
    setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
    stopRun = false
    while getDistanceBetweenCoords2d(x, y, tox, toy) > 0.8 do
        setGameKeyState(1, -255)
		if isSprint then setGameKeyState(16, 255) end
		isSprint = true
        wait(1)
        x, y, z = getCharCoordinates(PLAYER_PED)
        angle = getHeadingFromVector2d(tox - x, toy - y)
        setCameraPositionUnfixed(xAngle, math.rad(angle - 90))
        if stopRun then
            stopRun = false
            break
        end
    end
end

local menu = {true,
    false,
    
}

function getTableUsersByUrl(url)
    local n_file, bool, users = os.getenv('TEMP')..os.time(), false, {}
    downloadUrlToFile(url, n_file, function(id, status)
        if status == 6 then bool = true end
    end)
    while not doesFileExist(n_file) do wait(0) end
    if bool then
        local file = io.open(n_file, 'r')
        for w in file:lines() do
            local n, d = w:match('(.*): (.*)')
            users[#users+1] = { name = n, date = d }
        end
        file:close()
        os.remove(n_file)
    end
    return bool, users
end

function isAvailableUser(users, name)
    for i, k in pairs(users) do
        if k.name == name then
            local d, m, y = k.date:match('(%d+)%.(%d+)%.(%d+)')
            local time = {
                day = tonumber(d),
                isdst = true,
                wday = 0,
                yday = 0,
                year = tonumber(y),
                month = tonumber(m),
                hour = 0
            }
            if os.time(time) >= os.time() then return true end
        end
    end
    return false
end

site = 'https://pastebin.com/raw/KXZA8bhu'

function main()
	repeat wait(0) until isSampAvailable()
    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    while sampGetCurrentServerName() == 'SA-MP' do wait(0) end
    local bool, users = getTableUsersByUrl(site) -- узнаём таблицу списка.
    assert(bool, 'Downloading list users failed.') -- Если bool = false.
    local _, myid = sampGetPlayerIdByCharHandle(playerPed) -- Узнаём свой ид.
    assert(isAvailableUser(users, sampGetPlayerNickname(myid)), 'The term is ended or your name is not in the list.') -- Если пользователя нету в списке или срок уже пройден.
	wait(100)
	sampAddChatMessage("{AD42FE}[SecondHandExtensive]{ffffff} -  Загружен! Активация: /second | Автор: vlaDICK2288", -1)
	sampRegisterChatCommand("second", menu_imgui)
	sampRegisterChatCommand("second.stat", stat_imgui)
	while true do
		wait(0)
	if begit.v then
             for id = 0, 4096 do
                 if sampIs3dTextDefined(id) then
                   local text, color, x, y, z, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(id)
                    if text:find("Одежда из секонд-хенда") then
						wait(1000)
						runToPoint(x, y, z)
						end
					end
				end
			end
    if ragemod.v then
             for id = 0, 4096 do
                 if sampIs3dTextDefined(id) then
                   local text, color, x, y, z, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(id)
                     if text:find("Одежда из секонд-хенда") then
						wait(sliderr.v)
                        setCharCoordinates(PLAYER_PED, x, y, z)
                            break
							end
						end
					end
				end
		if sh.v then
			if isCharOnFoot(playerPed) and isKeyDown(0x31) and isKeyCheckAvailable() then
				setGameKeyState(16, 256)
				wait(10)
				setGameKeyState(16, 0)
			end
		end
        if obj_col_act then
            find_obj_x, find_obj_y, find_obj_z = getCharCoordinates(PLAYER_PED)
            result, objectHandle = findAllRandomObjectsInSphere(find_obj_x, find_obj_y, find_obj_z, 25, true)
            if result then
                setObjectCollision(objectHandle, false)
            end
        else
            find_obj_x, find_obj_y, find_obj_z = getCharCoordinates(PLAYER_PED)
            result, objectHandle = findAllRandomObjectsInSphere(find_obj_x, find_obj_y, find_obj_z, 25, true)
            if result then
                setObjectCollision(objectHandle, true)
			end
		end
		if render.v then
	     for id = 0, 4096 do
		     if sampIs3dTextDefined(id) then
	 	       local text, color, x, y, z, distance, ignoreWalls, player, vehicle = sampGet3dTextInfoById(id)
	 	         if text:find("Одежда из секонд-хенда") then
	 		        if isPointOnScreen(x, y, z, 3.0) then
	 			        xp, yp, zp = getCharCoordinates(PLAYER_PED)
	 			        x1, y2 = convert3DCoordsToScreen(x, y, z)
	 			        p3, p4 = convert3DCoordsToScreen(xp, yp, zp)
	 			        distance = string.format("%.0f", getDistanceBetweenCoords3d(x, y, z, xp, yp, zp))
	 			        text = ("{ffffff}Шмот\n{ff0000}Дистанция: "..distance)
	 			        renderDrawLine(x1, y2, p3, p4, 2, 0xFFFF0000)
	 			        renderFontDrawText(font, text, x1, y2, -1)
						end
					end
				end
			end
		end
		if shmot.v then
            for a = 0, 4096 do
                if sampTextdrawIsExists(a) then
                local model, rotX, rotY, rotZ, zoom, clr1, clr2 = sampTextdrawGetModelRotationZoomVehColor(a)
                    if model == 2844 or model == 2845 or model == 2846 or model == 2072 or model == 2076 or model == 2077 or model == 2081 or model == 2074 or model == 2079 or model == 2075 or model == 2078 or model == 2073 or model == 2080 then
                        sampSendClickTextdraw(a)
                        wait(slider.v)
						end
					end
				end
			end
		if alt.v then
		while true do
		wait(450)
			local x, y, z = getCharCoordinates(PLAYER_PED)
			local result, _, _, _, _, _, _, _, _, _ = Search3Dtext(x, y, z, 3, "Одежда")
				if result then
				setGameKeyState(21, 255)
				wait(5)
				setGameKeyState(21, 0)
				result = false
				end
			end
		if enter.v then
			end
		end
	end
end

function Search3Dtext(x, y, z, radius, patern)
    local text = ""
    local color = 0
    local posX = 0.0
    local posY = 0.0
    local posZ = 0.0
    local distance = 0.0
    local ignoreWalls = false
    local player = -1
    local vehicle = -1
    local result = false

    for id = 0, 2048 do
        if sampIs3dTextDefined(id) then
            local text2, color2, posX2, posY2, posZ2, distance2, ignoreWalls2, player2, vehicle2 = sampGet3dTextInfoById(id)
            if getDistanceBetweenCoords3d(x, y, z, posX2, posY2, posZ2) < radius then
                if string.len(patern) ~= 0 then
                    if string.match(text2, patern, 0) ~= nil then result = true end
                else
                    result = true
                end
                if result then
                    text = text2
                    color = color2
                    posX = posX2
                    posY = posY2
                    posZ = posZ2
                    distance = distance2
                    ignoreWalls = ignoreWalls2
                    player = player2
                    vehicle = vehicle2
                    radius = getDistanceBetweenCoords3d(x, y, z, posX, posY, posZ)
                end
            end
        end
    end

    return result, text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle
end

function isKeyCheckAvailable()
	if not isSampLoaded() then
		return true
	end
	if not isSampfuncsLoaded() then
		return not sampIsChatInputActive() and not sampIsDialogActive()
	end
	return not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive()
end

function menu_imgui()
		work.v = not work.v
		imgui.Process = work.v or stat.v
end

function imgui.OnDrawFrame()
    local w, h = getScreenResolution()
	if not work.v and not work_stat.v then
		imgui.Process = false
	end
	if work.v then
	imgui_colors()
	imgui.ShowCursor = true
	imgui.SetNextWindowSize(imgui.ImVec2(250, 230), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(w/2, h/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.Begin(u8"SecondHandExtensive", imgui.WindowFlags.NoCollapse, imgui.WindowFlags.NoResize)
    if imgui.Button(u8"Легит", imgui.ImVec2(73, 30)) then uu() menu[1] = true end imgui.SameLine()
    if imgui.Button(u8'Дангеон', imgui.ImVec2(73, 30)) then uu() menu[2] = true end imgui.SameLine()
	if imgui.Button(u8'Настройки', imgui.ImVec2(73, 30)) then uu() menu[3] = true end
    imgui.Separator()
    imgui.NewLine()
    imgui.SameLine(2)
    if menu[1] then
	imgui.Text(u8" Тут собран софт который не палится")
	imgui.Checkbox(u8"Авто сбор одежды", shmot)
	imgui.TextQuestion('Можно настроить задержку в настройках')
	imgui.Checkbox(u8"Рендер одежды", render)
	imgui.TextQuestion('Можно настроить в настройках')
	imgui.Checkbox(u8"Авто alt", alt)
	imgui.Checkbox(u8"Авто enter", enter)
	if imgui.Checkbox(u8"Статистика и информация", stat) then
		work_stat.v = not work_stat.v
	end
    end
    if menu[2] then
	imgui.Text(u8" Тут собран софт чтобы быть пидером")
	imgui.Checkbox(u8"Работа пешом", begit)
	imgui.TextQuestion('Использовать вместе с:\nавто alt\nавто enter\nавто сбор одежды\nколлизия')
	imgui.Checkbox(u8"Работа телепортом", ragemod)
	imgui.TextQuestion('Использовать вместе с:\nавто alt\nавто enter\nавто сбор одежды\nможно настроить задержку в настройках')
	imgui.Checkbox(u8"Спринтхук", sh)
	imgui.TextQuestion('Активация w+1')
	imgui.Checkbox(u8"Коллизия на стеллажи", collision)
	if imgui.Checkbox(u8"Сбив анимки сбора", sbiv) then
		if sbiv.v == true then  
		sbivala = 2
	elseif sbiv.v == false then 
		sbivala = 0
		end 
	end
	end
	if menu[3] then
	imgui.Text(u8" Сбор одежды")
	imgui.SliderInt("##first", slider, 300, 800)
	imgui.Text(u8"Время телепорта")
	imgui.SliderInt("##second", sliderr, 500, 1500)
	end
    if collision.v then
		obj_col_act = true
	else
		obj_col_act = false
    end
	imgui.End()
	end
	if work_stat.v then
		if not work.v then
			imgui.ShowCursor = false
		end
	imgui.SetNextWindowSize(imgui.ImVec2(290, 295), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(w/2, h/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.Begin(u8"Статистика", stat, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
    imgui.Text(u8'Текущее время: '..os.date('%H:%M:%S'))
	imgui.Text(u8"Таймер спавна одежды: "..sec)
	imgui.Text(u8"Потрачено денег: "..money)
	imgui.Text(u8"Куплено одежды: "..larci)
	if imgui.Button(u8"Очистить статистику") then
		money = 0
		larci = 0
	end
	imgui.Text(u8"")
    for _, text in ipairs(array) do
    imgui.Text(u8(text))
	end
	if imgui.Button(u8"Вывести статистику секонд хендов") then
	amount = 2
        sampSendChat("/gps")
        sampSendDialogResponse(25309, 2, 9, nil)
	end
	imgui.End()
	end
end

imgui["TextQuestion"] = function(text)
	imgui.SameLine(0, 5)
	imgui.TextDisabled(fa.ICON_FA_QUESTION_CIRCLE)
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(450)
		imgui.TextUnformatted(u8(text))
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end

function uu()
    for i = 0,3 do
        menu[i] = false
    end
end

function events.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
	if text:find("До следующего выноса одежды в зал осталось (%d+) секунд.") then
		sec = text:match("осталось (%d+) секунд!")
		if thread ~= nil then thread:terminate() thread = nil end
		thread = lua_thread.create(function()
			wait(1500)
			thread = nil
		end)
	end
end

function sampev.onShowDialog(id, style, title, button1, button2, text)
    if title:find("Секонд%-хенды") then
        array = {}
        for line in text:gmatch('[^\r\n]+') do
            sk = line:gsub("%{......%}Секонд%-хенд%s+%{......%}Начало распродажи%s+%{......%}Количество одежды на распродаже", "")
            rb = sk:gsub("%{......%}Склад комиссионной одежды%s%{......%}работает%sс%s10:00%s%{......%}до%s11:00", "")
            ar = rb:gsub("%{......%}", "")
            array[#array+1] = ar
        end
	end
	if amount == 2 or amount == 1 then
      if id == 25309 or id == 15339 then
        amount = amount - 1
        return false
    end
  end
end

function sampev.onServerMessage(color, text)
    if string.find(text, "Вы купили одежду из секонд-хенда за $50000.", 1, true) then
        lua_thread.create(function()
            wait(1)
			larci = larci + 1
			money = money + 50000
		if sbivala == 2 then
			sampSendChat(".")
			end
		end)
	end
end

function imgui_colors()
        local style = imgui.GetStyle()
        local colors = style.Colors
        local clr = imgui.Col
        local ImVec4 = imgui.ImVec4
        colors[clr.Text]                 = ImVec4(1.00, 1.00, 1.00, 1.00)
        colors[clr.TextDisabled]         = ImVec4(0.60, 0.60, 0.60, 1.00)
        colors[clr.WindowBg]             = ImVec4(0.09, 0.09, 0.09, 1.00)
        colors[clr.ChildWindowBg]        = ImVec4(9.90, 9.99, 9.99, 0.00)
        colors[clr.PopupBg]              = ImVec4(0.09, 0.09, 0.09, 1.00)
        colors[clr.Border]               = ImVec4(0.71, 0.71, 0.71, 0.40)
        colors[clr.BorderShadow]         = ImVec4(9.90, 9.99, 9.99, 0.00)
        colors[clr.FrameBg]              = ImVec4(0.34, 0.30, 0.34, 0.30)
        colors[clr.FrameBgHovered]       = ImVec4(0.22, 0.21, 0.21, 0.40)
        colors[clr.FrameBgActive]        = ImVec4(0.20, 0.20, 0.20, 0.44)
        colors[clr.TitleBg]              = ImVec4(0.52, 0.27, 0.77, 0.82)
        colors[clr.TitleBgActive]        = ImVec4(0.55, 0.28, 0.75, 0.87)
        colors[clr.TitleBgCollapsed]     = ImVec4(9.99, 9.99, 9.90, 0.20)
        colors[clr.MenuBarBg]            = ImVec4(0.27, 0.27, 0.29, 0.80)
        colors[clr.ScrollbarBg]          = ImVec4(0.08, 0.08, 0.08, 0.60)
        colors[clr.ScrollbarGrab]        = ImVec4(0.54, 0.20, 0.66, 0.30)
        colors[clr.ScrollbarGrabHovered] = ImVec4(0.21, 0.21, 0.21, 0.40)
        colors[clr.ScrollbarGrabActive]  = ImVec4(0.80, 0.50, 0.50, 0.40)
        colors[clr.ComboBg]              = ImVec4(0.20, 0.20, 0.20, 0.99)
        colors[clr.CheckMark]            = ImVec4(0.89, 0.89, 0.89, 0.50)
        colors[clr.SliderGrab]           = ImVec4(1.00, 1.00, 1.00, 0.30)
        colors[clr.SliderGrabActive]     = ImVec4(0.80, 0.50, 0.50, 1.00)
        colors[clr.Button]               = ImVec4(0.48, 0.25, 0.60, 0.60)
        colors[clr.ButtonHovered]        = ImVec4(0.67, 0.40, 0.40, 1.00)
        colors[clr.ButtonActive]         = ImVec4(0.80, 0.50, 0.50, 1.00)
        colors[clr.Header]               = ImVec4(0.56, 0.27, 0.73, 0.44)
        colors[clr.HeaderHovered]        = ImVec4(0.78, 0.44, 0.89, 0.80)
        colors[clr.HeaderActive]         = ImVec4(0.81, 0.52, 0.87, 0.80)
        colors[clr.Separator]            = ImVec4(0.42, 0.42, 0.42, 1.00)
        colors[clr.SeparatorHovered]     = ImVec4(0.57, 0.24, 0.73, 1.00)
        colors[clr.SeparatorActive]      = ImVec4(0.69, 0.69, 0.89, 1.00)
        colors[clr.ResizeGrip]           = ImVec4(1.00, 1.00, 1.00, 0.30)
        colors[clr.ResizeGripHovered]    = ImVec4(1.00, 1.00, 1.00, 0.60)
        colors[clr.ResizeGripActive]     = ImVec4(1.00, 1.00, 1.00, 0.89)
        colors[clr.CloseButton]          = ImVec4(0.33, 0.14, 0.46, 0.50)
        colors[clr.CloseButtonHovered]   = ImVec4(0.69, 0.69, 0.89, 0.60)
        colors[clr.CloseButtonActive]    = ImVec4(0.69, 0.69, 0.69, 1.00)
        colors[clr.PlotLines]            = ImVec4(1.00, 0.99, 0.99, 1.00)
        colors[clr.PlotLinesHovered]     = ImVec4(0.49, 0.00, 0.89, 1.00)
        colors[clr.PlotHistogram]        = ImVec4(9.99, 9.99, 9.90, 1.00)
        colors[clr.PlotHistogramHovered] = ImVec4(9.99, 9.99, 9.90, 1.00)
        colors[clr.TextSelectedBg]       = ImVec4(0.54, 0.00, 1.00, 0.34)
        colors[clr.ModalWindowDarkening] = ImVec4(0.20, 0.20, 0.20, 0.34)
end