const User = require("../../../models/user");
const post = require('../../../models/post');
const Page = require("../../../models/pages");
const pageJobs = require("../../../models/pageJobs");
const jobApplication = require("../../../models/jobApplication");
const pageGroup = require("../../../models/pageGroup");
const messages = require("../../../models/messages");
const activeUsers = require("../../../models/activeUsers");
const groupMeeting = require("../../../models/groupMeeting");
const connections = require("../../../models/connections");
const { Op } = require('sequelize');
const sentConnection = require("../../../models/sentConnection");
const systemFields = require("../../../models/systemFields");

exports.deleteSystemField = async (req, res, next) => {
    var username = req.user.username;
    var field  = req.params;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        try {
            var fields = await systemFields.destroy({
                where:
                {
                    Field: field,
                }
            })
            return res.status(200).json({
                message: 'field deleted',
            });
        } catch (err) {
            return res.status(409).json({
                message: 'field does not exists',
            });
        }

    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.newSystemField = async (req, res, next) => {
    var username = req.user.username;
    var { field } = req.body;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        try {
            var fields = await systemFields.create({
                Field: field,
            })
            return res.status(200).json({
                message: 'field created',
            });
        } catch (err) {
            return res.status(409).json({
                message: 'field already exists',
            });
        }

    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getSystemFields = async (req, res, next) => {
    var username = req.user.username;
    var userUsername = req.params;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var fields = await systemFields.findAll({

        });
        return res.status(200).json({
            message: 'fields',
            fields: fields,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}