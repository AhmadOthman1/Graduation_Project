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
const pageFollower = require("../../models/pageFollower");
const Page = require("../../models/pages");
const pageJobs = require("../../models/pageJobs");
const jobApplication = require("../../models/jobApplication");
const systemFields = require("../../models/systemFields");
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

exports.editGroupInfo = async (req, res, next) => {
    try {
        const { groupId, description, name, memberCanSendMessages } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        console.log(memberCanSendMessages != null)
        console.log("llllllllllllllllllllllllllllllllllllll")

        const existingUsername = await User.findOne({
            where: {
                username: userUsername,
                status: null,
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
                if (name != null && name.trim() != "") {
                    pageGroup.update(
                        { name: name },
                        {
                            where: { groupId: groupId },
                        }
                    )
                }
                if (description != null && description.trim() != "") {
                    pageGroup.update(
                        { description: description },
                        {
                            where: { groupId: groupId },
                        }
                    )
                }
                if (memberCanSendMessages != null) {
                    console.log(memberCanSendMessages == "true" ? 1 : 0)
                    console.log("llllllllllllllllllllllllllllllllllllll")

                    pageGroup.update(
                        { memberSendMessage: memberCanSendMessages == "true" ? true : false },
                        {
                            where: { groupId: groupId },
                        }
                    )
                }

                return res.status(200).json({
                    message: 'Group updated',
                });
            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    if (name != null && name.trim() !== "") {
                        await pageGroup.update(
                            { name: name },
                            { where: { groupId: groupId } }
                        );
                    }

                    if (description != null && description.trim() !== "") {
                        await pageGroup.update(
                            { description: description },
                            { where: { groupId: groupId } }
                        );
                    }

                    if (memberCanSendMessages != null) {
                        console.log(memberCanSendMessages == "true" ? 1 : 0)
                        console.log("llllllllllllllllllllllllllllllllllllll")

                        await pageGroup.update(
                            { memberSendMessage: memberCanSendMessages == "true" ? true : false },
                            { where: { groupId: groupId } }
                        );
                    }

                    return res.status(200).json({
                        message: 'Group updated',
                    });
                } else {
                    return res.status(403).json({
                        message: 'You are not allowed to update this group',
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
exports.addGroupAdmin = async (req, res, next) => {
    try {
        const { adminUsername, groupId } = req.body;
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
            const existingAdminUsername = await User.findOne({
                where: {
                    username: adminUsername,
                    status: null,
                },
            });
            if (existingAdminUsername == null) {
                return res.status(500).json({
                    message: 'user not found',
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
                const isUserAdmin = await groupAdmin.findOne({
                    where: {
                        groupId: groupId,
                        username: adminUsername
                    }
                });
                if (isUserAdmin != null) {
                    return res.status(500).json({
                        message: 'this user is already admin in this group',
                    });
                }
                const isUserMember = await groupMember.findOne({
                    where: {
                        groupId: groupId,
                        username: adminUsername
                    }
                });
                if (isUserMember != null) {
                    await groupAdmin.create({
                        groupId: groupId,
                        username: adminUsername
                    })
                    return res.status(200).json({
                        message: 'admin created',
                    });
                } else {
                    return res.status(500).json({
                        message: 'user is not member in this group',
                    });
                }
            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    const isUserAdmin = await groupAdmin.findOne({
                        where: {
                            groupId: groupId,
                            username: adminUsername
                        }
                    });
                    if (isUserAdmin != null) {
                        return res.status(500).json({
                            message: 'this user is already admin in this group',
                        });
                    }
                    const isUserMember = await groupMember.findOne({
                        where: {
                            groupId: groupId,
                            username: adminUsername
                        }
                    });
                    if (isUserMember != null) {
                        await groupAdmin.create({
                            groupId: groupId,
                            username: adminUsername
                        })
                        return res.status(200).json({
                            message: 'admin created',
                        });
                    } else {
                        return res.status(500).json({
                            message: 'user is not member in this group',
                        });
                    }
                } else {
                    // The user is not authorized to update the group info
                    return res.status(403).json({
                        message: 'You are not allowed to update this group',
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

exports.deleteGroupAdmin = async (req, res, next) => {
    try {
        const { adminUsername, groupId } = req.body;
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
            const existingAdminUsername = await User.findOne({
                where: {
                    username: adminUsername
                },
            });
            if (existingAdminUsername == null) {
                return res.status(500).json({
                    message: 'user not found',
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
                const isUserAdmin = await groupAdmin.findOne({
                    where: {
                        groupId: groupId,
                        username: adminUsername
                    }
                });
                if (isUserAdmin == null) {
                    return res.status(500).json({
                        message: 'you are not allowed to delete this user because he is admin in parent group',
                    });
                }
                await isUserAdmin.destroy();
                return res.status(200).json({
                    message: 'admin deleted',
                });

            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    const isUserAdmin = await groupAdmin.findOne({
                        where: {
                            groupId: groupId,
                            username: adminUsername
                        }
                    });
                    if (isUserAdmin == null) {
                        return res.status(500).json({
                            message: 'you are not allowed to delete this user because he is admin in parent group',
                        });
                    }
                    await isUserAdmin.destroy();
                    return res.status(200).json({
                        message: 'admin deleted',
                    });
                } else {
                    // The user is not authorized to update the group info
                    return res.status(403).json({
                        message: 'You are not allowed to update this group',
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
exports.addGroupMember = async (req, res, next) => {
    try {
        const { isEmployee, memberUsername, groupId } = req.body;
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
            const existingMemberUsername = await User.findOne({
                where: {
                    username: memberUsername,
                    status: null,
                },
            });
            if (existingMemberUsername == null) {
                return res.status(500).json({
                    message: 'user not found',
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
                const isUserMember = await groupMember.findOne({
                    where: {
                        groupId: groupId,
                        username: memberUsername
                    }
                });
                if (isUserMember != null) {
                    return res.status(500).json({
                        message: 'this user is already member in this group',
                    });
                }
                const isUserEmployee = await pageEmployees.findOne({
                    where: {
                        pageId: group.pageId,
                        username: memberUsername
                    }
                });
                if (isUserEmployee) {
                    await groupMember.create({
                        groupId: groupId,
                        username: memberUsername
                    });
                    return res.status(200).json({
                        message: 'member Added',
                    });
                } else {
                    if (isEmployee == "true") {
                        return res.status(500).json({
                            message: 'user is not employee in this page',
                        });
                    } else if (isEmployee == "false") {
                        await groupMember.create({
                            groupId: groupId,
                            username: memberUsername
                        });
                        return res.status(200).json({
                            message: 'member Added',
                        });
                    } else {
                        return res.status(500).json({
                            message: 'invalid values',
                        });
                    }

                }


            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    const isUserMember = await groupMember.findOne({
                        where: {
                            groupId: groupId,
                            username: memberUsername
                        }
                    });
                    if (isUserMember != null) {
                        return res.status(500).json({
                            message: 'this user is already member in this group',
                        });
                    }
                    const isUserEmployee = await pageEmployees.findOne({
                        where: {
                            pageId: group.pageId,
                            username: memberUsername
                        }
                    });
                    if (isUserEmployee) {
                        await groupMember.create({
                            groupId: groupId,
                            username: memberUsername
                        });
                        return res.status(200).json({
                            message: 'member Added',
                        });
                    } else {
                        if (isEmployee == "true") {
                            return res.status(500).json({
                                message: 'user is not employee in this page',
                            });
                        } else if (isEmployee == "false") {
                            await groupMember.create({
                                groupId: groupId,
                                username: memberUsername
                            });
                            return res.status(200).json({
                                message: 'member Added',
                            });
                        } else {
                            return res.status(500).json({
                                message: 'invalid values',
                            });
                        }

                    }
                } else {
                    // The user is not authorized to update the group info
                    return res.status(403).json({
                        message: 'You are not allowed to update this group',
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
exports.deleteGroupMember = async (req, res, next) => {
    try {
        const { employeeUsername, groupId } = req.body;
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
            const existingMemberUsername = await User.findOne({
                where: {
                    username: employeeUsername
                },
            });
            if (existingMemberUsername == null) {
                return res.status(500).json({
                    message: 'user not found',
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
                const isUserMember = await groupMember.findOne({
                    where: {
                        groupId: groupId,
                        username: employeeUsername
                    }
                });
                if (isUserMember == null) {
                    return res.status(500).json({
                        message: 'user is not member in this group',
                    });
                }
                await isUserMember.destroy();
                return res.status(200).json({
                    message: 'user deleted',
                });

            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    const isUserMember = await groupMember.findOne({
                        where: {
                            groupId: groupId,
                            username: employeeUsername
                        }
                    });
                    if (isUserMember == null) {
                        return res.status(500).json({
                            message: 'user is not member in this group',
                        });
                    }
                    await isUserMember.destroy();
                    return res.status(200).json({
                        message: 'user deleted',
                    });
                } else {
                    // The user is not authorized to update the group info
                    return res.status(403).json({
                        message: 'You are not allowed to update this group',
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
exports.deleteGroup = async (req, res, next) => {
    try {
        const { groupId } = req.body;
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
                await group.destroy();
                return res.status(200).json({
                    message: 'group deleted',
                });

            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    await group.destroy();
                    return res.status(200).json({
                        message: 'group deleted',
                    });
                } else {
                    // The user is not authorized to update the group info
                    return res.status(403).json({
                        message: 'You are not allowed to update this group',
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