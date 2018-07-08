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

//Item Tab page
WorkerScript.onMessage = function(msg) {
	if ( msg.action === 'updateList' ) {
		/* Display */
		msg.model.clear();
		for ( var i = 0; i < msg.data.length; i++ ) {
			if ( msg.data[i].release > msg.data[i].installed )
			{
				WorkerScript.sendMessage({ 'action': 'update', 'id': msg.data[i].ident } )
			}
			msg.model.append( msg.data[i] );
			if ( (i%10) == 0 )
				msg.model.sync();
		}
	}
	msg.model.sync();
}



