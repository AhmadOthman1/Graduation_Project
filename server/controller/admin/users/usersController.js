const User = require("../../../models/user");
const post = require('../../../models/post');
const Page = require("../../../models/pages");
const pageJobs = require("../../../models/pageJobs");
const jobApplication = require("../../../models/jobApplication");
const pageGroup = require("../../../models/pageGroup");
const messages = require("../../../models/messages");
const activeUsers = require("../../../models/activeUsers");
const groupMeeting = require("../../../models/groupMeeting");
const EducationLevel = require("../../../models/educationLevel");
const WorkExperience = require("../../../models/workExperience");



exports.getUsers = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var users = await User.findAll({
            attributes: ['username', 'firstname', 'lastname', 'email', 'bio', 'country', 'address', 'phone', 'dateOfBirth', 'Gender', 'Fields', 'photo', 'coverImage', 'cv', 'status', 'type']
        });
        return res.status(200).json({
            message: 'users',
            users: users,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}

exports.createUser = async (req, res, next) => {
    const { userName, firstName, lastName, email, password, phone, dateOfBirth, type } = req.body;
    var existingUsername = await User.findOne({
        where: {
            username: req.user.username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        if (!firstName || !lastName || !userName || !email || !password || !phone || !dateOfBirth) {
            return res.status(409).json({
                message: 'One or more fields are empty',
                body: req.body
            });
        }
        // all values are correct
        if (!validator.isUsername(firstName) || firstName.length < 1 || firstName.length > 50) {
            return res.status(409).json({
                message: 'Not Valid firstName',
                body: req.body
            });
        }
        if (!validator.isUsername(lastName) || lastName.length < 1 || lastName.length > 50) {
            return res.status(409).json({
                message: 'Not Valid UserName',
                body: req.body
            });
        }
        if (!validator.isUsername(userName) || userName.length < 5 || userName.length > 50) {
            return res.status(409).json({
                message: 'Not Valid UserName',
                body: req.body
            });
        }
        if (!validator.isEmail(email) || email.length < 12 || email.length > 100) {
            return res.status(409).json({
                message: 'Not Valid email',
                body: req.body
            });
        }
        if (!validator.isPhoneNumber(phone) || phone.length < 10 || phone.length > 15) {
            return res.status(409).json({
                message: 'Not Valid Phone Number',
                body: req.body
            });
        }
        if (password.length < 8 || password.length > 30) {
            return res.status(409).json({
                message: 'Not Valid password',
                body: req.body
            });
        }
        if (!validator.isDate(dateOfBirth) || dateOfBirth.length < 8 || dateOfBirth.length > 10) {
            return res.status(409).json({
                message: 'Not Valid date Of Birth',
                body: req.body
            });
        }

        // find if user exsist in user table
        const existingUserName = await User.findOne({
            where: {
                username: userName
            },
        });
        const existingEmail = await User.findOne({
            where: {
                email: email
            },
        });
        // find if user exsist in tempuser table
        const existingUserNameInTemp = await tempUser.findOne({
            where: {
                username: userName
            },
        });
        const existingEmailInTemp = await tempUser.findOne({
            where: {
                email: email
            },
        });
        //if user has a data on temuser will be removed 
        if (existingUserNameInTemp != null) {
            await existingUserNameInTemp.destroy();
        }
        if (existingEmailInTemp != null) {
            await existingEmailInTemp.destroy();
        }
        if (existingUserName != null) {
            // User already exists
            return res.status(409).json({
                message: 'UserName already exists',
                body: req.body
            });
        } if (existingEmail != null) {
            // mail already exists
            return res.status(409).json({
                message: 'Email already exists',
                body: req.body
            });
        }

        const newUser = await User.create({
            firstname: firstName,
            lastname: lastName,
            username: userName,
            email: email,
            password: hashedPassword,
            phone: phone,
            dateOfBirth: dateOfBirth,
            type: type,
        });
        return res.status(200).json({
            message: 'user created',
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}

exports.updateUser = async (req, res, next) => {
    try {
        const { username, email, firstName, lastName, address, country, Gender, dateOfBirth, phone, bio, Fields, type, status } = req.body;
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
                type: "Admin"
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
            // save changes
            if (validfirstName) {
                await User.update(
                    { firstname: firstName },
                    {
                        where: { username: username },
                    }
                );
            }
            if (validlastName) {
                await User.update(
                    { lastname: lastName },
                    {
                        where: { username: username },
                    }
                );
            }
            if (validaddress) {
                await User.update(
                    { address: address },
                    {
                        where: { username: username },
                    }
                );
            }
            if (validcountry) {
                await User.update(
                    { country: country },
                    {
                        where: { username: username },
                    }
                );
            }
            if (validGender) {
                await User.update(
                    { Gender: Gender },
                    {
                        where: { username: username },
                    }
                );
            }
            if (validdateOfBirth) {
                await User.update(
                    { dateOfBirth: dateOfBirth },
                    {
                        where: { username: username },
                    }
                );
            }
            if (validphone) {
                await User.update(
                    { phone: phone },
                    {
                        where: { username: username },
                    }
                );
            }
            if (validbio) {
                await User.update(
                    { bio: bio },
                    {
                        where: { username: username },
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
                        where: { username: username },
                    }
                );
            }
            if (type != null && type == "Admin") {
                await User.update(
                    { type: type },
                    {
                        where: { username: username },
                    }
                );
            }
            if (status != null && status == "true") {
                await User.update(
                    { status: null },
                    {
                        where: { username: username },
                    }
                );
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
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }
}
exports.deleteUser = async (req, res, next) => {
    try {
        const { username } = req.body;
        const existingAdmin = await User.findOne({
            where: {
                email: req.user.email,
                status: null,
                type: "Admin"
            },
        });
        const existingEmail = await User.findOne({
            where: {
                username: username,
                status: null,
                type: "Admin"
            },
        });

        if (existingAdmin != null) {
            // mail  exists

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
exports.educationLevel = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var EducationLevels = await EducationLevel.findAll({
        });
        return res.status(200).json({
            message: 'EducationLevels',
            EducationLevels: EducationLevels,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.workExperience = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var WorkExperiences = await WorkExperience.findAll({
        });
        return res.status(200).json({
            message: 'WorkExperiences',
            WorkExperiences: WorkExperiences,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}