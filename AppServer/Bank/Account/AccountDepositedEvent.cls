 
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

class bank.account.AccountDepositedEvent: 

    define variable PubObj as class Bank.Account.Account no-undo.
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    constructor public AccountDepositedEvent ( input prPubObj as class Bank.Account.Account ):
        
        assign PubObj = prPubObj.
        PubObj:NewDeposit:Subscribe(NewDepositHandler).
                
    end constructor.
    
    method public void NewDepositHandler (input cIBAN as character, input dAmount as decimal, input dnewBalance as decimal).
        
        var kafka.producer producer = new kafka.producer().
        var JsonObject joBody = new JsonObject().
        
        joBody:Add("IBAN", cIBAN).
        joBody:Add("amount", dAmount).
        joBody:Add("new_balance", dnewBalance).
        
        producer:sendKafkaMessage('transactions','deposit', joBody) no-error.
                    
        PubObj:NewDeposit:Unsubscribe( NewDepositHandler ) no-error.
        
        catch e as Progress.Lang.Error:
            message e:GetMessage(1) view-as alert-box.
        end catch.
    end method.    
end class.