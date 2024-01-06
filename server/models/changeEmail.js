const Sequelize=require('sequelize');

const sequelize=require('../util/database');
const User = require('./user');
const changeEmail=sequelize.define('changeEmail',{
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
        type: Sequelize.STRING,
        allowNull:false,
        unique: true,
    },
    code:{
        type:Sequelize.STRING,
        allowNull:false
    },
});
User.hasOne(changeEmail, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});

module.exports=changeEmail;