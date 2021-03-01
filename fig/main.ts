import * as os from 'os';
import {join} from 'path';

import variables from '../variables.js';
import Context from './Context.js';
import ErrorWithMetadata from './ErrorWithMetadata.js';
import {root} from './index.js';
import {debug, log, setLogLevel} from './console.js';
import dedent from './dedent.js';
import getOptions from './getOptions.js';
import merge from './merge.js';
import path from './path.js';
import prompt from './prompt.js';
import readAspect from './readAspect.js';
import readProject from './readProject.js';
import regExpFromString from './regExpFromString.js';
import stringify from './stringify.js';
import test from './test.js';

import type {Aspect} from './types/Project.js';

async function main() {
    if (Context.attributes.uid === 0) {
        throw new ErrorWithMetadata('Cannot run as root');
    }

    // Skip first two args (node executable and main.js script).
    const options = await getOptions(process.argv.slice(2));

    setLogLevel(options.logLevel);

    debug(() => {
        log.debug('process.argv:\n\n' + stringify(process.argv) + '\n');
        log.debug('getOptions():\n\n' + stringify(options) + '\n');
    });

    if (process.cwd() === root) {
        log.info(`Working from root: ${path(root).simplify}`);
    } else {
        log.notice(`Changing to root: ${path(root).simplify}`);
        process.chdir(root);
    }

    log.info('Running tests');

    await test();

    if (options.testsOnly) {
        return;
    }

    const project = await readProject(join(root, 'project.json'));

    const hostname = os.hostname();

    const profiles = project.profiles ?? {};

    const [profile] =
        Object.entries(profiles).find(([, {pattern}]) =>
            regExpFromString(pattern).test(hostname)
        ) || [];

    log.info(`Profile: ${profile || 'n/a'}`);

    log.debug(`Profiles:\n\n${stringify(profiles)}\n`);

    const profileVariables: {[key: string]: JSONValue} = profile
        ? profiles[profile]!.variables ?? {}
        : {};

    const platform = Context.attributes.platform;

    log.info(`Platform: ${platform}`);

    const {aspects, variables: platformVariables = {}} = project.platforms[
        platform
    ];

    // Register tasks.
    const candidateTasks = [];

    for (const aspect of aspects) {
        await loadAspect(aspect);

        if (options.focused.size && !options.focused.has(aspect)) {
            continue;
        }

        // Check for an exact match of the starting task if `--start-at-task=` was
        // supplied.
        for (const [, name] of Context.tasks.get(aspect)) {
            if (name === options.startAt.literal) {
                options.startAt.found = true;
            } else if (
                !options.startAt.found &&
                options.startAt.fuzzy &&
                options.startAt.fuzzy.test(name)
            ) {
                candidateTasks.push(name);
            }
        }
    }

    if (!options.startAt.found && candidateTasks.length === 1) {
        log.notice(`Matching task found: ${candidateTasks[0]}`);

        log();

        if (await prompt.confirm('Start running at this task')) {
            options.startAt.found = true;
            options.startAt.literal = candidateTasks[0];
        } else {
            throw new ErrorWithMetadata('User aborted');
        }
    } else if (!options.startAt.found && candidateTasks.length > 1) {
        log.notice(`${candidateTasks.length} tasks found:\n`);

        const width = candidateTasks.length.toString().length;

        while (!options.startAt.found) {
            candidateTasks.forEach((name, i) => {
                log(`${(i + 1).toString().padStart(width)}: ${name}`);
            });

            log();

            const reply = await prompt('Start at task number: ');

            const choice = parseInt(reply.trim(), 10);

            if (
                Number.isNaN(choice) ||
                choice < 1 ||
                choice > candidateTasks.length
            ) {
                log.warn(
                    `Invalid choice ${stringify(
                        reply
                    )}; try again or press CTRL-C to abort.`
                );

                log();
            } else {
                options.startAt.found = true;
                options.startAt.literal = candidateTasks[choice - 1];
            }
        }
    } else if (!options.startAt.found && options.startAt.literal) {
        throw new ErrorWithMetadata(
            `Failed to find task matching ${stringify(options.startAt.literal)}`
        );
    }

    const attributeVariables = {
        home: Context.attributes.home,
        platform: Context.attributes.platform,
        username: Context.attributes.username,
    };

    const defaultVariables = project.variables ?? {};

    const baseVariables = merge(
        {profile: profile || null},
        attributeVariables,
        defaultVariables,
        profileVariables,
        platformVariables,
        variables
    );

    // Execute tasks.
    try {
        loopAspects: {
            for (const aspect of aspects) {
                const {variables: aspectVariables = {}} = await readAspect(
                    join(root, 'aspects', aspect)
                );

                if (options.focused.size && !options.focused.has(aspect)) {
                    log.info(`Skipping aspect: ${aspect}`);
                    continue;
                }

                const mergedVariables = merge(baseVariables, aspectVariables);

                const variables = merge(
                    mergedVariables,
                    Context.variables.get(aspect)(mergedVariables)
                );

                log.debug(`Variables:\n\n${stringify(variables)}\n`);

                for (const [callback, name] of Context.tasks.get(aspect)) {
                    if (
                        !options.startAt.found ||
                        name === options.startAt.literal
                    ) {
                        options.startAt.found = false;
                        log.notice(`Task: ${name}`);

                        if (options.step) {
                            for (;;) {
                                const reply = (
                                    await prompt(
                                        `Run task ${name}? [y]es/[n]o/[q]uit]/[c]ontinue/[h]elp: `
                                    )
                                )
                                    .toLowerCase()
                                    .trim();

                                if ('yes'.startsWith(reply)) {
                                    await Context.withContext(
                                        {
                                            aspect,
                                            options,
                                            task: name,
                                            variables,
                                        },
                                        callback
                                    );
                                    break;
                                } else if ('no'.startsWith(reply)) {
                                    Context.informSkipped(`task ${name}`);
                                    break;
                                } else if ('quit'.startsWith(reply)) {
                                    break loopAspects;
                                } else if ('continue'.startsWith(reply)) {
                                    options.step = false;
                                    await Context.withContext(
                                        {
                                            aspect,
                                            options,
                                            task: name,
                                            variables,
                                        },
                                        callback
                                    );
                                    break;
                                } else if ('help'.startsWith(reply)) {
                                    log(
                                        dedent`
                                            [y]es:      run the task
                                            [n]o:       skip the task
                                            [q]uit:     stop running
                                            [c]ontinue: run all remaining tasks
                                        `
                                    );
                                } else {
                                    log.warn('Invalid choice; try again.');
                                }
                            }
                        } else {
                            await Context.withContext(
                                {aspect, options, task: name, variables},
                                callback
                            );
                        }
                    }
                }

                const {callbacks, notifications} = Context.handlers.get(aspect);

                for (const [callback, name] of callbacks) {
                    if (!options.startAt.found) {
                        log.notice(`Handler: ${name}`);

                        if (notifications.has(name)) {
                            if (options.step) {
                                // TODO: DRY up -- almost same as task handling
                                // above
                                for (;;) {
                                    const reply = (
                                        await prompt(
                                            `Run handler ${name}? [y]es/[n]o/[q]uit]/[c]ontinue/[h]elp: `
                                        )
                                    )
                                        .toLowerCase()
                                        .trim();

                                    if ('yes'.startsWith(reply)) {
                                        await Context.withContext(
                                            {
                                                aspect,
                                                options,
                                                task: name,
                                                variables,
                                            },
                                            callback
                                        );
                                        break;
                                    } else if ('no'.startsWith(reply)) {
                                        Context.informSkipped(`task ${name}`);
                                        break;
                                    } else if ('quit'.startsWith(reply)) {
                                        break loopAspects;
                                    } else if ('continue'.startsWith(reply)) {
                                        options.step = false;
                                        await Context.withContext(
                                            {
                                                aspect,
                                                options,
                                                task: name,
                                                variables,
                                            },
                                            callback
                                        );
                                        break;
                                    } else if ('help'.startsWith(reply)) {
                                        log(
                                            dedent`
                                                [y]es:      run the handler
                                                [n]o:       skip the handler
                                                [q]uit:     stop running
                                                [c]ontinue: run all remaining handlers and tasks
                                            `
                                        );
                                    } else {
                                        log.warn('Invalid choice; try again.');
                                    }
                                }
                            } else {
                                await Context.withContext(
                                    {aspect, options, task: name, variables},
                                    callback
                                );
                            }
                        } else {
                            Context.informSkipped(`handler ${name}`);
                        }
                    }
                }
            }
        }
    } finally {
        const counts = Object.entries(Context.counts)
            .map(([name, count]) => {
                return `${name}=${count}`;
            })
            .join(' ');

        log.notice(`Summary: ${counts}`);
    }
}

