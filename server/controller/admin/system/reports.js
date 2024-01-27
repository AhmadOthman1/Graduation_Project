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
const reportedComment = require("../../../models/reportedComment");
const reportedPost = require("../../../models/reportedPost");
const reportedUsers = require("../../../models/reportedUsers");
const reportedPages = require("../../../models/reportedPages");


exports.commentReport = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var reportedComments = await reportedComment.findAll({

        });
        return res.status(200).json({
            message: 'reportedComments',
            reportedComments: reportedComments,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.postReport = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var reportedPosts = await reportedPost.findAll({

        });
        return res.status(200).json({
            message: 'reportedPosts',
            reportedPosts: reportedPosts,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.userReport = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var reportedUser = await reportedUsers.findAll({

        });
        return res.status(200).json({
            message: 'reportedUser',
            reportedUser: reportedUser,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.pageReport = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var reportedPage = await reportedPages.findAll({

        });
        return res.status(200).json({
            message: 'reportedPage',
            reportedPage: reportedPage,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
