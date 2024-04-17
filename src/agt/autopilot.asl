
+!stop_mission
   <- .drop_intention(run_plan(_)).

+!run_plan([])[source(Ag)]
   <- .send(Ag,signal,finished).

+!run_plan([Step|T])[source(Ag)]
   <- !do(Step,Ag,T); !run_plan(T)[source(Ag)].

+!do(Step,Ag,Rem)
   <- .print("doing ",Step);
      .send(Ag,achieve,update_rem_plan(Step,5,Rem));
      .wait(1000);
   .   

!consume_energy(1000). // it initially has 1000 of energy
+!consume_energy(E)    // that decais 10 units each second
   <- .send(bob2,achieve,update_energy(E));
      .wait(1000);
      !consume_energy(E-10).
