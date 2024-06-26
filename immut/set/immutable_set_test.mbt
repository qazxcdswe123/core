// Copyright 2024 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// This module implements the set data structure.
// The types stored in set need to implement the Compare trait.
// All operations over sets are purely applicative (no side-effects).

test "new" {
  let empty : ImmutableSet[Int] = ImmutableSet::new()
  inspect(empty, content="ImmutableSet::[]")?
}

test "disjoint" {
  inspect(ImmutableSet::[1].disjoint(ImmutableSet::[1, 2, 3]), content="false")?
  inspect(
    ImmutableSet::[1, 2, 3].disjoint(ImmutableSet::[1, 2, 3]),
    content="false",
  )?
  inspect(
    ImmutableSet::[1, 2, 3].disjoint(ImmutableSet::[4, 5, 6]),
    content="true",
  )?
  inspect(
    ImmutableSet::[1, 2, 3].subset(ImmutableSet::[3, 4, 5]),
    content="false",
  )?
}

test "subset" {
  inspect(
    ImmutableSet::[1, 2, 3].subset(ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1]),
    content="true",
  )?
  inspect(
    ImmutableSet::[1, 2, 3].subset(ImmutableSet::[10, 11, 12, 13, 14]),
    content="false",
  )?
}

test "diff" {
  let empty : ImmutableSet[Int] = ImmutableSet::new()
  inspect(empty.diff(ImmutableSet::[1, 2, 3]), content="ImmutableSet::[]")?
  inspect(
    ImmutableSet::[1, 2, 3].diff(empty),
    content="ImmutableSet::[1, 2, 3]",
  )?
  inspect(
    ImmutableSet::[1, 2, 3].diff(ImmutableSet::[4, 5, 1]),
    content="ImmutableSet::[2, 3]",
  )?
  inspect(
    ImmutableSet::[1, 2, 3].diff(ImmutableSet::[1, 2, 3]),
    content="ImmutableSet::[]",
  )?
}

test "inter" {
  inspect(
    ImmutableSet::[3, 4, 5].inter(ImmutableSet::[4, 5, 6]),
    content="ImmutableSet::[4, 5]",
  )?
  inspect(
    ImmutableSet::[3, 4].inter(ImmutableSet::[5, 6]),
    content="ImmutableSet::[]",
  )?
}

test "union" {
  let empty : ImmutableSet[Int] = ImmutableSet::new()
  inspect(
    empty.union(ImmutableSet::[4, 5, 6]),
    content="ImmutableSet::[4, 5, 6]",
  )?
  inspect(
    ImmutableSet::[4, 5, 6].union(empty),
    content="ImmutableSet::[4, 5, 6]",
  )?
  inspect(
    ImmutableSet::[3].union(ImmutableSet::[4, 5, 6]),
    content="ImmutableSet::[3, 4, 5, 6]",
  )?
  inspect(
    ImmutableSet::[3, 4, 5].union(ImmutableSet::[6]),
    content="ImmutableSet::[3, 4, 5, 6]",
  )?
  inspect(
    ImmutableSet::[3, 4, 5].union(ImmutableSet::[4, 5, 6]),
    content="ImmutableSet::[3, 4, 5, 6]",
  )?
}

test "map" {
  inspect(
    ImmutableSet::[1, 2, 3, 4, 5].map(fn(x) { x * 2 }),
    content="ImmutableSet::[2, 4, 6, 8, 10]",
  )?
}

test "forall" {
  inspect(ImmutableSet::[2, 4, 6].forall(fn(v) { v % 2 == 0 }), content="true")?
  inspect(ImmutableSet::[1, 3, 5].forall(fn(v) { v % 2 == 0 }), content="false")?
}

test "exists" {
  inspect(ImmutableSet::[1, 4, 3].exists(fn(v) { v % 2 == 0 }), content="true")?
  inspect(ImmutableSet::[1, 5, 3].exists(fn(v) { v % 2 == 0 }), content="false")?
}

test "fold" {
  inspect(
    ImmutableSet::[1, 2, 3, 4, 5].fold(init=0, fn(acc, x) { acc + x }),
    content="15",
  )?
}

test "filter" {
  inspect(
    ImmutableSet::[1, 2, 3, 4, 5, 6].filter(fn(v) { v % 2 == 0 }),
    content="ImmutableSet::[2, 4, 6]",
  )?
}

