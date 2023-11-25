const Sequelize=require('sequelize');

const sequelize=require('../util/database');
const User=sequelize.define('user',{
    username:{
        type:Sequelize.STRING,
        allowNull:false,
        primaryKey:true

    },
    firstname: {type:Sequelize.STRING,allowNull:false},
    lastname:  {type:Sequelize.STRING,allowNull:false},
    email: {
        type: Sequelize.STRING,
        allowNull:false,
    },
    password: {
        type:Sequelize.STRING(1000),
        allowNull:false
    },
    bio: {
        type:Sequelize.STRING,
        allowNull:true
    },
    country:{
        type:Sequelize.STRING,
        allowNull:true
    },
    address:{
        type:Sequelize.STRING,
        allowNull:true
    },
    phone:{
        type:Sequelize.STRING,
        allowNull:false
    },
    dateOfBirth:{
        type:Sequelize.DATEONLY,
        allowNull:false
    },
    photo:{
        type:Sequelize.STRING,
        allowNull:true
    },
    coverImage:{
        type:Sequelize.STRING,
        allowNull:true
    },
    cv:{
        type:Sequelize.STRING,
        allowNull:true
    }
    


});



module.exports=User;