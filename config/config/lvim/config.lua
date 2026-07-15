-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.builtin.telescope.extensions = {
  fzf = {
    fuzzy = true,
    override_generic_sorter = true,
    override_file_sorter = true,
    case_mode = "smart_case",
  }
}

-- lvim.builtin.telescope.active = false

lvim.plugins = {
   {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
  {
    "camspiers/snap",
    config = function()
      local snap = require "snap"
      local layout = snap.get("layout").bottom
      local file = snap.config.file:with { consumer = "fzf", layout = layout }
      local vimgrep = snap.config.vimgrep:with { layout = layout }
      snap.register.command("find_files", file { producer = "ripgrep.file" })
      snap.register.command("buffers", file { producer = "vim.buffer" })
      snap.register.command("oldfiles", file { producer = "vim.oldfile" })
      snap.register.command("live_grep", vimgrep {})
    end,
  },
  {
    "yetone/avante.nvim",
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    opts = {
    },
    config = function()
      require("telescope").load_extension("fzf")
      require('avante').setup({
        instructions_file = "Agent.md",
        provider = "opencode",
        providers = {
          minimax = {
            __inherited_from = "claude",
            endpoint = "https://api.minimaxi.com/anthropic",
            model = "MiniMax-M2.7-highspeed",
            api_key_name = "MINIMAX_KEY",
          },
        },
        acp_providers = {
          opencode = {
            command = "opencode",
            args = { "acp" }
          },
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- 以下依赖项是可选的，
      "echasnovski/mini.pick",         -- 用于文件选择器提供者 mini.pick
      "nvim-telescope/telescope.nvim", -- 用于文件选择器提供者 telescope
      "hrsh7th/nvim-cmp",              -- avante 命令和提及的自动完成
      "ibhagwan/fzf-lua",              -- 用于文件选择器提供者 fzf
      "nvim-tree/nvim-web-devicons",   -- 或 echasnovski/mini.icons
      "zbirenbaum/copilot.lua",        -- 用于 providers='copilot'
      {
        -- 支持图像粘贴
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- 推荐设置
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- Windows 用户必需
            use_absolute_path = true,
          },
        },
      },
      {
        -- 如果您有 lazy=true，请确保正确设置
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "kevinhwang91/rnvimr",
    config = function()
      vim.g.rnvimr_enable_ex = 1
      vim.g.rnvimr_edit_cmd = "drop"
      vim.g.rnvimr_draw_border = 1
      vim.g.rnvimr_hide_gitignore = 0
      vim.g.rnvimr_border_attr = { fg = 14, bg = -1 }
      vim.g.rnvimr_pick_enable = 1
      vim.g.rnvimr_bw_enable = 1
      vim.g.rnvimr_shadow_winblend = 70
      -- vim.g.rnvimr_ranger_cmd = { "ranger", "--cmd=set draw_borders both" }

      vim.api.nvim_set_hl(0, "RnvimrNormal", { link = "CursorLine" })

      vim.keymap.set("n", "<M-o>", ":RnvimrToggle<CR>")
      vim.keymap.set("t", "<M-o>", "<C-\\><C-n>:RnvimrToggle<CR>")

      vim.keymap.set("t", "<M-i>", "<C-\\><C-n>:RnvimrResize<CR>")
      vim.keymap.set("t", "<M-l>", "<C-\\><C-n>:RnvimrResize 1,8,9,11,5<CR>")
      vim.keymap.set("t", "<M-y>", "<C-\\><C-n>:RnvimrResize 6<CR>")

      vim.g.rnvimr_ranger_views = {
        { minwidth = 90, ratio = {} },
        { minwidth = 50, maxwidth = 89, ratio = { 1, 1 } },
        { maxwidth = 49, ratio = { 1 } },
      }
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require('neo-tree').setup({
        close_if_last_window = true,
        window = {
          width = 30,
        },
        buffers = {
          follow_current_file = true,
        },
        filesystem = {
          follow_current_file = true,
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
              "node_modules"
            },
            never_show = {
              ".DS_Store",
              "thumbs.db"
            },
          },
          commands = {
            avante_add_files = function(state)
              local node = state.tree:get_node()
              local filepath = node:get_id()
              local relative_path = require('avante.utils').relative_path(filepath)

              local sidebar = require('avante').get()

              local open = sidebar:is_open()
              -- ensure avante sidebar is open
              if not open then
                require('avante.api').ask()
                sidebar = require('avante').get()
              end

              sidebar.file_selector:add_selected_file(relative_path)

              -- remove neo tree buffer
              if not open then
                sidebar.file_selector:remove_selected_file('neo-tree filesystem [1]')
              end
            end,
          },
          window = {
            mappings = {
              ['oa'] = 'avante_add_files',
            },
          },
        },
      })
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
  {
    "suliatis/Jumppack.nvim",
    config = function()
      require("Jumppack").setup({
        mappings = {
          jump_back = '<C-_>',
          jump_forward = '<C-i>',
        }
      })
    end
  }
}
lvim.builtin.nvimtree.active = false
lvim.builtin.which_key.mappings["e"] = {
  name = "Neotree Explore",
  e = { ":Neotree toggle<CR>", "explore" },
  g = { ":Neotree toggle git_status<CR>", "git status explore" },
  f = { ":Neotree float git_status<CR>", "git status float explore" },
  s = { ":Neotree toggle document_symbols<CR>", "symbols explore" },
  b = { ":Neotree toggle buffers<CR>", "buffers explore" },
}
lvim.builtin.which_key.mappings["gG"] = {
  ":Neotree float git_status<CR>"
}
lvim.builtin.which_key.mappings["ss"] = {
  "<cmd>lua require('spectre').toggle()<CR>", "global search"
}
lvim.builtin.which_key.mappings["sL"] = {
  '<cmd>lua require("spectre").resume_last_search()<CR>', "Search current word"
}
lvim.builtin.which_key.mappings["sw"] = {
  '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', "Search current word"
}
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
  desc = "Search current word"
})
lvim.builtin.which_key.mappings["sS"] = {
  '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', "Search on current file"
}

lvim.builtin.which_key.mappings["gh"] = {
  ':Gitsigns toggle_numhl<CR>', "highlight change"
}
lvim.builtin.which_key.mappings["j"] = {
  name = "Jumppack",
  j = { "<cmd>lua require('Jumppack').start({ offset = -1 })<CR>", "Jump back" },
  i = { "<cmd>lua require('Jumppack').start({ offset = 1 })<CR>", "Jump forward" },
}
-- lvim.builtin.which_key.on_config_done = function()
--   require('which_key').add({
--     {
--       mode = { "n", "v" },
--       { "<C-x>",      group = "Customize" },
--       { "<C-x><C-f>", ":Snap find_files<CR>", desc = "Find file" },
--     },
--   })
-- end
-- which_key
lvim.keys.normal_mode["<C-x><C-f>"] = ":Snap find_files<CR>"
lvim.keys.normal_mode["<leader>yy"] = ":let @+ = expand('%:p') .. ':' .. line('.')<CR>"
