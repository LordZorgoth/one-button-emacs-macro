I wrote this function because by default, the emacs keyboard macro system is clunky to access. This was never really intended for public consumption, so it is barely documented. This is how to use it.

1. Execute the ELisp however you prefer.

2. Bind a key to one-button-macro-function, e.g. `(global-set-key [f3] 'one-button-macro-function)`.

3. To record and save a macro, do this: `C-<digit> <your-hotkey> <your-macro> <your-hotkey>`.
This is to say, the hotkey with a numerical prefix argument will record a macro, and pressing the unprefixed hotkey during macro definition will end macro definition and save the macro to the register corresponding to the numerical prefix argument you originally provided.

4. To execute a saved macro, do this: `<your-hotkey> <digit>`. If you press `<digit>` again, the macro will repeat!
When you press the hotkey without a prefix argument while no macro is being defined, the function prompts the user to enter a digit. If the digit corresponds to a saved macro, it will be executed. A convenient side effect of my using registers for this function is that you can press `<digit>` again to repeat the macro, without pressing the hotkey.

5. Emacs, for good reasons, doesn't generally let you execute macros while defining macros. However, I let you do this if you want to. To execute a macro while definining a macro using `<your-hotkey>`, use `C-<other digit> <your-hotkey>` while defining a macro. I have done nothing to make this safer, so use it wisely. I also provided a variable, `one-button-macro-disable-execute-during-definition`, which disables this functionality if set to `t`. 

6. Do not attempt to use the shortcut in 5.\ while n a recursive edit query during a macro definition. Rather, simply execute the macro in the usual way, with no prefix. `defining-kbd-macro` is nil during a recursive edit query, so the prefix key will define a new keyboard macro, which is going to change the value of `one-button-macro-requested-register`. If you accidentally do this, just hit `C-<original-digit> <your-hotkey> C-g` before exiting the recursive edit to make sure `one-button-macro-requested-register` has the correct value.

**Note on Emacs macros**

If you hit C-g during a macro definition, or if any error occurs, you lose the definition. You also lose the definition if you use `isearch-forward` or any other `isearch` function (`C-s`, `C-r`, etc). Use `search-forward`, etc, instead.
