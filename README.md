# Priority Warehouse Delivery Planning

## Project Overview

This project models a warehouse delivery system where autonomous robots are responsible for transporting packages from a central warehouse to customer destinations. The main challenge is the presence of package priorities and delivery deadlines. Some packages are more urgent than others and must be delivered before less important deliveries, while all tasks still need to be completed efficiently.

The project is divided into two parts:

- **Q1 – Basic PDDL Model:** deadlines are approximated through delivery ordering constraints and priority relationships.
- **Q2 – PDDL+ Model:** deadlines are explicitly represented through temporal processes and events, allowing the planner to reason about time progression and deadline violations.

The objective is to demonstrate how planning techniques can be used to schedule deliveries, respect priorities, avoid deadline violations, and minimize overall execution cost.

---

# Domain Characteristics

### Robots
- One or more autonomous delivery robots.
- Robots transport packages between the warehouse and customer locations.
- Robots must return to the warehouse after completing deliveries.

### Tasks
- Deliver packages to assigned destinations.
- Respect package priorities.
- Complete all deliveries.

### Constraints
- Priority ordering between packages.
- Delivery deadlines.
- Limited robot availability.
- Cost minimization.

---

# Q1 – Basic PDDL Model

## Domain Description

The first model is implemented using classical PDDL. Since standard PDDL does not directly support deadlines, 
urgency is approximated through ordering constraints.

The domain contains:

### Objects
- Robots
- Packages
- Locations

### Main Predicates

```pddl
(at ?r ?l)
(package-at ?p ?l)
(carrying ?r ?p)
(delivered ?p)
(destination ?p ?l)
(free ?r)
(connected ?from ?to)
```

### Priority Predicates

```pddl
(high-priority ?p)
(medium-priority ?p)
(low-priority ?p)
```

### Ordering Constraints

```pddl
(must-before ?urgent ?later)
```

This predicate forces urgent packages to be delivered before lower-priority packages.

### Cost Function

```pddl
(total-cost)
```

Every action increases the total cost by one unit.

---

## Actions

### Move

Moves a robot between warehouse and connected locations.

### Pick-Up

Allows a robot to collect a package only if all required predecessor packages have already been delivered.

### Deliver

Delivers a package to its destination while respecting priority constraints.

---

## Problem 1 – No Urgency

This scenario represents a standard warehouse operation without priorities.

### Characteristics

- 2 robots (`r1`, `r2`)
- 4 packages (`p1–p4`)
- 4 destinations (`a–d`)
- No priority levels
- No ordering constraints

The planner may freely choose any valid delivery sequence.

### Goal

- Deliver all packages.
- Return both robots to the warehouse.
- Minimize total cost.

### Expected Behaviour

Since no package has priority over another, the robots are free to pick up and deliver any package in any order. No urgency or precedence constraints are imposed, giving the planner full freedom when generating the delivery schedule.

---

## Problem 2 – Priority-Based Deliveries

This scenario introduces urgency and delivery priorities.

### Package Priorities

| Package | Priority Level |
|----------|----------|
| P1 | High |
| P5 | High |
| P2 | Medium |
| P3 | Low |
| P4 | Low |

### Ordering Constraints

High-priority packages must be delivered before medium-priority packages, 
while medium-priority packages must be delivered before low-priority packages.

Examples:

```pddl
(must-before p1 p2)
(must-before p5 p2)

(must-before p1 p3)
(must-before p5 p3)

(must-before p2 p3)
(must-before p2 p4)
```

### Goal

- Deliver all packages.
- Return both robots to the warehouse.
- Minimize total cost.

### Expected Behaviour

Unlike Problem 1, the planner cannot freely choose the delivery order. 
The generated plan must respect the priority hierarchy, making scheduling decisions more constrained and realistic.

---

# Q2 – PDDL+ Model

## Overview

The PDDL+ version extends the classical model by introducing explicit temporal reasoning. 
Instead of approximating deadlines only through ordering constraints, the planner must manage actual delivery durations, 
return durations and package deadlines.

