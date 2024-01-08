const User = require("../../models/user");
const notifications = require("../../models/notifications");
const { Op } = require('sequelize');
const Sequelize = require('sequelize');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const moment = require('moment');

exports.getUserNotifications = async (req, res, next) => {
    try {
        var page = req.query.page || 1;
        var pageSize = req.query.pageSize || 10;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // Calculate the offset based on page and pageSize
        const offset = (page - 1) * pageSize;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if(existingUsername !=null){
            const userNotifications = await notifications.findAll({
                where: {
                  username: userUsername,
                },
                limit: parseInt(pageSize),
                offset: parseInt(offset),
                order: [['createdAt', 'DESC']],
              });
              console.log(userNotifications);
              console.log("llllllllllllllllllllllllllllllll");
              const fullNotificationsBody = await Promise.all(userNotifications.map(async (notification) => {
                var photo;
                if(notification.notificationType == "connection" || notification.notificationType == "call"|| notification.notificationType == "message"){
                    const user = await User.findOne({
                        where: {
                            username: notification.notificationPointer
                        }
                    });
                    photo = user ? user.photo : null;
                    
                }
                return {
                    ...notification.dataValues,
                    createdAt: moment(notification.createdAt).format('YYYY-MM-DD HH:mm:ss'),
                    photo,
                };
            }));
            console.log(fullNotificationsBody);
            return res.status(200).json({
                 notifications: fullNotificationsBody ,
            });
        }
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    }
};