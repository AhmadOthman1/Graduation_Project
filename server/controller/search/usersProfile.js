const User = require("../../models/user");
const Connections = require("../../models/connections");
const sentConnection = require("../../models/sentConnection");
const WorkExperience = require("../../models/workExperience");
const EducationLevel = require("../../models/educationLevel");
const {notifyUser,deleteNotification} = require('../notifyUser');
const post = require('../../models/post');

const jwt = require('jsonwebtoken');
require('dotenv').config();
const { Op } = require('sequelize');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const Sequelize = require('sequelize');
const pageEmployees = require("../../models/pageEmployees");
const pageAdmin = require("../../models/pageAdmin");



exports.getWorkExperience = async (req, res, next) => {
    try {
        var ProfileUsername = req.query.ProfileUsername;
        const userUsername = await User.findOne({
            where: {
                username: ProfileUsername,
                status: null,
            },
            include: WorkExperience,
        });

        if (userUsername != null) {
            console.log(";;;;;;;;;;;;;;;;;;;;;;;;;");
            const workExperiences = await Promise.all(userUsername.workExperiences.map(async (experience) => {
                const isEmployee = await pageEmployees.findOne({
                    where: {
                        pageId: experience.company,
                        username: ProfileUsername,
                        field: experience.specialty,
                    }
                });
                const isAdmin = await pageAdmin.findOne({
                    where: {
                        pageId: experience.company,
                        username: ProfileUsername,
                        adminType: "A",
                    }
                });
                return {
                    'id': experience.id.toString(),
                    'Specialty': experience.specialty,
                    'Company': experience.company,
                    'Description': experience.description,
                    'Start Date': experience.startDate.toISOString().split("T")[0],
                    'End Date': (experience.endDate) ? experience.endDate.toISOString().split("T")[0] : 'Present',
                    'isEmployee': isEmployee == null ? (isAdmin==null? "false" : "true" ) : "true",
                };
            }));
            console.log(workExperiences)
            
            return res.status(200).json({
                message: 'User found',
                workExperiences: workExperiences,
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

exports.getEducationLevel= async (req, res, next) => {
    try {
        var ProfileUsername = req.query.ProfileUsername;
        const userUsername = await User.findOne({
            where: {
                username: ProfileUsername,
                status: null,
            },
            include: EducationLevel,
        });
        if (userUsername !=null) {
            const educationLevel = userUsername.educationLevels.map((Level) => ({
                'id': Level.id.toString(),
                'Specialty': Level.specialty,
                'School': Level.School,
                'Description': Level.description,
                'Start Date': Level.startDate.toISOString().split("T")[0],
                'End Date': (Level.endDate) ? Level.endDate.toISOString().split("T")[0] : 'Present', // Handle the case where endDate is null
            }));
            return res.status(200).json({
                message: 'User found',
                educationLevel: educationLevel,
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
exports.postSendDeleteReq = async (req, res, next) => {
    try {
        const { username } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: username,
                status: null,
            },
        });
        if(existingUsername == null){
            return res.status(409).json({
                message: 'there is no user exists',
                body: req.body
            });
        } 
        const existinguserUsername = await User.findOne({
            where: {
                username: userUsername,
                status: null,
            },
        });
        if(existinguserUsername == null){
            return res.status(409).json({
                message: 'user not found',
                body: req.body
            });
        }  
        var userInConnections = await findIfUserInConnections(userUsername, username);
        if (userInConnections[0]) {// check if this user  connected with other user 
            return res.status(409).json({
                message: 'This user is already in your connections',
                body: req.body
            });
        }    
        
        var userInReceiverConnections = await findIfUserInSentConnectionsReceiver(userUsername, username);
        console.log(userInReceiverConnections);
        if (userInReceiverConnections[0]) {// check if this user sent a connection req to other user 
            return res.status(409).json({
                message: 'you already have a connection request',
                body: req.body
            });
        }
        var userInSenderConnections = await findIfUserInSentConnectionsSender(userUsername, username);
        console.log(userInSenderConnections);
        if (userInSenderConnections[0]) {// check if this user has a connection req from other user
            await sentConnection.destroy({ where: { id: userInSenderConnections[0].id } });
            return res.status(200).json({
                message: 'request Accepted',
                body: req.body
            });
        }
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
        
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }
}


exports.postSendAcceptConnectReq = async (req, res, next) => {
    try {
        const { username } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: username,
                status: null,
            },
        });
        if(existingUsername == null){
            return res.status(409).json({
                message: 'there is no user exists',
                body: req.body
            });
        } 
        const existinguserUsername = await User.findOne({
            where: {
                username: userUsername,
                status: null,
            },
        });
        if(existinguserUsername == null){
            return res.status(409).json({
                message: 'user not found',
                body: req.body
            });
        }   
        var userInConnections = await findIfUserInConnections(userUsername, username);
        if (userInConnections[0]) {// check if this user  connected with other user 
            return res.status(409).json({
                message: 'This user is already in your connections',
                body: req.body
            });
        }    
        
        var userInReceiverConnections = await findIfUserInSentConnectionsReceiver(userUsername, username);
        console.log(userInReceiverConnections);
        if (userInReceiverConnections[0]) {// check if this user sent a connection req to other user 
            return res.status(409).json({
                message: 'you already have a connection request',
                body: req.body
            });
        }
        var userInSenderConnections = await findIfUserInSentConnectionsSender(userUsername, username);
        console.log(userInSenderConnections);
        if (userInSenderConnections[0]) {// check if this user has a connection req from other user
            await sentConnection.destroy({ where: { id: userInSenderConnections[0].id } });
            await Connections.create({
                senderUsername: username,
                receiverUsername: userUsername,
                date: new Date(),
            })
            const notification = {
                username: username,  
                notificationType: 'connection', // Type of notification
                notificationContent: "accept connection request",  
                notificationPointer: userUsername,
              };
              var isnotify= false
              isnotify= await notifyUser (username, notification);
            //isnotify = await notifyUser(username, notification);
              console.log(isnotify);
            return res.status(200).json({
                message: 'request Accepted',
                body: req.body
            });
        }
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
        
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }
}
exports.postSendRemoveConnection = async (req, res, next) => {
    try {
        const { username } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: username,
                status: null,
            },
        });
        if(existingUsername == null){
            return res.status(409).json({
                message: 'there is no user exists',
                body: req.body
            });
        }
        const existinguserUsername = await User.findOne({
            where: {
                username: userUsername,
                status: null,
            },
        });
        if(existinguserUsername == null){
            return res.status(409).json({
                message: 'user not found',
                body: req.body
            });
        }       
        var userInSenderConnections = await findIfUserInSentConnectionsSender(userUsername, username);
        console.log(userInSenderConnections);
        if (userInSenderConnections[0]) {// check if this user has a connection req from other user 
            return res.status(409).json({
                message: 'you already have a connection request',
                body: req.body
            });
        }
        var userInReceiverConnections = await findIfUserInSentConnectionsReceiver(userUsername, username);
        console.log(userInReceiverConnections);
        if (userInReceiverConnections[0]) {// check if this user sent a connection req to other user 
            return res.status(409).json({
                message: 'you already have a connection request',
                body: req.body
            });
        }
        var userInConnections = await findIfUserInConnections(userUsername, username);
        if (userInConnections[0]) {// check if this user  connected with other user 
            await Connections.destroy({ where: { id: userInConnections[0].id } });
            return res.status(200).json({
                message: 'request removed',
                body: req.body
            });
        } 
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
        
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }
}
exports.postSendRemoveReq = async (req, res, next) => {
    try {
        console.log("===========================");
        const { username } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: username,
                status: null,
            },
        });
        if(existingUsername == null){
            return res.status(409).json({
                message: 'there is no user exists',
                body: req.body
            });
        }
        const existinguserUsername = await User.findOne({
            where: {
                username: userUsername,
                status: null,
            },
        });
        if(existinguserUsername == null){
            return res.status(409).json({
                message: 'user not found',
                body: req.body
            });
        }
        var userInConnections = await findIfUserInConnections(userUsername, username);
        if (userInConnections[0]) {// check if this user  connected with other user 
            return res.status(409).json({
                message: 'This user is already in your connections',
                body: req.body
            });
        }        
        var userInSenderConnections = await findIfUserInSentConnectionsSender(userUsername, username);
        console.log(userInSenderConnections);
        if (userInSenderConnections[0]) {// check if this user has a connection req from other user 
            return res.status(409).json({
                message: 'you already have a connection request',
                body: req.body
            });
        }
        var userInReceiverConnections = await findIfUserInSentConnectionsReceiver(userUsername, username);
        console.log(userInReceiverConnections);
        if (userInReceiverConnections[0]) {// check if this user sent a connection req to other user 
            await sentConnection.destroy({ where: { id: userInReceiverConnections[0].id } });
            const notification = {
                username: username,  // Type of notification
                notificationType: 'connection',  // Content of the notification
                notificationContent: "sent you a connection request",  // Timestamp of when the notification was sent
                notificationPointer: userUsername,
              };
              var isnotify= false
            isnotify = await deleteNotification(username, notification);
              console.log(isnotify);
            return res.status(200).json({
                message: 'request removed',
                body: req.body
            });
        }
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
        
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }
}
exports.postSendConnectReq = async (req, res, next) => {
    try {
        console.log("===========================");
        const { username } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: username,
                status: null,
            },
        });
        if(existingUsername == null){
            return res.status(409).json({
                message: 'there is no user exists',
                body: req.body
            });
        }
        const existinguserUsername = await User.findOne({
            where: {
                username: userUsername,
                status: null,
            },
        });
        if(existinguserUsername == null){
            return res.status(409).json({
                message: 'user not found',
                body: req.body
            });
        }
        var userInConnections = await findIfUserInConnections(userUsername, username);
        if (userInConnections[0]) {// check if this user  connected with other user 
            return res.status(409).json({
                message: 'This user is already in your connections',
                body: req.body
            });
        }
        var userInSenderConnections = await findIfUserInSentConnectionsSender(userUsername, username);
        if (userInSenderConnections[0]) {// check if this user has a connection req from other user 
            return res.status(409).json({
                message: 'you already sent a connection request',
                body: req.body
            });
        }
        var userInReceiverConnections = await findIfUserInSentConnectionsReceiver(userUsername, username);
        if (userInReceiverConnections[0]) {// check if this user sent a connection req to other user 
            return res.status(409).json({
                message: 'you already have a connection request',
                body: req.body
            });
        }
        const newConnection = await sentConnection.create({
            senderUsername: userUsername,
            receiverUsername: username,
            date: new Date(),
        });
        const notification = {
            username: username,  
            notificationType: 'connection', // Type of notification
            notificationContent: "sent you a connection request",  
            notificationPointer: userUsername,
          };
          var isnotify= false
        //isnotify = await notifyUser(username, notification);
        isnotify= await notifyUser (username, notification);
          console.log(isnotify);
        return res.status(200).json({
            message: 'request sent',
            body: req.body
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }
}

