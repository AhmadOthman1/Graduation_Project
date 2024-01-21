const Sequelize = require('sequelize');
const sequelize = require('../../util/database');
const messages = require("../../models/messages");
const groupMessage = require("../../models/groupMessage");
const path = require('path');
const fs = require('fs');
//Video
exports.messageSaveVideo = async (userUsername, messageVideoBytes,messageVideoBytesName,messageVideoExt) => {
    //while(true);
        const photoBuffer = Buffer.from(messageVideoBytes, 'base64');
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        const newphotoname = userUsername + "-" + uniqueSuffix + "." + messageVideoExt; 
        const uploadPath = path.join('messageVideos', newphotoname);

        // Save the image to the server
        fs.writeFileSync(uploadPath, photoBuffer);
        return newphotoname;
}
exports.messageSaveImage = async (userUsername, messageImageBytes,messageImageBytesName,messageImageExt) => {
    //while(true);
        const photoBuffer = Buffer.from(messageImageBytes, 'base64');
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        const newphotoname = userUsername + "-" + uniqueSuffix + "." + messageImageExt;
        const uploadPath = path.join('messageImages', newphotoname);

        // Save the image to the server
        fs.writeFileSync(uploadPath, photoBuffer);
        return newphotoname;
}

exports.messagesControl = async (userUsername, username, message,messageImageName,messageVideoName) => {
    //while(true);
    await messages.create({
        senderUsername: userUsername,
        receiverUsername: username,
        text: message,
        image: messageImageName,
        video:messageVideoName,
        createdAt: new Date(),
    });
}
exports.pageMessagesControl = async (pageId, username, message,messageImageName,messageVideoName) => {
    //while(true);
    await messages.create({
        senderPageId: pageId,
        receiverUsername: username,
        text: message,
        image: messageImageName,
        video:messageVideoName,
        createdAt: new Date(),
    });
}
exports.messagesToPageControl = async ( username,pageId, message,messageImageName,messageVideoName) => {
    //while(true);
    await messages.create({
        senderUsername: username,
        receiverPageId: pageId,
        text: message,
        image: messageImageName,
        video:messageVideoName,
        createdAt: new Date(),
    });
}
exports.groupMessagesControl = async (userUsername, groupId, message,messageImageName,messageVideoName) => {
    //while(true);
    await groupMessage.create({
        senderUsername: userUsername,
        groupId: groupId,
        text: message,
        image: messageImageName,
        video:messageVideoName,
        createdAt: new Date(),
    });
}
