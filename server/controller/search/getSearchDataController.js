const User = require("../../models/user");
const { Op } = require('sequelize');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const Sequelize = require('sequelize');
const Page = require("../../models/pages");
const pageJobs = require("../../models/pageJobs");

exports.getSearchData = async (req, res, next) => {
    try {
        var search = req.query.search;
        var page = req.query.page || 1;
        var pageSize = req.query.pageSize || 10;
        var searchType = req.query.type;
        // Calculate the offset based on page and pageSize
        const offset = (page - 1) * pageSize;
        if (searchType == "U") {
            const result = await searchForUser(req.user.email, search, pageSize, offset);
            return res.status(result.statusCode).json(result.body);

        }
        else if (searchType == "P") {
            const result = await searchForPage(req.user.email, search, pageSize, offset);
            return res.status(result.statusCode).json(result.body);
        }
        else if (searchType == "J") {
            const result = await searchForJob(req.user.email, search, pageSize, offset);
            return res.status(result.statusCode).json(result.body);
        }
        return res.status(500).json({
            message: 'Server Error',
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Server Error',
        });
    }
};
async function searchForJob(email, search, pageSize, offset) {
    try {
        const existingEmail = await User.findOne({
            where: {
                email: email,
                status: null,
            },
        });

        if (existingEmail != null) {
            const pageJob = await pageJobs.findAll({
                attributes: [
                    'pageJobId',
                    'pageId',
                    'title',
                    'Fields',
                    'description',
                    'endDate',
                ],
                where: {
                    [Op.or]: [
                        { pageId: { [Op.like]: `%${search}%` } },
                        { title: { [Op.like]: `%${search}%` } },
                        { Fields: { [Op.like]: `%${search}%` } },
                        { description: { [Op.like]: `%${search}%` } },
                    ],
                },
                include: [{
                    model: Page,
                    attributes: ['country'], // Include the 'country' attribute from the 'pages' table
                }],
                order: [
                    // Order by user country match (descending endDate)
                    [Sequelize.literal(`CASE WHEN Page.country = '${existingEmail.country}' THEN 0 ELSE 1 END`)],
                    ['endDate', 'DESC'],
                ],
                limit: parseInt(pageSize),
                offset: parseInt(offset),
            });

            if (pageJob.length > 0) {
                return {
                    statusCode: 200,
                    body: {
                        message: 'jobs found',
                        jobs: pageJob,
                        totalCount: pageJob.length,
                    },
                };
            } else {
                // Handle case where no results are found
                return {
                    statusCode: 409,
                    body: {
                        message: 'No jobs found',
                        jobs: [],
                        totalCount: 0,
                    },
                };
            }
        } else {
            return {
                statusCode: 500,
                body: {
                    message: 'user not found',
                },
            };
        }
    } catch (err) {
        console.log(err)
        return {
            statusCode: 500,
            body: {
                message: 'Server Error',
            },
        };
    }
};
async function searchForPage(email, search, pageSize, offset) {
    try {
        const existingEmail = await User.findOne({
            where: {
                email: email,
                status: null,
            },
        });

        if (existingEmail != null) {
            if (search[0] == '@') {//search for ids only 
                var searchValue = search.substring(1);
                const searchResults = await Page.findAll({
                    attributes: [
                        'id',
                        'name',
                        'photo',
                    ],
                    where: {

                        id: {
                            [Op.or]: [
                                { [Op.eq]: searchValue }, // Exact match
                                { [Op.like]: `${searchValue}%` }, // Starts with the specified string
                            ],
                        },
                        pageType: "public",

                    },
                    limit: parseInt(pageSize),
                    offset: parseInt(offset),
                    order: [
                        // Order by exact match first, then by starts with
                        [Sequelize.literal(`CASE WHEN id = '${searchValue}' THEN 0 ELSE 1 END`)],
                        ['id'],
                    ],

                });
                if (searchResults.length > 0) {
                    console.log(searchResults)
                    return {
                        statusCode: 200,
                        body: {
                            message: 'Page found',
                            pages: searchResults,
                            totalCount: searchResults.length,
                        },
                    };

                } else {
                    // Handle case where no results are found
                    return {
                        statusCode: 200,
                        body: {
                            message: 'No Pages found',
                            pages: [],
                            totalCount: 0,
                        },
                    };
                }
            }
            const pages = await Page.findAll({
                attributes: [
                    'id',
                    'name',
                    'photo',
                ],
                where: {
                    [Op.or]: [
                        { id: { [Op.like]: `%${search}%` } },
                        { name: { [Op.like]: `%${search}%` } },
                    ],
                    pageType: "public",
                },
                limit: parseInt(pageSize),
                offset: parseInt(offset),
            });
            if (pages.length > 0) {
                return {
                    statusCode: 200,
                    body: {
                        message: 'pages found',
                        pages: pages,
                        totalCount: pages.length,
                    },
                };
            } else {
                // Handle case where no results are found
                return {
                    statusCode: 409,
                    body: {
                        message: 'No pages found',
                        pages: [],
                        totalCount: 0,
                    },
                };
            }
        } else {
            return {
                statusCode: 500,
                body: {
                    message: 'Server Error',
                },
            };
        }
    } catch (err) {
        return {
            statusCode: 500,
            body: {
                message: 'Server Error',
            },
        };
    }
}
async function searchForUser(email, search, pageSize, offset) {
    try {
        const existingEmail = await User.findOne({
            where: {
                email: email,
                status: null,
            },
        });

        if (existingEmail != null) {
            if (search[0] == '@') {//search for ids only 
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
                            {
                                status: null,
                            }
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
                    [Op.and]: [
                        {
                            [Op.or]: [
                                { firstname: { [Op.like]: `%${search.split(' ')[0]}%` } },
                                { lastname: { [Op.like]: `%${search.split(' ')[1]}%` } },
                                { username: { [Op.like]: `%${search.split(' ')[0]}%` } },
                            ],
                        },
                        {
                            status: null,
                        }
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
                },
            };
        }
    } catch (err) {
        return {
            statusCode: 500,
            body: {
                message: 'Server Error',
            },
        };
    }
}