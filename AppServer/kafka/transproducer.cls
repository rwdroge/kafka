 
 /*------------------------------------------------------------------------
    File        : transproducer
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : rdroge
    Created     : Mon May 16 13:20:36 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Messaging.IProducer from propath.
using OpenEdge.Messaging.ProducerBuilder from propath.
using OpenEdge.Messaging.IProducerRecord from propath.
using OpenEdge.Messaging.RecordBuilder from propath.
using OpenEdge.Messaging.ISendResponse from propath.
using OpenEdge.Messaging.Kafka.*.
using Progress.Json.ObjectModel.*.

block-level on error undo, throw.

class kafka.transproducer: 

    var RecordBuilder recordBuilder.
    var ProducerBuilder pb.
    var IProducer producer.
    var IProducerRecord record.
    var ISendResponse response.
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    constructor public transproducer ():
        pb = ProducerBuilder:Create("progress-kafka").
        pb:SetProducerOption("bootstrap.servers", "localhost:9092").
        pb:SetProducerOption("value.serializer", "OpenEdge.Messaging.JsonSerializer").
        pb:SetProducerOption("key.serializer", "OpenEdge.Messaging.StringSerializer").

        /* Optionally set message.timeout.ms. In case of a mistake/typo in bootstrap
          servers, this will make it time out sooner. Otherwise, it can sit for a long time 
          waiting for the Send to complete and show an error. */
        pb:SetProducerOption("message.timeout.ms", "10000").
        producer = pb:Build().

        
    end constructor.

    method public void sendKafkaMessage(input cTopicName as character, input cKeyName as character, input joBody as JsonObject):
        recordBuilder = producer:RecordBuilder.
        recordBuilder:SetTopicName(cTopicName).
        recordBuilder:SetPartitionKey(cKeyName).
        recordBuilder:SetBody(joBody).
        record = recordBuilder:Build().

        response = producer:Send(record).
    
        producer:Flush(1000).
    
        repeat while not response:Completed:
            pause .1 no-message.
        end.

        if response:Success then do:
            message "Send successful" view-as alert-box.
        end.
        else do:
            undo, throw new Progress.Lang.AppError("Failed to send the record: " +
                response:ErrorMessage, 0).
        end.
    
        catch err as Progress.Lang.Error :
            message 
                err:GetMessage(1) skip(2) 
                err:CallStack 
            view-as alert-box.
        end catch.

        finally:
            delete object producer no-error.
        end.

end method.
        
end class.