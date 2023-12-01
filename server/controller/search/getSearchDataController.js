const User = require("../../models/user");
const { Op } = require('sequelize');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const Sequelize = require('sequelize');

exports.getSearchData = async (req, res, next) => {
    try {
        var email = req.query.email;
        var search = req.query.search;
        var page = req.query.page || 1;
        var pageSize = req.query.pageSize || 10;
        var searchType = req.query.type;
        // Calculate the offset based on page and pageSize
        const offset = (page - 1) * pageSize;
        if(searchType=="U"){
            const result = await searchForUser(email, search, pageSize, offset);
            return res.status(result.statusCode).json(result.body);
            
        }
        else if(searchType=="P"){

        }
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    }
};
async function searchForUser(email,search,pageSize,offset){
    try{
        const existingEmail = await User.findOne({
            where: {
                email: email,
            },
        });

        if (existingEmail) {
            if (search[0] == '@') {
                var searchValue = search.substring(1);
                const searchResults = await User.findAll({
                    attributes: [
                        'firstname',
                        'lastname',
                        'username',
                        'photo',
                    ],
                    where: {
                        [Op.and]: [
                            {
                                username: {
                                    [Op.or]: [
                                        { [Op.eq]: searchValue }, // Exact match
                                        { [Op.like]: `${searchValue}%` }, // Starts with the specified string
                                    ],
                                },
                            },
                            {
                                email: {
                                    [Op.ne]: email, // Exclude the user himself
                                },
                            },
                        ],
                    },
                    limit: parseInt(pageSize),
                    offset: parseInt(offset),
                    order: [
                        // Order by exact match first, then by starts with
                        [Sequelize.literal(`CASE WHEN username = '${searchValue}' THEN 0 ELSE 1 END`)],
                        ['username'],
                    ],

                });
                if (searchResults.length > 0) {
                    return {
                        statusCode: 200,
                        body: {
                            message: 'User found',
                            users: searchResults,
                            totalCount: searchResults.length,
                        },
                    };
                    
                } else {
                    // Handle case where no results are found
                    return {
                        statusCode: 200,
                        body: {
                            message: 'No users found',
                            users: [],
                            totalCount: 0,
                        },
                    };
                }
            }
            const users = await User.findAll({
                attributes: [
                    'firstname',
                    'lastname',
                    'username',
                    'photo',
                ],
                where: {
                    [Op.or]: [
                        { firstname: { [Op.like]: `%${search}%` } },
                        { lastname: { [Op.like]: `%${search}%` } },
                        { username: { [Op.like]: `%${search}%` } },
                    ],
                },
                limit: parseInt(pageSize),
                offset: parseInt(offset),
            });
            if (users.length > 0) {
                return {
                    statusCode: 200,
                    body: {
                        message: 'User found',
                        users: users,
                        totalCount: users.length,
                    },
                };
            } else {
                // Handle case where no results are found
                return {
                    statusCode: 409,
                    body: {
                        message: 'No users found',
                        users: [],
                        totalCount: 0,
                    },
                };
            }
        } else {
            return {
                statusCode: 500,
                body: {
                    message: 'Server Error',
                    body: req.body,
                },
            };
        }
    }catch(err){
        return {
            statusCode: 500,
            body: {
                message: 'Server Error',
                body: req.body,
            },
        };
    }
}