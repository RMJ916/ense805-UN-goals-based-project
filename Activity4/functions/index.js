const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().functions);
exports.event = functions.firestore.document("/events/{id}")
    .onCreate((snapshot, context) => {
      // const _title = context.params.id;
      const newValue = snapshot.data();
      const _title = newValue.title;
      const _dec = newValue.dec;
      console.log(_dec);

      admin.firestore().collection("usertoken").get().then((snapshots) => {
        const tokens = [];
        for (const token of snapshots.docs) {
          tokens.push(token.data().token);
        }
        const mess = {
          notification: {
            title: _title,
            body: _dec,
          },
        };
        admin.messaging().sendToDevice(tokens, mess)
            .then((response) => {
              console.log("succes");
            })
            .catch((error) => {
              console.log("error");
            });
      });
    });

exports.boradcastroom = functions.firestore
    .document("/broadcastrooms/{id}/posts/{pid}")
    .onCreate((snapshot, context) => {
      const valu = snapshot.data();
      const dec = valu.description;
      console.log(dec);
      const id = context.params.id;
      admin.firestore().collection("broadcastrooms").doc(id)
          .get().then((snap) => {
            const newValue = snap.data();
            const _name = newValue.name;
            console.log(_name);
            const mess = {
              notification: {
                title: _name,
                body: dec,
              },
            };
            admin.firestore().collection("usertoken")
                .get().then((snapshots) => {
                  const tokens = [];
                  for (const token of snapshots.docs) {
                    tokens.push(token.data().token);
                  }
                  admin.messaging().sendToDevice(tokens, mess)
                      .then((response) => {
                        console.log("succes");
                      })
                      .catch((error) => {
                        console.log("error");
                      });
                });
          });
    });
