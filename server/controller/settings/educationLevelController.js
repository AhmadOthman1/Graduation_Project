const User = require("../../models/user");
const EducationLevel = require("../../models/educationLevel");
const { Op } = require('sequelize');
const validator = require('../validator');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer')
const multer = require('multer');
const path = require('path');
const fs = require('fs');


exports.getEducationLevel= async (req, res, next) => {
    try {
        var email = req.query.email;
        const existingEmail = await User.findOne({
            where: {
                email: req.user.email,
            },
            include: EducationLevel,
        });

        if (existingEmail !=null) {
            console.log(existingEmail.educationLevels);
            const educationLevel = existingEmail.educationLevels.map((Level) => ({
                'id': Level.id.toString(),
                'Specialty': Level.specialty,
                'School': Level.School,
                'Description': Level.description,
                'Start Date': Level.startDate.toISOString().split("T")[0],
                'End Date': (Level.endDate) ? Level.endDate.toISOString().split("T")[0] : 'Present', // Handle the case where endDate is null
            }));
            return res.status(200).json({
                message: 'User found',
                educationLevel: educationLevel,
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
exports.postAddEducationLevel = async (req, res, next) => {
    try {

        const { email, Specialty, School, Description, StartDate, EndDate } = req.body;
        var validSpecialty = false;
        var validSchool = false;
        var validDescription = false;
        var validStartDate = false;
        var validEndDate = false;
        const existingEmail = await User.findOne({
            where: {
                email: req.user.email
            },
        });
        if (existingEmail !=null) {
            if (Specialty != null) {//if feild change enables (!=null)
                if (Specialty.length < 1 || Specialty.length > 250) {//validate
                    return res.status(409).json({
                        message: 'Not Valid Specialty',
                        body: req.body
                    });
                } else {//change
                    validSpecialty = true;
                }
            }
            if (School != null) {//if feild change enables (!=null)
                if (School.length < 1 || School.length > 250) {//validate
                    return res.status(409).json({
                        message: 'Not Valid School',
                        body: req.body
                    });
                } else {//change
                    validSchool = true;
                }
            }
            if (Description != null) {//if feild change enables (!=null)
                if (Description.length < 1 || Description.length > 2000) {//validate
                    return res.status(409).json({
                        message: 'Not Valid Description',
                        body: req.body
                    });
                } else {//change
                    validDescription = true;
                }
            }
            if (StartDate != null) {//if feild change enables (!=null)
                if (!validator.isDate(StartDate) || StartDate.length < 8 || StartDate.length > 10) {//validate
                    return res.status(409).json({
                        message: 'Not Valid StartDate',
                        body: req.body
                    });
                } else {//change
                    validStartDate = true;
                }
            }
            console.log(EndDate != null)
            if (EndDate) {//if feild change enables (!=null)
                if (!validator.isDate(EndDate) || EndDate.length < 8 || EndDate.length > 10) {//validate
                    return res.status(409).json({
                        message: 'Not Valid EndDate',
                        body: req.body
                    });
                } else {//change
                    validEndDate = true;
                }
            } else {
                validEndDate = true;
            }
            // save changes
            
            if (validSpecialty && validSchool && validDescription && validStartDate && validEndDate) {
                //{ email, Specialty, Company, Description, StartDate, EndDate
                const newEducationLevelData = {
                    username: existingEmail.username,
                    specialty: Specialty,
                    School: School,
                    description: Description,
                    startDate: StartDate,
                    endDate: (EndDate) ? EndDate : null,
                };
                //return the id
                EducationLevel.create(newEducationLevelData).then((educationLevels) => {
                    return res.status(200).json({
                        message: educationLevels.id,
                        body: req.body
                    });
                }).catch((error) => {
                    console.error('Error adding work experience:', error);
                });
            }
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

exports.postEditEducationLevel = async (req, res, next) => {
    try {

        const { email, id, Specialty, School, Description, StartDate, EndDate } = req.body;
        var validSpecialty = false;
        var validSchool = false;
        var validDescription = false;
        var validStartDate = false;
        var validEndDate = false;
        const existingEmail = await User.findOne({
            where: {
                email: req.user.email
            },
        });
        if (existingEmail !=null) {
            
            if (Specialty != null && Specialty != "") {//if feild change enables (!=null)
                if (Specialty.length < 1 || Specialty.length > 250) {//validate
                    return res.status(409).json({
                        message: 'Not Valid Specialty',
                        body: req.body
                    });
                } else {//change
                    validSpecialty = true;
                }
            }

            if (School != null && School != "") {//if feild change enables (!=null)
                if (School.length < 1 || School.length > 250) {//validate
                    return res.status(409).json({
                        message: 'Not Valid Company',
                        body: req.body
                    });
                } else {//change
                    validSchool = true;
                }
            }

            if (Description != null && Description != "") {//if feild change enables (!=null)
                if (Description.length < 1 || Description.length > 2000) {//validate
                    return res.status(409).json({
                        message: 'Not Valid Description',
                        body: req.body
                    });
                } else {//change
                    validDescription = true;
                }
            }
            if (StartDate != null && StartDate != "") {//if feild change enables (!=null)
                if (!validator.isDate(StartDate) || StartDate.length < 8 || StartDate.length > 10) {//validate
                    return res.status(409).json({
                        message: 'Not Valid StartDate',
                        body: req.body
                    });
                } else {//change
                    validStartDate = true;
                }
            }
            if (EndDate) {//if feild change enables (!=null)
                if (!validator.isDate(EndDate) || EndDate.length < 8 || EndDate.length > 10) {//validate
                    return res.status(409).json({
                        message: 'Not Valid EndDate',
                        body: req.body
                    });
                } else {//change
                    validEndDate = true;
                }
            } else {
                validEndDate = true;
            }
            // save changes
            console.log(existingEmail.username);
            if (validSpecialty && validSchool && validDescription && validStartDate && validEndDate) {
                //{ email, Specialty, Company, Description, StartDate, EndDate
                const updatedEducationLevelData = {
                    specialty: Specialty,
                    School: School,
                    description: Description,
                    startDate: StartDate,
                    endDate: (EndDate) ? EndDate : null,
                };
                console.log(updatedEducationLevelData);
                //return the id
                EducationLevel.update(updatedEducationLevelData, {
                    where: { id: id, username: existingEmail.username },
                }).then((educationLevels) => {
                    return res.status(200).json({
                        message: educationLevels.id,
                        body: req.body
                    });
                }).catch((error) => {
                    console.error('Error adding work experience:', error);
                    return res.status(409).json({
                        message: "server error",
                        body: req.body
                    });
                });
            }
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

exports.postDeleteEducationLevel = async (req, res, next) => {
    try {

        const { email, id } = req.body;
        const existingEmail = await User.findOne({
            where: {
                email: req.user.email
            },
        });
        if (existingEmail !=null) {
            EducationLevel.destroy({
                where: {
                    id: id,
                    username: existingEmail.username,
                },
            })
            return res.status(200).json({
                message: "deleted",
                body: req.body
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