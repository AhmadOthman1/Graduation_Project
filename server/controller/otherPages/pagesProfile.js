const User = require("../../models/user");
const Connections = require("../../models/connections");
const sentConnection = require("../../models/sentConnection");
const WorkExperience = require("../../models/workExperience");
const EducationLevel = require("../../models/educationLevel");
const { notifyUser, deleteNotificaion } = require("../notifications");
const post = require('../../models/post');
const Page = require("../../models/pages");
const pageFollower = require("../../models/pageFollower");
const pageAdmin = require("../../models/pageAdmin");
const pageJobs = require("../../models/pageJobs");
const jobApplication = require("../../models/jobApplication");
const jwt = require('jsonwebtoken');
require('dotenv').config();
const { Op } = require('sequelize');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const Sequelize = require('sequelize');
const pageEmployees = require("../../models/pageEmployees");

async function findIfUserInFollowers(userUsername, findPageProfile) {
    const userConnections = await pageFollower.findOne({
        where: {
            pageId: findPageProfile,
            username: userUsername
        }
    });
    if (userConnections != null) {
        return true
    } else {
        return false;
    }
}
exports.getPageProfileInfo = async (req, res, next) => {
    try {
        var findPageProfile = req.query.pageId;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // 'decoded' now contains the user information (e.g., email, password)
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {

            const pageProfile = await Page.findOne({
                where: {
                    id: findPageProfile
                },
            });
            if (pageProfile != null) {// if page is found 
                var following = "N";
                var photo;
                var coverimage;
                //check page photo
                if (pageProfile.photo == null) {
                    photo = null;
                } else {
                    const photoFilePath = path.join('images', pageProfile.photo);
                    // Check if the file exists
                    try {
                        await fs.promises.access(photoFilePath, fs.constants.F_OK);
                        photo = pageProfile.photo;
                    } catch (err) {
                        console.error(err);
                        photo = null;
                        await User.update({ photo: photo }, { where: { email } });
                    }

                }
                //check page cover image
                if (pageProfile.coverImage == null) {
                    coverimage = null;
                } else {
                    const coverImageFilePath = await path.join('images', pageProfile.coverImage);
                    // Check if the file exists
                    try {
                        await fs.promises.access(coverImageFilePath, fs.constants.F_OK);
                        coverimage = pageProfile.coverImage;

                    } catch (err) {
                        console.error(err);
                        coverimage = null;
                        await User.update({ coverImage: coverimage }, { where: { email } });
                    }

                }


                var pageUserAdmin = await pageAdmin.findOne({
                    where: {
                        pageId: findPageProfile,
                        username: userUsername
                    }
                });
                if (pageUserAdmin != null) {
                    const [postCount, followCount] = await Promise.all([
                        post.count({ where: { pageId: pageProfile.id } }),
                        pageFollower.count({ where: { pageId: pageProfile.id } }),
                    ]);
                    console.log(pageProfile)
                    return res.status(200).json({
                        message: 'Page found',
                        Page: {
                            isAdmin: true,
                            id: pageProfile.id,
                            name: pageProfile.name,
                            description: pageProfile.description,
                            country: pageProfile.country,
                            address: pageProfile.address,
                            contactInfo: pageProfile.contactInfo,
                            specialty: pageProfile.specialty,
                            pageType: pageProfile.pageType,
                            photo: photo,
                            coverImage: coverimage,
                            postCount: postCount.toString(),
                            followCount: followCount.toString(),
                        }
                    });
                } else {
                    if (pageProfile.pageType == "public") {
                        var userIsFollower = await findIfUserInFollowers(userUsername, findPageProfile);
                        if (userIsFollower) { // check if user is follower to other page
                            following = "F";
                        }
                        const followersCount = await pageFollower.count({
                            where: {
                                pageId: findPageProfile
                            },
                        });
                        const postsCount = await post.count({
                            where: { pageId: findPageProfile },
                        });
                        return res.status(200).json({
                            message: 'Page found',
                            Page: {
                                isAdmin: false,
                                id: pageProfile.id,
                                name: pageProfile.name,
                                description: pageProfile.description,
                                country: pageProfile.country,
                                address: pageProfile.address,
                                contactInfo: pageProfile.contactInfo,
                                specialty: pageProfile.specialty,
                                pageType: pageProfile.pageType,
                                photo: photo,
                                coverImage: coverimage,
                                following: following,
                                followCount: followersCount.toString(),
                                postCount: postsCount.toString(),
                            },
                        });
                    } else {
                        return res.status(500).json({
                            message: 'you are not allowed to see this page',
                            body: req.body
                        });
                    }
                }

            } else {
                return res.status(404).json({
                    message: 'Page not found',
                    body: req.body
                });
            }

        } else {
            return res.status(404).json({
                message: 'user not found',
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
exports.followPage = async (req, res, next) => {
    try {

        var pageId = req.body.pageId;
        console.log(pageId)
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // 'decoded' now contains the user information (e.g., email, password)
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {//find if user exist
            var existingPage = await Page.findOne({
                where: {
                    id: pageId,
                }
            });

            if (existingPage != null) {//find if Page exist
                var isUserFollowingPage = await pageFollower.findOne({
                    where: {
                        pageId: pageId,
                        username: userUsername,
                    }
                });
                if (isUserFollowingPage != null) {//find if user is following the page
                    return res.status(500).json({
                        message: 'You are already following this page',
                        body: req.body
                    });
                } else {
                    if (existingPage.pageType == "public") {//if the page is public
                        await pageFollower.create({
                            pageId: pageId,
                            username: userUsername,
                        });
                        return res.status(200).json({
                            message: 'Followed',
                            body: req.body
                        });
                    }
                }
            } else {
                return res.status(404).json({
                    message: 'Page not found',
                    body: req.body
                });
            }
        } else {
            return res.status(404).json({
                message: 'user not found',
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
exports.removePageFollow = async (req, res, next) => {
    try {
        var pageId = req.body.pageId;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // 'decoded' now contains the user information (e.g., email, password)
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {//find if user exist
            var existingPage = await Page.findOne({
                where: {
                    id: pageId,
                }
            });
            if (existingPage != null) {//find if Page exist
                var isUserFollowingPage = await pageFollower.findOne({
                    where: {
                        pageId: pageId,
                        username: userUsername,
                    }
                });
                if (isUserFollowingPage == null) {//find if user is following the page
                    return res.status(500).json({
                        message: 'You are not following this page',
                        body: req.body
                    });
                } else {
                    if (existingPage.pageType == "public") {//if the page is public
                        await isUserFollowingPage.destroy();
                        return res.status(200).json({
                            message: 'Follow removed',
                            body: req.body
                        });
                    }
                }
            } else {
                return res.status(404).json({
                    message: 'Page not found',
                    body: req.body
                });
            }
        } else {
            return res.status(404).json({
                message: 'user not found',
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
exports.getJobs = async (req, res, next) => {
    try {
        var page = req.query.page || 1;
        var pageSize = req.query.pageSize || 10;
        var pageId = req.query.pageId;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // Calculate the offset based on page and pageSize
        const offset = (page - 1) * pageSize;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            const finsPage = Page.findOne({
                where: {
                    id: pageId
                }
            })
            if (finsPage != null) {
                const allPageJobs = await pageJobs.findAll({
                    where: {
                        pageId: pageId,
                    },
                    limit: parseInt(pageSize),
                    offset: parseInt(offset),
                    order: [['endDate', 'DESC']],
                });

                return res.status(200).json({
                    pageJobs: allPageJobs,
                });
            } else {
                return res.status(404).json({
                    message: 'Page not found',
                    body: req.body,
                });
            }


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
exports.saveJobApplication = async (req, res, next) => {
    try {
        const { jobId, cvBytes, cvName, cvExt, notice } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // Calculate the offset based on page and pageSize
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        console.log(jobId)
        if (existingUsername != null) {
            const job = await pageJobs.findOne({
                where: {
                    pageJobId: jobId
                }
            })
            if (job != null) {
                console.log(job)
                const isAdmin = await pageAdmin.findOne({
                    where: {
                        username: userUsername,
                        pageId: job.pageId,
                    }
                })
                if (isAdmin == null) {
                    const isEmployee = await pageEmployees.findOne({
                        where: {
                            username: userUsername,
                            pageId: job.pageId,
                        }
                    });
                    if (isEmployee == null) {
                        const isAlreadyApplied = await jobApplication.findOne({
                            where: {
                                username: userUsername,
                                pageJobId: jobId,
                            }
                        });
                        if (isAlreadyApplied == null) {
                            const currentDate = new Date();

                            if (job.endDate < currentDate) { 
                                return res.status(500).json({
                                    message: 'Application for this job has ended',
                                    body: req.body,
                                });
                            }
                            var validcv = false;
                            if (cvBytes != null && cvName != null && cvExt != null) {//if feild change enables (!=null)
                                validcv = true;
                            }
                            var newPdfName;
                            if (validcv) {
                                const pdfBuffer = Buffer.from(cvBytes, 'base64');
                                const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
                                newPdfName = userUsername + '-' + uniqueSuffix + '.pdf';
                                const uploadPath = path.join('cvs', newPdfName); // Update the folder path as needed

                                // Save the PDF to the server
                                fs.writeFileSync(uploadPath, pdfBuffer);

                            }
                            await jobApplication.create({
                                pageJobId: jobId,
                                username: userUsername,
                                note: notice,
                                cv: newPdfName,
                            })
                            return res.status(500).json({
                                message: 'Your job application have been submitted successfully',
                                body: req.body,
                            });
                        } else {
                            return res.status(500).json({
                                message: 'You have been already applied for this job',
                                body: req.body,
                            });
                        }

                    } else {
                        return res.status(500).json({
                            message: 'You are Employee in this page',
                            body: req.body,
                        });
                    }
                } else {
                    return res.status(500).json({
                        message: 'You are admin in this page',
                        body: req.body,
                    });
                }
            } else {
                return res.status(404).json({
                    message: 'job not found',
                    body: req.body,
                });
            }


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
exports.getOneJob = async (req, res, next) => {
    try {
        const jobId = req.query.jobId;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        // Calculate the offset based on page and pageSize
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            const onePageJob = await pageJobs.findOne({
                where: {
                    pageJobId: jobId,
                },
                include: [
                    {
                        model: Page,
                        order: [['id', 'photo']],
                    },
                ],
            });
            if (onePageJob != null) {
                return res.status(200).json({
                    job: onePageJob,
                });
            } else {
                return res.status(404).json({
                    message: 'job not found',
                    body: req.body,
                });
            }




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