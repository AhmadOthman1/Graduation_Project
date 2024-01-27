const User = require("../../../models/user");
const comment = require("../../../models/comment");


exports.getComments = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var comments = await comment.findAll({
        });
        return res.status(200).json({
            message: 'comments',
            comments: comments,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getPostComments = async (req, res, next) => {
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
        var comments = await comment.findAll({
            where:{
                postId:postId
            }
        });
        return res.status(200).json({
            message: 'comments',
            comments: comments,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.deleteComment = async (req, res, next) => {
    var username = req.user.username;
    const commentId  = req.params;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var Comment = await comment.findOne({
            where:{
                id:commentId,
            }
        });
        if(Comment != null){
            Comment.destroy();
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