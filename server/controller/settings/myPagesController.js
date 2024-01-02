const User = require("../../models/user");
const userPages = require("../../models/pages");
const pageAdmin = require("../../models/pageAdmin");
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

exports.getMyPageInfo = async (req, res, next) => {
    try {
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;

        const existingEmail = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingEmail) {

            pageAdmin.findAll({
                where: { username: existingEmail.username },
                include: userPages,
            }).then(async (pageAdmins) => {
                const userPages = await Promise.all(pageAdmins.map(async (pageAdmin) => {
                    const pageData = pageAdmin.page.dataValues;

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
exports.postCreatePage = async (req, res, next) => {
    try {
        const { email, pageId, pageName, description, address, contactInfo, country, speciality, pageType } = req.body;

        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;

        const existingEmail = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingEmail) {

            if (!pageId || !pageName || !description || !address || !contactInfo || !country || !speciality || !pageType) {
                return res.status(409).json({
                    message: 'One or more fields are empty',
                    body: req.body
                });
            }
            if (!validator.isUsername(pageId) || pageId.length < 5 || pageId.length > 50) {
                return res.status(409).json({
                    message: 'Not Valid pageId',
                    body: req.body
                });
            }
            if (pageName.length < 1 || pageName.length > 50) {
                return res.status(409).json({
                    message: 'Not Valid pageName',
                    body: req.body
                });
            }
            if (description.length < 1 || description.length > 2000) {
                return res.status(409).json({
                    message: 'Not Valid description',
                    body: req.body
                });
            }
            if (address.length < 1 || address.length > 2000) {
                return res.status(409).json({
                    message: 'Not Valid address',
                    body: req.body
                });
            }
            if (contactInfo.length < 1 || contactInfo.length > 2000) {
                return res.status(409).json({
                    message: 'Not Valid contactInfo',
                    body: req.body
                });
            }
            if (country.length < 1 || country.length > 250) {
                return res.status(409).json({
                    message: 'Not Valid country',
                    body: req.body
                });
            }
            if (speciality.length < 1 || speciality.length > 2000) {
                return res.status(409).json({
                    message: 'Not Valid speciality',
                    body: req.body
                });
            }
            if (pageType != "public" && pageType != "private") {
                return res.status(409).json({
                    message: 'Not Valid pageType',
                    body: req.body
                });
            }
            //const { pageId, pageName, description, address, contactInfo, country, speciality, pageType } = req.body;
            const pageData = {
                id: pageId, // Generate a unique ID
                name: pageName,
                description: description,
                country: country,
                address: address,
                contactInfo: contactInfo,
                specialty: speciality,
                pageType: pageType,
            };
            const newPage = await userPages.create(pageData);


            await pageAdmin.create({
                pageId: newPage.id,
                username: existingEmail.username,
                adminType: 'A',
            });
            return res.status(200).json({
                message: "created",
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Page ID is already exisits',
            body: req.body
        });
    }
}

exports.getPagePosts = async (req, res, next) => {
    try {
        const { pageId, pages, pagesSize } = req.body;

        var page = pages || 1;
        var pageSize = pagesSize || 10;
        const offset = (page - 1) * pageSize;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername) {
            //find if the user is admin in the page
            var userAdmin = await pageAdmin.findOne({
                where: {
                    username: userUsername,
                    pageId: pageId
                },
                include: userPages,
            });
            if (userAdmin) {
                const pagePosts = await post.findAll({
                    where: { pageId: pageId },
                    order: [['postDate', 'DESC']], // Order posts by date
                    offset: offset, // Calculate the offset
                    limit: pageSize, // Number of records to retrieve
                    include: [
                        {
                            model: comment,
                            order: [['Date', 'DESC']],
                        },
                        {
                            model: like,
                            order: [['createdAt', 'DESC']],
                        },
                    ],
                });
                console.log(pageSize)
                console.log(offset)
                console.log("pppppppppppppppppppppppppppppppppp")
                console.log(pagePosts.posts)
                const posts = pagePosts.map(post => {
                    const isLiked = post.likes.some(like => like.pageId === pageId);

                    return {
                        id: post.id,
                        createdBy: pageId,
                        name: userAdmin.page.dataValues.name,
                        userPhoto: userAdmin.page.dataValues.photo,
                        postContent: post.postContent,
                        selectedPrivacy: post.selectedPrivacy,
                        photo: post.photo,
                        postDate: moment(post.postDate).format('YYYY-MM-DD HH:mm:ss'),
                        commentCount: post.comments.length,
                        likeCount: post.likes.length,
                        isLiked: isLiked,
                    };
                });
                console.log(posts)
                return res.status(200).json({
                    message: 'fetched',
                    posts: posts,
                });
            } else {//user is not admin

            }

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
    return res.status(404).json({
        message: 'server Error',
        body: req.body
    });
}
