-- Shows info about the current activity being tracked

local component = require("lualine.component"):extend()

local function get_status()
	local output = vim.fn.system("timew")
	local lines = {}

	for line in output:gmatch("[^\r\n]+") do
		table.insert(lines, line)
	end

	if #lines > 1 then
		return true
	else
		return false
	end
end

local active_spinner = {
	"   ",
	".  ",
	".. ",
	"...",
}

local inactive_spinner = {
	"󰒲 ",
	"󰚌 ",
}

local function get_tag()
	local output = vim.fn.system("timew")
	local tag, total_time
	local lines = {}

	for line in output:gmatch("[^\r\n]+") do
		table.insert(lines, line)
	end

	if #lines > 1 then
		tag = lines[1]
		if tag:find('"') then
			tag = lines[1]:match('"([^"]*)"')
		else
			tag = lines[1]:match("Tracking%s*(%S+%s*%S+)")
		end

		total_time = lines[4]:match("%d+:%d+:%d+")
		local hours, minutes, seconds = total_time:match("(%d+):(%d+):(%d+)")
		local formatted_time = string.format("%02d:%02d", hours, minutes)
		return " " .. tag .. " - " .. formatted_time
	end
end

local spinner_count = 1

local function get_spinner(spinners, tag)
	local spinner = spinners[spinner_count]
	spinner_count = spinner_count + 1
	if spinner_count > #spinners then
		spinner_count = 1
	end
	return spinner .. "" .. tag
end

local default_options = {
	spinners = false,
}

component.init = function(self, options)
	component.super.init(self, options)
	self.options = vim.tbl_deep_extend("force", default_options, options or {})
end

component.update_status = function(self, options)
	local tag = get_tag()
	if self.options.spinners then
		if get_status() then
			return get_spinner(active_spinner, tag)
		else
			return get_spinner(inactive_spinner, "")
		end
	else
		if get_status() then
			return "" .. tag
		else
			return "󰚌 "
		end
	end
end

return component
