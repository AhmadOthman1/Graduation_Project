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
                username: userUsername
            },
        });
        if (existingUsername != null) {
            var allUserCalender = await userCalender.findAll({
                where: {
                    username: userUsername,
                },
            });
            console.log(allUserCalender);
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