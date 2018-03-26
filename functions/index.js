const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

const twilio = require('twilio');
const accountSid = functions.config().twilio.sid;
const authToken = functions.config().twilio.token;
const client = new twilio(accountSid, authToken);
const twilioNumber = '+14696601142';

exports.sendConfirmationCode = functions.https.onRequest((req, res) => {
    if(!req.body.phone){
        return res.status(422).send({ error: 'Bad Input' });
    }

    const phone = String(req.body.phone);
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
        admin.database().ref(`/users/${phone}/status`).set("verifying");
        admin.database().ref(`/users/${phone}/code`).set(code);
        return res.status(200).send({body: 'Success'});
    }).catch((err) =>{
        return res.status(422).send({err: err});
    });    
});



exports.verifyUserCode = functions.https.onRequest((req, res) => {
    if(!req.body.radiaCode){
        return res.status(422).send({ error: 'Bad Input' });
    }

    const code = String(req.body.radiaCode);
    const phone = String(req.body.phone);

    return admin.database().ref(`/users/${phone}`).child('code').once('value').then((snapshot) =>{
        if(parseInt(code) === parseInt(snapshot.val())){
            return admin.auth().createUser({uid: phone});
        }
        else{
            return Promise.resolve(null);
        }
    }).then((user) => {
        if(user !== null){
            admin.database().ref(`/users/${phone}/code`).remove();
            admin.database().ref(`/users/${phone}/status`).set('verified');
            return res.send(user);
        }
        else{
            return res.status(422).send({error: 'Invalid Code'});
        }
    }).catch((err) => { return res.status(422).send({error: err}) });
});

