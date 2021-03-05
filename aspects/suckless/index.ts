import {
    backup,
    command,
    file,
    path,
    resource,
    task,
    variable
} from 'fig';

task('make directories', async () => {
    await file({path: '~/.suckless', state: 'directory'});
    await file({path: '~/.config', state: 'directory'});
});

task('move originals to ~/.backups', async () => {
    const files = variable.paths('files');

    for (const src of files) {
        await backup({src});
    }
});

task('link files', async () => {
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

async function build(app: string) {
    const base = resource.file('.suckless').join(app);

    await command('make', [], {
        chdir: base
    });
}

task('build dwm', async () => {
    await build('dwm');
});
