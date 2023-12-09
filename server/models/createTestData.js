const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const sentConnection= require('./sentConnection');
const connections= require('./connections');
const post= require('./post');
const like= require('./like');
const comment= require('./comment');
const bcrypt = require('bcrypt');
var iLimit = 80;
 User.create({
    firstname: "Ahmad",
    lastname: "Othman",
    username: "AhmadOthman",
    email: "ahmadmajed20188@gmail.com",
    password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
    photo: "AhmadOthmanNaN1700761827122-645531203.jpg",
    phone: "0569929734",
    dateOfBirth: "2001-05-18",
});
 User.create({
    firstname: "Ahmad",
    lastname: "Majed",
    username: "AhmadMajed",
    email: "ahmadmajed201999@gmail.com",
    password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
    photo: "AhmadOthmanNaN1700761827122-645531203.jpg",
    phone: "0569929734",
    dateOfBirth: "2001-05-18",
});
User.create({
    firstname: "mohammad",
    lastname: "Othman",
    username: "MohammadOthman",
    email: "mohammadothman@gmail.com",
    password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
    phone: "0569929734",
    dateOfBirth: "2001-05-18",
});
 User.create({
    firstname: "omar",
    lastname: "mohammad",
    username: "omarmohammad",
    email: "omarmohammad@gmail.com",
    password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
    phone: "0569929734",
    dateOfBirth: "2001-05-18",
});
for(let i =0 ; i<iLimit ; i++){
    User.create({
        firstname: "Ahmad",
        lastname: "Othman",
        username: "ahmad" + i,
        email: "ahmad"+i+"@gmail.com",
        password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
        phone: "0569929734",
        dateOfBirth: "2001-05-18",
    });
}
for(let i =0 ; i<iLimit/4 ; i++){
    sentConnection.create({
        senderUsername: "ahmad" + i,
        receiverUsername: "AhmadOthman",
        date: new Date(),
    });
}
for(let i =iLimit/4; i<iLimit/2 ; i++){
    sentConnection.create({
        senderUsername: "AhmadOthman",
        receiverUsername: "ahmad" + i,
        date: new Date(),
    });
}
for(let i =iLimit/2; i<iLimit*(3/4) ; i++){
    connections.create({
        senderUsername: "AhmadOthman",
        receiverUsername: "ahmad" + i,
        date: new Date(),
    });
}
for(let i =0; i<iLimit ; i++){
    post.create({
        postContent: "post " + i, 
        selectedPrivacy: "Any One", 
        postDate: new Date(),
        username: "AhmadOthman",
        date: new Date(),
    });
}
for(let i =iLimit/2; i<iLimit*(3/4) ; i++){
    for(let j =1; j<iLimit ; j++)
    like.create({
        postId: j,
        username: "ahmad"+ i,
    });
}
for(let i =iLimit/2; i<iLimit*(3/4) ; i++){
    for(let j =1; j<iLimit ; j++)
    comment.create({
        postId: j,
        username: "ahmad"+ i,
        commentContent: "ahmad"+ i, 
        Date: new Date()
    });
}
for(let i =0; i<iLimit ; i++){
    for(let j =0; j<10 ; j++)
    post.create({
        postContent: "my post : ahmad" + i + "post " + i, 
        selectedPrivacy: "Any One", 
        postDate: new Date(),
        username: "ahmad" + i,
        date: new Date(),
    });
}

