#lang racket

(require    "ast.rkt"
            "mips_intr.rkt"
            "parser.rkt"
)

(provide compile)

;;formate les instruction label et les emplacements mémoire
(define (mips-loc loc)
  (match loc
    ((Lbl l)   (format "~a" l))
    ((Mem b r) (format "~a($~a)" b r))))


;;compile les operations arithmitique logique et de comparaisons et les nombre
(define (compil-operation op v1 v2 env fp-sp)
    (append
        (mips-struct-generate v1 env fp-sp)
        (list   (Addi 'sp 'sp -4)
                (Sw 'v0 (Mem 0 'sp)))
        (mips-struct-generate v2 env (- fp-sp 4))
        ;; ensuite on compile v2:
        (list   (Lw 't0 (Mem 0  'sp)) ;; on dépile a
                (Addi 'sp 'sp 4)
                (Move 't1 'v0)) ;; on récupère b
        ;(compile-expression op)
        (cond
            ((equal? op 'Div)   (list (Div 't0 't1) (Mflo 'v0)))
            ((equal? op 'Mod)   (list (Div 't0 't1) (Mfhi 'v0)))
            (else
                (list (Op op 'v0 't0 't1))
            )
        )                  
    )
)

;; garde l'emplacement des variable se trouvant dans la pile dans une table de hashage.
(define fp 0)
;; table de hashage avec les id qui represente les nom de variable et value leur emplacement dans la pile
(define variable-env (make-hash))
;; fonction qui alloue et compile une déclaration de variable
(define (compile-vardef id expr env fp-sp)
    (cond
        ((hash-has-key? variable-env id)
            (append 
                (mips-struct-generate expr env fp-sp)
                (list (Sw 'v0 (Mem (hash-ref variable-env id) 'fp)))        
            )
        )
        (else    
            (hash-set! variable-env id fp)
            (set! fp (- fp 4))
            (append
                (mips-struct-generate expr env fp-sp)
                (list (Sw 'v0 (Mem (+ fp 4) 'fp)))
            )
        )
    )
)

