
{ include("mission-management.asl", mm) }


!my_missions.

+!my_missions
   <- !mm::create_mission(pa, print_a, 900);
      !mm::create_mission(pb, print_b, 100);

      !mm::change_mission(pa, suspend_current);  // other option for second argument is drop_current
      .wait(2000);
      !mm::change_mission(pb, suspend_current);
      .wait(2000);
      !mm::change_mission(pa, suspend_current);            
   .

// (simulate) energy availability 

!consume_energy(1000). // it initially has 1000 of energy
+!consume_energy(E)    // that decais 10 units each second
   <- .wait(1000);
      -+mm::available_energy(E);  // change the belief in the module mm, so the module can react to it
      !consume_energy(E-10)
   .


+mm::mission_cancelled(Id,R) // "callback" when a mission is cancelled
   <- .print("Mission ",Id," was cancelled due to ",R).


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
