const User = require("../../models/user");
const userPages = require("../../models/pages");
const pageAdmin = require("../../models/pageAdmin");
const pageEmployees = require("../../models/pageEmployees");
const { Op } = require('sequelize');
const validator = require('../validator');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer')
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const jwt = require('jsonwebtoken');
const post = require('../../models/post');
const comment = require('../../models/comment');
const like = require('../../models/like');
const moment = require('moment');
const pageGroup = require("../../models/pageGroup");
const { notifyUser, deleteNotification } = require('../notifyUser');
const groupAdmin = require("../../models/groupAdmin");
const groupMember = require("../../models/groupMember");
const groupMeeting = require("../../models/groupMeeting");
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
exports.createGroupMeeting = async (req, res, next) => {
    try {
        const { meetingId, groupId } = req.body;
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
                var isMeetingExist = await groupMeeting.findOne({
                    where: {
                        groupId: groupId,
                        meetingId: meetingId,
                    }
                });
                if (isMeetingExist != null) {
                    return res.status(406).json({
                        message: 'change meeting id',
                    });
                } else {
                    await groupMeeting.create({
                        groupId: groupId,
                        meetingId: meetingId,
                        users: 1,
                    });
                    return res.status(200).json({
                        message: 'meeting created',
                    });
                }
            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    var isMeetingExist = await groupMeeting.findOne({
                        where: {
                            groupId: groupId,
                            meetingId: meetingId,
                        }
                    });
                    if (isMeetingExist != null) {
                        return res.status(406).json({
                            message: 'change meeting id',
                        });
                    } else {
                        await groupMeeting.create({
                            groupId: groupId,
                            meetingId: meetingId,
                            users: 1,
                        });
                        return res.status(200).json({
                            message: 'meeting created',
                        });
                    }
                } else {
                    // The user is not authorized to update the group info
                    return res.status(403).json({
                        message: 'You are not allowed to create a meeting',
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
exports.joinGroupMeeting = async (req, res, next) => {
    try {
        const { meetingId, groupId } = req.body;
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
                var isMeetingExist = await groupMeeting.findOne({
                    where: {
                        groupId: groupId,
                        meetingId: meetingId,
                    }
                });
                if (isMeetingExist != null) {
                    if (isMeetingExist.users <= 0) {
                        return res.status(500).json({
                            message: 'meeting ended',
                        });
                    }
                    var meetingUsers = isMeetingExist.users + 1;
                    await groupMeeting.update({ users: meetingUsers }, {
                        where: {
                            groupId: groupId,
                            meetingId: meetingId,
                        }
                    })
                    return res.status(200).json({
                        message: 'joined',
                    });
                } else {
                    return res.status(500).json({
                        message: 'invalid meeting id',
                    });
                }
            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    var isMeetingExist = await groupMeeting.findOne({
                        where: {
                            groupId: groupId,
                            meetingId: meetingId,
                        }
                    });
                    if (isMeetingExist != null) {
                        if (isMeetingExist.users <= 0) {
                            return res.status(500).json({
                                message: 'meeting ended',
                            });
                        }
                        var meetingUsers = isMeetingExist.users + 1;
                        await groupMeeting.update({ users: meetingUsers }, {
                            where: {
                                groupId: groupId,
                                meetingId: meetingId,
                            }
                        })
                        return res.status(200).json({
                            message: 'joined',
                        });
                    } else {
                        return res.status(500).json({
                            message: 'invalid meeting id',
                        });
                    }
                } else {
                    var groupMembers = await groupMember.findOne({
                        where: {
                            username: userUsername
                        }
                    })
                    if (groupMembers == null) {
                        return res.status(500).json({
                            message: 'you are not allowed to join this meeting ',
                            body: req.body
                        });
                    }
                    var isMeetingExist = await groupMeeting.findOne({
                        where: {
                            groupId: groupId,
                            meetingId: meetingId,
                        }
                    });
                    if (isMeetingExist != null) {
                        if (isMeetingExist.users <= 0) {
                            return res.status(500).json({
                                message: 'meeting ended',
                            });
                        }
                        var meetingUsers = isMeetingExist.users + 1;
                        await groupMeeting.update({ users: meetingUsers }, {
                            where: {
                                groupId: groupId,
                                meetingId: meetingId,
                            }
                        })
                        return res.status(200).json({
                            message: 'joined',
                        });
                    } else {
                        return res.status(500).json({
                            message: 'invalid meeting id',
                        });
                    }
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
exports.leaveGroupMeeting = async (req, res, next) => {
    try {
        const { meetingId, groupId } = req.body;
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
                var isMeetingExist = await groupMeeting.findOne({
                    where: {
                        groupId: groupId,
                        meetingId: meetingId,
                    }
                });
                if (isMeetingExist != null) {
                    if (isMeetingExist.users <= 0) {
                        return res.status(500).json({
                            message: 'meeting ended',
                        });
                    }
                    var meetingUsers = isMeetingExist.users - 1;
                    await groupMeeting.update({ users: meetingUsers }, {
                        where: {
                            groupId: groupId,
                            meetingId: meetingId,
                        }
                    })
                    return res.status(200).json({
                        message: 'leaved',
                    });
                } else {
                    return res.status(500).json({
                        message: 'invalid meeting id',
                    });
                }
            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    var isMeetingExist = await groupMeeting.findOne({
                        where: {
                            groupId: groupId,
                            meetingId: meetingId,
                        }
                    });
                    if (isMeetingExist != null) {
                        if (isMeetingExist.users <= 0) {
                            return res.status(500).json({
                                message: 'meeting ended',
                            });
                        }
                        var meetingUsers = isMeetingExist.users - 1;
                        await groupMeeting.update({ users: meetingUsers }, {
                            where: {
                                groupId: groupId,
                                meetingId: meetingId,
                            }
                        })
                        return res.status(200).json({
                            message: 'leaved',
                        });
                    } else {
                        return res.status(500).json({
                            message: 'invalid meeting id',
                        });
                    }
                } else {
                    var groupMembers = await groupMember.findOne({
                        where: {
                            username: userUsername
                        }
                    })
                    if (groupMembers == null) {
                        return res.status(500).json({
                            message: 'you are not allowed to join this meeting ',
                            body: req.body
                        });
                    }
                    var isMeetingExist = await groupMeeting.findOne({
                        where: {
                            groupId: groupId,
                            meetingId: meetingId,
                        }
                    });
                    if (isMeetingExist != null) {
                        if (isMeetingExist.users <= 0) {
                            return res.status(500).json({
                                message: 'meeting ended',
                            });
                        }
                        var meetingUsers = isMeetingExist.users - 1;
                        await groupMeeting.update({ users: meetingUsers }, {
                            where: {
                                groupId: groupId,
                                meetingId: meetingId,
                            }
                        })
                        return res.status(200).json({
                            message: 'leaved',
                        });
                    } else {
                        return res.status(500).json({
                            message: 'invalid meeting id',
                        });
                    }
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