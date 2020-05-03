#lang racket

(require parser-tools/lex
         (prefix-in : parser-tools/lex-sre))

(provide    pymips-lex    
            punctuations
            operators
            values
            (struct-out position)
)



(define-empty-tokens operators
    (Leof 
    Lif Lelif Lelse
    Lln Ladd Lsub Lmul Ldiv Lmod 
    Land Lor Lxor Lnot 
    Leq Lneq Lgt Llt Lgte Llte
    Lassign
    )
)

(define-empty-tokens punctuations
    (Lopar Lcpar Locr Lccr)
)

(define-tokens values
    (Lnum Lid)
)



(define pymips-lex
    (lexer-src-pos
        ((eof)                              (token-Leof))
        (whitespace                         (return-without-pos (pymips-lex input-port)))
        ("if"                               (token-Lif))
        ("elif"                             (token-Lelif))
        ("else"                             (token-Lelse))
        ("\\n"                              (return-without-pos pymips-lex input-port))
        ("="                                (token-Lassign))
        ("+"                                (token-Ladd))
        ("-"                                (token-Lsub))
        ("*"                                (token-Lmul))
        ("/"                                (token-Ldiv))
        ("%"                                (token-Lmod))
        
        ("not"                              (token-Lnot))
        ("and"                              (token-Land))
        ("or"                               (token-Lor))
        ("^"                                (token-Lxor))
        
        ("=="                               (token-Leq))
        ("!="                               (token-Lneq))
        (">"                                (token-Lgt))
        (">="                               (token-Lgte))
        ("<"                                (token-Llt))
        ("<="                               (token-Llte))

        ("("                                (token-Lopar))
        (")"                                (token-Lcpar))
        ("{"                                (token-Locr))
        ("}"                                (token-Lccr)) 
        ((:+ numeric)                       (token-Lnum (string->number lexeme)))
        ((:+ alphabetic)                    (token-Lid (string->symbol lexeme)))

        
        (any-char   (begin
                 (eprintf "Lexer: ~a: unrecognized char at line ~a col ~a.\n"
                          lexeme (position-line start-pos) (position-col start-pos))
                 (exit 1)))
    )
)



;(call-with-input-string "a = 21" pymips-lex)