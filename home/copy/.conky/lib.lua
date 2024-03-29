require('io')
require('math')

function constrain_xy(count, ratio)
	local limit = math.floor(math.sqrt(count))
	local x = count
	local y = 1

	for i=1,limit do
		if count%i == 0 then
			x = count / i
			y = i
			if x/y <= ratio then
				break
			end
		end
	end

	return { x=x, y=y }
end

function exec(cmd)
	local pipe = io.popen(cmd)
	stdout = pipe:read('*a')
	pipe:close()

	return stdout
end

function round(value, places)
	if places == nil then
		places = 0
	end

	local shift = 10 ^ places
	value = value * shift
	value = math.floor(value + 0.5)

	return value / shift
end

function split(str)
	local values = { }

	for v in str:gmatch('%S+') do
		table.insert(values, v)
	end

	return values
end

-- 9pt * 4/3
font_px = 12

-- 3/4 * 1.618 (golden ratio)
line_height = round(1.2135 * font_px)

nproc = tonumber(exec('nproc'))
tile_layout = constrain_xy(nproc, 4)

tiles_width = 360
tile_size = tiles_width / tile_layout.x
tiles_height = tile_size * tile_layout.y

graph_height = 32
graph_width = tiles_width
