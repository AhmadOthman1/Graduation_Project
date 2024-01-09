const express=require('express');
const userController=require('../controller/userController')
const loginController=require('../controller/loginController')
const logOutController=require('../controller/logOutController')
const forgetpasswordController=require('../controller/forgetpasswordController')
const settingsController=require('../controller/settings/settingsController')
const workExperienceController=require('../controller/settings/workExperienceController')
const educationLevelController=require('../controller/settings/educationLevelController')
const myPagesController=require('../controller/settings/myPagesController')
const getSearchDataController=require('../controller/search/getSearchDataController')
const usersProfile=require('../controller/search/usersProfile')
const { authenticateToken } = require('../controller/authController');
const authController = require('../controller/authController');
const userPostsController=require('../controller/posts/userPosts')
const getPostsController=require('../controller/posts/getPosts')
const userNotificationsController=require('../controller/notifications/userNotificationsController')
const chatsMainPage=require('../controller/chats/chatsMainPage')
const userMessages=require('../controller/chats/userMessages')
const UserColleagues=require('../controller/mainUser/userColleagues')
const pagesProfile=require('../controller/search/pagesProfile')
const userTasks =require('../controller/tasks/userTasksController')


const router=express.Router();
//auth
router.post('/signup',userController.postSignup);
router.post('/verification',userController.postVerificationCode);
router.post('/forgetpasswordverification',forgetpasswordController.postVerificationCode);
router.post('/forgetpassword',forgetpasswordController.postForgetPassword);
router.post('/changepassword',forgetpasswordController.changePassword);
//user
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
router.post('/getUserProfileDashboard',authenticateToken,settingsController.getUserProfileDashboard);
router.get('/getUserColleagues',authenticateToken,UserColleagues.getUserColleagues);
router.get('/getUserRequestsReceived',authenticateToken,UserColleagues.getUserRequestsReceived);
router.get('/getUserRequestsSent',authenticateToken,UserColleagues.getUserRequestsSent);
//search
router.get('/getSearchData',authenticateToken,getSearchDataController.getSearchData);
//other users profile
router.get('/getUserProfileInfo',authenticateToken,usersProfile.getUserProfileInfo);
router.post('/postSendConnectReq',authenticateToken,usersProfile.postSendConnectReq);
router.post('/postSendRemoveReq',authenticateToken,usersProfile.postSendRemoveReq);
router.post('/postSendRemoveConnection',authenticateToken,usersProfile.postSendRemoveConnection);
router.post('/postSendAcceptConnectReq',authenticateToken,usersProfile.postSendAcceptConnectReq);
router.post('/postSendDeleteReq',authenticateToken,usersProfile.postSendDeleteReq);
router.get('/usersGetEducationLevel',authenticateToken,usersProfile.getEducationLevel);
router.get('/usersGetworkExperience',authenticateToken,usersProfile.getWorkExperience);
//user posts
router.post('/postNewUserPost',authenticateToken,userPostsController.postNewUserPost);
router.post('/getPosts',authenticateToken,getPostsController.getPosts);
router.post('/getPost',authenticateToken,getPostsController.getPost);
router.post('/getPostLikes',authenticateToken,getPostsController.getPostLikes);
router.post('/addLike',authenticateToken,getPostsController.addLike);
router.post('/removeLike',authenticateToken,getPostsController.removeLike);
router.post('/getPostComments',authenticateToken,getPostsController.getPostComments);
router.post('/addComment',authenticateToken,getPostsController.addComment);
router.post('/deletePost',authenticateToken,getPostsController.deletePost);
router.post('/deleteComment',authenticateToken,getPostsController.deleteComment);
//user notifications
router.get('/getUserNotifications',authenticateToken,userNotificationsController.getUserNotifications);
//chats
router.get('/getChats',authenticateToken,chatsMainPage.getChats);
router.get('/getUserMessages',authenticateToken,userMessages.getUserMessages);
//userTasks
router.get('/getUserTasks',authenticateToken,userTasks.getUserTasks);
router.post('/ChangeUserTaskStatus',authenticateToken,userTasks.ChangeUserTaskStatus);
router.post('/CreateUserTask',authenticateToken,userTasks.CreateUserTask);

//user pages
router.get('/getMyPages',authenticateToken,myPagesController.getMyPageInfo);
router.post('/postCreatePage',authenticateToken,myPagesController.postCreatePage);
router.post('/getPagePosts',authenticateToken,myPagesController.getPagePosts);
router.post('/getPagePostLikes',authenticateToken,myPagesController.getPagePostLikes);
router.post('/getPagePostComments',authenticateToken,myPagesController.getPagePostComments);
router.post('/pageAddLike',authenticateToken,myPagesController.pageAddLike);
router.post('/pageRemoveLike',authenticateToken,myPagesController.pageRemoveLike);
router.post('/pageAddComment',authenticateToken,myPagesController.pageAddComment);
router.post('/postNewPagePost',authenticateToken,myPagesController.postNewPagePost);
router.post('/deletePagePost',authenticateToken,myPagesController.deletePagePost);
router.post('/deletePageComment',authenticateToken,myPagesController.deletePageComment);
router.post('/editPageInfo',authenticateToken,myPagesController.editPageInfo);
router.get('/getPageAdmins',authenticateToken,myPagesController.getPageAdmins);
router.post('/addNewAdmin',authenticateToken,myPagesController.addNewAdmin);
router.post('/deleteAdmin',authenticateToken,myPagesController.deleteAdmin);
router.get('/getPageEmployees',authenticateToken,myPagesController.getPageEmployees);
router.post('/addNewEmployee',authenticateToken,myPagesController.addNewEmployee);
router.post('/deleteEmployee',authenticateToken,myPagesController.deleteEmployee);
router.get('/getPageJobs',authenticateToken,myPagesController.getPageJobs);
router.get('/getPageJobApplications',authenticateToken,myPagesController.getPageJobApplications);
router.get('/getJobFields',authenticateToken,myPagesController.getJobFields);
router.post('/addNewJob',authenticateToken,myPagesController.addNewJob);
// other Pages
router.get('/getPageProfileInfo',authenticateToken,pagesProfile.getPageProfileInfo);
router.post('/followPage',authenticateToken,pagesProfile.followPage);
router.post('/removePageFollow',authenticateToken,pagesProfile.removePageFollow);
router.get('/getJobs',authenticateToken,pagesProfile.getJobs);
router.post('/saveJobApplication',authenticateToken,pagesProfile.saveJobApplication);




router.post('/token', authController.getRefreshToken);
router.post('/Login',loginController.postLogin);
router.post('/LogOut',authenticateToken,logOutController.postLogOut);

//router.post('/post',userController.createPost)
module.exports=router;