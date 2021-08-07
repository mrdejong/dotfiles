-- local filesystem = require('filesystem')
-- local beautiful  = require('beautiful')

return {
    default = {
        terminal = "alacritty",
        lock = 'slock'
    },
    run_on_start = {
        '~/.config/awesome/autostart.sh'
    }
}
