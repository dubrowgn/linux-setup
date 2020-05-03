require('config')
require('io')

function dip(px)
	return px * config.px_scalar
end

function exec(cmd)
	local pipe = io.popen(cmd)
	stdout = pipe:read('*a')
	pipe:close()

	return stdout
end
