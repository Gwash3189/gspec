import gleam/dict
import gleeunit
import gspec.{
  be, contain, empty, equal, expect, false, have, include, include_exactly,
  member, member_with_value, not, start_with, to, true,
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

pub fn not_expect_chain_test() {
  1
  |> expect
  |> not
  |> to
  |> equal(2)
}

pub fn expect_to_be_true_test() {
  True
  |> expect
  |> to
  |> be
  |> true
}

pub fn expect_to_be_false_test() {
  False
  |> expect
  |> to
  |> be
  |> false
}

pub fn expect_to_not_be_true_test() {
  False
  |> expect
  |> to
  |> not
  |> be
  |> true
}

pub fn expect_to_not_be_false_test() {
  True
  |> expect
  |> to
  |> not
  |> be
  |> false
}

pub fn expect_dict_to_have_member_test() {
  dict.new()
  |> dict.insert("name", "John Doe")
  |> expect
  |> to
  |> have
  |> member("name")
}

pub fn expect_dict_to_not_have_member_test() {
  dict.new()
  |> dict.insert("name", "John Doe")
  |> expect
  |> to
  |> not
  |> have
  |> member("nae")
}

pub fn expect_dict_to_have_member_and_value_test() {
  dict.new()
  |> dict.insert("name", "John Doe")
  |> expect
  |> to
  |> have
  |> member_with_value("name", "John Doe")
}

pub fn expect_dict_to_not_have_member_and_value_label_test() {
  dict.new()
  |> dict.insert("name", "John Doe")
  |> expect
  |> to
  |> not
  |> have
  |> member_with_value("nae", "John Doe")
}

pub fn expect_dict_to_not_have_member_and_value_key_test() {
  dict.new()
  |> dict.insert("name", "John Doe")
  |> expect
  |> to
  |> not
  |> have
  |> member_with_value("name", "Jon Doe")
}

pub fn expect_list_to_include_item_test() {
  [1]
  |> expect
  |> to
  |> include(1)
}

pub fn expect_list_to_not_include_item_test() {
  [1]
  |> expect
  |> to
  |> not
  |> include(2)
}

pub fn expect_list_to_include_exactly_item_test() {
  [1]
  |> expect
  |> to
  |> include_exactly([1])
}

pub fn expect_list_to_not_include_exactly_item_test() {
  [1, 3]
  |> expect
  |> to
  |> not
  |> include_exactly([2, 1])
}

pub fn expect_list_to_contain_item_test() {
  [1]
  |> expect
  |> to
  |> contain(1)
}

pub fn expect_list_to_not_contain_item_test() {
  [1]
  |> expect
  |> to
  |> not
  |> contain(2)
}

pub fn expect_list_to_start_with_test() {
  [1]
  |> expect
  |> to
  |> start_with(1)
}

pub fn expect_list_to_not_start_with_test() {
  [1]
  |> expect
  |> to
  |> not
  |> start_with(2)
}

pub fn expect_list_to_be_empty_test() {
  [1]
  |> expect
  |> to
  |> not
  |> be
  |> empty
}

pub fn expect_list_to_not_be_empty_test() {
  []
  |> expect
  |> to
  |> be
  |> empty
}
