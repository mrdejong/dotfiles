import { task, skip, backup, variable, file, path } from 'fig';

task('Install awesomewm', async () => {
    skip();
});

task('make directories', async () => {
    await file({ path: '~/.config', state: 'directory' });
    await file({ path: '~/.backups', state: 'directory' });
});

task('move originals to ~/.backups', async() => {
    const files = variable.paths('files');

    for (const file of files) {
        const src = file.strip('.erb');
        await backup({src});
    }
});

task('create symlinks', async () => {
    const files = variable.paths('files');

    for (const src of files) {
        await file({
            force: true,
            path: path.home.join(src),
            src: path.aspect.join('files', src),
            state: 'link'
        });
    }
});
