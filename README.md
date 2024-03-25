# Jason Mission Management

This is a library to help an agent to manage its missions! A mission is a focus of attention and can be accomplished by several goals. 

We assume the agent is executing only one mission a time and the agent can change its current mission. When switching the mission, the current mission can be either suspended or dropped.

If a mission is interrupted/stopped/dropped, another suspended mission resumes. The agent is ideally always in a mission -- no mission is avoided :-)

A mission has the following properties

- an identification
- the Jason goal assigned to it
- the required energy to accomplish it
- the amount of energy already use

this information is stored in beliefs like `mission(id, goal, energy requirement,energy already consumed)` in namespace `mm`.

The code is available in the file `src/agt/mission-management.asl` and illustrated in `src/agt/bob.asl`.

## Missions change

## Actions

## Energy