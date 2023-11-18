const User = require("../models/user");
const tempUser = require("../models/tempUser");
const { Op } = require('sequelize');
const validator = require('./validator');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer')
const moment = require('moment');




exports.getPosts=(req,res,next)=>{
    console.log("fgdfg");
    res.status(200).json({posts:[{title:"first post",content:"this is hte content"}]})
};
exports.postVerificationCode=async (req,res,next)=>{
    try{

        const { verificationCode , email} = req.body;//get data from req
        //find the user by email in tempuser table
        const existingUserInTemp  = await tempUser.findOne({
            where: {
                email: email 
        }});
        //if exists 
        if (existingUserInTemp) {
            const storedVerificationCode = existingUserInTemp.code;// get the hashed code from the thable
            //const hashedVerificationCode = await bcrypt.hash(VerificationCode.toString(), 10);// hash the code from the user
            //compare
            console.log(storedVerificationCode);
            console.log(existingUserInTemp);
            if(verificationCode == storedVerificationCode){
                const newUser = await User.create({
                    firstname: existingUserInTemp.firstname,
                    lastname: existingUserInTemp.lastname,
                    username: existingUserInTemp.username,
                    email: existingUserInTemp.email,
                    password: existingUserInTemp.password, 
                    phone: existingUserInTemp.phone,
                    dateOfBirth: existingUserInTemp.dateOfBirth,
                  });
                  await existingUserInTemp.destroy();
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
            
            console.log('User not found with the given email');
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


exports.postSignup=async (req,res,next)=>{
    try {
        console.log("==============================");
        console.log(req.body);
    
        const { firstName,lastName,userName, email, password, phone, dateOfBirth } = req.body;
        // all values not empty 
        if (!firstName ||!lastName ||!userName || !email || !password || !phone || !dateOfBirth) {
            return res.status(409).json({
                message: 'One or more fields are empty',
                body :req.body
              });
          }
        // all values are correct
        if(!validator.isUsername(firstName) || firstName.length < 5 ||firstName.length > 50){
            return res.status(409).json({
                message: 'Not Valid firstName',
                body :req.body
              });
        }
        if(!validator.isUsername(lastName) || lastName.length < 5 ||lastName.length > 50){
            return res.status(409).json({
                message: 'Not Valid UserName',
                body :req.body
              });
        }
        if(!validator.isUsername(userName) || userName.length < 5 ||userName.length > 50){
            return res.status(409).json({
                message: 'Not Valid UserName',
                body :req.body
              });
        }
        if(!validator.isEmail(email)|| email.length < 12 ||email.length > 100){
            return res.status(409).json({
                message: 'Not Valid email',
                body :req.body
              });
        }
        if(!validator.isPhoneNumber(phone)|| phone.length < 10 ||phone.length > 15){
            return res.status(409).json({
                message: 'Not Valid Phone Number',
                body :req.body
              });
        }
        if(password.length <8 || password.length >30 ){
            return res.status(409).json({
                message: 'Not Valid password',
                body :req.body
              });
        }
        if(!validator.isDate(dateOfBirth)|| dateOfBirth.length < 8 ||dateOfBirth.length > 10){
            return res.status(409).json({
                message: 'Not Valid date Of Birth',
                body :req.body
              });
        }
        // find if user exsist in user table
            const existingUserName  = await User.findOne({
                where: {
                    username: userName 
                },
                });
            const existingEmail = await User.findOne({
                where: {
                        email: email 
                    },
                });
            // find if user exsist in tempuser table
            const existingUserNameInTemp  = await tempUser.findOne({
                where: {
                      username: userName 
                  },
                });
            const existingEmailInTemp = await tempUser.findOne({
                where: {
                        email: email 
                    },
                });
            //if user has a data on temuser will be removed 
            if (existingUserNameInTemp) {
                await existingUserNameInTemp.destroy();
            }   
            if (existingEmailInTemp) {
                await existingEmailInTemp.destroy();
            }                  
            if (existingUserName ) {
                // User already exists
                return res.status(409).json({
                  message: 'UserName already exists',
                  body :req.body
                });
            }if (existingEmail) {
                // mail already exists
                return res.status(409).json({
                  message: 'Email already exists',
                  body :req.body
                });
            }

            // after all that validation save the new user and send the VerificationCode
            await createUserInTemp(firstName,lastName,userName, email, password, phone, dateOfBirth);
            /*
            const hashedPassword = await bcrypt.hash(password, 10);// hash the password
            const newUser = await User.create({
                username: userName,
                email: email,
                password: hashedPassword, 
                phone: phone,
                dateOfBirth: dateOfBirth,
              });
*/
            return res.status(200).json({
                message: "",
                body :req.body
            });
        

      } catch (error) {
        console.error('Error during user registration:', error);
            return res.status(500).json({
            message: 'Internal Server Error',
            body: req.body
            });
      }
}
async function createUserInTemp(firstName,lastName,userName, email, password, phone, dateOfBirth){
    console.log("========================");
    console.log(dateOfBirth);
    var VerificationCode = Math.floor(10000 + Math.random() * 90000);
    //const hashedVerificationCode = await bcrypt.hash(VerificationCode.toString(), 10);
    await sendVerificationCode(email, VerificationCode);
    const hashedPassword = await bcrypt.hash(password, 10);// hash the password
    const newUser = await tempUser.create({
        firstname: firstName,
        lastname: lastName,
        username: userName,
        email: email,
        password: hashedPassword, 
        phone: phone,
        dateOfBirth: dateOfBirth,
        //code: hashedVerificationCode,
        code: VerificationCode,
      });
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
        console.log('Email sent:', info.response);
      } catch (error) {
        
        console.error('Error sending email:', error);
        return res.status(500).json({
            message: 'email not found',
            body: req.body
            });
      }
    
  }
  
  // Example usage

exports.createPost=(req,res,next)=>{
    const title=req.body.title;
    const content=req.body.content;

    User.create({
        username:"ahmad",
        name:"ahmad",
        email:"ahmad@gmail.com ",
        password:"123123",
        bio:"",
        country:"",
        address:"",
        phone:"",
        dateOfBirth:"10-11-2022",
        photo:"",
        coverImage:"",
        cv:""



    }).then((result) =>{
        console.log(result);

        res.status(201).json({message:"created sucsessfully",post:result
})
    }).catch((err) =>{
        console.log(err);
    });


}