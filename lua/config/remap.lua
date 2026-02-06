vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move selected lines in visual mode up or down and reindent
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- paste over selection without taking selection into buffer
vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank selection or line to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- delete without yanking 
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- disables ex mode 
vim.keymap.set("n", "Q", "<nop>")

--format 
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- next/previous quickfix item
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- next/previous locationlist item
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- start replace for word under cursor across file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- souce current file
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
