vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- fix notify wining pt 1
vim.opt.termguicolors = true

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- setup noice.nvim
require("noice").setup {
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
}

-- fix notify wining pt 2
require("notify").setup {
  background_colour = "#000000",
}

-- setup mini animate
require("mini.animate").setup()

-- setup nvim-lsputils
if vim.fn.has "nvim-0.5.1" == 1 then
  vim.lsp.handlers["textDocument/codeAction"] = require("lsputil.codeAction").code_action_handler
  vim.lsp.handlers["textDocument/references"] = require("lsputil.locations").references_handler
  vim.lsp.handlers["textDocument/definition"] = require("lsputil.locations").definition_handler
  vim.lsp.handlers["textDocument/declaration"] = require("lsputil.locations").declaration_handler
  vim.lsp.handlers["textDocument/typeDefinition"] = require("lsputil.locations").typeDefinition_handler
  vim.lsp.handlers["textDocument/implementation"] = require("lsputil.locations").implementation_handler
  vim.lsp.handlers["textDocument/documentSymbol"] = require("lsputil.symbols").document_handler
  vim.lsp.handlers["workspace/symbol"] = require("lsputil.symbols").workspace_handler
else
  local bufnr = vim.api.nvim_buf_get_number(0)

  vim.lsp.handlers["textDocument/codeAction"] = function(_, _, actions)
    require("lsputil.codeAction").code_action_handler(nil, actions, nil, nil, nil)
  end

  vim.lsp.handlers["textDocument/references"] = function(_, _, result)
    require("lsputil.locations").references_handler(nil, result, { bufnr = bufnr }, nil)
  end

  vim.lsp.handlers["textDocument/definition"] = function(_, method, result)
    require("lsputil.locations").definition_handler(nil, result, { bufnr = bufnr, method = method }, nil)
  end

  vim.lsp.handlers["textDocument/declaration"] = function(_, method, result)
    require("lsputil.locations").declaration_handler(nil, result, { bufnr = bufnr, method = method }, nil)
  end

  vim.lsp.handlers["textDocument/typeDefinition"] = function(_, method, result)
    require("lsputil.locations").typeDefinition_handler(nil, result, { bufnr = bufnr, method = method }, nil)
  end

  vim.lsp.handlers["textDocument/implementation"] = function(_, method, result)
    require("lsputil.locations").implementation_handler(nil, result, { bufnr = bufnr, method = method }, nil)
  end

  vim.lsp.handlers["textDocument/documentSymbol"] = function(_, _, result, _, bufn)
    require("lsputil.symbols").document_handler(nil, result, { bufnr = bufn }, nil)
  end

  vim.lsp.handlers["textDocument/symbol"] = function(_, _, result, _, bufn)
    require("lsputil.symbols").workspace_handler(nil, result, { bufnr = bufn }, nil)
  end
end

