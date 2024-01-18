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
const { notifyUser, deleteNotification } = require('../notifyUser');
const pageGroup = require('../../models/pageGroup');
const groupAdmin = require('../../models/groupAdmin');
const groupMember = require('../../models/groupMember');
exports.getUserFollowedPages = async (req, res, next) => {
    try {
        var page = req.query.page || 1;
        var pageSize = req.query.pageSize || 10;
        const offset = (page - 1) * pageSize;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;

        const existingEmail = await User.findOne({
            where: {
                username: userUsername,
                status:null,
            },
        });
        if (existingEmail != null) {

            pageFollower.findAll({
                where: { username: existingEmail.username },
                include: userPages,
                limit: parseInt(pageSize),
                offset: parseInt(offset),
                order: [['createdAt', 'DESC']],
            }).then(async (followedPages) => {
                const userPages = await Promise.all(followedPages.map(async (followedPage) => {
                    const pageData = followedPage.page.dataValues;

                    const [postCount, followCount] = await Promise.all([
                        post.count({ where: { pageId: pageData.id } }),
                        pageFollower.count({ where: { pageId: pageData.id } }),
                    ]);

                    return {
                        id: pageData.id,
                        name: pageData.name,
                        description: pageData.description,
                        country: pageData.country,
                        address: pageData.address,
                        contactInfo: pageData.contactInfo,
                        specialty: pageData.specialty,
                        pageType: pageData.pageType,
                        photo: pageData.photo,
                        coverImage: pageData.coverImage,
                        postCount: postCount.toString(),
                        followCount: followCount.toString(),
                    };
                }));

                console.log(userPages);
                console.log(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");

                return res.status(200).json({
                    message: 'return',
                    pages: userPages,
                });
            })
                .catch((error) => {
                    console.error('Error:', error);
                    return res.status(500).json({
                        message: 'server Error',
                        body: req.body
                    });
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
exports.getUserEmployedPages = async (req, res, next) => {
    try {
        var page = req.query.page || 1;
        var pageSize = req.query.pageSize || 10;
        const offset = (page - 1) * pageSize;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;

        const existingEmail = await User.findOne({
            where: {
                username: userUsername,
                status:null,
            },
        });
        if (existingEmail != null) {

            pageEmployees.findAll({
                where: { username: existingEmail.username },
                include: userPages,
                limit: parseInt(pageSize),
                offset: parseInt(offset),
                order: [['createdAt', 'DESC']],
            }).then(async (EmployedPages) => {
                const userPages = await Promise.all(EmployedPages.map(async (EmployedPage) => {
                    const pageData = EmployedPage.page.dataValues;

                    const [postCount, followCount] = await Promise.all([
                        post.count({ where: { pageId: pageData.id } }),
                        pageFollower.count({ where: { pageId: pageData.id } }),
                    ]);

                    return {
                        id: pageData.id,
                        name: pageData.name,
                        description: pageData.description,
                        country: pageData.country,
                        address: pageData.address,
                        contactInfo: pageData.contactInfo,
                        specialty: pageData.specialty,
                        pageType: pageData.pageType,
                        photo: pageData.photo,
                        coverImage: pageData.coverImage,
                        postCount: postCount.toString(),
                        followCount: followCount.toString(),
                    };
                }));

                console.log(userPages);
                console.log(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");

                return res.status(200).json({
                    message: 'return',
                    pages: userPages,
                });
            })
                .catch((error) => {
                    console.error('Error:', error);
                    return res.status(500).json({
                        message: 'server Error',
                        body: req.body
                    });
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
const getUserMemberGroups = async (userUsername) => {
    const memberGroups = await groupMember.findAll({
        where: {
            username: userUsername,
        },
    });

    const groupIds = memberGroups.map(group => group.groupId);

    return [...new Set(groupIds)]; // Remove duplicates
};
exports.getUserGroups = async (req, res, next) => {
    try {
        console.log("aaaaaaaaaaaaaaaaaaaa");
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;

        const existingEmail = await User.findOne({
            where: {
                username: userUsername,
                status:null,
            },
        });
        if (existingEmail != null) {
            const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
            const memberGroups = await getUserMemberGroups(userUsername);
        
            const allGroups = [...new Set([...adminGroupsAndChildren, ...memberGroups])];
        
            // Fetch detailed information about the groups
            const groupsDetails = await pageGroup.findAll({
                where: {
                    groupId: {
                        [Op.in]: allGroups,
                    },
                },
            });
            return res.status(200).json({
                message: 'Groups',
                groups: groupsDetails
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