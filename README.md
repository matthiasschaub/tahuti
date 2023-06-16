# Expense Sharing App for Urbit

## Development

### Setup

```bash
$ git clone https://git.sr.ht/~talfus-laddus/splt-exps
$ cd splt-exps
$ urbit -F zod
> |merge %splt-exps our %base
> |mount %splt-exps
```

Start continuous synchronisation between the git repository's `splt-exps` directory
(Earth) and the `%splt-exps` desk's directory (Mars):

```bash
./sync.sh
```

### Usage

Run the fake ship, start the language server, `commit` the files and run tests.
```bash
$ urbit zod
> |start %language-server
> |commit %splt-exps
> -test /=splt-exps=/tests/lib/bsf/hoon ~
```

## Contact

Reach out to me on the network: `~talfus-laddus`
