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

exports.getUserMessages = async (req, res, next) => {
    try {
        console.log("????????????????????????");
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const otherUsername = req.headers['username']
        var page = parseInt(req.query.page) || 1;
        var pageSize = parseInt(req.query.pageSize) || 10;
        var type = req.query.type;
        const offset = (page - 1) * pageSize;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername,
                status: null,
            },
        });
        if (existingUsername==null) {
            return res.status(500).json({
                message: 'user not found',
                body: req.body,
            });
        }
        const existingotherUsername = await User.findOne({
            where: {
                username: otherUsername
            },
        });
        if(existingotherUsername == null){
            return res.status(500).json({
                message: 'user not found',
                body: req.body,
            });
        }
        if (type == "U") {
            console.log(userUsername);
    
            const messages = await Messages.findAll({
                where: {
                    [Op.or]: [
                        {
                            senderUsername: userUsername,
                            receiverUsername: otherUsername,
                        },
                        {
                            senderUsername: otherUsername,
                            receiverUsername: userUsername,
                        },
                    ],
                },
                order: [['createdAt', 'DESC']], // Order by created date in descending order
                offset: offset,
                limit: pageSize,
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
                ],
            });
            console.log("================================");
            console.log(messages);
            return res.status(200).json({
                message: 'messages fetched',
                messages: messages,
            });
        } else {
            console.log("Invalid type provided");
            
        }

    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    }
};