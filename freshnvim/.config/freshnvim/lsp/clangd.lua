-- vim.lsp.config.clangd = {
--   cmd = {
--     "clangd",
--     "--clang-tidy",
--     "--background-index",
--     "--offset-encoding=utf-8",
--   },
--   root_markers = { ".clangd", "compile_commands.json" },
--   filetypes = { "c", "cpp", "objc", "objcpp" },
--   single_file_support = true,
--   root_dir = vim.fs.find({ ".git" }, { upward = true })[1] or vim.loop.cwd(),
--   init_options = {
--     fallbackFlags = { "--std=c23" },
--   },
-- }
return {
  cmd = {
    "clangd",
    "--clang-tidy",
    "--background-index",
    "--offset-encoding=utf-8",
  },
  root_markers = { ".clangd", "compile_commands.json" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  single_file_support = true,
  root_dir = vim.fs.find({ ".git" }, { upward = true })[1] or vim.loop.cwd(),
  init_options = {
    fallbackFlags = { "--std=c23" },
  },
}
-- }
-- vim.lsp.enable("clangd")
