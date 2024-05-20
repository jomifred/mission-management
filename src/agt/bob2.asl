
{ include("mission-management2.asl", mm) }


!my_missions.
+!my_missions
   <- !mm::create_mission(pa, 900, []); // scan
      +mm::mission_plan(pa,[a1,a2,a3,a4,a5,a,a,a,a,a,a,a]); // a list of waypoints
      !mm::create_mission(pb, 100, [drop_when_interrupted]); // extinguish
      +mm::mission_plan(pb,[b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b]);
      !mm::create_mission(pc, 50, []);
      +mm::mission_plan(pc,[c,c]); // help other
      !mm::create_mission(pd, 50, [loop]);
      +mm::mission_plan(pd,[d,d]); // help other
      // go home
      // land now

      !mm::run_mission(pa);
      .wait(2000);
      !mm::run_mission(pb);
      .wait(2000);
      !mm::run_mission(pc);
   .

+fire <- !mm::run_mission(pb).
-energy <- !mm::run_mission(gohome).

+mm::mission_state(pc,finished) 
   <- .print("Mission c finished!");
      !mm::run_mission(pd);
      .wait(4000);
      !mm::stop_mission(pd,timeout);
   .

+mm::mission_state(Id,S) // "callback" when a mission is finished
   <- .print("Mission ",Id," state is ",S).
