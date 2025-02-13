if (CLIENT) then 

for i=10, 50 do 

	surface.CreateFont( "gDisastersFont_"..tostring(i), {
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = i,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )
end

local function drawPercentageBox( edger, ox, oy, w, l, minv, maxv, current_value, color)

	local xscale, yscale, scale        = ScrW()/1920, ScrH()/1080, (ScrH() + ScrW())/ 3000	
	local percentage                   = 0
	if minv < 0 then
		percentage = math.Clamp((current_value + ((maxv - minv) * 0.5)) / (maxv - minv), 0, 1)
		
	else
		percentage = math.Clamp((current_value-minv)  / (maxv - minv), 0, 1)
	end
	
	local height                       = l * percentage
	local my                           = oy - height
	
	draw.RoundedBox( edger, ox * xscale, my * yscale, w * xscale, height * yscale, color ) -- body temp


end

function hud_gDisastersINFO()
	
	if GetConVar( "gdisasters_hud_enabled" ):GetInt()!=1 then return end
	
	if GetConVar( "gdisasters_hud_type" ):GetInt()==1 then 
		
		hud_DrawBasicINFO()
		
	elseif GetConVar( "gdisasters_hud_type" ):GetInt()==2 then
	
		hud_DrawBarometer()
		
	elseif GetConVar( "gdisasters_hud_type" ):GetInt()==3 then
	
		hud_DrawSeismoGraph()
		
	end
end
hook.Add("HUDPaint", "gDisastersINFO", hud_gDisastersINFO)



function hud_gDisastersAlarm()
	
	if CurTime() >= LocalPlayer().gDisasters.HUD.NextWarningSoundTime then
	
		LocalPlayer():EmitSound( "disasters/player/hud_warning.wav", 100, 100, math.Clamp(GetConVar( "gdisasters_hud_warning_volume" ):GetFloat(),0,1) )
		LocalPlayer().gDisasters.HUD.NextWarningSoundTime = CurTime() + 1
	else
	end
end

function hud_gDisastersHeart(nexttime, pitch)
	if CurTime() >= LocalPlayer().gDisasters.HUD.NextHeartSoundTime then
		LocalPlayer():EmitSound( "disasters/player/heartbeat.wav", 100, pitch, math.Clamp(GetConVar( "gdisasters_hud_heartbeat_volume" ):GetFloat(),0,1))
		LocalPlayer().gDisasters.HUD.NextHeartSoundTime = CurTime() + nexttime
	else
	end
end


function hud_gDisastersVomit()

	if CurTime() >= LocalPlayer().gDisasters.HUD.NextVomitTime then
		LocalPlayer().gDisasters.HUD.VomitIntensity = 1
		net.Start("gd_vomit")
		net.WriteEntity(LocalPlayer())
		net.SendToServer()
		
		LocalPlayer().gDisasters.HUD.NextVomitTime = CurTime() + math.random(1,19)
	else
	end
end

function hud_gDisastersVomitBlood()

	
	if CurTime() >= LocalPlayer().gDisasters.HUD.NextVomitBloodTime  then
		LocalPlayer().gDisasters.HUD.BloodVomitIntensity   = 1
		net.Start("gd_vomit_blood")
		net.WriteEntity(LocalPlayer())
		net.SendToServer()
		
		LocalPlayer().gDisasters.HUD.NextVomitBloodTime  = CurTime() + math.random(1,19)
	else
	end
end




function hud_GDisasters_Hallucinations()


	
	local function createHallucination(class)
		if class == "brush" then 
			
			
			local pos   = LocalPlayer():GetPos() + Vector(math.random(-300,300), math.random(-300,300), 55)
			local prop  =  ClientsideModel( "models/props_c17/pushbroom.mdl" )
			local startangle = Angle(-8,129,153)
			local endangle   = Angle(19, -31,-27)
			prop:SetPos(pos)
			sound.Play(table.Random({"vo/npc/female01/question02.wav","vo/npc/female01/question01.wav","vo/npc/female01/pardonme01.wav", "vo/npc/female01/pardonme02.wav"}), pos, 75, math.random(70, 120), 1)
			sound.Play("disasters/player/wtf1.wav", pos, 75, math.random(90, 110), 1)

			
			for i=0, 600 do
				timer.Simple(i/100, function()
					if prop:IsValid() then
						
						prop:SetAngles( LerpAngle( math.sin(CurTime()*4), startangle, endangle) )
						prop:SetPos( pos + Vector(-0.5,0.5,0) * (math.sin(CurTime() * -4)*100))
					end
				end)	
			end
			timer.Simple(6, function()
				if prop:IsValid() then
				prop:Remove()
				
				end
			end)
			
		end

		if class == "melon" then 
			
			
			local pos   = LocalPlayer():GetPos() + Vector(math.random(-300,300), math.random(-300,300), 55)
			local prop  =  ClientsideModel( "models/props_junk/watermelon01.mdl" )
			prop:SetPos(pos)
			sound.Play(table.Random({"vo/npc/female01/question02.wav","vo/npc/female01/question01.wav","vo/npc/female01/pardonme01.wav", "vo/npc/female01/pardonme02.wav"}), pos, 75, math.random(70, 120), 1)
			sound.Play("disasters/player/wtf2.wav", pos, 75, math.random(90, 110), 1)

			for i=0, 60 do
				timer.Simple(i/10, function()
					if prop:IsValid() then
						

						prop:SetPos( pos + Vector(0,0,1) * (math.sin(CurTime())*10))
					end
				end)	
			end
			timer.Simple(6, function()
				if prop:IsValid() then
				prop:Remove()
				
				end
			end)
			
		end
		if class == "jackhammer" then 
			
			
			local pos   = LocalPlayer():GetPos() + Vector(math.random(-300,300), math.random(-300,300), 45)
			local prop  =  ClientsideModel( "models/props_junk/harpoon002a.mdl" )
			prop:SetAngles( Angle(90, 0, 0))
			prop:SetPos(pos)
			sound.Play(table.Random({"vo/npc/female01/question02.wav","vo/npc/female01/question01.wav","vo/npc/female01/pardonme01.wav", "vo/npc/female01/pardonme02.wav"}), pos, 75, math.random(70, 120), 1)
			sound.Play("disasters/player/wtf3.wav", pos, 75, math.random(90, 110), 1)

			for i=0, 60 do
				timer.Simple(i/10, function()
					if prop:IsValid() then
						

						prop:SetPos( pos + Vector(0,0,1) * (math.sin(CurTime() * 40)*10))
					end
				end)	
			end
			timer.Simple(6, function()
				if prop:IsValid() then
				prop:Remove()
				
				end
			end)
			
		end
		
		if class == "sexymossman" then 
			
			
			local pos   = LocalPlayer():GetPos() + Vector(math.random(-300,300), math.random(-300,300), 45)
			local prop  =  ClientsideModel( "models/mossman.mdl" )
			prop:SetAngles( Angle(0, 0, 0))
			prop:SetPos(pos)
			sound.Play("vo/eli_lab/mo_thiswaydoc.wav", prop:GetPos(), 100, 100, 1)
			sound.Play("hl1/ambience/port_suckout1.wav", prop:GetPos(), 100, 100, 1)
			sound.Play("disasters/player/wtf4.wav", pos, 75, math.random(90, 110), 1)
			ParticleEffectAttach( "vomit_main", PATTACH_POINT_FOLLOW, prop, 3 )
			
			for i=0, 60 do
				timer.Simple(i/10, function()
					if prop:IsValid() then
						local angle = (LocalPlayer():GetPos()-prop:GetPos()):Angle()
						prop:ManipulateBoneAngles( 6, Angle(0,0,angle.y) )
						prop:SetPos( pos + Vector(0,0,1) * (math.sin(CurTime() * 40)*2))
					end
				end)	
			end
			timer.Simple(6, function()
				if prop:IsValid() then
				prop:Remove()
				
				end
			end)
			
		end
		
		
	end
	
	createHallucination(table.Random({"jackhammer","melon","brush", "sexymossman"}))


	
	
end




function hud_DrawBarometer()

	local xscale, yscale, scale        = ScrW()/1920, ScrH()/1080, (ScrH() + ScrW())/ 3000	
		
	local function drawFrame()
		draw.RoundedBox( 12 * scale, 270 * xscale, 885 * yscale, 560 * xscale, 200 * yscale, Color( 30, 30, 30, 150 ) ) -- main box
		draw.RoundedBox( 12 * scale, 280 * xscale, 895 * yscale, 540 * xscale, 180 * yscale, Color( 255, 255, 255, 150 ) ) -- main box
	end
	
	local function drawBarometerOverlay()
		surface.SetDrawColor( 255, 255,255, 255 )

		
		local barometer     = surface.GetTextureID( "hud/barometer" )

		local scale  = 1 
		local w, h   = 540 * scale, 180 * scale
		local x, y   = 550 - (w/2), 985  - (h/2)
		
		surface.SetTexture( barometer )
		surface.DrawTexturedRect(  x * xscale, y * yscale, w * xscale, h * yscale )
		
		
		
	end
	
	local function drawBarometerArrow()
		surface.SetDrawColor( 255, 255, 255, 255 )
		
		local pressure                     = GetGlobalFloat("gDisasters_Pressure")
		local clockhead                    = surface.GetTextureID( "hud/clockhead" )
		local angle                        = math.Clamp((((106000-math.Clamp(pressure,94000,106000))/ 12000) * 180),20,160)
		
		local x0, y0                       = -90 , 0
		
		local c = math.cos( math.rad( angle ) )
		local s = math.sin( math.rad( angle ) )

		local newx = y0 * s - x0 * c
		local newy = y0 * c + x0 * s
		
		
		surface.SetTexture( clockhead )
		surface.DrawTexturedRectRotated( 540 + newx, 1130 + newy, 219, 39, angle )

		

	end
	


	drawFrame()
	drawBarometerOverlay()
	drawBarometerArrow()
end




function hud_DrawBasicINFO()
	local xscale, yscale, scale        = ScrW()/1920, ScrH()/1080, (ScrH() + ScrW())/ 3000
		
	local pos_air_temperature      	   = Vector(280 * xscale, 870 * yscale, 0)
	local pos_body_temperature         = Vector(280 * xscale, 900 * yscale, 0)
	local pos_humidity                 = Vector(280 * xscale, 930 * yscale , 0)
	local pos_windspeed                = Vector(280 * xscale, 960 * yscale , 0)
	local pos_lwindspeed                = Vector(280 * xscale, 990 * yscale , 0)
	
	local air_tmp   = math.Round(GetGlobalFloat("gDisasters_Temperature"),2)
	local body_tmp  = math.Round(LocalPlayer():GetNWFloat("BodyTemperature"),2)
	local hm        = math.Round(GetGlobalFloat("gDisasters_Humidity"),2)
	local windspd   = math.Round(GetGlobalFloat("gDisasters_Wind"))
	local lwindspd  = math.Round(LocalPlayer():GetNWFloat("LocalWind"))
	
	local air_temp   =  string.format("%.2f", tostring( air_tmp  )).."c"
	local body_temp  =  string.format("%.2f",tostring( math.Round(LocalPlayer():GetNWFloat("BodyTemperature"),2) )).."c"
	local humidity   =  string.format("%.2f",tostring( hm,2) ).."%"
	
	
	local function windspeed_Format(speed)
		local strspeed = tostring(speed)
		local chr1, chr2, chr3, chr4, comma = strspeed[1], strspeed[2], strspeed[3], strspeed[4], ","
		
		if chr1 == "" or chr1==nil  then chr1 = "" end
		if chr2 == "" or chr2==nil  then chr2 = "" end
		if chr3 == "" or chr3==nil  then chr3 = "" end
		if chr4 == "" or chr4==nil  then chr4 = ""; comma="" end
		
		if speed <= 256 then 
		
			strspeed = chr1..comma..chr2..chr3..chr4.." km/h"
		else
			strspeed = table.Random({">256 km/h", "ERROR"})
		end
		
		return strspeed
		
		
	end

	local wind_speed   =  tostring(windspeed_Format(windspd))
	local local_wspeed =  tostring(windspeed_Format(lwindspd))
	

	local function drawFrame()
	
		draw.RoundedBox( 12 * scale, 270 * xscale, 855 * yscale, 560 * xscale, 200 * yscale, Color( 30, 30, 30, 100 ) ) -- main box
		draw.RoundedBox( 6 * scale, 595 * xscale, 865 * yscale, 225 * xscale, 180 * yscale, Color( 30, 30, 30, 100 ) ) -- main box right
		draw.RoundedBox( 6 * scale, 680 * xscale, 890 * yscale, 128 * xscale, 128 * yscale, Color( 30, 30, 30, 150 + (math.sin(CurTime()) * 50) ) ) 
		
	end
	
	local function drawText()
	
		draw.DrawText( "Air Temperature    : "..air_temp, "gDisastersFont_"..tostring(math.Round(scale * 25)), pos_air_temperature.x , pos_air_temperature.y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
		
		draw.DrawText( "Body Temperature: "..body_temp, "gDisastersFont_"..tostring(math.Round(scale * 25)), pos_body_temperature.x , pos_body_temperature.y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
		
		draw.DrawText( "Humidity                : "..humidity, "gDisastersFont_"..tostring(math.Round(scale * 25)), pos_humidity.x , pos_humidity.y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
		
		local color  = Color(255,255,255,255)
		local color2  = Color(255,255,255,255)
	
		if windspd > 256 then
			color    = Color(math.random(0,255), 0, 0, 255)
			color2    = Color(math.random(0,255), 0, 0, 255)
		end
		
		draw.DrawText( "Wind Speed          : "..wind_speed, "gDisastersFont_"..tostring(math.Round(scale * 25)), pos_windspeed.x , pos_windspeed.y, color, TEXT_ALIGN_LEFT )
		draw.DrawText( "Local Wind Speed: "..local_wspeed, "gDisastersFont_"..tostring(math.Round(scale * 25)), pos_lwindspeed.x , pos_lwindspeed.y, color2, TEXT_ALIGN_LEFT )

		
	end
	
	local function drawBars()
	
		local hypo_min, hypo_max     = 24,   36.5
		local safe_c_min, safe_c_max = 35.5, 38
		local hyper_min, hyper_max   = 38,   44
		
		local r, g, b                   = 0, 0, 0
		local r2, g2, b2                = 0, 0, 0
		
		local function drawCoreBar()
			if body_tmp >= hypo_min and body_tmp <= hypo_max then 
				
				if body_tmp <= ((hypo_min+hypo_max)/2) then
					local p = (body_tmp-24) / 6.25
					r = 0
					g = 255 * p
					b = 255
				else 
					local p = (body_tmp-30.25) / 6.25
					
					r = 0
					g = 255 
					b = 255 * (1 - p)
				end
				
			elseif body_tmp > safe_c_min and body_tmp < safe_c_max then
				r = 0
				g = 255 
				b = 0
			elseif body_tmp >= hyper_min and body_tmp <= hyper_max then 
			
				if body_tmp <= ((hyper_min+hyper_max)/2) then

					local p = (body_tmp-38) / 3
					r = 255 * p
					g = 255 
					b = 0
				else 
					local p = (body_tmp-41) / 3
					
					r = 255
					g = 255 * (1 - p)
					b = 0
				end
			end
			
			if body_tmp < 26 or body_tmp > 40 then 
				
				if math.Round(CurTime())%2 == 0 then
					hud_gDisastersAlarm()
					drawPercentageBox( 0, 624, 1020, 22, 150, 24, 44, body_tmp, Color( r, g, b, 255 ))
				else
					drawPercentageBox( 0, 624, 1020, 22, 150, 24, 44, body_tmp, Color( 0, 0, 0, 255 ))
				end
			else
				drawPercentageBox( 0, 624, 1020, 22, 150, 24, 44, body_tmp, Color( r, g, b, 200 ))
			end
		end
		
		local function drawAirBar()
			if air_tmp >= -273.3 and air_tmp <= 0 then 
				
				if air_tmp <= -136.65 then
					local p = (air_tmp+273.3) / 136.65
					r2 = 0
					g2 = 255 * p
					b2 = 255
				else 
					local p = (air_tmp+136.65) / 136.65
					
					r2 = 0
					g2 = 255 
					b2 = 255 * (1 - p)
				end
				
			elseif air_tmp > 5 and air_tmp < 38 then
				r2 = 0
				g2 = 255 
				b2 = 0
			elseif air_tmp >= 38 and air_tmp <= 273.3 then 
			
				if air_tmp <= 136.65 then

					local p = (air_tmp-38) / 98.65
					r2 = 255 * p
					g2 = 255 
					b2 = 0
				else 
					local p = (air_tmp-136.65) / 136.65
	
					r2 = 255
					g2 = 255 * (1 - p)
					b2 = 0
				end
			end
			
			drawPercentageBox( 0, 600, 1020, 22, 150, -273, 273, air_tmp, Color( r2, g2, b2, 200))

		end
		
		local function drawHumidityBar()
			drawPercentageBox( 0, 648, 1020, 22, 150, 0, 100, hm, Color( 155, 155, 155, 200))
		end
		drawHumidityBar()	
		drawAirBar()
		drawCoreBar()
	end
	local function drawHeart()
		
		surface.SetDrawColor( 255, 255, 255, 255)
		local heart     = surface.GetTextureID( "hud/heart" )
		local freq      = math.Clamp((1-((44-math.Round(body_tmp))/20)) * (180/60), 0.5, 20)
		if LocalPlayer():Alive()==false then freq = 0.05 end 
		

		local scale  = 1 + (math.sin( CurTime() * ((2*math.pi) * freq) ) * 0.1)
		local w, h   = 110 * scale, 110 * scale
		local x, y   = 750 - (w/2), 955  - (h/2)
		
		surface.SetTexture( heart )
		surface.DrawTexturedRect(  x * xscale, y * yscale, w * xscale, h * yscale )
		hud_gDisastersHeart( 1/freq , 100 )
		
	end
	
	local function drawIcons()
		surface.SetDrawColor( 255, 255,255, 255 )
		
		local airtemp      = surface.GetTextureID( "icons/airtemp" )
		local bodytemp     = surface.GetTextureID( "icons/bodytemp" )
		local humidity     = surface.GetTextureID( "icons/humidity" )
		local w, h   = 16 * scale, 16 * scale
		
		local x, y   = 605, 1025
		surface.SetTexture( airtemp )
		surface.DrawTexturedRect(  x * xscale, y * yscale, w * xscale, h * yscale )
		


		local x, y   = 629, 1025
		surface.SetTexture( bodytemp )
		surface.DrawTexturedRect(  x * xscale, y * yscale, w * xscale, h * yscale )
		
		local x, y   = 651, 1025
		surface.SetTexture( humidity )
		surface.DrawTexturedRect(  x * xscale, y * yscale, w * xscale, h * yscale )
		
	end
	
	
	
	
	
	
	
	
	drawFrame()
	drawText()
	drawBars()
	drawHeart()
	drawIcons()

end

function hud_DrawSeismoGraph()
	
	local xscale, yscale, scale        = ScrW()/1920, ScrH()/1080, (ScrH() + ScrW())/ 3000	
	local xmin, xmax = 290  * yscale , (269+540) * yscale 
	local ymin, ymax = 900  * yscale , (890+180) * yscale 	
	
	local function drawFrame()
		draw.RoundedBox( 12 * scale, 270 * xscale, 885 * yscale, 620 * xscale, 200 * yscale, Color( 30, 30, 30, 150 ) ) -- main box
		draw.RoundedBox( 12 * scale, 280 * xscale, 895 * yscale, 610 * xscale, 180 * yscale, Color( 0, 0, 0, 255 ) ) -- main box
	end
	
	local function drawGrid()		
		local xjump      = math.floor(xmax-xmin)
		local yjump      = math.floor(ymax-ymin)
		
		local xdensity   = 16
		local ydensity   = 10
	
		surface.SetDrawColor( 0, 55, 0, 255 )
		
		for i=0, xdensity do
			local nxmin = ((i/xdensity) * (xjump) + xmin)
			surface.DrawLine( nxmin, ymin, nxmin, ymax )
		end
		
		for i=0, ydensity do
		
			local nymin = ((i/ydensity) * (yjump) + ymin)

			surface.DrawLine( xmin, nymin, xmax, nymin )
		end
		
	end
	

	local function recordTremors()
	
		local sample_interval = math.Clamp( ((1/FrameTime())/66.666) * 0.01, 0.01, 1)
		local max_sample_points = 500
		
		if LocalPlayer().SeismoGraph_SampleIntervalNextTime == nil then LocalPlayer().SeismoGraph_SampleIntervalNextTime = CurTime() end
		if LocalPlayer().SeismoGraph_SamplePoints == nil then LocalPlayer().SeismoGraph_SamplePoints = {} end
		
		if #LocalPlayer().SeismoGraph_SamplePoints > max_sample_points then
			table.remove(LocalPlayer().SeismoGraph_SamplePoints, max_sample_points + 1 )
		end
		
		if CurTime() >= LocalPlayer().SeismoGraph_SampleIntervalNextTime then  -- here we add sample points 
			
			local M  =  -1+( GetGlobalFloat("gd_seismic_activity")/10)
			local IP =  (-(M-0.25)^2 - (2/(M-0.25))) / 8
		
			local ygain = (( 0.5 * (ymax - ymin) + math.random(0,10) ) * (math.sin( (2 * math.pi * math.random(14,16)) * CurTime()))) * (math.Clamp((IP),0.01, 1))
	
			LocalPlayer().SeismoGraph_SampleIntervalNextTime = CurTime() + sample_interval
			table.insert(LocalPlayer().SeismoGraph_SamplePoints, { ["A"]= IP, ["Pos"]=Vector(xmax, ( (ymax + ymin) / 2) + ygain)   }   ) 
			
		
		end
		
	
	end	
	
	local function drawTremors()
		surface.SetDrawColor( 0, 255, 0, 255 )
		
		local vel  = 66.666/(1/FrameTime())
		local max_a= 0
		for k, v in pairs(LocalPlayer().SeismoGraph_SamplePoints) do
			
			v["Pos"] = v["Pos"] - Vector(vel,0,0)
			if v["Pos"].x <= xmin then table.remove(LocalPlayer().SeismoGraph_SamplePoints, k) end -- remove out of bounds stuff
			
			if LocalPlayer().SeismoGraph_SamplePoints[k-1] != nil then
				local olpos = LocalPlayer().SeismoGraph_SamplePoints[k-1]["Pos"]
				local amp   = LocalPlayer().SeismoGraph_SamplePoints[k-1]["A"]
				
				surface.SetDrawColor( 0, 255, 0, 255 )
				surface.DrawLine( olpos.x, olpos.y, v["Pos"].x, v["Pos"].y )
				surface.SetDrawColor( 255, 0, 0, 255 * ((v["A"]+amp) * 0.5) )
				surface.DrawLine( olpos.x, (amp  * (-0.5 * (ymax - ymin)))+ (0.5 * (ymax + ymin)), v["Pos"].x, (v["A"] * (-0.5 * (ymax - ymin))) + (0.5 * (ymax + ymin))  )
				surface.DrawLine( olpos.x, (amp  * (0.5 * (ymax - ymin)))+ (0.5 * (ymax + ymin)), v["Pos"].x, (v["A"] * (0.5 * (ymax - ymin))) + (0.5 * (ymax + ymin))  )
				
				if max_a < v["A"] then 
					max_a_x =  v["Pos"].x
					max_a   =  v["A"] 
				end
				
			end
			
		end
		
		local peak_x_min, peak_x_max =  809 * xscale, 828 * xscale 
		--±0.4
		surface.SetDrawColor( 255, 255, 255 , 255 )
		surface.DrawLine( peak_x_min, (max_a  * (-0.5 * (ymax - ymin)))+ (0.5 * (ymax + ymin)), peak_x_max, (max_a  * (-0.5 * (ymax - ymin)))+ (0.5 * (ymax + ymin)) )
		draw.DrawText( " Richter Scale \n     ≈  "..math.Round(max_a*15,1), "gDisastersFont_"..tostring(math.Round(scale * 15)), peak_x_min , (max_a  * (-0.5 * (ymax - ymin)))+ (0.5 * (ymax + ymin)) , Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

	end	
	recordTremors()
	
	drawFrame()
	drawGrid()
	drawTremors()
	

end



end






