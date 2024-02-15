-- Shows info about the current task being tracked, and it only shows the first tag if you have multiple ones

local component = require("lualine.component"):extend()

component.init = function(self, options)
	component.super.init(self, options)
end

component.update_status = function(self)
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
			tag = lines[1]:match("Tracking%s*(%S+)")
		end

		total_time = lines[4]:match("%d+:%d+:%d+")
		local hours, minutes, seconds = total_time:match("(%d+):(%d+):(%d+)")
		local formatted_time = string.format("%02d:%02d", hours, minutes)
		return " " .. tag .. " - " .. formatted_time
	else
		local message = "~ 󰚌"
		return message
	end
end

return component
