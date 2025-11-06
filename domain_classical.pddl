(define (domain southside-classic)

    ;;Domain: southside-classic
    ;;Name: Syed Mohammed Arslan Kazmi

    ;;Context:
    ;;This domain models a parcel delivery system called "Southside Deliveries" which operate in the southside of Glasgow.
    ;;Drivers use vehicles to pick up packages from a depot then deliver them to multiple neighbourhoods (areas within southside of Glasgow).

    ;;Contstraints:
    ;;A driver must physically be with the vhicle to load/unload.
    ;;A driver must be inside a vehicle to drive it.
    ;;Vehicles have a limited capacity.
    ;;Multiple drivers, vehicles, and packages are included to show realistic logistics complexity.

    ;;Capacity Model:
    ;;(capacity-available ?v) is used. If its true, the vehicle still has room for another package.
    ;;After loading the van, its cleared and it is restored once its unloaded.

    (:requirements
        :strips
        :typing
        :negative-preconditions
    )

    ;;Types
    ;;Drivers (human agents)
    ;;Vehicles (van, truck, bike)
    ;;Packages (parcels being delivered)
    ;;locations (Southside Glasgow areas)

    (:types
        driver
        vehicle
        package
        location
    )

    ;;Predicates
    ;;These are to describe the state of the whole delivery system.
    (:predicates
        
        ;;Driver ?d is at location ?l on foot (not inside of the vehicle)
        (at-driver ?d - driver ?l - location)

        ;;Vehicle ?v is parked at location ?l
        (at-vehicle ?v - vehicle ?l - location)

        ;;Driver ?d is inside/operative the vehicle ?v.
        ;;Used so only a driver that is onboard can move the vehicle
        (in-vehicle ?d - driver ?v - vehicle)

        ;;package ?p is inside the vehicle ?v
        ;;if the vehicle moves, the package inside is also moving inside with it.
        (package-in ?p - package ?v - vehicle)

        ;;Drivers will be allow to walk between ?l1 and ?l2 (as they are walkable distance from each other)
        ;;Used by the (walk ...) action.
        (connected-walk ?l1 - location ?l2 - location)

        ;;The package ?p is at ?l (not loaded)
        ;;It is updated by the load-package and unload-package actions
        (package-at ?p - package ?l - location)

        ;;Vehicles can drive from ?l1 to ?l2 along a road link
        ;;Used by the (drive-vehicle ...) action
        (road ?l1 - location ?l2 - location)

        ;;(allowed ?v ?l) means vehicle ?v is allowed to enter location ?l
        ;;This allow restrictions such as large trucks unable to go through narrow streets
        (allowed ?v - vehicle ?l - location)

        ;;(capacity-available ?v) means the vehicle has free cargo space
        ;;After loading, it is removed. After unloading, it is added back.
        (capacity-available ?v - vehicle)

        ;;Marker added to show that the package is successfully delivered.
        (delivered ?p - package)

        (assigned-vehicle ?d - driver ?v - vehicle)

        (driver-free ?d - driver)
    )

    ;;Actions
    ;;Each action is non-durative

    ;;Action - Walk
    ;;A driver walks from one location to another that is marked as "walk-connected".
    ;;This represents short local movement that is done on foot (such as streets in Govanhill/Pollokshields).
    (:action walk
        :parameters (
            ?d - driver ?from - location ?to - location
        )
        :precondition (and 
            (at-driver ?d ?from)
            (connected-walk ?from ?to)
            (driver-free ?d)
        )
        :effect (and
            (at-driver ?d ?to)
            (not (at-driver ?d ?from))
            (not (driver-free ?d))
            (driver-free ?d)
        )
    )


    ;;Action - board-vehicle
    ;;A driver boards a vehicle at a location
    ;;This represents the link between "on foot" and "in vehicle".
    (:action board-vehicle
        :parameters (
            ?d - driver ?v - vehicle ?l - location
        )
        :precondition (and 
            (at-driver ?d ?l)
            (at-vehicle ?v ?l)
            (assigned-vehicle ?d ?v)
            (driver-free ?d)
        )
        :effect (and 
            (in-vehicle ?d ?v) 
            (not(at-driver ?d ?l))
            (not (driver-free ?d))
            (driver-free ?d)
        )
    )
    

    ;;Action - unboard-vehicle
    ;;The driver exits the vehicle. They become "at-driver" at the vehicles current location.
    ;;They are then no longer in the vehicle
    (:action unboard-vehicle
        :parameters (
            ?d - driver ?v - vehicle ?l - location
        )
        :precondition (and 
            (in-vehicle ?d ?v)
            (at-vehicle ?v ?l)
            (driver-free ?d)
        )
        :effect (and 
            (at-driver ?d ?l)
            (not(in-vehicle ?d ?v))
            (not (driver-free ?d))
            (driver-free ?d)
        )
    )

    ;;Action - drive-vehicle
    ;;A driver drives a specific vehicle from ?from to ?to.
    
    ;;Constraints:
    ;;The driver must be already inside the vehicle
    ;;Vehicle has to be parked at ?from
    ;;There must be a defined road connection (?from to ?to).
    ;;The vehicle has to have allowed access ?to.

    ;;Effect:
    ;;The vehicle is now at ?to (not at ?from).
    ;;The driver is still inside the vehicle (in-vehicle = true)
    ;;Any packages that are already loaded in the vehicle moves.
    ;;Packages (package-in ?p ?v) remain loaded so are considered to have travelled with the vehicle.
    (:action drive-vehicle
        :parameters (
            ?d - driver ?v - vehicle ?from - location ?to - location
        )
        :precondition (and 
            (in-vehicle ?d ?v)
            (at-vehicle ?v ?from)
            (road ?from ?to)
            (allowed ?v ?to)
            (driver-free ?d)
        )
        :effect (and
            (at-vehicle ?v ?to)
            (not(at-vehicle ?v ?from))
            (not (driver-free ?d))
            (driver-free ?d)
        )
    )
    
    ;;Action - load-package
    ;;The driver loads a package from the ground at location ?l into a vehicle parked at the same location.
    
    ;;The driver must be physically present (on foot) at the location.
    ;;The vehicle must be at the same location.
    ;;The package must be at the same location.
    ;;The vehicle must have capacity available.

    ;;After loading, (capacity-available ?v) is removed.
    ;;This means no more packages can be loaded until one is unloaded.
    
    (:action load-package
        :parameters (
            ?d - driver ?v - vehicle ?p - package ?l - location
        )
        :precondition (and 
            (at-driver ?d ?l)
            (at-vehicle ?v ?l)
            (package-at ?p ?l)
            (capacity-available ?v)
            (driver-free ?d)
        )
        :effect (and
            (package-in ?p ?v)
            (not(package-at ?p ?l))
            (not(capacity-available ?v))
            (not (driver-free ?d))
            (driver-free ?d)
        )
    )

    ;;Action - unload-package
    ;;The driver unloads a package from a vehicle into the current location.
    ;;(drops it off/delivers it).

    ;;The driver must be physically present (on foot) at the location.
    ;;The vehicle is at the drop off location.
    ;;The package is currently in the vehicle.

    ;;Unloaded will free capacity again (capacity-available).

    (:action unload-package
        :parameters (
            ?d - driver ?v - vehicle ?p - package ?l - location
        )
        :precondition (and 
            (at-vehicle ?v ?l)
            (at-driver ?d ?l)
            (package-in ?p ?v)
            (driver-free ?d)
        )
        :effect (and
            (package-at ?p ?l)
            (not(package-in ?p ?v))
            (capacity-available ?v)
            (not (driver-free ?d))
            (driver-free ?d)
        )
    )
    
    
    
)