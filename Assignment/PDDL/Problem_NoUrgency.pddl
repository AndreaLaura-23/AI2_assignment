;; Problem without priority
(define (problem warehouse-no-urgency)
  (:domain priority-delivery-basic)

  (:objects
    r1 r2 - robot
    p1 p2 p3 p4 - package
    warehouse a b c d - location
  )

  (:init
    (= (total-cost) 0)

    (at r1 warehouse)
    (at r2 warehouse)

    (free r1)
    (free r2)

    (package-at p1 warehouse)
    (package-at p2 warehouse)
    (package-at p3 warehouse)
    (package-at p4 warehouse)

    (destination p1 a)
    (destination p2 b)
    (destination p3 c)
    (destination p4 d)

    ;; Fully connected simplified warehouse graph
    (connected warehouse a)
    (connected a warehouse)
    (connected warehouse b)
    (connected b warehouse)
    (connected warehouse c)
    (connected c warehouse)
    (connected warehouse d)
    (connected d warehouse)

    ;; No urgency: no priority predicates and no must-before constraints.
  )

  (:goal
    (and
      (delivered p1)
      (delivered p2)
      (delivered p3)
      (delivered p4)
      
      ;; Robots must return to the warehouse after completing deliveries.
      (at r1 warehouse)
      (at r2 warehouse)
    )
  )

  (:metric minimize (total-cost))
)
