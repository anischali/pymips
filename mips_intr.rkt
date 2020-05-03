#lang racket

(provide (all-defined-out))

;; label (souvent présent dans .data)
(struct Lbl (l))   
;; emplacement mémoire à l'adresse b + valeur du registre r
(struct Mem (b r)) 
;;charger une valeur dans un registre
(struct Li          (r i)               #:transparent)
;;charger dans une adresse
(struct La          (r a)               #:transparent)

;;addition entre registre source et une valeur $rd = $rs + 1
(struct Addi        (rd rs rt)          #:transparent)
;;division entre registre source et un registre source2 $rd = $rs / $rt
(struct Div         (r1 r2)             #:transparent)
;;recuperation de contenu se trouvant dans hi qui contient le reste d'une division(modulo)
(struct Mfhi        (rd)                #:transparent)
;;récupération de contenu se trouvant dant lo qui contient le resultat entier d'une division 
(struct Mflo        (rd)                #:transparent)

;;l'instruction appel system
(struct Syscall     ()                  #:transparent)
;;jump to rigester
(struct Jr          (r)                 #:transparent)
;; faire un label
(struct Label       (l)                 #:transparent)
;; copie le contenu d'un registre dans un autre
(struct Move        (rd rs)             #:transparent)
;; stocke un mot mémoire
(struct Sw          (r loc)             #:transparent)
;; restaure un mot stocké en mémoire
(struct Lw          (r loc)             #:transparent)
;; structure qui prend un opérateur et l'execute sur rs st et stocke le résultat dans rd
(struct Op          (op rd rs rt)       #:transparent)

;; saute au label si le rgistre rs vaut 0 , pour gérer les condition
(struct Beqz        (rs label)          #:transparent)
;; branchement inconditionnel
(struct B           (label)             #:transparent)