local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

local function open_terminal(opts)
	local width = 3 * math.ceil(vim.o.columns / 4)
	local height = 3 * math.ceil(vim.o.lines / 4)

	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2.5)

	local winopts = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}

	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	local win = vim.api.nvim_open_win(buf, true, winopts)

	if vim.bo[buf].buftype ~= "terminal" then
		vim.cmd.term()
	end

	return { win = win, buf = buf }
end

vim.api.nvim_create_user_command("Terminal", open_terminal, {})

vim.api.nvim_create_user_command("TerminalToggle", function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = open_terminal({ buf = state.floating.buf })
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end, {})

vim.keymap.set("n", "<leader>t", "<cmd>TerminalToggle<CR>")

return {
	"nvim-telescope/telescope.nvim",
	config = function()
		require("telescope").setup({
			-- Add your telescope configuration here
		})
	end,
}
