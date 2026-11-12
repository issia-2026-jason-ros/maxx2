!start.
!walk.           //move forward and avoid obstacles
!alert_blink.    //blink alert lights when not moving forward

+!start : .my_name(Me)
   <- //.move("forward");
      .print("Hello from ", Me).


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



// Sinal vermelho: para e espera ficar verde antes de continuar
+!walk : traffic_light(red)
   <- .print("Sinal vermelho, parado");
      .move("stop");
      .brakeLight(true);
      .wait(traffic_light(green));
      .print("Sinal verde, seguindo");
      !walk.

+!walk
   <- //.turnSignal("off");
      //.brakeLight(false);
      //.motorSpeed("default");
      //.wait(500);
      .move("forward");         .wait(300); //n  o aciona os motores, apesar de escrever no t  pico
      .turnSignal("off");       .wait(300);
      .brakeLight(false);       .wait(300);
      .motorSpeed("default");   .wait(300);
      .print("Moving forward");
      .wait((distance(D) & D <= 50) | traffic_light(red)); // acorda com obstaculo OU sinal vermelho
      //.wait(2000);
      !walk;
      .


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

// Reação imediata à mudança do sinal (o carrinho já pode estar andando)
// Garante que só existe a crença do sinal atual
+traffic_light(red)[source(_)]
   <- -traffic_light(green)[source(_)];
      .print("Sinal VERMELHO: parando");
      .brakeLight(true);
      .move("stop").

+traffic_light(green)[source(_)]
   <- -traffic_light(red)[source(_)];
      .print("Sinal VERDE: andando");
      .brakeLight(false);
      .move("forward").

