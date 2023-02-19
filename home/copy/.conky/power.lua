require('io')
require('lib')
require('os')

local cache = { }
local cap_hist = { }
local cap_max_age_s = 7

function read_from_micros(path)
	local f = io.open(path)
	local micros = f:read('*n')
	f:close()

	return micros / 1000000
end

function conky_power_query()
	cache = { ts = os.time(), }

	local pow_path = '/sys/class/power_supply'
	local pipe = io.popen('cd ' .. pow_path .. ' && ls -1d BAT*')
	for battery in pipe:lines() do
		local bat_path = pow_path .. '/' .. battery

		local energy_wh = read_from_micros(bat_path .. '/energy_now')
		local capacity_wh = read_from_micros(bat_path .. '/energy_full')
		cache[battery] = {
			capacity_wh = capacity_wh,
			energy_wh = energy_wh,
			level = energy_wh / capacity_wh * 100,
			wear = capacity_wh / read_from_micros(bat_path .. '/energy_full_design') * 100,
			volts = read_from_micros(bat_path .. '/voltage_now'),
		}

		table.insert(cap_hist, {
			ts = cache.ts,
			energy_wh = energy_wh,
		})
		while #cap_hist > 2 and cache.ts - cap_hist[1].ts > cap_max_age_s do
			table.remove(cap_hist, 1)
		end
	end
	pipe:close()

	-- conky throws a warning unless something is returned
	return ''
end

conky_power_query()

function val_fmt(tbl, key)
	if not tbl then
		return 0
	end

	return round(tbl[key], 2)
end

function conky_battery_capacity_wh(battery)
	return val_fmt(cache[battery], 'capacity_wh')
end

function conky_battery_energy_wh(battery)
	return val_fmt(cache[battery], 'energy_wh')
end

function conky_battery_level(battery)
	return val_fmt(cache[battery], 'level')
end

function conky_battery_power_w(battery)
	if #cap_hist < 2 then
		return 0
	end

	local cur = cap_hist[#cap_hist]
	local old = cap_hist[1]

	local wh = cur.energy_wh - old.energy_wh
	local dt = old.ts - cur.ts

	return round(wh * 3600 / dt, 2)
end

function conky_battery_wear(battery)
	return val_fmt(cache[battery], 'wear')
end

function conky_battery_volts(battery)
	return val_fmt(cache[battery], 'volts')
end
