
/*------------------------------------------------------------------------
    File        : startConsumer.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : rdroge
    Created     : Wed May 18 08:30:43 CEST 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


block-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */
using kafka.consumer.
using Progress.Json.ObjectModel.*.


/* ***************************  Main Block  *************************** */
var kafka.consumer consumer.
var JsonObject joResponse.

consumer = new kafka.consumer("my-topic").

joResponse = consumer:getMessage() no-error.

message string(joResponse:GetJsonText()) view-as alert-box.



 