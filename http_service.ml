open Core.Std
open Lwt
open Ezxmlm
open Cow

type service = 
	{
	 mutable base_url: string;
	 mutable parameters: (string) String.Table.t;
	};;

let create = 
	let inst = {base_url="http://forecast.weather.gov/MapClick.php?"; parameters = String.Table.create () ~size:4;} in 
		List.iter ~f:(fun (key, data) -> Hashtbl.set inst.parameters ~key ~data)[ ("lat", "47.73"); ("lon", "-121.09"); ("unit", "0"); ("lg", "english"); ("FcstType", "dwml");];
		inst;;

let set_base_url http_service url =
	http_service.base_url <- url;
	http_service.base_url;;

let set_lon http_service lon = 
	Hashtbl.replace http_service.parameters ~key:"lon" ~data:lon;
	lon;;
		
let get_parameter_lon http_service =
	match (Hashtbl.find http_service.parameters "lon") with 
		| Some(x) -> x
		| _ -> "";;

let set_lat http_service lat = 
	Hashtbl.replace http_service.parameters ~key:"lat" ~data:lat;
	lat;;

let get_parameter_lat http_service =
	match (Hashtbl.find http_service.parameters "lat") with 
		| Some(x) -> x
		| _ -> "";;

let generate_parameter_request_str http_service = 
	let tmp = Hashtbl.fold ~f:(fun ~key:k ~data:v acc -> (k^"="^v)::acc) http_service.parameters ~init:[] in
	String.concat ~sep:"&" tmp;; 

let make_request http_service = Lwt.(Cohttp_lwt_unix.(Lwt_unix.run (Client.get Uri.(of_string (http_service.base_url^(generate_parameter_request_str http_service))) >>= function None -> assert false |Some (r,b) -> Cohttp_lwt_body.string_of_body b)));;

let parse_to_xml request = 
	let dtdXml = Ezxmlm.from_string request in
		match dtdXml with
		(_, xml) -> xml;;
