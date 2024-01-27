const express=require('express');
const dashboardController=require('../controller/admin/dashboardController')
const loginController=require('../controller/loginController')
const usersController=require('../controller/admin/users/usersController')
const ConnectionsController=require('../controller/admin/users/ConnectionsController')
const activeUsersController=require('../controller/admin/users/activeUsersController')
const commentsController=require('../controller/admin/posts/commentsController')
const likesController=require('../controller/admin/posts/likesController')
const postsController=require('../controller/admin/posts/postsController')
const { authenticateToken } = require('../controller/authController');



const router=express.Router();

router.post('/login',loginController.postLoginAdmin);
router.get('/getDashboard',authenticateToken,dashboardController.getDashboard);
//users
router.get('/user',authenticateToken,usersController.getUsers);
router.post('/user',authenticateToken,usersController.createUser);
router.put('/user',authenticateToken,usersController.updateUser);
router.delete('/user',authenticateToken,usersController.deleteUser);
router.get('/connections',authenticateToken,ConnectionsController.getConnections);
router.get('/educationLevel',authenticateToken,usersController.educationLevel);
router.get('workExperience',authenticateToken,usersController.workExperience);

//active users
router.get('/activeUser',authenticateToken,activeUsersController.getActiveUsers);
//post
router.get('/posts',authenticateToken,postsController.getPosts);
router.get('/postHistory/:postId',authenticateToken,postsController.postHistory);
router.get('/comments',authenticateToken,commentsController.getComments);
router.get('/comments/:postId',authenticateToken,commentsController.getPostComments);
router.delete('/comments/:commentId',authenticateToken,commentsController.deleteComment);
router.get('/likes',authenticateToken,likesController.getLikes);
router.get('/likes/:postId',authenticateToken,likesController.getPostLikes);
router.delete('/likes/:likeId',authenticateToken,likesController.deleteLike);









module.exports=router;