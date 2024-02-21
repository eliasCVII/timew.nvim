local Popup = require("nui.popup")
local NuiText = require("nui.text")
local event = require("nui.utils.autocmd").event

local M = {}

M.timew_popup = function(opts, width, height)
	local sorter = ":" .. opts
	local command = { "timew", "summary", ":ids", sorter }

	vim.api.nvim_set_hl(0, "border", { fg = "#dadada" })
	local popup = Popup({
		position = "50%",
		size = {
			width = width,
			height = height,
		},
		enter = true,
		focusable = true,
		zindex = 50,
		relative = "editor",
		border = {
			padding = {
				top = 1,
				bottom = 1,
				left = 8,
				right = 1,
			},
			style = "rounded",
			text = {
				top = " Summary ",
				top_align = "center",
				bottom_align = "left",
				bottom = NuiText("q <quit>", "Error"),
			},
		},
		buf_options = {
			modifiable = true,
			readonly = false,
		},
		win_options = {
			winblend = 10,
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
		},
	})

	popup.border:set_highlight("border")

	popup:map("n", "q", function()
		popup:unmount()
	end, { noremap = true })

	popup:mount()

	-- unmount component when cursor leaves buffer
	popup:on(event.BufLeave, function()
		popup:unmount()
	end)

	-- Set contents inside buffer
	vim.fn.jobstart(command, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			local to_buf = {}
			if data then
				for _, v in ipairs(data) do
					if v ~= "" then
						table.insert(to_buf, v)
					end
				end
				vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, to_buf)
			end
		end,
	})
end

return M
