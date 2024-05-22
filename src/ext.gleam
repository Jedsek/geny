import geny.{type Geny, Geny, type GResult}
import gleam/int
import gleam/io
import gleam/list
import gleam/string

fn append(geny: Geny(e), new_contexts: List(String)) -> Geny(e) {
  let Geny(value, contexts) = geny
  let contexts = list.concat([contexts, new_contexts])
  Geny(value, contexts)
}

pub fn wrap_error(error: e) -> Geny(e) {
  Geny(error, list.new())
}

pub fn from(result: Result(a, e)) -> GResult(a, e) {
  case result {
    Ok(a) -> Ok(a)
    Error(e) -> Error(wrap_error(e))
  }
}

pub fn context(result: GResult(a, e), context: String) -> GResult(a, e) {
  case result {
    Ok(_) -> result
    Error(geny) -> Error(append(geny, [context]))
  }
}

pub fn lazy_context(
  result: GResult(a, e),
  context: fn() -> String,
) -> GResult(a, e) {
  case result {
    Ok(_) -> result
    Error(geny) -> Error(append(geny, [context()]))
  }
}

pub fn ensure(
  must must: Bool,
  error error,
  otherwise otherwise: fn() -> GResult(a, e),
) -> GResult(a, e) {
  case must {
    False -> Error(wrap_error(error))
    _ -> otherwise()
  }
}

pub fn to_string(geny: Geny(e)) -> String {
  let Geny(error, contexts) = geny

  let error = error |> string.inspect
  let error = "\nerror: " <> error

  let contexts = {
    use acc, context, index <- list.index_fold(contexts, "")
    acc <> "  " <> { index |> int.to_string } <> " : " <> context <> "\n"
  }
  let #(line_separator, contexts) = case string.is_empty(contexts) {
    True -> #("\n", "")
    False -> #("\n\n", "caused by:\n" <> contexts)
  }

  error <> line_separator <> contexts
}

pub fn debug(result: GResult(a, e)) -> GResult(a, e) {
  io.println("======= Geny/Debug start......========")
  case result {
    Error(geny) -> {
      to_string(geny) |> io.println
      Nil
    }
    Ok(a) -> {
      a |> io.debug
      Nil
    }
  }
  io.println("======= Geny/Debug end......  ========")
  io.println("")
  io.println("")
  io.println("")
  result
}
