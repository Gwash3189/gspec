import gleam/result
import gleeunit
import gspec.{be, equal, expect, false, to, true}
import gspec/list_lib

pub fn main() {
  gleeunit.main()
}

pub fn expect_list_every_to_return_true_test() {
  let list = [1, 2, 3, 4, 5]
  let result = list_lib.every(list, fn(x) { x > 0 })

  expect(result) |> to |> be |> true
}

pub fn expect_list_every_to_return_false_test() {
  let list = [1, 2, 3, 4, 5]
  let result = list_lib.every(list, fn(x) { x < 0 })

  expect(result) |> to |> be |> false
}

pub fn expect_at_to_return_expected_element_test() {
  let list = [1, 2, 3, 4, 5]
  let r = result.unwrap(list_lib.at(list, 1), 0)

  r |> expect |> to |> be |> equal(2)
}

pub fn expect_each_with_index_to_pass_index_to_func_test() {
  let list = [1, 2, 3, 4, 5]
  list_lib.each_with_index(list, fn(int, i) {
    i |> expect |> to |> equal(int - 1)
  })
}
