
/*------------------------------------------------------------------------
    File        : transactional_producer.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : rdroge
    Created     : Thu Oct 13 08:24:41 CEST 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

using OpenEdge.Messaging.*.
using Progress.Json.ObjectModel.*.
using OpenEdge.Messaging.Kafka.KafkaProducerBuilder from propath.
using OpenEdge.Core.Util.ConfigBuilder from propath.

block-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

var RecordBuilder recordBuilder.
var TopicConfigurationBuilder topicConfigBuilder.
var KafkaProducerBuilder kpb.
var ITransactionalProducer producer.
var JsonObject msgbody.
var IProducerRecord record.
var IProducerRecord record2.
     
kpb = cast(ProducerBuilder:Create("progress-kafka"), KafkaProducerBuilder).
kpb:SetBootstrapServers("localhost:9092").
kpb:SetBodySerializer(new JsonSerializer()).


// To indicate the need for a transactional producer, 
//   set the TransactionalId producer option.
kpb:SetTransactionalId("some.unique.value").
 
// In order to use the transactional producer methods, 
//   cast the newly built producer to ITransactionalProducer.
producer = cast(kpb:Build(), ITransactionalProducer).
 
// Call InitTransactions() to ensure any outstanding transactions for the given
//   transactional id are completed properly.
producer:InitTransactions().
 
recordBuilder = producer:RecordBuilder.
 
recordBuilder:SetTopicName("my-topic").
     
msgBody = new JsonObject().
msgBody:Add("name", "Lift Line Skiing").
msgBody:Add("address", "1 Main Street").
     

recordBuilder:SetBody(msgBody).
record = recordBuilder:Build().
 
// Begin a transction before sending any records
producer:BeginTransaction().

producer:Send(record).
producer:Send(record).
 
// Commit any outstanding records.
producer:CommitTransaction().
     
        
catch e as Progress.Lang.Error :
    message e:GetMessage(1) view-as alert-box.
    producer:AbortTransaction() no-error.
end catch.