async function loadAspect(aspect: Aspect): Promise<void> {
    switch (aspect) {
        /* case 'aur': */
        /*     await import('../aspects/aur/index.js'); */
        /*     break; */
        /* case 'automator': */
        /*     await import('../aspects/automator/index.js'); */
        /*     break; */
        /* case 'automount': */
        /*     await import('../aspects/automount/index.js'); */
        /*     break; */
        /* case 'backup': */
        /*     await import('../aspects/backup/index.js'); */
        /*     break; */
        /* case 'cron': */
        /*     await import('../aspects/cron/index.js'); */
        /*     break; */
        /* case 'defaults': */
        /*     await import('../aspects/defaults/index.js'); */
        /*     break; */
        case 'dotfiles':
            await import('../aspects/dotfiles/index.js');
            break;
        /* case 'fonts': */
        /*     await import('../aspects/fonts/index.js'); */
        /*     break; */
        /* case 'homebrew': */
        /*     await import('../aspects/homebrew/index.js'); */
        /*     break; */
        /* case 'interception': */
        /*     await import('../aspects/interception/index.js'); */
        /*     break; */
        /* case 'iterm': */
        /*     await import('../aspects/iterm/index.js'); */
        /*     break; */
        /* case 'karabiner': */
        /*     await import('../aspects/karabiner/index.js'); */
        /*     break; */
        /* case 'launchd': */
        /*     await import('../aspects/launchd/index.js'); */
        /*     break; */
        /* case 'locale': */
        /*     await import('../aspects/locale/index.js'); */
        /*     break; */
        case 'meta':
            await import('../aspects/meta/index.js');
            break;
        /* case 'node': */
        /*     await import('../aspects/node/index.js'); */
        /*     break; */
        /* case 'pacman': */
        /*     await import('../aspects/pacman/index.js'); */
        /*     break; */
        /* case 'ruby': */
        /*     await import('../aspects/ruby/index.js'); */
        /*     break; */
        /* case 'shell': */
        /*     await import('../aspects/shell/index.js'); */
        /*     break; */
        /* case 'ssh': */
        /*     await import('../aspects/ssh/index.js'); */
        /*     break; */
        /* case 'systemd': */
        /*     await import('../aspects/systemd/index.js'); */
        /*     break; */
        /* case 'tampermonkey': */
        /*     await import('../aspects/tampermonkey/index.js'); */
        /*     break; */
        /* case 'terminfo': */
        /*     await import('../aspects/terminfo/index.js'); */
        /*     break; */
        case 'nvim':
            await import('../aspects/nvim/index.js');
            break;
        case 'suckless':
            await import('../aspects/suckless/index.js');
            break;
        default:
            const unreachable: never = aspect;
            throw new Error(`Unreachable ${unreachable}`);
    }
}

main().catch((error) => {
    if (error instanceof ErrorWithMetadata) {
        if (error.metadata) {
            log.error(`${error.message}\n\n${stringify(error.metadata)}\n`);
        } else {
            log.error(error.message);
        }
    } else {
        log.error(error.toString());
    }

    log.debug(String(error.stack));

    process.exit(1);
});
