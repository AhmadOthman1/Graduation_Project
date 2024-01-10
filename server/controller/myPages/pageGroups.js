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
const pageGroup = require("../../models/pageGroup");
const { notifyUser, deleteNotification } = require('../notifyUser');

exports.getMyPageGroups = async (req, res, next) => {
    try {
        const pageId = req.query.pageId;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;

        const existingEmail = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingEmail != null) {
            const isAdmin = await pageAdmin.findOne({
                where:{
                    username:userUsername,
                    pageId:pageId,
                    adminType: "A"
                }
            });
            if(isAdmin!=null){
                const pageGroups = await pageGroup.findAll({
                    where :{
                        pageId:pageId
                    }
                });
                return res.status(200).json({
                    message: 'Groups',
                    pageGroups: pageGroups
                });
            }else{
                return res.status(500).json({
                    message: 'You are not allowed to see this info',
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