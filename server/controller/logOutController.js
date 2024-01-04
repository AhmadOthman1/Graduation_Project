const User = require("../models/user");
const validator = require('./validator');
const bcrypt = require('bcrypt');
require('dotenv').config();
const jwt = require('jsonwebtoken');
const activeUsers = require('../models/activeUsers');


exports.postLogOut = async (req, res, next) => {
    const authHeader = req.headers['authorization']
    const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
    var userUsername = decoded.username;
    const existingUsername = await User.findOne({
        where: {
            username: userUsername
        },
    });
    if (existingUsername!=null) {
        await User.update({ token: null }, {
            where: {
              username: userUsername
            }
          })        
          var activeUser = await activeUsers.findOne({
            where: {
            username: userUsername,
            }
          });
          if(activeUser!=null){
            await activeUser.destroy({
              where: {
                username: userUsername,
              },
            });

          }
          
          return res.status(200).json({
            message: 'logged out',
            body: req.body
        });
    } else {
        return res.status(409).json({
            message: 'Email not exists',
            body: req.body
        });
    }
 }