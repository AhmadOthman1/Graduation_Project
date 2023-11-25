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
exports.getMyPageInfo=async (req,res,next)=>{
    try{
        var email = req.query.email;
        const existingEmail = await User.findOne({
            where: {
                    email: email 
                },
            });
        if(existingEmail){
            return res.status(409).json({
                message: 'return',
                body: req.body
                });
        }else{
            return res.status(500).json({
                message: 'server Error',
                body: req.body
                });
        }
        console.log(email);
        console.log("*************************");
    }  catch(err){
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
            });
    }
}