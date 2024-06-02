// import gleam/int
import gleam/list
// import gleam/string
import gleam/result

pub type Geny(e) {
  Geny(error: e, contexts: List(String))
}

pub type GResult(a, e) =
  Result(a, Geny(e))

pub fn get_error(geny: Geny(e)) -> e {
  let Geny(error, _) = geny
  error
}

pub fn to_normal(result: GResult(a, e)) -> Result(a, e) {
  case result {
    Ok(x) -> Ok(x)
    Error(Geny(e, _)) -> Error(e)
  }
}

pub fn is_ok(result: GResult(a, e)) -> Bool {
  result.is_ok(result)
}

pub fn is_error(result: GResult(a, e)) -> Bool {
  result.is_error(result)
}

pub fn map(over result: GResult(a, e), with fun: fn(a) -> b) -> GResult(b, e) {
  result.map(result, fun)
}

pub fn map_error(
  over result: GResult(a, e),
  with fun: fn(e) -> f,
) -> GResult(a, f) {
  case result {
    Ok(x) -> Ok(x)
    Error(Geny(error, contexts)) -> Error(Geny(fun(error), contexts))
  }
}

pub fn flatten(result: GResult(GResult(a, e), e)) -> GResult(a, e) {
  result.flatten(result)
}

pub fn try(
  result: GResult(a, e),
  apply fun: fn(a) -> GResult(b, e),
) -> GResult(b, e) {
  result.try(result, fun)
}

pub fn then(
  result: GResult(a, e),
  apply fun: fn(a) -> GResult(b, e),
) -> GResult(b, e) {
  try(result, fun)
}

pub fn unwrap(result: GResult(a, e), or default: a) -> a {
  case result {
    Ok(v) -> v
    Error(_) -> default
  }
}

pub fn lazy_unwrap(result: GResult(a, e), or default: fn() -> a) -> a {
  case result {
    Ok(v) -> v
    Error(_) -> default()
  }
}

pub fn unwrap_error(result: GResult(a, e), or default: e) -> e {
  case result {
    Ok(_) -> default
    Error(Geny(error, _)) -> error
  }
}

pub fn unwrap_both(result: GResult(a, a)) -> a {
  case result {
    Ok(a) -> a
    Error(Geny(a, _)) -> a
  }
}

pub fn nil_error(result: GResult(a, e)) -> GResult(a, Nil) {
  map_error(result, fn(_) { Nil })
}

pub fn or(first: GResult(a, e), second: GResult(a, e)) -> GResult(a, e) {
  case first {
    Ok(_) -> first
    Error(_) -> second
  }
}

pub fn lazy_or(
  first: GResult(a, e),
  second: fn() -> GResult(a, e),
) -> GResult(a, e) {
  case first {
    Ok(_) -> first
    Error(_) -> second()
  }
}

pub fn all(results: List(GResult(a, e))) -> GResult(List(a), e) {
  list.try_map(results, fn(x) { x })
}

// pub fn partition(results: List(GResult(a, e))) -> #(List(a), List(e)) {
//   do_partition(results, [], [])
// }

// fn do_partition(results: List(GResult(a, e)), oks: List(a), errors: List(e)) {
//   case results {
//     [] -> #(oks, errors)
//     [Ok(a), ..rest] -> do_partition(rest, [a, ..oks], errors)
//     [Error(e), ..rest] -> do_partition(rest, oks, [e, ..errors])
//   }
// }
