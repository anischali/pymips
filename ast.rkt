#lang racket

(provide (all-defined-out))
;vide
(struct Nil         ()                          #:transparent)
;;valeur entiere
(struct Pval        (val)                       #:transparent)
;;operation logique + arthmétique + comparaison
(struct Pop         (op v1 v2)                  #:transparent)
;;la declaration de variables
(struct Pvardecl    (id expr)                   #:transparent)
;;l'appel de variable
(struct Pvarref     (id)                        #:transparent)
;;;structure pour les conditions
(struct Pcond       (test yes suite)            #:transparent)
