# geny

(WIP.)

[![Package Version](https://img.shields.io/hexpm/v/geny)](https://hex.pm/packages/geny)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/geny/)

Inspired by rust's [anyhow](https://github.com/dtolnay/anyhow)  


```sh
gleam add geny
```

```gleam
import geny.{type GResult}
import geny.ext.ensure

pub fn user_allowed(user_id: Int) -> GResult(String, String) {
  use <- ensure(must: user_id == 0, error: "Only user 0 is allowed")
  // ...
  // ...
  // ...
  Ok("Good")
}

user_allowed(0) |> should.be_ok
user_allowed(1) |> should.be_error
user_allowed(2) |> should.be_error
```

You could add context for `GResult` and print them:  

```gleam
import geny.{type GResult}
import geny/ext.{context, from, to_string}
import gleam/io

let result = Error("This is a error") |> from  //  <-- This convert/wrap normal `Result` into `GResult`  
let result = result |> context("The context A")
let result = result |> context("The context B")
let result = result |> context("The context C")

case result {
  Ok(_) -> io.println("Good ok!")
  Error(geny) -> io.println(geny |> to_string)
}
```

The output is:  

```gleam
error: This is a error

caused by:
  0: The context A
  1: The context B
  2: The context C
```

Further documentation can be found at <https://hexdocs.pm/geny>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
