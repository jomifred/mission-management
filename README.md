# Jason Mission Management

This is a library to help an agent to manage its missions! A mission a focus of attention and can be accomplished by several goals. 

We assume the agent is executing only one mission a time and it can change the current mission by

- cancelling the current mission and start the new 
- suspend the current and start the new


A mission has the following properties

- an identification
- the Jason goal assigned to it
- the required energy to accomplish it
- the amount of energy already use

this information is stored in beliefs like `mission(id, goal, energy requirement,energy already consumed)` in namespace `mm`.

The code is available in the file `src/agt/mission-management.asl` and illustrated in `src/agt/bob.asl`.