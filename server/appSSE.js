const express = require('express');
const http = require('http');
const { Server } = require('http');
const { createReadStream } = require('fs');
const { extname } = require('path');
const userRoutes = require('./routes/userNotifications');
var cors = require('cors');

const app = express();
const server = http.createServer(app);
app.use(cors());

app.use(express.static('images'));
app.use(express.static('cvs')); 
app.use('/userNotifications', userRoutes);


server.listen(4000, () => {
  console.log('Server listening on port 4000');
});