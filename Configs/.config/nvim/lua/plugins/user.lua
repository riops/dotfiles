-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            [[                                                   ]],
            [[                                              ___  ]],
            [[                                           ,o88888 ]],
            [[                                        ,o8888888' ]],
            [[                  ,:o:o:oooo.        ,8O88Pd8888"  ]],
            [[              ,.::.::o:ooooOoOoO. ,oO8O8Pd888'"    ]],
            [[            ,.:.::o:ooOoOoOO8O8OOo.8OOPd8O8O"      ]],
            [[           , ..:.::o:ooOoOOOO8OOOOo.FdO8O8"        ]],
            [[          , ..:.::o:ooOoOO8O888O8O,COCOO"          ]],
            [[         , . ..:.::o:ooOoOOOO8OOOOCOCO"            ]],
            [[          . ..:.::o:ooOoOoOO8O8OCCCC"o             ]],
            [[             . ..:.::o:ooooOoCoCCC"o:o             ]],
            [[             . ..:.::o:o:,cooooCo"oo:o:            ]],
            [[          `   . . ..:.:cocoooo"'o:o:::'            ]],
            [[          .`   . ..::ccccoc"'o:o:o:::'             ]],
            [[         :.:.    ,c:cccc"':.:.:.:.:.'              ]],
            [[       ..:.:"'`::::c:"'..:.:.:.:.:.'               ]],
            [[     ...:.'.:.::::"'    . . . . .'                 ]],
            [[    .. . ....:."' `   .  . . ''                    ]],
            [[  . . . ...."'                                     ]],
            [[  .. . ."'                                         ]],
            [[ .                                                 ]],
            [[                                                   ]],
          }, "\n"),
        },
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        filetypes = {
          tex = true,
          plaintex = true,
          latex = true,
          ["*"] = false,
        },
      }
    end,
  },
  {
    "catppuccin",
    opts = { transparent_background = true },
  },

  {
    "lervag/vimtex",
    config = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_latexmk = {
        builds_dir = "",
        options = {
          "-pdf",
          "-interaction=nonstopmode",
          "-synctex=1",
        },
      }
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          -- show hidden (dot) files
          hide_dotfiles = false,
          -- optionally also show git-ignored files
          hide_gitignored = false,
          -- if you want “filtered” files to just be dimmed instead of removed:
          visible = true,
        },
      },
    },
  },
}
