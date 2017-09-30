const functions = require('firebase-functions');
const admin = require('firebase-admin');
 
admin.initializeApp(functions.config().firebase);
const userRef = functions.database.ref('/Users')

exports.updateInformations = userRef.onWrite(event => {
    
});
