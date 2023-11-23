const User = require("../models/user");
const { Op } = require('sequelize');
const validator = require('./validator');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer')
const multer = require('multer');
const path = require('path');
const fs = require('fs');
exports.getMainInfo=async (req,res,next)=>{
    try{
        var email = req.query.email;
        const existingEmail = await User.findOne({
            where: {
                    email: email 
                },
            });
        if(existingEmail){
            var photo;
            var coverimage;
            var cv;
            if(existingEmail.photo==null) {
                photo=null;
            }else{
                
                const photoFilePath =  path.join('images', existingEmail.photo);

                // Check if the file exists
                try {
                    await fs.promises.access(photoFilePath, fs.constants.F_OK);
                    photo = existingEmail.photo;
                  } catch (err) {
                    console.error(err);
                    photo = null;
                    await User.update({ photo: photo }, { where: { email } });
                  }
                
            }
            if(existingEmail.coverImage==null){
                coverimage=null;
            }else{
                const coverImageFilePath = await path.join('images', existingEmail.coverImage);
                // Check if the file exists
                try {
                    await fs.promises.access(coverImageFilePath, fs.constants.F_OK);
                    coverimage = existingEmail.coverImage;
                    console.log("image fetched");

                  } catch (err) {
                    console.error(err);
                    coverimage = null;
                    await User.update({ coverImage: coverimage }, { where: { email } });
                  }
                
            }
            if(existingEmail.cv==null){
                cv=null;

            }
            console.log("fff"+photo);
            return res.status(200).json({
                message: 'User found',
                user: {
                  username: existingEmail.username,
                  firstname: existingEmail.firstname,
                  lastname: existingEmail.lastname,
                  bio: existingEmail.bio,
                  country: existingEmail.country,
                  address: existingEmail.address,
                  phone: existingEmail.phone,
                  dateOfBirth: existingEmail.dateOfBirth,
                  photo: photo,
                  coverImage: coverimage,
                  cv: cv,
                  // Add other user properties as neededs
                },
              });
        }else{
            return res.status(500).json({
                message: 'server Error',
                body: req.body
                });
        }
        console.log(email);
        console.log("*************************");
    }  catch(err){
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
            });
    }
}
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      const uploadPath = 'images'; // Set your desired upload path
      if (!fs.existsSync(uploadPath)) {
        fs.mkdirSync(uploadPath);
      }
      cb(null, uploadPath);
    },
    filename: (req, file, cb) => {
      const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
      cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
    },
  });
  
  const upload = multer({ storage });
