-- Fold expression called by Neovim for every line when foldmethod=expr.
-- Returns ">1" to start a level-1 fold at H2 headings, ">2" for H3,
-- and "=" elsewhere (inherit the fold level of the previous line).
-- ### is checked before ## so the two-character prefix "## " doesn't
-- accidentally match a three-character "### " heading.
_G._markdown_foldexpr = function()
	local line = vim.fn.getline(vim.v.lnum)
	if line:match("^### ") then return ">2"
	elseif line:match("^## ") then return ">1"
	else return "="
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		-- Use the custom fold expression above instead of indent or syntax folding.
		vim.opt_local.foldmethod = "expr"
		vim.opt_local.foldexpr = "v:lua._markdown_foldexpr()"

		-- Start with everything unfolded. 99 is high enough to exceed any
		-- real heading depth, so no folds are closed on open.
		vim.opt_local.foldlevel = 99

		-- Force Neovim to compute folds for the whole buffer after it finishes
		-- loading. Without this, folds for off-screen lines are evaluated lazily
		-- and may not exist yet when a keymap tries to close them.
		vim.schedule(function() vim.cmd("normal! zX") end)

		-- zk: toggle all H2 sections open/closed.
		-- Uses foldlevel: 0 closes every fold whose level is > 0 (i.e. all H2
		-- and H3 sections). zX re-applies foldlevel without reopening the fold
		-- under the cursor (zx would reopen it, defeating the purpose).
		vim.keymap.set("n", "zk", function()
			if vim.opt_local.foldlevel:get() == 0 then
				vim.opt_local.foldlevel = 99
			else
				vim.opt_local.foldlevel = 0
			end
			vim.cmd("normal! zX")
		end, { buffer = true, desc = "Toggle fold at H2" })

		-- zl: toggle H3 folds within the current H2 section only.
		-- Walks backwards from the cursor to find the enclosing ## heading,
		-- then forwards to find where that section ends (next ## or EOF).
		-- Closes or opens each ### heading in that range individually so other
		-- sections are not affected.
		vim.keymap.set("n", "zl", function()
			local cursor_line = vim.fn.line(".")
			local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

			-- Find the ## heading that contains the cursor.
			local section_start = nil
			for i = cursor_line, 1, -1 do
				if lines[i]:match("^## ") then
					section_start = i
					break
				end
			end
			if not section_start then return end

			-- Find the line before the next ## heading (or end of file).
			local section_end = #lines
			for i = section_start + 1, #lines do
				if lines[i]:match("^## ") then
					section_end = i - 1
					break
				end
			end

			-- Collect all ### heading line numbers within this section.
			local h3_lines = {}
			for i = section_start + 1, section_end do
				if lines[i]:match("^### ") then
					table.insert(h3_lines, i)
				end
			end
			if #h3_lines == 0 then return end

			-- Toggle based on the state of the first H3: if it is open, close
			-- all; if it is already closed, open all. foldclosed() returns -1
			-- when a line is not inside a closed fold.
			local is_open = vim.fn.foldclosed(h3_lines[1]) == -1
			local save_pos = vim.fn.getcurpos()
			for _, lnum in ipairs(h3_lines) do
				vim.fn.cursor(lnum, 1)
				vim.cmd("normal! " .. (is_open and "zc" or "zo"))
			end
			vim.fn.setpos(".", save_pos)
		end, { buffer = true, desc = "Toggle H3 folds in current section" })

		-- zu: unfold everything by setting foldlevel high enough that no fold
		-- qualifies for auto-closing.
		vim.keymap.set("n", "zu", function()
			vim.opt_local.foldlevel = 99
			vim.cmd("normal! zX")
		end, { buffer = true, desc = "Unfold all" })
	end,
})
