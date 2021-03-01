import {
    // attributes,
    backup,
    command,
    file,
    path,
    resource,
    // skip,
    task,
    variable
} from 'fig';

task('make direcotries', async () => {
    await file({path: '~/.backups', state: 'directory'});
    await file({path: '~/.config', state: 'directory'});
});

task('move originals to ~/.backups', async () => {
    const files = variable.paths('files');

    for (const src of files) {
        await backup({src});
    }
});

task('Link files', async () => {
    const files = variable.paths('files');

    for (const src of files) {
        await file({
            force: true,
            path: path.home.join(src),
            src: path.aspect.join('files', src),
            state: "link"
        });
    }
});

const FZF_BASE = "pack/bundle/start/fzf";

task('Install fzf', async () => {
    const base = resource.file('.config/nvim').join(FZF_BASE);

    await command('./install', ['--all'], {
        chdir: base,
        creates: '~/.fzf'
    });
});
