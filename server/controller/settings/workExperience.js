const User = require("../../models/user");
const WorkExperience = require("../../models/workExperience");
const { Op } = require('sequelize');
const validator = require('../validator');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer')
const multer = require('multer');
const path = require('path');
const fs = require('fs');


exports.getWorkExperience = async (req, res, next) => {
    try {
        var email = req.query.email;
        const existingEmail = await User.findOne({
            where: {
                email: email,
            },
            include: WorkExperience,
        });

        if (existingEmail) {
            console.log(existingEmail.workExperiences[0].specialty);
            const workExperiences = existingEmail.workExperiences.map((experience) => ({
                'Specialty': experience.specialty,
                'Company': experience.company,
                'Description': experience.description,
                'Start Date': experience.startDate,
                'End Date': experience.endDate || '', // Handle the case where endDate is null
            }));

            return res.status(200).json({
                message: 'User found',
                workExperiences: workExperiences,
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