(define (problem southside-temporal-problem)
    (:domain southside-temporal)

    (:objects
        ;;the drivers
        driver1 driver2 driver3 - driver 

        ;;the vehicles
        van1 truck1 bike1 - vehicle

        ;;packages
        pkgA pkgB pkgC pkgD pkgE pkgF - package 

        ;;location
        kinning-park-depot pollokshields govanhill shawlands battlefield langside mount-florida cathcart - location 

    )

    (:init
        ;;the drivers start at the kinning park depot on foot (not in the vehicle)
        (at-driver driver1 kinning-park-depot)
        (at-driver driver2 kinning-park-depot)
        (at-driver driver3 kinning-park-depot)

        ;;the vehicles start at the depot
        (at-vehicle van1 kinning-park-depot)
        (at-vehicle truck1 kinning-park-depot)
        (at-vehicle bike1 kinning-park-depot)

        ;;all of the packages start at the depot
        (package-at pkgA kinning-park-depot)
        (package-at pkgB kinning-park-depot)
        (package-at pkgC kinning-park-depot)
        (package-at pkgD kinning-park-depot)
        (package-at pkgE kinning-park-depot)
        (package-at pkgF kinning-park-depot)

        ;;capacity availablibity
        (capacity-available van1)
        (capacity-available truck1)
        (capacity-available bike1)

        ;;assignment of the driver to the vehicle
        (assigned-vehicle driver1 van1)
        (assigned-vehicle driver2 truck1)
        (assigned-vehicle driver3 bike1)

        ;;drivers and vehicles are free at the start
        (driver-free driver1)
        (driver-free driver2)
        (driver-free driver3)
        (vehicle-free van1)
        (vehicle-free truck1)
        (vehicle-free bike1)

        ;;fuel stops
        (fuel-stop kinning-park-depot)
        (fuel-stop shawlands)
        (fuel-stop langside)
        (fuel-stop mount-florida)

        ;;fuel capacities for every vehicle
        (= (max-fuel van1) 5)
        (= (max-fuel truck1) 6)
        (= (max-fuel bike1) 4)

        ;;initial fuel levels
        (= (fuel-level van1) 3)
        (= (fuel-level truck1) 3)
        (= (fuel-level bike1) 2)

        ;;road network
        (road kinning-park-depot pollokshields)
        (road kinning-park-depot shawlands)
        (road kinning-park-depot langside)
        (road kinning-park-depot mount-florida)
        (road kinning-park-depot cathcart)
        (road pollokshields kinning-park-depot)
        (road shawlands kinning-park-depot)
        (road langside kinning-park-depot)
        (road mount-florida kinning-park-depot)
        (road cathcart kinning-park-depot)
        (road pollokshields govanhill)
        (road shawlands battlefield)
        (road battlefield shawlands)
        (road shawlands langside)
        (road langside shawlands)
        (road langside mount-florida)
        (road mount-florida langside)
        (road mount-florida cathcart)
        (road cathcart mount-florida)

        ;;the walks between neighbourhoods
        (connected-walk pollokshields govanhill)
        (connected-walk govanhill pollokshields)
        (connected-walk shawlands battlefield)
        (connected-walk battlefield shawlands)

        ;;Vehicle permissions
        ;;truck routes
        (allowed truck1 kinning-park-depot)
        (allowed truck1 cathcart)
        (allowed truck1 mount-florida)
        (allowed truck1 langside)
        (allowed truck1 shawlands)
        ;;van routes
        (allowed van1 kinning-park-depot)
        (allowed van1 pollokshields)
        (allowed van1 govanhill)
        (allowed van1 shawlands)
        (allowed van1 langside)
        (allowed van1 battlefield)
        (allowed van1 mount-florida)
        ;;bike
        (allowed bike1 kinning-park-depot)
        (allowed bike1 pollokshields)
        (allowed bike1 govanhill)
        (allowed bike1 shawlands)
        (allowed bike1 battlefield)


    )

    (:goal (and
        ;;delivery goals
        (package-at pkgA shawlands)
        (package-at pkgB battlefield)
        (package-at pkgC govanhill)
        (package-at pkgD langside)
        (package-at pkgE cathcart)
        (package-at pkgF mount-florida)

        ;;all of the drivers back to kinning park depot
        (at-driver driver1 kinning-park-depot)
        (at-driver driver2 kinning-park-depot)
        (at-driver driver3 kinning-park-depot)

        ;;all of the vehicles back to the depot
        (at-vehicle van1 kinning-park-depot)
        (at-vehicle truck1 kinning-park-depot)
        (at-vehicle bike1 kinning-park-depot)

    ))

)