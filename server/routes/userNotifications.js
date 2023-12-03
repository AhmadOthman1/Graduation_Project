const express=require('express');
const router=express.Router();
const notifications = require('../controller/notifications')
const { authenticateToken } = require('../controller/authController');







router.get('/notifications',authenticateToken, notifications.getNotifications);
router.get('/events', notifications.getevents);
module.exports=router;