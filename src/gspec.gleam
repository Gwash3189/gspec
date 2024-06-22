import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option}
import gleam/result
import gleam/string
import gleeunit/should
import gspec/list_lib

/// A container for a value that is being asserted on.
/// Can be Not(x) when asserting that a value is not equal to something.
/// Can be Expect(x) when asserting that a value is equal to something.
/// Expectation chains can be short circuited with a Noop(x) value.
pub type Container(inner) {
  Expect(value: inner)
  Not(value: inner)
  Noop(value: inner)
}

/// The start of a expectation chain.
/// Used to start a chain of expectations.
/// ## Examples
/// ```gleam
/// pub fn expect_chain_test() {
///   1
///   |> expect
///   |> equal(1)
/// }
/// ```
pub fn expect(value: val) -> Container(val) {
  Expect(value)
}

/// Grammar sugar for `expect`.
/// This does not transform the value in any way.
/// ## Examples
/// ```gleam
/// pub fn expect_chain_test() {
///  1
/// |> expect
/// |> to
/// |> equal(1)
/// }
/// ```
pub fn to(value: Container(val)) -> Container(val) {
  value
}

/// Grammar sugar for `expect`.
/// This does not transform the value in any way.
/// ## Examples
/// ```gleam
/// pub fn expect_dict_to_have_member_test() {
///   dict.new()
///   |> dict.insert("name", "John Doe")
///   |> expect
///   |> to
///   |> have
///   |> member("name")
/// }
/// ```
pub fn have(value: Container(val)) -> Container(val) {
  value
}

/// Assert that two values are equal.
/// Can be used with Not assertions.
/// ## Examples
/// ```gleam
/// pub fn expect_chain_test() {
///  1
/// |> expect
/// |> to
/// |> equal(1)
///
/// 1
/// |> expect
/// |> to
/// |> not
/// |> equal(2)
/// }
/// ```
pub fn equal(expected: Container(inner), actual: inner) {
  case expected {
    Not(_) -> should.not_equal(expected.value, actual)
    Expect(_) -> should.equal(expected.value, actual)
    Noop(_) -> Nil
  }
}

/// Grammar sugar for `expect`.
/// This does not transform the value in any way.
/// ## Examples
/// ```gleam
/// pub fn test() {
///   [1]
///   |> expect
///   |> to
///   |> not
///   |> be
///   |> empty
/// }
/// ```
pub fn be(expected: Container(inner)) {
  to(expected)
}

/// Grammar sugar for `expect`.
/// This does not transform the value in any way.
/// ## Examples
/// ```gleam
/// pub fn test() {
///   [1]
///   |> expect
///   |> to
///   |> not
///   |> be
///   |> an
///   |> error
/// }
/// ```
pub fn an(expected: Container(inner)) {
  to(expected)
}

/// Flips the expectation from truthy to falsey.
/// ## Examples
/// ```gleam
/// pub fn test() {
///   [1]
///   |> expect
///   |> to
///   |> not
///   |> be
///   |> empty
/// }
/// ```
pub fn not(value: Container(val)) {
  Not(value.value)
}

/// Expects the value to be an error
/// ## Examples
/// ```gleam
/// pub fn test() {
///   Error(True)
///   |> expect
///   |> to
///   |> be
///   |> an
///   |> error
/// }
/// ```
pub fn error(a: Container(Result(a, e))) {
  should.be_error(a.value)
}

/// Expects the value to be an error
/// ## Examples
/// ```gleam
/// pub fn test() {
///   Some(True)
///   |> expect
///   |> to
///   |> be
///   |> some
/// }
/// ```
pub fn some(a: Container(Option(a))) {
  should.be_some(a.value)
}

/// Expects the value to an Ok type
/// ## Examples
/// ```gleam
/// pub fn test() {
///   Ok(True)
///   |> expect
///   |> to
///   |> be
///   |> ok
/// }
/// ```
pub fn ok(a: Container(Result(a, e))) {
  should.be_ok(a.value)
}

/// Expects the value to be a none
/// ## Examples
/// ```gleam
/// pub fn test() {
///   None(_)
///   |> expect
///   |> to
///   |> be
///   |> none
/// }
/// ```
pub fn none(a: Container(Option(a))) {
  should.be_none(a.value)
}

/// Expects the value to be nil
/// ## Examples
/// ```gleam
/// pub fn test() {
///   nil
///   |> expect
///   |> to
///   |> be
///   |> nil
/// }
/// ```
pub fn nil(a: Container(Option(a))) {
  none(a)
}

/// Expects the value to be true
/// ## Examples
/// ```gleam
/// pub fn test() {
///   Some(True)
///   |> expect
///   |> to
///   |> be
///   |> true
/// }
/// ```
pub fn true(a: Container(Bool)) {
  equal(a, True)
}

/// Expects the value to be false
/// ## Examples
/// ```gleam
/// pub fn test() {
///   Some(True)
///   |> expect
///   |> to
///   |> be
///   |> false
/// }
/// ```
pub fn false(a: Container(Bool)) {
  equal(a, False)
}

/// Expects the lists first element to equal the provided value
/// ## Examples
/// ```gleam
/// pub fn test() {
///   [1, 2]
///   |> expect
///   |> to
///   |> start_with(1)
/// }
/// ```
pub fn start_with(container: Container(List(any)), item: any) {
  let first = list.first(container.value)
  let print_panic = fn(container, item) {
    panic as string.concat([
      "\n\t",
      string.inspect(container),
      "\n\tshould start with \n\t",
      string.inspect(item),
    ])
  }

  case container, first {
    Expect(_), Ok(first) -> first |> expect |> equal(item)
    Expect(_), Error(_) -> print_panic(container, item)
    Not(_), Ok(first) -> first |> expect |> to |> not |> equal(item)
    Not(_), Error(_) -> Nil
    _, _ -> print_panic(container, item)
  }
}

