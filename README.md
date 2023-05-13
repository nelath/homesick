# homesick

This repo is a clone of https://github.com/andsens/homesick that has been simplified to
support only zsh and bash and has been renamed to homesick again and extended to support
bootstrapping scripts as part of the first install.

By the power of git, homesick enables you to synchronize dotfiles across computers.

However bare bones these machines are, provided that at least Bash 3 and Git 1.5 are available you can use homesick.
homesick can handle multiple dotfile repositories. This means that you can install
larger frameworks like [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
or a multitude of emacs or vim plugins alongside your own customizations without clutter.

## Quick install

homesick is installed to your own home directory and does not require root privileges to be installed.
```sh
git clone https://github.com/michaelrommel/homesick.git $HOME/.homesick/repos/homesick
```

To invoke homesick, source the `homesick.sh` script from your rc-script:
```sh
# from sh and its derivates (bash, dash, ksh, zsh etc.)
printf '\nsource "$HOME/.homesick/repos/homesick/homesick.sh"' >> $HOME/.bashrc
```

## Completion ##

homesick comes with its own tab completion scripts. There are scripts for bash and zsh.
They allow you to tab complete all available commands and supply you with possible castle names.
[[tab-completion.gif]]

### Bash completion ###
To get tab completion working in bash, simply source
`completions/homesick-completion.bash` somewhere in your `.bashrc`.
```sh
printf '\nsource "$HOME/.homesick/repos/homesick/completions/homesick-completion.bash"' >> $HOME/.bashrc
```

### ZSH completion ###
ZSH autoloads its completion scripts.
In order for ZSH to know that there exists a homesick completion script
you have to add the `homesick/completions` directory to the ZSH tab completion
lookup path.
```sh
printf '\nfpath=($HOME/.homesick/repos/homesick/completions $fpath)' >> $HOME/.zshrc
```

***NOTE***: you may need to ensure that this line comes *before* the `compinit` line. If you are using `oh-my-zsh`, the homesick `fpath` modification may need to come *before* sourcing `oh-my-zsh`. For example:

```zsh
source "$HOME/.homesick/repos/homesick/homesick.sh"
fpath=($HOME/.homesick/repos/homesick/completions $fpath)

source $ZSH/oh-my-zsh.sh
```

## Commands

homesick is used via subcommands, so simply typing `homesick` will yield a helpful message
that tersely explains all of the things you can do with it.

Most subcommands accept castlenames as arguments.
You can also run a subcommand on all castles by not specifying any arguments.

### link ###

`homesick link [castlename ...]`

This command symlinks all files that reside in the `home` folders of your
castles into your home folder. Note that only files tracked by git will be
linked, untracked files are ignored.
You will be prompted if there are any files or folders that would be overwritten.

If the castle does not contain a home folder it will simply be ignored.
To further understand how the linking process works you can consult the
[linking table](Symlinking#linking-table).

### clone ###

`homesick clone URI..`

The `clone` command clones a new git repository to `.homesick/repos`.
The clone command accepts a github shorthand url, so if you want to clone
oh-my-zsh you can type `homesick clone robbyrussell/oh-my-zsh`.

### pull ###

`homesick pull [castlename ...]`

The `pull` command runs a `git pull` on your castle and any of its submodules.
If there are any new dotfiles to be linked, homesick will prompt you whether you want to link them.

### check ###

`homesick check [castlename ...]`

`check` determines the state of a castle.
* There may be updates on the remote, meaning it is *behind*.
* Your castle can also contain unpushed commits, meaning it is *ahead*.
* When everything is in sync, `check` will report that your castle is *up to date*.

### list ###

`homesick list`

You can see your installed castles by running the `list` command.

### track ###

`homesick track castlename .file [.folder ...]`

If you have a new dotfile or folder that you want to put in one of your castles, you can ask
homesick to do the moving, symlinking and git-adding for you.
To track your `.bashrc` and `.zshrc` in your `dotfiles` castle
run `homesick track dotfiles .bashrc .zshrc`,
the files are automatically added to the git index.
Alternatively you may want to track an entire folder like your vim configuration,
when given a path to a folder homesick will traverse the entire structure
and track all the files contained within:
`homesick track dotfiles .vimrc .vim`
Any files that would be git-ignored by the castle will be left untouched.

### generate ###

`homesick generate castlename [castlename2 ...]`

`generate` creates a new castle.
All you need to do now is call [`track`](Commands#track) to fill it with your dotfiles.

### refresh ###

`homesick refresh`

Run this command to check if any of your repositories have not been updated the last week.
This goes very well with your rc scripts (check out the [tutorial](Tutorials#refreshing) for more about this).

### cd ###

`homesick cd castlename`

After you have used the [`track`](Commands#track) command, you will want to commit the changes and push them.
Instead of `cd`'ing your way into the repository simply type `homesick cd dotfiles`;
homesick will place you right inside the `home/` directory of your `dotfiles` castle.
From there you can run whatever git commands you like on your castle.

*Tip: `cd -` places you in your previous directory, so if you did not change directories
after running `homesick cd dotfiles` you can simply type `cd -` to get back to where you left off.*


## Switches ##
homesick has commandline switches that can automate some of its actions or modify its output.
Their applicability is not enforced despite the fact that some only work on specific commands.

### quiet ###
The `--quiet` flag (shorthand: `-q`) suppresses all status output except when input is required.

### skip ###
When running `homesick link`, the `--skip` flag (shorthand: `-s`) causes the command
to automatically not overwrite files in your `$HOME` that conflict with files in your castles.

### force ###
`--force` (shorthand: `-f`) will cause homesick to overwrite any conflicting files in your `$HOME` when
symlinking with `homesick link` and any conflicting files in your castle when running `homesick track`.

### batch ###
When integrating homesick with other scripts you can use `--batch` (shorthand: `-b`)
to avoid any interactive prompts. homesick will instead pick the defaults.
You can combine this switch with the other switches to e.g. overwrite all conflicting files in `$HOME`.


## Bootstrapping ##

In the Installation, you added a `homesick` alias to your `.bashrc` file.

Let's create your first castle to hold this file. You use the [`generate`](Commands#generate) command to do that:

```
homesick generate dotfiles
```

This creates an empty castle, which you can now populate.

Put the `.bashrc` file into your `dotfiles` castle with:

```
homesick track dotfiles .bashrc
```
*Be aware that your file has now been moved into the castle and a symlink to it has been created in its stead. So any modifications to your `dotfiles` repo will directly affect your dotfiles.*

Let's now enter the castle, commit the changes, add your github remote and push to it.
```sh
homesick cd dotfiles
git commit -m "Initial commit, add .bashrc"
git remote add origin git@github.com:username/dotfiles.git
git push -u origin master
cd -
```
*Note: The `.homesick/` folder is not a typo, it is named as such because of compatibility with
[homesick](homesick-and-homesick), the ruby tool that inspired homesick*

## Adding other machines ##
To get your custom `.bashrc` file onto other machines you [install homesick](Installation) and
[`clone`](Commands#clone) your castle with:
```
$HOME/.homesick/repos/homesick/bin/homesick clone username/dotfiles
```
homesick will ask you immediately whether you want to symlink the newly cloned castle.
If you agree to that and also agree to it overwriting the existing `.bashrc` you can run
`source $HOME/.bashrc` to get your `homesick` alias running.

## Refreshing ##
You can run [`check`](Commands#check) to see whether your castles are up to date or need pushing/pulling.
This is a task that is easy to forget, which is why homesick has the [`refresh`](Commands#refresh) subcommand.
It examines your castles to see when they were pulled the last time and prompts you to pull
any castles that have not been pulled over the last week.
You can put this into your `.bashrc` file to run the check everytime you start up the shell:
`printf '\nhomesick --quiet refresh' >> $HOME/.bashrc`.
*(The `--quiet` flag makes sure your terminal is not spammed with status info on every startup)*

If you prefer to update your dotfiles every other day, simply run `homesick refresh 2` instead.

## Updating your castle ##
To make changes to one of your castles you simply use git.
For example, if you want to update your `dotfiles` castle
on a machine where you have a nice tmux configuration:

```sh
homesick track dotfiles .tmux.conf
homesick cd dotfiles
git commit -m "Added awesome tmux configuration"
git push origin master
cd -
```

## Dealing with automated config files ##
There are times when some programs attempt to auto generate / save config files and in so doing will overwrite the symbolic link that homesick creates. This means files that were tracked become untracked and attempts to re-link result in either overwriting your changes or staying untracked. The most common culprit are programs that offer an internal method for making and saving config changes.

I'll show you how to diagnose such a situation and then how to fix it. For this tutorial I will use the [tin news reader](http://www.tin.org/) as the sample program. Tin uses the following directory structure for its config:

```
~/.tin
├── attributes
├── filter
├── news.example.com
│   ├── newsgroups
│   └── serverrc
├── posted
└── tinrc
```

The actual configuration variables are stored in `tinrc` and the rest are caches and other runtime files. So we need homesick to track `~/.tin/tinrc`. If you run a `homesick track myCastle ~/.tin/tinrc` then it will create the following:

```
~/.homesick/repos/myCastle/home
└── .tin
    └── tinrc

~/.tin
├── attributes
├── filter
├── news.example.com
│   ├── newsgroups
│   └── serverrc
├── posted
└── tinrc@ -> ../.homesick/repos/myCastle/home/.tin/tinrc
```

Normally this is what we want but the next time we quit tin it will delete `~/.tin/tinrc` and recreate it losing the symlink. To verify this is the case do an `ls -la ~/.tin` and you'll see the symlink missing. You will also experience homesick complaining next time you do a **link** command.

To fix this we have to use the [shallow symlink](Symlinking#shallow-symlinking) trick. However we need to prevent homesick from tracking all the caches and temp files.

1. Remove the bad tracking file/directory.
2. Move the original config directory (temp files and all) into a custom directory in the *myCastle* repo.
3. Add a `.gitignore` file to ignore everything but the wanted files.
4. Add a symlink from home to the custom directory in the same repo.
5. Save to git.
6. Run `homesick link` to finish the setup.

```console
~ $ homesick cd myCastle
~/.homesick/repos/myCastle $ git rm -r home/.tin             # Step 1
~/.homesick/repos/myCastle $ mkdir dotdirs
~/.homesick/repos/myCastle $ mv ~/.tin dotdirs/              # Step 2
~/.homesick/repos/myCastle $ nano dotdirs/.tin/.gitignore    # Step 3
```
```gitignore
# .gitignore contents:
*            # Ignore everything...
!.gitignore  # Except .gitignore
!tinrc       # Except tinrc
```
```console
~/.homesick/repos/myCastle $ ln -s dotdirs/.tin home/.tin # Step 4
~/.homesick/repos/myCastle $ git add dotdirs/.tin home/.tin
~/.homesick/repos/myCastle $ git commit                      # Step 5
~/.homesick/repos/myCastle $ homesick link                  # Step 6
```

## Symlinking: Linking table ##

homesick does not blindly symlink everything,
instead it uses a carefully crafted linking strategy to achieve a high level
of flexibility without resorting to configuration files.

The table below shows how homesick decides what to do in different situations.

`$HOME`/castle            | directory      | not directory
--------------------------|----------------|--------------
**nonexistent**           | `mkdir`        | `link`
**symlink to castle**     | `rm! && mkdir` | `identical`
**file/symlinked file**   | `rm? && mkdir` | `rm? && link`
**directory**             | `identical`    | `rm? && link`
**directory (symlink)**   | `identical`    | `rm? && link`

### Explanation ###
homesick traverses through all *resources* (files, folders and symlinks),
that reside under the `home/` folder of a castle in a depth-first manner.
Symlinks in the castle are not followed.
Conversely: if `$HOME` contains a directory symlink that matches a normal
directory in the castle it will be followed.
The table is consulted for each *resource* that is encountered.
Files or directories that are not tracked by git are ignored and not traversed.

The columns **directory** and **not directory** represent the resource in the castle.
The rows represent what resource is found at the corresponding location in the actual `$HOME` directory.

In the castle, **directory** is a simple directory (and not a symlink to a directory),
while **not directory** is everything that is not the former (so: files, symlinked files, and symlinked directories).

The *resources* that can be encounter in the `$HOME` directory are categorized as follows:
* **nonexistent** means that the corresponding *resource* in the `$HOME` folder does not exist.
* **symlink to castle** represents a symlink to the current *resource*
* **file/symlinked file** is a symlink to anything *but* the current *resource*
* **directory** is a regular directory
* **directory (symlink)** is a symlinked directory (but not to the castle)

The actions that can be taken always refer to the `$HOME` directory. A `&&` means that the second action is only executed if the first one was executed as well.
* `identical`: Do not do anything, resources are identical
* `mkdir`: Create the directory
* `link`: Create a symlink to the resource in the castle
* `rm!`: Delete without prompting (this is only done for legacy directory symlinks)
* `rm?`: Prompt whether the user wants to overwrite the resource
         (`--skip` answers "no" to this, while `--force` does the opposite. `--batch` selects the default, which is "no")

## Combining directories ##

As you can see in the [linking table](Symlinking#linking-table),
every folder that is encountered in the castle is replicated in `$HOME`.
This allows you to combine multiple castles into one directory structure.

Say you have two vim plugins in different castles:
* Castle 1: `home/.vim/bundle/vim-colors-solarized`
* Castle 2: `home/.vim/bundle/vim-git`

When homesick symlinks castle 1, it will create the directory structure `home/.vim/bundle/vim-colors-solarized` (and symlink whatever files are in that folder).
Upon encountering castle 2, homesick sees the folders `home/.vim/bundle/` and considers them `identical`.
It then creates the directory `vim-git` inside `home/.vim/bundle/` and goes on with symlinking the `vim-git` plugin files.

## Repos with no home directory ##
What do you do if you encounter a really cool repository that goes well with
your existing setup, but it has no `home/` folder and needs to be linked to a
very specific place in your `$HOME` folder?

Let's say you want to add [vundle](https://github.com/gmarik/vundle) to your Vim configuration.
The documentation says it needs to be installed to `~/.vim/bundle/vundle`, but you are not
very interested in forking the repository solely for the purpose of changing the directory layout
so that all files are placed four directories deeper in `home/.vim/bundle/vundle/`.

homesick can solve this problem in two ways:

1. Add vundle as a submodule to your dotfiles. This is definitely the quick and easy way.

        homesick cd dotfiles
        git submodule add https://github.com/gmarik/vundle.git home/.vim/bundle/Vundle.vim
2. Clone vundle with homesick and symlink to the repo from the appropriate folder in your dotfiles:

        homesick clone gmarik/vundle
        cd ~/.homesick/repos/dotfiles/home
        mkdir .vim/bundle
        cd .vim/bundle
        ln -s ../../../../vundle vundle # symlink to the location of the cloned vundle repository
        homesick link dotfiles

We use a relative path for the symlink in case we log in with different username on other machines.
When running the [`link`](Commands#link) command, homesick will create a symlink at `~/.vim/bundle/vundle`
pointing at the symlink we just created. This means there will be a symlinked directory at
`~/.vim/bundle/vundle`, which contains the files of the cloned vundle repository
*Note: You can see how homesick decides what to do when encountering different symlink situations
by looking at the [linking table](Symlinking#linking-table).*

The advantage of the second option is that you have more finegrained control over your repositories
and can manage each of them individually
(e.g. you want to [`refresh`](Commands#refresh) your own dotfiles every week,
but you don't want to wait for all the submodules in your repository to refresh as well).

The downside of not using submodules is that you will need to add the additional repositories
with `homesick clone` on every machine.
However, you can use the [automatic deployment](Automatic-deployment) script to avoid having
to do this manually.


## Shallow symlinking ##

Since homesick traverses into the directories of your `home/` folder,
it may encounter quite a lot of files that need symlinking.
In many scenarios this is desirable (e.g. when [combining directories](Symlinking#combining-directories)).
Some directories however may have a huge configuration setup with a lot of files.
Traversing and symlinking these files can take a little while and you may have no interest in
having fine-grained control over these directories.

You can use homesick's linking strategy to your advantage in such cases and have homesick create
a simple directory symlink in your `$HOME` folder.

The **not directory** column in the [linking table](Symlinking#linking-table)
also covers directory symlinks. When encountering a directory symlink,
homesick will create a symlink in `$HOME`, which points to the symlink in your Castle.
Therefore, all we need to do is to convert the directory in question into a symlink.


As an example, consider this directory structure:

    dotfiles/
    └─home/
      └─.emacs/
        ├─snippets/
        └─themes/

If we move `.emacs` outside the `home/` directory, we can still keep it in the repository
and create a symlink in its place like so:

    dotfiles/
    ├─emacs/
    │ └─snippets/
    │ └─themes/
    └─home/
      └─.emacs ➞ ../emacs

When running `homesick link dotfiles`, homesick will now not traverse into the `.emacs` folder
in your castle. Instead it will create a symlink named `.emacs` in your `$HOME`,
which links to `$HOME/.homesick/repos/dotfiles/home/.emacs`.

## Files outside your home directory ##

Although homesick is specifically made for files in your `$HOME` directory,
you can get homesick to venture outside those borders.
Since homesick follows directory symlinks in `$HOME`, you can create one
that points to a different location on your machine.

*Please note that managing files outside `$HOME` is beyond homesick's intended scope.
It is possible, but more often than not it is not the right tool for the job.
The strategy outlined below is more of a "hack" than a real pattern.*

Consider a scenario where you might have a webapp you want to add to `/var/www/tools`.
This is the structure of that app:

    tools/
    ├─public/
    │ ├─assets/
    │ │ ├─js/
    │ │ │ └─jquery.js
    │ │ └─css/
    │ │   └─bootstrap.css
    │ └─index.htm
    └─app/
      └─controllers/
        └─router.py

You will need to place a symlink somewhere inside your `$HOME` that points at the intended
location for your webapp. We don't want to clutter `$HOME`, so we place the symlink in the
`.homesick` directory.

    $HOME/
    └─.homesick/
      ├─repos/
      │ └─...
      └─links/
        └─tools ➞ /var/www/tools

The structure of the castle now needs to mimick the location of that symlink:

    webapp/
    └─home/
      └─.homesick/
        └─links/
          └─tools/
            ├─public/
            │ ├─assets/
            │ │ └─...
            │ └─index.htm
            └─app/
              └─...

When running `homesick link webapp`, homesick will now traverse
into the directory structure of your castle, discover that the *resource* `.homesick/links/tools`
already exists, choose the `identical` action (see the [linking table](Symlinking#linking-table)),
follow the symlink you created, and go on with creating the `public/` and `app/` folders
in `/var/www/tools`.

This method can of course be combined with the [shallow symlinking](Symlinking#shallow-symlinking) method.
In such a case it would be better to point the symlink in the `.homesick/links` directory at `/var/www` (to avoid having to create symlinks for both `public/` and `app/`)
and use the following castle directory structure

    webapp/
    ├─tools/
    │ ├─public/
    │ │ ├─assets/
    │ │ │ └─...
    │ │ └─index.htm
    │ └─app/
    │   └─...
    └─home/
      └─.homesick/
        └─links/
          └─var-www/
            └─tools ➞ ../../../../tools

If you want the `links/` folder to be under version control, you should place it adjacent to a castles `home/` folder like this

    webapp/
    ├─tools/
    │ └─...
    ├─home/
    │ └─.homesick/
    │   └─repos/
    │     └─webapp/
    │       └─links/
    │         └─var-www/
    │           └─tools ➞ ../../../../../../tools
    └─links/
      └─var-www/ ➞ /var/www

This scenario is of course only useful if the destination of your webapp is the same on all the machines homesick is deployed to. Deployment specific links (like `/srv` instead of `/var/www` on some installations) are only possible if you keep the symlinks outside of version control.

