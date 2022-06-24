 
 /*------------------------------------------------------------------------
    File        : consumer
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : rdroge
    Created     : Tue May 17 11:28:24 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Messaging.IConsumer from propath.
using OpenEdge.Messaging.IConsumerRecord from propath.
using Progress.Json.ObjectModel.JsonConstruct from propath.
using Progress.Json.ObjectModel.JsonObject from propath.
using OpenEdge.Messaging.Kafka.KafkaConsumerBuilder from propath.
using OpenEdge.Messaging.ConsumerBuilder from propath.
using OpenEdge.Messaging.Kafka.AutoOffsetReset from propath.

class kafka.consumer: 

    var KafkaConsumerBuilder cb.
    var IConsumer consumer.
    var IConsumerRecord record.
    var JsonObject messageBody.
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    constructor public consumer ( input cTopicName as character  ):
        super ().
        cb = cast(ConsumerBuilder:Create("progress-kafka"), KafkaConsumerBuilder).
 
        // Kafka requires at least one bootstrap server host and port.
        cb:SetBootstrapServers("localhost:9092").
        // enable auto commit which will automatically acknowledge each received message.
        cb:SetEnableAutoCommit(true).
        // Identify the consumer group. The consumer group allows multiple clients to
        //  coordinate the consumption of multiple topics and partitions
        cb:SetGroupId("consumergroup_1").
        // Specifies whether the consumer group should automatically be deleted when
        //  the consumer is garbage collected. 
        cb:SetAutoDeleteConsumerGroup(false).
        // Set the client id. This allows group rejoin to work efficiently. Each client
        //  in the group needs to have a unique id.
        cb:SetClientId("progress_client").
        cb:SetBodyDeserializer(new OpenEdge.Messaging.JsonDeserializer()).
        
        // Set the consumer starting position to the most recent (latest) message
        cb:SetAutoOffsetReset(AutoOffsetReset:Latest).
        // identify one or more topics to consume
        cb:AddSubscription(cTopicName).
        // build the consumer
        consumer = cb:Build().
        
    end constructor.
    
    method public JsonObject getMessage ():
        repeat while true:
            // request a record, waiting up to 1 second for some records to be available
            record = consumer:Poll(1000).
             
            if valid-object(record) then do: 
                
                messageBody = cast(record:Body, JsonObject).
                messageBody:Add("timestamp", record:Timestamp).    
                return messageBody.
            end.
             
        end.
      
        catch err as Progress.Lang.Error :
            message err:GetMessage(1) view-as alert-box.
        end catch.

        finally:
        delete object consumer no-error.
        end.
    end method. 

end class.