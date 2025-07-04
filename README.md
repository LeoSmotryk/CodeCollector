# CodeCollector

CodeCollector is a cross-platform Flutter application for collecting, viewing, and saving code files. It supports Windows, macOS and Linux.

## Features

- Select and load code files or folders.
- View code in a clean, monospaced format.
- Save code to your Downloads folder.
- Cross-platform support (Windows, macOS, Linux).

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart SDK (included with Flutter)
- For desktop builds: 
  - Windows: Visual Studio with Desktop development tools
  - macOS: Xcode
  - Linux: GTK3 development libraries

### Installation

Clone the repository:

```sh
git clone https://github.com/LeoSmotryk/CodeCollector.git
cd code_collector
```

Install dependencies:

```sh
flutter pub get
```

### Running

#### Desktop

```sh
flutter run -d windows   # or macos, linux
```

## Project Structure

- `lib/` - Main Dart source code.
- `windows/`, `macos/`, `linux/` - Platform-specific code and build files.
- `.dart_tool/`, `build/` - Generated and build files (not for editing).

## Plugins Used

- [`file_picker`](https://pub.dev/packages/file_picker)
- [`file_saver`](https://pub.dev/packages/file_saver)
- [`bitsdojo_window`](https://pub.dev/packages/bitsdojo_window)
- [`path`](https://pub.dev/packages/path)
- [`flutter`](https://flutter.dev/)

## License

This project is licensed under the BSD-style license. See the LICENSE file for details.
