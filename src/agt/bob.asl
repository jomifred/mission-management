
{ include("mission-management.asl", mm) }


!my_missions.
+!my_missions
   <- !mm::create_mission(pa, print_a, 900, []); 
      !mm::create_mission(pb, print_b, 100, [drop_when_interrupted]);
      !mm::create_mission(pc, print_c,  50, []);

      !mm::run_mission(pa);
      .wait(2000);
      !mm::run_mission(pb);
      .wait(2000);
      !mm::run_mission(pc);
   .

// (simulate) energy availability 

!consume_energy(1000). // it initially has 1000 of energy
+!consume_energy(E)    // that decais 10 units each second
   <- .wait(1000);
      -+mm::available_energy(E);  // change the belief in the module mm, so the module can react to it
      !consume_energy(E-10)
   .


+mm::mission_state(Id,S) // "callback" when a mission is finished
   <- .print("Mission ",Id," state is ",S).


// the plans for the goals of the missions

+!print_a[mission(M)]
   <- !mm::do( M, {.print(a)}, 1 ); // does the action assuming it consumes 1 unit of energy
      .wait(200);
      !mm::do( M, {.print("A")}, 1 );
      .wait(200);
      !mm::do( M, {.print("Ahh")}, 2 );
      .wait(500);
      !print_a[mission(M)].

+!print_b[mission(M)]
   <- !mm::do( M, {.print(b)}, 5 );
      .wait(200);
      !print_b[mission(M)].

+!print_c[mission(M)]
   <- !mm::do( M, {.print("CCC, a short mission ")}, 5 ).
