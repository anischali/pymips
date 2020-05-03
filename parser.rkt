#lang racket

(require parser-tools/yacc
         "lexer.rkt"
         "ast.rkt")

(provide pymips-parser)



(define parse
    (parser
        (src-pos)
        (tokens operators values punctuations) 
        (start prog)
        (end Leof)
        (grammar
            (prog
                ((def prog)                               (cons $1 $2))
                ((def)                                    (list $1))
            )
            (def
                ((vardecl)                                  $1)
                ((cexpr)                                    $1)
                ((test)                                     $1)
            )
            (vardecl
                ((Lid Lassign cexpr)                    (Pvardecl $1 $3))
            )   
            (cexpr
                ((Lopar expr Lcpar)                         $2)
                ((expr)                                     $1)
            )
            (expr                    
                ((cexpr Ladd cexpr)                         (Pop 'add $1 $3))
                ((cexpr Lsub cexpr)                         (Pop 'sub $1 $3))
                ((cexpr Lmul cexpr)                         (Pop 'mul $1 $3))
                ((cexpr Ldiv cexpr)                         (Pop 'Div $1 $3))
                ((cexpr Lmod cexpr)                         (Pop 'Mod $1 $3))
                
                ((Lnot cexpr)                               (Pop 'seq (Pval 0) $2))
                ((cexpr Land cexpr)                         (Pop 'and $1 $3))
                ((cexpr Lor cexpr)                          (Pop 'or $1 $3))
                ((cexpr Lxor cexpr)                         (Pop 'xor $1 $3))
                
                ((cexpr Leq cexpr)                          (Pop 'seq $1 $3))
                ((cexpr Lneq cexpr)                         (Pop 'sne $1 $3))
                ((cexpr Lgt cexpr)                          (Pop 'sgt $1 $3))
                ((cexpr Lgte cexpr)                         (Pop 'sge $1 $3))
                ((cexpr Llt cexpr)                          (Pop 'slt $1 $3))
                ((cexpr Llte cexpr)                         (Pop 'sle $1 $3))

                ((val)                                      $1)
                ((varref)                                   $1)   
            )
            (test
                ((Lif cexpr Locr def Lccr suite)            (Pcond $2 $4 $6))
            )
            (suite
                ((Lelif cexpr Locr def Lccr suite)          (Pcond $2 $4 $6))
                ((Lelse Locr def Lccr)                      (Pcond (Pval 1) $3 (Nil)))
                (()                                         (Nil))
            )
            (varref
                ((Lid)                                      (Pvarref $1))
            )
            (val
                ((Lnum)                                     (Pval $1))
            )
        )
        (precs      
                    (left Lor)
                    (left Lxor)
                    (left Land)
                    (left Lnot)

                    (left Leq)
                    (left Lneq)
                    (left Llt)
                    (left Lgt)
                    (left Llte)
                    (left Lgte)

                    (left Lmod)
                    (left Ladd)
                    (left Lsub)
                    (left Lmul)
                    (left Ldiv)
        )
        (error
            (lambda (ok? name value s-pos e-pos)
                (eprintf "Parser: ~a: ~a~a on line ~a col ~a.\n"
                (substring (symbol->string name) 1)
                (if ok? "syntax error" "unexpected token")
                (if value (format " near '~a'" value) "")
                (position-line s-pos)
                (position-col s-pos))
        (exit 1)))
    )

)

    



(define (pymips-parser in)
    (parse (lambda ()(pymips-lex in)))
)


;(define (compil-inter in)
 ;   (pymips-ast_mips (lambda ()(pymips-parser in))
                     
  ;                   0)
    
;)

;(define (pymips-compil in)
 ;   (pymips-generate (lambda ()(compil-inter in)))
;)

;(define z (call-with-input-string "4 + 6" pymips-parser))
;(displayln z)

