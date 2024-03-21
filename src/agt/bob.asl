
{ include("mission-management.asl", mm) }


!my_missions.

+!my_missions
   <- !mm::create_mission(pa, print_a, 900, [auto_resume]); // is no mission is running, pa will resume, if possible
      !mm::create_mission(pb, print_b, 100, []);
      !mm::create_mission(pc, print_c,  50, []);

      !mm::change_mission(pa, suspend_current);  // other option for second argument is drop_current
      .wait(2000);
      !mm::change_mission(pb, suspend_current);
      .wait(2000);
      !mm::change_mission(pc, drop_current); // drop mission pb in the case   
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


// the plans for goal of the missions

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
