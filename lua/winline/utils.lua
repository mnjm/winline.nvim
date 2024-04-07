--------------------------------------------------------------------------------------------------
--------------------------------- winline.nvim ---------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Author - mnjm - github.com/mnjm
-- Repo - github.com/mnjm/winline.nvim
-- File - lua/winline/config.lua
-- License - Refer github

local M = {}

-- get count of number of items in table
-- @param tbl input table
-- @return number | number of items in table
M.get_table_len = function(tbl)
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

-- create hightlight groups
-- @param hightlights table
M.setup_highlights = function(highlights)
    if not highlights then return end
    for name, data in pairs(highlights) do
        -- in case if hightligh in default_config has link and migrated to user passed configs
        if data['link'] and M.get_table_len(data) > 1 then data['link'] = nil end
        vim.api.nvim_set_hl(0, name, data)
    end
end

-- dont error out if module not found
-- @param module_name - string module name
-- @return module tbl if found else nil
M.safe_require = function(module_name)
    local status_ok, mod = pcall(require, module_name)
    local ret = status_ok and mod or nil
    return ret
end

-- get icon for file from nvim-web-devicons plugin
-- @param fpath fullpath of the file
-- @return icon if found else "" (empty string)
M.get_icon = function(fpath)
    local file_name, file_ext = vim.fn.fnamemodify(fpath, ":t"), vim.fn.fnamemodify(fpath, ":e")
    local nvim_icons = M.safe_require("nvim-web-devicons")
    local icon = ""
    if nvim_icons then
        icon = nvim_icons.get_icon(file_name, file_ext, { default = true })
    end
    return icon
end

--  check if given window is fixed
--  @param win_id window id
--  @return true if window is fixed
M.is_window_fixed = function(win_id)
    return vim.api.nvim_win_get_config(win_id).relative == ''
end

-- get count of active windows in a given tabpage
-- @param tab_no tabpage ref
-- @return active window count
M.get_active_win_count = function(tab_no)
    if not tab_no then tab_no = 0 end
    local wins = vim.api.nvim_tabpage_list_wins(tab_no) -- get windows in the tabpage tabpage
    -- count fixed (non relative windows)
    local count = 0
    for _, win_id in ipairs(wins) do
        if M.is_window_fixed(win_id) then count = count + 1 end
    end
    return count
end

return M
