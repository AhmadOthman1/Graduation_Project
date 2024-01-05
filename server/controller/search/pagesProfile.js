const User = require("../../models/user");
const Connections = require("../../models/connections");
const sentConnection = require("../../models/sentConnection");
const WorkExperience = require("../../models/workExperience");
const EducationLevel = require("../../models/educationLevel");
const { notifyUser, deleteNotificaion } = require("../notifications");
const post = require('../../models/post');
const Page = require("../../models/pages");
const pageFollower = require("../../models/pageFollower");
const pageAdmin = require("../../models/pageAdmin");

const jwt = require('jsonwebtoken');
require('dotenv').config();
const { Op } = require('sequelize');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const Sequelize = require('sequelize');

async function findIfUserInFollowers(userUsername, findPageProfile) {
    const userConnections = await pageFollower.findOne({
        where: {
            pageId: findPageProfile,
            username: userUsername
        }
    });
    if (userConnections != null) {
        return true
    } else {
        return false;
    }
}
exports.getPageProfileInfo = async (req, res, next) => {
    try {
        var findPageProfile = req.query.pageId;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // 'decoded' now contains the user information (e.g., email, password)
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {

            const pageProfile = await Page.findOne({
                where: {
                    id: findPageProfile
                },
            });
            if (pageProfile != null) {// if page is found 
                var following = "N";
                var photo;
                var coverimage;
                //check page photo
                if (pageProfile.photo == null) {
                    photo = null;
                } else {
                    const photoFilePath = path.join('images', pageProfile.photo);
                    // Check if the file exists
                    try {
                        await fs.promises.access(photoFilePath, fs.constants.F_OK);
                        photo = pageProfile.photo;
                    } catch (err) {
                        console.error(err);
                        photo = null;
                        await User.update({ photo: photo }, { where: { email } });
                    }

                }
                //check page cover image
                if (pageProfile.coverImage == null) {
                    coverimage = null;
                } else {
                    const coverImageFilePath = await path.join('images', pageProfile.coverImage);
                    // Check if the file exists
                    try {
                        await fs.promises.access(coverImageFilePath, fs.constants.F_OK);
                        coverimage = pageProfile.coverImage;

                    } catch (err) {
                        console.error(err);
                        coverimage = null;
                        await User.update({ coverImage: coverimage }, { where: { email } });
                    }

                }


                var pageUserAdmin = await pageAdmin.findOne({
                    where: {
                        pageId: findPageProfile,
                        username: userUsername
                    }
                });
                if (pageUserAdmin != null) {
                    const [postCount, followCount] = await Promise.all([
                        post.count({ where: { pageId: pageProfile.id } }),
                        pageFollower.count({ where: { pageId: pageProfile.id } }),
                    ]);
                    console.log(pageProfile)
                    return res.status(200).json({
                        message: 'Page found',
                        Page: {
                            isAdmin: true,
                            id: pageProfile.id,
                            name: pageProfile.name,
                            description: pageProfile.description,
                            country: pageProfile.country,
                            address: pageProfile.address,
                            contactInfo: pageProfile.contactInfo,
                            specialty: pageProfile.specialty,
                            pageType: pageProfile.pageType,
                            photo: photo,
                            coverImage: coverimage,
                            postCount: postCount.toString(),
                            followCount: followCount.toString(),
                        }
                    });
                } else {
                    if (pageProfile.pageType == "public") {
                        var userIsFollower = await findIfUserInFollowers(userUsername, findPageProfile);
                        if (userIsFollower) { // check if user is follower to other page
                            following = "F";
                        }
                        const followersCount = await pageFollower.count({
                            where: {
                                pageId: findPageProfile
                            },
                        });
                        const postsCount = await post.count({
                            where: { pageId: findPageProfile },
                        });
                        return res.status(200).json({
                            message: 'Page found',
                            Page: {
                                isAdmin: false,
                                id: pageProfile.id,
                                name: pageProfile.name,
                                description: pageProfile.description,
                                country: pageProfile.country,
                                address: pageProfile.address,
                                contactInfo: pageProfile.contactInfo,
                                specialty: pageProfile.specialty,
                                pageType: pageProfile.pageType,
                                photo: photo,
                                coverImage: coverimage,
                                following: following,
                                followCount: followersCount.toString(),
                                postCount: postsCount.toString(),
                            },
                        });
                    } else {
                        return res.status(500).json({
                            message: 'you are not allowed to see this page',
                            body: req.body
                        });
                    }
                }

            } else {
                return res.status(404).json({
                    message: 'Page not found',
                    body: req.body
                });
            }

        } else {
            return res.status(404).json({
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
exports.followPage = async (req, res, next) => {
    try {
        
        var pageId = req.body.pageId;
        console.log(pageId)
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // 'decoded' now contains the user information (e.g., email, password)
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {//find if user exist
            var existingPage = await Page.findOne({
                where :{
                    id:pageId,
                }
            });
            
            if(existingPage != null){//find if Page exist
                var isUserFollowingPage = await pageFollower.findOne({
                    where:{
                        pageId:pageId,
                        username: userUsername,
                    }
                });
                if(isUserFollowingPage!=null){//find if user is following the page
                    return res.status(500).json({
                        message: 'You are already following this page',
                        body: req.body
                    });
                }else{
                    if(existingPage.pageType == "public"){//if the page is public
                        await pageFollower.create({
                                pageId:pageId,
                                username: userUsername,
                        });
                        return res.status(200).json({
                            message: 'Followed',
                            body: req.body
                        });
                    }
                }
            }else{
                return res.status(404).json({
                    message: 'Page not found',
                    body: req.body
                });
            }
        } else {
            return res.status(404).json({
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
exports.removePageFollow = async (req, res, next) => {
    try {
        var pageId = req.body.pageId;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // 'decoded' now contains the user information (e.g., email, password)
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {//find if user exist
            var existingPage = await Page.findOne({
                where :{
                    id:pageId,
                }
            });
            if(existingPage != null){//find if Page exist
                var isUserFollowingPage = await pageFollower.findOne({
                    where:{
                        pageId:pageId,
                        username: userUsername,
                    }
                });
                if(isUserFollowingPage==null){//find if user is following the page
                    return res.status(500).json({
                        message: 'You are not following this page',
                        body: req.body
                    });
                }else{
                    if(existingPage.pageType == "public"){//if the page is public
                        await isUserFollowingPage.destroy();
                        return res.status(200).json({
                            message: 'Follow removed',
                            body: req.body
                        });
                    }
                }
            }else{
                return res.status(404).json({
                    message: 'Page not found',
                    body: req.body
                });
            }
        } else {
            return res.status(404).json({
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
