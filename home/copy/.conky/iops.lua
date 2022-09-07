require('io')
require('lib')
require('os')

local prev_cache = { }
local cache = { }

function conky_iops_query()
	prev_cache = cache
	cache = { ts = os.time(), }

	for line in io.lines('/proc/diskstats') do
		local parts = split(line)

		cache[parts[3]] = {
			r_io = parts[4],
			w_io = parts[8],
		}
	end

	-- conky throws a warning unless something is returned
	return ''
end

function conky_iops_read(disk)
	local now = cache[disk]
	local prev = prev_cache[disk]

	if not now or not prev or cache.ts == prev_cache.ts then
		return 0
	end

	return (now.r_io - prev.r_io) / (cache.ts - prev_cache.ts)
end

function conky_iops_write(disk)
	local now = cache[disk]
	local prev = prev_cache[disk]

	if not now or not prev or cache.ts == prev_cache.ts then
		return 0
	end

	return (now.w_io - prev.w_io) / (cache.ts - prev_cache.ts)
end
