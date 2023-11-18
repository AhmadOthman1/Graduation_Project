const Sequelize=require('sequelize');

const sequelize=require('../util/database');

const forgetPasswordCode=sequelize.define('forgetPasswordCode',{
    email: {
        type:Sequelize.STRING,
        allowNull:false,
        primaryKey:true
    },
    code:{
        type:Sequelize.STRING,
        allowNull:false
    },

});

module.exports=forgetPasswordCode;