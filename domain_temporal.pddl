(define (domain southside-temporal)

;;Domain: southside-temporal
;;Name: Syed Mohammed Arslan Kazmi

    (:requirements
        :strips 
        :typing
        :durative-actions
        :negative-preconditions
        :numeric-fluents
    )

    (:types
        driver 
        vehicle 
        package 
        location
    )

    (:predicates
        
        ;;Driver standing at a location and not in a vehicle. 
        (at-driver ?d - driver ?l - location)

        ;;vehicle parked at a location
        (at-vehicle ?v - vehicle ?l - location)

        ;;driver is in the vehicle
        (in-vehicle ?d - driver ?v - vehicle)

        ;;package is in vehicle
        (package-in ?p - package ?v - vehicle)

        ;;package at a location (not loaded)
        (package-at ?p - package ?l - location)

        ;;walkable link for drivers
        (connected-walk ?l1 - location ?l2 - location)

        ;;driveable road link for the vehicles
        (road ?l1 - location ?l2 - location)

        ;;vehicle access allowed into locations
        (allowed ?v - vehicle ?l - location)

        ;;free capacity for at least 1 package
        (capacity-available ?v - vehicle)

        ;;each driver as a vehicle assigned to them
        (assigned-vehicle ?d - driver ?v - vehicle)

        ;;locations where the vehicles can refuel
        (fuel-stop ?l - location)

        (driver-free ?d - driver)
        (vehicle-free ?v - vehicle)
    )

    (:functions
        ;;current fuel level for every vehicle
        (fuel-level ?v - vehicle)

        ;;max fuel level for every vehicle
        (max-fuel ?v - vehicle)
    )

    ;;Durative Actions
    
    ;;Drivers can walk between nearby locations
    (:durative-action walk
        :parameters
        (
            ?d - driver ?from - location ?to - location
        )
        :duration (= ?duration 5)
        :condition (and 
            (at start (
                driver-free ?d
            ))
            (at start (
                at-driver ?d ?from
            ))
            (at start (
                connected-walk ?from ?to
            ))
        )

        :effect (and 
            (at start (
                not(driver-free ?d) 
            ))
            (at end (
                at-driver ?d ?to
            ))
            (at end (
                not(at-driver ?d ?from)
            ))
            (at-end (
                driver-free ?d
            ))
        )
    )
    
    ;;Driver boards the vehicle that is assigned to them
    (:durative-action board-vehicle
        :parameters (
            ?d - driver ?v - vehicle ?l - location 
        )
        :duration (= ?duration 1)
        :condition (and 
            (at start (
                driver-free ?d
            ))
            (at start (
                vehicle-free ?v 
            ))
            (at start (
                assigned-vehicle ?d ?v  
            ))
            (at start (
                at-driver ?d ?l
            ))
            (at start (
                at-vehicle ?v ?l
            ))
        )
        :effect (and 
            (at start (
                not(driver-free ?d) 
            ))
            (at start (
                not(vehicle-free ?v)
            ))
            (at end (
                in-vehicle ?d ?v
            ))
            (at end (
                not(at-driver ?d ?l)
            ))
            (at end (
                driver-free ?d
            ))
            (at end (
                vehicle-free ?v
            ))

        )
    )

    ;;Driver exits vehicle
    (:durative-action unboard-vehicle
        :parameters (
            ?d - driver ?v - vehicle ?l - location
        )
        :duration (= ?duration 1)
        :condition (and 
            (at start (
                driver-free ?d 
            ))
            (at start (
                in-vehicle ?d ?v
            ))
            (at start (
                at-vehicle ?v ?l 
            ))
        )
        :effect (and 
            (at start (
                not(driver-free ?d) 
            ))
            (at end (
                at-driver ?d ?l 
            ))
            (at end (
                not(in-vehicle ?d ?v)
            ))
            (at end (
                driver-free ?d
            ))
        )
    )

    ;;Drive vehicle between locations, including fuel consumtion
    (:durative-action drive-vehicle
        :parameters (
            ?d - driver ?v - vehicle ?from - location ?to - location
        )
        :duration (= ?duration 6)
        :condition (and 
            (at start (
                driver-free ?d 
            ))
            (at start (
                vehicle-free ?v 
            ))
            (at start (
                assigned-vehicle ?d ?v
            ))
            (at start (
                in-vehicle ?d ?v
            ))
            (at start (
                at-vehicle ?v ?from
            ))
            (at start (
                road ?from ?to
            ))
            (at start (
                allowed ?v ?to
            ))
            (at start (
                >=(fuel-level ?v) 1
            ))
        )
        :effect (and 
            (at start (
                not(driver-free ?d) 
            ))
            (at start (
                not(vehicle-free ?v) 
            ))
            (at end (
                at-vehicle ?v ?to
            ))
            (at end (
                not(at-vehicle ?v ?from)
            ))
            (at end (
                decrease (fuel-level ?v) 1
            ))
            (at end (
                driver-free ?d
            ))
            (at end (
                vehicle-free ?v
            ))
        )
    )

    ;;Load package from location into the vehicle by the driver
    (:durative-action load-package
        :parameters (
            ?d - driver ?v - vehicle ?p - package ?l - location
        )
        :duration (= ?duration 4)
        :condition (and 
            (at start (
                driver-free ?d 
            ))
            (at start (
                vehicle-free ?v
            ))
            (at start (
                at-driver ?d ?l
            ))
            (at start (
                at-vehicle ?v ?l 
            ))
            (at start (
                package-at ?p ?l 
            ))
            (at start (
                capacity-available ?v
            ))
        )
        :effect (and 
            (at start (
                not(driver-free ?d) 
            ))
            (at start ( 
                not(vehicle-free ?v)
            ))
            (at end (
                not(package-at ?p ?l)
            ))
            (at end (
                package-at ?p ?v
            ))
            ;;one package fills up the capacity
            (at end (
                not(capacity-available ?v)
            ))
            (at end (
                driver-free ?d
            ))
            (at end (
                vehicle-free ?v
            ))
        )
    )

    ;;unload package from the vehicle to the location (basically the delivery)
    (:durative-action unload-package
        :parameters (
            ?d - driver ?v - vehicle ?p - package ?l - location
        )
        :duration (= ?duration 4)
        :condition (and 
            (at start (
                driver-free ?d 
            ))
            (at start (
                vehicle-free ?v
            ))
            (at start (
                at-vehicle ?d  ?l
            ))
            (at start (
                package-in ?p ?v 
            ))
        )
        :effect (and 
            (at start (
                not(driver-free ?d) 
            ))
            (at start (
                not(vehicle-free ?v) 
            ))
            (at end (
                package-at ?p ?l
            ))
            (at end (
                not(package-in ?p ?v)
            ))
            (at end (
                capacity-available ?v
            ))
            (at end (
                driver-free ?d
            ))
            (at end (
                vehicle-free ?v
            ))
        )
    )

    ;; Transfer package between two vehicles at same location.
    (:durative-action transfer-package
        :parameters (
            ?d - driver ?p - package ?from-v - vehicle ?to-v - vehicle ?l - location
        )
        :duration (= ?duration 3)
        :condition (and
            (at start (
                driver-free ?d
            ))
            (at start (
                vehicle-free ?from-v
            ))
            (at start (
                vehicle-free ?to-v
            ))
            (at start (
                at-driver ?d ?l
            ))
            (at start (
                at-vehicle ?from-v ?l
            ))
            (at start (
                at-vehicle ?to-v ?l
            ))
            (at start (
                package-in ?p ?from-v
            ))
            (at start (
                capacity-available ?to-v
            ))
        )

        :effect (and
            (at start (
                not (driver-free ?d)
            ))
            (at start (
                not (vehicle-free ?from-v)
            ))
            (at start (
                not (vehicle-free ?to-v)
            ))
            (at end (
                not (package-in ?p ?from-v)
            ))
            (at end (
                package-in ?p ?to-v
            ))
            (at end (
                capacity-available ?from-v
            ))
            (at end (
                not (capacity-available ?to-v)
            ))
            (at end (
                driver-free ?d
            ))
            (at end (
                vehicle-free ?from-v
            ))
            (at end (
                vehicle-free ?to-v
            ))
        )
    )

    ;;refuel a vehicle at a location thats got a fuel station
    (:durative-action refuel
        :parameters (
            ?v-vehicle ?l - location
        )
        :duration (= ?duration 5)
        :condition (and 
            (at start (
                vehicle-free ?v 
            ))
            (at start (
                at-vehicle ?v ?l 
            ))
            (at start( 
                fuel-stop ?l
            ))
        )
        :effect (and 
            (at start (
                not(vehicle-free ?v) 
            ))
            (at end (
                assign(fuel-level ?v) (max-fuel ?v)
            ))
            (at end ( 
                vehicle-free ?v
            ))
        )
    )
    
    
    
    
    
    

)