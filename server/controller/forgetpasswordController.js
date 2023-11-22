const User = require("../models/user");
const forgetPasswordCode = require("../models/forgetPasswordCode");
const tempUser = require("../models/tempUser");
const { Op } = require('sequelize');
const validator = require('./validator');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer')




exports.changePassword=async (req,res,next)=>{
    try{
    const { email , password} = req.body;
    const existingUserInforgetPasswordCode  = await forgetPasswordCode.findOne({
        where: {
            email: email 
    }});
    //if exists 
    if (existingUserInforgetPasswordCode) {
        const hashedPassword = await bcrypt.hash(password, 10);
        const result = await User.update(
            { password: hashedPassword },
            {
              where: { email: email },
            }
          );
          await existingUserInforgetPasswordCode.destroy();
          return res.status(200).json({
            body :req.body
          });
      } else {
        return res.status(409).json({
            message: 'Not Valid email',
            body :req.body
          });
      }
    }catch(err){
        console.log(err);
        return res.status(409).json({
            message: 'server error',
            body :req.body
          });
    }
}
exports.postVerificationCode=async (req,res,next)=>{
    try{

        const { verificationCode , email} = req.body;//get data from req
        //find the user by email in tempuser table
        const existingUserInforgetPasswordCode  = await forgetPasswordCode.findOne({
            where: {
                email: email 
        }});
        //if exists 
        if (existingUserInforgetPasswordCode) {
            const storedVerificationCode = existingUserInforgetPasswordCode.code;// get the hashed code from the thable
            //compare
            if(verificationCode == storedVerificationCode){
                  //await existingUserInforgetPasswordCode.destroy(); ==> we will not destroy the code from here for securty 
                  return res.status(200).json({
                    body :req.body
                  });
            }
            else{
                return res.status(409).json({
                    message: 'Not Valid code',
                    body :req.body
                  });
            }
        
            
          } else {
            
            return res.status(409).json({
                message: 'Not Valid email',
                body :req.body
              });
          }




    }catch(err){
        console.log(err);
        return res.status(409).json({
            message: 'server error',
            body :req.body
          });
    }
}

exports.postForgetPassword=async (req,res,next)=>{
    //check for valid email
    const { email } = req.body;
    if (!email) {
        return res.status(409).json({
            message: 'email field is empty',
            body :req.body
          });
      }
      if(!validator.isEmail(email)|| email.length < 12 ||email.length > 100){
        return res.status(409).json({
            message: 'Not Valid email',
            body :req.body
          });
    }
    //check if existed in database
    try{
        const existingEmail = await User.findOne({
            where: {
                    email: email 
                },
            });
        if (existingEmail) {
            // mail  exists
            //check if there is a pre code
            const existingEmailInForget = await forgetPasswordCode.findOne({
                where: {
                        email: email 
                    },
                });
            //delete code if existed
            if(existingEmailInForget){
                await existingEmailInForget.destroy();
            }
            //create new code
            var VerificationCode = Math.floor(10000 + Math.random() * 90000);
            //send the code
            await sendVerificationCode(email, VerificationCode);
            //create it in the datebase
            const newforgetPasswordCode = await forgetPasswordCode.create({
                email: existingEmail.email,
                code:VerificationCode,
            });
            return res.status(200).json({
                message: email,
                body :req.body
            });
            
        }else{
            return res.status(409).json({
                message: 'Email not exists',
                body :req.body
                });
        }
    }catch(err){
        console.log(err);
        return res.status(409).json({
            message: 'error from server',
            body :req.body
            });
    }
}
async function sendVerificationCode(email, code) {
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
        user: 'growifygp2@gmail.com',
        pass: 'zglg aoic kdiz gjwf',//growifygp2$P2
        },
    });
    
      const mailOptions = {
        from: 'growifygp2@gmail.com',
        to: email,
        subject: 'Growify Verification Code',
        text: `Your verification code is: ${code} and its valid unless you close the app`,
      };
    
      
      try {
        // Send the email
        const info = await transporter.sendMail(mailOptions);
      } catch (error) {
        
        console.error('Error sending email:', error);
        return res.status(500).json({
            message: 'email not found',
            body: req.body
            });
      }
    
  }