exports.getUserProfileInfo = async (req, res, next) => {
    try {
        var findProfileUsername = req.query.ProfileUsername;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // 'decoded' now contains the user information (e.g., email, password)
        const ProfileUsername = await User.findOne({
            where: {
                username: findProfileUsername,
                status: null,
            },
        });
        const ProfileuserUsername = await User.findOne({
            where: {
                username: userUsername,
                status: null,
            },
        });
        if(ProfileuserUsername==null){
            return res.status(409).json({
                message: 'user not found',
                body: req.body
            });
        }
        if (ProfileUsername !=null) {
            var connection = "N";
            var photo;
            var coverimage;
            var cv;
            if (ProfileUsername.photo == null) {
                photo = null;
            } else {

                const photoFilePath = path.join('images', ProfileUsername.photo);

                // Check if the file exists
                try {
                    await fs.promises.access(photoFilePath, fs.constants.F_OK);
                    photo = ProfileUsername.photo;
                } catch (err) {
                    console.error(err);
                    photo = null;
                    await User.update({ photo: photo }, { where: { email } });
                }

            }
            if (ProfileUsername.coverImage == null) {
                coverimage = null;
            } else {
                const coverImageFilePath = await path.join('images', ProfileUsername.coverImage);
                // Check if the file exists
                try {
                    await fs.promises.access(coverImageFilePath, fs.constants.F_OK);
                    coverimage = ProfileUsername.coverImage;

                } catch (err) {
                    console.error(err);
                    coverimage = null;
                    await User.update({ coverImage: coverimage }, { where: { email } });
                }

            }
            if (ProfileUsername.cv == null) {
                cv = null;
            } else {
                const cvFilePath = await path.join('cvs', ProfileUsername.cv);
                // Check if the file exists
                try {
                    await fs.promises.access(cvFilePath, fs.constants.F_OK);
                    cv = ProfileUsername.cv;

                } catch (err) {
                    console.error(err);
                    cv = null;
                    await User.update({ cv: cv }, { where: { email } });
                }

            }
            var userInConnections = await findIfUserInConnections(userUsername, findProfileUsername);
            if (userInConnections[0]) { // check if user is connected to other user
                connection = "C";
            }
            else {

                var userInSenderConnections = await findIfUserInSentConnectionsSender(userUsername, findProfileUsername);
                if (userInSenderConnections[0]) {// check if the other user sent a connection req
                    connection = "S";
                }
                else {
                    var userInReceiverConnections = await findIfUserInSentConnectionsReceiver(userUsername, findProfileUsername);
                    if (userInReceiverConnections[0]) {// check if this user sent a connection req to other user 
                        connection = "R";
                    }
                    else {
                        connection = "N";
                    }

                }
            }
            const connectionsCount = await Connections.count({
                where: {
                    [Op.or]: [
                        { senderUsername: findProfileUsername },
                        { receiverUsername: findProfileUsername },
                    ],
                },
            });
            const postsCount = await post.count({
                where: { username: findProfileUsername },
            });
            return res.status(200).json({
                message: 'User found',
                user: {
                    username: ProfileUsername.username,
                    firstname: ProfileUsername.firstname,
                    lastname: ProfileUsername.lastname,
                    bio: ProfileUsername.bio,
                    country: ProfileUsername.country,
                    address: ProfileUsername.address,
                    phone: ProfileUsername.phone,
                    dateOfBirth: ProfileUsername.dateOfBirth,
                    photo: photo,
                    coverImage: coverimage,
                    Gender: ProfileUsername.Gender,
                    Fields:ProfileUsername.Fields,
                    cv: cv,
                    connection: connection,
                    connectionsCount: connectionsCount,
                    postsCount:postsCount,
                },
            });
        } else {
            return res.status(409).json({
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
// check if this user (userUsername) connected with other user 
async function findIfUserInConnections(userUsername, findProfileUsername) {
    const userConnections = await Connections.findAll({
        where: {
            [Op.or]: [
                { senderUsername: userUsername },
                { receiverUsername: userUsername },
            ],
        },
        include: [{
            model: User,
            as: 'senderUsername_FK',
            attributes: ['username'],
        }, {
            model: User,
            as: 'receiverUsername_FK',
            attributes: ['username'],
        }],
    });
    const userInConnections = userConnections.filter(connection => {
        // Check if the username is in senders or receivers
        return connection.senderUsername_FK.username === findProfileUsername || connection.receiverUsername_FK.username === findProfileUsername;
    });
    return userInConnections;
}
// check if this user(userUsername) has a connection req to other user 
async function findIfUserInSentConnectionsSender(userUsername, findProfileUsername) {
    const userSentConnections = await sentConnection.findAll({
        where: {
            [Op.or]: [
                { senderUsername: userUsername },
                { receiverUsername: userUsername },
            ],
        },
        include: [{
            model: User,
            as: 'senderRUsername_FK',
            attributes: ['username'],
        }, {
            model: User,
            as: 'receiverRUsername_FK',
            attributes: ['username'],
        }],
    });

    const userInSenderConnections = userSentConnections.filter(connection => {
        // Check if the username is in senders
        return connection.senderRUsername_FK.username === findProfileUsername;
    });
    return userInSenderConnections;
}
// check if this user (userUsername) sent a connection req to other user 
async function findIfUserInSentConnectionsReceiver(userUsername, findProfileUsername) {
    const userSentConnections = await sentConnection.findAll({
        where: {
            [Op.or]: [
                { senderUsername: userUsername },
                { receiverUsername: userUsername },
            ],
        },
        include: [{
            model: User,
            as: 'senderRUsername_FK',
            attributes: ['username'],
        }, {
            model: User,
            as: 'receiverRUsername_FK',
            attributes: ['username'],
        }],
    });
    
    const userInReceiverConnections = userSentConnections.filter(connection => {
        // Check if the username is in senders
        return connection.receiverRUsername_FK.username === findProfileUsername;
    });
    return userInReceiverConnections;
}