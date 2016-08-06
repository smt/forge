# Forge

This is a tool to allow for scalable local development for larger teams.

It attempts to solve several problems:

* How do I keep a group of developers in sync?
* How do enable my developers to compile or transpile their code in a codebase that is subject to change at any moment?
* How do I scale my toolchain without having to redo my current toolchain for force developers to learn a new tool?
* How do I handle Developers who don't know their way around a shell?
* How do I minimize the number of commands I must memorize to make my application run?

## Containerization

It's important to mention up-front that Forge is not seeking to replace containerization i.e. Docker, but is intended to complement it. When it comes to env setup and enforcement, containerization is the best solution; but containerization does not solve how to run or develop an application; nor does it deal well with the idiosyncrasies of varying language-based package managers, without resulting to long container initialization times. This is where Forge comes in.

## Install
```
git clone git@github.com:quidmonkey/forge.git ~/.forge && ~/.forge/install
```

## How It Works

What forge does is install a global cmd for every developer to run on their machine, and creates a `.forge/` directory in the project root. Within the `.forge/` is a `tasks/` directory that contains various executable scripts. These scripts can be written in any language, using a `/usr/bin/env` invocation, and can do whatever the project requires. No longer does the project need to be chained to a specific toolchain e.g. `maven` or `gulp`. Forge acts a proxy for these tasks, and acts as a simple interface that only needs to be learned once.

To run a forge task, run:
```script
forge task
```

To run the default task, run:
```script
forge
```

To get help, run:
```script
forge -h
```

To get help for a specific task, run:
```script
forge task -h
```

To list all available forge tasks, run:
```script
forge -t
```

Other commands exist to make the development experience easier. Dig into the forge help cmd to find out more.

## Tasks

Dig into the `tasks/` directory of this repo or a project you installed forge into for examples of how to create your own tasks. To create a task, all that is required is that the task file is added to the `tasks/` directory and includes a `/usr/bin/env` invocation. In addition, it is encouraged that task documentation is added to the task by leaving a multiline comment annotated with `@forge` directives. This documentation is what will be displayed in the terminal when the `forge task -h` cmd is run. See the examples tasks to see how it is done.

## Version Control

One of the central problems of local development is version control. While Forge does not seek to replace containerization, it does seek to keep to complement and simplify the process of version control during development. Forge exposes a `version_control` function that takes two parameters: a file to check for version control and a cmd to execute if the file is stale. Forge handles version control by caching a copy of the file that it is given to version control e.g. package.json or requirements.txt. Each time a version_control is run for the file, Forge checks for an associated file of the same name in its cache, and then it diffs the current file with the cached file. If a difference is found, the associated cmd is executed to bring the file up-to-date, and then the cache is updated with the new file.

If `version_control` is used within a task that a developer runs all the time i.e. the default task, then version control is always exerted on the codebase, and the developer never has to manual check for updates to project dependencies. No more will a developer have to run `npm install` or `pip install` or be told that a new dependency has been added to the codebase. It will all be taken care of seamlessly by forge as it is run.

See the use of `version_control` in the default task and the `version_control.sh` file for more info.

## Closing Remarks

In a nutshell, Forge can be thought of as "the one command to rule them all." Some may argue that they prefer experienced developers to something so simple, but one wonders if they have had the experience of dealing with broken machines on a daily basis, or running a complex set of cmds as a project matures, or having to rewrite the toolchain because the project far out-scaled what was originally envisioned. Forge offers a single interface to gently introduce developers to the cmd line, while offering up the ability for experienced developers to go wild creating tasks and modify Forge to their heart's content (and please submit good ideas as pull requests!).

Forge was created to be infinitely scalable, toolchain agnostic, and one may hope, replace the daily travails of the local development. It was written in Bash, because Bash is the original JavaScript, being ubiquitous, it is fast, and it allows the flexibility to run any script in any language.

Now go out, and Forge!

## Api

```script
debug string
```

Logs a string if `$DEBUG` is set to true by passing the `-d` flag to forge.

```script
error string
```

Logs an error

```script
get_time
```

Get the current timestamp in milliseconds. Be aware that this function can add overhead, especially for MacOS, which does not support millisecond accuracy for the Bash `date` cmd. Or order to achieve millisecond accuracy, MacOS must make calls to a system language. It may be better to invoke forge with the `time` cmd e.g. `time forge`.

```script
is_mac_os
```

Returns true, if the current OS is MacOS; false, otherwise.

```script
list_tasks
```
Lists the available forge tasks in a project.

```script
log string
```

Logs a string.

```script
run_task task options
```

Runs a task of the same name in the `.forge/tasks` directory. Any Bash task will be sourced, allowing access to the forge api. Any non-Bash task will be executed in a sub-shell. All options invoked with Forge will be passed down to the task that is run.

```script
task_usage task
```

Prints the documentation for any forge task that has been annotated using the `@forge` directives.

```script
usage
```

Prints the documentation for forge
