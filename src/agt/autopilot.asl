
+!stop_mission
   <- .drop_intention(do(_,_,_)).


+!run_plan(CM,Plan)[source(Ag)]
   <- -+my_agent(Ag);
      -+current_mission(CM);
      -+mission_plan(CM,Plan);
      !do(0,Plan,Ag).


// simulates autopilot running Plan
+!do(N,[],Ag)
    : current_mission(Id)    
   <- if (mission_loop(Id)) {
         ?mission_plan(Id,P);
         !do(0,P,Ag);
      } else {
         .send(Ag,signal,finished)
      }.

+!do(N,[Step|Rem],Ag)
    : current_mission(MisId)
   <- .print("doing ",Step);
      -+uav_lastWP(N);
      UsedEnergy = 5;
      if (not mission_loop(MisId)) {
         .send(Ag,achieve,update_rem_plan(Step,UsedEnergy));
      }
      .wait(1000);
      !do(N+1,Rem,Ag);
   .   

/*+update_current_mission(Id)[source(Ag)] 
  <- -current_mission(_);
     +current_mission(Id);
     -update_current_mission(Id)[source(Ag)].
*/

+uav_lastWP(N) 
   : current_mission(CM) 
   <- -progress(CM,_);
      +progress(CM,N).

+progress(CM,N) 
   : mission_plan(CM,Plan) & .length(Plan,N) & my_agent(Ag)
   <- .send(Ag,signal,finished).


!consume_energy(1000). // it initially has 1000 of energy
+!consume_energy(E)    // that decais 10 units each second
   <- .send(bob2,achieve,update_energy(E));
      .wait(1000);
      !consume_energy(E-10).

+update_current_mission(Id)[source(Ag)] 
  <- -current_mission(_);
     +current_mission(Id);
     -update_current_mission(Id)[source(Ag)].


