# l10n_lint

The `l10n_lint` package provides linting rules for Flutter localization. It helps you check if localization is initialized correctly and find string literals that should be localized.

## Features
- Cli init, sort and get unused value
- Linting rules to ensure correct initialization of localization.
- Detection of string literals that should be localized.

## Getting started

To start using the `l10n_lint` package, make sure you have the following prerequisites:
Flutter SDK is installed on your machine.

To install the `l10n_lint` cli and , run the following command:
```sh
dart pub global activate l10n_lint
```
use:
```sh
l10n <flags> [arguments]
-h, --help                  Print this usage information.
-v, --verbose               Show additional command output.
-s, --sort                  Sort the ARB files alphabetically.
-u, --[no-]remove-unused    Remove unused translations from the ARB file
-i, --init                  Initialize the l10n tool.
    --version               Print the tool version.
```

To add `l10n_lint` to your Flutter project, follow these steps:

1. Open your project's `pubspec.yaml` file.
2. Add `l10n_lint` as a dev dependency:

```yaml
dev_dependencies:
  flutter_lints: ^3.0.0
  custom_lint:
  l10n_lint:
```

3. In `analysis_options.yaml` add

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  plugins: 
    - custom_lint
```

<!-- TODO -->
## TODO
- [ ] show number of deleted keys when run `l10n unused`