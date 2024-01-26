
const User = require("../../models/user");
const path = require('path');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const userTasks = require('../../models/userTasks');
const moment = require('moment');
const Connections = require("../../models/connections");
const { Op } = require('sequelize');

exports.getUserTasks = async (req, res, next) => {
    try {
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
            var allUserTasks = await userTasks.findAll({
                where: {
                    username: userUsername,
                },
                order: [
                    ['endDate', 'ASC'], // Order by endDate in ascending order
                    ['endTime', 'ASC'], // Then order by endTime in ascending order
                ],
            });
            return res.status(200).json({
                message: 'tasks fetched',
                tasks: allUserTasks
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
exports.ChangeUserTaskStatus = async (req, res, next) => {
    try {
        const { taskId, newValue } = req.body;
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
            if (taskId == null || newValue == null) {
                return res.status(500).json({
                    message: 'invalid values',
                    body: req.body
                });
            }

            var userTask = await userTasks.findOne({
                where: {
                    username: userUsername,
                    id: taskId,
                }
            });
            if (userTask != null) {
                if (newValue == 'ToDo' || newValue == 'Doing' || newValue == 'Done' || newValue == 'Archived') {
                    await userTasks.update(
                        { status: newValue },
                        {
                            where: {
                                username: userUsername,
                                id: taskId,
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
exports.CreateUserTask = async (req, res, next) => {
    try {
        const { taskName, description, startTime, endTime, startDate, endDate, status , reminderDate, reminderTime} = req.body;
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
            if (taskName == null || description == null || startTime == null || endTime == null || startDate == null || endDate == null || status == null) {
                return res.status(500).json({
                    message: 'invalid values',
                    body: req.body
                });
            } else if (taskName.length < 1 || taskName.length > 2000 || description.length < 1 || description.length > 2000 || status.length < 1 || status.length > 255) {
                return res.status(500).json({
                    message: 'values length out of the range 2000',
                    body: req.body
                });
            }
            if (status == 'ToDo' || status == 'Doing' || status == 'Done' || status == 'Archived') {
                const formattedStartDate = new Date(startDate);
                const formattedEndDate = new Date(endDate);

                var newTask = await userTasks.create({
                    username: userUsername,
                    taskName: taskName,
                    description: description,
                    status: status,
                    startTime: startTime,
                    startDate: formattedStartDate,
                    endTime: endTime,
                    endDate: formattedEndDate,
                    reminderDate:reminderDate,
                    reminderTime:reminderTime,
                });
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