# toml-test Integration

This subpackage contains CLI tools for running the [toml-test](https://github.com/toml-lang/toml-test) compliance suite.

## Prerequisites

- Go (for running toml-test)

## Usage

```bash
cd Tests/Integration
make              # build and run all tests
make test-decoder # decoder tests only
make test-encoder # encoder tests only
make build        # build without running tests
make clean        # clean build artifacts
```

## Manual Testing

### Decoder

Reads TOML from stdin and outputs tagged JSON:

```bash
echo 'name = "test"' | ./.build/debug/toml-decoder
# {"name":{"type":"string","value":"test"}}
```

### Encoder

Reads tagged JSON from stdin and outputs TOML:

```bash
echo '{"name":{"type":"string","value":"test"}}' | ./.build/debug/toml-encoder
# name = "test"
```

## Options

Skip specific tests:

```bash
go run github.com/toml-lang/toml-test/cmd/toml-test@latest -skip 'valid/float/inf-and-nan' ./.build/debug/toml-decoder
```

Run specific tests:

```bash
go run github.com/toml-lang/toml-test/cmd/toml-test@latest -run 'valid/string/*' ./.build/debug/toml-decoder
```
