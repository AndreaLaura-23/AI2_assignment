(define (domain priority-delivery-pddlplus)

  (:requirements :strips :typing :negative-preconditions :fluents :adl :time )

  (:types robot package location)

  (:predicates
    (at ?r - robot ?l - location)
    (package-at ?p - package ?l - location)
    (destination ?p - package ?l - location)

    (depot ?l - location)
    (customer-location ?l - location)

    (available ?r - robot)
    (delivering ?r - robot ?p - package ?to - location)
    (returning ?r - robot ?from - location ?to - location)

    (delivered ?p - package)
    (violated ?p - package)
  )

  (:functions
    (clock)
    (total-cost)
    (deadline ?p - package)
    (delivery-time ?p - package)
    (delivery-progress ?p - package)
    (return-time ?from - location ?to - location)
    (return-progress ?r - robot)
    (priority ?p - package)
  )

  ;; Time progression 
  (:process time-passing
    :parameters ()
    :precondition (and)
    :effect (and
      (increase (clock) (* #t 1))
      (increase (total-cost) (* #t 1))
    )
  )

  ;; Start delivery
  (:action start-delivery
    :parameters (?r - robot ?p - package ?from - location ?to - location)
    :precondition (and
      (available ?r)
      (at ?r ?from)
      (depot ?from)
      (package-at ?p ?from)
      (destination ?p ?to)

      ;; Priority rule:
      ;; A package can be delivered only if no package with higher priority
      ;; is still waiting at the depot.
      (forall (?q - package)
        (or
          (delivered ?q)
          (not (package-at ?q ?from))
          (<= (priority ?q) (priority ?p))
        )
      )

      (not (delivered ?p))
      (not (violated ?p))
    )
    :effect (and
      (not (available ?r))
      (not (at ?r ?from))
      (not (package-at ?p ?from))
      (assign (delivery-progress ?p) 0)
      (delivering ?r ?p ?to)
    )
  )

  ;; Delivery process
  (:process delivery-process
    :parameters (?r - robot ?p - package ?to - location)
    :precondition (and
      (delivering ?r ?p ?to)
      (not (delivered ?p))
      (not (violated ?p))
    )
    :effect (increase (delivery-progress ?p) (* #t 1))
  )

  ;; Delivery completion event
  (:event complete-delivery
    :parameters (?r - robot ?p - package ?to - location)
    :precondition (and
      (delivering ?r ?p ?to)
      (>= (delivery-progress ?p) (delivery-time ?p))
      (not (violated ?p))
    )
    :effect (and
      (not (delivering ?r ?p ?to))
      (at ?r ?to)
      (available ?r)
      (delivered ?p)
    )
  )

  ;; Start return to warehouse
  (:action start-return
    :parameters (?r - robot ?from - location ?w - location)
    :precondition (and
      (available ?r)
      (at ?r ?from)
      (customer-location ?from)
      (depot ?w)
    )
    :effect (and
      (not (available ?r))
      (not (at ?r ?from))
      (assign (return-progress ?r) 0)
      (returning ?r ?from ?w)
    )
  )

  ;; Return process
  (:process return-process
    :parameters (?r - robot ?from - location ?w - location)
    :precondition (returning ?r ?from ?w)
    :effect (increase (return-progress ?r) (* #t 1))
  )

  ;; Return completion event
  (:event complete-return
    :parameters (?r - robot ?from - location ?w - location)
    :precondition (and
      (returning ?r ?from ?w)
      (depot ?w)
      (>= (return-progress ?r) (return-time ?from ?w))
    )
    :effect (and
      (not (returning ?r ?from ?w))
      (at ?r ?w)
      (available ?r)
    )
  )

  ;; Deadline violation
  (:event deadline-violation
    :parameters (?p - package)
    :precondition (and
      (not (delivered ?p))
      (not (violated ?p))
      (> (clock) (deadline ?p))
    )
    :effect (violated ?p)
  )
)