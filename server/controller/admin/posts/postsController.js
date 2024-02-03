const User = require("../../../models/user");
const post = require("../../../models/post");
const postHistory = require("../../../models/postHistory");
const postPhotos = require('../../../models/postPhotos');
const postVideos = require('../../../models/postVideos');
const comment = require('../../../models/comment');
const like = require('../../../models/like');
const moment = require('moment');

exports.getUserPosts = async (req, res, next) => {
    var username = req.user.username;
    var userUsername = req.params.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var Posts = await post.findAll({
            where:{
                username:userUsername
            },
            include: [
                {
                    model: comment,
                    order: [['Date', 'DESC']],
                },
                {
                    model: like,
                    order: [['createdAt', 'DESC']],
                },
                {
                    model: postPhotos,
                    order: [['createdAt', 'DESC']],
                },
                {
                    model: postVideos,
                    order: [['createdAt', 'DESC']],
                },
            ],
        });
        const posts = Posts.map(post => {
            return {
                id: post.id,
                createdBy: post.username,
                postContent: post.postContent,
                selectedPrivacy: post.selectedPrivacy,
                photo: post.postPhotos,
                video: post.postVideos,
                postDate: moment(post.updatedAt).format('YYYY-MM-DD HH:mm:ss'),
                commentCount: post.comments.length,
                likeCount: post.likes.length,
            };
        });
        console.log(posts)
        return res.status(200).json({
            message: 'fetched',
            posts: posts,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getPagePosts = async (req, res, next) => {
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
        var Posts = await post.findAll({
            where:{
                pageId:pageId
            },
            include: [
                {
                    model: comment,
                    order: [['Date', 'DESC']],
                },
                {
                    model: like,
                    order: [['createdAt', 'DESC']],
                },
                {
                    model: postPhotos,
                    order: [['createdAt', 'DESC']],
                },
                {
                    model: postVideos,
                    order: [['createdAt', 'DESC']],
                },
            ],
        });
        const posts = Posts.map(post => {
            return {
                id: post.id,
                createdBy: post.username,
                postContent: post.postContent,
                selectedPrivacy: post.selectedPrivacy,
                photo: post.postPhotos,
                video: post.postVideos,
                postDate: moment(post.updatedAt).format('YYYY-MM-DD HH:mm:ss'),
                commentCount: post.comments.length,
                likeCount: post.likes.length,
            };
        });
        console.log(posts)
        return res.status(200).json({
            message: 'fetched',
            posts: posts,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getPosts = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var Posts = await post.findAll({
            include: [
                {
                    model: comment,
                    order: [['Date', 'DESC']],
                },
                {
                    model: like,
                    order: [['createdAt', 'DESC']],
                },
                {
                    model: postPhotos,
                    order: [['createdAt', 'DESC']],
                },
                {
                    model: postVideos,
                    order: [['createdAt', 'DESC']],
                },
            ],
        });
        const posts = Posts.map(post => {
            return {
                id: post.id,
                createdBy: post.username,
                postContent: post.postContent,
                selectedPrivacy: post.selectedPrivacy,
                photo: post.postPhotos,
                video: post.postVideos,
                postDate: moment(post.updatedAt).format('YYYY-MM-DD HH:mm:ss'),
                commentCount: post.comments.length,
                likeCount: post.likes.length,
            };
        });
        console.log(posts)
        return res.status(200).json({
            message: 'fetched',
            posts: posts,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getPost = async (req, res, next) => {
    var username = req.user.username;
    var postId = req.params;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var Posts = await post.findOne({
            where: {
                id: postId,
            },
            include: [
                {
                    model: comment,
                    order: [['Date', 'DESC']],
                },
                {
                    model: like,
                    order: [['createdAt', 'DESC']],
                },
                {
                    model: postPhotos,
                    order: [['createdAt', 'DESC']],
                },
                {
                    model: postVideos,
                    order: [['createdAt', 'DESC']],
                },
            ],

        });
        const posts = Posts.map(post => {
            return {
                id: post.id,
                createdBy: post.username,
                postContent: post.postContent,
                selectedPrivacy: post.selectedPrivacy,
                photo: post.postPhotos,
                video: post.postVideos,
                postDate: moment(post.updatedAt).format('YYYY-MM-DD HH:mm:ss'),
                commentCount: post.comments.length,
                likeCount: post.likes.length,
            };
        });
        console.log(posts)
        return res.status(200).json({
            message: 'fetched',
            posts: posts,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.postHistory = async (req, res, next) => {
    const  postId  = req.params;
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var postsHistory = await postHistory.findAll({
            where: {
                postId: postId
            }
        });
        return res.status(200).json({
            message: 'post History',
            postsHistory: postsHistory,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}