const User = require("../models/user");
const activeUsers = require("../models/activeUsers");
const notifications = require("../models/notifications");
const Sequelize = require('sequelize');
var clientsMap = new Map();
const moment = require('moment');
var Notices = [];
//refresh clint mab every time server run
exports.populateClientsMap = async () => {
  try {
    clientsMap.clear();
    clientsMap = new Map();
    const activeUsersList = await activeUsers.findAll();
    console.log(activeUsersList)
    activeUsersList.forEach(user => {
      const username = user.username;
      clientsMap.set(username, []);
    });
    console.log('clientsMap populated successfully');
  } catch (error) {
    console.error('Error populating clientsMap:', error);
  }
};

//test
exports.getevents = async (req, res) => {
  return res.status(200).json({
    message: 'auth',
  });
}
//open sse connection and handel notifications
exports.getNotifications = async (req, res) => {
  const username = req.user.username;
  console.log(username)
  const isClosedHeaderIndex = req.rawHeaders.indexOf('isclosed') == -1 ? req.rawHeaders.indexOf('isClosed') :  req.rawHeaders.indexOf('isclosed');
  console.log(isClosedHeaderIndex)
  if (isClosedHeaderIndex !== -1) {

    const isClosedValue = req.rawHeaders[isClosedHeaderIndex + 1];
    console.log(isClosedValue)
    if (isClosedValue == 'true') {
      clientsMap.delete(username);
      
      return res.status(200).json({
        message: 'Closed',
      });
    }
  }
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.flushHeaders();
  const existingUser = await User.findOne({
    where: {
      username: username
    },
  });
  if (existingUser) {


    if (!clientsMap.get(username)) {
      clientsMap.set(username, []);
    }
    const clients = [];
    clients.push(res);
    clientsMap.set(username, clients);
    if (!clientsMap.has('_intervalId')) {
      // Set the initial interval
      const intervalId = setInterval(async () => {
        // Fetch new notifications after the current timestamp
        //console.log(Notices)
        //console.log(clientsMap)
        for (const notification of Notices) {
          const { id, username, notificationType, notificationContent, notificationPointer, createdAt } = notification;

          // Send the notification to the user's clients
          var userClients = clientsMap.get(username) || [];
          if (userClients != null && userClients != []) {
            userClients.forEach(async (client) => {
              // Write the notification data to the client
              client.write(`data: ${JSON.stringify(notification)}\n\n`);
            });
          }

          // Delete the notification from Notices
          Notices = Notices.filter(notice => notice.id !== id);
        }
        /*const newNotifications = await notifications.findAll({
          where: {
            createdAt: {
              [Sequelize.Op.gte]: new Date(new Date() - 1000),
            },
          },
        });

        console.log("''''''''''''''''''''''''''''''''''''''");
        console.log(newNotifications);

        // New notifications sent to the users
        newNotifications.forEach(async (notification) => {
          const { id, username, notificationType, notificationContent, notificationPointer, createdAt } = notification;
          var createdat = moment(createdAt).format('YYYY-MM-DD HH:mm:ss')
          const notificationData = {
            id,
            username,
            notificationType,
            notificationContent,
            notificationPointer,
            createdat,
          };
          var userClients = clientsMap.get(username) || [];
          if (userClients != null && userClients != [])
            userClients.forEach(async (client) => {
              // Write the notification data to the client
              console.log(":;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
              console.log(userClients);
              console.log(":;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
              client.write(`data: ${JSON.stringify(notificationData)}\n\n`);
            });
          userClients = null;
        });*/
      }, 1000);

      // Store the intervalId in the clientsMap
      clientsMap.set('_intervalId', intervalId);
    }




  }

};

// craete notification
exports.notify = async (req, res) => {
  var username = req.body.username;
  var notification = req.body.notification;
  console.log(notification)
  var user = await User.findOne({
    username: username,
  });
  if (user) {
    await notifications.create({
      username: username,
      notificationType: notification.notificationType,
      notificationContent: notification.notificationContent,
      notificationPointer: notification.notificationPointer,
    });
    Notices.push({
      username: username,
      notificationType: notification.notificationType,
      notificationContent: notification.notificationContent,
      notificationPointer: notification.notificationPointer,
    });
    console.log(Notices);
    console.log("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    return res.status(200).json({ success: true, message: "Notification received and processed successfully." });
  }
}
exports.notifyUser = async (username, notification) => {
  var user = await User.findOne({
    username: username,
  });
  if (user) {
    await notifications.create({
      username: username,
      notificationType: notification.notificationType,
      notificationContent: notification.notificationContent,
      notificationPointer: notification.notificationPointer,
    });
    Notices.push({
      username: username,
      notificationType: notification.notificationType,
      notificationContent: notification.notificationContent,
      notificationPointer: notification.notificationPointer,
    });
    console.log(Notices);
    console.log("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

  }


}
exports.deleteNotification = async (req, res) => {
  var username = req.body.username;
  var notification = req.body.notification;
  var user = await User.findOne({
    username: username,
  });
  if (user) {
    var deletenotifications = await notifications.findOne({
      where: {
        username: username,
        notificationType: notification.notificationType,
        notificationContent: notification.notificationContent,
        notificationPointer: notification.notificationPointer,
      }
    });

    if (deletenotifications) {
      await deletenotifications.destroy();
    }
    return res.status(200).json({ success: true, message: "Notification Deleted successfully." });
  }
}
