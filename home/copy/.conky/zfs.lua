require('io')
require('lib')
require('os')

local cache = { }
local enabled = exec('zpool list -H') ~= ''

local co = nil
if enabled then
	co = coroutine.create(function()
		local pipe = io.popen('sudo zpool iostat -H 1')
		repeat
			line = pipe:read('*l')
			coroutine.yield(line)
		until not line
		pipe:close()
	end)
end

function conky_zfs_query()
	if not enabled then
		return ''
	end

	cache = { }

	local ok, line = coroutine.resume(co)
	local parts = split(line)
	cache[parts[1]] = {
		size = parts[2],
		free = parts[3],
		r_io = parts[4],
		w_io = parts[5],
		r_bw = parts[6],
		w_bw = parts[7],
	}

	-- conky throws a warning unless something is returned
	return ''
end

function zfs_lookup(pool, field)
	return cache[pool] and cache[pool][field] or 0
end

function conky_zfs_iops_read(pool)
	return zfs_lookup(pool, "r_io")
end

function conky_zfs_iops_write(pool)
	return zfs_lookup(pool, "w_io")
end

function conky_zfs_bw_read(pool)
	return zfs_lookup(pool, "r_bw")
end

function conky_zfs_bw_write(pool)
	return zfs_lookup(pool, "w_bw")
end
