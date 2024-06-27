# gspec

[![Package Version](https://img.shields.io/hexpm/v/gspec)](https://hex.pm/packages/gspec)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gspec/)

See [our tests](https://github.com/Gwash3189/gspec/blob/main/test/gspec_test.gleam) for a complete example

```sh
gleam add gspec
```
```gleam
import gspec.{
  be, contain, empty, equal, expect, false, have, include, include_exactly,
  member, member_with_value, not, start_with, to, true, // see tests for all matchers
}

pub fn main() {
  gleeunit.main()
}

pub fn expect_chain_test() {
  1
  |> expect
  |> to
  |> equal(1)
}

// ...
```

Further documentation can be found at <https://hexdocs.pm/gspec>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
