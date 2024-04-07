# WinLine.nvim

**Minimal winbar plugin with 
- different colors for active and inactive windows
- icons + close button

![ss](https://github.com/mnjm/github-media-repo/blob/2c134ceca60b81b359f3c40bd8847e4ba2408d19/winline.nvim/ss.png)

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
## Setup
To start winline add below line in your neovim config
```lua
require("winline").setup()
```
### Customization
You can pass custom config to override default configs to setup call, for
```lua
require('winline').setup({
    enable = true,
    always_show = false,
    enable_icons = true,
    close_icon = "󱎘",
    display_buf_no = true,
    seperators = { '',  '' },
})
```
Available configuration options
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
