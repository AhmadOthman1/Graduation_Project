const express=require('express');
const router=express.Router();
const notifications = require('../controller/notifications')
const { authenticateToken } = require('../controller/authController');







router.get('/notifications',authenticateToken, notifications.getNotifications);
router.get('/closeNotifications',authenticateToken, notifications.closeNotifications);
router.get('/notificationsAuth',authenticateToken, notifications.getevents);
module.exports=router;