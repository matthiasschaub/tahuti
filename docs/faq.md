# Frequently Asked Questions (FAQ)

## How can I backup my expenses?

You can download all expenses of a group as JSON file on the settings page.

Alternatively, you can use the command-line tool `tahuti` to download the
expenses:

```bash
> pipx install https://github.com/matthiasschaub/tahuti
> tahuti backup --help 
Usage: tahuti backup [OPTIONS]

  Backup expenses of a group.

Options:
  --url TEXT          Base URL of your ship.  [required]
  --gid TEXT          Existing group ID.  [required]
  --file FILE         Input JSON file.  [required]
  --access-code TEXT  Access code of your ship.
  --help              Show this message and exit.
> # access code can also be provided as env
> export TAHUTI_ACCESS_CODE=mycode
> tahuti restore \
    --url https://sample-palnet.tlon.network \
    --gid ca14e82a-ad2f-487e-9f59-fe373bbadd9c \
    --file expenses.json
```

See also [How can I restore my backup?](#how-can-i-restore-my-backup)

## How can I restore my backup?

The general process to restore expenses of a group is to create a new group,
invite all previous members and import expenses from JSON file.

Unfortunately, importing expenses can not be done from the web interface yet.
Right now, the only way to do it is to use the command-line tool `tahuti` to
restore your backup:

```bash
> pipx install https://github.com/matthiasschaub/tahuti
> tahuti restore --help
Usage: tahuti restore [OPTIONS]

  Restore expenses of a group.

Options:
  --url TEXT          Base URL of your ship.  [required]
  --gid TEXT          New group ID.  [required]
  --file FILE         Output JSON file.  [required]
  --access-code TEXT  Access code of your ship.
  --help              Show this message and exit.
> # access code can also be provided as env
> export TAHUTI_ACCESS_CODE=mycode
> tahuti backup \
    --url https://sample-palnet.tlon.network \
    --gid ca14e82a-ad2f-487e-9f59-fe373bbadd9c \
    --file expenses.json
```

See also [How can I backup my expenses?](#how-can-i-backup-my-expenses)
