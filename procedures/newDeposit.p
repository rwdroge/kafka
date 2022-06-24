
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
define variable EventHandler as bank.account.AccountDepositedEvent no-undo.

Account = new bank.account.account().
EventHandler = new bank.account.AccountDepositedEvent(Account).

Account:deposit("NL04INGB0006014433", 50.00).


