const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

const twilio = require('twilio');
const accountSid = functions.config().twilio.sid;
const authToken = functions.config().twilio.token;
const client = new twilio(accountSid, authToken);
const twilioNumber = '+14696601142';

exports.sendConfirmationCode = functions.https.onRequest((req, res) => {

    if(!req.body.phone || !req.body.firstName || !req.body.lastName){
        return res.status(422).send({ error: 'Bad Input' });
    }

    const phone = String(req.body.phone);
  	const firstName = String(req.body.firstName);
  	const lastName = String(req.body.lastName);

    if(!/^\+?[1-9]\d{1,14}$/.test(phone)){
        return res.status(422).send({ error: 'Invalid Number' });
    }

    var code = Math.floor(100000 + Math.random() * 900000);
    const textMessage = {
        body: `Your Radia confirmation code is: ${code}`,
        to: phone,
        from: twilioNumber
    }

    return client.messages.create(textMessage).then((val) => {
      	var uid = admin.database().ref('/users').push();
      	uid.set({
        	'phone':phone,
          	'fistName':firstName,
          	'lastName':lastName,
          	'code':code,
          	'status':'verifying'
        });

        return res.status(200).send({uid: uid.key});
    }).catch((err) =>{
        return res.status(422).send({err: err});
    });
});

exports.verifyUserCode = functions.https.onRequest((req, res) => {

    if(!req.body.uid || 
        !req.body.radiaCode || 
        !req.body.password ||
        !req.body.phoneNumber){
        return res.status(422).send({ error: 'Bad Input' });
    }

    const code = String(req.body.radiaCode);
    const uid = String(req.body.uid);
    const password = String(req.body.password);
    const phoneNumber = String(req.body.phoneNumber);

    return admin.database().ref(`/users/${uid}`).child('code').once('value').then((snapshot) =>{
        if(parseInt(code) === parseInt(snapshot.val())){
            return admin.auth().createUser({
                uid: uid,
                password: password,
                phoneNumber: phoneNumber,
            });
        }
        else{
            return Promise.resolve(null);
        }
    }).then((user) => {
        if(user !== null){
            admin.database().ref(`/users/${uid}/code`).remove();
            admin.database().ref(`/users/${uid}/status`).set('verified');
            return res.send({'uid':uid});
        }
        else{
            return res.status(422).send({error: 'Invalid Code'});
        }
    }).catch((err) => { return res.status(422).send({error: err}) });
});



