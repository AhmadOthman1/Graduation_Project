const User = require("../../models/user");
const pages = require("../../models/pages");
const pageAdmin = require("../../models/pageAdmin");
const { Op } = require('sequelize');
const validator = require('../validator');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer')
const multer = require('multer');
const path = require('path');
const fs = require('fs');
exports.getMyPageInfo = async (req, res, next) => {
    try {
        var email = req.query.email;
        const existingEmail = await User.findOne({
            where: {
                email: email
            },
        });
        if (existingEmail) {
            const authHeader = req.headers['authorization']
            const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
            var userUsername = decoded.username;
            if(existingEmail.username != userUsername){
                return res.status(500).json({
                    message: 'you cant reach this page',
                    body: req.body
                });
            }
            pageAdmin
              .findAll({
                where: { username: existingEmail.username },
                include: pages,
              })
              .then((pageAdmins) => {
                const userPages = pageAdmins.map((pageAdmin) => {
                  const pageData = pageAdmin.page.dataValues; 
                  console.log(pageData); 
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
                  };
                });
          
                console.log(userPages); 
          
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
          }else {
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
        const existingEmail = await User.findOne({
            where: {
                email: email,
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
            const newPage = await pages.create(pageData);

           
            await pageAdmin.create({
                pageId: newPage.id,
                username: existingEmail.username,
                adminType: 'A', 
            });
            return res.status(200).json({
                message: "created",
                body :req.body
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