/// Expects the lists to contain the provided value
/// ## Examples
/// ```gleam
/// pub fn test() {
///   [1, 2]
///   |> expect
///   |> to
///   |> contain(1)
/// }
/// ```
pub fn contain(container: Container(List(any)), item: any) -> Nil {
  include(container, item)
}

/// Expects the provided list to match the expected list exactly
/// ## Examples
/// ```gleam
/// pub fn test() {
///   [1, 2]
///   |> expect
///   |> to
///   |> include_exactly([1, 2])
/// }
/// ```
pub fn include_exactly(container: Container(List(any)), items: List(any)) -> Nil {
  let expected_length = list.length(container.value)
  let actual_length = list.length(items)

  case expected_length == actual_length {
    False -> {
      panic as string.concat([
        "\n\t",
        string.inspect(container),
        "\n\tshould be the same length as \n\t",
        string.inspect(items),
      ])
    }
    _ -> Nil
  }

  case container {
    Expect(expected_list) -> {
      list_lib.each_with_index(expected_list, fn(expected_item, i) {
        let _ =
          items
          |> list_lib.at(i)
          |> result.try_recover(fn(_) {
            panic as "Unable to get element from list"
          })
          |> result.then(fn(actual_item) {
            actual_item |> expect |> equal(expected_item)
            Ok(actual_item)
          })
        Nil
      })
    }
    Not(expected_list) -> {
      list_lib.each_with_index(expected_list, fn(expected_item, i) {
        let _ =
          items
          |> list_lib.at(i)
          |> result.try_recover(fn(_) {
            panic as "Unable to get element from list"
          })
          |> result.then(fn(actual_item) {
            actual_item |> expect |> to |> not |> equal(expected_item)
            Ok(actual_item)
          })
        Nil
      })
    }
    Noop(_) -> {
      Nil
    }
  }
}

/// Behaves just like contain
/// ## Examples
/// ```gleam
/// pub fn test() {
///   [1, 2]
///   |> expect
///   |> to
///   |> include(1)
/// }
/// ```
pub fn include(container: Container(List(any)), item: any) -> Nil {
  let result = case container {
    Expect(container) -> list.contains(container, item)
    Not(container) -> list.contains(container, item)
    Noop(_) -> False
  }

  case container, result {
    Not(_a), False -> Nil
    Noop(_a), _ -> Nil
    Expect(_a), True -> Nil
    Not(container), True ->
      panic as string.concat([
        "\n\t",
        string.inspect(container),
        "\n\tshould not include \n\t",
        string.inspect(item),
      ])
    Expect(container), False ->
      panic as string.concat([
        "\n\t",
        string.inspect(container),
        "\n\tshould include \n\t",
        string.inspect(item),
      ])
  }
}

/// Expects the key value pair of a dict to match exactly
/// ## Examples
/// ```gleam
/// pub fn test() {
///   dict.new()
///   |> dict.insert("name", "John Doe")
///   |> expect
///   |> to
///   |> have
///   |> member_with_value("name", "John Doe")
/// }
/// ```
pub fn member_with_value(
  container: Container(Dict(String, any)),
  label: String,
  value: any,
) -> Nil {
  let print_panic = fn(container, label, value) {
    panic as string.concat([
      "\n\t",
      string.inspect(container),
      "\n\tshould have the following label and value \n\t",
      string.inspect(label) <> " => " <> string.inspect(value),
    ])
  }

  let has_key = dict.has_key(container.value, label)
  let actual = dict.get(container.value, label)

  case has_key, container, actual {
    True, Expect(_), Ok(actual) -> actual |> expect |> equal(value)
    True, Not(_), Ok(actual) -> actual |> expect |> to |> not |> equal(value)
    False, Not(_), Error(_) -> Nil
    _, _, _ -> print_panic(container, label, value)
  }
}

/// Expects the key of a dict to exist
/// ## Examples
/// ```gleam
/// pub fn test() {
///   dict.new()
///   |> dict.insert("name", "John Doe")
///   |> expect
///   |> to
///   |> have
///   |> member("name")
/// }
/// ```
pub fn member(container: Container(Dict(String, b)), label: String) -> Nil {
  let result = case container {
    Expect(container) -> dict.has_key(container, label)
    Not(container) -> dict.has_key(container, label)
    Noop(_) -> False
  }
  let print_panic = fn(container, label) {
    panic as string.concat([
      "\n\t",
      string.inspect(container),
      "\n\tshould have key \n\t",
      string.inspect(label),
    ])
  }

  case container, result {
    Not(_a), False -> Nil
    Noop(_a), _ -> Nil
    Expect(_a), True -> Nil
    Not(container), True -> print_panic(container, label)
    Expect(container), False -> print_panic(container, label)
  }
}

/// Expects the list to be empty
/// ## Examples
/// ```gleam
/// pub fn expect_list_to_be_empty_test() {
///   [1]
///   |> expect
///   |> to
///   |> not
///   |> be
///   |> empty
/// }
/// ```
pub fn empty(container: Container(List(a))) -> Nil {
  let result = case container {
    Expect(container) -> list.is_empty(container)
    Not(container) -> list.is_empty(container)
    Noop(_) -> False
  }
  let print_panic = fn(container) {
    panic as string.concat([
      "\n\t",
      string.inspect(container),
      "\n\tshould be empty",
    ])
  }

  case container, result {
    Not(_a), False -> Nil
    Noop(_a), _ -> Nil
    Expect(_a), True -> Nil
    Not(container), True -> print_panic(container)
    Expect(container), False -> print_panic(container)
  }
}
