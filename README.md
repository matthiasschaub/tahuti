# Expense Sharing App for Urbit

For details about this app, see the [proposal](./proposal.md).

## Development

### Setup

```
$ git clone https://git.sr.ht/~talfus-laddus/splt-exps
$ cd splt-exps
$ urbit -F zod
> |merge %splt-exps our %base
> |mount %splt-exps
> |start %language-server
```

Start continuous synchronisation between the git repository's `splt-exps` directory
(Earth) and the `%splt-exps` desk's directory (Mars):

```bash
./sync.sh
```

### Tests

To run all tests files:

```
> |commit %splt-exps
> -test /=splt-exps=/tests/lib
```

For individual test files:
```
> -test /=splt-exps=/tests/lib/bfs/hoon ~
> -test /=splt-exps=/tests/lib/edmonds-karp/hoon ~
```

## Contact

Reach out to me on the network: `~talfus-laddus`
