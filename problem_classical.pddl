(define (problem southside-classical-problem)
    (:domain southside-classic)

    ;;Problem: southisde-classical-problem
    ;;Name: Syed Mohammed Arslan Kazmi

    ;;Scenario
    ;;Southside deliveries operates from kinning park depot.
    ;;3 drivers (driver1, driver2, driver3) and 3 vehicles (van1, truck1, bike1) must deliver multiple packages from the depot out to the southside areas in Glasgow.
    ;;Then they return to the depot.

    ;;The goal is to deliver all the packages to their destination areas.
    ;;After completing all the deliveries, the vehicles/drivers have to return to the kinning park depot.

    ;;Multiple packages (such as pkgA...pkgF) going to different locations.
    ;;Different vehicles access rules using "allowed ?v ?l".
    ;;For example trucks may not be allowed in tight streets.
    ;;Walking connectivity (connected-walk ...) for local foot movement between neighbours like pollokshields to govanhill.
    ;;Road connectivity (road ...) for drivable routes.
    ;; Capacity limits through "capacity-available ?v".

    ;;Objects
    (:objects
        ;;drivers
        driver1 driver2 driver3 - driver

        ;;vehicles
        van1 truck1 bike1 - vehicle

        ;;packages
        pkgA pkgB pkgC pkgD pkgE pkgF - package

        ;;locations
        kinning-park-depot pollokshields govanhill shawlands battlefield langside mount-florida cathcart - location
    
    )

    ;;Initial State
    (:init
        ;;All of the drivers start on foot at the main depot.
        ;;They are also not initially boarded into the vehicles.
        (at-driver driver1 kinning-park-depot)
        (at-driver driver2 kinning-park-depot)
        (at-driver driver3 kinning-park-depot)

        ;;All of the vehicles start parked at the main depot.
        (at-vehicle van1 kinning-park-depot)
        (at-vehicle truck1 kinning-park-depot)
        (at-vehicle bike1 kinning-park-depot)

        ;;All of the packages start at the depot waiting to be delivered.
        (package-at pkgA kinning-park-depot)
        (package-at pkgB kinning-park-depot)
        (package-at pkgC kinning-park-depot)
        (package-at pkgD kinning-park-depot)
        (package-at pkgE kinning-park-depot)
        (package-at pkgF kinning-park-depot)

        ;;The vehicles begin with free capacity
        (capacity-available van1)
        (capacity-available truck1)
        (capacity-available bike1)

        ;;Access Permissions
        ;;The truck can reach main areas but not tight residentials.
        (allowed truck1 kinning-park-depot)
        (allowed truck1 cathcart)
        (allowed truck1 mount-florida) 
        (allowed truck1 langside) 
        (allowed truck1 shawlands)
        ;;truck1 is not allowed in govanhill/battlefield/pollockshields

        ;;The van can access most of the common delivery areas.
        (allowed van1 kinning-park-depot)
        (allowed van1 pollokshields)
        (allowed van1 govanhill)
        (allowed van1 shawlands)
        (allowed van1 langside)
        (allowed van1 battlefield)
        (allowed van1 mount-florida)
        ;;Cathcart is not included as it is truck-only

        ;;The bike (electric cargo bike) can access the dense residential areas.
        (allowed bike1 kinning-park-depot)
        (allowed bike1 pollokshields)
        (allowed bike1 govanhill)
        (allowed bike1 shawlands)
        (allowed bike1 battlefield)
        ;;The bike can't do long hauls (for example to langside/cathart)

        (assigned-vehicle driver1 van1)
        (assigned-vehicle driver2 truck1)
        (assigned-vehicle driver3 bike1)

        (driver-free driver1)
        (driver-free driver2)
        (driver-free driver3)

        ;;Road Connections
        ;;These are the road links for the vehicle movements
        ;;Depot Outbound:
        (road kinning-park-depot pollokshields)
        (road kinning-park-depot shawlands)
        (road kinning-park-depot langside)
        (road kinning-park-depot mount-florida)
        (road kinning-park-depot cathcart)

        ;;The return routes back to the depot
        (road pollokshields kinning-park-depot)
        (road shawlands kinning-park-depot)
        (road langside kinning-park-depot)
        (road mount-florida kinning-park-depot)
        (road cathcart kinning-park-depot)

        ;;These are the local inter-area connections
        (road pollokshields govanhill)
        (road govanhill pollokshields)
        (road shawlands battlefield)
        (road battlefield shawlands)
        (road shawlands langside)
        (road langside shawlands)
        (road langside mount-florida)
        (road mount-florida langside)
        (road mount-florida cathcart)
        (road cathcart mount-florida)

        ;;Walk Network
        ;;These are showing the short walking links between the dense-neighbourhoods.
        ;;This will support the "walk ..." action for drivers on foot.
        (connected-walk pollokshields govanhill)
        (connected-walk govanhill pollokshields)
        (connected-walk shawlands battlefield)
        (connected-walk battlefield shawlands)
        
    )

    ;;Goal State
    ;;All of the packages should be delivered to their destination locations across southside.
    ;;All drivers should be physically returned to kinning park depot.
    ;;All of the behicles should be returned back to kinning park depot.

    ;;The delivery targets are
    ;;pkgA to shawlands
    ;;pkgB to Battlefield
    ;;pkgC to Govanhill
    ;;pkgD to Langside
    ;;pkgE to Cathcart
    ;;pkgF to Mount Florida

    (:goal (and
        ;;package at the destinations
        (package-at pkgA shawlands)
        (package-at pkgB battlefield)
        (package-at pkgC govanhill)
        (package-at pkgD langside)
        (package-at pkgE cathcart)
        (package-at pkgF mount-florida)

        ;;all the vehicles returning back to the depot
        (at-driver driver1 kinning-park-depot)
        (at-driver driver2 kinning-park-depot)
        (at-driver driver3 kinning-park-depot)

        ;;all the vehicles returning back to the depot
        (at-vehicle van1 kinning-park-depot)
        (at-vehicle truck1 kinning-park-depot)
        (at-vehicle bike1 kinning-park-depot)
    ))

)

;;Analysis and Discussion
;;The plan was successful and it demonstrated all six actions:
;;walking, boarding, driving, loading, and unloading.

;;Drivers only used the vehicles that they were assigned to: 
;;driver1 = van1
;;driver2 = truck1
;;driver3 = bike1

;;Vehicle access restrictions affected how the deliveries were made by each driver: 
;;truck1 handled long distance areas.
;;van1 delivered to central areas
;;bike1 covered the dense streets (like Pollokshields, Govanhill, Battlefield)

;;The "driver-free" predicated had prevented actions made by the same driver which had ensured logical sequencing.