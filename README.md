# [WinLine.nvim](https://github.com/mnjm/winline.nvim)

**Minimal winbar plugin with**
- Different highlights for active and inactive windows
- Icons and Interactive close button

![demo](https://github.com/mnjm/github-media-repo/blob/main/winline.nvim/demo.gif?raw=true)

**My other plugins**
- [BottomLine.nvim](https://github.com/mnjm/bottomline.nvim) - Statusline plugin
- [TopLine.nvim](https://github.com/mnjm/topline.nvim) - Tabline plugin

***

## Installation

### vim-plug
```vim
Plug 'mnjm/winline.nvim'
" Optional dependency for icons
Plug 'nvim-tree/nvim-web-devicons'
```
### packer.nvim
```lua
use {
    'mnjm/winline.nvim',
    -- optional dependency for icons 
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
}
```
### lazy.nvim
```lua
{
    'mnjm/winline.nvim'
    dependencies = { 'nvim-tree/nvim-web-devicons' }
}
```

***

## Setup
To start winline, add below line in your neovim config
```lua
require("winline").setup()
```
### Customization
You can pass custom config to override default configs to setup call, for ex
```lua
require('winline').setup({
    enable = true,
    always_show = false,
    enable_icons = true,
    close_icon = "󱎘",
    display_buf_no = true,
    -- seperators = { '',  '' },
    seperators = { '',  '' },
})
```
Available default configuration options
```lua
require('winline').setup({
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
})
```

***

![ss](https://github.com/mnjm/github-media-repo/blob/main/winline.nvim/ss.png?raw=true)

***
License MIT
