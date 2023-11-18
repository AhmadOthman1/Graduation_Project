const express = require('express');
const bodyParser = require('body-parser');

const userRoutes = require('./routes/user');

//const bodyParser=require('body-parser');

const sequelize=require('./util/database');

const app = express();

// Use body-parser middleware
app.use(bodyParser.json());

// Log middleware to see the request details


// Use feed routes
app.use('/user', userRoutes);



//{force:true}
sequelize.sync().then(result =>{
    console.log(result);
    app.listen(3000);
  
}).catch(err=>{
    console.log(err);
    

});
/*const express=require('express');
const User=require('./models/user');
const TempUser=require('./models/tempUser');
const forgetpasswordController=require('./models/forgetPasswordCode');
//const bodyParser=require('body-parser');

const sequelize=require('./util/database');

const app=express();

//{force:true}
sequelize.sync().then(result =>{
    console.log(result);
    app.listen(3000);
  
}).catch(err=>{
    console.log(err);
    

});*/