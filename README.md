# Kafka and ABL integration

## Prerequisites

- OpenEdge 12.5 or higher
- Docker (and docker compose)


These are examples of i.e. ABL events publishing these events as Kafka messages to a Kafka broker.
There's both a producer (creating Kafka messages) and a consumer (listening for Kafka topics) available.

Note that these examples will only work with OpenEdge 12.5 or higher, since it uses the OpenEdge Messaging (and Kafka) libraries.
I've included the Kafka binaries required by the AVM to this repository, if that does not work, make sure to read instructions how to setup your OE/Kafka environment here: 

https://docs.progress.com/bundle/openedge-kafka-guide/page/How-to-Set-Up-Apache-Kafka-with-Progress-OpenEdge.html

## Getting started:

- Clone the repository
- Open PDSOE and import the new folder as existing project into PDSOE workspace
- Navigate with CMD to the 'docker' folder inside the repository and execute this command:
``` 
docker-compose up
```
- Now use the different procedures in the 'procedures' folder to start the producer/consumer and create/listen for Kafka messages   
