const User = require("../../models/user");
const tempUser = require("../../models/tempUser");
const changeEmail = require("../../models/changeEmail");
const { Op } = require('sequelize');
const validator = require('../validator');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer')
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const jwt = require('jsonwebtoken');
const connections = require("../../models/connections");
const post = require("../../models/post");
const sentConnection = require("../../models/sentConnection");

exports.getUserColleagues = async (req, res, next) => {
    try {
        var page = req.query.page || 1;
        var pageSize = req.query.pageSize || 10;
        const offset = (page - 1) * pageSize;

        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        var userExists = await User.findOne({
            where: {
                username: userUsername,
            },
        });
        if (userExists != null) {
            var userConnections = await connections.findAll({
                where: {
                    [Op.or]: [
                        { senderUsername: userUsername },
                        { receiverUsername: userUsername },
                    ],
                },
                limit: parseInt(pageSize),
                offset: parseInt(offset),
                order: [['createdAt', 'DESC']],
            });
            const connectionsWithUserInfo = await Promise.all(
                userConnections.map(async (connection) => {
                    var senderUser;
                    var receiverUser;
                    if (connection.senderUsername != userUsername) {
                        senderUser = await User.findOne({
                            where: {
                                username: connection.senderUsername,
                            },
                            attributes: ['username', 'firstname', 'lastname', 'photo'], 
                        });
                    }
                    if (connection.receiverUsername != userUsername) {

                        receiverUser = await User.findOne({
                            where: {
                                username: connection.receiverUsername,
                            },
                            attributes: ['username', 'firstname', 'lastname', 'photo'], 
                        });
                    }
                    return {
                        connection: senderUser == null ? receiverUser : senderUser,

                    };
                })
            );
            const filteredConnectionsWithUserInfo= connectionsWithUserInfo.filter(
                (item) => item !== null && item !== undefined
            );
            const responseData = {
                userConnections: filteredConnectionsWithUserInfo,
            };

            // Sending the response as JSON
            return res.status(200).json(responseData);
        } else {
            return res.status(500).json({
                message: 'server Error',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }


}
exports.getUserRequestsReceived = async (req, res, next) => {
    try {
        var page = req.query.page || 1;
        var pageSize = req.query.pageSize || 10;
        const offset = (page - 1) * pageSize;

        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        var userExists = await User.findOne({
            where: {
                username: userUsername,
            },
        });
        if (userExists != null) {
            var userConnectionsRequestsReceived = await sentConnection.findAll({
                where: {
                    [Op.or]: [
                        {
                           receiverUsername: {
                                [Op.eq]: userUsername,
                            },
                        },
                        {
                            senderUsername: {
                                [Op.not]: userUsername,
                            },
                        },
                    ],
                },
                limit: parseInt(pageSize),
                offset: parseInt(offset),
                order: [['createdAt', 'DESC']],
            });
            const RequestsReceivedWithUserInfo = await Promise.all(
                userConnectionsRequestsReceived.map(async (Request) => {
                    var senderUser;
                    if (Request.senderUsername != userUsername) {
                        senderUser = await User.findOne({
                            where: {
                                username: Request.senderUsername,
                            },
                            attributes: ['username', 'firstname', 'lastname', 'photo'], 
                        });
                        return {
                            senderUser,
                        };
                    }
                    
                    
                })
            );
            const filteredRequestsReceivedWithUserInfo = RequestsReceivedWithUserInfo.filter(
                (item) => item !== null&& item !== undefined
            );
    
            const responseData = {
                userConnectionsRequestsReceived: filteredRequestsReceivedWithUserInfo,
            };
            // Sending the response as JSON
            return res.status(200).json(responseData);
        } else {
            return res.status(500).json({
                message: 'server Error',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }


}

exports.getUserRequestsSent = async (req, res, next) => {
    try {
        var page = req.query.page || 1;
        var pageSize = req.query.pageSize || 10;
        const offset = (page - 1) * pageSize;

        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        var userExists = await User.findOne({
            where: {
                username: userUsername,
            },
        });
        if (userExists != null) {
            var userConnectionsRequestsSent = await sentConnection.findAll({
                where: {
                    [Op.or]: [
                        {
                            senderUsername: {
                                [Op.eq]: userUsername,
                            },
                        },
                        {
                            receiverUsername: {
                                [Op.not]: userUsername,
                            },
                        },
                    ],
                },
                limit: parseInt(pageSize),
                offset: parseInt(offset),
                order: [['createdAt', 'DESC']],
            });
            
            const RequestsSentWithUserInfo = await Promise.all(
                userConnectionsRequestsSent.map(async (Request) => {
                    var receiverUser;
                    if (Request.receiverUsername != userUsername) {
                        receiverUser = await User.findOne({
                            where: {
                                username: Request.receiverUsername,
                            },
                            attributes: ['username', 'firstname', 'lastname', 'photo'], 
                        });
                        return {
                            receiverUser,
                        };
                    }
                    
                    
                })
            );
            console.log(RequestsSentWithUserInfo);
            const filteredRequestsSentWithUserInfo = RequestsSentWithUserInfo.filter(
                (item) => item !== null&& item !== undefined
            );
    
            const responseData = {
                userConnectionsRequestsSent: filteredRequestsSentWithUserInfo,
            };
            // Sending the response as JSON
            return res.status(200).json(responseData);
        } else {
            return res.status(500).json({
                message: 'server Error',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }


}