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
const pageFollower = require("../../models/pageFollower");
const Page = require("../../models/pages");
const pageJobs = require("../../models/pageJobs");
const jobApplication = require("../../models/jobApplication");
const systemFields = require("../../models/systemFields");
const pageGroup = require("../../models/pageGroup");
const { notifyUser, deleteNotification } = require('../notifyUser');
const groupAdmin = require("../../models/groupAdmin");
const groupMember = require("../../models/groupMember");
const groupTask = require("../../models/groupTask");

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



exports.getGroupTasks = async (req, res, next) => {
    try {
        var groupId = req.query.groupId;
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
                var allGroupTasks = await groupTask.findAll({
                    where: {
                        groupId: groupId,
                    },
                    order: [
                        ['endDate', 'ASC'], // Order by endDate in ascending order
                        ['endTime', 'ASC'], // Then order by endTime in ascending order
                    ],
                });
                console.log(allGroupTasks);
                return res.status(200).json({
                    message: 'tasks fetched',
                    tasks: allGroupTasks
                });
            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    var allGroupTasks = await groupTask.findAll({
                        where: {
                            groupId: groupId,
                        },
                        order: [
                            ['endDate', 'ASC'], // Order by endDate in ascending order
                            ['endTime', 'ASC'], // Then order by endTime in ascending order
                        ],
                    });
                    console.log(allGroupTasks);
                    return res.status(200).json({
                        message: 'tasks fetched',
                        tasks: allGroupTasks
                    });
                } else {
                    var allGroupTasks = await groupTask.findAll({
                        where: {
                            groupId: groupId,
                            username: userUsername
                        },
                        order: [
                            ['endDate', 'ASC'], // Order by endDate in ascending order
                            ['endTime', 'ASC'], // Then order by endTime in ascending order
                        ],
                    });
                    console.log(allGroupTasks);
                    return res.status(200).json({
                        message: 'tasks fetched',
                        tasks: allGroupTasks
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
exports.CreateGroupTask = async (req, res, next) => {
    try {
        const { groupId, taskName, description, users, startTime, endTime, startDate, endDate, status } = req.body;
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
            if (taskName == null || users == null || description == null || startTime == null || endTime == null || startDate == null || endDate == null || status == null) {
                return res.status(500).json({
                    message: 'invalid values',
                    body: req.body
                });
            } else if (taskName.length < 1 || taskName.length > 2000 || description.length < 1 || description.length > 2000 || status.length < 1 || status.length > 255 || users.length < 1) {
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
                if (status == 'ToDo' || status == 'Doing' || status == 'Done' || status == 'Archived') {
                    const formattedStartDate = new Date(startDate);
                    const formattedEndDate = new Date(endDate);
                    var usersUsername = users.split(',');
                    for (const user of usersUsername) {
                        var isMember = await groupMember.findOne({
                            where: {
                                username: user,
                            }
                        });
                        if (isMember != null) {
                            var newTask = await groupTask.create({
                                groupId: groupId,
                                username: user,
                                taskName: taskName,
                                description: description,
                                status: status,
                                startTime: startTime,
                                startDate: formattedStartDate,
                                endTime: endTime,
                                endDate: formattedEndDate,
                            });
                        }
                    }
                    return res.status(200).json({
                        message: 'Task Created',
                        taskId: newTask.id,
                    });
                } else {
                    return res.status(500).json({
                        message: 'invalid status value',
                        body: req.body
                    });
                }

            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    if (status == 'ToDo' || status == 'Doing' || status == 'Done' || status == 'Archived') {
                        const formattedStartDate = new Date(startDate);
                        const formattedEndDate = new Date(endDate);
                        var usersUsername = users.split(',');
                        for (const user of usersUsername) {
                            var isMember = await groupMember.findOne({
                                where: {
                                    username: user,
                                }
                            });
                            if (isMember != null) {
                                var newTask = await groupTask.create({
                                    groupId: groupId,
                                    username: user,
                                    taskName: taskName,
                                    description: description,
                                    status: status,
                                    startTime: startTime,
                                    startDate: formattedStartDate,
                                    endTime: endTime,
                                    endDate: formattedEndDate,
                                });
                            }
                        }
                        return res.status(200).json({
                            message: 'Task Created',
                            taskId: newTask.id,
                        });
                    } else {
                        return res.status(500).json({
                            message: 'invalid status value',
                            body: req.body
                        });
                    }
                } else {
                    return res.status(500).json({
                        message: 'you are not allowed to add a task',
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
exports.ChangeGroupTaskStatus = async (req, res, next) => {
    try {
        const { groupId, taskId, newValue } = req.body;
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
            if (groupId == null || taskId == null || newValue == null) {
                return res.status(500).json({
                    message: 'invalid values',
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
                var userTask = await groupTask.findOne({
                    where: {
                        taskId: taskId,
                        groupId: groupId,
                    }
                });
                if (userTask != null) {
                    if (newValue == 'ToDo' || newValue == 'Doing' || newValue == 'Done' || newValue == 'Archived') {
                        await groupTask.update(
                            { status: newValue },
                            {
                                where: {
                                    groupId: groupId,
                                    taskId: taskId,
                                }
                            });
                        return res.status(200).json({
                            message: 'Task updated',
                        });
                    } else if (newValue == 'Delete') {
                        await userTask.destroy();
                        return res.status(200).json({
                            message: 'Task deleted',
                        });
                    }

                    else {
                        return res.status(500).json({
                            message: 'invalid value',
                        });
                    }
                } else {
                    return res.status(500).json({
                        message: 'Task not found',
                    });
                }
            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    var userTask = await groupTask.findOne({
                        where: {
                            taskId: taskId,
                            groupId: groupId,
                        }
                    });
                    if (userTask != null) {
                        if (newValue == 'ToDo' || newValue == 'Doing' || newValue == 'Done' || newValue == 'Archived') {
                            await groupTask.update(
                                { status: newValue },
                                {
                                    where: {
                                        groupId: groupId,
                                        taskId: taskId,
                                    }
                                });
                            return res.status(200).json({
                                message: 'Task updated',
                            });
                        } else if (newValue == 'Delete') {
                            await userTask.destroy();
                            return res.status(200).json({
                                message: 'Task deleted',
                            });
                        }

                        else {
                            return res.status(500).json({
                                message: 'invalid value',
                            });
                        }
                    } else {
                        return res.status(500).json({
                            message: 'Task not found',
                        });
                    }
                } else {
                    var userTask = await groupTask.findOne({
                        where: {
                            taskId: taskId,
                            groupId: groupId,
                            username: userUsername,
                        }
                    });
                    if (userTask != null) {
                        if ((newValue == 'ToDo' || newValue == 'Doing' || newValue == 'Done') && userTask.status != "Archived") {
                            await groupTask.update(
                                { status: newValue },
                                {
                                    where: {
                                        groupId: groupId,
                                        taskId: taskId,
                                        username: userUsername,
                                    }
                                });
                            return res.status(200).json({
                                message: 'Task updated',
                            });
                        }
                        else {
                            return res.status(500).json({
                                message: 'invalid value',
                            });
                        }
                    } else {
                        return res.status(500).json({
                            message: 'Task not found',
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