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



exports.postLogin = async (req, res, next) => {
    const { email, password } = req.body;
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
            email: email
        },
    });
    if (existingEmail) {
        // mail  exists
        console.log(password);
        const isMatch = await bcrypt.compare(password, existingEmail.password);
        if (isMatch) {
            const userLoginInfo = { email: email, username:  existingEmail.username};
            const accessToken = auth.generateAccessToken(userLoginInfo);
            const refreshToken = jwt.sign(userLoginInfo, process.env.REFRESH_TOKEN_SECRET);
            const result = await User.update({ token: refreshToken }, { where: { email } });
            console.log(accessToken)
            console.log(refreshToken)
            return res.status(200).json({
                message: 'logged',
                accessToken: accessToken,
                refreshToken: refreshToken,
                username: existingEmail.username,
                firstname: existingEmail.firstname,
                lastname: existingEmail.lastname,
                photo: existingEmail.photo,
            });

        } else {
            return res.status(409).json({
                message: 'Wrong Password',
                body: req.body
            });
        }

    } else {
        return res.status(409).json({
            message: 'Email not exists',
            body: req.body
        });
    }

}