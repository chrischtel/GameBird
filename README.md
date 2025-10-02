# GameBird

A simple game library manager for Windows. Organize your games in one place without the bloat.

## What it does

GameBird lets you add games to a personal library, mark favorites, and launch them quickly. It's not trying to be Steam or compete with launchers that do everything. Just a clean way to organize the games you actually play.

## Features

- Add any executable as a game entry
- Mark games as favorites 
- Launch games with double-click or button
- Dark interface that doesn't hurt your eyes
- Saves your library automatically

## Getting started

Download the latest release, run GameBird.exe, and click "Add Game" to get started. Point it to any .exe file and give it a name.

## Requirements

- Windows 10 or later
- About 50MB disk space with Qt libraries

## Building from source

You'll need Qt 6.9+ and CMake:

```bash
cmake -B build -S . -G Ninja
cmake --build build
```

## Current limitations

This is version 0.1.0. Some things that might be obvious are missing:

- Game icons come from the exe (basic extraction only)
- No Steam integration yet  
- Windows only for now
- No categories beyond favorites

## Why another launcher

Most game launchers try to do everything. GameBird just manages a list of games you want quick access to. Sometimes that's all you need.

## License

MIT - do whatever you want with it.