const express=require('express');
const userController=require('../controller/userController')
const loginController=require('../controller/loginController')
const forgetpasswordController=require('../controller/forgetpasswordController')
const router=express.Router();


router.post('/signup',userController.postSignup);
router.post('/verification',userController.postVerificationCode);
router.post('/forgetpasswordverification',forgetpasswordController.postVerificationCode);
router.post('/forgetpassword',forgetpasswordController.postForgetPassword);
router.post('/changepassword',forgetpasswordController.changePassword);
router.post('/Login',loginController.postLogin);
router.get('/posts',userController.getPosts);

//router.post('/post',userController.createPost)
module.exports=router;