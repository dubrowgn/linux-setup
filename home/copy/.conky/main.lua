package.path = './.conky/?.lua;' .. package.path
require('cairo')
require('draw')
require('lib')
require('math')

local nproc = tonumber(exec('nproc'))
local tile_layout = constrain_xy(nproc, 4)
local tile_size = dip(360 / tile_layout.x)

function cpu_info(cpu)
	return {
		freq = tonumber(conky_parse(string.format('${freq_g %u}', cpu))),
		use = tonumber(conky_parse(string.format('${cpu cpu%u}', cpu))),
	}
end

function draw_cpu_tile(cairo, cpu, offset)
	local font_size = dip(12)
	local row = math.floor((cpu - 1) / tile_layout.x)
	local col = (cpu - 1) % tile_layout.x

	local dims = {
		x=offset.x + tile_size * col,
		y=offset.y + tile_size * row,
		w=tile_size,
		h=tile_size,
	}
	local center = dims_center(dims)

	local info = cpu_info(cpu)
	local tile_color = lerp(color.blue, color.red, info.use/100)
	draw_box(cairo, dims, tile_color)
	draw_text_center(cairo, { x=center.x, y=center.y - dip(6) }, font_size * 1.5, color.white, info.use .. '%')
	draw_text_center(cairo, { x=center.x, y=center.y + dip(6) }, font_size, color.white, info.freq .. ' GHz')
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

	local offset = { x=dip(8), y=dip(100) }
	for i=1,nproc do
		draw_cpu_tile(cairo, i, offset)
	end

	cairo_surface_destroy(surface)
	cairo_destroy(cairo)
end
