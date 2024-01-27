const User = require("../../../models/user");
const like = require("../../../models/like");
const post = require("../../../models/post");
const postHistory = require("../../../models/postHistory");


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
        });
        return res.status(200).json({
            message: 'Posts',
            Posts: Posts,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.postHistory = async (req, res, next) => {
    const { postId } = req.params;
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
            where:{
                postId:postId
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