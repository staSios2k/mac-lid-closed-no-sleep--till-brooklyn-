# brooklyn

Keep your MacBook awake **with the lid closed**, on battery or charger, for exactly as long as you need. Then it puts everything back to normal on its own.

```
$ brooklyn 90
brooklyn: lid-close sleep disabled for 1h30m00s.
Press q or Ctrl+C to stop early. Closing this window also stops it.
  1h12m48s remaining   battery 74%   (q = stop)
```

Built for long-running jobs: local AI coding agents, big downloads, builds, renders. Start a timer, close the lid, walk away.

- **Zero dependencies.** One zsh script using only built-in macOS tools (`pmset`, `afplay`).
- **Always restores sleep.** When the timer ends, when you press `q` or Ctrl+C, or when you close the Terminal window.
- **Battery guard.** On battery, it stops automatically at 20% so your Mac never dies mid-job.
- **Glass sound** when time is up.

## Install

```zsh
curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/brooklyn/main/install.sh | zsh
```

This copies one file to `~/.local/bin/brooklyn` and adds that folder to your PATH. It doesn't need `sudo` to install. Prefer to read before you run? [The installer](install.sh) and [the script](brooklyn) are short.

<details>
<summary>Manual install</summary>

```zsh
git clone https://github.com/YOUR_GITHUB_USERNAME/brooklyn.git
cd brooklyn
./install.sh
```
</details>

## Usage

| Command | What it does |
|---|---|
| `brooklyn 60` | Keep awake for 60 minutes (1 to 1440), with a live countdown |
| `q` or Ctrl+C | Stop early and restore normal sleep |
| close the window | Same as stopping early |
| `brooklyn` | From another window: show time remaining |
| `brooklyn arrived` | From another window: stop now (also works as a panic reset) |

Change the battery cutoff (default 20%, `0` turns it off):

```zsh
BROOKLYN_MIN_BATTERY=10 brooklyn 120
```

## How it works

macOS only keeps a closed MacBook awake on its own when it's on power with an external display connected (clamshell mode). `caffeinate` can't override lid-close sleep on battery.

`brooklyn` uses `pmset -a disablesleep 1`, which tells macOS not to sleep at all, then sets it back to `0` when it's done. Changing that setting needs administrator rights, so `brooklyn` asks for your password once when you start it. The countdown runs as root in your Terminal window so it can always restore the setting, even hours later when the `sudo` cache has expired.

What `sudo` is used for, and nothing else:
- `pmset -a disablesleep 1` and `0`
- writing and removing `/tmp/brooklyn_timer.state` (the timer's PID and end time)
- stopping a running timer when you call `brooklyn arrived`

## Safety

- A closed MacBook that's awake still produces heat. Keep it on a hard, open surface, **never in a bag or sleeve**.
- `disablesleep` survives reboots. If your Mac crashes mid-timer, sleep will stay disabled. Running `brooklyn` tells you if this happened, and `brooklyn arrived` fixes it.
- `disablesleep` isn't listed in `man pmset`. It works on current macOS (Intel and Apple Silicon), but Apple could change it.

## Uninstall

```zsh
curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/brooklyn/main/install.sh | zsh -s -- --uninstall
```

## Requirements

macOS with zsh (the default shell since Catalina) and an administrator account.

## License

[MIT](LICENSE)
