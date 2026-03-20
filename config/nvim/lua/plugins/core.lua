return {
  -- Neo-tree: file explorer sidebar
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("neo-tree").setup({
        window = {
          width = 35,
        },
        filesystem = {
          follow_current_file = { enabled = true },
        },
      })
      vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { silent = true })
    end,
  },

  -- Telescope: fuzzy navigation/search
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)
      vim.keymap.set("n", "<leader>fh", builtin.help_tags)
    end,
  },

  -- nvim-treesitter: syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "lua", "vim", "markdown", "json", "yaml", "toml",
          "go", "ruby", "python", "javascript", "typescript", "tsx",
          "html", "css",
        },
        highlight = { enable = true },
      })
    end,
  },
}
