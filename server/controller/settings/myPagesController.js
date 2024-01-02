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
const Page = require("../../models/pages");
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


exports.getPagePostLikes = async (req, res, next) => {
    try {
        const { postId } = req.body;
        console.log(postId)
        console.log("-----------------------------------")
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername) {
            const userPostLikes = await post.findOne({
                where: { id: postId },
                include: [
                    {
                        model: like,
                        order: [['createdAt', 'DESC']],
                    },

                ],
            });
            if (!userPostLikes) {
                return res.status(404).json({ error: 'Post not found' });
            }

            if (userPostLikes) {
                // Extract likes from the userPostLikes object
                const likes = await Promise.all(userPostLikes.likes.map(async (like) => {
                    const createdBy = like.username || like.pageId;
                    const isUser = !!like.username;
                    const isPage = !!like.pageId;
                    var name;
                    var photo;

                    if (isUser) {
                        const user = await User.findOne({
                            where: {
                                username: createdBy
                            },
                        });
                        name = user.firstname + " " + user.lastname;
                        photo = user.photo;
                    } else if (isPage) {
                        const page = await Page.findOne({
                            where: {
                                id: createdBy
                            },
                        });
                        name = page.name;
                        photo = page.photo;
                    }

                    return {
                        id: like.id,
                        createdBy: createdBy,
                        isUser: isUser,
                        name: name,
                        photo: photo,
                    };
                }));

                console.log(likes);
                console.log("-----------------------------------");

                return res.status(200).json({ data: likes });
            }
        } else {
            return res.status(500).json({
                message: 'user not found',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        console.log("aaaaaaaaaaaaaaaaaaaaaaa00");
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }

}
exports.getPagePostComments = async (req, res, next) => {
    try {
        const { postId } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername) {
            const userPostComments = await post.findOne({
                where: { id: postId },
                include: [
                    {
                        model: comment,
                        order: [['Date', 'DESC']],
                    },

                ],
            });
            if (!userPostComments) {
                return res.status(404).json({ error: 'Post not found' });
            }

            if (userPostComments) {

                const comments = await Promise.all(userPostComments.comments.map(async (comment) => {
                    const createdBy = comment.username || comment.pageId;
                    const isUser = comment.username;
                    const isPage = comment.pageId;
                    let name;
                    let photo;

                    if (isUser) {
                        const user = await User.findOne({
                            where: {
                                username: createdBy
                            },
                        });

                        name = user.firstname + " " + user.lastname;
                        photo = user.photo;
                        console.log(name);
                    } else if (isPage) {
                        const page = await Page.findOne({
                            where: {
                                id: createdBy
                            },
                        });
                        name = page.name;
                        photo = page.photo;
                    }

                    return {
                        id: comment.id,
                        postId: comment.postId,
                        createdBy: createdBy,
                        commentContent: comment.commentContent,
                        Date: moment(comment.Date).format('YYYY-MM-DD HH:mm:ss'),
                        isUser: isUser ? true : false,
                        name: name,
                        photo: photo,
                    };
                }));

                return res.status(200).json({ data: comments });

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

}
exports.pageAddLike = async (req, res, next) => {
    try {
        const { postId } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername) {
            const userPostLikes = await post.findOne({
                where: { id: postId },
                include: [
                    {
                        model: like,
                        order: [['createdAt', 'DESC']],
                    },

                ],
            });
            if (userPostLikes) {
                var userPageAdmin = await pageAdmin.findOne({
                    where: { username: userUsername, pageId: userPostLikes.pageId }
                });
                if (userPageAdmin) {//add like as admin with pageId 
                    await like.create({
                        postId: postId,
                        pageId: userPostLikes.pageId,
                    });

                    return res.status(200).json({
                        message: 'like added',
                        body: req.body
                    });
                } else {//add like as user
                    await like.create({
                        postId: postId,
                        username: userUsername,
                    });

                    return res.status(200).json({
                        message: 'like added',
                        body: req.body
                    });
                }

            } else {
                return res.status(404).json({ error: 'Post not found' });

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

}
exports.pageRemoveLike = async (req, res, next) => {
    try {
        const { postId } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername) {
            const pagePosts = await post.findOne({
                where: { id: postId },
            });
            var userPageAdmin = await pageAdmin.findOne({
                where: { username: userUsername, pageId: pagePosts.pageId }
            });
            if (userPageAdmin) {//add like as admin with pageId 
                const userPostLikes = await like.findOne({
                    where: { postId: postId, pageId: pagePosts.pageId },

                });
                if (!userPostLikes) {
                    return res.status(404).json({ error: 'like not found' });
                }
                await userPostLikes.destroy();
                return res.status(200).json({
                    message: 'like removed',
                    body: req.body
                });

            } else {//if user is not admin
                const userPostLikes = await like.findOne({
                    where: { postId: postId, username: userUsername },

                });
                if (!userPostLikes) {
                    return res.status(404).json({ error: 'like not found' });
                }
                await userPostLikes.destroy();
                return res.status(200).json({
                    message: 'like removed',
                    body: req.body
                });

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

}

exports.pageAddComment = async (req, res, next) => {
    try {
        const { postId, commentContent } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        if (!postId || !commentContent) {
            return res.status(409).json({
                message: 'valuse cant be empty',
                body: req.body
            });
        }
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername) {
            const userPostComments = await post.findOne({
                where: { id: postId },
                include: [
                    {
                        model: comment,
                        order: [['createdAt', 'DESC']],
                    },

                ],
            });
            if (!userPostComments) {
                return res.status(404).json({ error: 'Post not found' });
            }
            // if the post created by a page
            if (userPostComments.pageId) {
                var userPageAdmin = await pageAdmin.findOne({
                    where: { username: userUsername, pageId: userPostComments.pageId }
                });
                if (userPageAdmin) {
                    // Extract comments from the userPostcommentsobject
                    await comment.create({
                        postId: postId,
                        pageId: userPostComments.pageId,
                        commentContent: commentContent,
                        Date: new Date(),
                    });

                    return res.status(200).json({
                        message: 'comment created',
                        body: req.body
                    });
                }
                else {
                    await comment.create({
                        postId: postId,
                        username: username,
                        commentContent: commentContent,
                        Date: new Date(),
                    });

                    return res.status(200).json({
                        message: 'comment created',
                        body: req.body
                    });
                }
            }else{

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

}