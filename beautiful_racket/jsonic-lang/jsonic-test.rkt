#lang jsonic
[
  null,
  42,
  true,
  ["array", "of", "strings"],
  {
    "key-1": null,
    "key-2": false,
    "key-3": {"subkey": 21}
  },
  @$ (+ 1 1) $@,
  // a line comment
  @$ 'null $@,
  @$ (/ 8 4) $@,
  @$ (= 2 (+ 1 1)) $@,
  @$ (list "array" "of" "strings") $@,
  @$ (hash 'key-1 'null
           'key-2 (even? 3)
           'key-3 (hash 'subkey 21)) $@
]
