# Expense Sharing App for Urbit

## Development

### Setup

```bash
$ git clone https://git.sr.ht/~talfus-laddus/splt-exps
$ cd splt-exps
$ urbit -F zod
> |mount %base  :: create %base folder on earth
```

Start continuous synchronisation between the git repository's `gen` directory and the `%base` desk's `gen` directory:
```bash
$ watch "rsync -zr ./lib/* zod/base/lib"
```

Then run the fake ship and `commit` the files:
```bash
$ urbit zod
> |start %language-server
> |commit %base  :: sync %base desk with earth
```

Finally run `splt-exps`:
```dojo
> +splt-exps
``
