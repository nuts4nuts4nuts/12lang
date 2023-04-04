#lang brag
a-program : (a-expr | a-whitespace | a-word | a-escaped-at | a-colon)*
a-expr : a-at a-whitespace* a-expr-name [a-whitespace+ a-expr-args] a-whitespace+ a-expr-body a-whitespace* a-at
a-expr-name : WORD
a-expr-args : [a-arg-key /a-whitespace* /a-colon /a-whitespace* a-arg-value /a-whitespace+]* a-arg-key /a-whitespace* /a-colon /a-whitespace* a-arg-value
a-expr-body : a-program
a-arg-key : WORD
a-arg-value : WORD
a-at : /AT
a-escaped-at : /ESCAPED-AT
a-word : WORD
a-whitespace : WHITESPACE
a-colon : /COLON
