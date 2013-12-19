
open Ezxmlm

let get_location_tag xml =
	let dwml = member "dwml" xml in
	(* Also have to check if type=forecast*) 
		let data = member "data" dwml in
			let location_tag = member "location" data in
				location_tag;;

let get_location_name xml =
	let location_tag = get_location_tag xml in
		let desc = member "description" location_tag in
			to_string desc;; 

let get_location_elev xml =
	let location_tag = get_location_tag xml in 
		let elev = member "description" location_tag in
			int_of_string (to_string elev);;