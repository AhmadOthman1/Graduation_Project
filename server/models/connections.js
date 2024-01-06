const Sequelize=require('sequelize');

const sequelize=require('../util/database');
const User=require('./user');

const connections=sequelize.define('connections',{
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    senderUsername:{
        type:Sequelize.STRING,
        allowNull:false,
    },
    receiverUsername:{
        type:Sequelize.STRING,
        allowNull:false,
    },
    date:{
        type:Sequelize.DATEONLY,
        allowNull:false
    },
});

User.hasMany(connections, {  foreignKey: 'senderUsername', onDelete: 'CASCADE',onUpdate : 'CASCADE' });
connections.belongsTo(User, { as: 'senderUsername_FK',foreignKey: 'senderUsername', onDelete: 'CASCADE',onUpdate : 'CASCADE' });
User.hasMany(connections, { foreignKey: 'receiverUsername', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
connections.belongsTo(User, { as: 'receiverUsername_FK',foreignKey: 'receiverUsername', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});

module.exports=connections;