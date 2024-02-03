const User = require("../../../models/user");
const post = require('../../../models/post');
const Page = require("../../../models/pages");
const pageJobs = require("../../../models/pageJobs");
const pageGroup = require("../../../models/pageGroup");
const pageFollower = require("../../../models/pageFollower");
const pageAdmin = require("../../../models/pageAdmin");
const pageEmployees = require("../../../models/pageEmployees");
const pageCalender = require("../../../models/pageCalender");
const jobApplication = require("../../../models/jobApplication");


exports.getPages = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var pages = await Page.findAll({
            attributes: ['id', 'name', 'description', 'country', 'address', 'contactInfo', 'specialty', 'pageType', 'photo', 'coverImage', 'createdAt', 'updatedAt']
        });
        return res.status(200).json({
            message: 'pages',
            pages: pages,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getPage = async (req, res, next) => {
    var username = req.user.username;
    var pageId = req.params;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var pages = await Page.findAll({
            where: {
                id: pageId,
            },
            attributes: ['id', 'name', 'description', 'country', 'address', 'contactInfo', 'specialty', 'pageType', 'photo', 'coverImage', 'createdAt', 'updatedAt']
        });
        return res.status(200).json({
            message: 'pages',
            pages: pages,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getPages = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var pages = await Page.findAll({
            attributes: ['id', 'name', 'description', 'country', 'address', 'contactInfo', 'specialty', 'pageType', 'photo', 'coverImage', 'createdAt', 'updatedAt']
        });
        return res.status(200).json({
            message: 'pages',
            pages: pages,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getPageJobs = async (req, res, next) => {
    var username = req.user.username;
    var pageId = req.params.pageId;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var PageJobs = await pageJobs.findAll({
            where: {
                pageId: pageId
            }
        });
        return res.status(200).json({
            message: 'PageJobs',
            PageJobs: PageJobs,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getJopApplications = async (req, res, next) => {
    var username = req.user.username;
    var jobId = req.params;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var PageApplications= await jobApplication.findAll({
            where: {
                pageJobId: jobId
            }
        });
        return res.status(200).json({
            message: 'PageApplications',
            PageApplications: PageApplications,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getJobs = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var PageJobs = await pageJobs.findAll({

        });
        return res.status(200).json({
            message: 'PageJobs',
            PageJobs: PageJobs,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getPageGroups = async (req, res, next) => {
    var username = req.user.username;
    var pageId = req.params.pageId;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var PageGroup = await pageGroup.findAll({
            where: {
                pageId: pageId
            }
        });
        return res.status(200).json({
            message: 'PageGroup',
            PageGroup: PageGroup,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getGroups = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var PageGroup = await pageGroup.findAll({

        });
        return res.status(200).json({
            message: 'PageGroup',
            PageGroup: PageGroup,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getPageFollowers = async (req, res, next) => {
    var username = req.user.username;
    var pageId = req.params.pageId;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var pageFollowers = await pageFollower.findAll({
            where: {
                pageId: pageId
            }
        });
        return res.status(200).json({
            message: 'pageFollowers',
            pageFollowers: pageFollowers,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getPageAdmins = async (req, res, next) => {
    var username = req.user.username;
    var pageId = req.params.pageId;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,   
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var pageAdmins = await pageAdmin.findAll({
            where: {
                pageId: pageId
            }
        });
        return res.status(200).json({
            message: 'pageAdmins',
            pageAdmins: pageAdmins,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getPageEmployees = async (req, res, next) => {
    var username = req.user.username;
    var pageId = req.params.pageId;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var PageEmployees = await pageEmployees.findAll({
            where: {
                pageId: pageId
            }
        });
        return res.status(200).json({
            message: 'PageEmployees',
            PageEmployees: PageEmployees,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getPageCalender = async (req, res, next) => {
    var username = req.user.username;
    var pageId = req.params.pageId;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var PageCalender = await pageCalender.findAll({
            where: {
                pageId: pageId
            }
        });
        return res.status(200).json({
            message: 'PageCalender',
            PageCalender: PageCalender,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}