const User = require("../../../models/user");
const like = require("../../../models/like");


exports.getLikes = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var likes = await like.findAll({
        });
        return res.status(200).json({
            message: 'likes',
            likes: likes,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getPostLikes = async (req, res, next) => {
    var username = req.user.username;
    const  postId  = req.params;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var likes = await like.findAll({
            where:{
                postId:postId
            }
        });
        return res.status(200).json({
            message: 'likes',
            likes: likes,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.deleteLike = async (req, res, next) => {
    var username = req.user.username;
    const  likeId  = req.params;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var Like = await like.findOne({
            where:{
                id:likeId,
            }
        });
        if(Like != null){
            Like.destroy();
        }
        return res.status(200).json({
            message: 'deleted',
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}