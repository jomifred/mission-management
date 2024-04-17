
{ include("mission-management2.asl", mm) }


!my_missions.
+!my_missions
   <- !mm::create_mission(pa, 900, []); 
      +mm::mission_plan(pa,[a,a,a,a,a,a,a,a,a,a,a,a]);
      !mm::create_mission(pb, 100, [drop_when_interrupted]);
      +mm::mission_plan(pb,[b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b]);
      !mm::create_mission(pc, 50, []);
      +mm::mission_plan(pc,[c,c,c]);

      !mm::run_mission(pa);
      .wait(2000);
      !mm::run_mission(pb);
      .wait(2000);
      !mm::run_mission(pc);
   .

+mm::mission_state(Id,S) // "callback" when a mission is finished
   <- .print("Mission ",Id," state is ",S).

