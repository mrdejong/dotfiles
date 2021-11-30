import {
    // attributes,
    backup,
    command,
    file,
    path,
    prompt,
    // resource,
    skip,
    task,
    variable,
    fail,
    log
} from 'fig';

task('check encrypted files', async () => {
  if (variable('identity') === 'alexander') {
    const result = await command(
      'vendor/git-cipher/bin/git-cipher',
      ['status'],
      {
        failedWhen: () => false,
      }
    );

    if (result !== null) {
      if (result.status !== 0) {
        log.warn(`git-cipher status:\n\n${result.stdout}\n`);

        if (!(await prompt.confirm('Continue anyway'))) {
          fail(`decrypted file check failed`);
        }
      }
    }
    else {
      skip();
    }
  }
});

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

// const FZF_BASE = "pack/bundle/start/fzf";

// task('Install fzf', async () => {
//     const base = resource.file('.config/nvim').join(FZF_BASE);

//     await command('./install', [], {
//         chdir: base,
//         creates: '~/.fzf'
//     });
// });
