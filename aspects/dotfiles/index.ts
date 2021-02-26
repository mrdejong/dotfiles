import {
  backup,
  // command,
  // fail,
  file,
  // log,
  path,
  // prompt,
  resource,
  skip,
  template,
  task,
  variable,
  variables
} from 'fig';

variables(({identity}) => ({
  gitUserEmail: identity === 'alexander' ? 'mrdejong89@gmail.com' : '',
  gitUserName: identity === 'alexander' ? 'Alexander de Jong' : '',
  gitHubUsername: identity === 'alexander' ? 'mrdejong' : '',
}));

task('check for descrypted files', async () => {
  skip();
});

task('make directories', async () => {
  await file({path: '~/.backups', state: 'directory'});
  await file({path: '~/.config', state: 'directory'});
  await file({path: '~/.mail', state: 'directory'});
  await file({path: '~/.zshenv.d', state: 'directory'});

  if (variable('identity') === 'alexander') {
    await file({path: '~/projects', state: 'directory'});
  }
});

task('move originals to ~/.backups', async() => {
  const files = [...variable.paths('files'), ...variable.paths('templates')];

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
      state: 'link',
    });
  }
});

task('fill templates', async () => {
  const templates = variable.paths('templates');

  for (const src of templates) {
    await template({
      mode: src.endsWith('.sh.erb') ? '0755' : '0644',
      path: path.home.join(src.strip('.erb')),
      src: path.aspect.join('templates', src),
    });
  }
});

task('create ~/projects/.editorconfig', async () => {
  if (variable('identity') === 'alexander') {
    await template({
      path: '~/projects/.editorconfig',
      src: resource.template('.editorconfig'),
    });
  }
  else {
    skip();
  }
});
