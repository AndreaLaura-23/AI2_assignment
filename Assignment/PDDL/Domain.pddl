(define (domain priority-delivery-basic)

  (:requirements :strips :typing :negative-preconditions :action-costs :adl)

  (:types robot package location )

  (:predicates
    (at ?r - robot ?l - location)
    (package-at ?p - package ?l - location)
    (carrying ?r - robot ?p - package)
    (free ?r - robot)
    (delivered ?p - package)
    (destination ?p - package ?l - location)
    (connected ?from ?to - location)
    
    ;; This predicates classify packages
    (high-priority ?p - package)
    (medium-priority ?p - package)
    (low-priority ?p - package)

    ;; Ordering Constraints 
    (must-before ?urgent - package ?later - package)
  )

  (:functions
    (total-cost)
  )

;; Robot can move from a location to an other location
  (:action move
    :parameters (?r - robot ?from - location ?to - location)
    :precondition (and (at ?r ?from)
                       (connected ?from ?to)
                  )
    :effect (and (not (at ?r ?from))
                 (at ?r ?to)
                 (increase (total-cost) 1)
            )
  )
 
  (:action pick-up
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and (at ?r ?l)            ;; Same location robot and package
                       (package-at ?p ?l)    
                       (free ?r)             ;; Robot is free 
                       (not (delivered ?p))  ;; Robot is not delivered
                      ;; A package can be picked up only when all its predecessors are delivered.
                       (forall (?u - package)
                          (imply (must-before ?u ?p)
                                 (delivered ?u)))
                  )
    :effect (and (not (package-at ?p ?l))
                 (not (free ?r))
                 (carrying ?r ?p)
                 (increase (total-cost) 1)
            )
  )

  (:action deliver
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and (at ?r ?l)
                       (carrying ?r ?p)
                       (destination ?p ?l)
                       (forall (?u - package)
                       (imply (must-before ?u ?p)
                       (delivered ?u)))
                  )
      ;; A package ?p can be delivered ONLY if all packages
      ;; that must precede it have already been delivered.
      
    :effect (and (not (carrying ?r ?p))
                 (free ?r)
                 (delivered ?p)
                 (increase (total-cost) 1)
              )
  )
)


