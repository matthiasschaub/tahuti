# Tahuti - An Expense Sharing App for Urbit

For details about this app, see the [proposal](./proposal.md).

For the front-end, see [this repository](https://git.sr.ht/~talfus-laddus/tahuti-website)

## Development

### Setup

```bash
git clone https://git.sr.ht/~talfus-laddus/tahuti
cd tahuti

curl -L https://urbit.org/install/linux-x86_64/latest | tar xzk --transform='s/.*/urbit/g'
wget https://bootstrap.urbit.org/dev-latest.pill
urbit -B dev-latest.pill -F zod
```

```dojo
|merge %tahuti our %base
|mount %tahuti
```

Start continuous synchronisation between the git repository's `tahuti` directory (Earth) and the `tahuti` desk's directory (Mars):

```bash
./sync.sh
```

```dojo
|commit %tahuti
|install our %tahuti
|rein %tahuti [& %tahuti-ui]
```

### Tests

To run all tests files:

```dojo
|commit %tahuti
-test /=tahuti=/tests/
```

### Agents

There are three agents:

- `%tahuti`: core agent storing groups, members and expenses.
- `%tahuti-ui`: UI agent serving front-end (html, css and js)
- `%tahuti-api`: API agent

```dojo
|rein %tahuti [& %tahuti]  :: start agent
|rein %tahuti [| %tahuti]  :: stop agent
```

#### %tahuti-ui

Inspired by [%feature](https://developers.urbit.org/guides/additional/app-workbook/feature). Depends on [%schooner](https://github.com/dalten-collective/boat).


## Contact

Reach out to me on the network: `~talfus-laddus`
