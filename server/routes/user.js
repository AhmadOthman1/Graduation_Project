const express=require('express');
const userController=require('../controller/userController')
const loginController=require('../controller/loginController')
const forgetpasswordController=require('../controller/forgetpasswordController')
const settingsController=require('../controller/settingsController')
const router=express.Router();


router.post('/signup',userController.postSignup);
router.post('/verification',userController.postVerificationCode);
router.post('/forgetpasswordverification',forgetpasswordController.postVerificationCode);
router.post('/forgetpassword',forgetpasswordController.postForgetPassword);
router.post('/changepassword',forgetpasswordController.changePassword);
router.get('/settingsGetMainInfo',settingsController.getMainInfo);
router.post('/settingsChangeMainInfo',settingsController.changeMainInfo);
router.post('/settingChangepasswor',settingsController.changePassword);
router.post('/settingChangeemailVerificationCode',settingsController.postVerificationCode);
router.post('/settingChangeemail',settingsController.changeEmail);

router.post('/Login',loginController.postLogin);
router.get('/posts',userController.getPosts);

//router.post('/post',userController.createPost)
module.exports=router;