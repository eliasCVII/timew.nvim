local utils = require("timew.utils")

local options = {
	"start",
	"stop",
	"continue",
	"cancel",
	"delete",
}

local M = {}

M.make_command = function()
	-- Menu for timew
	vim.api.nvim_create_user_command("Timew", function(opts)
		local selection = opts.fargs[1]

		-- Begin tracking a new task
		if selection == options[1] then
			utils.timew_start()

		-- Stop/Finish tracking
		elseif selection == options[2] then
			utils.timew_stop()

		-- Continue current tracking
		elseif selection == options[3] then
			utils.timew_continue()

		-- Cancel current tracking
		elseif selection == options[4] then
			utils.timew_cancel()

		-- Delete by id
		elseif selection == options[5] then
			utils.timew_delete()
		end

		--Setup autocompletion when calling the command by the user
	end, {
		nargs = 1,
		complete = function(ArgLead, CmdLine, CursorPos)
			-- return completion candidates as a list-like table
			return options
		end,
	})
end

return M
