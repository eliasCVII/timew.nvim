local M = {}

local function manage(command, par1)
	if par1 then
		vim.fn.jobstart({ "timew", command, par1 })
	else
		vim.fn.jobstart({ "timew", command })
	end
end

M.timew_start = function()
	vim.ui.input({ prompt = "task: " }, function(input)
		manage("start", input)
	end)
end

M.timew_cancel = function()
	manage("cancel", nil)
end

M.timew_stop = function()
	manage("stop", nil)
end

M.timew_continue = function()
	manage("continue", nil)
end

M.timew_delete = function()
	local command = { "timew", "summary", ":ids" }
	local stuff = {}

	vim.fn.jobstart(command, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if data then
				for _, v in ipairs(data) do
					if v:find("@") then
						table.insert(stuff, v)
					end
				end
				table.insert(stuff, 1, "Wk Date       Day ID Tags          Start      End    Time   Total")
				vim.ui.select(stuff, { prompt = "Task to delete?" }, function(choice)
					if choice then
						local id = choice:match("@(%d+) (.*)") -- Extract the number and the rest of the string
						manage("delete", "@" .. id)
						-- call timew delete @{id}
					end
				end)
			end
		end,
	})
end

return M
