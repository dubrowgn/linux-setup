require('config')
require('io')

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

function dip(px)
	return px * config.px_scalar
end

function exec(cmd)
	local pipe = io.popen(cmd)
	stdout = pipe:read('*a')
	pipe:close()

	return stdout
end
