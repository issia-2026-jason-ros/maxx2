!connect.



+!connect <- .connectCN("skynet.chon.group",5000,"4e4a4441-9cd7-435d-a69c-02e5b9d7d3d8").

+!hello[source(58c8b3e1-068f-45f9-8367-52df2c5d73d3)] <- .sendOut(58c8b3e1-068f-45f9-8367-52df2c5d73d3,askOne,status(C)).

+!turnOff[source(Human)] <- .print("closing"); .stopMAS.

+hermes::contextNetConfiguration(_,Server,Port,ID,Status,_) <-
    .print("Server ",Server," status=",Status);
    .print("Messenger with me at http://skynet.chon.group:5000/en?ip=",Server,"&port=",Port,"&agentUUID=",ID,"&userUUID=auto&strength=achieve&message=hello").

+!achieve(CMD)[source(Human)] <-
     .sendOut(Human,tell,"Achieve recebido!!!");
     .send(chonbot_agent,achieve,CMD).

// Recebe o estado do sinal (red/green) e repassa ao carrinho
+!traffic_light(Color)[source(Human)] <-
     .sendOut(Human,tell,"Sinal recebido!!!");
     .send(chonbot_agent,tell,traffic_light(Color)).

+!unachieve(CMD)[source(Human)] <-
     .sendOut(Human,tell,"UnAchieve recebido!!!");
     .send(chonbot_agent,unachieve,CMD).