#lang s-exp framework/keybinding-lang

(keybinding "c:space" (λ (editor event) (send editor auto-complete)))
(keybinding "c:d" (λ (editor event) (send editor delete-line)))
