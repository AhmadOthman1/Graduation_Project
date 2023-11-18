const Sequelize=require('sequelize');

const sequelize=require('../util/database');

const User=sequelize.define('tempUser',{
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
    phone:{
        type:Sequelize.STRING,
        allowNull:false
    },
    dateOfBirth:{
        type:Sequelize.DATEONLY,
        allowNull:false
    },
    code:{
        type:Sequelize.STRING,
        allowNull:false
    },

});

module.exports=User;