const User = require("../models/user");
const tempUser = require("../models/tempUser");
const { Op } = require('sequelize');
const validator = require('./validator');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer')
const moment = require('moment');
require('dotenv').config();
const jwt = require('jsonwebtoken');
const auth = require('./authController')
const activeUsers = require("../models/activeUsers");
const loginAttempts = require("../models/loginAttempts");



exports.postLogin = async (req, res, next) => {
    const { email, password, ipAddress } = req.body;
    if (!email || !password) {
        return res.status(409).json({
            message: 'One or more fields are empty',
            body: req.body
        });
    }
    if (!validator.isEmail(email) || email.length < 12 || email.length > 100) {
        return res.status(409).json({
            message: 'Not Valid email',
            body: req.body
        });
    }
    if (password.length < 8 || password.length > 30) {
        return res.status(409).json({
            message: 'Not Valid password',
            body: req.body
        });
    }
    const existingEmail = await User.findOne({
        where: {
            email: email,
            status: null,
        },
    });
    if (existingEmail != null) {
        // mail  exists
        console.log(password);
        const isMatch = await bcrypt.compare(password, existingEmail.password);
        if (isMatch) {
            var attempt = await loginAttempts.findOne({
                where: {
                    ipAddress: ipAddress,
                    username: existingEmail.username,
                }
            })
            if (attempt == null) {// password match, no previous attempts => login
                const userLoginInfo = { email: email, username: existingEmail.username };
                const accessToken = auth.generateAccessToken(userLoginInfo);
                const refreshToken = jwt.sign(userLoginInfo, process.env.REFRESH_TOKEN_SECRET);
                const result = await User.update({ token: refreshToken }, { where: { email } });
                console.log(accessToken)
                console.log(refreshToken)
                var user = await activeUsers.findOne({
                    where: {
                        username: existingEmail.username,
                    },
                });
                if (!user) {
                    await activeUsers.create({
                        username: existingEmail.username,
                    });
                }
                return res.status(200).json({
                    message: 'logged',
                    accessToken: accessToken,
                    refreshToken: refreshToken,
                    username: existingEmail.username,
                    firstname: existingEmail.firstname,
                    lastname: existingEmail.lastname,
                    photo: existingEmail.photo,
                    Fields: existingEmail.Fields,
                });
            } else {// password match, theres previous attempts ??
                if (attempt.counter >= 3) {//password match , attempt.counter more than 3 ??
                    const currentDate = new Date();
                    const timeDifference = currentDate - attempt.createdAt;

                    // (3600 seconds * 1000 milliseconds)
                    if (timeDifference < 3600 * 1000) { // password match , less than hour => dont login
                        // The time difference is less than one hour
                        return res.status(409).json({
                            message: 'Login attempts exceeded. Please try again later.',
                        });
                    } else {//password match , more than hour => login
                        await attempt.destroy();
                        const userLoginInfo = { email: email, username: existingEmail.username };
                        const accessToken = auth.generateAccessToken(userLoginInfo);
                        const refreshToken = jwt.sign(userLoginInfo, process.env.REFRESH_TOKEN_SECRET);
                        const result = await User.update({ token: refreshToken }, { where: { email } });
                        console.log(accessToken)
                        console.log(refreshToken)
                        var user = await activeUsers.findOne({
                            where: {
                                username: existingEmail.username,
                            },
                        });
                        if (!user) {
                            await activeUsers.create({
                                username: existingEmail.username,
                            });
                        }
                        return res.status(200).json({
                            message: 'logged',
                            accessToken: accessToken,
                            refreshToken: refreshToken,
                            username: existingEmail.username,
                            firstname: existingEmail.firstname,
                            lastname: existingEmail.lastname,
                            photo: existingEmail.photo,
                            Fields: existingEmail.Fields,
                        });
                    }

                } else {//password match , attempt.counter less than 3
                    await attempt.destroy();
                    const userLoginInfo = { email: email, username: existingEmail.username };
                    const accessToken = auth.generateAccessToken(userLoginInfo);
                    const refreshToken = jwt.sign(userLoginInfo, process.env.REFRESH_TOKEN_SECRET);
                    const result = await User.update({ token: refreshToken }, { where: { email } });
                    console.log(accessToken)
                    console.log(refreshToken)
                    var user = await activeUsers.findOne({
                        where: {
                            username: existingEmail.username,
                        },
                    });
                    if (!user) {
                        await activeUsers.create({
                            username: existingEmail.username,
                        });
                    }
                    return res.status(200).json({
                        message: 'logged',
                        accessToken: accessToken,
                        refreshToken: refreshToken,
                        username: existingEmail.username,
                        firstname: existingEmail.firstname,
                        lastname: existingEmail.lastname,
                        photo: existingEmail.photo,
                        Fields: existingEmail.Fields,
                    });
                }
            }


        } else {
            var attempt = await loginAttempts.findOne({
                where: {
                    ipAddress: ipAddress,
                    username: existingEmail.username,
                }
            })
            if (attempt == null) {//password wrong , first attempt
                await loginAttempts.create({
                    ipAddress: ipAddress,
                    username: existingEmail.username,
                    counter: 1,
                })
                return res.status(409).json({
                    message: 'Wrong Password, 2 attempts left',
                    body: req.body
                });
            } else {//password wrong , not first attempt
                if (attempt.counter >= 3) {
                    const currentDate = new Date();
                    const timeDifference = currentDate - attempt.createdAt;

                    // 1 hour
                    if (timeDifference < 3600 * 1000) { // password wrong , less than hour => 
                        // The time difference is less than one hour
                        return res.status(409).json({
                            message: 'Login attempts exceeded. Please try again later.',
                        });
                    } else {// password wrong , more than hour
                        await attempt.destroy();
                        await loginAttempts.create({
                            ipAddress: ipAddress,
                            username: existingEmail.username,
                            counter: 1,
                        })
                        return res.status(409).json({
                            message: 'Wrong Password, 2 attempts left',
                            body: req.body
                        });
                    }
                } else {
                    var newCounter = attempt.counter + 1
                    await loginAttempts.update({
                        counter: newCounter
                    },
                        {
                            where: {
                                ipAddress: ipAddress,
                                username: existingEmail.username,
                            }
                        }
                    )
                    return res.status(409).json({
                        message: `Wrong Password,${3 - newCounter} attempts left`,
                        body: req.body
                    });
                }

            }

        }

    } else {
        return res.status(409).json({
            message: 'Email doest exists',
            body: req.body
        });
    }

}