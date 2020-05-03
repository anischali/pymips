#lang racket

(require "parser.rkt"
         "compil.rkt")

(define argv (current-command-line-arguments))
(cond
  ((>= (vector-length argv) 1)
   (define in (open-input-file (vector-ref argv 0)))
   (port-count-lines! in)
   (define ret (compile in))
   (newline)
   (exit ret))
  
  (else
   (eprintf "Usage: racket pymips.rkt <source.py>\n")
   (exit 1)))