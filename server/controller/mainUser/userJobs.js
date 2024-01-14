const User = require("../../models/user");
const tempUser = require("../../models/tempUser");
const changeEmail = require("../../models/changeEmail");
const { Op } = require('sequelize');
const validator = require('../validator');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer')
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const jwt = require('jsonwebtoken');
const connections = require("../../models/connections");
const post = require("../../models/post");
const sentConnection = require("../../models/sentConnection");
const pageFollower = require("../../models/pageFollower");
const pageJobs = require("../../models/pageJobs");

exports.getUserJobs = async (req, res, next) => {
    try {
        var page = req.query.page || 1;
        var pageSize = req.query.pageSize || 10;
        const offset = (page - 1) * pageSize;

        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        var userExists = await User.findOne({
            where: {
                username: userUsername,
            },
        });
        if (userExists != null) {

            var userPages = await pageFollower.findAll({
                where: {
                    username:userUsername
                },
                /*limit: parseInt(pageSize),
                offset: parseInt(offset),
                order: [['createdAt', 'DESC']],*/
            });
            var allUserJobs= [];
            for(const Page of userPages){
                var userJobs = await pageJobs.findAll({
                    where: {
                        pageId:Page.pageId
                    },
                    order: [['endDate', 'DESC']],
                });
                for(const job of userJobs){
                    allUserJobs.push(job);
                }
                
            }
            const newArray = allUserJobs.slice(parseInt(offset), parseInt(pageSize)+parseInt(offset) + 1);
            console.log(newArray)
            return res.status(200).json({
                message: 'jobs fetched',
                jobs: newArray
            });
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