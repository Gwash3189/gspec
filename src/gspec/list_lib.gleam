import gleam/list
import gleam/result

pub fn every(list: List(a), func: fn(a) -> Bool) -> Bool {
  list.fold(list, True, fn(acc, x) { acc && func(x) })
}

pub fn some(list: List(a), func: fn(a) -> Bool) -> Bool {
  list.fold(list, False, fn(acc, x) { acc || func(x) })
}

pub fn equal_length(list_one: List(a), list_two: List(b)) -> Bool {
  list.length(list_one) == list.length(list_two)
}

pub fn tail(list: List(a)) -> List(a) {
  case list {
    [] -> []
    [_, ..rest] -> rest
  }
}

fn walk_until(
  arr: List(a),
  requested_index: Int,
  current_index: Int,
) -> Result(a, Nil) {
  let length = list.length(arr)
  let index_out_of_bounds = requested_index > length || requested_index < 0

  case index_out_of_bounds {
    True -> Error(Nil)
    False -> {
      case current_index == requested_index {
        True -> result.flatten(Ok(list.first(arr)))
        False -> {
          walk_until(tail(arr), requested_index, current_index + 1)
        }
      }
    }
  }
}

fn private_each_with_index(
  list: List(a),
  func: fn(a, Int) -> Nil,
  index: Int,
  stop: Int,
) -> Nil {
  case index > stop, list {
    True, _ -> Nil
    False, arr -> {
      let _ =
        result.try_recover(list.first(arr), with: fn(_) {
          Error("Unable to get element from list")
        })
        |> result.then(fn(head) { Ok(func(head, index)) })
        |> result.then(fn(_) {
          Ok(private_each_with_index(tail(arr), func, index + 1, stop))
        })
        |> result.try_recover(fn(_) { panic as "Unable to iterate over list" })
      Nil
    }
  }
}

pub fn each_with_index(list: List(a), func: fn(a, Int) -> Nil) -> Nil {
  private_each_with_index(list, func, 0, list.length(list) - 1)
}

pub fn first(list: List(a)) -> Result(a, Nil) {
  at(list, 0)
}

pub fn last(list: List(a)) -> Result(a, Nil) {
  at(list, list.length(list) - 1)
}

pub fn second(list: List(a)) -> Result(a, Nil) {
  at(list, 1)
}

pub fn third(list: List(a)) -> Result(a, Nil) {
  at(list, 2)
}

pub fn fourth(list: List(a)) -> Result(a, Nil) {
  at(list, 3)
}

pub fn fifth(list: List(a)) -> Result(a, Nil) {
  at(list, 4)
}

pub fn sixth(list: List(a)) -> Result(a, Nil) {
  at(list, 5)
}

pub fn seventh(list: List(a)) -> Result(a, Nil) {
  at(list, 6)
}

pub fn eighth(list: List(a)) -> Result(a, Nil) {
  at(list, 7)
}

pub fn ninth(list: List(a)) -> Result(a, Nil) {
  at(list, 8)
}

pub fn tenth(list: List(a)) -> Result(a, Nil) {
  at(list, 9)
}

pub fn at(list: List(a), index: Int) -> Result(a, Nil) {
  walk_until(list, index, 0)
}
