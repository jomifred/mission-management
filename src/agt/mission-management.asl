
/* Mission plans */

+!create_mission(Id,Goal,ExpEnergy) <- +mission(Id,Goal,ExpEnergy,0).

@[atomic] +!change_mission(Id,_) : current_mission(Id). // nothing to do
@[atomic] +!change_mission(Id,_) 
   :  not current_mission(_) & 
      mission(Id,G,_,_) &
      .desire(default::G)
   <- +current_mission(Id);
      .resume(G).
@[atomic] +!change_mission(Id,_) 
   :  not current_mission(_) & 
      mission(Id,G,_,_) &
      not .desire(default::G)
   <- +current_mission(Id);
      !!default::G[mission(Id)]. // ToDo: fix default?
@[atomic] +!change_mission(Id,drop_current) 
   :  current_mission(OtherMission) & 
      OtherMission \== Id &
      mission(OtherMission,G,_,_)
   <- .drop_intention(G);
      -current_mission(OtherMission);
      !change_mission(Id,drop_current).

@[atomic] +!change_mission(Id,suspend_current) 
   :  current_mission(OtherMission) & 
      OtherMission \== Id &
      mission(OtherMission,G,_,_)
   <- .suspend(default::G);
      -current_mission(OtherMission);
      !change_mission(Id,suspend_current).

@[atomic] +!cancel_mission(Id,R) 
   :  current_mission(Id) & 
      mission(Id,G,_,_)
   <- .suspend(default::G);
      -current_mission(Id);
      +mission_cancelled(Id,R).

/* energy plans */

available_energy(100000000). // should be updated by who is using this library

enough_energy(RE) :- available_energy(A) & A > RE.

// either if available energy or mission consumption change, test if we can continue on the mission
+available_energy(_)      <- !test_enough_energy.
+mission(Mission,_,EE,US) <- !test_enough_energy.

+!test_enough_energy
    : current_mission(Mission) & 
      mission(Mission,_,EE,US) & 
      not enough_energy(EE - US)
   <- ?available_energy(A);
      !cancel_mission(Mission,lack_of_energy(required(EE-US),available(A))). 
+!test_enough_energy.

/* action plans */

// do some action that consumes energy
+!do( Mission, Code, Energy) 
    : mission(Mission,G,EE,US)
   <- default::Code;
      -mission(Mission,G,EE,US);
      +mission(Mission,G,EE,US+Energy);
   .