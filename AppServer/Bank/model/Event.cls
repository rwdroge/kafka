 
 /*------------------------------------------------------------------------
    File        : event
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : rdroge
    Created     : Tue May 10 10:42:04 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

block-level on error undo, throw.

class bank.model.Event abstract: 
    
    define final property aggregateID as int64 no-undo get. set.
    define final property timestamp as datetime no-undo get. set.
    define final property iversion as integer no-undo get. set.
    
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    constructor protected Event (  ):
        super ().
        assign 
            aggregateID = aggregateID
            timestamp = timestamp
            iversion = iversion
            .
        
    end constructor.



    
    method public int64 getAggregateId():
        return aggregateID.
    end method.
    
    method public datetime getTimestamp():
        return timestamp.
    end method.
    
    method public integer getVersion():
        return iversion.
    end method.
        

end class.