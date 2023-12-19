const Sequelize=require('sequelize');

const sequelize=require('../util/database');
const User=require('./user');
const Page=require('./pages');

const messages=sequelize.define('messages',{
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
    receiverUsername:{
        type:Sequelize.STRING,
        allowNull:true,
    },
    senderPageId:{
        type:Sequelize.STRING,
        allowNull:true,
    },
    receiverPageId:{
        type:Sequelize.STRING,
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

User.hasMany(messages, {  foreignKey: 'senderUsername', onDelete: 'CASCADE', onUpdate : 'CASCADE'});
messages.belongsTo(User, { as: 'senderUsername_FK',foreignKey: 'senderUsername', onDelete: 'CASCADE' , onUpdate : 'CASCADE'});
User.hasMany(messages, { foreignKey: 'receiverUsername', onDelete: 'CASCADE', onUpdate : 'CASCADE' });
messages.belongsTo(User, { as: 'receiverUsername_FK',foreignKey: 'receiverUsername', onDelete: 'CASCADE' , onUpdate : 'CASCADE'});

Page.hasMany(messages, {  foreignKey: 'senderPageId', onDelete: 'CASCADE' , onUpdate : 'CASCADE'});
messages.belongsTo(Page, { as: 'senderPageId_FK',foreignKey: 'senderPageId', onDelete: 'CASCADE', onUpdate : 'CASCADE' });
Page.hasMany(messages, { foreignKey: 'receiverPageId', onDelete: 'CASCADE', onUpdate : 'CASCADE' });
messages.belongsTo(Page, { as: 'receiverPageId_FK',foreignKey: 'receiverPageId', onDelete: 'CASCADE', onUpdate : 'CASCADE' });

module.exports=messages;