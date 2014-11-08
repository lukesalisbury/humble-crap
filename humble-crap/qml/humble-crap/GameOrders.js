
WorkerScript.parseOrderDownload = function( id, downloads ) {
	var types = "|"
	for ( var i = 0; i < downloads.length; i++ ) {
		types += downloads[i].platform + "|";

		for ( var q = 0; q < downloads[i].download_struct.length; q++ ) {
			var w = downloads[i].download_struct[q]
			if ( w.url )
			{
				WorkerScript.sendMessage({
											'action': 'replaceDownload',
											'query': {
												'id': id,
												'platform': downloads[i].platform,
												'subplatform': w.name,
												'version': downloads[i].download_version_number,
												'date': w.timestamp,
												'torrent': w.url.bittorrent,
												'url': w.url.web,
												'sha1': w.sha1,
												'size':w.file_size
											 }
										 })
			}
		}
	}
	return types
}

WorkerScript.parseOrder = function( orderid, ordercache ) {

	var obj = JSON.parse( ordercache );


	for ( var i = 0; i < obj.subproducts.length; i++ ) {
		var item = obj.subproducts[i];

		var types = this.parseOrderDownload( item.machine_name, item.downloads )
		WorkerScript.sendMessage({ 'action': 'replaceListing', 'query': { 'ident': item.machine_name, 'product':item.human_name, 'type':types } })
	}
}


WorkerScript.onMessage = function(msg) {

	if ( msg.action === 'readOrders' ) {
		/* Read the orders */
		for ( var i = 0; i < msg.data.length; i++ ) {
			this.parseOrder( msg.data[i].id, msg.data[i].cache  )
		}
		WorkerScript.sendMessage({ 'action': 'complete' } )
	}
	else if ( msg.action === 'updateList' ) {
		/* Display */
		msg.model.clear();
		msg.model.sync();
		for ( var i = 0; i < msg.data.length; i++ ) {
			if ( msg.data[i].date > msg.data[i].installDate )
			{
				WorkerScript.sendMessage({ 'action': 'update', 'id': msg.data[i].ident } )
			}
			msg.model.append( msg.data[i] );
			msg.model.sync();
		}

	}
}
