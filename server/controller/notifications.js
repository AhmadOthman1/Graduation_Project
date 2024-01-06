const User = require("../models/user");
const activeUsers = require("../models/activeUsers");
const notifications = require("../models/notifications");
const Sequelize = require('sequelize');
var clientsMap = new Map();
const moment = require('moment');

//refresh clint mab every time server run
exports.populateClientsMap = async () => {
  try {
    clientsMap.clear();
    clientsMap = new Map();
    const activeUsersList = await activeUsers.findAll();
    console.log(activeUsersList)
    activeUsersList.forEach(user => {
      console.log(user.username)
      console.log("================================")
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
  console.log("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");

  const isClosedHeaderIndex = req.rawHeaders.indexOf('isclosed');
  if (isClosedHeaderIndex !== -1) {

    const isClosedValue = req.rawHeaders[isClosedHeaderIndex + 1];
    if (isClosedValue == 'true') {
      clientsMap.delete(username);
      return res.status(200).json({
        message: 'Closed',
      });
    }
  }
  console.log("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.flushHeaders();
  console.log(username);
  console.log(";;;;;;;;;;;;;;;;;;;;;;;;;;;;");
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
    console.log("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    if (!clientsMap.has('_intervalId')) {
      // Set the initial interval
      const intervalId = setInterval(async () => {
        console.log("??????????????????????????????????????????");
        console.log(clientsMap);
        // Fetch new notifications after the current timestamp
        const newNotifications = await notifications.findAll({
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
        });
      }, 1000);

      // Store the intervalId in the clientsMap
      clientsMap.set('_intervalId', intervalId);
    }




  }

};
exports.closeNotifications = async (username) => {
  console.log("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
  console.log(clientsMap)
  console.log(username)
  // Check if the user is in the map and has no remaining clients
  for (const key of clientsMap.keys()) {
    console.log(key);
    console.log(";;;;;;;;;;;;;;;;;;;;;");
    if (key == username) {
      // Remove the user from the map
      clientsMap.delete(username);
      console.log(clientsMap);
      console.log("ooooooooooooooooooooooooooooooooooooo");
      // Clear the interval for this user if it exists
      const intervalId = clientsMap.get('_intervalId');
      if (intervalId) {
        clearInterval(intervalId);
        clientsMap.delete('_intervalId');
      }

      // Optionally, clean up any other resources related to the user
      var user = await activeUsers.findOne({
        where: {
          username: username,
        },
      });
      if (user != null) {
        user.destroy();
      }
      return true;
    }
  }
  return false;
};

/*
exports.getNotifications = async (req, res) => {
  // Extract the userId from the query parameters
  const username = req.headers['username'];
 
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
    // Check if the user is already marked as active
    const user = await ActiveUsers.findOne({
      where: {
        username: username,
      },
    });
 
    if (!user) {
      // If not, mark the user as active in the database
      await ActiveUsers.create({
        username: username,
      });
    }
 
    // Your existing logic to push data to clients
    const intervalId = setInterval(() => {
 
      const eventData = { message: 'Server time: ' + new Date() };
      res.write(`data: ${JSON.stringify(eventData)}\n\n`);
    }, 1000);
    // Handle client disconnect
    req.on('close', async () => {
      // Remove the user from the list of active users when they disconnect
      await ActiveUsers.destroy({
        where: {
          username: username,
        },
      });
    });
  }
};
*/
// craete notification
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
    return true;
  }
}
exports.deleteNotificaion = async (username, notification) => {
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
    return true;
  }
}
