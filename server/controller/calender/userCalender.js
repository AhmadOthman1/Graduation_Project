const User = require("../../models/user");
const path = require('path');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const userCalender = require('../../models/userCalender');
const moment = require('moment');
const Connections = require("../../models/connections");
const { Op } = require('sequelize');

exports.getUserCalender = async (req, res, next) => {
    try {
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername,
                status: null,
            },
        });
        if (existingUsername != null) {
            var allUserCalender = await userCalender.findAll({
                where: {
                    username: userUsername,
                },
            });
            return res.status(200).json({
                message: 'Calender fetched',
                Calender: allUserCalender
            });
        } else {
            return res.status(500).json({
                message: 'user not found',
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
exports.addNewUserEvent = async (req, res, next) => {
    try {
        const { subject, description, startTime , reminderDate,reminderTime} = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername,
                status: null,
            },
        });
        if (existingUsername != null) {
            if (subject == null || description == null || startTime == null) {
                return res.status(500).json({
                    message: 'invalid values',
                    body: req.body
                });
            } else if (subject.length < 1 || subject.length > 255 || description.length < 1 || description.length > 2000) {
                return res.status(500).json({
                    message: 'values length out of the range 2000',
                    body: req.body
                });
            }
            console.log(subject)
            console.log(description)
            console.log(startTime)
            const eventDateTime = new Date(startTime);

            // Create the event
            const newEvent = await userCalender.create({
                username: userUsername,
                subject: subject,
                description: description,
                date: eventDateTime.toISOString().split('T')[0],
                time: eventDateTime.toISOString().split('T')[1].substring(0, 8),
                reminderDate:reminderDate,
                reminderTime:reminderTime,
            });
            return res.status(200).json({
                message: 'event Created',
            });


        } else {
            return res.status(500).json({
                message: 'user not found',
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

exports.deleteUserEvent = async (req, res, next) => {
    try {
        const { eventId } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername,
                status: null,
            },
        });
        if (existingUsername != null) {
            const userEvent = await userCalender.findOne({
                where: {
                    id: eventId,
                }
            });
            if (userEvent != null) {
                await userEvent.destroy();
                return res.status(200).json({
                    message: 'event deleted',
                });
            } else {
                return res.status(500).json({
                    message: 'event not found',
                });
            }
        } else {
            return res.status(500).json({
                message: 'user not found',
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