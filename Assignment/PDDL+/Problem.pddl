(define (problem pddl-plus-delivery)
  (:domain priority-delivery-pddlplus)

  (:objects
    r1 r2 - robot
    warehouse A B C D E - location
    p1 p2 p3 p4 p5 - package
  )

  (:init
    (depot warehouse)
    
    (customer-location A)
    (customer-location B)
    (customer-location C)
    (customer-location D)
    (customer-location E)

    (at r1 warehouse)
    (at r2 warehouse)

    (available r1)
    (available r2)

    (package-at p1 warehouse)
    (package-at p2 warehouse)
    (package-at p3 warehouse)
    (package-at p4 warehouse)
    (package-at p5 warehouse)

    (destination p1 A)
    (destination p2 B)
    (destination p3 C)
    (destination p4 D)
    (destination p5 E)

    (= (clock) 0)
    (= (total-cost) 0)

    (= (delivery-progress p1) 0)
    (= (delivery-progress p2) 0)
    (= (delivery-progress p3) 0)
    (= (delivery-progress p4) 0)
    (= (delivery-progress p5) 0)

    (= (return-progress r1) 0)
    (= (return-progress r2) 0)

    (= (delivery-time p1) 3)
    (= (delivery-time p2) 4)
    (= (delivery-time p3) 5)
    (= (delivery-time p4) 6)
    (= (delivery-time p5) 5)

    (= (deadline p1) 5)
    (= (deadline p2) 10)
    (= (deadline p3) 16)
    (= (deadline p4) 20)
    (= (deadline p5) 12)

    (= (priority p1) 10)
    (= (priority p2) 8)
    (= (priority p3) 4)
    (= (priority p4) 2)
    (= (priority p5) 6)

    (= (return-time A warehouse) 2)
    (= (return-time B warehouse) 2)
    (= (return-time C warehouse) 2)
    (= (return-time D warehouse) 2)
    (= (return-time E warehouse) 2)
  )

  (:goal
    (and
      (delivered p1)
      (delivered p2)
      (delivered p3)
      (delivered p4)
      (delivered p5)

      (not (violated p1))
      (not (violated p2))
      (not (violated p3))
      (not (violated p4))
      (not (violated p5))

      (at r1 warehouse)
      (at r2 warehouse)
    )
  )
  (:metric minimize (total-cost))
)