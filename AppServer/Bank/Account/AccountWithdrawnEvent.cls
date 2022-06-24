 
 /*------------------------------------------------------------------------
    File        : AccountDepositedEvent
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : rdroge
    Created     : Mon May 16 11:59:16 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using kafka.producer.*.
using Progress.Json.ObjectModel.*.

block-level on error undo, throw.

class bank.account.AccountWithdrawnEvent: 

    define variable PubObj as class Bank.Account.Account no-undo.
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    constructor public AccountWithdrawnEvent ( input prPubObj as class Bank.Account.Account ):
        
        assign PubObj = prPubObj.
        PubObj:NewWithdraw:Subscribe(NewWithdrawHandler).
                
    end constructor.
    
    method public void NewWithdrawHandler (input cIBAN as character, input dAmount as decimal, input dnewBalance as decimal).
        
        var kafka.producer producer = new kafka.producer().
        var JsonObject joBody = new JsonObject().
        
        joBody:Add("IBAN", cIBAN).
        joBody:Add("amount", dAmount).
        joBody:Add("new_balance", dnewBalance).
        
        producer:sendKafkaMessage("transactions", "withdraw", joBody) no-error.
                    
        PubObj:NewWithdraw:Unsubscribe( NewWithdrawHandler ) no-error.
        
        /* catch e as Progress.Lang.Error:
            message e:GetMessage(1) view-as alert-box.
        end catch.
        */
    end method.    
end class.