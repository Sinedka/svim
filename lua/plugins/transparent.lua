return {
  "xiyaowong/transparent.nvim",
  config = function()
    require("transparent").setup {
      enable = false,
      auto = true,
      extra_groups = { "BufferLineFill" },
      exclude = {}, -- сюда можно добавить группы, которые не должны быть прозрачными
    }
  end,
}
