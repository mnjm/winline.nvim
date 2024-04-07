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

-- highlight lookup table for active and inactive
local hl_lookup = {
    active = {
        title = "WinLineTitle",
        fill = "WinLineFill",
        buf = "WinLineBuf",
    },
    inactive = {
        title = "WinLineInactiveTitle",
        fill = "WinLineInactiveFill",
        buf = "WinLineInactiveBuf",
    }
}

-- get icon given win id
-- @param win_id - window id
-- @return icon if enabled and available
local get_icon = function (win_id)
    local icon = ""
    if M.config.enable_icons then
        icon = utils.get_icon(vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win_id)))
    end
    return icon
end

-- composes winbar for the given window
-- @param win_id window id
-- @is_cur_wid (boolen) true if window is the focused one
-- @return string | composed winbar
local compose_winbar = function(win_id, is_cur_wid)
    local ret = ""
    local hl = is_cur_wid and hl_lookup.active or hl_lookup.inactive
    local icon = get_icon(win_id)
    ret = table.concat({
        "%#", hl.title, "# ", icon, " %<%t%m%r ", sep_m.get_seperator(hl.title, hl.fill, 1),
    })
    if M.config.display_buf_no then
        ret = table.concat({ ret, "%=", sep_m.get_seperator(hl.buf, hl.fill, 2),
           "%#", hl.buf, "# B:%n " })
    end
    return ret
end

-- generates and registers winbar for all window
local generate_winbar = function()
    local win_id_l = vim.api.nvim_tabpage_list_wins(0)
    local cur_win = vim.api.nvim_tabpage_get_win(0)
    if M.config.always_show or utils.get_active_win_count(0) > 1 then
        for _, win_id in ipairs(win_id_l) do
            if utils.is_window_fixed(win_id) then
                local winbar = compose_winbar(win_id, win_id == cur_win)
                -- set winbar localy
                vim.api.nvim_set_option_value("winbar", winbar, { win = win_id })
            end
        end
    else
        -- clear winbar is there is only onw window in tabpage
        vim.api.nvim_set_option_value("winbar", "", { win = cur_win })
    end
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

-- setup call
M.setup = function (cfg)
    M.config = config.init_config(cfg)
    -- initialize winline
    -- if not enabled
    if not M.config.enable then return end
    -- setup highlights
    utils.setup_highlights(M.config.highlights)
    -- initialize seperators
    sep_m.initialize_seperators(M.config.seperators, utils.setup_highlights)
    -- setup winbar
    setup_winbar()

end

return M
