# Group ExpensesAn

Expense sharing app for Urbit.

For details about this app, see the [proposal](https://urbit.org/grants/splitwise).

## Development

See [inbox](inbox.md) for open tasks.

### Setup

Setup this project either by using
[pilothouse](https://git.sr.ht/~talfus-laddus/pilothouse) or by hand.

#### Setup by using Pilothouse

See [pilothouse](https://git.sr.ht/~talfus-laddus/pilothouse).

```bash
pilothouse chain zod tahuti/
```

#### Setup by Hand

```bash
urbit -F zod
```

```hoon
|merge %tahuti our %base
|mount %tahuti
```

Start continuous synchronisation between the git repository's `tahuti`
directory (Earth) and the `tahuti` desk's directory (Mars):

```bash
watch "rsync -zr tahuti/* zod/tahuti"
```

```dojo
|commit %tahuti
|install our %tahuti
```

### Debugging

`%dbug` agent wrapper is in use:

```
|start %dbug
http://localhost:8080/~debug
```

### Tests

#### Unit Tests (Hoon)

To run all tests files:

```dojo
|commit %tahuti
-test /=tahuti=/tests
```

#### Integration Tests (Python)

Integration tests are written in Python and are utilizing the `pytest`
framework. The tests run against tahutis API on fake ships.

```bash
# Setup Python environment for test framework (pytest)
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
# Run all tests
pytest tests
```


### Agents

There are three agents:

- `%tahuti-ui`: UI agent. Serves front-end (HTML, CSS and HTMX).
- `%tahuti-api`: REST API agent. Interfaces with front-end via requests with JSON payload.
- `%tahuti`: Core agent. Manages state (groups and expenses).

#### %tahuti

...

#### %tahuti-ui

Inspired by [%feature](https://developers.urbit.org/guides/additional/app-workbook/feature).
Depends on [%schooner](https://github.com/dalten-collective/boat).

The front-end is build with HTML, CSS and HTMX.
HTMX is used to interfaces with the API using JSON encoded request bodies
(`json-enc` extension) and client side templates.

#### %tahuti-api

Inspired by [%feature](https://developers.urbit.org/guides/additional/app-workbook/feature).
Depends on [%schooner](https://github.com/dalten-collective/boat).

Endpoints:
```
GET   api/groups                         // Get all groups               (JSON array)
PUT   api/groups                         // Add or edit a group          (JSON object)
GET   api/groups/{uuid}                  // Get a group                  (JSON object)

GET   api/groups/{uuid}/invitees         // Get all invitees of a group  (JSON array)
PUT   api/groups/{uuid}/invitees         // Invite a ship                (JSON object)

GET   api/groups/{uuid}/register         // Get all members of a group   (JSON array)

GET   api/groups/{uuid}/expenses         // Get all expenses of a group  (JSON array)
PUT   api/groups/{uuid}/expenses         // Add or edit an expense       (JSON object)
GET   api/groups/{uuid}/expenses/{uuid}  // Get an expense               (JSON object)

POST  api/groups/action/join             // Join a group                 (JSON object)
```

### Abbreviations

- gid: group ID
- eid: expense ID
- reg: register (of members)
- acl: access-control list
- led: ledger (of expenses)


## Contributing

You can contribute in various ways. Foremost, you can always reach out
to me on the network (`~talfus-laddus`). Critic and praise are welcomed
equally.
For financial support, you can donate to my Ethereum Address:

`0x Ee09 333c 1a33 2Ba8 dA96 4230 C71C 724A 2F48 aC56`

## Contact

`~talfus-laddus`
