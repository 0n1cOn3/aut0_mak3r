# aut0 mak3r

![Screenshot](index.jpeg)

## Table of Contents

- [General Information](#general-information)
- [Changelog](#changelog)
- [Features](#features)
- [Installation](#installation)
- [Disclaimer](#disclaimer)
- [Credits](#credits)
- [Social Media](#social-media)
- [Bug Report](#bug-report)

# General Information

This project has been in development for a long time and already offers many features despite its small size. If you wipe a computer you might be annoyed by reinstalling tools manually—**aut0 mak3r** solves this problem for you.

The project is now powered by a lightweight modular launcher that keeps individual features in self-contained modules. Each module focuses on a single responsibility which makes the codebase easier to understand, maintain and extend. If you encounter any errors, please visit the [Bug Report](#bug-report) section.
  

# Changelog

### In Progress

- [x] Sources.list Backup/Restore
- [ ] Facebook Tools for Termux section
- [x] `install_tools` module for Linux section
- [x] Split `full_config` module into a separate menu
- [x] Add update checker

### Releases

- **0.3f** – modular loader and dynamic module support
- **0.3d‑Beta 1** – grammar fixes, UI design improvements,
  sources list backup, updated Tor Browser repo and separated driver installation
- **0.3b2** – beta update
- **0.3c‑Beta 2** – code improvements
- **0.3c‑Beta 1** – bug fixes, grammar fixes, UI updates and error log feature
- **0.3** – added a submenu for `full_config` and fixed some Termux commands
- **0.2** – fixed path errors, fixed misc commands and added update checker
- **0.1 (Beta)** – initial release with 59 tools, Termux, misc and ViperZCrew modules

# Features

  Some features are not yet available but will be coming soon

  * Modular launcher with a curated set of focused utilities
  * Install Tools menu with automatic/manual installation, platform-aware package lists and one-click upgrades
  * Cool Command Line Features (delete history, list local/public IPs, traceroute, DNS/WHOIS lookups, open port scans, network sweeps, speed tests, log tailing, resource monitors and more)
  * Command Execution (tmaker)
  
# Disclaimer

  Use this tool for educational purposes only. 🕵️‍♂️
  If you perform any illegal attacks, I am not responsible for your actions.
  Use this tool correctly, and do not re-upload it to your GitHub repository without permission.

# Installation

  For Linux/Termux:
  
  ```git clone https://github.com/rebl0x3r/aut0_mak3r.git```
  
  ```cd aut0_mak3r && chmod +x *```

Run:

```bash
bash tmaker.sh
```

**Warning:** The tool relies on several folders—do not delete them!

- `backup` – stores DNS and `.bashrc` backups
- `lib` – libraries and other module tools (can be run manually)
- `openvpn` – login configurations and modules such as `openvpn.sh`
- `tools` – placeholder for future tools

## Modules

The launcher scans the `modules` directory and loads every `*.sh` file. Each
module can optionally set two variables that describe it:

```bash
MODULE_NAME="example"
MODULE_DESC="Example module description"
```

If these variables are provided, their values appear in the menu. The script
should also define a `run` function that performs the module action. New tools
become available simply by dropping a compatible file into `modules/`.

The launcher currently ships with the following first-party modules:

* `install_tools` – menu-driven installer with automatic/manual modes, Termux-aware package catalogs and a system upgrade helper
* `cli_tools` – collection of handy command-line utilities (history cleanup, IP discovery, traceroute, DNS/WHOIS lookups, speed tests, log tailing, resource monitoring, etc.)
* `credits` – project credits

New modules become available simply by dropping a compatible file into `modules/`.

# Credits

_Channels_

- [LeakerHounds](https://t.me/LeakerHounds)
- [ViperZCrew](https://t.me/ViperZCrew)
- [Deepwaterleaks](https://t.me/deepwaterleaks2)

_Contributors & Supporters_

- BlackFlare
- Legend
- MarCus
- [0n1cOn3](https://github.com/0n1cOn3)

**Current Maintainer:** [0n1c0n3](https://github.com/0n1c0n3)

_Developer & Contact_

[mrblackx2_0](t.me/mrblackx2_0)


# Social Media

Telegram

- @LeakerHounds
- @hx


# Bug Report

If you find any bug or issue, please go [here](https://github.com/rebl0x3r/aut0_mak3r/issues).
You can also request an update.

## Testing

Run the included checks before contributing:

```bash
cd tests
./syntax_check.sh
./test_modules.sh
```
