const express=require('express');
const userController=require('../controller/userController')
const loginController=require('../controller/loginController')
const forgetpasswordController=require('../controller/forgetpasswordController')
const settingsController=require('../controller/settings/settingsController')
const workExperienceController=require('../controller/settings/workExperienceController')
const educationLevelController=require('../controller/settings/educationLevelController')
const myPagesController=require('../controller/settings/myPagesController')
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
router.get('/getworkExperience',workExperienceController.getWorkExperience);
router.post('/addworkExperience',workExperienceController.postAddworkExperience);
router.post('/editworkExperience',workExperienceController.postEditworkExperience);
router.post('/deleteworkExperience',workExperienceController.postDeleteworkExperience);
router.get('/getEducationLevel',educationLevelController.getEducationLevel);
router.post('/addEducationLevel',educationLevelController.postAddEducationLevel);
router.post('/editEducationLevel',educationLevelController.postEditEducationLevel);
router.post('/deleteEducationLevele',educationLevelController.postDeleteEducationLevel);


router.get('/getMyPages',myPagesController.getMyPageInfo);

router.post('/Login',loginController.postLogin);
router.get('/posts',userController.getPosts);

//router.post('/post',userController.createPost)
module.exports=router;