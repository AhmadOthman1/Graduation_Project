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
        if (existingEmail != null) {

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
        if (existingEmail != null) {

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
exports.deletePagePost = async (req, res, next) => {
    try {
        const { postId, pageId } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            var userPageAdmin = await pageAdmin.findOne({
                where: { username: userUsername, pageId: pageId }
            });
            if (userPageAdmin != null) {
                const userPost = await post.findOne({
                    where: { id: postId },
                });
                if (userPost == null) {
                    return res.status(404).json({ error: 'Post not found' });
                }

                if (userPost.pageId == pageId) {
                    await userPost.destroy();
                    return res.status(200).json({
                        message: 'Post deleted',
                    });
                } else {
                    return res.status(500).json({
                        message: 'You are not allowed to delete this post',
                        body: req.body
                    });
                }
            } else {
                return res.status(500).json({
                    message: 'You are not Admin',
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
        if (existingUsername != null) {
            //find if the user is admin in the page
            var userAdmin = await pageAdmin.findOne({
                where: {
                    username: userUsername,
                    pageId: pageId
                },
                include: userPages,
            });
            if (userAdmin != null) {
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
                var existingPage = await Page.findOne({
                    where: {
                        id: pageId,
                    }
                });
                if (existingPage == null) {
                    return res.status(404).json({
                        message: 'Page not found',
                        body: req.body
                    });
                }
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
                const posts = pagePosts.map(post => {
                    const isLiked = post.likes.some(like => like.username === userUsername);

                    return {
                        id: post.id,
                        createdBy: pageId,
                        name: existingPage.name,
                        userPhoto: existingPage.photo,
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
        if (existingUsername != null) {
            const userPostLikes = await post.findOne({
                where: { id: postId },
                include: [
                    {
                        model: like,
                        order: [['createdAt', 'DESC']],
                    },

                ],
            });
            if (userPostLikes == null) {
                return res.status(404).json({ error: 'Post not found' });
            }

            if (userPostLikes != null) {
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
        if (existingUsername != null) {
            const userPostComments = await post.findOne({
                where: { id: postId },
                include: [
                    {
                        model: comment,
                        order: [['Date', 'DESC']],
                    },

                ],
            });
            if (userPostComments == null) {
                return res.status(404).json({ error: 'Post not found' });
            }

            if (userPostComments != null) {

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
exports.deletePageComment = async (req, res, next) => {
    try {
        const { commentId, pageId } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            var userPageAdmin = await pageAdmin.findOne({
                where: { username: userUsername, pageId: pageId }
            });
            if (userPageAdmin != null) {// if user is admin in the page
                const pageComment = await comment.findOne({
                    where: { id: commentId },
                });
                if (pageComment == null) {
                    return res.status(404).json({ error: 'Comment not found' });
                }

                if (pageComment.pageId == pageId) {// if page is the comment creator
                    await pageComment.destroy();
                    return res.status(200).json({
                        message: 'Comment deleted',
                    });
                } else {
                    const pagePost = await post.findOne({
                        where: { id: pageComment.postId },
                    });
                    if (pagePost == null) {
                        return res.status(404).json({ error: 'Post not found' });
                    }
                    if (pagePost.pageId == pageId) {// if page is the post creator
                        await pageComment.destroy();
                        return res.status(200).json({
                            message: 'Comment deleted',
                        });
                    } else {
                        return res.status(500).json({
                            message: 'You are not allowed to delete this comment',
                            body: req.body
                        });
                    }
                }
            } else {// if user not admin => wants to remove his comment from the page post
                const pageComment = await comment.findOne({
                    where: { id: commentId },
                });
                if (pageComment == null) {
                    return res.status(404).json({ error: 'Comment not found' });
                }

                if (pageComment.username == userUsername) {// if user is the comment creator
                    await pageComment.destroy();
                    return res.status(200).json({
                        message: 'Comment deleted',
                    });
                } else {
                    return res.status(500).json({
                        message: 'You are not allowed to delete this comment',
                        body: req.body
                    });
                }
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
        if (existingUsername != null) {
            const userPostLikes = await post.findOne({
                where: { id: postId },
                include: [
                    {
                        model: like,
                        order: [['createdAt', 'DESC']],
                    },

                ],
            });
            if (userPostLikes != null) {
                var userPageAdmin = await pageAdmin.findOne({
                    where: { username: userUsername, pageId: userPostLikes.pageId }
                });
                if (userPageAdmin != null) {//add like as admin with pageId 
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
        if (existingUsername != null) {
            const pagePosts = await post.findOne({
                where: { id: postId },
            });
            var userPageAdmin = await pageAdmin.findOne({
                where: { username: userUsername, pageId: pagePosts.pageId }
            });
            if (userPageAdmin != null) {//add like as admin with pageId 
                const userPostLikes = await like.findOne({
                    where: { postId: postId, pageId: pagePosts.pageId },

                });
                if (userPostLikes == null) {
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
                if (userPostLikes == null) {
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
        if (existingUsername != null) {
            const userPostComments = await post.findOne({
                where: { id: postId },
                include: [
                    {
                        model: comment,
                        order: [['createdAt', 'DESC']],
                    },

                ],
            });
            if (userPostComments == null) {
                return res.status(404).json({ error: 'Post not found' });
            }
            // if the post created by a page
            if (userPostComments.pageId) {
                var userPageAdmin = await pageAdmin.findOne({
                    where: { username: userUsername, pageId: userPostComments.pageId }
                });
                if (userPageAdmin != null) {
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
                        username: userUsername,
                        commentContent: commentContent,
                        Date: new Date(),
                    });

                    return res.status(200).json({
                        message: 'comment created',
                        body: req.body
                    });
                }
            } else {

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
exports.postNewPagePost = async (req, res, next) => {
    try {
        const { postContent, postImageBytes, postImageBytesName, postImageExt, pageId } = req.body;
        var validphoto = false;
        var newphotoname = null;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            var userPageAdmin = await pageAdmin.findOne({
                where: { username: userUsername, pageId: pageId }
            });
            if (userPageAdmin != null) {

                if ((postContent == null || postContent.trim() == "") && (postImageBytes == null || postImageBytesName == null || postImageExt == null)) {
                    return res.status(409).json({
                        message: 'you must add a text or photo to create a new post',
                        body: req.body
                    });
                }
                if (postImageBytes != null && postImageBytesName != null && postImageExt != null) {//if feild change enables (!=null)
                    validphoto = true;
                }
                if (validphoto) {
                    const photoBuffer = Buffer.from(postImageBytes, 'base64');
                    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
                    newphotoname = userUsername + +"-" + uniqueSuffix + "." + postImageExt; // You can adjust the file extension based on the actual image type
                    const uploadPath = path.join('images', newphotoname);

                    // Save the image to the server
                    fs.writeFileSync(uploadPath, photoBuffer);
                    console.log("fff" + newphotoname);
                    // Update the user record in the database with the new photo name
                }
                const result = await post.create({
                    "pageId": pageId,
                    "postContent": postContent,
                    "selectedPrivacy": "Any One",
                    "photo": newphotoname,
                    "postDate": new Date(),

                }).then(() => {
                    res.status(200).json({
                        message: "created sucsessfully",
                    })
                }).catch((err) => {
                    console.log(err);
                    return res.status(500).json({
                        message: 'server Error',
                        body: req.body
                    });
                });
            } else {
                return res.status(500).json({
                    message: 'You are not Admin',
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

exports.editPageInfo = async (req, res, next) => {
    try {
        const { pageId, name, specialty, address, country, contactInfo, description, profileImageBytes, profileImageBytesName, profileImageExt, coverImageBytes, coverImageBytesName, coverImageExt } = req.body;
        var validname = false;
        var validspecialty = false;
        var validaddress = false;
        var validcountry = false;
        var validcontactInfo = false;
        var validdescription = false;
        var validphoto = false;
        var validcoverImage = false;
        const existingEmail = await User.findOne({
            where: {
                email: req.user.email
            },
        });
        if (existingEmail != null) {
            var userPageAdmin = await pageAdmin.findOne({
                where: { username: req.user.username, pageId: pageId, adminType: "A" }
            });
            if (userPageAdmin != null) {
                var currentPageInfo = await Page.findOne({
                    where: {
                        id: pageId
                    }
                })
                if (name != null) {//if feild change enables (!=null)
                    if (name.length < 1 || name.length > 50) {//validate
                        return res.status(409).json({
                            message: 'Not Valid name',
                            body: req.body
                        });
                    } else {//change
                        validname = true;
                    }
                }
                if (specialty != null) {//if feild change enables (!=null)
                    if (specialty.length < 1 || specialty.length > 2000) {//validate
                        return res.status(409).json({
                            message: 'Not Valid specialty',
                            body: req.body
                        });
                    } else {//change
                        validspecialty = true;
                    }
                }
                if (address != null) {//if feild change enables (!=null)
                    if (address.length < 1 || address.length > 2000) {//validate
                        return res.status(409).json({
                            message: 'Not Valid address',
                            body: req.body
                        });
                    } else {//change
                        validaddress = true;
                    }
                }
                if (country != null) {//if feild change enables (!=null)
                    if (country.length < 1 || country.length > 250) {//validate
                        return res.status(409).json({
                            message: 'Not Valid country',
                            body: req.body
                        });
                    } else {//change
                        validcountry = true;
                    }
                }
                if (contactInfo != null) {//if feild change enables (!=null)
                    if (contactInfo.length < 1 || contactInfo.length > 2000) {//validate
                        return res.status(409).json({
                            message: 'Not Valid contactInfo',
                            body: req.body
                        });
                    } else {//change
                        validcontactInfo = true;
                    }
                }
                if (description != null) {//if feild change enables (!=null)
                    if (description.length < 1 || description.length > 2000) {//validate
                        return res.status(409).json({
                            message: 'Not Valid description',
                            body: req.body
                        });
                    } else {//change
                        validdescription = true;
                    }
                }
                if (profileImageBytes != null && profileImageBytesName != null && profileImageExt != null) {//if feild change enables (!=null)
                    validphoto = true;
                }
                if (coverImageBytes != null && coverImageBytesName != null && coverImageExt != null) {//if feild change enables (!=null)
                    validcoverImage = true;
                }

                // save changes
                if (validname) {
                    const result = await Page.update(
                        { name: name },
                        {
                            where: { id: pageId },
                        }
                    );
                }
                if (validspecialty) {
                    const result = await Page.update(
                        { specialty: specialty },
                        {
                            where: { id: pageId },
                        }
                    );
                }
                if (validaddress) {
                    const result = await Page.update(
                        { address: address },
                        {
                            where: { id: pageId },
                        }
                    );
                }
                if (validcountry) {
                    const result = await Page.update(
                        { country: country },
                        {
                            where: { id: pageId },
                        }
                    );
                }
                if (validcontactInfo) {
                    const result = await Page.update(
                        { contactInfo: contactInfo },
                        {
                            where: { id: pageId },
                        }
                    );
                }
                if (validdescription) {
                    const result = await Page.update(
                        { description: description },
                        {
                            where: { id: pageId },
                        }
                    );
                }
                if (validphoto) {
                    var oldPhoto = currentPageInfo.photo;

                    const photoBuffer = Buffer.from(profileImageBytes, 'base64');
                    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
                    const newphotoname = currentPageInfo.id + "-" + uniqueSuffix + "." + profileImageExt; // You can adjust the file extension based on the actual image type
                    const uploadPath = path.join('images', newphotoname);

                    // Save the image to the server
                    fs.writeFileSync(uploadPath, photoBuffer);
                    console.log("fff" + newphotoname);
                    // Update the user record in the database with the new photo name
                    const result = await Page.update({ photo: newphotoname }, { where: { id: pageId } });
                    if (oldPhoto != null) {
                        //delete the old photo from the  server image folder
                        const oldPhotoPath = path.join('images', oldPhoto);

                        fs.unlinkSync(oldPhotoPath);
                    }

                }
                if (validcoverImage) {
                    var oldCover = currentPageInfo.coverImage;

                    const photoBuffer = Buffer.from(coverImageBytes, 'base64');
                    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
                    const newphotoname = currentPageInfo.id + +"-" + uniqueSuffix + "." + coverImageExt; // You can adjust the file extension based on the actual image type
                    const uploadPath = path.join('images', newphotoname);

                    // Save the image to the server
                    fs.writeFileSync(uploadPath, photoBuffer);

                    // Update the user record in the database with the new photo name
                    const result = await Page.update({ coverImage: newphotoname }, { where: { id: pageId } });
                    if (oldCover != null) {
                        //delete the old photo from the  server image folder
                        const oldCoverPath = path.join('images', oldCover);

                        fs.unlinkSync(oldCoverPath);
                    }

                }

                return res.status(200).json({
                    message: 'updated',
                    body: req.body
                });
            } else {
                return res.status(500).json({
                    message: 'you are not allowed to edit this page info',
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
exports.getPageAdmins = async (req, res, next) => {
    try {
        var page = req.query.page || 1;
        var pageSize = req.query.pageSize || 10;
        var pageId = req.query.pageId;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // Calculate the offset based on page and pageSize
        const offset = (page - 1) * pageSize;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            var userPageAdmin = await pageAdmin.findOne({
                where: { username: userUsername, pageId: pageId, adminType: "A" }
            });
            if (userPageAdmin != null) {

                const allPageAdmin = await pageAdmin.findAll({
                    where: {
                        pageId: pageId,
                    },
                    limit: parseInt(pageSize),
                    offset: parseInt(offset),
                    order: [['createdAt', 'DESC']],
                });
                const fullPageAdminBody = await Promise.all(allPageAdmin.map(async (admin) => {
                    const user = await User.findOne({
                        where: {
                            username: admin.username
                        }
                    });
                    const photo = user ? user.photo : null;
                    const firstname = user.firstname;
                    const lastname = user.lastname;

                    var adminType;
                    if (admin.adminType == "A") {
                        adminType = "Admin";
                    } else {
                        adminType = "Publisher";
                    }
                    return {
                        ...admin.dataValues,
                        firstname,
                        lastname,
                        createdAt: moment(admin.createdAt).format('YYYY-MM-DD HH:mm:ss'),
                        adminType: adminType,
                        photo,
                    };
                }));
                console.log(fullPageAdminBody);
                return res.status(200).json({
                    pageAdmins: fullPageAdminBody,
                });
            } else {
                return res.status(500).json({
                    message: 'You are not allowed to see this information',
                    body: req.body,
                });
            }
        }
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    }
};

exports.addNewAdmin = async (req, res, next) => {
    try {
        var pageId = req.body.pageId;
        var adminUsername = req.body.adminUsername;
        var selectedRole = req.body.selectedRole;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // Calculate the offset based on page and pageSize
        if (pageId == null || adminUsername == null || selectedRole == null) {
            return res.status(500).json({
                message: 'invalid values',
                body: req.body,
            });
        }
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            var userPageAdmin = await pageAdmin.findOne({
                where: { username: userUsername, pageId: pageId, adminType: "A" }
            });
            if (userPageAdmin != null) {
                const existingAdminUsername = await User.findOne({
                    where: {
                        username: adminUsername
                    },
                });
                if (existingAdminUsername != null) {
                    const isAddedUsernameAdmin = await pageAdmin.findOne({
                        where: {
                            pageId: pageId,
                            username: adminUsername,
                        },
                    });
                    if (isAddedUsernameAdmin != null) {
                        if (isAddedUsernameAdmin.adminType == selectedRole) {
                            return res.status(500).json({
                                message: 'This User Is already an Admin',
                            });
                        } else {
                            await pageAdmin.update(
                                { adminType: selectedRole },
                                {
                                    where: {
                                        pageId: pageId,
                                        username: adminUsername,
                                    },
                                });
                            return res.status(500).json({
                                message: 'you Changed ' + adminUsername + ' role successfully',
                            });
                        }

                    } else {
                        await pageAdmin.create({
                            pageId: pageId,
                            username: adminUsername,
                            adminType: selectedRole,
                        });
                        return res.status(200).json({
                            message: 'you added ' + adminUsername + ' as admin successfully',
                        });
                    }
                } else {
                    return res.status(404).json({
                        message: 'User not found',
                    });
                }
            } else {
                return res.status(500).json({
                    message: 'You are not allowed to edit this information',
                    body: req.body,
                });
            }
        }
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    }
};
exports.deleteAdmin = async (req, res, next) => {
    try {
        var pageId = req.body.pageId;
        var adminUsername = req.body.adminUsername;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // Calculate the offset based on page and pageSize
        if (pageId == null || adminUsername == null) {
            return res.status(500).json({
                message: 'invalid values',
                body: req.body,
            });
        }
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            var userPageAdmin = await pageAdmin.findOne({
                where: { username: userUsername, pageId: pageId, adminType: "A" }
            });
            if (userPageAdmin != null) {
                const existingAdminUsername = await User.findOne({
                    where: {
                        username: adminUsername
                    },
                });
                if (existingAdminUsername != null) {
                    const isDeletedUsernameAdmin = await pageAdmin.findOne({
                        where: {
                            pageId: pageId,
                            username: adminUsername,
                        },
                    });
                    if (isDeletedUsernameAdmin != null) {
                        await isDeletedUsernameAdmin.destroy();
                        return res.status(200).json({
                            message: 'Admin deleted',
                        });
                    } else {

                        return res.status(404).json({
                            message: 'This user is not admin in your page',
                        });
                    }
                } else {
                    return res.status(404).json({
                        message: 'User not found',
                    });
                }
            } else {
                return res.status(500).json({
                    message: 'You are not allowed to edit this information',
                    body: req.body,
                });
            }
        }
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    }
};
exports.getPageEmployees = async (req, res, next) => {
    try {
        var page = req.query.page || 1;
        var pageSize = req.query.pageSize || 10;
        var pageId = req.query.pageId;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // Calculate the offset based on page and pageSize
        const offset = (page - 1) * pageSize;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            var userPageAdmin = await pageAdmin.findOne({
                where: { username: userUsername, pageId: pageId, adminType: "A" }
            });
            if (userPageAdmin != null) {

                const allPageEmployees = await pageEmployees.findAll({
                    where: {
                        pageId: pageId,
                    },
                    limit: parseInt(pageSize),
                    offset: parseInt(offset),
                    order: [['createdAt', 'DESC']],
                });
                const fullPageEmployeesBody = await Promise.all(allPageEmployees.map(async (employee) => {
                    const user = await User.findOne({
                        where: {
                            username: employee.username
                        }
                    });
                    const photo = user ? user.photo : null;
                    const firstname = user.firstname;
                    const lastname = user.lastname;
                    return {
                        ...employee.dataValues,
                        firstname,
                        lastname,
                        createdAt: moment(employee.createdAt).format('YYYY-MM-DD HH:mm:ss'),
                        photo,
                    };
                }));
                return res.status(200).json({
                    pageEmployees: fullPageEmployeesBody,
                });
            } else {
                return res.status(500).json({
                    message: 'You are not allowed to see this information',
                    body: req.body,
                });
            }
        }
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    }
};
exports.addNewEmployee = async (req, res, next) => {
    try {
        var pageId = req.body.pageId;
        var employeeUsername = req.body.employeeUsername;
        var field = req.body.field;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // Calculate the offset based on page and pageSize
        if (pageId == null || employeeUsername == null || field == null) {
            return res.status(500).json({
                message: 'invalid values',
                body: req.body,
            });
        }
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            var userPageAdmin = await pageAdmin.findOne({
                where: { username: userUsername, pageId: pageId, adminType: "A" }
            });
            if (userPageAdmin != null) {
                const existingEmployeeUsername = await User.findOne({
                    where: {
                        username: employeeUsername
                    },
                });
                if (existingEmployeeUsername != null) {
                    const isAddedUsernameEmployee = await pageEmployees.findOne({
                        where: {
                            pageId: pageId,
                            username: employeeUsername,
                        },
                    });
                    if (isAddedUsernameEmployee != null) {
                        if (isAddedUsernameEmployee.field == field) {
                            return res.status(500).json({
                                message: 'This User Is already an Employee',
                            });
                        } else {
                            await pageEmployees.update(
                                { field: field },
                                {
                                    where: {
                                        pageId: pageId,
                                        username: employeeUsername,
                                    },
                                });
                            return res.status(500).json({
                                message: 'you Changed ' + employeeUsername + ' field successfully',
                            });
                        }

                    } else {
                        await pageEmployees.create({
                            pageId: pageId,
                            username: employeeUsername,
                            field: field,
                        });
                        return res.status(200).json({
                            message: 'you added ' + employeeUsername + ' as employee successfully',
                        });
                    }
                } else {
                    return res.status(404).json({
                        message: 'User not found',
                    });
                }
            } else {
                return res.status(500).json({
                    message: 'You are not allowed to edit this information',
                    body: req.body,
                });
            }
        }
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    }
};
exports.deleteEmployee = async (req, res, next) => {
    try {
        var pageId = req.body.pageId;
        var employeeUsername = req.body.employeeUsername;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // Calculate the offset based on page and pageSize
        if (pageId == null || employeeUsername == null) {
            return res.status(500).json({
                message: 'invalid values',
                body: req.body,
            });
        }
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            var userPageAdmin = await pageAdmin.findOne({
                where: { username: userUsername, pageId: pageId, adminType: "A" }
            });
            if (userPageAdmin != null) {
                const existingEmployeeUsername = await User.findOne({
                    where: {
                        username: employeeUsername
                    },
                });
                if (existingEmployeeUsername != null) {
                    const isDeletedUsernameEmployee = await pageEmployees.findOne({
                        where: {
                            pageId: pageId,
                            username: employeeUsername,
                        },
                    });
                    if (isDeletedUsernameEmployee != null) {
                        await isDeletedUsernameEmployee.destroy();
                        return res.status(200).json({
                            message: 'Employee deleted',
                        });
                    } else {

                        return res.status(404).json({
                            message: 'This user is not employee in your page',
                        });
                    }
                } else {
                    return res.status(404).json({
                        message: 'User not found',
                    });
                }
            } else {
                return res.status(500).json({
                    message: 'You are not allowed to edit this information',
                    body: req.body,
                });
            }
        }
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    }
};
exports.getPageJobs = async (req, res, next) => {
    try {
        var page = req.query.page || 1;
        var pageSize = req.query.pageSize || 10;
        var pageId = req.query.pageId;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // Calculate the offset based on page and pageSize
        const offset = (page - 1) * pageSize;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            var userPageAdmin = await pageAdmin.findOne({
                where: { username: userUsername, pageId: pageId, adminType: "A" }
            });
            if (userPageAdmin != null) {

                const allPageJobs = await pageJobs.findAll({
                    where: {
                        pageId: pageId,
                    },
                    limit: parseInt(pageSize),
                    offset: parseInt(offset),
                    order: [['endDate', 'DESC']],
                });

                return res.status(200).json({
                    pageJobs: allPageJobs,
                });
            } else {
                return res.status(500).json({
                    message: 'You are not allowed to see this information',
                    body: req.body,
                });
            }
        }
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    }
};
exports.getPageJobApplications = async (req, res, next) => {
    try {
        var pageJobId = req.query.pageJobId;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // Calculate the offset based on page and pageSize
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            var pageJob = await pageJobs.findOne({
                where: {
                    pageJobId: pageJobId
                }
            });
            if (pageJob != null) {
                var userPageAdmin = await pageAdmin.findOne({
                    where: { username: userUsername, pageId: pageJob.pageId, adminType: "A" }
                });
                if (userPageAdmin != null) {

                    var jobApplications = await jobApplication.findAll({
                        where: {
                            pageJobId: pageJobId
                        },
                        include: [{
                            model: User,
                            attributes: ['username', 'firstname', 'lastname', 'email', 'Fields', 'photo']
                        }]
                    });
                    return res.status(200).json({
                        pageJob: pageJob,
                        application: jobApplications,
                    });
                } else {
                    return res.status(500).json({
                        message: 'You are not allowed to see this information',
                        body: req.body,
                    });
                }
            } else {
                return res.status(404).json({
                    message: 'job not found',
                    body: req.body,
                });
            }
        }
        return res.status(404).json({
            message: 'user not found',
            body: req.body,
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    }
};
exports.getJobFields = async (req, res, next) => {
    try {
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // Calculate the offset based on page and pageSize
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            var availableFields = await systemFields.findAll({
                attributes: ['Field'],
            });
            if (availableFields != null) {
                return res.status(200).json({
                    message: 'Fields fetched',
                    availableFields: availableFields,

                });
            } else {
                return res.status(500).json({
                    message: 'Server Error',
                    body: req.body,
                });
            }
        }
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    }
};

exports.addNewJob = async (req, res, next) => {
    try {
        var pageId = req.body.pageId;
        var title = req.body.title;
        var fields = req.body.fields;
        var description = req.body.description;
        var endDate = req.body.endDate;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // Calculate the offset based on page and pageSize
        if (pageId == null || title == null || fields == null || description == null || endDate == null) {
            return res.status(500).json({
                message: 'invalid values',
                body: req.body,
            });
        }
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            var userPageAdmin = await pageAdmin.findOne({
                where: { username: userUsername, pageId: pageId, adminType: "A" }
            });
            if (userPageAdmin != null) {
                console.log(fields)
                availableSystemFields = await systemFields.findAll();
                const fieldsArray = fields.split(',');
                var fieldsToSave = "";
                availableSystemFields.forEach(async systemField => {//for each job field
                    if (fieldsArray.includes(systemField.dataValues.Field)) {// if field is valid
                        fieldsToSave += systemField.dataValues.Field + ",";//save it to store it in the database
                    }
                });
                fieldsToSave = fieldsToSave.slice(0, -1);
                var newJob = await pageJobs.create({
                    pageId: pageId,
                    title: title,
                    Fields: fieldsToSave,
                    description: description,
                    endDate: endDate
                });
                var uniqueUsernames = [];
                await availableSystemFields.forEach(async systemField => {//for each job field
                    if (fieldsArray.includes(systemField.dataValues.Field)) {// if field is valid
                        const pageFollowers = await pageFollower.findAll({// find page followers to send them notification
                            where: {
                                pageId: pageId,
                            },
                            include: [{
                                model: User,
                                attributes: ['username', 'Fields']
                            }]
                        });
                        if (pageFollowers != null) {// if page has followers 
                            pageFollowers.forEach(async follower => {//for each follower 
                                var followerUsername = follower.dataValues.username;
                                var followerFields = follower.dataValues.user.dataValues.Fields; // fetch his fields
                                if (followerFields == null) {
                                    return; // discard this user
                                }
                                const userFieldsArray = followerFields.split(',');
                                userFieldsArray.forEach(async userField => {//for each field

                                    if (userField == systemField.dataValues.Field) {//if its equal to the new job field 
                                        if (!uniqueUsernames.includes(followerUsername)) {//send notification for all followers with the same field one time only
                                            uniqueUsernames.push(followerUsername);
                                            console.log(uniqueUsernames)
                                            const notification = {
                                                username: followerUsername,
                                                notificationType: 'job',
                                                notificationContent: "A company you follow posted a new job you might be interested in",
                                                notificationPointer: newJob.pageJobId.toString(),
                                            };
                                            await notifyUser(followerUsername, notification);
                                        }
                                    }

                                });

                            })
                        }
                    }
                });

                return res.status(200).json({
                    message: 'Job added successfully',
                });
            } else {
                return res.status(500).json({
                    message: 'You are not allowed to edit this information',
                    body: req.body,
                });
            }
        }
        return res.status(500).json({
            message: 'user not found',
            body: req.body,
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    }
};