local M = {}

M.options = function()
	local table = {
		"start",
		"stop",
		"continue",
		"cancel",
		"delete",
		"summary",
	}
	return table
end

local function manage(command, par1)
	if par1 and type(par1) == "string" then
		vim.fn.jobstart({ "timew", command, par1 })
	elseif type(par1) == "table" then
		vim.fn.jobstart({ "timew", command, table.unpack(par1) })
	else
		vim.fn.jobstart({ "timew", command })
	end
end

local function get_last_track()
	local output = vim.fn.system("timew")
	local tag = output:match("[^\r\n]+")
	return tag:lower()
end

local function getCount(table)
	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count
end

M.timew_start = function()
	vim.ui.input({ prompt = "task: " }, function(input)
		if input then
			if string.find(input, ",") then
				local tags = {}
				for tag in input:gmatch("[^,]+") do
					table.insert(tags, tag)
				end
				manage("start", tags)
			else
				manage("start", input)
			end
		end
	end)
end

M.timew_cancel = function()
	manage("cancel", nil)
	local recent = get_last_track()
	print("cancelled " .. recent)
end

M.timew_stop = function()
	manage("stop", nil)
	local recent = get_last_track()
	print("stopped " .. recent)
end

M.timew_continue = function()
	manage("continue", nil)
	print("resuming tracking")
end

M.timew_delete = function(opts)
	local sort = ":" .. opts
	local command = { "timew", "summary", ":ids", sort }
	local stuff = {}

	vim.fn.jobstart(command, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if data then
				for _, v in ipairs(data) do
					if v:find("@") then
						local id, rest = v:match("(@%d+) (.*)") -- Extract the number and the rest of the string
						local tag = rest:match("(.-)%s+%d") -- Extract the part before the numbers begin
						local hours = {}
						for time_string in string.gmatch(v, "%S+:%S+:%S+") do
							table.insert(hours, time_string)
						end
						local total_time

						if #hours > 3 then
							total_time = hours[#hours - 1]
						else
							total_time = hours[#hours]
						end
						local entry = id .. "--" .. total_time .. "\t" .. tag
						table.insert(stuff, entry)
					end
				end
				vim.ui.select(stuff, { prompt = "Task to delete?" }, function(choice)
					if choice then
						local id = choice:match("(@%d+)") -- Extract the number and the rest of the string
						manage("delete", id)
					end
				end)
			end
		end,
	})
end

return M
