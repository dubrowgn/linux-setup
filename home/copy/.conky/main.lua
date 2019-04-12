package.path = './.conky/?.lua;' .. package.path
require('config')
require('lib')
require('cairo')

local white = { r=1, g=1, b=1, a=1 }
local light_grey = { r=0.9372549019607843, g=0.9372549019607843, b=0.9372549019607843, a=1 }
local dark_grey = { r=0.4, g=0.4, b=0.4, a=1 }
local black = { r=0, g=0, b=0, a=1 }
local red = { r=0.8, g=0, b=0, a=1 }
local orange = { r=0.9019607843137255, g=0.5686274509803921, b=0.2196078431372549, a=1 }
local yellow = { r=0.9450980392156862, g=0.7607843137254902, b=0.19607843137254902, a=1 }
local green = { r=0.41568627450980394, g=0.6588235294117647, b=0.30980392156862746, a=1 }
local blue = { r=0.23529411764705882, g=0.47058823529411764, b=0.8470588235294118, a=1 }
local purple = { r=0.403921568627451, g=0.3058823529411765, b=0.6549019607843137, a=1 }

function lerp(zero_color, one_color, value)
	return {
		r = zero_color.r + (one_color.r - zero_color.r) * value,
		g = zero_color.g + (one_color.g - zero_color.g) * value,
		b = zero_color.b + (one_color.b - zero_color.b) * value,
		a = zero_color.a + (one_color.a - zero_color.a) * value,
	}
end

function dims(x, y, w, h)
	return { x=x, y=y, w=w, h=h }
end

function dims_center(dims)
	return { x=dims.x + dims.w/2, y=dims.y + dims.h/2 }
end

function dims_bl(dims)
	return { x=dims.x, y=dims.y + dims.h }
end

function text_setup(cairo, size)
	cairo_select_font_face(cairo, "mono", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
	cairo_set_font_size(cairo, size)
end

function text_get_dims(cairo, text)
	local extents = cairo_text_extents_t:create()

	tolua.takeownership(extents)
	cairo_text_extents(cairo, text, extents)

	return {
		x = extents.x_bearing,
		y = extents.y_bearing,
		w = extents.width,
		h = extents.height,
	}
end

function text_center(cairo, pos, text)
	local dims = text_get_dims(cairo, text)

	cairo_move_to(
		cairo,
		dip(pos.x) - (dims.w/2 + dims.x),
		dip(pos.y) - (dims.h/2 + dims.y)
	)
end

function draw_text(cairo, pos, size, color, text)
	text_setup(cairo, size)

	cairo_move_to(cairo, dip(pos.x), size + dip(pos.y))
	cairo_set_source_rgba(cairo, color.r, color.g, color.b, color.a)
	cairo_show_text(cairo, text)
	cairo_stroke(cairo)
end

function draw_text_center(cairo, pos, size, color, text)
	text_setup(cairo, size)
	text_center(cairo, pos, text)

	cairo_set_source_rgba(cairo, color.r, color.g, color.b, color.a)
	cairo_show_text(cairo, text)
	cairo_stroke(cairo)
end

function draw_box(cairo, dims, color)
	cairo_rectangle(cairo, dip(dims.x), dip(dims.y), dip(dims.w), dip(dims.h))
	cairo_set_source_rgba(cairo, color.r, color.g, color.b, color.a)
	cairo_fill(cairo)
end

function cpu_info(cpu)
	return {
		freq = tonumber(conky_parse(string.format('${freq_g %u}', cpu))),
		use = tonumber(conky_parse(string.format('${cpu cpu%u}', cpu))),
		temp = tonumber(conky_parse(string.format('${hwmon 1 temp %u}', cpu))),
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
	local bl = dims_bl(dims)
	local center = dims_center(dims)

	local info = cpu_info(cpu)

	local color = lerp(blue, red, info.use/100)
	draw_box(cairo, dims, color)
	draw_text_center(cairo, { x=center.x, y=center.y - dip(8) }, font_size * 1.5, white, info.use .. '%')
	draw_text_center(cairo, { x=center.x, y=center.y + dip(2) }, font_size, white, info.freq .. ' GHz')
	draw_text_center(cairo, { x=center.x, y=center.y + dip(8) }, font_size, white, info.temp .. ' °C')

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

	local offset = { x=dip(0), y=dip(18) }
	for i=1,config.cpus do
		draw_cpu_tile(cairo, i, offset)
	end

	cairo_surface_destroy(surface)
	cairo_destroy(cairo)
end

