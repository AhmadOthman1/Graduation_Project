const Sequelize = require('sequelize');
const sequelize = require('../../util/database');
const messages = require("../../models/messages");
const path = require('path');
const fs = require('fs');
//Video
exports.messageSaveVideo = async (userUsername, username, messageVideoBytes,messageVideoBytesName,messageVideoExt) => {
    //while(true);
        const photoBuffer = Buffer.from(messageVideoBytes, 'base64');
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        const newphotoname = userUsername + "-" + uniqueSuffix + "." + messageVideoExt; 
        const uploadPath = path.join('messageVideos', newphotoname);

        // Save the image to the server
        fs.writeFileSync(uploadPath, photoBuffer);
        return newphotoname;
}
exports.messageSaveImage = async (userUsername, username, messageImageBytes,messageImageBytesName,messageImageExt) => {
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
