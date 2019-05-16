(setq one-button-macro-requested-register nil)
(setq one-button-macro-prefixes '(0 1 2 3 4 5 6 7 8 9))
(setq one-button-macro-disable-execute-during-definition nil)

(defun one-button-macro-function (prefix) (interactive "P")
       (if (and prefix
    		(member prefix one-button-macro-prefixes))
    	   (let ((register
		  (one-button-macro-translate-prefix-to-char prefix)))
    	     (if (or defining-kbd-macro executing-kbd-macro)
		 ;; This allows the user to "chain" macros by executing
		 ;; a macro during definition. Use with caution.
		 ;; Does not allow autofilling of recursive edit queries.
    		 (if one-button-macro-disable-execute-during-definition
		     (error "Macro execution during macro definition disabled.")
		   (one-button-macro-execute-during-definition register))
	       ;; Start recording a keyboard macro
    	       (kmacro-start-macro nil)
	       (setq one-button-macro-requested-register register)))
	 ;; If no prefix is used, we start here. If we are currently
	 ;; defining a macro, we save it. Otherwise, we prompt the user
	 ;; to pick a macro to execute.
    	 (if defining-kbd-macro
    	     (one-button-macro-save-to-register
	      one-button-macro-requested-register)
	   (one-button-macro-execute))))

(defun one-button-macro-execute (&optional register)
  (or register
      (setq register
    	    (read-char
	     "Please select a register containing a keyboard macro:")))
  ;; The if statement here is confirming that there is a macro in the register.
  (if (cl-search "kmacro-execute-from-register"
    		 (format "%s" (get-register register)))
      (jump-to-register register)
    (error "Error: not a keyboard macro.")))

(defun one-button-macro-save-to-register (register)
  (ignore-errors (kmacro-end-macro nil))
  (kmacro-to-register register)
  (print (concat "Saved keyboard macro to register "
		 (char-to-string register)))
  (setq one-button-macro-requested-register nil))

(defun one-button-macro-execute-during-definition (prefix-or-register)
  (interactive "P")
  (let ((register	
	 (if (> prefix-or-register 9)
	     prefix-or-register     
	   (one-button-macro-translate-prefix-to-char prefix-or-register))))
    ;; The if statement here is confirming that there is a macro in the register.
    (if (equal register one-button-macro-requested-register)
	(print "Refusing to execute macro within itself.")
      (if (cl-search "kmacro-execute-from-register"
    		     (format "%s" (get-register register)))
	  (ignore-errors (execute-kbd-macro (elt (get-register register) 1)))
	(error "Error: not a keyboard macro")))))

(defun one-button-macro-translate-prefix-to-char (prefix)
  (+ prefix 48))