test "split" {
  let (left, present, right) = ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1].split(
    5,
  )
  inspect(present, content="true")?
  inspect(left, content="ImmutableSet::[1, 2, 3, 4]")?
  inspect(right, content="ImmutableSet::[6, 7, 8, 9]")?
  let (left, present, right) = ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1].split(
    0,
  )
  inspect(present, content="false")?
  inspect(left, content="ImmutableSet::[]")?
  inspect(right, content="ImmutableSet::[1, 2, 3, 4, 5, 6, 7, 8, 9]")?
}

test "contain" {
  inspect(
    ImmutableSet::[7, 2, 9, 4, 6, 3, 8, 1].add(5).contain(5),
    content="true",
  )?
  inspect(ImmutableSet::[7, 2, 9, 4, 6, 3, 8, 1].contain(5), content="false")?
}

test "from_list" {
  let empty_list : List[Int] = List::[]
  inspect(ImmutableSet::from_list(empty_list), content="ImmutableSet::[]")?
  inspect(ImmutableSet::from_list(List::[1]), content="ImmutableSet::[1]")?
  inspect(ImmutableSet::from_list(List::[1, 2]), content="ImmutableSet::[1, 2]")?
  inspect(
    ImmutableSet::from_list(List::[1, 2, 3]),
    content="ImmutableSet::[1, 2, 3]",
  )?
  inspect(
    ImmutableSet::from_list(List::[1, 2, 3, 4]),
    content="ImmutableSet::[1, 2, 3, 4]",
  )?
  inspect(
    ImmutableSet::from_list(List::[1, 2, 3, 4, 5]),
    content="ImmutableSet::[1, 2, 3, 4, 5]",
  )?
  inspect(
    ImmutableSet::from_list(List::[7, 2, 9, 4, 5, 6, 3, 8, 1]),
    content="ImmutableSet::[1, 2, 3, 4, 5, 6, 7, 8, 9]",
  )?
}

test "to_list" {
  inspect(
    ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1].to_list(),
    content="List::[1, 2, 3, 4, 5, 6, 7, 8, 9]",
  )?
  let empty : ImmutableSet[Int] = ImmutableSet::new()
  inspect(empty.to_list(), content="List::[]")?
}

test "to_array" {
  inspect(
    ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1].to_array(),
    content="[1, 2, 3, 4, 5, 6, 7, 8, 9]",
  )?
}

test "from_array" {
  inspect(
    ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1],
    content="ImmutableSet::[1, 2, 3, 4, 5, 6, 7, 8, 9]",
  )?
}

test "remove_min" {
  inspect(ImmutableSet::[3, 4, 5].remove_min(), content="ImmutableSet::[4, 5]")?
}

test "add" {
  inspect(
    ImmutableSet::[7, 2, 9, 4, 6, 3, 8, 1].add(5),
    content="ImmutableSet::[1, 2, 3, 4, 5, 6, 7, 8, 9]",
  )?
  inspect(ImmutableSet::[2].add(1), content="ImmutableSet::[1, 2]")?
  inspect(ImmutableSet::[2].add(3), content="ImmutableSet::[2, 3]")?
  inspect(ImmutableSet::[2].add(1).add(3), content="ImmutableSet::[1, 2, 3]")?
  inspect(ImmutableSet::[1, 2].add(1), content="ImmutableSet::[1, 2]")?
  inspect(ImmutableSet::[2, 3].add(3), content="ImmutableSet::[2, 3]")?
  inspect(ImmutableSet::[1, 2, 3].add(1), content="ImmutableSet::[1, 2, 3]")?
  inspect(ImmutableSet::[1, 2, 3].add(3), content="ImmutableSet::[1, 2, 3]")?
  inspect(ImmutableSet::[1].add(2).add(2), content="ImmutableSet::[1, 2]")?
}

test "remove" {
  let empty : ImmutableSet[Int] = ImmutableSet::new()
  inspect(empty.remove(1), content="ImmutableSet::[]")?
  inspect(
    ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1].remove(1),
    content="ImmutableSet::[2, 3, 4, 5, 6, 7, 8, 9]",
  )?
  inspect(
    ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1].remove(9),
    content="ImmutableSet::[1, 2, 3, 4, 5, 6, 7, 8]",
  )?
  inspect(
    ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1].remove(8),
    content="ImmutableSet::[1, 2, 3, 4, 5, 6, 7, 9]",
  )?
  inspect(
    ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1].remove(0),
    content="ImmutableSet::[1, 2, 3, 4, 5, 6, 7, 8, 9]",
  )?
  inspect(
    ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1].remove(10),
    content="ImmutableSet::[1, 2, 3, 4, 5, 6, 7, 8, 9]",
  )?
}

test "min" {
  inspect(ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1].min(), content="1")?
}

