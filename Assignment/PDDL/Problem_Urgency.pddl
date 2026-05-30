;; Problem with priority 
(define (problem warehouse-with-priority)
  (:domain priority-delivery-basic)

  (:objects
    r1 r2 - robot
    p1 p2 p3 p4 p5 - package
    warehouse a b c d e - location
  )

  (:init
    (= (total-cost) 0)

     ;; Robots at the warehouse
    (at r1 warehouse)
    (at r2 warehouse)

    ;; Robots are free at the 
    (free r1)
    (free r2)

    ;; All packages are at the warehouse
    (package-at p1 warehouse)
    (package-at p2 warehouse)
    (package-at p3 warehouse)
    (package-at p4 warehouse)
    (package-at p5 warehouse)

    (destination p1 a)
    (destination p2 b)
    (destination p3 c)
    (destination p4 d)
    (destination p5 e)

    ;; Fully connected simplified warehouse graph
    (connected warehouse a)
    (connected a warehouse)
    (connected warehouse b)
    (connected b warehouse)
    (connected warehouse c)
    (connected c warehouse)
    (connected warehouse d)
    (connected d warehouse)
    (connected warehouse e)
    (connected e warehouse)
    
    (high-priority p1)
    (medium-priority p2)
    (low-priority p3)
    (low-priority p4)
    (high-priority p5)

    ;; High-priority packages must be delivered before medium-priority ones.
    ;; Medium-priority packages must be delivered before low-priority ones.
    
    (must-before p1 p2)
    (must-before p5 p2)
    (must-before p1 p3)
    (must-before p1 p4)
    (must-before p5 p3)
    (must-before p5 p4)
    (must-before p2 p3)
    (must-before p2 p4)
  )

  (:goal
    (and
      (delivered p1)
      (delivered p2)
      (delivered p3)
      (delivered p4)
      (delivered p5)

      ;; Robots must return to the warehouse after completing deliveries.
      (at r1 warehouse)
      (at r2 warehouse)
    )
  )

  (:metric minimize (total-cost))
)
