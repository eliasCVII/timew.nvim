# timew
timew integration for lualine

## How to install
- using [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
    "eliasCVII/timew.nvim",
    branch = "timew-lualine"
}
```

## Setup
After installing, you can setup your new `timew` component inside your lualine config file, for example:
```lua
-- ... lualine setup
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "filetype" }, 
		lualine_y = { {
		    "timew", -- I used timew here
		    spinners = false -- Spinners behave weird when you are moving around the buffer, but they look cool tho.
		} }, 
		lualine_z = { "location" },
	},
```
