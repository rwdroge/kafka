 
 /*------------------------------------------------------------------------
    File        : balance
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : rdroge
    Created     : Mon Apr 25 14:51:02 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

block-level on error undo, throw.

class Bank.Account.Account: 
    
    define property cIBAN as character
    get. set.
    define property dAmount as decimal
    get. set.
    define property balance as decimal
    get. set.
    
    define public event NewDeposit 
    signature void ( input cIBAN as character, input dAmount as decimal, input newBalance as decimal). 

    define public event NewWithdraw 
    signature void ( input cIBAN as character, input dAmount as decimal, input newBalance as decimal). 
    
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    constructor public account (  ):
        
        super ().
        //message "do i even get here 1" view-as alert-box.
    end constructor.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    
    
    method public void deposit  (   input cIBAN as character, input dAmount as decimal  ):
        
        var decimal newBalance = balance + dAmount.
        this-object:NewDeposit:publish(cIBAN, dAmount, newBalance ) no-error.
        
        catch e as Progress.Lang.Error:
            
            message e view-as alert-box.

        end catch.

    end method.    
    
    method public void withdraw (   input cIBAN as character, input dAmount as decimal  ):
        
        var decimal newBalance = balance - dAmount.
        if newBalance <= -0.01 then do:
            undo, 
            throw new Progress.Lang.AppError("Insufficient Funds", 0).
        end.
        else do: 
            this-object:NewWithdraw:publish(cIBAN, dAmount, newBalance ) no-error.
        end.    
        catch e as Progress.Lang.Error:
            message e:GetMessage(1) view-as alert-box. 
        end catch.

    end method.    
    

end class.