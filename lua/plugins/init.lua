return {
  "nvim-lua/plenary.nvim", --lua functions that many plugins use
  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
}
