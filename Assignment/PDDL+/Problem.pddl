(define (problem warehouse-two-robots-four-packages)
  (:domain priority-delivery-pddlplus)

  (:objects
    r1 r2 - robot
    warehouse locA locB locC locD - location
    p1 p2 p3 p4 - package
  )

  (:init
    (at r1 warehouse)
    (at r2 warehouse)

    (available r1)
    (available r2)

    (package-at p1 warehouse)
    (package-at p2 warehouse)
    (package-at p3 warehouse)
    (package-at p4 warehouse)

    (destination p1 locA)
    (destination p2 locB)
    (destination p3 locC)
    (destination p4 locD)

    (urgent p1)
    (urgent p2)
    (normal p3)
    (normal p4)

    (= (clock) 0)

    (= (delivery-time p1) 3)
    (= (delivery-time p2) 4)
    (= (delivery-time p3) 5)
    (= (delivery-time p4) 6)

    (= (deadline p1) 5)
    (= (deadline p2) 9)
    (= (deadline p3) 13)
    (= (deadline p4) 15)

    (= (priority p1) 10)
    (= (priority p2) 8)
    (= (priority p3) 7)
    (= (priority p4) 6)
  )

  (:goal
    (and
      (delivered p1)
      (delivered p2)
      (delivered p3)
      (delivered p4)

      (not (violated p1))
      (not (violated p2))
      (not (violated p3))
      (not (violated p4))
    )
  )

  (:metric minimize (total-cost))
)