-- setup headlines
require("headlines").setup {
  markdown = {
    query = vim.treesitter.query.parse(
      "markdown",
      [[
                (atx_heading [
                    (atx_h1_marker)
                    (atx_h2_marker)
                    (atx_h3_marker)
                    (atx_h4_marker)
                    (atx_h5_marker)
                    (atx_h6_marker)
                ] @headline)

                (thematic_break) @dash

                (fenced_code_block) @codeblock

                (block_quote_marker) @quote
                (block_quote (paragraph (inline (block_continuation) @quote)))
                (block_quote (paragraph (block_continuation) @quote))
                (block_quote (block_continuation) @quote)
            ]]
    ),
    headline_highlights = { "Headline" },
    bullet_highlights = {
      "@text.title.1.marker.markdown",
      "@text.title.2.marker.markdown",
      "@text.title.3.marker.markdown",
      "@text.title.4.marker.markdown",
      "@text.title.5.marker.markdown",
      "@text.title.6.marker.markdown",
    },
    bullets = { "◉", "○", "✸", "✿" },
    codeblock_highlight = "CodeBlock",
    dash_highlight = "Dash",
    dash_string = "-",
    quote_highlight = "Quote",
    quote_string = "┃",
    fat_headlines = true,
    fat_headline_upper_string = "▃",
    fat_headline_lower_string = "🬂",
  },
  rmd = {
    query = vim.treesitter.query.parse(
      "markdown",
      [[
                (atx_heading [
                    (atx_h1_marker)
                    (atx_h2_marker)
                    (atx_h3_marker)
                    (atx_h4_marker)
                    (atx_h5_marker)
                    (atx_h6_marker)
                ] @headline)

                (thematic_break) @dash

                (fenced_code_block) @codeblock

                (block_quote_marker) @quote
                (block_quote (paragraph (inline (block_continuation) @quote)))
                (block_quote (paragraph (block_continuation) @quote))
                (block_quote (block_continuation) @quote)
            ]]
    ),
    treesitter_language = "markdown",
    headline_highlights = { "Headline" },
    bullet_highlights = {
      "@text.title.1.marker.markdown",
      "@text.title.2.marker.markdown",
      "@text.title.3.marker.markdown",
      "@text.title.4.marker.markdown",
      "@text.title.5.marker.markdown",
      "@text.title.6.marker.markdown",
    },
    bullets = { "◉", "○", "✸", "✿" },
    codeblock_highlight = "CodeBlock",
    dash_highlight = "Dash",
    dash_string = "-",
    quote_highlight = "Quote",
    quote_string = "┃",
    fat_headlines = true,
    fat_headline_upper_string = "▃",
    fat_headline_lower_string = "🬂",
  },
  norg = {
    query = vim.treesitter.query.parse(
      "norg",
      [[
                [
                    (heading1_prefix)
                    (heading2_prefix)
                    (heading3_prefix)
                    (heading4_prefix)
                    (heading5_prefix)
                    (heading6_prefix)
                ] @headline

                (weak_paragraph_delimiter) @dash
                (strong_paragraph_delimiter) @doubledash

                ([(ranged_tag
                    name: (tag_name) @_name
                    (#eq? @_name "code")
                )
                (ranged_verbatim_tag
                    name: (tag_name) @_name
                    (#eq? @_name "code")
                )] @codeblock (#offset! @codeblock 0 0 1 0))

                (quote1_prefix) @quote
            ]]
    ),
    headline_highlights = { "Headline" },
    bullet_highlights = {
      "@neorg.headings.1.prefix",
      "@neorg.headings.2.prefix",
      "@neorg.headings.3.prefix",
      "@neorg.headings.4.prefix",
      "@neorg.headings.5.prefix",
      "@neorg.headings.6.prefix",
    },
    bullets = { "◉", "○", "✸", "✿" },
    codeblock_highlight = "CodeBlock",
    dash_highlight = "Dash",
    dash_string = "-",
    doubledash_highlight = "DoubleDash",
    doubledash_string = "=",
    quote_highlight = "Quote",
    quote_string = "┃",
    fat_headlines = true,
    fat_headline_upper_string = "▃",
    fat_headline_lower_string = "🬂",
  },
  org = {
    query = vim.treesitter.query.parse(
      "org",
      [[
                (headline (stars) @headline)

                (
                    (expr) @dash
                    (#match? @dash "^-----+$")
                )

                (block
                    name: (expr) @_name
                    (#match? @_name "(SRC|src)")
                ) @codeblock

                (paragraph . (expr) @quote
                    (#eq? @quote ">")
                )
            ]]
    ),
    headline_highlights = { "Headline" },
    bullet_highlights = {
      "@org.headline.level1",
      "@org.headline.level2",
      "@org.headline.level3",
      "@org.headline.level4",
      "@org.headline.level5",
      "@org.headline.level6",
      "@org.headline.level7",
      "@org.headline.level8",
    },
    bullets = { "◉", "○", "✸", "✿" },
    codeblock_highlight = "CodeBlock",
    dash_highlight = "Dash",
    dash_string = "-",
    quote_highlight = "Quote",
    quote_string = "┃",
    fat_headlines = true,
    fat_headline_upper_string = "▃",
    fat_headline_lower_string = "🬂",
  },
}

require("astrotheme").setup {
  palette = "astrodark", -- String of the default palette to use when calling `:colorscheme astrotheme`
  background = { -- :h background, palettes to use when using the core vim background colors
    light = "astrolight",
    dark = "astrodark",
  },

  style = {
    transparent = false, -- Bool value, toggles transparency.
    inactive = true, -- Bool value, toggles inactive window color.
    float = true, -- Bool value, toggles floating windows background colors.
    neotree = true, -- Bool value, toggles neo-trees background color.
    border = true, -- Bool value, toggles borders.
    title_invert = true, -- Bool value, swaps text and background colors.
    italic_comments = true, -- Bool value, toggles italic comments.
    simple_syntax_colors = true, -- Bool value, simplifies the amounts of colors used for syntax highlighting.
  },

  termguicolors = true, -- Bool value, toggles if termguicolors are set by AstroTheme.

  terminal_color = true, -- Bool value, toggles if terminal_colors are set by AstroTheme.

  plugin_default = "auto", -- Sets how all plugins will be loaded
  -- "auto": Uses lazy / packer enabled plugins to load highlights.
  -- true: Enables all plugins highlights.
  -- false: Disables all plugins.

  plugins = { -- Allows for individual plugin overrides using plugin name and value from above.
    ["bufferline.nvim"] = false,
  },

  palettes = {
    global = { -- Globally accessible palettes, theme palettes take priority.
      my_grey = "#ebebeb",
      my_color = "#ffffff",
    },
    astrodark = { -- Extend or modify astrodarks palette colors
      ui = {
        red = "#800010", -- Overrides astrodarks red UI color
        accent = "#CC83E3", -- Changes the accent color of astrodark.
      },
      syntax = {
        cyan = "#800010", -- Overrides astrodarks cyan syntax color
        comments = "#CC83E3", -- Overrides astrodarks comment color.
      },
      my_color = "#000000", -- Overrides global.my_color
    },
  },

  highlights = {
    global = { -- Add or modify hl groups globally, theme specific hl groups take priority.
      modify_hl_groups = function(hl, c)
        hl.PluginColor4 = { fg = c.my_grey, bg = c.none }
      end,
      ["@String"] = { fg = "#ff00ff", bg = "NONE" },
    },
    astrodark = {
      -- first parameter is the highlight table and the second parameter is the color palette table
      modify_hl_groups = function(hl, c) -- modify_hl_groups function allows you to modify hl groups,
        hl.Comment.fg = c.my_color
        hl.Comment.italic = true
      end,
      ["@String"] = { fg = "#ff00ff", bg = "NONE" },
    },
  },
}
