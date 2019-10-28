/****************************************************************************
* Copyright © Luke Salisbury
*
* This software is provided 'as-is', without any express or implied
* warranty. In no event will the authors be held liable for any damages
* arising from the use of this software.
*
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
*
* 1. The origin of this software must not be misrepresented; you must not
*    claim that you wrote the original software. If you use this software
*    in a product, an acknowledgement in the product documentation would be
*    appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
*    misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
****************************************************************************/
//.pragma library
Qt.include('CrapDefines.js')


// Functions
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

function listItemCheckStatus(releaseDate, installedDate, dbExecutable) {
	canPlay = ( dbExecutable !== null && dbExecutable !== "" )
	hasUpdate = ( releaseDate > installedDate )

	if ( hasUpdate ) {
		return DEFINES.productUpdate
	} else if ( canPlay ) {
		return DEFINES.productPlay
	} else {
		return DEFINES.productDownload
	}
}

function downloadProduct(address, category, productId, machineName, queueId) {

	// Humble Downloads are stored on dl.humble.com and have 3 arguments,
	// the gamekey, time to live and token.
	// Since we can't built the token, we need to get the latest order page
	// for game key, then exact the new url and download that.
	// Note: using HUMBLEURL_DOWNLOADSIGN instead
	//
	// An Issues will be resuming download...

	console.log(address, productId, machineName)

	//Strip Query String
	address = address.indexOf('?') > 0 ? address.substring(0, address.indexOf('?')) : address

	// we need the path and filename only
	var filename = address.split('/').slice(3).join('/');

	if ( productId && machineName && filename )
		humbleUser.retrieveSignedDownloadURL(productId, category, machineName, filename)

}
