/obj/structure/vaultdoor
	name = "vault door 113"
	icon = 'icons/obj/doors/gear.dmi'
	icon_state = "closed"
	density = TRUE
	opacity = 1
	layer = WALL_OBJ_LAYER
	anchored = TRUE
	var/is_busy = FALSE
	var/destroyed = FALSE
	var/isworn = FALSE
	var/is_open = FALSE
	max_integrity = 450
	resistance_flags = FIRE_PROOF | ACID_PROOF   //it's a fucking steel door
	armor = list("melee" = 75, "bullet" = 15, "laser" = 0, "energy" = 0, "bomb" = 45, "bio" = 100, "rad" = 100, "fire" = 99, "acid" = 100)

/obj/structure/vaultdoor/blob_act()
	if(prob(1))
		qdel(src)
	return

/obj/structure/vaultdoor/ex_act(severity, target)
	if(severity == 1)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		destroy()
		return

/obj/structure/vaultdoor/proc/destroy()
	icon_state = "empty"
	set_opacity(0)
	src.density = FALSE
	destroyed = TRUE

/obj/structure/vaultdoor/proc/open()
	is_busy = TRUE
	flick("opening", src)
	icon_state = "open"
	playsound(loc, 'sound/f13machines/doorgear_open.ogg', 50, 0, 10)
	sleep(30)
	set_opacity(0)
	src.density = FALSE
	is_busy = FALSE
	is_open = TRUE

/obj/structure/vaultdoor/proc/close()
	is_busy = TRUE
	flick("closing", src)
	icon_state = "closed"
	playsound(loc, 'sound/f13machines/doorgear_close.ogg', 50, 0, 10)
	sleep(30)
	set_opacity(1)
	src.density = TRUE
	is_busy = FALSE
	is_open = FALSE

/obj/structure/vaultdoor/proc/vaultactivate()
	if(destroyed)
		to_chat(usr, "<span class='warning'>[src] is broken</span>")
		return
	if(is_busy)
		to_chat(usr, "<span class='warning'>[src] is busy</span>")
		return
	if(density)
		open()
		return
	close()

/obj/structure/vaultdoor/attackby(obj/item/I, mob/living/user, params)
	add_fingerprint(user)
	if(istype(I, /obj/item/weldingtool) && user.a_intent == INTENT_HELP)
		if(obj_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=0))
				return

			to_chat(user, "<span class='notice'>You begin repairing [src]...</span>")
			if(I.use_tool(src, user, 40, volume=50))
				obj_integrity = max_integrity
				to_chat(user, "<span class='notice'>You repair [src].</span>")
		else
			to_chat(user, "<span class='warning'>[src] is already in good condition!</span>")
		return

//ß íå õî÷ó ïåðåäåëûâàòü ýòî äåðüìî  - Google translate tells me that from Russian to english this is "Do not move your arms around this way." so dont.





/obj/machinery/doorButtons/vaultButton
	name = "vault access"
	icon = 'icons/obj/lever.dmi'
	icon_state = "lever0"
	anchored = TRUE
	density = TRUE

/obj/machinery/doorButtons/vaultButton/proc/activate()
	for(var/obj/structure/vaultdoor/vdoor in world)
		vdoor.vaultactivate()

/obj/machinery/doorButtons/vaultButton/attackby(obj/item/weapon/W, mob/user, params)
	activate()

/obj/machinery/doorButtons/vaultButton/attack_hand(mob/user)
	activate()
//new vault door button
/obj/machinery/doorButtons/wornvaultButton
	name = "worn vault access"
	icon = 'icons/obj/lever.dmi'
	icon_state = "lever0"
	anchored = TRUE
	density = TRUE

/obj/machinery/doorButtons/wornvaultButton/proc/activate()
	for(var/obj/structure/vaultdoor/vdoor in world)
		if(vdoor.isworn == TRUE)
			vdoor.vaultactivate()

/obj/machinery/doorButtons/wornvaultButton/attackby(obj/item/weapon/W, mob/user, params)
	activate()

/obj/machinery/doorButtons/wornvaultButton/attack_hand(mob/user)
	activate()