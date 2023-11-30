const express=require('express');
const userController=require('../controller/userController')
const loginController=require('../controller/loginController')
const forgetpasswordController=require('../controller/forgetpasswordController')
const settingsController=require('../controller/settings/settingsController')
const workExperienceController=require('../controller/settings/workExperienceController')
const educationLevelController=require('../controller/settings/educationLevelController')
const myPagesController=require('../controller/settings/myPagesController')
const getSearchDataController=require('../controller/search/getSearchDataController')
const { authenticateToken } = require('../controller/authController');
const authController = require('../controller/authController');

const router=express.Router();


router.post('/signup',userController.postSignup);
router.post('/verification',userController.postVerificationCode);
router.post('/forgetpasswordverification',forgetpasswordController.postVerificationCode);
router.post('/forgetpassword',forgetpasswordController.postForgetPassword);
router.post('/changepassword',forgetpasswordController.changePassword);
router.get('/settingsGetMainInfo',authenticateToken, settingsController.getMainInfo);
router.post('/settingsChangeMainInfo',authenticateToken,settingsController.changeMainInfo);
router.post('/settingChangepasswor',authenticateToken,settingsController.changePassword);
router.post('/settingChangeemailVerificationCode',authenticateToken,settingsController.postVerificationCode);
router.post('/settingChangeemail',authenticateToken,settingsController.changeEmail);
router.get('/getworkExperience',authenticateToken,workExperienceController.getWorkExperience);
router.post('/addworkExperience',authenticateToken,workExperienceController.postAddworkExperience);
router.post('/editworkExperience',authenticateToken,workExperienceController.postEditworkExperience);
router.post('/deleteworkExperience',authenticateToken,workExperienceController.postDeleteworkExperience);
router.get('/getEducationLevel',authenticateToken,educationLevelController.getEducationLevel);
router.post('/addEducationLevel',authenticateToken,educationLevelController.postAddEducationLevel);
router.post('/editEducationLevel',authenticateToken,educationLevelController.postEditEducationLevel);
router.post('/deleteEducationLevele',authenticateToken,educationLevelController.postDeleteEducationLevel);
router.get('/getSearchData',authenticateToken,getSearchDataController.getSearchData);




router.get('/getMyPages',authenticateToken,myPagesController.getMyPageInfo);
router.post('/postCreatePage',authenticateToken,myPagesController.postCreatePage);




router.post('/token', authController.getRefreshToken);
router.post('/Login',loginController.postLogin);
router.get('/posts',userController.getPosts);

//router.post('/post',userController.createPost)
module.exports=router;