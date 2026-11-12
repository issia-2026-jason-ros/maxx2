!connect.

+!connect <- .connectCN("skynet.chon.group",5000,"4e4a4441-9cd7-435d-a69c-02e5b9d7d3d8").

+!hello[source(Human)] <- .sendOut(Human,tell,"Hello Human!!!").

+!turnOff[source(Human)] <- .print("closing"); .stopMAS.

+hermes::contextNetConfiguration(_,Server,Port,ID,Status,_) <-
    .print("Server ",Server," status=",Status);
    .print("Messenger with me at http://skynet.chon.group:5000/en?ip=",Server,"&port=",Port,"&agentUUID>).
+!achieve(CMD)[source(Human)] <-
     .sendOut(Human,tell,"Achieve recebido!!!");
     .send(chonbot_agent,achieve,CMD).

+!unachieve(CMD)[source(Human)] <-
     .sendOut(Human,tell,"UnAchieve recebido!!!");
     .send(chonbot_agent,unachieve,CMD).




