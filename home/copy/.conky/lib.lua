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

function round(value)
	return math.floor(value + 0.5)
end

function exec(cmd)
	local pipe = io.popen(cmd)
	stdout = pipe:read('*a')
	pipe:close()

	return stdout
end

function get_gsetting(setting)
	return tonumber(exec('gsettings get ' .. setting .. ' | grep -oE "[0-9]$"'))
end

function get_dpi()
	local default_api = { x=96, y=96 }

	local str = exec('xdpyinfo | grep resolution')
	if (str == "") then
		return default_api
	end

	for x, y in string.gmatch(str, '(%d+)x(%d+)') do
		return { x=x, y=y }
	end

	return default_api
end

dpi = get_dpi()

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
