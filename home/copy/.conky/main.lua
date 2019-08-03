package.path = './.conky/?.lua;' .. package.path
require('cairo')
require('config')
require('draw')
require('io')
require('lib')

local hwmod_id

function cpu_init()
	local core_path = '/sys/devices/platform/coretemp.0/hwmon'

	for i=0,16 do
		local f = io.open(core_path .. '/hwmon' .. i)
		if f then
			hwmon_id = i
			io.close(f)
			break
		end
	end
end

cpu_init()

function cpu_info(cpu)
	return {
		freq = tonumber(conky_parse(string.format('${freq_g %u}', cpu))),
		use = tonumber(conky_parse(string.format('${cpu cpu%u}', cpu))),
		temp = tonumber(conky_parse(string.format('${hwmon %u temp %u}', hwmon_id, cpu))),
	}
end

function draw_cpu_tile(cairo, cpu, offset)
	local font_size = dip(12)
	local tiles_per_row = 4
	local row = math.floor((cpu - 1) / tiles_per_row)
	local col = (cpu - 1) % tiles_per_row

	local pad = dip(4)
	local size = dip(41)
	local dims = { x=pad + offset.x, y=pad + offset.y, w=size, h=size }
	dims.x = dims.x + (pad + dims.w) * col
	dims.y = dims.y + (pad + dims.h) * row
	local center = dims_center(dims)

	local info = cpu_info(cpu)

	local tile_color = lerp(color.blue, color.red, info.use/100)
	draw_box(cairo, dims, tile_color)
	draw_text_center(cairo, { x=center.x, y=center.y - dip(8) }, font_size * 1.5, color.white, info.use .. '%')
	draw_text_center(cairo, { x=center.x, y=center.y + dip(2) }, font_size, color.white, info.freq .. ' GHz')
	draw_text_center(cairo, { x=center.x, y=center.y + dip(8) }, font_size, color.white, info.temp .. ' °C')

end

function conky_draw()
	if conky_window == nil then
		return
	end

	local surface = cairo_xlib_surface_create(
		conky_window.display,
		conky_window.drawable,
		conky_window.visual,
		conky_window.width,
		conky_window.height
	)
	local cairo = cairo_create(surface)

	local offset = { x=dip(0), y=dip(44) }
	for i=1,config.cpus do
		draw_cpu_tile(cairo, i, offset)
	end

	cairo_surface_destroy(surface)
	cairo_destroy(cairo)
end
