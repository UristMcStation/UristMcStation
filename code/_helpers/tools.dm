/// True when this atom can be used as a wrench.
/atom/proc/IsWrench()
	return FALSE

/// Defines the base wrench as useable as a wrench.
/obj/item/wrench/IsWrench()
	return TRUE

/// True when A exists and can be used as a wrench.
#define isWrench(A) (A?.IsWrench())


/// True when this atom can be used as a Welder.
/atom/proc/IsWelder()
	return FALSE

/// Defines the base welder as useable as a welder.
/obj/item/weldingtool/IsWelder()
	return TRUE

/// True when A exists and can be used as a welder.
#define isWelder(A) (A?.IsWelder())


/// True when this atom can be used as a cable coil.
/atom/proc/IsCoil()
	return FALSE

/// Defines the base coil as useable as a cable coil.
/obj/item/stack/cable_coil/IsCoil()
	return TRUE

/// True when A exists and can be used as a cable coil.
#define isCoil(A) (A?.IsCoil())


/// True when this atom can be used as a wirecutter.
/atom/proc/IsWirecutter()
	return FALSE

/// Defines the base wirecutter as useable as a wirecutter.
/obj/item/wirecutters/IsWirecutter()
	return TRUE

/// True when A exists and can be used as a wirecutter.
#define isWirecutter(A) (A?.IsWirecutter())


/// True when this atom can be used as a screwdriver.
/atom/proc/IsScrewdriver()
	return FALSE

/// Defines the base screwdriver as useable as a screwdriver.
/obj/item/screwdriver/IsScrewdriver()
	return TRUE

/// True when A exists and can be used as a screwdriver.
#define isScrewdriver(A) (A?.IsScrewdriver())


/// True when this atom can be used as a multitool.
/atom/proc/IsMultitool()
	return FALSE

/// Defines the base multitool as useable as a multitool.
/obj/item/device/multitool/IsMultitool()
	return TRUE

/// True when A exists and can be used as a multitool.
#define isMultitool(A) (A?.IsMultitool())


/// True when this atom can be used as a crowbar.
/atom/proc/IsCrowbar()
	return FALSE

/// Defines the base crowbar as useable as a crowbar.
/obj/item/crowbar/IsCrowbar()
	return TRUE

/// True when A exists and can be used as a crowbar.
#define isCrowbar(A) (A?.IsCrowbar())


/// True when this atom can be used as a hatchet.
/atom/proc/IsHatchet()
	return FALSE

/// Defines the base hatchet as useable as a hatchet.
/obj/item/material/hatchet/IsHatchet()
	return TRUE

/// True when A exists and can be used as a hatchet.
#define isHatchet(A) (A?.IsHatchet())


/// True when this atom can be used as a flame source. This is for open flames.
/atom/proc/IsFlameSource()
	return FALSE

/// True when A exists and can be used as a flame source.
#define isFlameSource(A) (A?.IsFlameSource())


/**
 * Returns an integer value of temperature when this atom can be used as a heat source. This is for hot objects.
 *
 * Defaults to `1000` if `IsFlameSource()` returns `TRUE`, otherwise `0`.
 */
/atom/proc/IsHeatSource()
	return IsFlameSource() ? 1000 : 0

/// 0 if A does not exist, or the heat value of A
#define isHeatSource(A) (A ? A.IsHeatSource() : 0)


/// True when A exists and is either a flame or heat source
#define isFlameOrHeatSource(A) (A && (A.IsFlameSource() || !!A.IsHeatSource()))


/obj/item/proc/istool()
	return FALSE


/obj/item/stack/cable_coil/istool()
	return TRUE


/obj/item/wrench/istool()
	return TRUE


/obj/item/weldingtool/istool()
	return TRUE


/obj/item/screwdriver/istool()
	return TRUE


/obj/item/wirecutters/istool()
	return TRUE


/obj/item/device/multitool/istool()
	return TRUE


/obj/item/crowbar/istool()
	return TRUE


/**
 * For items that can puncture e.g. thick plastic but aren't necessarily sharp.
 *
 * Returns TRUE if the given item is capable of popping things like balloons, inflatable barriers, or cutting police tape. Also used to determine what items can eyestab.
 */
/obj/item/proc/can_puncture()
	return sharp || puncture


/obj/item/weldingtool/can_puncture()
	return welding


/obj/item/flame/can_puncture()
	return lit


/obj/item/clothing/mask/smokable/cigarette/can_puncture()
	return lit


//Whether or not the given item counts as sharp in terms of dealing damage
/proc/is_sharp(obj/obj)
	return obj?.edge || obj?.sharp || FALSE


//Whether or not the given item counts as cutting with an edge in terms of removing limbs
/proc/has_edge(obj/obj)
	return obj?.edge || FALSE
