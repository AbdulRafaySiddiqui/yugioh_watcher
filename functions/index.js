const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.database();
const fcm = admin.messaging();
const axios = require('axios');
let moment = require('moment');

const condition = "'new_item_added' in topics";

//Reddit Item Fetch and Delete
const redditURL = "https://www.reddit.com/r/YGOMarketplace/new.json?sort=new";

exports.fetchRedditPosts = functions.pubsub.schedule("every 30 minutes").onRun((context) => {
    return axios.get(redditURL).then((response) => {
        return response.data["data"]["children"].forEach((i) => {
            item = i["data"];
            var now = new Date().getTime(); //current timestamp
            db.ref("reddit_items").child(item["id"].toString()).set(item);
        });
    }).catch((error) => {
        console.log("Fetch Reddit Post Error:", error);
    });
});

exports.deleteOldRedditPosts = functions.pubsub.schedule("every 5 hours").onRun(async (context) => {
    return db.ref("reddit_items").once('value').then(async snapshot => {
        let items = snapshot.val();
        if (items) {
            for (const key in items) {
                let created = moment(new Date(items[key]["created"])); //created date
                var now = moment(new Date()); //todays date
                var duration = moment.duration(now.diff(created));
                var Hour = parseInt(duration.asHours());
                if (Hour >= 5) {
                    db.ref("reddit_items/" + items[key]["id"]).remove().then(() => {
                        console.log("reddit item deleted: " + key); return { "response": "OK" };
                    }).catch(error => console.log("Reddit Item Delete Error: ", error));
                }
            }
        }
        return { "response": "OK" };
    }).catch(error => {
        console.log("Reddit Post Delete Error", error);
    });
});

//Notifications
exports.notifyForTwitter = functions.database.ref('Twitter_search/{collection}/statuses/{id}').onCreate((snapshot, context) => {
    const item = snapshot.val();
    const message = {
        notification: {
            title: "Twitter new item",
            body: item["text"],
        },
        condition: condition,
    }
    return fcm.send(message).catch(error => console.log(error));
});

exports.notifyForCragslist = functions.database.ref('craigslist/{collection}/{id}').onCreate((snapshot, context) => {
    const item = snapshot.val();
    const message = {
        notification: {
            title: "Craigslist new item",
            body: item["title"],
        },
        condition: condition,
    }
    return fcm.send(message).catch(error => console.log(error));
});


exports.notifyForEbay = functions.database.ref('eBay_Items/{id}').onCreate((snapshot, context) => {
    const item = snapshot.val();
    const message = {
        notification: {
            title: "eBay new item",
            body: item["title"]["0"],
        },
        condition: condition,
    }
    return fcm.send(message).catch(error => console.log(error));
});

exports.notifyForReddit = functions.database.ref('reddit_items/{id}').onCreate((snapshot, context) => {
    const item = snapshot.val();
    const message = {
        notification: {
            title: "Reddit new item",
            body: item["title"],
        },
        condition: condition,
    }
    return fcm.send(message).catch(error => console.log(error));
});