exports.changeMainInfo=async (req,res,next)=>{
    try{
        const { email, firstName, lastName , address , country , dateOfBirth , phone , bio , profileImageBytes, profileImageBytesName, profileImageExt , coverImageBytes , coverImageBytesName,coverImageExt , cvBytes,cvName,cvExt} = req.body;
        var validfirstName=false;
        var validlastName=false;
        var validaddress=false;
        var validcountry=false;
        var validdateOfBirth=false;
        var validphone=false;
        var validbio=false;
        var validphoto=false;
        var validcoverImage=false;
        var validcv=false;
        const existingEmail = await User.findOne({
            where: {
                    email: email 
                },
            });
        if(existingEmail){
            if(firstName!=null){//if feild change enables (!=null)
                if(!validator.isUsername(firstName) || firstName.length < 1 ||firstName.length > 50){//validate
                    return res.status(409).json({
                        message: 'Not Valid firstName',
                        body :req.body
                      });
                }else{//change
                    validfirstName=true;
                }
            }
            if(lastName!=null){//if feild change enables (!=null)
                if(!validator.isUsername(lastName) || lastName.length < 1 ||lastName.length > 50){//validate
                    return res.status(409).json({
                        message: 'Not Valid firstName',
                        body :req.body
                      });
                }else{//change
                    validlastName=true;
                }
            }
            if(address!=null){//if feild change enables (!=null)
                if(address.length < 1 ||address.length > 50){//validate
                    return res.status(409).json({
                        message: 'Not Valid firstName',
                        body :req.body
                      });
                }else{//change
                    validaddress=true;
                }
            }
            if(country!=null){//if feild change enables (!=null)
                if( country.length < 1 ||country.length > 50){//validate
                    return res.status(409).json({
                        message: 'Not Valid firstName',
                        body :req.body
                      });
                }else{//change
                    validcountry=true;
                }
            }
            if(dateOfBirth!=null){//if feild change enables (!=null)
                if(!validator.isDate(dateOfBirth) || dateOfBirth.length < 8 ||dateOfBirth.length > 10){//validate
                    return res.status(409).json({
                        message: 'Not Valid firstName',
                        body :req.body
                      });
                }else{//change
                    validdateOfBirth=true;
                }
            }
            if(phone!=null){//if feild change enables (!=null)
                if(!validator.isPhoneNumbere(phone) || phone.length < 8 ||phone.length > 10){//validate
                    return res.status(409).json({
                        message: 'Not Valid firstName',
                        body :req.body
                      });
                }else{//change
                    validphone=true;
                }
            }
            if(bio!=null){//if feild change enables (!=null)
                if( bio.length < 1 ||bio.length > 250){//validate
                    return res.status(409).json({
                        message: 'Not Valid firstName',
                        body :req.body
                      });
                }else{//change
                    validbio=true;
                }
            }
            if(profileImageBytes!=null && profileImageBytesName!=null&& profileImageExt!=null){//if feild change enables (!=null)
                validphoto=true;
            }   
            if(coverImageBytes!=null && coverImageBytesName!=null && coverImageExt!=null){//if feild change enables (!=null)
                validcoverImage=true;
            }
            if(cvBytes!=null && cvName!=null &&cvExt!=null){//if feild change enables (!=null)
                validcv=true;
            }


            // save changes
            if(validfirstName){
                const result = await User.update(
                    { firstname: firstName },
                    {
                    where: { email: email },
                    }
                );
            }
            if(validlastName){
                const result = await User.update(
                    { lastname: lastName },
                    {
                    where: { email: email },
                    }
                );
            }
            if(validaddress){
                const result = await User.update(
                    { address: address },
                    {
                    where: { email: email },
                    }
                );
            }
            if(validcountry){
                const result = await User.update(
                    { country: country },
                    {
                    where: { email: email },
                    }
                );
            }
            if(validdateOfBirth){
                const result = await User.update(
                    { dateOfBirth: dateOfBirth },
                    {
                    where: { email: email },
                    }
                );
            }
            if(validphone){
                const result = await User.update(
                    { phone: phone },
                    {
                    where: { email: email },
                    }
                );
            }
            if(validbio){
                const result = await User.update(
                    { bio: bio },
                    {
                    where: { email: email },
                    }
                );
            }
            if(validphoto){
                var oldPhoto = existingEmail.photo;
                
                const photoBuffer = Buffer.from(profileImageBytes, 'base64');
                const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
                const newphotoname = existingEmail.username+ +"-"+ uniqueSuffix +"."+ profileImageExt; // You can adjust the file extension based on the actual image type
                const uploadPath = path.join('images', newphotoname);

                // Save the image to the server
                fs.writeFileSync(uploadPath, photoBuffer);

                // Update the user record in the database with the new photo name
                const result = await User.update({ photo: newphotoname }, { where: { email }});
                if(oldPhoto != null){
                    //delete the old photo from the  server image folder
                    const oldPhotoPath = path.join('images', oldPhoto);

                    fs.unlinkSync(oldPhotoPath);
                }

            }
            if(validcoverImage){
                var oldCover= existingEmail.coverImage;
                
                const photoBuffer = Buffer.from(coverImageBytes, 'base64');
                const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
                const newphotoname = existingEmail.username+ +"-"+ uniqueSuffix +"."+ coverImageExt; // You can adjust the file extension based on the actual image type
                const uploadPath = path.join('images', newphotoname);

                // Save the image to the server
                fs.writeFileSync(uploadPath, photoBuffer);

                // Update the user record in the database with the new photo name
                const result = await User.update({ coverImage: newphotoname }, { where: { email }});
                if(oldCover != null){
                    //delete the old photo from the  server image folder
                    const oldCoverPath = path.join('images', oldCover);

                    fs.unlinkSync(oldCoverPath);
                }

            }
            if(validcv){
                var oldCv = existingEmail.cv; // Change 'pdf' to the appropriate field in your database
                
                
                const pdfBuffer = Buffer.from(cvBytes, 'base64');
                const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
                const newPdfName = existingEmail.username + '-' + uniqueSuffix + '.pdf'; // Adjust the file extension based on the actual PDF type
                const uploadPath = path.join('cvs', newPdfName); // Update the folder path as needed

                // Save the PDF to the server
                fs.writeFileSync(uploadPath, pdfBuffer);

                // Update the user record in the database with the new PDF name
                const result = await User.update({ cv: newPdfName }, { where: { email } });
                if (oldCv != null) {
                    // Delete the old PDF file from the server folder
                    const oldPdfPath = path.join('cvs', oldCv); // Update the folder path as needed

                    fs.unlinkSync(oldPdfPath);
                }
            }
            
            return res.status(200).json({
                message: 'updated',
                body: req.body
                });
        }else{
            return res.status(500).json({
                message: 'server Error',
                body: req.body
                });
        }
        console.log(email);
        console.log("*************************");
    }  catch(err){
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
            });
    }
}
exports.changePassword=async (req,res,next)=>{
    try{
    const { email, oldPassword , newPassword} = req.body;
    if (!email || !oldPassword|| !newPassword ) {
        return res.status(409).json({
            message: 'One or more fields are empty',
            body :req.body
          });
    }
    if(!validator.isEmail(email)|| email.length < 12 ||email.length > 100){
    return res.status(409).json({
        message: 'Not Valid email',
        body :req.body
        });
    }
    if(oldPassword.length <8 || oldPassword.length >30 ){
        return res.status(409).json({
            message: 'Not Valid password',
            body :req.body
          });
    }
    if(newPassword.length <8 || newPassword.length >30 ){
        return res.status(409).json({
            message: 'Not Valid password',
            body :req.body
          });
    }
    const existingEmail = await User.findOne({
        where: {
                email: email 
            },
        });
        if(existingEmail){
            const isMatch = await bcrypt.compare(oldPassword, existingEmail.password);
            if(isMatch){
                const hashedPassword = await bcrypt.hash(newPassword, 10);
                const result = await User.update(
                    { password: hashedPassword },
                    {
                    where: { email: email },
                    }
                );
                return res.status(200).json({
                    
                    message: 'changed',
                    body :req.body
                    });

            }else{
                return res.status(409).json({
                    message: 'Wrong Password',
                    body :req.body
                    });
            }

        }else{
            return res.status(500).json({
                message: 'server Error',
                body: req.body
                });
        }
    }catch(err){
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
            });
    }
}
