local Table = require('__kry_stdlib__/stdlib/utils/table') -- needed for merge
local module_settings = {"productivity"}
local module_default = "none"
if mods["quality"] then
	table.insert(module_settings,"quality")
	table.insert(module_settings,"both")
	module_default = "quality"
end
table.insert(module_settings,"none")

local base_settings = {
	{
		type = "string-setting",
		name = "rf-balance",
		setting_type = "startup",
		default_value = "vanilla",
		allowed_values = {"vanilla","no balance","user defined"},
		order = "a-b",
		localised_description = {"setting-description.rf-balance"}
	},
	{
		type = "int-setting",
		name = "rf-efficiency",
		setting_type = "startup",
		default_value = 25,
		minimum_value = 1,
		maximum_value = 100,
		order = "a-c"
	},
	{
		type = "bool-setting",
		name = "rf-intermediates",
		setting_type = "startup",
		default_value = true,
		order = "a-d"
	},
	{
		type = "string-setting",
		name = "rf-modules",
		setting_type = "startup",
		default_value = module_default,
		allowed_values = module_settings,
		order = "a-e"
	},
	{
		type = "bool-setting",
		name = "rf-revert-modules",
		setting_type = "startup",
		default_value = false,
		order = "a-f"
	},
	{
		type = "bool-setting",
		name = "rf-autopush",
		setting_type = "runtime-global",
		default_value = true,
		order = "c-a"
	},
	{
		type = "int-setting",
		name = "rf-delay",
		setting_type = "runtime-global",
		default_value = 30,
		minimum_value = 5,
		maximum_value = 300,
		order = "c-b"
	},
	{
		type = "int-setting",
		name = "rf-timer",
		setting_type = "runtime-global",
		default_value = 90,
		minimum_value = 10,
		maximum_value = 600,
		order = "c-c"
	}
}

if mods["space-age"] then
	-- first change description to include planets
	base_settings[1].localised_description = {"setting-description.rf-balance-space-age"}
	-- then merge in the new space age settings
	local space_settings = {
		{
			type = "string-setting",
			name = "rf-craft-limit",
			setting_type = "startup",
			default_value = "nauvis",
			allowed_values = {"nauvis","nauvis, gleba","nauvis, gleba, aquilo", "nauvis, gleba, vulcanus", "nauvis, gleba, aquilo, vulcanus","all planets", "no restrictions"},
			order = "b-a"
		},
		{
			type = "string-setting",
			name = "rf-place-limit",
			setting_type = "startup",
			default_value = "nauvis, gleba, aquilo",
			allowed_values = {"nauvis","nauvis, gleba","nauvis, gleba, aquilo", "nauvis, gleba, vulcanus", "nauvis, gleba, aquilo, vulcanus","all planets", "no restrictions"},
			order = "b-b"
		},
	}
	Table.merge(base_settings,space_settings,true)
end

-- Skip this setting if solid fluids mod was detected (handled from that side instead)
if not mods["kry-solid-fluids"] then
	local additional_settings = {
		{
			type = "bool-setting",
			name = "rf-solid-fluids",
			setting_type = "startup",
			default_value = true,
			order = "a-a-a"
		},
	}
	Table.merge(base_settings,additional_settings,true)
end

-- Add this setting if auto barrel mods are enabled
-- Skip this setting if solid fluids mod was detected (handled from that side instead)
if mods["auto-barrel"] or mods["fct-barreling-machine"] and not mods["kry-solid-fluids"] then
	local additional_settings = {
		{
			type = "bool-setting",
			name = "rf-allow-chemplant",
			setting_type = "startup",
			default_value = false,
			order = "a-a-b"
		},
	}
	Table.merge(base_settings,additional_settings,true)
end

data:extend(base_settings)