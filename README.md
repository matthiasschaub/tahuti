# Tahuti - An Expense Sharing App for Urbit

For details about this app, see the [proposal](./proposal.md).

For the front-end, see [this repository](https://git.sr.ht/~talfus-laddus/tahuti-website)

## Development

### Setup

```bash
git clone https://git.sr.ht/~talfus-laddus/tahuti
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

## Contact

Reach out to me on the network: `~talfus-laddus`
