#lang brag
a-program : (a-expr | a-escaped-at | a-literal)*
a-expr : /a-at /WHITESPACE* @a-expr-name [/WHITESPACE+ a-expr-args] /WHITESPACE+ a-expr-body /WHITESPACE* /a-at
a-expr-name : WORD
/a-expr-args : [@a-arg-key /WHITESPACE* /COLON /WHITESPACE* @a-arg-value /WHITESPACE+]* @a-arg-key /WHITESPACE* /COLON /WHITESPACE* @a-arg-value
/a-expr-body : @a-program
a-arg-key : WORD
a-arg-value : WORD
a-at : AT
a-escaped-at : /ESCAPED-AT
a-literal : WHITESPACE | WORD | COLON
