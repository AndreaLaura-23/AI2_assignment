(define (domain priority-delivery-pddlplus)

  (:requirements
    :typing
    :negative-preconditions
    :fluents
    
  )

  (:types robot package location)

  (:predicates
    (at ?r - robot ?l - location)
    (package-at ?p - package ?l - location)
    (destination ?p - package ?l - location)

    (available ?r - robot)
    (delivered ?p - package)
    (violated ?p - package)

    (urgent ?p - package)
    (normal ?p - package)
  )

  (:functions
    (clock)
    (deadline ?p - package)
    (delivery-time ?p - package)
    (priority ?p - package)
  )

 (:action deliver
  :parameters (?r - robot ?p - package ?from ?to - location)

  :precondition (and
    (available ?r)
    (at ?r ?from)
    (package-at ?p ?from)
    (destination ?p ?to)
    (not (delivered ?p))
    (not (violated ?p))
  )

  :effect (and
    (not (available ?r))
    (not (package-at ?p ?from))
    (not (at ?r ?from))
    (at ?r ?to)
    (available ?r)
    (delivered ?p)
  )
 )

  ;; Robot returns instantly to warehouse
  (:action return-to-warehouse
    :parameters (?r - robot ?from ?warehouse - location)
    :precondition (and
      (available ?r)
      (at ?r ?from)
    )
    :effect (and
      (not (at ?r ?from))
      (at ?r ?warehouse)
    )
  )

  ;; Deadline violation event for urgent packages
  (:event urgent-deadline-violation
    :parameters (?p - package)
    :precondition (and
      (urgent ?p)
      (not (delivered ?p))
      (> (clock) (deadline ?p))
    )
    :effect (violated ?p)
  )

  ;; Deadline violation event for normal packages
  (:event normal-deadline-violation
    :parameters (?p - package)
    :precondition (and
      (normal ?p)
      (not (delivered ?p))
      (> (clock) (deadline ?p))
    )
    :effect (violated ?p)
  )
)