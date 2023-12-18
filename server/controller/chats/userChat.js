const Sequelize = require('sequelize');
const sequelize = require('../../util/database');
const messages = require("../../models/messages");



exports.messagesControl = async (userUsername, username, message) => {
    //while(true);
    await messages.create({
        senderUsername: userUsername,
        receiverUsername: username,
        text: message,
        createdAt: new Date(),
    });
}
