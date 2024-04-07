--------------------------------------------------------------------------------------------------
--------------------------------- winline.nvim ---------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Author - mnjm - github.com/mnjm
-- Repo - github.com/mnjm/winline.nvim
-- File - lua/winline/config.lua
-- License - Refer github

local M = {}

-- Additional things to add
-- TODO: Close button
-- TODO: Style = 'l2r', 'c', 'r2l'

local default_config = {
    enable = true,
    enable_icons = false,
    display_buf_no = false,      -- add winbar buffer?
    always_show = false,        -- if false, will display only when more than 1 window in tabpage
    seperators = { '', '' },
    -- Winbar highlights
    highlights = {
        -- active
        WinLineTitle   = {link = 'TabLineSel'},
        WinLineFill    = {link = 'TabLineFill'},
        WinLineBuf     = {link = 'TabLineSel'},
        -- inative
        WinLineInactiveTitle   = {link = 'TabLine'},
        WinLineInactiveFill    = {link = 'TabLineFill'},
        WinLineInactiveBuf     = {link = 'TabLine'},
    }
}

-- winbar config validator
-- @param cfg - cfg to validate
local validate_config = function (cfg)
    cfg = cfg or {}
    vim.validate({ cfg = { cfg, "table" } })
    vim.validate({ enable = { cfg.enable, "boolean" }})
    -- dont bother checking if winbar is disabled
    if not cfg.enable then return end
    vim.validate({ enable_icons = { cfg.enable_icons, "boolean" }})
    vim.validate({ always_show = { cfg.always_show, "boolean" }})
    vim.validate({ display_buf_no = { cfg.display_buf_no, "boolean" }})
    vim.validate({ enable_icons = { cfg.enable_icons, "boolean" }})
    vim.validate({ seperators = { cfg.seperators, "table" }})
    vim.validate({ highlights = { cfg.highlights, "table" }})
end

-- initialize config
-- @param cfg custom config from setup call
-- @param table | concat of default and custom configs
M.init_config = function(cfg)
    -- if not not passed create a empty table
    cfg = cfg or {}
    vim.validate({ cfg = { cfg, 'table' } })
    -- extend default_config and keep the changes from custom config (cfg)
    local config = vim.tbl_deep_extend("keep", cfg, default_config)
    validate_config(config)

    return config
end

return M
