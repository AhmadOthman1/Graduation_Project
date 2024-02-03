const User = require("../models/user");
const forgetPasswordCode = require("../models/forgetPasswordCode");
const tempUser = require("../models/tempUser");
const { Op } = require('sequelize');
const validator = require('./validator');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer')




exports.changePassword = async (req, res, next) => {
    try {
        const { email, password, code, ipAddress } = req.body;
        const existingUserInforgetPasswordCode = await forgetPasswordCode.findOne({
            where: {
                email: email,
                ipAddress: ipAddress,

            }
        });
        //if exists 
        if (existingUserInforgetPasswordCode != null) {
            if (existingUserInforgetPasswordCode.attemptCounter >= 3) {
                const currentDate = new Date();
                const timeDifference = currentDate - existingUserInforgetPasswordCode.createdAt;

                // (3600 seconds * 1000 milliseconds)
                if (timeDifference < 3600 * 1000) { // password match , less than hour => dont login
                    // The time difference is less than one hour
                    return res.status(409).json({
                        message: 'change password attempts exceeded. Please try again later.',
                    });
                } else {
                    var VerificationCode = Math.floor(10000 + Math.random() * 90000);
                    //send the code
                    await sendVerificationCode(email, VerificationCode);
                    existingUserInforgetPasswordCode.code = VerificationCode;
                    existingUserInforgetPasswordCode.ipAddress;
                    existingUserInforgetPasswordCode.attemptCounter = 0;
                    existingUserInforgetPasswordCode.createdAt = existingUserInforgetPasswordCode.updatedAt;
                    await existingUserInforgetPasswordCode.save();
                    return res.status(409).json({
                        message: 'new code have been sent to your email. Please try again.',
                    });
                }
            }
            if (code == existingUserInforgetPasswordCode.code) {
                const hashedPassword = await bcrypt.hash(password, 10);
                const result = await User.update(
                    { password: hashedPassword },
                    {
                        where: { email: email },
                    }
                );
                await forgetPasswordCode.destroy({
                    where: {
                        email: email,
                        ipAddress: ipAddress,

                    }
                });
                return res.status(200).json({
                    body: req.body
                });
            } else {
                var newCounter = existingUserInforgetPasswordCode.attemptCounter + 1
                existingUserInforgetPasswordCode.attemptCounter = newCounter;
                await existingUserInforgetPasswordCode.save();
                return res.status(409).json({
                    message: `Not Valid code, you have ${3 - newCounter} attempts left`,
                    body: req.body
                });
            }

        } else {
            return res.status(409).json({
                message: 'Not Valid email',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(409).json({
            message: 'server error',
            body: req.body
        });
    }
}
exports.postVerificationCode = async (req, res, next) => {
    try {

        const { verificationCode, email, ipAddress } = req.body;//get data from req
        console.log("lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll")
        //find the user by email in tempuser table
        const existingUserInforgetPasswordCode = await forgetPasswordCode.findOne({
            where: {
                email: email,
                ipAddress: ipAddress,
            }
        });
        //if exists 
        if (existingUserInforgetPasswordCode != null) {
            const storedVerificationCode = existingUserInforgetPasswordCode.code;// get the hashed code from the thable
            if (existingUserInforgetPasswordCode.attemptCounter >= 3) {
                const currentDate = new Date();
                const timeDifference = currentDate - existingUserInforgetPasswordCode.createdAt;

                // (3600 seconds * 1000 milliseconds)
                if (timeDifference < 3600 * 1000) { // password match , less than hour => dont login
                    // The time difference is less than one hour
                    return res.status(409).json({
                        message: 'change password attempts exceeded. Please try again later.',
                    });
                } else {

                    var VerificationCode = Math.floor(10000 + Math.random() * 90000);
                    //send the code
                    await sendVerificationCode(email, VerificationCode);
                    existingUserInforgetPasswordCode.code = VerificationCode;
                    existingUserInforgetPasswordCode.attemptCounter = 0;
                    existingUserInforgetPasswordCode.createdAt = existingUserInforgetPasswordCode.updatedAt;
                    await existingUserInforgetPasswordCode.save();
                    
                    return res.status(409).json({
                        message: 'new code have been sent to your email. Please try again.',
                    });
                }
            }
            //compare
            if (verificationCode == storedVerificationCode) {
                //await existingUserInforgetPasswordCode.destroy(); ==> we will not destroy the code from here for securty 
                // we want to reCheck the code in reset password in case user can change status(409) to status(200) before it reach our app
                return res.status(200).json({
                    body: req.body
                });
            }
            else {
                var newCounter = existingUserInforgetPasswordCode.attemptCounter + 1
                existingUserInforgetPasswordCode.attemptCounter = newCounter;
                await existingUserInforgetPasswordCode.save();
                return res.status(409).json({
                    message: `Not Valid code, you have ${3 - newCounter} attempts left`,
                    body: req.body
                });
            }


        } else {

            return res.status(409).json({
                message: 'Not Valid email',
                body: req.body
            });
        }




    } catch (err) {
        console.log(err);
        return res.status(409).json({
            message: 'server error',
            body: req.body
        });
    }
}

exports.postForgetPassword = async (req, res, next) => {
    //check for valid email
    const { email, ipAddress } = req.body;
    if (!email) {
        return res.status(409).json({
            message: 'email field is empty',
            body: req.body
        });
    }
    if (!validator.isEmail(email) || email.length < 12 || email.length > 100) {
        return res.status(409).json({
            message: 'Not Valid email',
            body: req.body
        });
    }
    //check if existed in database
    try {
        const existingEmail = await User.findOne({
            where: {
                email: email,
                status: null,
            },
        });
        if (existingEmail != null) {
            // mail  exists
            //check if there is a pre code
            const existingEmailInForget = await forgetPasswordCode.findOne({
                where: {
                    email: email,
                    ipAddress: ipAddress,
                },
            });
            //delete code if existed
            if (existingEmailInForget != null) {

                await existingEmailInForget.destroy();
            }
            //create new code
            var VerificationCode = Math.floor(10000 + Math.random() * 90000);
            //send the code
            await sendVerificationCode(email, VerificationCode);
            //create it in the datebase
            const newforgetPasswordCode = await forgetPasswordCode.create({
                username: existingEmail.username,
                email: existingEmail.email,
                code: VerificationCode,
                attemptCounter: 0,
                ipAddress: ipAddress,
            });
            return res.status(200).json({
                message: email,
                body: req.body
            });

        } else {
            return res.status(409).json({
                message: 'Email not exists',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(409).json({
            message: 'error from server',
            body: req.body
        });
    }
}
async function sendVerificationCode(email, code) {
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: 'growifygp2@gmail.com',
            pass: 'zglg aoic kdiz gjwf',//growifygp2$P2
        },
    });

    const mailOptions = {
        from: 'growifygp2@gmail.com',
        to: email,
        subject: 'Growify Verification Code',
        text: `Your verification code is: ${code} `,
    };


    try {
        // Send the email
        const info = await transporter.sendMail(mailOptions);
    } catch (error) {

        console.error('Error sending email:', error);
        return res.status(500).json({
            message: 'email not found',
            body: req.body
        });
    }

}