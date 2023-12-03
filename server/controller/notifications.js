const clientsMap = new Map();
exports.getevents = async(req,res)=>{
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
exports.getNotifications = async (req, res) => {
    // Extract the userId from the query parameters
    const userId = req.query.userId;
  
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');
    res.flushHeaders();
  
    // Store the response object for later use
    const clients = clientsMap.get(userId) || [];
    clients.push(res);
    clientsMap.set(userId, clients);
  
    // Handle client disconnect
    req.on('close', () => {
      const remainingClients = (clientsMap.get(userId) || []).filter(client => client !== res);
      clientsMap.set(userId, remainingClients);
    });
  };

  
  // Notify users function
  function notifyUser(userId, notification) {
    const clients = clientsMap.get(userId) || [];
    clients.forEach(client => {
      client.write(`data: ${JSON.stringify(notification)}\n\n`);
    });
  }