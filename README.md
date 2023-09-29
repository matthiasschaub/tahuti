# Tahuti - An Expense Sharing App for Urbit

For details about this app, see the [proposal](./proposal.md).

For the front-end, see [this repository](https://git.sr.ht/~talfus-laddus/tahuti-website).


## Development

### Setup

Setup this project either by hand or by using *pilothouse*.

#### Setup by Hand

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
watch "rsync -zr tahuti/* zod/tahuti"
```

```dojo
|commit %tahuti
|install our %tahuti
```

#### Setup by using Pilothouse (TBA)

```bash
pilothouse chain zod tahuti/
```

### Tests

#### Unit Tests in Hoon

To run all tests files:

```dojo
|commit %tahuti
-test /=tahuti=/tests
```

#### Integration Tests in Python

```python
pytest tests
```

### Agents

There are three agents:

- `%tahuti`: Core agent. Manages state (groups and expenses)
- `%tahuti-ui`: UI agent. Serves front-end (HTML, CSS and JS)
- `%tahuti-api`: REST API agent. Interfaces with front-end via JSON.

#### %tahuti

```hoon
:tahuti &tahuti-action [%add-group gid=%uuid group=['title' ~zod (silt [~nus ~]) (silt [~nus ~])]]
.^(@ %gx /=tahuti=/groups/noun)
:tahuti +dbug
```

#### %tahuti-ui

Inspired by [%feature](https://developers.urbit.org/guides/additional/app-workbook/feature). Depends on [%schooner](https://github.com/dalten-collective/boat).

#### %tahuti-api API

Inspired by [%feature](https://developers.urbit.org/guides/additional/app-workbook/feature). Depends on [%schooner](https://github.com/dalten-collective/boat).

Endpoints:
```
GET  /groups                         // Get all groups
PUT  /groups/{uuid}                  // Add or edit a group
GET  /groups/{uuid}/expenses         // Get all expenses of a group
PUT  /groups/{uuid}/expenses/{uuid}  // Add or edit an expense
```


### Abbreviations

- ex: expense
- exes: a list of expenses
- gid: group ID
- eid: expense ID


## Contact

Reach out to me on the network: `~talfus-laddus`
