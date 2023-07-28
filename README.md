# Expense Sharing App for Urbit

For details about this app, see the [proposal](./proposal.md).

## Development

### Setup

```bash
git clone https://git.sr.ht/~talfus-laddus/splt-exps tahuti
cd tahuti
urbit -F zod
```

```dojo
|merge %tahuti our %base
|mount %tahuti
|start %language-server
```

Start continuous synchronisation between the git repository's `tahuti` directory
(Earth) and the `tahuti` desk's directory (Mars):

```bash
./sync.sh
```

### Tests

To run all tests files:

```dojo
|commit %tahuti
-test /=tahuti=/tests/lib
```

For individual test files:
```dojo
-test /=tahuti=/tests/lib/bfs/hoon ~
-test /=tahuti=/tests/lib/edmonds-karp/hoon ~
```

## Contact

Reach out to me on the network: `~talfus-laddus`
