# shell-completions

Shell completions for the [Zig compiler](https://github.com/ziglang/zig).

## Installation for zsh

The `_zig` file needs to be included in your `$fpath`. This can be achieved in two ways:
1. Move the `_zig` file to one of the folders listed in `$fpath`. You can list these folders with `print -l $fpath`.
2. Add the folder containing `_zig` to the `$fpath`. This can be achieved by adding `fpath=(/path/to/this/repo/shell-completions $fpath)` to your `~/.zshrc` file (to update the current terminal run `source ~/.zshrc`).

Once the `$fpath` variable is updated, run `compinit` to rebuild `~/.zcompdump`.

### Installation for Oh My Zsh

1. Clone the plugin as `zig-shell-completions`

```sh
git clone https://github.com/ziglang/shell-completions $ZSH/custom/zig-shell-completions
```

2. Add the plugin `zig-shell-completions` to `$plugin`

```sh
plugins+=(zig-shell-completions)
```

## Installation for bash

```sh
curl -LO "https://raw.githubusercontent.com/ziglang/shell-completions/master/_zig.bash"
echo ". $PWD/_zig.bash" >> ~/.bashrc
```
