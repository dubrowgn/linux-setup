package.path = './.conky/?.lua;' .. package.path
require('cairo')
require('draw')
require('lib')
require('math')

function tile_dims(idx, offset)
	local row = math.floor(idx / tile_layout.x)
	local col = idx % tile_layout.x

	return {
		x=offset.x + tile_size * col,
		y=offset.y + tile_size * row,
		w=tile_size,
		h=tile_size,
	}
end

function draw_cpu_tile(cairo, cpu, offset)
	local cpu_use = tonumber(conky_parse(string.format('${cpu cpu%u}', cpu)))
	local tile_color = lerp(color.blue, color.red, cpu_use/100)
	local dims = tile_dims(cpu - 1, offset)
	draw_box(cairo, dims, tile_color)

	local center = dims_center(dims)
	draw_text_center(cairo, center, font_px, color.white, cpu_use .. '%')
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

	local offset = { x=dip(8) + 1, y=round(5.5 * line_height + graph_height) }
	for i=1,nproc do
		draw_cpu_tile(cairo, i, offset)
	end

	cairo_surface_destroy(surface)
	cairo_destroy(cairo)
end
