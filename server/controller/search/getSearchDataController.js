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

        // Calculate the offset based on page and pageSize
        const offset = (page - 1) * pageSize;

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
                    console.log(searchResults);
                    return res.status(200).json({
                        message: 'User found',
                        users: searchResults,
                        totalCount: searchResults.length,
                    });
                } else {
                    // Handle case where no results are found
                    return res.status(200).json({
                        message: 'No users found',
                        users: [],
                        totalCount: 0,
                    });
                }
            }
            const users = await User.findAndCountAll({
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

            return res.status(200).json({
                message: 'User found',
                users: users.rows,
                totalCount: users.count,
            });
        } else {
            return res.status(500).json({
                message: 'Server Error',
                body: req.body,
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
            body: req.body,
        });
    }
};