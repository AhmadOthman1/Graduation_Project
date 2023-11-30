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

User.hasMany(connections, { foreignKey: 'senderUsername', onDelete: 'CASCADE' });
connections.belongsTo(User, { foreignKey: 'senderUsername', onDelete: 'CASCADE' });
User.hasMany(connections, { foreignKey: 'receiverUsername', onDelete: 'CASCADE' });
connections.belongsTo(User, { foreignKey: 'receiverUsername', onDelete: 'CASCADE' });

module.exports=connections;