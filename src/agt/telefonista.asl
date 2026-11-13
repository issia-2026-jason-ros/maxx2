// UUID do agente do semaforo (iotCommunicator) no ContextNet
semaforo("58c8b3e1-068f-45f9-8367-52df2c5d73d3").
intervalo_consulta(1000).   // ms entre cada consulta ao semaforo

!connect.

+!connect <- .connectCN("skynet.chon.group",5000,"4e4a4441-9cd7-435d-a69c-02e5b9d7d3d8").

+!hello[source(Human)] <- .sendOut(Human,tell,"Hello Human!!!").

// +!hello[source(58c8b3e1-068f-45f9-8367-52df2c5d73d3)] <- .sendOut(58c8b3e1-068f-45f9-8367-52df2c5d73d3,askOne,status(C)).

+!turnOff[source(Human)] <- .print("closing"); .stopMAS.

+hermes::contextNetConfiguration(_,Server,Port,ID,Status,_) <-
    .print("Server ",Server," status=",Status);
    .print("Messenger with me at http://skynet.chon.group:5000/en?ip=",Server,"&port=",Port,"&agentUUID=",ID,"&userUUID=auto&strength=achieve&message=hello");
    !iniciar_consulta.   // conectado: comeca a consultar o semaforo


// =====================================================================
// SEMAFORO -> atualiza a crenca sinal(Cor)
// =====================================================================

// Garante um unico loop de consulta (contextNetConfiguration pode disparar mais de uma vez)
+!iniciar_consulta : .intend(consultar_semaforo) <- true.
+!iniciar_consulta <- !!consultar_semaforo.

// Pergunta ao iotCommunicator qual e a crenca status(Cor) dele
+!consultar_semaforo : semaforo(UUID) & intervalo_consulta(T) <-
     .sendOut(UUID, askOne, status(Cor));
     .wait(T);
     !consultar_semaforo.

// Se a consulta falhar, tenta de novo em vez de parar o loop
-!consultar_semaforo : intervalo_consulta(T) <-
     .print("Falha ao consultar o semaforo, tentando novamente");
     .wait(T);
     !consultar_semaforo.

// Resposta do askOne chega como crenca status(Cor)
// (o semaforo tambem pode mandar TELL status(Cor) por conta propria)
+status(Color)[source(S)] <-
     .abolish(status(_));          // limpa para que a proxima resposta dispare de novo
     !atualizar_sinal(Color).

// Usuario pode informar a cor manualmente: ACHIEVE traffic_light(red)
+!traffic_light(Color)[source(Human)] <-
     .sendOut(Human,tell,"Sinal recebido!!!");
     !atualizar_sinal(Color).

// Aceita tanto red quanto "red" (string)
+!atualizar_sinal(Color) : .string(Color) <-
     .term2string(C, Color);
     !atualizar_sinal(C).

// Mesma cor de antes: nao faz nada (evita mandar go/stop a cada consulta)
+!atualizar_sinal(Color) : sinal(Color) <- true.

// Cor mudou: atualiza e decide
+!atualizar_sinal(Color) <-
     .print("Semaforo mudou para: ", Color);
     -+sinal(Color);
     !decidir.


// =====================================================================
// USUARIO -> pede para andar / parar
// =====================================================================

// No Messenger BDI: performativa ACHIEVE + mensagem "walk"  -> chega como +!walk
+!walk[source(Human)] <- !pedir_walk(Human).

// Compatibilidade: performativa ACHIEVE + mensagem "achieve(walk)"
+!achieve(walk)[source(Human)] <- !pedir_walk(Human).

+!pedir_walk(Human) <-
     +quer_andar;
     .sendOut(Human,tell,"Walk recebido!!!");
     !decidir.

// ACHIEVE stop
+!stop[source(Human)] <-
     -quer_andar;
     .sendOut(Human,tell,"Stop recebido, parando!!!");
     !decidir.

// SENAO (qualquer outro achieve(CMD)) -> carrinho para
+!achieve(CMD)[source(Human)] <-
     -quer_andar;
     .sendOut(Human,tell,"Comando desconhecido, parando!!!");
     !decidir.

+!unachieve(CMD)[source(Human)] <-
     .sendOut(Human,tell,"UnAchieve recebido!!!");
     !enviar_carrinho(unachieve,CMD).


// =====================================================================
// DECISAO (unico ponto que manda o carrinho andar ou parar)
//   SE pediu walk E sinal == green  -> anda
//   SENAO (red, blue, sem sinal, sem pedido) -> para
// =====================================================================
+!decidir : quer_andar & sinal(green) <-
     .print("Sinal VERDE: carrinho anda");
     !enviar_carrinho(achieve,go).

+!decidir : sinal(Color) <-
     .print("Sinal ", Color, ": carrinho para");
     !enviar_carrinho(achieve,stop).

+!decidir <-
     .print("Sem sinal conhecido: carrinho para");
     !enviar_carrinho(achieve,stop).


// =====================================================================
// ENVIO AO CARRINHO (so envia se o chonbot_agent existir)
// =====================================================================
+!enviar_carrinho(Perf,CMD) : .all_names(L) & .member(chonbot_agent,L) <-
     .send(chonbot_agent,Perf,CMD).

+!enviar_carrinho(Perf,CMD) <-
     .print("AVISO: chonbot_agent nao existe (falhou ao iniciar? ROS/rosbridge em ws://localhost:9090 acessivel?). Comando '",CMD,"' nao enviado.").
