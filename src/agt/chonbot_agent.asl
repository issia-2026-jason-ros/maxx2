!start.
// !walk.        // nao anda sozinho: quem manda andar e o telefonista (achieve go)
!alert_blink.    //blink alert lights when not moving forward

+!start : .my_name(Me)
   <- //.move("forward");
      .print("Hello from ", Me).


// =====================================================================
// Comandos vindos do telefonista
// =====================================================================

// go: inicia o loop de walk (se ja estiver andando, nao cria outro loop)
+!go : .desire(walk)
   <- .print("Ja estou andando").

+!go
   <- !!walk.

// stop: cancela o loop de walk e para o carrinho
+!stop
   <- .drop_desire(walk);
      .print("Parando");
      .brakeLight(true);
      .move("stop").


// =====================================================================
// Loop de walk (anda e desvia de obstaculos)
// =====================================================================

+!walk : distance(D) & D <= 50
   <- .print("Obstacle...") ;
      .brakeLight(true);           //brakeLight on
      .motorSpeed("low");          //slow down
      .move("backward");           //move backward for 1 second
      .wait(2000);
      .move("stop");               //stop for 500 milliseconds
      .wait(500);
      .move("right");              //move right for 2 seconds
      .wait(2000);
      .move("stop");
      !walk.

+!walk
   <- .move("forward");         .wait(300); //nao aciona os motores, apesar de escrever no topico
      .turnSignal("off");       .wait(300);
      .brakeLight(false);       .wait(300);
      .motorSpeed("default");   .wait(300);
      .print("Moving forward");
      .wait(distance(D) & D <= 50);   // acorda com obstaculo (o sinal vermelho/azul chega via !stop)
      !walk.


// =====================================================================
// Luzes de alerta
// =====================================================================

+!alert_blink : not motor_status("running")
   <- .turnSignal("alert");           //alert light on
      .wait(500);
      .turnSignal("off");            //alert light off
      .wait(300);
      !alert_blink.

+!alert_blink
   <- .wait( motor_status(S)&S\=="running");
      !alert_blink.

+distance(D)
   <- .print("Distance: ", D).
