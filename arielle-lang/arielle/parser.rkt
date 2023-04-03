#lang brag
a-program : (a-expr | a-whitespace | a-word | a-char)*
a-expr : "@" "(" a-whitespace* a-expr-name a-whitespace+ [a-expr-args] a-whitespace+ a-expr-body a-whitespace* ")"
a-expr-name : WORD
a-expr-args : [a-arg-key a-whitespace* ":" a-whitespace* a-arg-value "," a-whitespace*]* a-arg-key a-whitespace* ":" a-whitespace* a-arg-value
a-arg-key : WORD
a-arg-value : WORD
a-expr-body : a-program
a-word : WORD
a-whitespace : WHITESPACE
a-char : ("@" | "(" | ")" | ":" | ",")
