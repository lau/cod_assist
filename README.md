# CodAssist

Get a notification when a CoD server is started on the LAN.

For Call of Duty 2 and 4 multiplayer on Max OS X

## Requirements

The following needs to be installed in order for the program to run:

- terminal-notifier
- Elixir

To install those with Homebrew: `brew update && brew install terminal-notifier elixir`

## Installation

Copy the files `cod2_mp.sh` and `cod4_mp.sh` to the `/Applications` folder.

It is assumed that location of CoD4 is: `/Applications/Call of Duty 4/Call of Duty 4 Multiplayer.app`
and for CoD2: `/Applications/CoD2/Call of Duty 2 Multiplayer.app`

Optional: System Preferences -> Notifications -> terminal-notifier -> Select "Alerts" alert style in
order to have the alert stay until you dismiss them.

## Use

Start the script by double clicking the `start.command` file.

Once a game server is detected it will make a notification. Click it to connect to the game.

To stop the CoD notification tool: Press Ctrl-C then enter `a` then hit ENTER. Or simply close the Terminal window.
