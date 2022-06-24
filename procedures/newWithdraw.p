
/*------------------------------------------------------------------------
    File        : newDeposit.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : rdroge
    Created     : Mon May 16 12:11:03 CEST 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
block-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
using bank.account.account.

define variable Account as bank.account.account no-undo.
define variable EventHandler as bank.account.AccountWithdrawnEvent no-undo.

Account = new bank.account.account().
EventHandler = new bank.account.AccountWithdrawnEvent(Account).

Account:withdraw("NL04INGB0006014433", 50.00).

catch e as Progress.Lang.Error :
    message e view-as alert-box.
        
end catch.

