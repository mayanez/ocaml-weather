open Cow

let _ =
	let client = Http_service.create in
		let request = Http_service.make_request client in
			let xml = Http_service.parse_to_xml request in
				prerr_endline(Cow.Xml.to_string xml);;
