# CodAssist

Get a notification when a CoD server is started on the LAN.

For Call of Duty 2 and 4 multiplayer on Max OS X

## Requirements

The following needs to be installed in order for the program to run:

- terminal-notifier
- Elixir

To install those with Homebrew: `brew update && brew install terminal-notifier elixir`

## Installation

- Make sure Elixir and terminal-notifer is installed as per above.

- Copy the files `cod2_mp.sh` and `cod4_mp.sh` to the `/Applications` folder.

- Rename the folder containing this README file to exactly `CodAssist.app`
  unless is already is called that.
  This will make it behave like a Mac app that you can just double click to start.
  Place this app anywhere you want. For instance in the /Applications folder

It is assumed that location of CoD4 is: `/Applications/Call of Duty 4/Call of Duty 4 Multiplayer.app`
and for CoD2: `/Applications/CoD2/Call of Duty 2 Multiplayer.app`. If they are somewhere else, you can
edit `cod2_mp.sh` and `cod4_mp.sh` to reflect another location.

Optional: System Preferences -> Notifications -> terminal-notifier -> Select "Alerts" alert style in
order to have the alert stay until you dismiss them.

## Use

Double click the `CodAssist.app` folder to start the program. It should
open a Terminal window with the program.

Alternatively start the script by double clicking the `start.command` file.

Once a game server is detected it will make a notification. Click it to connect to the game.

To close the program, close the Terminal window.
