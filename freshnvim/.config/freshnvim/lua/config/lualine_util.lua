---@class lualine_util
local Util = {}

Util.cache = {}
Util.icons = {
  misc = {
    dots = "󰇘",
  },
  ft = {
    octo = "",
  },
  dap = {
    Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected = { " ", "DiagnosticError" },
    LogPoint = ".>",
  },
  diagnostics = {
    Error = " ",
    Warn = " ",

    Hint = " ",

    Info = " ",
  },
  git = {
    added = " ",
    modified = " ",
    removed = " ",
    changedelete = "󱕖 ",
  },
  kinds = {
    Array = " ",

    Boolean = "󰨙 ",
    Class = " ",
    Codeium = "󰘦 ",
    Color = " ",
    Control = " ",
    Collapsed = " ",
    Constant = "󰏿 ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Key = " ",
    Keyword = " ",

    Method = "󰊕 ",
    Module = " ",
    Namespace = "󰦮 ",
    Null = " ",
    Number = "󰎠 ",

    Object = " ",

    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    String = " ",
    Struct = "󰆼 ",

    TabNine = "󰏚 ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",

    Value = " ",

    Variable = "󰀫 ",
  },
}
function Util.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

---@param icon string
---@param status fun(): nil|"ok"|"error"|"pending"
function Util.status(icon, status)
  local colors = {
    ok = "Special",
    error = "DiagnosticError",
    pending = "DiagnosticWarn",
  }
  return {
    function()
      return icon
    end,
    cond = function()
      return status() ~= nil
    end,
    color = function()
      return { fg = Snacks.util.color(colors[status()] or colors.ok) }
    end,
  }
end

---@param name string
---@param icon? string
function Util.cmp_source(name, icon)
  icon = icon or Util.icons.kinds[name:sub(1, 1):upper() .. name:sub(2)]
  local started = false
  return Util.status(icon, function()
    if not package.loaded["cmp"] then
      return
    end
    for _, s in ipairs(require("cmp").core.sources or {}) do
      if s.name == name then
        if s.source:is_available() then
          started = true
        else
          return started and "error" or nil
        end
        if s.status == s.SourceStatus.FETCHING then
          return "pending"
        end
        return "ok"
      end
    end
  end)
end
return Util