;; table de hashage contenant les label des condition généré avec un random
;; l'id c'est le nombre representant l'ordre d'apparition dans le code.
(define labels (make-hash))
;; le label courant ou moment de compilation d'une codition et c'est un nombre qui represente un id pour labels
;; (hash-ref labels label-curr) et pour surtout controller les labels a mettre dans le if le else et le branchement
;; inconditionnel vers la sortie des conditions  
(define label-curr 0)
;; une liste contenant toute les codition sous la forme de structure de l'ast (Pcond ....)
(define conds  '())
;; variable que j'incrémente au moment ou je génère des structures mips 
(define nbr-cond-labels 0)
;; une liste contenant toute les codition sous la forme de structure mips (Move rd rs)
(define cond-mips '())
;; compte le nombre totale d'un bloc conditionnel
(define nbr-conds 0)
;; la variable sert a ne pas emittre de code assembleur pour des blocs deja traité
(define old-cond-len 0)

;; compte le nombre de conditions presente dans tout le code
(define (count-cond-blocks block)
    (match block
        ((Pcond test yes suite)
            (set! conds (append conds (list (list test yes))))
            (set! nbr-conds (+ nbr-conds 1))
            (hash-set! labels nbr-conds (~a 'cond (random 0 100000)))
            (count-cond-blocks suite)   
        )
        (_
            (set! nbr-conds (+ 0 nbr-conds))
        )
    )
)


;; génére les structure mips de mon ast et les met dans cond mips
(define (compil-conds env fp-sp) 
    (set! cond-mips (append cond-mips
        (list (Label (hash-ref labels nbr-cond-labels)))
        (mips-struct-generate (list-ref (list-ref conds nbr-cond-labels) 0) env fp-sp)
        (list (Beqz 'v0 (hash-ref labels (+ nbr-cond-labels 1))))
        (mips-struct-generate (list-ref (list-ref conds nbr-cond-labels) 1) env fp-sp)
        (list (B (hash-ref labels nbr-conds )))
    ))
    (set! nbr-cond-labels (+ nbr-cond-labels 1))
    (unless (eq? nbr-cond-labels (- nbr-conds 1)) (compil-conds env fp-sp))
)

        

;; la fonction qui match tou l'ast puis fait appel aux défférent fontions de génération des structures mips
(define (mips-struct-generate ast env fp-sp)
    (match ast
        ((Nil)                         (list (Li '0 0)))
        ((Lbl l)                       (list (Label l)))
        ((or (list (Pval n)) (Pval n)) (list (Li 'v0 n)))
        ((or (Pop op v1 v2) (list (Pop op v1 v2)))                
            (compil-operation op v1 v2 env fp-sp)        
        )
        ((or (Pvardecl id expr) (list (Pvardecl id expr))) 
            (compile-vardef id expr env fp-sp)
        )            
        ((or (Pvarref id) (list (Pvarref id)))
            ;;renvoi l'emplacement stocké dans variable-env
            (list (Lw 'v0 (Mem (hash-ref variable-env id) 'fp)))
        )
        ((or (Pcond test yes suite) (list (Pcond test yes suite)))
            ;;génére le dernier label pour le retour au block principale
            (hash-set! labels nbr-conds (~a 'cond (random 0 100000)))
            (count-cond-blocks (Pcond test yes suite))
            (set! old-cond-len (length cond-mips))
            (set! label-curr nbr-cond-labels)
            (compil-conds env fp-sp)
            (append
            (append
                (list (B (hash-ref labels label-curr)))
                ;;je prend que ce qu'est pas compilé auparavant
                (take-right cond-mips (- (length cond-mips) old-cond-len))
                (list (Label (hash-ref labels nbr-conds)))          
            )
            (append
                (list (Label (hash-ref labels (- nbr-conds 1))))
            )
            )
        )
    )
)


;;la fonctions qui génère le code ou les instructions mips.
(define (asm-mips-generate instr)
    (match instr
        ;; récupère le code de l'instruction depuis le parser et le met dans op
        ((Op op rd rs rt)       (printf "~a    $~a, $~a, $~a\n" op rd rs rt))
        
        ((Beqz rs lbl)          (printf "beqz   $~a,~a\n" rs lbl))
        ((B lbl)                (printf "b      ~a\n" lbl))

        ((Li rd i)              (printf "li     $~a, ~a\n" rd i))
        ((Addi rd rs i)         (printf "add    $~a, $~a, ~a\n" rd rs i))
        ((Div r1 r2)            (printf "div    $~a, $~a\n" r1 r2))
        ((Mfhi rd)              (printf "mfhi   $~a\n" rd))
        ((Mflo rd)              (printf "mflo   $~a\n" rd))
        
        ((Jr ra)                (printf "jr     $ra\n"))
        ((Move rd rs)           (printf "move   $~a, $~a\n" rd rs))
        ((Syscall)              (printf "syscall\n"))
        ((Sw r loc)             (printf "sw     $~a, ~a\n" r (mips-loc loc)))
        ((Lw r loc)             (printf "lw     $~a, ~a\n" r (mips-loc loc)))   
        ((Label l)              (printf "~a:\n" l))
        
    )
)

;;print avec saut de ligne
(define (print)

     (printf "move  $a0, $v0\n")
     (printf "li    $v0, 1\nsyscall\n")
     (printf "la    $a0, nl\n")
     (printf "li    $v0, 4\nsyscall\n")
)
     

;;génère les différent data dans les différente sections
(define (mips-data data)
  (printf ".data\n")
  (hash-for-each data
                 (lambda (k v)
                   (printf "~a: .asciiz ~s\n" k v)))
  (printf "\n.text\n.globl main\nmain:\n"))


(mips-data (make-hash '((nl . "\n"))))


;;fonction de sauvegarde fp son utilisation est prévupour les fonctions
(define (save-sp-fp)
    (for-each (lambda (arg)
        (asm-generate arg)
        )
        (list   (list (Addi 'sp 'sp -4)) 
                (list (Sw 'v0 (Mem -4 'sp)))
                (list (Move 'fp 'sp))
                (list (Addi 'sp 'sp -4))
                (list (Sw 'v0 (Mem -4 'sp)))
        )
    )
)

;;prend l'ast et appel dessus generate-code pour générer le code assembleur
(define (ast-mips in env)
    (asm-generate (list (Move 'fp 'sp)))
    (asm-generate (list (Addi 'sp 'sp nbr-var)))
    (for-each (lambda (arg)
            (asm-generate (mips-struct-generate arg env nbr-var))
            (print)

        )
        in
    )
    (asm-generate (list (Addi 'sp 'sp (- nbr-var))))
    (asm-generate (list (Jr 'ra)))
)


;;appel asm-mips-generate une fois que les structure mips ont été généré
(define (asm-generate in)    
    (for-each (lambda (arg)
            (asm-mips-generate arg)
        )
        in
    )
)
;;contient les variables auxquel on reserve de la place
(define vars (make-hash))
;;le nombre final de variable
(define nbr-var 0) 


;;cherche combien de variable déclaré dans tous mon code pour leurs réserver de la mémoire sur la pile
;;tout en gardant l'emplacement dans une table de hashage dédié pour éviter de le cas d'une variable a
;;laquel qui recoit des résultats d'opérations tout au long du code exemple:
;; a = 7
;; a = 7 * 5 ==> dans ce cas grace a la table de hashage on évite de réserver deux mot mémoire.  
(define (var-match ast)
    (match ast
        ((Pvardecl id expr)
            (cond
                ((not (hash-has-key? vars id))
                    (hash-set! vars id nbr-var)
                    (set! nbr-var (- nbr-var 4)))
            )
        )
        ((Pcond test yes suite)
            (var-match yes)
            (var-match suite)
        )
        ((Nil)
            (set! nbr-var nbr-var)
        )
    )
)

;;fonction de parcours de l'ast pour les passer a var-match
(define (var-mem in)
    (for-each (lambda (arg)
            (var-match arg)
        )
        in
    )
    
)
;;fonction appelé en entré de compilateur et qui appel avant le parser
;;et var-mem qui alloue de la mémoire
(define (compile in)
    (define parsed (pymips-parser in))
    (var-mem parsed)
    (ast-mips parsed (make-immutable-hash))
    
)
