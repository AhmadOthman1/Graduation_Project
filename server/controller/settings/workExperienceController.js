const User = require("../../models/user");
const WorkExperience = require("../../models/workExperience");
const { Op } = require('sequelize');
const validator = require('../validator');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer')
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const pageEmployees = require("../../models/pageEmployees");
const pageAdmin = require("../../models/pageAdmin");


exports.getWorkExperience = async (req, res, next) => {
    try {
        var email = req.user.email;
        const existingEmail = await User.findOne({
            where: {
                email: email,
                status:null,
            },
            include: WorkExperience,
        });

        if (existingEmail !=null) {
            const workExperiences = await Promise.all(existingEmail.workExperiences.map(async (experience) => {
                const isEmployee = await pageEmployees.findOne({
                    where: {
                        pageId: experience.company,
                        username: req.user.username,
                        field: experience.specialty,
                    }
                });
                const isAdmin = await pageAdmin.findOne({
                    where: {
                        pageId: experience.company,
                        username: req.user.username,
                        adminType: "A",
                    }
                });
                console.log(isAdmin)
                return {
                    'id': experience.id.toString(),
                    'Specialty': experience.specialty,
                    'Company': experience.company,
                    'Description': experience.description,
                    'Start Date': experience.startDate.toISOString().split("T")[0],
                    'End Date': (experience.endDate) ? experience.endDate.toISOString().split("T")[0] : 'Present',
                    'isEmployee': isEmployee == null ? (isAdmin==null? "false" : "true" ): "true",
                };
            }));
            console.log(workExperiences)
            return res.status(200).json({
                message: 'User found',
                workExperiences: workExperiences,
            });
            /*
            console.log(existingEmail);
            const workExperiences = existingEmail.workExperiences.map((experience) => ({

                'id': experience.id.toString(),
                'Specialty': experience.specialty,
                'Company': experience.company,
                'Description': experience.description,
                'Start Date': experience.startDate.toISOString().split("T")[0],
                'End Date': (experience.endDate) ? experience.endDate.toISOString().split("T")[0] : 'Present', // Handle the case where endDate is null
            }));

            return res.status(200).json({
                message: 'User found',
                workExperiences: workExperiences,
            });*/
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
exports.postAddworkExperience = async (req, res, next) => {
    try {

        const { email, Specialty, Company, Description, StartDate, EndDate } = req.body;
        var validSpecialty = false;
        var validCompany = false;
        var validDescription = false;
        var validStartDate = false;
        var validEndDate = false;
        const existingEmail = await User.findOne({
            where: {
                email: req.user.email,
                status:null,
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
            if (Company != null) {//if feild change enables (!=null)
                if (Company.length < 1 || Company.length > 250) {//validate
                    return res.status(409).json({
                        message: 'Not Valid Company',
                        body: req.body
                    });
                } else {//change
                    validCompany = true;
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

            if (validSpecialty && validCompany && validDescription && validStartDate && validEndDate) {
                //{ email, Specialty, Company, Description, StartDate, EndDate
                const newWorkExperienceData = {
                    username: existingEmail.username,
                    specialty: Specialty,
                    company: Company,
                    description: Description,
                    startDate: StartDate,
                    endDate: (EndDate) ? EndDate : null,
                };
                //return the id
                WorkExperience.create(newWorkExperienceData).then((workExperience) => {
                    return res.status(200).json({
                        message: workExperience.id,
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

exports.postEditworkExperience = async (req, res, next) => {
    try {

        const { email, id, Specialty, Company, Description, StartDate, EndDate } = req.body;
        var validSpecialty = false;
        var validCompany = false;
        var validDescription = false;
        var validStartDate = false;
        var validEndDate = false;
        const existingEmail = await User.findOne({
            where: {
                email: req.user.email,
                status:null,
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

            if (Company != null && Company != "") {//if feild change enables (!=null)
                if (Company.length < 1 || Company.length > 250) {//validate
                    return res.status(409).json({
                        message: 'Not Valid Company',
                        body: req.body
                    });
                } else {//change
                    validCompany = true;
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

            if (validSpecialty && validCompany && validDescription && validStartDate && validEndDate) {
                //{ email, Specialty, Company, Description, StartDate, EndDate
                const updatedWorkExperienceData = {
                    specialty: Specialty,
                    company: Company,
                    description: Description,
                    startDate: StartDate,
                    endDate: (EndDate) ? EndDate : null,
                };
                //return the id
                WorkExperience.update(updatedWorkExperienceData, {
                    where: { id: id, username: existingEmail.username },
                }).then((workExperience) => {
                    return res.status(200).json({
                        message: workExperience.id,
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

exports.postDeleteworkExperience = async (req, res, next) => {
    try {

        const { email, id } = req.body;
        const existingEmail = await User.findOne({
            where: {
                email: req.user.email,
                status:null,
            },
        });
        if (existingEmail !=null) {
            WorkExperience.destroy({
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