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

-- callback for win close user command
-- @param data from user command - this is assumed to contain win_id in args[1]
local winline_close_win_callback = function(data)
    if utils.get_active_win_count() > 1 then
        local win_id = tonumber(data["fargs"][1])
        vim.api.nvim_win_hide(win_id)
    else
        vim.api.nvim_echo( {"WinLine.nvim: Cannout close last window"}, true )
    end
end

-- setup callbacks - window close click
local setup_close_func = function()
    M.is_tabclick_supported = vim.fn.has('tablinat')
    -- I couldn't find anyway to switch to tab using win_id in vim script, so had to create a user
    -- command and call that with vim script.
    if M.is_tabclick_supported then
        -- vim func
        vim.cmd(
            [[function! WinLineCloseFunc(win_id, clicks, button, mod)
            execute 'WinLineCloseCallUsrCmd' a:win_id
            endfunction]]
        )
        -- User command calling lua callback(?)
        vim.api.nvim_create_user_command('WinLineCloseCallUsrCmd', winline_close_win_callback,
            {nargs = "?", desc = 'Topline,nvim: On click callback user command'})
    end
end

-- composes winbar for the given window
-- @param win_id window id
-- @is_cur_wid (boolen) true if window is the focused one
-- @return string | composed winbar
local compose_winbar = function(win_id, is_cur_wid)
    local ret = ""
    local hl = is_cur_wid and config.hl_lookup.active or config.hl_lookup.inactive
    local icon = get_icon(win_id)
    ret = table.concat({
        "%#", hl.title, "# ", icon, " %<%t%m%r ",
    })
    -- check click support, non empty close icon and check if more than one window active
    if M.is_winclick_support and M.config.close_icon ~= "" and utils.get_active_win_count() > 1 then
        -- add close button
        local close_call =  string.format('%%%d@WinLineCloseFunc@', win_id)
        ret = table.concat({ ret, "%#", hl.close, '# ', close_call, M.config.close_icon, " ",
            sep_m.get_seperator(hl.close, hl.fill, 1),  "%X ",})
    else
        ret = ret .. sep_m.get_seperator(hl.title, hl.fill, 1)
    end
    if M.config.display_buf_no then
        ret = table.concat({ ret, "%=", sep_m.get_seperator(hl.buf, hl.fill, 2),
           "%#", hl.buf, "# B:%n ", })
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
    M.is_winclick_support = vim.fn.has('tablinat')
    local _au = vim.api.nvim_create_augroup('WinLine.nvim', { clear = true })
    -- Winbar
    vim.api.nvim_create_autocmd({'WinEnter', 'WinLeave', 'BufWinEnter', 'BufWinLeave', 'WinResized', 'DirChanged'}, {
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
    -- close button setup
    setup_close_func()
end

return M
