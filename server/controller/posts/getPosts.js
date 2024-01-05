
const User = require("../../models/user");
const Page = require("../../models/pages");
const path = require('path');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const post = require('../../models/post');
const comment = require('../../models/comment');
const like = require('../../models/like');
const moment = require('moment');
const Connections = require("../../models/connections");
const { Op } = require('sequelize');

async function findIfUserInConnections(userUsername, findProfileUsername) {
    const userConnections = await Connections.findAll({
        where: {
            [Op.or]: [
                { senderUsername: userUsername },
                { receiverUsername: userUsername },
            ],
        },
        include: [{
            model: User,
            as: 'senderUsername_FK',
            attributes: ['username'],
        }, {
            model: User,
            as: 'receiverUsername_FK',
            attributes: ['username'],
        }],
    });
    const userInConnections = userConnections.filter(connection => {
        // Check if the username is in senders or receivers
        return connection.senderUsername_FK.username === findProfileUsername || connection.receiverUsername_FK.username === findProfileUsername;
    });
    return userInConnections;
}

exports.addComment = async (req, res, next) => {
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
        // اذا كان الشخص بده يعلق ع بوست بنفحص اذا الشخص موجود اذا مش موجود بكون صفحة بدها تعلق ع بوست
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
            // لازم نفحص اذا اليوزر نيم للبوست موجود بعدها بنطبق كل الي تحت واذا لا بكون بده يعلق ع بوست صفحة
            if (userPostComments.username == userUsername) {
                // Extract comments from the userPostcommentsobject
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
            else {
                if (userPostComments.username != userUsername) {
                    if (userPostComments.selectedPrivacy == "Any One") {
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
                    } else {
                        var userInConnections = await findIfUserInConnections(userUsername, userPostComments.username);
                        if (userInConnections[0]) { // check if user is connected to other user
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
                        }else {
                            return res.status(500).json({
                                message: 'You are not allowed to see add a comment',
                                body: req.body
                            });
                        }
                    }
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

exports.getPostComments = async (req, res, next) => {
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

            if (userPostComments.username == userUsername) {

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
                                pageId: createdBy
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

            }//if the post for other user
            const existingOtherUsername = await User.findOne({
                where: {
                    username: userPostComments.username
                },
            });
            if (existingOtherUsername != null) {
                var userInConnections = await findIfUserInConnections(userUsername, userPostComments.username);
                if (userInConnections[0]) { // check if user is connected to other user
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
                                    pageId: createdBy
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

                } else {// if the other user is not in user connections
                    if (userPostComments.selectedPrivacy == "Any One") {// if the post is public
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
                                        pageId: createdBy
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
                    } else {
                        return res.status(500).json({
                            message: 'You are not allowed to see this info',
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
exports.removeLike = async (req, res, next) => {
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
        console.log(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;")
        console.log(userUsername);
        if (existingUsername != null) {
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
exports.addLike = async (req, res, next) => {
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
            if (userPostLikes == null) {
                return res.status(404).json({ error: 'Post not found' });
            }

            if (userPostLikes.username == userUsername) {
                // Extract likes from the userPostLikes object
                await like.create({
                    postId: postId,
                    username: userUsername,
                });

                return res.status(200).json({
                    message: 'like added',
                    body: req.body
                });
            }
            else {
                if (userPostLikes.username != userUsername) {
                    if (userPostLikes.selectedPrivacy == "Any One") {
                        await like.create({
                            postId: postId,
                            username: userUsername,
                        });
                        return res.status(200).json({
                            message: 'like added',
                            body: req.body
                        });
                    } else {
                        var userInConnections = await findIfUserInConnections(userUsername, userPostLikes.username);
                        if (userInConnections[0]) { // check if user is connected to other user
                            await like.create({
                                postId: postId,
                                username: userUsername,
                            });
                            return res.status(200).json({
                                message: 'like added',
                                body: req.body
                            });
                        }else {
                            return res.status(500).json({
                                message: 'You are not allowed to see add like to this post',
                                body: req.body
                            });
                        }
                    }
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
exports.getPostLikes = async (req, res, next) => {
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

            if (userPostLikes.username == userUsername) {// if it is the user post
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
                                pageId: createdBy
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
            } else {//if the post for other user
                const existingOtherUsername = await User.findOne({
                    where: {
                        username: userPostLikes.username
                    },
                });
                if (existingOtherUsername != null) {
                    var userInConnections = await findIfUserInConnections(userUsername, userPostLikes.username);
                    if (userInConnections[0]) { // check if user is connected to other user
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
                                        pageId: createdBy
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
                    } else {// if the other user is not in user connections
                        if (userPostLikes.selectedPrivacy == "Any One") {// if the post is public
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
                                            pageId: createdBy
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
                        } else {
                            return res.status(500).json({
                                message: 'You are not allowed to see this info',
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

exports.getPosts = async (req, res, next) => {
    try {
        const { username, pages, pagesSize } = req.body;

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
            if (userUsername == username) {// if it is the user post 
                const userPosts = await post.findAll({
                    where: { username: username },
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
                const posts = userPosts.map(post => {
                    const isLiked = post.likes.some(like => like.username === username);

                    return {
                        id: post.id,
                        createdBy: username,
                        name: existingUsername.firstname + ' ' + existingUsername.lastname,
                        userPhoto: existingUsername.photo,
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
            } else {// if its other user post
                const existingOtherUsername = await User.findOne({
                    where: {
                        username: username
                    },
                });
                if (existingOtherUsername != null) {// if the other user exist 
                    var userInConnections = await findIfUserInConnections(userUsername, username);
                    if (userInConnections[0]) { // check if user is connected to other user
                        const userPosts = await post.findAll({
                            where: { username: username },
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
                        const posts = userPosts.map(post => {
                            const isLiked = post.likes.some(like => like.username === userUsername);

                            return {
                                id: post.id,
                                createdBy: username,
                                name: existingOtherUsername.firstname + ' ' + existingOtherUsername.lastname,
                                userPhoto: existingOtherUsername.photo,
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
                    } else {// if the user is not connected to the other user, return the public posts only
                        const userPosts = await post.findAll({
                            where: { username: username, selectedPrivacy: 'Any One' },
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
                        const posts = userPosts.map(post => {
                            const isLiked = post.likes.some(like => like.username === userUsername);

                            return {
                                id: post.id,
                                createdBy: username,
                                name: existingOtherUsername.firstname + ' ' + existingOtherUsername.lastname,
                                userPhoto: existingOtherUsername.photo,
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
                        message: 'user not found',
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
    return res.status(404).json({
        message: 'server Error',
        body: req.body
    });;
}

exports.deletePost = async (req, res, next) => {
    console.log("innnnnnnnnnnnnnnnnnnn");
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
            const userPost = await post.findOne({
                where: { id: postId },
            });
            if (userPost == null) {
                return res.status(404).json({ error: 'Post not found' });
            }

            if (userPost.username == userUsername) {
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

exports.deleteComment = async (req, res, next) => {
    console.log("innnnnnnnnnnnnnnnnnnn");
    try {
        const { commentId } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            const userComment = await comment.findOne({
                where: { id: commentId },
            });
            if (userComment == null) {
                return res.status(404).json({ error: 'Comment not found' });
            }
            //if user created the comment
            console.log(userComment.username)
            console.log("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
            if (userComment.username == userUsername) {
                await userComment.destroy();
                return res.status(200).json({
                    message: 'Comment deleted',
                });
            } else {
                const userPost = await post.findOne({
                    where: { id: userComment.postId },
                });
                if (userPost != null) {
                    //if user created the post that the comment in it
                    if (userPost.username == userUsername) {
                        await userComment.destroy();
                        return res.status(200).json({
                            message: 'Comment deleted',
                        });
                    } else {
                        return res.status(404).json({ error: 'You are not allowed to delete this comment' });
                    }
                } else {
                    return res.status(404).json({ error: 'Post not found' });
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