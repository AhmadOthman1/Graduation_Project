const User = require("../../models/user");
const userPages = require("../../models/pages");
const pageAdmin = require("../../models/pageAdmin");
const pageEmployees = require("../../models/pageEmployees");
const { Op } = require('sequelize');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const jwt = require('jsonwebtoken');
const moment = require('moment');
const groupCalender = require("../../models/groupCalender");
const pageGroup = require("../../models/pageGroup");
const { notifyUser, deleteNotification } = require('../notifyUser');
const groupAdmin = require("../../models/groupAdmin");
const groupMember = require("../../models/groupMember");
const groupMessage = require("../../models/groupMessage");




const getChildGroups = async (groupId, childGroups = []) => {
    const groups = await pageGroup.findAll({
        where: {
            parentGroup: groupId,
        },
    });

    for (const group of groups) {
        childGroups.push(group.groupId);
        await getChildGroups(group.groupId, childGroups);
    }

    return childGroups;
};
const getUserAdminGroupsAndChildren = async (userUsername) => {
    const adminGroups = await groupAdmin.findAll({
        where: {
            username: userUsername,
        },
    });

    let allGroups = [];

    for (const adminGroup of adminGroups) {
        const groupId = adminGroup.groupId;
        const childGroups = await getChildGroups(groupId);
        allGroups.push(groupId, ...childGroups);
    }

    return [...new Set(allGroups)]; // Remove duplicates
};

exports.getGroupCalender = async (req, res, next) => {
    try {
        var groupId = req.query.groupId;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            const group = await pageGroup.findOne({
                where: {
                    groupId: groupId,
                }
            });
            if (group == null) {
                return res.status(500).json({
                    message: 'group not found',
                    body: req.body
                });
            }
            const isAdmin = await pageAdmin.findOne({
                where: {
                    username: userUsername,
                    pageId: group.pageId,
                    adminType: "A"
                }
            });
            if (isAdmin != null) {
                var allGroupCalender = await groupCalender.findAll({
                    where: {
                        groupId: groupId,
                    },
                });
                console.log(allGroupCalender);
                return res.status(200).json({
                    message: 'Calender fetched',
                    Calender: allGroupCalender
                });
            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    var allGroupCalender = await groupCalender.findAll({
                        where: {
                            groupId: groupId,
                        },
                    });
                    console.log(allGroupCalender);
                    return res.status(200).json({
                        message: 'Calender fetched',
                        Calender: allGroupCalender
                    });
                } else {
                    var groupMembers = await groupMember.findOne({
                        where: {
                            username: userUsername
                        }
                    })
                    if (groupMembers == null) {
                        return res.status(500).json({
                            message: 'you are not allowed to see this info ',
                            body: req.body
                        });
                    }
                    var allGroupCalender = await groupCalender.findAll({
                        where: {
                            groupId: groupId,
                        },
                    });
                    console.log(allGroupCalender);
                    return res.status(200).json({
                        message: 'Calender fetched',
                        Calender: allGroupCalender
                    });
                }

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

exports.addNewGroupEvent = async (req, res, next) => {
    try {
        const { groupId, subject, description, startTime } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
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
            const group = await pageGroup.findOne({
                where: {
                    groupId: groupId,
                }
            });
            if (group == null) {
                return res.status(500).json({
                    message: 'group not found',
                    body: req.body
                });
            }
            const isAdmin = await pageAdmin.findOne({
                where: {
                    username: userUsername,
                    pageId: group.pageId,
                    adminType: "A"
                }
            });
            if (isAdmin != null) {
                const eventDateTime = new Date(startTime);
                const newEvent = await groupCalender.create({
                    groupId: groupId,
                    subject: subject,
                    description: description,
                    date: eventDateTime.toISOString().split('T')[0],
                    time: eventDateTime.toISOString().split('T')[1].substring(0, 8),
                });
                return res.status(200).json({
                    message: 'event Created',
                });
            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    const eventDateTime = new Date(startTime);
                    const newEvent = await groupCalender.create({
                        groupId: groupId,
                        subject: subject,
                        description: description,
                        date: eventDateTime.toISOString().split('T')[0],
                        time: eventDateTime.toISOString().split('T')[1].substring(0, 8),
                    });
                    return res.status(200).json({
                        message: 'event Created',
                    });
                } else {

                    return res.status(500).json({
                        message: 'you are not allowed to add this info ',
                        body: req.body
                    });

                }

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
exports.deleteGroupEvent = async (req, res, next) => {
    try {
        const { groupId, eventId } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            const group = await pageGroup.findOne({
                where: {
                    groupId: groupId,
                }
            });
            if (group == null) {
                return res.status(500).json({
                    message: 'group not found',
                    body: req.body
                });
            }
            const isAdmin = await pageAdmin.findOne({
                where: {
                    username: userUsername,
                    pageId: group.pageId,
                    adminType: "A"
                }
            });
            if (isAdmin != null) {
                const userEvent = await groupCalender.findOne({
                    where: {
                        id: eventId,
                        groupId: groupId,
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
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    const userEvent = await groupCalender.findOne({
                        where: {
                            id: eventId,
                            groupId: groupId,
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
                        message: 'you are not allowed to add this info ',
                        body: req.body
                    });

                }

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