This makes scheduling decisions directly affect whether a valid plan exists.

---

## Time Progression

A clock is used to represent the passage of time during execution.
This enables the planner to consider delivery durations and deadlines, rather than only the order of actions.

---
## Delivery Process

Each package requires a certain amount of time to be delivered. Once a robot starts a delivery, the package is considered delivered only after the required delivery time has passed.
This makes delivery duration an important factor in the planning process.

---
## Return Process

Once a package has been delivered, the robot must travel back to the warehouse before it can perform another delivery.
Every return journey takes 2 time units, making the return time an important factor in scheduling decisions and deadline satisfaction.

---

## Priority Management

Each package is assigned a numerical priority value. Packages with higher priority must be delivered before packages with lower priority that are still waiting in the warehouse. 
This ensures that urgent deliveries are handled first and influences the order in which robots perform their tasks.

Example:

| Package | Priority |
|----------|----------|
| P1 | 10 |
| P2 | 8 |
| P5 | 6 |
| P3 | 4 |
| P4 | 2 |

This creates non-trivial scheduling decisions because the planner must balance urgency and deadline satisfaction.

---

## Deadline Violations

Every package is associated with a deadline. If the delivery is not completed in time, the package is marked as violated. 
Since deadline violations cannot be undone, robots must schedule deliveries carefully to ensure that all deadlines are respected.

---

## PDDL+ Problem Instance

### Environment

My problem contains:

- 2 robots (`r1`, `r2`)
- 5 packages (`p1–p5`)
- 1 warehouse
- 5 customer destinations (`A–E`)

The following problem is a sample scenario and can be expanded with more robots, packages, locations, priorities, and deadlines. 
All packages initially start in the warehouse and are waiting to be delivered to their assigned destinations.

---

### Delivery Times and Deadlines

| Package | Delivery Time | Deadline |
|----------|----------|----------|
| P1 | 3 | 5 |
| P2 | 4 | 10 |
| P3 | 5 | 16 |
| P4 | 6 | 20 |
| P5 | 5 | 12 |

---

### Goal Conditions

The planner must:

- Deliver all packages.
- Avoid deadline violations.
- Return both robots to the warehouse.
- Minimize total execution cost.

---

## Impact of Scheduling Decisions

The PDDL+ model shows how delivery priorities, execution times and deadlines influence the planning process. Unlike the basic PDDL model, actions are not instantaneous and every delivery requires time to be completed. As a result, robots must carefully schedule deliveries to ensure that all packages are delivered before their deadlines.

A feasible solution requires assigning tasks efficiently, prioritizing urgent packages and considering both delivery and return times. Poor scheduling decisions may delay deliveries and eventually trigger deadline violations.

### Example Plan Found

```text
0: (start-delivery r1 p1 warehouse a)
0: (start-delivery r2 p2 warehouse b)
0: -----waiting---- [3.0]

3.0: (start-return r1 a warehouse)
3.0: -----waiting---- [4.0]
4.0: (start-return r2 b warehouse)
4.0: -----waiting---- [5.0]

5.0: (start-delivery r1 p5 warehouse e)
5.0: -----waiting---- [6.0]
6.0: (start-delivery r2 p3 warehouse c)
6.0: -----waiting---- [10.0]

10.0: (start-return r1 e warehouse)
10.0: -----waiting---- [11.0]
11.0: (start-return r2 c warehouse)
11.0: -----waiting---- [12.0]

12.0: (start-delivery r1 p4 warehouse d)
12.0: -----waiting---- [18.0]

18.0: (start-return r1 d warehouse)
18.0: -----waiting---- [20.0]
```

In this plan, both robots operate in parallel to reduce the overall completion time. 
Higher-priority packages are dispatched first, while lower-priority deliveries are scheduled later. 
The planner also accounts for delivery durations and return trips to the warehouse, ensuring that all deliveries are completed without violating package deadlines.

This example highlights how temporal constraints and priorities work together to produce an efficient and feasible delivery schedule.
