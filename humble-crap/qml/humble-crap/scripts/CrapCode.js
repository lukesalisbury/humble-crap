var DEFINES = {
	databaseQuery: 1,
	statusUpdate: 2,
	downloadRequest: 9,
	message: 3,
	productSetup: 4,
	productPlay: 5,
	productUpdate: 6,
	productDownload: 7,
	productHasUpdate: 8
}

var SERVER = "https://www.humblebundle.com/api/v1/order/"
//var SERVER = "http://localhost/api/v1/order/"

/* Functions */
function qmlComponent(file, parent, data) {
	var comp = Qt.createComponent('../'+file)
	if (comp.status === Component.Ready) {
		return comp.createObject(parent, data)
	} else if (comp.status === Component.Null) {
		console.error('QMLComponent is null')
	} else if (comp.status === Component.Error) {
		console.error('QMLComponent', comp.errorString())
	} else {
		console.log('QMLComponent still loading or other error')
	}
	return null
}


function downloadProduct(address, productId, machineName, queueId) {
	/*
	 Humble Downloads are stored on dl.humble.com and have 3 arguments,
	 the gamekey, time to live and token.
	 Since we can't built the token, we need to get the latest order page
	 for game key, then exact the new url and download that.
	 Note: using HUMBLEURL_DOWNLOADSIGN instead

	 An Issues will be resuming download...
	*/

	//Strip Query String
	address = address.indexOf('?') > 0 ? address.substring(0, address.indexOf('?')) : address
	// we need the path and filename only
	var filename = address.split('/').slice(3).join('/');

	if ( productId && machineName && filename )
		humbleUser.retrieveSignedDownloadURL(productId, machineName, filename)

}
