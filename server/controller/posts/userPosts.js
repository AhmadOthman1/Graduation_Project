
const User = require("../../models/user");
const path = require('path');
const fs = require('fs');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const posts = require('../../models/post');
const postPhotos = require('../../models/postPhotos');
const postVideos = require('../../models/postVideos');


exports.postNewUserPost = async (req, res, next) => {//postImageBytes, postImageBytesName, postImageExt,postVideoBytes ,postVideoBytesName , postVideoExt
    try {
        const { postContent, selectedPrivacy, videoList, imageList } = req.body;
        var validselectedPrivacy = false;
        var validphoto = false;
        var newphotonames = [];
        var validvideo = false;
        var newvideonames = [];
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername,
                status: null,
            },
        });
        if (existingUsername != null) {
            if ((postContent == null || postContent.trim() == "") && (videoList == undefined || videoList.length == 0) && (imageList == undefined || imageList.length == 0)) {
                return res.status(409).json({
                    message: 'you must add a text or photo to create a new post',
                    body: req.body
                });
            }
            if (imageList !== undefined ||imageList !== null || imageList.length != 0) {//if feild change enables (!=null)
                validphoto = true;
            }
            if (videoList !== undefined ||videoList !== null || videoList.length != 0) {//if feild change enables (!=null)
                validvideo = true;
            }
            if (!selectedPrivacy && (selectedPrivacy == "Any One" || selectedPrivacy == "Connections")) {
                validselectedPrivacy = true;
            }
            // save changes
            if (!validselectedPrivacy) {
                selectedPrivacy == "Any One";
            }
            if (validphoto) {
                for (const photo of imageList) {
                    if (photo.postImageBytes != null && photo.postImageBytesName != null && photo.postImageExt != null) {
                        const photoBuffer = Buffer.from(photo.postImageBytes, 'base64');
                        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
                        var newphotoname = userUsername + +"-" + uniqueSuffix + "." + photo.postImageExt; // You can adjust the file extension based on the actual image type
                        const uploadPath = path.join('images', newphotoname);
                        newphotonames.push(newphotoname);
                        // Save the image to the server
                        fs.writeFileSync(uploadPath, photoBuffer);
                        console.log("fff" + newphotoname);
                        // Update the user record in the database with the new photo name
                    }
                }
            }
            if (validvideo) {
                for (const video of videoList) {
                    if (video.postVideoBytes != null && video.postVideoBytesName != null && video.postVideoExt != null) {
                        const videoBuffer = Buffer.from(video.postVideoBytes, 'base64');
                        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
                        var newvideoname = userUsername + +"-" + uniqueSuffix + "." + video.postVideoExt; // You can adjust the file extension based on the actual image type
                        const uploadPath = path.join('videos', newvideoname);
                        newvideonames.push(newvideoname);
                        // Save the image to the server
                        fs.writeFileSync(uploadPath, videoBuffer);
                        console.log("fff" + newvideoname);
                        // Update the user record in the database with the new photo name
                    }
                }
            }
            const result = await posts.create({
                "username": userUsername,
                "postContent": postContent,
                "selectedPrivacy": selectedPrivacy,
                "postDate": new Date(),

            });
            for(const photo of newphotonames){
                await postPhotos.create({
                    postId:result.id,
                    photo:photo,
                })
            }
            for(const video of newvideonames){
                await postVideos.create({
                    postId:result.id,
                    video:video,
                })
            }
            res.status(200).json({
                message: "created sucsessfully",
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