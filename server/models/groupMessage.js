const Sequelize=require('sequelize');

const sequelize=require('../util/database');
const User=require('./user');
const pageGroup = require('./pageGroup');

const groupMessage=sequelize.define('groupMessage',{
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    senderUsername:{
        type:Sequelize.STRING,
        allowNull:true,
    },
    groupId:{
        type:Sequelize.INTEGER,
        allowNull:true,
    },
    text:{
        type:Sequelize.STRING(2000),
        allowNull:true,
    },
    image:{
        type:Sequelize.STRING(2000),
        allowNull:true,
    },
    video:{
        type:Sequelize.STRING(2000),
        allowNull:true,
    },

});

User.hasMany(groupMessage, {  foreignKey: 'senderUsername', onDelete: 'CASCADE', onUpdate : 'CASCADE'});
groupMessage.belongsTo(User, { foreignKey: 'senderUsername', onDelete: 'CASCADE' , onUpdate : 'CASCADE'});
pageGroup.hasMany(groupMessage, { foreignKey: 'groupId', onDelete: 'CASCADE', onUpdate : 'CASCADE' });
groupMessage.belongsTo(pageGroup, { foreignKey: 'groupId', onDelete: 'CASCADE' , onUpdate : 'CASCADE'});

module.exports=groupMessage;