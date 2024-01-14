const User = require("../../models/user");
const { notifyUser, deleteNotificaion } = require("../notifications");
const post = require('../../models/post');
const comment = require('../../models/comment');
const Page = require('../../models/pages');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const { Op } = require('sequelize');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const Sequelize = require('sequelize');
const reportedPost = require("../../models/reportedPost");
const reportedComment = require("../../models/reportedComment");
const reportedUsers = require("../../models/reportedUsers");
const reportedPages = require("../../models/reportedPages");

exports.createPostReport = async (req, res, next) => {
    try {
        const { postId,text } = req.body;
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
            const userReport = await reportedPost.findOne({
                where:{
                    postId: postId,
                    username:userUsername,
                }
            });
            if(userReport!=null){
                return res.status(500).json({
                    message: 'you have already reported this post',
                    body: req.body
                });
            }else{
                await reportedPost.create({
                    postId: postId,
                    username:userUsername,
                    text:text,
                })
                return res.status(200).json({
                    message: 'you have reported this post successfully',
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
exports.createCommentReport = async (req, res, next) => {
    try {
        const { commentId,text } = req.body;
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
            const userReport = await reportedComment.findOne({
                where:{
                    commentId: commentId,
                    username:userUsername,
                }
            });
            if(userReport!=null){
                return res.status(500).json({
                    message: 'you have already reported this comment',
                    body: req.body
                });
            }else{
                await reportedComment.create({
                    commentId: commentId,
                    username:userUsername,
                    text:text,
                })
                return res.status(200).json({
                    message: 'you have reported this comment successfully',
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
exports.createUserReport = async (req, res, next) => {
    try {
        const { userId,text } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            const user = await User.findOne({
                where: { username: userId },
            });
            if (user == null) {
                return res.status(404).json({ error: 'user not found' });
            }
            const userReport = await reportedUsers.findOne({
                where:{
                    userId: userId,
                    username:userUsername,
                }
            });
            if(userReport!=null){
                return res.status(500).json({
                    message: 'you have already reported this user',
                    body: req.body
                });
            }else{
                await reportedUsers.create({
                    userId: userId,
                    username:userUsername,
                    text:text,
                })
                return res.status(200).json({
                    message: 'you have reported this user successfully',
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
exports.createPageReport = async (req, res, next) => {
    try {
        const { pageId,text } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            const page = await Page.findOne({
                where: { id: pageId },
            });
            if (page == null) {
                return res.status(404).json({ error: 'page not found' });
            }
            const userReport = await reportedPages.findOne({
                where:{
                    pageId: pageId,
                    username:userUsername,
                }
            });
            if(userReport!=null){
                return res.status(500).json({
                    message: 'you have already reported this page',
                    body: req.body
                });
            }else{
                await reportedPages.create({
                    pageId: pageId,
                    username:userUsername,
                    text:text,
                })
                return res.status(200).json({
                    message: 'you have reported this page successfully',
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