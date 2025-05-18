local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
map("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

map("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "move up in buffer with cursor centered" })

-- search next with cursor centered
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("v", "<S-Tab>", "<gv", opts)
map("v", "<TAB>", ">gv", opts)

-- remember yanked
map("v", "p", '"_dp', opts)

-- leader d delete wont remember as yanked/clipboard when delete pasting
map({ "n", "v" }, "<leader>d", [["_d]])

map("n", "<Esc>", ":nohl<CR>", { desc = "Clear search hl", silent = true })

map("t", "<Esc>", "<c-\\><c-n>")
-- Unmaps Q in normal mode
-- map("n", "Q", "<nop>")

-- prevent x delete from registering when next paste
map("n", "x", '"_x', opts)

-- Replace the word cursor is on globally
map(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word cursor is on globally" }
)

-- Hightlight yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
map("n", "<leader>x", "<cmd>Bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>bc", "<cmd>BufferLinePick<CR>", { desc = "[C]hoose buffer" })
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>", { desc = "Toggle [P]in buffer" })

-- NvimTree float toggle
map("n", "<leader>ee", function()
  require("nvim-tree.api").tree.toggle { float = true }
end, { desc = "Toggle NvimTree float" })
