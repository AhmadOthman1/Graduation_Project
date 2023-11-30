const Sequelize=require('sequelize');

const sequelize=require('../util/database');
const User = require('./user');
const forgetPasswordCode=sequelize.define('forgetPasswordCode',{
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
        unique: true,
      },
    username:{
        type:Sequelize.STRING,
        allowNull:false,
    },
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
User.hasOne(forgetPasswordCode, { foreignKey: 'username', onDelete: 'CASCADE' });

module.exports=forgetPasswordCode;