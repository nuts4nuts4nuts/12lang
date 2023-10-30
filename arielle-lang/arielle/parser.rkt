#lang brag
a-program : (a-expr | WORD | WHITESPACE | COLON | ESCAPED-OPEN-AMAL | ESCAPED-COLON)*

a-expr : OPEN-AMAL WORD WHITESPACE* [@a-args] WHITESPACE* @a-body CLOSE-PAREN
a-args : (WORD WHITESPACE* COLON WHITESPACE* WORD)+
a-body : /a-program