test "min_option" {
  let empty : ImmutableSet[Int] = ImmutableSet::new()
  inspect(empty.min_option(), content="None")?
  inspect(
    ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1].min_option(),
    content="Some(1)",
  )?
}

test "max" {
  inspect(ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1].max(), content="9")?
}

test "max_option" {
  let empty : ImmutableSet[Int] = ImmutableSet::new()
  inspect(empty.max_option(), content="None")?
  inspect(
    ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1].max_option(),
    content="Some(9)",
  )?
}

test "is_empty" {
  inspect((ImmutableSet::[] : ImmutableSet[Int]).is_empty(), content="true")?
  inspect(ImmutableSet::[1].is_empty(), content="false")?
}

test "to_string" {
  inspect(
    ImmutableSet::[1, 2, 3, 4, 5],
    content="ImmutableSet::[1, 2, 3, 4, 5]",
  )?
  inspect((ImmutableSet::[] : ImmutableSet[Int]), content="ImmutableSet::[]")?
}

test "iter" {
  let mut s = ""
  ImmutableSet::[7, 2, 9, 4, 5, 6, 3, 8, 1].iter(fn(x) { s += x.to_string() })
  inspect(s, content="123456789")?
  let empty : ImmutableSet[Int] = ImmutableSet::[]
  s = ""
  empty.iter(fn(x) { s += x.to_string() })
  inspect(s, content="")?
}

test "split_bis" {
  inspect(ImmutableSet::[1, 2, 3].split_bis(1), content="Found")?
  inspect(ImmutableSet::[1, 2, 3].split_bis(3), content="Found")?
  inspect(ImmutableSet::[1, 2, 3].split_bis(0), content="NotFound")?
  inspect(ImmutableSet::[1, 2, 3].split_bis(4), content="NotFound")?
}

/// Convert ImmutableSet[T] to List[T], the result must be ordered.
pub fn to_list[T : Compare](self : ImmutableSet[T]) -> List[T] {
  fn values_aux(set : ImmutableSet[T], list : List[T]) {
    match set {
      Empty => list
      Node(~left, ~right, ~value, ..) =>
        values_aux(left, Cons(value, values_aux(right, list)))
    }
  }

  values_aux(self, Nil)
}

// Convert a sorted list into a balanced binary search tree to facilitate subsequent search, insertion, and deletion operations.
fn of_sorted_list[T : Compare](list : List[T]) -> ImmutableSet[T] {
  // Recursively process the input list and build a balanced binary search tree based on the length n of the list.
  fn sub(n : Int, list : List[T]) -> (ImmutableSet[T], List[T]) {
    match (n, list) {
      (0, list) => (Empty, list)
      (1, Cons(value, list)) =>
        (Node(left=Empty, ~value, right=Empty, height=1), list)
      (2, Cons(value, Cons(value1, list))) =>
        (
          Node(
            left=Node(left=Empty, ~value, right=Empty, height=1),
            value=value1,
            right=Empty,
            height=2,
          ),
          list,
        )
      (3, Cons(value, Cons(value1, Cons(value2, list)))) =>
        (
          Node(
            left=Node(left=Empty, ~value, right=Empty, height=1),
            value=value1,
            right=Node(left=Empty, value=value2, right=Empty, height=1),
            height=2,
          ),
          list,
        )

      // For n > 3, the function first calculates the size of the left subtree,
      // and then recursively constructs the left subtree.
      _ => {
        let left_length = n / 2
        let (left, list) = sub(left_length, list)
        match list {
          Nil => abort("of_sorted_list: cannot constructs the left")
          Cons(mid, list) => {
            let (right, list) = sub(n - left_length - 1, list)
            (create(left, mid, right), list)
          }
        }
      }
    }
  }

  sub(list.length(), list).0
}

/// Initialize an ImmutableSet[T] from a List[T]
pub fn ImmutableSet::from_list[T : Compare](list : List[T]) -> ImmutableSet[T] {
  match list {
    Nil => Empty
    // For very small lists, adding values to the set directly using the add function is much faster than sorting and de-important the entire list.
    Cons(value, Nil) => singleton(value)
    Cons(value, Cons(value1, Nil)) => singleton(value).add(value1)
    Cons(value, Cons(value1, Cons(value2, Nil))) =>
      singleton(value).add(value1).add(value2)
    Cons(value, Cons(value1, Cons(value2, Cons(value3, Nil)))) =>
      singleton(value).add(value1).add(value2).add(value3)
    Cons(value, Cons(value1, Cons(value2, Cons(value3, Cons(value4, Nil))))) =>
      singleton(value).add(value1).add(value2).add(value3).add(value4)
    _ => of_sorted_list(list.sort())
  }
}
