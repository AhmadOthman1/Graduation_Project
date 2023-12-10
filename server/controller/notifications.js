const User = require("../models/user");
const activeUsers = require("../models/activeUsers");
const notifications = require("../models/notifications");
const Sequelize = require('sequelize');
var clientsMap = new Map();

//refresh clint mab every time server run
exports.populateClientsMap = async () => {
  try {
    const activeUsersList = await activeUsers.findAll();
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
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.flushHeaders();

  const intervalId = setInterval(() => {
    const eventData = { message: 'Server time: ' + new Date() };
    res.write(`data: ${JSON.stringify(eventData)}\n\n`);
  }, 1000);

  req.on('close', () => {
    clearInterval(intervalId);
  });
}
//open sse connection and handel notifications
exports.getNotifications = async (req, res) => {
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
    var user = await activeUsers.findOne({
      username: username,
    });
    if (user) {
      await user.destroy();
    }
    await activeUsers.create({
      username: username,
    });
    if (!clientsMap.get(username)) {
      clientsMap.set(username, []);
    }
    const clients = clientsMap.get(username) || [];
    clients.push(res);
    clientsMap.set(username, clients);
    console.log("??????????????????????????????????????????");
    console.log(clientsMap);
    if (!clientsMap.has('_intervalId')) {
      // Set the initial interval
      const intervalId = setInterval(async () => {
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
          const { username, notificationType, notificationContent, notificationPointer, createdAt } = notification;
          const notificationData = {
            username,
            notificationType,
            notificationContent,
            notificationPointer,
            createdAt,
          };
          const userClients = clientsMap.get(username) || [];
          userClients.forEach(async (client) => {
            // Write the notification data to the client
            client.write(`data: ${JSON.stringify(notificationData)}\n\n`);
          });
        });
      }, 1000);

      // Store the intervalId in the clientsMap
      clientsMap.set('_intervalId', intervalId);
    }
    /*
    const intervalId = setInterval(async () => {

      // Fetch new notifications after the current timestamp
      const newNotifications = await notifications.findAll({
        where: {
          createdAt: {
            [Sequelize.Op.gt]: new Date(new Date() - 1000),//duplicate notification if the same as time interval
          },
        },
      });
      console.log("''''''''''''''''''''''''''''''''''''''");
      console.log(newNotifications);
      //  new notifications sent to the users
      newNotifications.forEach(async (notification) => {
        const { username, notificationType, notificationContent, notificationPointer ,createdAt } = notification;
        const notificationData = {
          username,
          notificationType,
          notificationContent,
          notificationPointer,
          createdAt,
        };
        const clients = clientsMap.get(username) || [];
        clients.forEach(async (client) => {
          // Write the notification data to the client
          client.write(`data: ${JSON.stringify(notificationData)}\n\n`);
        });
      });
    }, 1000);
    */
    // Handle client disconnect
    req.on('close', async () => {
      const remainingClients = (clientsMap.get(username) || []).filter(client => client !== res);
      clientsMap.set(username, remainingClients);
      var user = await activeUsers.findOne({
        username: username,
      });
      user.destroy();
      //clearInterval(intervalId);
    });

  }
  // Store the response object for later use

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
  var user = await activeUsers.findOne({
    username: username,
  });
  if (user) {
    await notifications.create({
      username: username,
      notificationType: notification.notificationType,
      notificationContent: notification.notificationContent,
      notificationPointer: notification.notificationPointer,
    });
    console.log("innnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");
    console.log(notification);
    return true;
  }
}
