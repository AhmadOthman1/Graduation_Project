const User = require("../../../models/user");

const connections = require("../../../models/connections");
const { Op } = require('sequelize');
const sentConnection = require("../../../models/sentConnection");

exports.getConnections = async (req, res, next) => {
    var username = req.user.username;
    var userUsername = req.params;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var connection = await connections.findAll({
            where : {
                [Op.or]:{
                    senderUsername:userUsername,
                    receiverUsername:userUsername,
                }
            }
        });
        return res.status(200).json({
            message: 'users',
            connection: connection,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
exports.getSentConnections = async (req, res, next) => {
    var username = req.user.username;
    var userUsername = req.params;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var connection = await sentConnection.findAll({
            where : {
                [Op.or]:{
                    senderUsername:userUsername,
                    receiverUsername:userUsername,
                }
            }
        });
        return res.status(200).json({
            message: 'users',
            connection: connection,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}