;; Problem: southside-temporal-problem
;; Name: Syed Mohammed Arslan Kazmi
    
;;The problem represents parcel delivery system where drivers operate vehicles from a depot
;;to deliver packages around the southside of Glasgow. 

;;Real-time durations (such as walk, drive, refuel, etc...)
;;Multiple drivers
;;Multiple vehicles
;;vehicle access, assignments, and road links.

(define (problem southside-temporal-problem)
    (:domain southside-temporal)

    (:objects
        ;;Drivers
        driver1 driver2 - driver

        ;;Vehicles
        van1 bike1 - vehicle

        ;;Packages
        pkgA pkgB pkgC - package

        ;;Locations
        kinning-park-depot shawlands battlefield govanhill langside - location
    )

    (:init
        ;;Drivers start on foot at kinning park depot.
        (at-driver driver1 kinning-park-depot)
        (at-driver driver2 kinning-park-depot)

        ;;Vehicles start at kinning park depot.
        (at-vehicle van1 kinning-park-depot)
        (at-vehicle bike1 kinning-park-depot)

        ;;Packages start at kinning park depot
        (package-at pkgA kinning-park-depot)
        (package-at pkgB kinning-park-depot)
        (package-at pkgC kinning-park-depot)

        ;;Fuel system for each vehicle
        (= (max-fuel van1) 5)
        (= (fuel-level van1) 2)
        (= (max-fuel bike1) 4)
        (= (fuel-level bike1) 2)

        ;;Fuel stops
        (fuel-stop kinning-park-depot)
        (fuel-stop langside)

        ;;Capacity
        (capacity-available van1)
        (capacity-available bike1)

        ;;Driver assignments
        (assigned-vehicle driver1 van1)
        (assigned-vehicle driver2 bike1)

        ;;Both drivers and vehicles start free
        (driver-free driver1)
        (driver-free driver2)
        (vehicle-free van1)
        (vehicle-free bike1)

        ;;Road links
        (road kinning-park-depot shawlands)
        (road shawlands battlefield)
        (road battlefield shawlands)
        (road shawlands govanhill)
        (road govanhill shawlands)
        (road shawlands langside)
        (road langside shawlands)
        (road shawlands kinning-park-depot)

        ;;Walking network
        (connected-walk battlefield govanhill)
        (connected-walk govanhill battlefield)

        ;;Vehicle permissions
        (allowed van1 kinning-park-depot)
        (allowed van1 shawlands)
        (allowed van1 battlefield)
        (allowed van1 langside)

        (allowed bike1 kinning-park-depot)
        (allowed bike1 shawlands)
        (allowed bike1 govanhill)
        (allowed bike1 battlefield)
    )

    (:goal (and
        ;;Delivery complete
        (package-at pkgA battlefield)
        (package-at pkgB govanhill)
        (package-at pkgC shawlands)

        ;;Return to kinning park depot
        (at-driver driver1 kinning-park-depot)
        (at-driver driver2 kinning-park-depot)
        (at-vehicle van1 kinning-park-depot)
        (at-vehicle bike1 kinning-park-depot)
    ))
    
)


;;Analysis and Discussio

;; Summary:
;;This problem represents a parcel delivery system for the southside of Glasgow.
;;It involves two drivers, two types of vehicles (van and bike), and 3 packages to deliver.

;;Each package must be delivered to a specific area.
;;Both drivers and vehicles must return to the depot after delivery.

;; Constraints:
;;Vehicles have limited fuel and must refuel at locations where fuel stops are available.
;;Only specific vehicles can enter certain areas.
;;Vehicles can only carry one package at a time.
;;Drivers must be on foot to load and unload, and they must board to drive.

;; Temporal Considerations:
;;All actions are durative (for example, walking takes 5 time units).
;;Actions cannot overlap due to both driver-free and vehicle-free predicates.

;; This temporal problem is designed to demonstrate non-trivial planning with realistic logistics.
