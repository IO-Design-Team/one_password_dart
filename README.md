Inject 1Password secrets into all reference files in the current directory

## Installation

```console
$ dart pub global activate one_password_dart
```

## Usage

1. Create files containing 1Password references with filenames matching the pattern `*.opr.*` (ex. `references.opr.dart`)
2. Run `opd` in the terminal

This will create files with filenames matching the pattern `*.ops.*` containing the injected secrets

## IMPORTANT

Make sure you have `*.ops.*` in your `.gitignore` file so that your secrets don't end up in version control