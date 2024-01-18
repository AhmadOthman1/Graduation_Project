
const User = require("../../models/user");
const path = require('path');
const fs = require('fs');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const posts = require('../../models/post');


exports.postNewUserPost = async (req, res, next) => {
    try {
        const { postContent, selectedPrivacy, postImageBytes, postImageBytesName, postImageExt,postVideoBytes ,postVideoBytesName , postVideoExt } = req.body;
        var validselectedPrivacy = false;
        var validphoto = false;
        var newphotoname = null;
        var validvideo = false;
        var newvideoname = null;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername !=null) {
            if ((postContent == null || postContent.trim() == "") && (postImageBytes == null || postImageBytesName == null || postImageExt == null)) {
                return res.status(409).json({
                    message: 'you must add a text or photo to create a new post',
                    body: req.body
                });
            }
            if (postImageBytes != null && postImageBytesName != null && postImageExt != null) {//if feild change enables (!=null)
                validphoto = true;
            }
            if (postVideoBytes != null && postVideoBytesName != null && postVideoExt != null) {//if feild change enables (!=null)
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
                const photoBuffer = Buffer.from(postImageBytes, 'base64');
                const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
                newphotoname = userUsername + +"-" + uniqueSuffix + "." + postImageExt; // You can adjust the file extension based on the actual image type
                const uploadPath = path.join('images', newphotoname);

                // Save the image to the server
                fs.writeFileSync(uploadPath, photoBuffer);
                console.log("fff" + newphotoname);
                // Update the user record in the database with the new photo name
            }
            if (validvideo) {
                const videoBuffer = Buffer.from(postVideoBytes, 'base64');
                const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
                newvideoname = userUsername + +"-" + uniqueSuffix + "." + postVideoExt; // You can adjust the file extension based on the actual image type
                const uploadPath = path.join('videos', newvideoname);

                // Save the image to the server
                fs.writeFileSync(uploadPath, videoBuffer);
                console.log("fff" + newvideoname);
                // Update the user record in the database with the new photo name
            }
            const result = await posts.create({
                "username": userUsername,
                "postContent": postContent,
                "selectedPrivacy": selectedPrivacy,
                "photo":newphotoname,
                "video":newvideoname,
                "postDate":new Date(),

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