# Development

## Requirements

- Python ^3.11
- Poetry ^1.7
- Node

## Setup

Setup this project either by using
[pilothouse](https://git.sr.ht/~talfus-laddus/pilothouse) or by hand.

### Setup by using Pilothouse

See [pilothouse](https://git.sr.ht/~talfus-laddus/pilothouse).

```bash
npm install
npm run build
pilothouse chain zod tahuti/
```

### Setup by Hand

```bash
npm install
npm run build
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


## Debugging

```
|start %dbug
http://localhost:8080/~debug
```

## Tests

### Unit Tests (Hoon)

Unit tests written in Hoon. Those are testing the libraries (`lib`).

To run all tests files:

```dojo
-test /=tahuti=/tests
```

### Unit & Property-Based Tests (Python)

Unit and property-based tests written in Python. These tests utilize the
`pytest` and `hypothesis` frameworks. The tests run against `%tahuti`'s API
on three fake ships (`~zod`, `~nus` and `lus`). Fake ships are managed
with [pilothouse](https://git.sr.ht/~talfus-laddus/pilothouse).

```bash
poetry install
poetry shell
pytest
```

