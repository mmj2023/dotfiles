-- local is_win = function()
--   return vim.uv.os_uname().sysname:find("Windows") ~= nil
-- end

return {
  -- disable builtin snippet support
  { "garymjr/nvim-snippets", enabled = false },
  {
    "L3MON4D3/LuaSnip",
    -- event = {"VeryLazy", "BufRead", "BufNewFile", "BufEnter", "InsertEnter"},
    enabled = true,
    lazy = true,
    -- build = (not vim.uv.os_uname().sysname:find("Windows") ~= nil)
    --     and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
    --   or nil,
    build = (function()
      -- Build Step is needed for regex support in snippets.
      -- This step is not supported in many windows environments.
      -- Remove the below condition to re-enable on windows.
      if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
        return
      end
      return "make install_jsregexp"
    end)(),
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
        end,
      },
    }, -- Make sure LuaSnip is installed
    opts = function(_, opts)
      local ls = require("luasnip")

      -- Add prefix ";" to each one of my snippets using the extend_decorator
      -- I use this in combination with blink.cmp. This way I don't have to use
      -- the transform_items function in blink.cmp that removes the ";" at the
      -- beginning of each snippet. I added this because snippets that start with
      -- a symbol like ```bash aren't having their ";" removed
      -- https://github.com/L3MON4D3/LuaSnip/discussions/895
      -- NOTE: THis extend_decorator works great, but I also tried to add the ";"
      -- prefix to all of the snippets loaded from friendly-snippets, but I was
      -- unable to do so, so I still have to use the transform_items in blink.cmp
      local extend_decorator = require("luasnip.util.extend_decorator")
      -- Create trigger transformation function
      local function auto_semicolon(context)
        if type(context) == "string" then
          return { trig = ";" .. context }
        end
        return vim.tbl_extend("keep", { trig = ";" .. context.trig }, context)
      end
      -- Register and apply decorator properly
      extend_decorator.register(ls.s, {
        arg_indx = 1,
        extend = function(original)
          return auto_semicolon(original)
        end,
      })
      local s = extend_decorator.apply(ls.s, {})

      -- local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node

      local function clipboard()
        return vim.fn.getreg("+")
      end
      -- Path to the text file containing video snippets
      local snippets_file = vim.fn.expand("")

      -- Check if the file exists before proceeding
      if vim.fn.filereadable(snippets_file) == 1 then
        -- Base function to process YouTube snippets with custom formatting
        local function process_youtube_snippets(file_path, format_func)
          local snippets = {}
          local file = io.open(file_path, "r")
          if not file then
            vim.notify("Could not open snippets file: " .. file_path, vim.log.levels.ERROR)
            return snippets
          end
          local lines = {}
          for line in file:lines() do
            if line == "" then
              if #lines == 2 then
                local raw_title, url = lines[1], lines[2]
                -- Removed spaces and any other special characters as I was having
                -- issues triggering the snippets
                local trig_title = raw_title:gsub("[^%w]", "")
                local formatted_content = format_func(trig_title, raw_title, url)
                table.insert(snippets, formatted_content)
              end
              lines = {}
            else
              table.insert(lines, line)
            end
          end
          -- Handle the last snippet if file doesn't end with blank line
          if #lines == 2 then
            local raw_title, url = lines[1], lines[2]
            -- Removed spaces and any other special characters as I was having
            -- issues triggering the snippets
            local trig_title = raw_title:gsub("[^%w]", "")
            local formatted_content = format_func(trig_title, raw_title, url)
            table.insert(snippets, formatted_content)
          end

          file:close()
          return snippets
        end
        -- Format functions for different types of YouTube snippets
        local format_functions = {
          plain = function(trig_title, title, url)
            return s({ trig = "yt" .. trig_title }, { t(title), t({ "", url }) })
          end,

          markdown = function(trig_title, title, url)
            local safe_title = string.gsub(title, "|", "-")
            local markdown_link = string.format("[%s](%s)", safe_title, url)
            return s({ trig = "ytmd" .. trig_title }, { t(markdown_link) })
          end,

          markdown_external = function(trig_title, title, url)
            local safe_title = string.gsub(title, "|", "-")
            local markdown_link = string.format('[%s](%s){:target="_blank"}', safe_title, url)
            return s({ trig = "ytex" .. trig_title }, { t(markdown_link) })
          end,
          -- Extract video ID from URL (everything after the last /)
          embed = function(trig_title, _, url)
            local video_id = url:match(".*/(.*)")
            local embed_code = string.format("{%% include embed/youtube.html id='%s' %%}", video_id)
            return s({ trig = "ytem" .. trig_title }, { t(embed_code) })
          end,
        }
        -- Generate all types of snippets using the base function
        local video_snippets = process_youtube_snippets(snippets_file, format_functions.plain)
        local video_md_snippets = process_youtube_snippets(snippets_file, format_functions.markdown)
        local video_md_snippets_ext = process_youtube_snippets(snippets_file, format_functions.markdown_external)
        local video_snippets_embed = process_youtube_snippets(snippets_file, format_functions.embed)

        -- Add all types of snippets to the "all" filetype
        ls.add_snippets("all", video_snippets)
        ls.add_snippets("all", video_md_snippets)
        ls.add_snippets("all", video_md_snippets_ext)
        ls.add_snippets("all", video_snippets_embed)
      else
        -- vim.notify("YouTube snippets file not found, skipping loading.", vim.log.levels.INFO)
      end
      -- Custom snippets
      -- the "all" after ls.add_snippets("all" is the filetype, you can know a
      -- file filetype with :set ft
      -- Custom snippets

      -- #####################################################################
      --                            Markdown
      -- #####################################################################

      -- Helper function to create code block snippets
      local function create_code_block_snippet(lang)
        return s({
          trig = lang,
          name = "Codeblock",
          desc = lang .. " codeblock",
        }, {
          t({ "```" .. lang, "" }),
          i(1),
          t({ "", "```" }),
        })
      end
      -- Define languages for code blocks
      local languages = {
        "txt",
        "lua",
        "sql",
        "go",
        "regex",
        "bash",
        "markdown",
        "markdown_inline",
        "yaml",
        "json",
        "jsonc",
        "cpp",
        "csv",
        "java",
        "javascript",
        "python",
        "dockerfile",
        "html",
        "css",
        "templ",
        "php",
      }
      -- Generate snippets for all languages
      local snippets = {}

      for _, lang in ipairs(languages) do
        table.insert(snippets, create_code_block_snippet(lang))
      end

      table.insert(
        snippets,
        s({
          trig = "chirpy",
          name = "Disable markdownlint and prettier for chirpy",
          desc = "Disable markdownlint and prettier for chirpy",
        }, {
          t({
            " ",
            "<!-- markdownlint-disable -->",
            "<!-- prettier-ignore-start -->",
            " ",
            "<!-- tip=green, info=blue, warning=yellow, danger=red -->",
            " ",
            "> ",
          }),
          i(1),
          t({
            "",
            "{: .prompt-",
          }),
          -- In case you want to add a default value "tip" here, but I'm having
          -- issues with autosave
          -- i(2, "tip"),
          i(2),
          t({
            " }",
            " ",
            "<!-- prettier-ignore-end -->",
            "<!-- markdownlint-restore -->",
          }),
        })
      )
      table.insert(
        snippets,
        s({
          trig = "markdownlint",
          name = "Add markdownlint disable and restore headings",
          desc = "Add markdownlint disable and restore headings",
        }, {
          t({
            " ",
            "<!-- markdownlint-disable -->",
            " ",
            "> ",
          }),
          i(1),
          t({
            " ",
            " ",
            "<!-- markdownlint-restore -->",
          }),
        })
      )
      table.insert(
        snippets,
        s({
          trig = "prettierignore",
          name = "Add prettier ignore start and end headings",
          desc = "Add prettier ignore start and end headings",
        }, {
          t({
            " ",
            "<!-- prettier-ignore-start -->",
            " ",
            "> ",
          }),
          i(1),
          t({
            " ",
            " ",
            "<!-- prettier-ignore-end -->",
          }),
        })
      )
      table.insert(
        snippets,
        s({
          trig = "linkt",
          name = 'Add this -> [](){:target="_blank"}',
          desc = 'Add this -> [](){:target="_blank"}',
        }, {
          t("["),
          i(1),
          t("]("),
          i(2),
          t('){:target="_blank"}'),
        })
      )
      table.insert(
        snippets,
        s({
          trig = "todo",
          name = "Add TODO: item",
          desc = "Add TODO: item",
        }, {
          t("<!-- TODO: "),
          i(1),
          t(" -->"),
        })
      )

      -- Paste clipboard contents in link section, move cursor to ()
      table.insert(
        snippets,
        s({
          trig = "linkc",
          name = "Paste clipboard as .md link",
          desc = "Paste clipboard as .md link",
        }, {
          t("["),
          i(1),
          t("]("),
          f(clipboard, {}),
          t(")"),
        })
      )
      -- Paste clipboard contents in link section, move cursor to ()
      table.insert(
        snippets,
        s({
          trig = "linkex",
          name = "Paste clipboard as EXT .md link",
          desc = "Paste clipboard as EXT .md link",
        }, {
          t("["),
          i(1),
          t("]("),
          f(clipboard, {}),
          t('){:target="_blank"}'),
        })
      )

      -- Inserting "my dotfiles" link
      table.insert(
        snippets,
        s({
          trig = "dotfileslatest",
          name = "Adds -> [my dotfiles](https://github.com/mmj2023/dotfiles)",
          desc = "Add link to https://github.com/mmj2023/dotfiles",
        }, {
          t("[my dotfiles](https://github.com/mmj2023/dotfiles)"),
        })
      )
      -- table.insert(
      --   snippets,
      --   s({
      --     trig = "supportme",
      --     name = "Inserts links (Ko-fi, Twitter, TikTok)",
      --     desc = "Inserts links (Ko-fi, Twitter, TikTok)",
      --   }, {
      --     t({
      --       "Join discord for free -> https://discord.gg/NgqMgwwtMH",
      --       "If you want to support me by becoming a YouTube member",
      --       "https://www.youtube.com/channel/UCrSIvbFncPSlK6AdwE2QboA/join",
      --       "☕ Support me -> ",
      --       "☑ My Twitter -> ",
      --       "❤‍🔥 My tiktok -> ",
      --       "My dotfiles (remember to star them) -> https://github.com/mmj2023/dotfiles",
      --       "A link to my resume -> ",
      --     }),
      --   })
      -- )
      table.insert(
        snippets,
        s({
          trig = "discord",
          name = "discord support",
          desc = "discord support",
        }, {
          t({
            "```txt",
            "I have a members only discord, it's goal is to troubleshoot stuff related to my videos, and try to help users out",
            "If you want to join, the link can be found below",
            "",
            "```",
          }),
        })
      )
      -- Add a snippet for inserting a blogpost article template
      table.insert(
        snippets,
        s({
          trig = "blogposttemplate",
          name = "Insert blog post template",
          desc = "Insert blog post template with frontmatter and sections",
        }, {
          t({ "---", "title: " }),
          i(1, ""),
          t({ "", "description: " }),
          i(2, ""),
          t({
            "",
            "image:",
            "  path: ./../../assets/img/imgs/250117-thux-simple-bar-sketchybar.avif",
            "date: '2025-01-16 06:10:00 +0000'",
            "categories:",
            "tags:",
            "  - linux",
            "  - tutorial",
            "  - youtube",
            "  - video",
            "---",
            "## Contents",
            "",
            "### Table of contents",
            "",
            "<!-- toc -->",
            "",
            "<!-- tocstop -->",
            "",
            "## YouTube video",
            "",
            "{% include embed/youtube.html id='' %}",
            "",
            "## Pre-requisites",
            "",
            "- List any here",
            "",
            "## If you like my content, and want to support me",
            "",
            "- I create and edit my videos in an [], and it's starting to stay",
            "  behind in the editing side of things, tends to slow me down a bit, I'd like to",
            "  upgrade the machine I use for all my videos to a `mac mini` with these specs:",
            "  - [] CPU, [] GPU, [] Neural Engine",
            "  - []GB unified memory",
            "  - []TB SSD storage",
            "  - [] Gigabit Ethernet",
            "- If you want to help me reach my goal, you can",
            '  [donate here](){:target="_blank"}',
            "",
            '[![Image](){: width="300" }](){:target="_blank"}',
            "",
            "## Discord server",
            "",
            "- My discord server is now open to the public, feel free to join and hang out with others",
            '- join the [discord server in this link](){:target="_blank"}',
            "",
            '[![Image](){: width="300" }](){:target="_blank"}',
            "",
            "## Follow me on social media",
            "",
            '- [Twitter (or "X")](){:target="_blank"}',
            '- [LinkedIn](){:target="_blank"}',
            '- [TikTok](){:target="_blank"}',
            '- [Instagram](){:target="_blank"}',
            '- [GitHub](https://github.com/mmj2023){:target="_blank"}',
            '- [Threads](){:target="_blank"}',
            '- [OnlyFans 🍆](){:target="_blank"}',
            '- [YouTube (subscribe MF, subscribe)](){:target="_blank"}',
            '- [Ko-Fi](){:target="_blank"}',
            "",
            "## All links in the video description",
            "",
            "- The following links will be in the YouTube video description:",
            "  - Each one of the videos shown",
            "  - A link to this blogpost",
            "",
            "## How do you manage your passwords?",
            "",
            "",
            "- You want to find out why? More info in my article:",
            "",
            "",
            "",
            "",
            "## bottom banner",
            "",
            "---",
            "",
            "",
            "",
            "",
            "",
          }),
        })
      )
      -- Add a snippet for inserting a video markdown template
      table.insert(
        snippets,
        s({
          trig = "videotemplate",
          name = "Insert video markdown template",
          desc = "Insert video markdown template",
        }, {
          t("## "),
          i(1, "cursor"),
          t(" video"),
          t({ "", "", "All of the details and the demo are covered in the video:", "" }),
          t({ "", "If you don't like watching videos, the keymaps are in " }),
          t("[my dotfiles](https://github.com/mmj2023/dotfiles)"),
          t({
            "",
            "",
            "```txt",
            "discord",
            "",
            "",
            "If you find this video helpful and want to support me",
            "",
            "",
            "Follow me on twitter",
            "",
            "",
            "My dotfiles (remember to star them)",
            "https://github.com/mmj2023/dotfiles",
            "",
            "Videos mentioned in this video:",
            "",
            "mmj",
            "",
            "1:00 - VIDEO video 1",
            "2:00 - VIDEO video 2",
            "```",
            "",
            "Video timeline:",
            "",
            "```txt",
            "0:00 -",
            "```",
            "",
            "```txt",
            "Join discord for free -> ",
            "If you want to support me by becoming a YouTube member",
            "https://www.youtube.com/channel/UCrSIvbFncPSlK6AdwE2QboA/join",
            "☕ Support me -> ",
            "☑ My Twitter -> ",
            "❤‍🔥 My tiktok -> ",
            "My dotfiles (remember to star them) -> https://github.com/mmj2023/dotfiles",
            "A link to my resume -> ",
            "```",
            "",
          }),
        })
      )

      table.insert(
        snippets,
        s({
          trig = "video-skitty",
          name = "New video in skitty-notes",
          desc = "New video in skitty-notes",
        }, {
          t("## "),
          i(1, "video name"),
          t({
            "",
            "",
            "- [ ] ",
          }),
          i(2, ""), -- This is now the second jump point
          t({
            "",
            "- [ ] **Thank supporters**",
            "- [ ] Push GitHub changes",
            "- [ ] Share discord server",
            "",
          }),
        })
      )
      -- Basic bash script template
      table.insert(
        snippets,
        s({
          trig = "bashex",
          name = "Basic bash script example",
          desc = "Simple bash script template",
        }, {
          t({
            "```bash",
            "#!/bin/bash",
            "",
            "echo 'helix'",
            "echo 'deeznuts'",
            "```",
            "",
          }),
        })
      )
      -- Basic Python script template
      table.insert(
        snippets,
        s({
          trig = "pythonex",
          name = "Basic Python script example",
          desc = "Simple Python script template",
        }, {
          t({
            "```python",
            "#!/usr/bin/env python3",
            "",
            "def main():",
            "    print('helix dizpython')",
            "",
            "if __name__ == '__main__':",
            "    main()",
            "```",
            "",
          }),
        })
      )
      ls.add_snippets("markdown", snippets)

      -- #####################################################################
      --                         all the filetypes
      -- #####################################################################
      ls.add_snippets("all", {
        s({
          trig = "workflow",
          name = "Add this -> lamw26wmal",
          desc = "Add this -> lamw26wmal",
        }, {
          t("lamw26wmal"),
        }),

        s({
          trig = "lam",
          name = "Add this -> lamw26wmal",
          desc = "Add this -> lamw26wmal",
        }, {
          t("lamw26wmal"),
        }),

        s({
          trig = "mw25",
          name = "Add this -> lamw26wmal",
          desc = "Add this -> lamw26wmal",
        }, {
          t("lamw26wmal"),
        }),
      })
      -- opts.history = true
      -- opts.delete_check_events = "TextChanged"
      return opts
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },
}
