const express=require('express');
const dashboardController=require('../controller/admin/dashboardController')
const loginController=require('../controller/loginController')
const usersController=require('../controller/admin/users/usersController')
const ConnectionsController=require('../controller/admin/users/ConnectionsController')
const activeUsersController=require('../controller/admin/users/activeUsersController')
const commentsController=require('../controller/admin/posts/commentsController')
const likesController=require('../controller/admin/posts/likesController')
const postsController=require('../controller/admin/posts/postsController')
const systemFields=require('../controller/admin/system/systemFields')
const reports=require('../controller/admin/system/reports')
const pageController=require('../controller/admin/pages/pageController')
const { authenticateToken } = require('../controller/authController');



const router=express.Router();

router.post('/login',loginController.postLoginAdmin);
router.get('/getDashboard',authenticateToken,dashboardController.getDashboard);
//users
router.get('/user',authenticateToken,usersController.getUsers);
router.post('/user',authenticateToken,usersController.createUser);
router.put('/user',authenticateToken,usersController.updateUser);
router.delete('/user',authenticateToken,usersController.deleteUser);
router.get('/connections/:username',authenticateToken,ConnectionsController.getConnections);
router.get('/SentConnections/:username',authenticateToken,ConnectionsController.getSentConnections);
router.get('/educationLevel/:username',authenticateToken,usersController.educationLevel);
router.get('workExperience/:username',authenticateToken,usersController.workExperience);
router.get('userApplications/:username',authenticateToken,usersController.userApplications);

router.get('/tempUser',authenticateToken,usersController.getTempUser);
router.delete('/tempUser',authenticateToken,usersController.deleteTempUser);

//active users
router.get('/activeUser',authenticateToken,activeUsersController.getActiveUsers);
//post
router.get('/userPosts/:username',authenticateToken,postsController.getUserPosts);
router.get('/pagePosts/:pageId',authenticateToken,postsController.getPagePosts);

router.get('/posts/:postId',authenticateToken,postsController.getPost);
router.get('/posts',authenticateToken,postsController.getPosts);
router.get('/postHistory/:postId',authenticateToken,postsController.postHistory);
router.get('/comments',authenticateToken,commentsController.getComments);
router.get('/comments/:postId',authenticateToken,commentsController.getPostComments);
router.delete('/comments/:commentId',authenticateToken,commentsController.deleteComment);
router.get('/likes',authenticateToken,likesController.getLikes);
router.get('/likes/:postId',authenticateToken,likesController.getPostLikes);
router.delete('/likes/:likeId',authenticateToken,likesController.deleteLike);
//pages
router.get('/page/:pageId',authenticateToken,pageController.getPage);
router.get('/page',authenticateToken,pageController.getPages);
router.get('/jobs/:pageId',authenticateToken,pageController.getPageJobs);
router.get('/jobs',authenticateToken,pageController.getJobs);
router.get('jopApplications/:jopId',authenticateToken,pageController.getJopApplications);
router.get('/groups/:pageId',authenticateToken,pageController.getPageGroups);
router.get('/groups',authenticateToken,pageController.getGroups);
router.get('/followers/:pageId',authenticateToken,pageController.getPageFollowers);
router.get('/admins/:pageId',authenticateToken,pageController.getPageAdmins);
router.get('/employees/:pageId',authenticateToken,pageController.getPageEmployees);
router.get('/calender/:pageId',authenticateToken,pageController.getPageCalender);






//system fields 
router.get('/systemField',authenticateToken,systemFields.getSystemFields);
router.post('/systemField',authenticateToken,systemFields.newSystemField);
router.delete('/systemField/:field',authenticateToken,systemFields.deleteSystemField);
//reports
router.get('/commentReport',authenticateToken,reports.commentReport);
router.get('/postReport',authenticateToken,reports.postReport);
router.get('/userReport',authenticateToken,reports.userReport);
router.get('/pageReport',authenticateToken,reports.pageReport);




module.exports=router;