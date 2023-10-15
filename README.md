# Tahuti - An Expense Sharing App for Urbit

For details about this app, see the [proposal](./proposal.md).


## Development

### Setup

Setup this project either by using [pilothouse](https://git.sr.ht/~talfus-laddus/pilothouse) or by hand.

#### Setup by using Pilothouse

See [pilothouse](https://git.sr.ht/~talfus-laddus/pilothouse).

```bash
pilothouse chain zod tahuti/
```

#### Setup by Hand

```bash
# Get source
git clone https://git.sr.ht/~talfus-laddus/tahuti
cd tahuti
# Get Urbit binary
curl -L https://urbit.org/install/linux-x86_64/latest | tar xzk --transform='s/.*/urbit/g'
urbit -F zod
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

### Tests

#### Unit Tests (Hoon)

To run all tests files:

```dojo
|commit %tahuti
-test /=tahuti=/tests
```

#### Integration Tests (Python)

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

- `%tahuti-ui`: UI agent. Serves front-end (HTML, CSS and HTMX)
- `%tahuti-api`: REST API agent. Interfaces with front-end via requests with JSON payload.
- `%tahuti`: Core agent. Manages state (groups and expenses)

#### %tahuti

...

#### %tahuti-ui

Inspired by [%feature](https://developers.urbit.org/guides/additional/app-workbook/feature).
Depends on [%schooner](https://github.com/dalten-collective/boat).

The front-end is build with HTML, CSS and HTMX.
HTMX is used to interfaces with the API using JSON encoded request bodies (`json-enc` extension) and client side templates.

#### %tahuti-api

Inspired by [%feature](https://developers.urbit.org/guides/additional/app-workbook/feature).
Depends on [%schooner](https://github.com/dalten-collective/boat).

Endpoints:
```
GET   api/groups                  // Get all groups               (JSON array)
PUT   api/groups                  // Add or edit a group          (JSON object)

GET   api/groups/{uuid}/members   // Get all members of a group   (JSON array)
PUT   api/groups/{uuid}/members   // Add members                  (JSON object)

GET   api/groups/{uuid}/expenses  // Get all expenses of a group  (JSON array)
PUT   api/groups/{uuid}/expenses  // Add or edit an expense       (JSON object)

POST  api/groups/action/join      // Join a group                 (JSON object)
```


### Abbreviations

- ex: expense
- gid: group ID
- eid: expense ID


## Contributing

You can contribute in various ways. Foremost, you can always reach out
to me on the network (`~talfus-laddus`). Critic and praise are welcomed
equally. You can also use the [issue/ticket
tracker](https://todo.sr.ht/~talfus-laddus/tahuti) to report any bugs or
request new features.
For financial support, you can donate to my Ethereum Address:

`0x Ee09 333c 1a33 2Ba8 dA96 4230 C71C 724A 2F48 aC56`

## Contact

`~talfus-laddus`
