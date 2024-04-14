--------------------------------------------------------------------------------------------------
--------------------------------- winline.nvim ---------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Author - mnjm - github.com/mnjm
-- Repo - github.com/mnjm/winline.nvim
-- File - lua/winline/config.lua
-- License - Refer github

local M = {}

-- Additional things to add

local default_config = {
    enable = true,
    enable_icons = false,
    close_icon = "X",           -- "" to disable close button
    display_buf_no = false,     -- add buf no to end of winbar
    always_show = false,        -- if false, will display only when more than 1 window in tabpage
    seperators = { '', '' },
    -- Winbar highlights
    highlights = {
        -- active
        WinLineTitle                = {fg="#282c34", bg="#5fafd7", bold=true },
        WinLineFill                 = {link = 'TabLineFill'},
        WinLineBuf                  = {link = 'TabLineSel'},
        WinLineCloseButton          = {fg="#d70000", bg="#98c379", bold=true},
        -- inative
        WinLineInactiveTitle        = {fg="#282c34", bg="#585858", bold=true },
        WinLineInactiveFill         = {link = 'TabLineFill'},
        WinLineInactiveBuf          = {link = 'TabLine'},
        WinLineInactiveCloseButton  = {fg="#d70000", bg="#444444", bold=true},
    }
}

-- highlight lookup table for active and inactive
M.hl_lookup = {
    active = {
        title = "WinLineTitle",
        fill = "WinLineFill",
        buf = "WinLineBuf",
        close = "WinLineCloseButton",
    },
    inactive = {
        title = "WinLineInactiveTitle",
        fill = "WinLineInactiveFill",
        buf = "WinLineInactiveBuf",
        close = "WinLineInactiveCloseButton",
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
    vim.validate({ close_icon = { cfg.close_icon, "string" }})
    vim.validate({ always_show = { cfg.always_show, "boolean" }})
    vim.validate({ display_buf_no = { cfg.display_buf_no, "boolean" }})
    vim.validate({ enable_icons = { cfg.enable_icons, "boolean" }})
    vim.validate({ seperators = { cfg.seperators, "table" }})
    vim.validate({ highlights = { cfg.highlights, "table" }})
end

-- initialize config
-- @param cfg custom config from setup call
-- @param table | concat of default and custom configs
M.init_config = function(user_cfg)
    -- if not not passed create a empty table
    user_cfg = user_cfg or {}
    vim.validate({ cfg = { user_cfg, 'table' } })
    -- extend default_config and keep the changes from custom config (cfg)
    local config = vim.tbl_deep_extend("keep", user_cfg, default_config)
    if user_cfg.highlights then
        for name, data in pairs(user_cfg.highlights) do
            config.highlights[name] = data
        end
    end
    validate_config(config)

    return config
end

return M
