--------------------------------------------------------------------------------------------------
--------------------------------- winline.nvim ---------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Author - mnjm - github.com/mnjm
-- Repo - github.com/mnjm/winline.nvim
-- File - lua/winline.lua
-- License - Refer github

local M = {}

local config = require('winline.config')
local utils = require('winline.utils')
local sep_m = require('winline.seperators') -- seperators module

-- winbar generator
-- @return winbar string
local generate_winbar = function()
    local winbar = ""
    if M.config.always_show or utils.get_active_win_count() > 1 then -- if more than 1 fixed windows in the current tabpage
        local sep = sep_m.get_seperator("WinLineTitle", "WinLineFill", 1)
        winbar = table.concat({
            "%#WinLineTitle# %<%t%m%r ",
            sep,
            "%#WinLineFill#"
        })
        if M.config.display_buf_no then
            sep = sep_m.get_seperator("WinLineBuf", "WinLineFill", 2)
            winbar = winbar .. table.concat({
                "%=",
                sep,
                "%#WinLineBuf# B:%n ",
            })
        end
    end
    -- set winbar
    vim.opt.winbar = winbar
end

-- create winbar aucmds
-- @params cfg winbar config tbl
local setup_winbar = function()
    local _au = vim.api.nvim_create_augroup('WinLine.nvim', { clear = true })
    -- Winbar
    vim.api.nvim_create_autocmd({'WinEnter', 'WinLeave', 'BufWinEnter', 'BufWinLeave'}, {
        pattern = "*",
        callback = generate_winbar,
        group = _au,
        desc = "Setup winbar statusline",
    })
end

M.setup = function (cfg)
    M.config = config.init_config(cfg)
    -- initialize winline
    -- if not enabled
    if not M.enable then return end
    -- setup highlights
    utils.setup_highlights(cfg.highlights)
    -- initialize seperators
    sep_m.initialize_seperators(cfg.seperators, utils.setup_highlights)
    -- setup winbar
    setup_winbar()

end

return M
