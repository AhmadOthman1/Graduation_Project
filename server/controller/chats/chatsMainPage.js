const User = require("../../models/user");
const Page = require("../../models/pages");
const Connections = require("../../models/connections");
const ActiveUsers = require("../../models/activeUsers");
const Messages = require("../../models/messages");
const { Op } = require('sequelize');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const sequelize = require('sequelize');
const jwt = require('jsonwebtoken');
require('dotenv').config();

exports.getChats = async (req, res, next) => {
    try {
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        var activeConnectionsInfo = [];
        const activeConnections = [];
        const userConnections = await Connections.findAll({
            where: {
                [Op.or]: [
                    { senderUsername: userUsername },
                    { receiverUsername: userUsername },
                ],
            },
            include: [
                {
                    model: User,
                    as: 'senderUsername_FK',
                },
                {
                    model: User,
                    as: 'receiverUsername_FK',
                },
            ],
        });

        // Check each user from userConnections if they are exist in activeUsers
        if (userConnections !=null) {
            for (const connection of userConnections) {
                var senderIsActive;
                var receiverIsActive;
                if (connection.senderUsername_FK.username != userUsername) {

                    senderIsActive = await ActiveUsers.findOne({
                        where: { username: connection.senderUsername_FK.username },
                    });
                    if (senderIsActive) {
                        activeConnections.push(connection.senderUsername_FK.username);
                    }
                }
                else {
                    receiverIsActive = await ActiveUsers.findOne({
                        where: { username: connection.receiverUsername_FK.username },
                    });
                    if (receiverIsActive) {
                        activeConnections.push(connection.receiverUsername_FK.username);
                    }
                }
            }
            if (activeConnections) {

                for (const activeConnection of activeConnections) {
                    const connectionInfo = await User.findOne({
                        where: {
                            username: activeConnection
                        },
                        attributes: ['username', 'firstname', 'lastname', 'photo'],
                    });
                    activeConnectionsInfo.push(connectionInfo);
                }
                

            }

        }
        //console.log(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
        //console.log(activeConnectionsInfo);
        const conversations = await Messages.findAll({
            attributes: [
                'senderUsername',
                'receiverUsername',
                [sequelize.fn('MAX', sequelize.col('messages.createdAt')), 'latestMessageDate'],
            ],
            where: {
                [Op.or]: [
                    { senderUsername: userUsername },
                    { receiverUsername: userUsername },
                ],
            },
            group: [
                'senderUsername',
                'receiverUsername',
                'senderPageId_FK.id',
                'receiverPageId_FK.id',
            ],
            include: [
                {
                    model: User,
                    as: 'senderUsername_FK',
                    attributes: ['username', 'firstName', 'lastName', 'photo'],
                },
                {
                    model: User,
                    as: 'receiverUsername_FK',
                    attributes: ['username', 'firstName', 'lastName', 'photo'],
                },
                {
                    model: Page,
                    as: 'senderPageId_FK',
                    attributes: ['id', 'name', 'photo'],
                },
                {
                    model: Page,
                    as: 'receiverPageId_FK',
                    attributes: ['id', 'name', 'photo'],
                },
            ],
            order: [[sequelize.literal('latestMessageDate'), 'DESC']],
        });
        //console.log(conversations.map((conversation) => conversation.toJSON()));


        const uniqueConversationsId = new Set();
        var uniqueConversations = [];
        conversations.forEach((conversation) => {
            if (
                conversation.senderUsername &&
                !uniqueConversationsId.has(conversation.senderUsername) &&
                conversation.senderUsername !== userUsername
            ) {
                uniqueConversationsId.add(conversation.senderUsername);
                uniqueConversations.push(conversation.get({ plain: true }));
            }

            if (
                conversation.receiverUsername &&
                !uniqueConversationsId.has(conversation.receiverUsername) &&
                conversation.receiverUsername !== userUsername
            ) {
                uniqueConversationsId.add(conversation.receiverUsername);
                uniqueConversations.push(conversation.get({ plain: true }));
            }

            if (
                conversation.senderPageId_FK &&
                conversation.senderPageId_FK.id &&
                !uniqueConversationsId.has(conversation.senderPageId_FK.id)
            ) {
                uniqueConversationsId.add(conversation.senderPageId_FK.id);
                uniqueConversations.push(conversation.get({ plain: true }));
            }

            if (
                conversation.receiverPageId_FK &&
                conversation.receiverPageId_FK.id &&
                !uniqueConversationsId.has(conversation.receiverPageId_FK.id)
            ) {
                uniqueConversationsId.add(conversation.receiverPageId_FK.id);
                uniqueConversations.push(conversation.get({ plain: true }));
            }
        });
        //console.log("==========================================")
        //console.log(uniqueConversationsId)
        //console.log("==========================================")
        //console.log(uniqueConversations)
        return res.status(200).json({
            message: 'active users fetched',
            activeConnectionsInfo: activeConnectionsInfo,
            uniqueConversations:uniqueConversations,
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    }
};