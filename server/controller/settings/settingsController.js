const User = require("../../models/user");
const tempUser = require("../../models/tempUser");
const { Op } = require('sequelize');
const validator = require('../validator');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer')
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const jwt = require('jsonwebtoken');
const systemFields = require("../../models/systemFields");
const activeUsers = require("../../models/activeUsers");
const notifications = require("../../models/notifications");
const connections = require("../../models/connections");
const sentConnection = require("../../models/sentConnection");
const workExperience = require("../../models/workExperience");
const educationLevel = require("../../models/educationLevel");
const userTasks = require("../../models/userTasks");
const changeEmail = require("../../models/changeEmail");
const forgetPasswordCode = require("../../models/forgetPasswordCode");
const userCalender = require("../../models/userCalender");
const jobApplication = require("../../models/jobApplication");
const pageFollower = require("../../models/pageFollower");
const pageEmployees = require("../../models/pageEmployees");
const pageAdmin = require("../../models/pageAdmin");
const comment = require("../../models/comment");
const like = require("../../models/like");
const post = require("../../models/post");
const groupMember = require("../../models/groupMember");
const groupAdmin = require("../../models/groupAdmin");
const groupTask = require("../../models/groupTask");
require('dotenv').config();

exports.getUserProfileDashboard = async (req, res, next) => {
    try {
        console.log("indashhhhhhhhhhhhhhhhhhhhhh")
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        var userExists = await User.findOne({
            where: {
                username: userUsername,
                status: null,
            },
        });
        if (userExists != null) {
            var userPostCount = await post.count({
                where: {
                    username: userUsername,
                },
            });
            var userConnectionsCount = await connections.count({
                where: {
                    [Op.or]: [
                        { senderUsername: userUsername },
                        { receiverUsername: userUsername },
                    ],
                },
            });
            const responseData = {
                userPostCount: userPostCount ?? 0,
                userConnectionsCount: userConnectionsCount ?? 0,
                // Add more key-value pairs as needed
            };

            // Sending the response as JSON
            console.log(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;")
            console.log(userPostCount)
            console.log(userConnectionsCount)
            res.status(200).json(responseData);
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
exports.getMainInfo = async (req, res, next) => {
    try {
        var email = req.user.email;
        const existingEmail = await User.findOne({
            where: {
                email: email,
                status: null,
            },
        });
        if (existingEmail != null) {
            var photo;
            var coverimage;
            var cv;
            if (existingEmail.photo == null) {
                photo = null;
            } else {

                const photoFilePath = path.join('images', existingEmail.photo);

                // Check if the file exists
                try {
                    await fs.promises.access(photoFilePath, fs.constants.F_OK);
                    photo = existingEmail.photo;
                } catch (err) {
                    console.error(err);
                    photo = null;
                    await User.update({ photo: photo }, { where: { email } });
                }

            }
            if (existingEmail.coverImage == null) {
                coverimage = null;
            } else {
                const coverImageFilePath = await path.join('images', existingEmail.coverImage);
                // Check if the file exists
                try {
                    await fs.promises.access(coverImageFilePath, fs.constants.F_OK);
                    coverimage = existingEmail.coverImage;
                    console.log("image fetched");

                } catch (err) {
                    console.error(err);
                    coverimage = null;
                    await User.update({ coverImage: coverimage }, { where: { email } });
                }

            }
            if (existingEmail.cv == null) {
                cv = null;
            } else {
                const cvFilePath = await path.join('cvs', existingEmail.cv);
                // Check if the file exists
                try {
                    await fs.promises.access(cvFilePath, fs.constants.F_OK);
                    cv = existingEmail.cv;
                    console.log("cv fetched");

                } catch (err) {
                    console.error(err);
                    cv = null;
                    await User.update({ cv: cv }, { where: { email } });
                }

            }
            var availableFields = await systemFields.findAll({
                attributes: ['Field'],
            });
            return res.status(200).json({
                message: 'User found',
                user: {
                    username: existingEmail.username,
                    firstname: existingEmail.firstname,
                    lastname: existingEmail.lastname,
                    bio: existingEmail.bio,
                    country: existingEmail.country,
                    address: existingEmail.address,
                    phone: existingEmail.phone,
                    dateOfBirth: existingEmail.dateOfBirth,
                    Gender: existingEmail.Gender,
                    Fields: existingEmail.Fields,
                    photo: photo,
                    coverImage: coverimage,
                    cv: cv,
                    // Add other user properties as neededs
                },
                availableFields: availableFields,

            });
        } else {
            return res.status(500).json({
                message: 'server Error',
                body: req.body
            });
        }
        console.log(email);
        console.log("*************************");
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }
}

exports.changeMainInfo = async (req, res, next) => {
    try {
        const { email, firstName, lastName, address, country, Gender, dateOfBirth, phone, bio, Fields, profileImageBytes, profileImageBytesName, profileImageExt, coverImageBytes, coverImageBytesName, coverImageExt, cvBytes, cvName, cvExt } = req.body;
        var validfirstName = false;
        var validlastName = false;
        var validaddress = false;
        var validcountry = false;
        var validGender = false;
        var validdateOfBirth = false;
        var validphone = false;
        var validbio = false;
        var validFields = false;
        var validphoto = false;
        var validcoverImage = false;
        var validcv = false;
        const existingEmail = await User.findOne({
            where: {
                email: req.user.email,
                status: null,
            },
        });
        if (existingEmail != null) {
            if (firstName != null) {//if feild change enables (!=null)
                if (!validator.isUsername(firstName) || firstName.length < 1 || firstName.length > 50) {//validate
                    return res.status(409).json({
                        message: 'Not Valid firstName',
                        body: req.body
                    });
                } else {//change
                    validfirstName = true;
                }
            }
            if (lastName != null) {//if feild change enables (!=null)
                if (!validator.isUsername(lastName) || lastName.length < 1 || lastName.length > 50) {//validate
                    return res.status(409).json({
                        message: 'Not Valid lastName',
                        body: req.body
                    });
                } else {//change
                    validlastName = true;
                }
            }
            if (address != null) {//if feild change enables (!=null)
                if (address.length < 1 || address.length > 50) {//validate
                    return res.status(409).json({
                        message: 'Not Valid address',
                        body: req.body
                    });
                } else {//change
                    validaddress = true;
                }
            }
            if (country != null) {//if feild change enables (!=null)
                if (country.length < 1 || country.length > 50) {//validate
                    return res.status(409).json({
                        message: 'Not Valid country',
                        body: req.body
                    });
                } else {//change
                    validcountry = true;
                }
            }
            if (Gender != null) {//if feild change enables (!=null)
                if (Gender.length < 1 || Gender.length > 50) {//validate
                    return res.status(409).json({
                        message: 'Not Valid Gender',
                        body: req.body
                    });
                } else if (Gender != "Male" && Gender != "Female") {
                    return res.status(409).json({
                        message: 'Not Valid Gender',
                        body: req.body
                    });
                } else {//change
                    validGender = true;
                }
            }
            if (dateOfBirth != null) {//if feild change enables (!=null)
                if (!validator.isDate(dateOfBirth) || dateOfBirth.length < 8 || dateOfBirth.length > 10) {//validate
                    return res.status(409).json({
                        message: 'Not Valid dateOfBirth',
                        body: req.body
                    });
                } else {//change
                    validdateOfBirth = true;
                }
            }
            if (phone != null) {//if feild change enables (!=null)
                if (!validator.isPhoneNumbere(phone) || phone.length < 8 || phone.length > 10) {//validate
                    return res.status(409).json({
                        message: 'Not Valid phone',
                        body: req.body
                    });
                } else {//change
                    validphone = true;
                }
            }
            if (bio != null) {//if feild change enables (!=null)
                if (bio.length < 1 || bio.length > 250) {//validate
                    return res.status(409).json({
                        message: 'Not Valid bio',
                        body: req.body
                    });
                } else {//change
                    validbio = true;
                }
            }
            if (Fields != null) {//if feild change enables (!=null)
                if (Fields.length < 1 || Fields.length > 6000) {//validate
                    return res.status(409).json({
                        message: 'Not Valid Fields',
                        body: req.body
                    });
                } else {//change
                    validFields = true;
                }
            }
            console.log("fff" + profileImageBytes + "fff" + profileImageBytesName + "fff" + profileImageExt);
            if (profileImageBytes != null && profileImageBytesName != null && profileImageExt != null) {//if feild change enables (!=null)
                validphoto = true;
            }
            if (coverImageBytes != null && coverImageBytesName != null && coverImageExt != null) {//if feild change enables (!=null)
                validcoverImage = true;
            }
            if (cvBytes != null && cvName != null && cvExt != null) {//if feild change enables (!=null)
                validcv = true;
            }


            // save changes
            if (validfirstName) {
                const result = await User.update(
                    { firstname: firstName },
                    {
                        where: { email: req.user.email },
                    }
                );
            }
            if (validlastName) {
                const result = await User.update(
                    { lastname: lastName },
                    {
                        where: { email: req.user.email },
                    }
                );
            }
            if (validaddress) {
                const result = await User.update(
                    { address: address },
                    {
                        where: { email: req.user.email },
                    }
                );
            }
            if (validcountry) {
                const result = await User.update(
                    { country: country },
                    {
                        where: { email: req.user.email },
                    }
                );
            }
            if (validGender) {
                const result = await User.update(
                    { Gender: Gender },
                    {
                        where: { email: req.user.email },
                    }
                );
            }
            if (validdateOfBirth) {
                const result = await User.update(
                    { dateOfBirth: dateOfBirth },
                    {
                        where: { email: req.user.email },
                    }
                );
            }
            if (validphone) {
                const result = await User.update(
                    { phone: phone },
                    {
                        where: { email: req.user.email },
                    }
                );
            }
            if (validbio) {
                const result = await User.update(
                    { bio: bio },
                    {
                        where: { email: req.user.email },
                    }
                );
            }
            if (validFields) {
                availableSystemFields = await systemFields.findAll();
                const fieldsArray = Fields.split(',');
                var fieldsToSave = "";
                availableSystemFields.forEach(systemField => {
                    if (fieldsArray.includes(systemField.dataValues.Field)) {
                        fieldsToSave += systemField.dataValues.Field + ","
                    }
                });
                fieldsToSave = fieldsToSave.slice(0, -1);
                const result = await User.update(
                    { Fields: fieldsToSave },
                    {
                        where: { email: req.user.email },
                    }
                );
            }
            if (validphoto) {
                var oldPhoto = existingEmail.photo;

                const photoBuffer = Buffer.from(profileImageBytes, 'base64');
                const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
                const newphotoname = existingEmail.username + "-" + uniqueSuffix + "." + profileImageExt; // You can adjust the file extension based on the actual image type
                const uploadPath = path.join('images', newphotoname);

                // Save the image to the server
                fs.writeFileSync(uploadPath, photoBuffer);
                console.log("fff" + newphotoname);
                // Update the user record in the database with the new photo name
                const result = await User.update({ photo: newphotoname }, { where: { email: req.user.email } });
                if (oldPhoto != null) {
                    //delete the old photo from the  server image folder
                    const oldPhotoPath = path.join('images', oldPhoto);

                    fs.unlinkSync(oldPhotoPath);
                }

            }
            if (validcoverImage) {
                var oldCover = existingEmail.coverImage;

                const photoBuffer = Buffer.from(coverImageBytes, 'base64');
                const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
                const newphotoname = existingEmail.username + +"-" + uniqueSuffix + "." + coverImageExt; // You can adjust the file extension based on the actual image type
                const uploadPath = path.join('images', newphotoname);

                // Save the image to the server
                fs.writeFileSync(uploadPath, photoBuffer);

                // Update the user record in the database with the new photo name
                const result = await User.update({ coverImage: newphotoname }, { where: { email: req.user.email } });
                if (oldCover != null) {
                    //delete the old photo from the  server image folder
                    const oldCoverPath = path.join('images', oldCover);

                    fs.unlinkSync(oldCoverPath);
                }

            }
            if (validcv) {
                var oldCv = existingEmail.cv; // Change 'pdf' to the appropriate field in your database


                const pdfBuffer = Buffer.from(cvBytes, 'base64');
                const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
                const newPdfName = existingEmail.username + '-' + uniqueSuffix + '.pdf'; // Adjust the file extension based on the actual PDF type
                const uploadPath = path.join('cvs', newPdfName); // Update the folder path as needed

                // Save the PDF to the server
                fs.writeFileSync(uploadPath, pdfBuffer);

                // Update the user record in the database with the new PDF name
                const result = await User.update({ cv: newPdfName }, { where: { email: req.user.email } });
                if (oldCv != null) {
                    // Delete the old PDF file from the server folder
                    const oldPdfPath = path.join('cvs', oldCv); // Update the folder path as needed

                    fs.unlinkSync(oldPdfPath);
                }
            }

            return res.status(200).json({
                message: 'updated',
                body: req.body
            });
        } else {
            return res.status(500).json({
                message: 'server Error',
                body: req.body
            });
        }
        console.log(email);
        console.log("*************************");
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }
}
exports.changePassword = async (req, res, next) => {
    try {
        const { email, oldPassword, newPassword } = req.body;
        if (!email || !oldPassword || !newPassword) {
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
        if (oldPassword.length < 8 || oldPassword.length > 30) {
            return res.status(409).json({
                message: 'Not Valid password',
                body: req.body
            });
        }
        if (newPassword.length < 8 || newPassword.length > 30) {
            return res.status(409).json({
                message: 'Not Valid password',
                body: req.body
            });
        }
        const existingEmail = await User.findOne({
            where: {
                email: req.user.email,
                status: null,
            },
        });
        if (existingEmail != null) {
            const isMatch = await bcrypt.compare(oldPassword, existingEmail.password);
            if (isMatch) {
                const hashedPassword = await bcrypt.hash(newPassword, 10);
                const result = await User.update(
                    { password: hashedPassword },
                    {
                        where: { email: req.user.email },
                    }
                );
                return res.status(200).json({

                    message: 'changed',
                    body: req.body
                });

            } else {
                return res.status(409).json({
                    message: 'Wrong Password',
                    body: req.body
                });
            }

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
exports.changeEmail = async (req, res, next) => {

    try {
        const { email, newEmail, Password, ipAddress } = req.body;

        if (!newEmail || !Password || !email) {
            return res.status(409).json({
                message: 'One or more fields are empty',
                body: req.body
            });
        }

        if (!validator.isEmail(newEmail) || email.length < 12 || email.length > 100) {
            return res.status(409).json({
                message: 'Not Valid email',
                body: req.body
            });
        }
        if (Password.length < 8 || Password.length > 30) {
            return res.status(409).json({
                message: 'Not Valid password',
                body: req.body
            });
        }
        if (email == newEmail) {

            return res.status(409).json({
                message: 'its the same email',
                body: req.body
            });
        }
        console.log(email);
        console.log(newEmail);
        console.log(Password);
        const existingEmail = await User.findOne({
            where: {
                email: req.user.email,
                status: null,
            },
        });

        if (existingEmail != null) {//if user found by old email

            const isMatch = await bcrypt.compare(Password, existingEmail.password);
            if (isMatch) {//correct password
                const existingNewEmail = await User.findOne({
                    where: {
                        email: newEmail
                    },
                });
                if (existingNewEmail != null) {//if email already used
                    return res.status(409).json({
                        message: 'Email is already exists',
                        body: req.body
                    });
                } else {
                    const existingNewEmailInTemp = await tempUser.findOne({
                        where: {
                            email: newEmail
                        },
                    });
                    if (existingNewEmailInTemp != null) {//if email under signup prosecc
                        return res.status(409).json({
                            message: 'The email address is used for a registered account. Please complete the registration process through the signup page',
                            body: req.body
                        });
                    } else {//change email 
                        const existingNewEmailInChange = await changeEmail.findOne({
                            where: {
                                email: newEmail,
                                ipAddress: ipAddress,
                            },
                        });
                        if (existingNewEmailInChange != null) {
                            if (existingNewEmailInChange.attemptCounter >= 3) {
                                const currentDate = new Date();
                                const timeDifference = currentDate - existingNewEmailInChange.createdAt;

                                // (3600 seconds * 1000 milliseconds)
                                if (timeDifference < 3600 * 1000) { // password match , less than hour => dont login
                                    // The time difference is less than one hour
                                    return res.status(409).json({
                                        message: 'change Email attempts exceeded. Please try again later.',
                                    });
                                } else {
                                    await existingNewEmailInChange.destroy();
                                }
                            }

                        }
                        await createChangeEmail(existingEmail.username, newEmail, ipAddress);
                        return res.status(200).json({
                            message: 'code sent',
                            body: req.body
                        });
                    }
                }
            } else {
                return res.status(409).json({
                    message: 'Wrong Password',
                    body: req.body
                });
            }

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
async function createChangeEmail(userName, email, ipAddress) {
    var VerificationCode = Math.floor(10000 + Math.random() * 90000);
    //const hashedVerificationCode = await bcrypt.hash(VerificationCode.toString(), 10);
    await sendVerificationCode(email, VerificationCode);
    const newUser = await changeEmail.create({
        username: userName,
        email: email,
        code: VerificationCode,
        ipAddress: ipAddress,
        attemptCounter:0,
    });
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
exports.postVerificationCode = async (req, res, next) => {
    try {

        const { verificationCode, email, ipAddress } = req.body;//get data from req
        //find the user by email in tempuser table
        console.log(email);
        const existingUserInChangeEamil = await changeEmail.findOne({
            where: {
                email: email,
                ipAddress: ipAddress,
            }
        });
        //if exists 
        if (existingUserInChangeEamil != null) {
            if (existingUserInChangeEamil.attemptCounter >= 3) {
                const currentDate = new Date();
                const timeDifference = currentDate - existingUserInChangeEamil.createdAt;

                // (3600 seconds * 1000 milliseconds)
                if (timeDifference < 3600 * 1000) { // password match , less than hour => dont login
                    // The time difference is less than one hour
                    return res.status(409).json({
                        message: 'change email attempts exceeded. Please try again later.',
                    });
                } else {
                    var VerificationCode = Math.floor(10000 + Math.random() * 90000);
                    //send the code
                    await sendVerificationCode(email, VerificationCode);
                    existingUserInChangeEamil.code = VerificationCode;
                    existingUserInChangeEamil.ipAddress;
                    existingUserInChangeEamil.attemptCounter = 0;
                    await existingUserInChangeEamil.save();
                    return res.status(409).json({
                        message: 'new code have been sent to your email. Please try again.',
                    });
                }
            }
            const storedVerificationCode = existingUserInChangeEamil.code;// get the hashed code from the thable
            //compare
            if (verificationCode == storedVerificationCode) {

                var username = existingUserInChangeEamil.username;
                const result = await User.update({ email: email }, { where: { username } });
                await changeEmail.destroy({
                    where: {
                        email: email,
                        ipAddress: ipAddress,
                    }
                });
                return res.status(200).json({
                    body: req.body
                });
            }
            else {
                var newCounter = existingUserInChangeEamil.attemptCounter + 1;
                existingUserInChangeEamil.attemptCounter = newCounter;
                await existingUserInChangeEamil.save();

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
exports.deleteUserAccount = async (req, res, next) => {
    try {
        const { password } = req.body;
        const existingEmail = await User.findOne({
            where: {
                email: req.user.email,
                status: null,
            },
        });
        if (!password) {
            return res.status(409).json({
                message: 'password is empty',
                body: req.body
            });
        }
        if (password.length < 8 || password.length > 30) {
            return res.status(409).json({
                message: 'Not Valid password',
                body: req.body
            });
        }
        if (existingEmail != null) {
            // mail  exists
            console.log(password);
            const isMatch = await bcrypt.compare(password, existingEmail.password);
            if (isMatch) {
                var oldPhoto = existingEmail.photo;
                var oldCover = existingEmail.coverImage;

                if (oldPhoto != null) {
                    //delete the old photo from the  server image folder
                    const oldPhotoPath = path.join('images', oldPhoto);

                    fs.unlinkSync(oldPhotoPath);
                }
                if (oldCover != null) {
                    //delete the old photo from the  server image folder
                    const oldCoverPath = path.join('images', oldCover);

                    fs.unlinkSync(oldCoverPath);
                }
                await User.update(
                    { status: false, photo: null, coverImage: null,token :null },
                    {
                        where: {
                            username: existingEmail.username,
                        },
                    });

                await activeUsers.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await notifications.destroy({
                    where: {
                        [Op.or]: [
                            {
                                username: existingEmail.username,
                            },
                            {
                                notificationPointer: existingEmail.username,
                            }
                        ]

                    },
                });
                await connections.destroy({
                    where: {
                        [Op.or]: [
                            {
                                senderUsername: existingEmail.username,
                            },
                            {
                                receiverUsername: existingEmail.username,
                            }
                        ]
                    },
                });
                await sentConnection.destroy({
                    where: {
                        [Op.or]: [
                            {
                                senderUsername: existingEmail.username,
                            },
                            {
                                receiverUsername: existingEmail.username,
                            }
                        ]
                    },
                });
                await workExperience.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await educationLevel.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await userTasks.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await changeEmail.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await forgetPasswordCode.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await userCalender.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await jobApplication.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await pageFollower.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await pageEmployees.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await pageAdmin.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await comment.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await like.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await post.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await groupTask.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await groupAdmin.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                await groupMember.destroy({
                    where: {
                        username: existingEmail.username,
                    },
                });
                return res.status(200).json({
                    message: 'Account deleted',
                });

            } else {
                return res.status(409).json({
                    message: 'Wrong Password',
                    body: req.body
                });
            }

        } else {
            return res.status(404).json({
                message: 'user not exist',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'user not exist',
            body: req.body
        });
    }
}
