import gleeunit
import gleeunit/should

import ext.{ensure}
import geny.{type GResult}

pub fn main() {
  gleeunit.main()
}

pub fn ensure_test() {
  let user_allowed = fn(user_id: Int) -> GResult(String, String) {
    use <- ensure(must: user_id == 0, error: "Only user 0 is allowed")
    Ok("Good")
  }

  user_allowed(0) |> should.be_ok
  user_allowed(1) |> should.be_error
  user_allowed(2) |> should.be_error
}
