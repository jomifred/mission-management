
/* Mission plans */

+!create_mission(Id,Goal,ExpEnergy, Args) 
   <- +mission(Id,Goal,ExpEnergy,0);
      //if ( .member(auto_resume, Args)) {
      //  +mission_auto_resume(Id);
      //}
      if ( .member(drop_when_interrupted, Args)) {
        +mission_drop_when_interrupted(Id);
      }
   .

@[atomic] +!run_mission(Id) : current_mission(Id). // nothing to do
@[atomic] +!run_mission(Id)  // no current, but already desired, resume
   :  not current_mission(_) & 
      mission(Id,G,_,_) &
      .desire(G)
   <- +current_mission(Id);
      .resume(G).
@[atomic] +!run_mission(Id) // no current, not desired, start!
   :  not current_mission(_) & 
      mission(Id,G,_,_) &
      not .desire(G)
   <- +current_mission(Id);
      !!start_mission(Id,G).
@[atomic] +!run_mission(Id) // drop current
   :  current_mission(CMission) & 
      CMission \== Id &
      mission_drop_when_interrupted(CMission) &
      mission(CMission,G,_,_) 
   <- .drop_intention(G);
      -current_mission(CMission);
      !change_state(CMission,dropped);
      !run_mission(Id).

@[atomic] +!run_mission(Id)  // suspend current
   :  current_mission(CMission) & 
      CMission \== Id &
      mission(CMission,G,_,_)
   <- .suspend(G);
      -current_mission(CMission);
      !change_state(CMission,suspended);
      !run_mission(Id).

@[atomic] +!stop_mission(Id,R)
   :  current_mission(Id) & 
      mission(Id,G,_,_)
   <- .suspend(G);
      -current_mission(Id);
      !change_state(Id,stopped[reason(R)]);
      !auto_resume.

@[atomic] +!drop_mission(Id,R)
   :  current_mission(Id) & 
      mission(Id,G,_,_)
   <- .drop_intention(G);
      -current_mission(Id);
      !change_state(Id,dropped[reason(R)]);
      !auto_resume.


+!start_mission(Id,G)
   :  enough_energy(Id)
   <- !default::G[mission(Id)];
      // mission has finished
      -current_mission(Id);
      !change_state(Id,finished);
      !auto_resume.   

+!auto_resume
   :  not current_mission(_) &
      //mission_auto_resume(Mission) &
      mission(Mission,G,_,_) &
      .desire(G) &
      enough_energy(Mission)
   <- !run_mission(Mission).
+!auto_resume.

+!change_state(Mission, State) 
   <- -mission_state(Mission, _);
      +mission_state(Mission, State).

/* energy plans */

available_energy(100000000). // should be updated by who is using this library

enough_energy(RE)      :- .number(RE) & available_energy(A) & A > RE.
enough_energy(Mission) :- mission(Mission,_,EE,US) & available_energy(A) & A > (EE-US).

// either if available energy or mission consumption change, test if we can continue on the mission
+available_energy(_)      <- !test_enough_energy.
+mission(Mission,_,EE,US) <- !test_enough_energy.

+!test_enough_energy
    : current_mission(Mission) & 
      mission(Mission,_,EE,US) & 
      not enough_energy(EE - US)
   <- ?available_energy(A);
      !!stop_mission(Mission,lack_of_energy(required(EE-US),available(A))). 
+!test_enough_energy.

/* action plans */

// do some action that consumes energy
+!do( Mission, Code, Energy) 
    : mission(Mission,G,EE,US)
   <- default::Code;
      -mission(Mission,G,EE,US);
      +mission(Mission,G,EE,US+Energy);
   .