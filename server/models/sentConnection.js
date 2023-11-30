const Sequelize=require('sequelize');

const sequelize=require('../util/database');
const User=require('./user');

const sentConnection=sequelize.define('sentConnection',{
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

User.hasMany(sentConnection, { foreignKey: 'senderUsername', onDelete: 'CASCADE' });
sentConnection.belongsTo(User, { foreignKey: 'senderUsername', onDelete: 'CASCADE' });
User.hasMany(sentConnection, { foreignKey: 'receiverUsername', onDelete: 'CASCADE' });
sentConnection.belongsTo(User, { foreignKey: 'receiverUsername', onDelete: 'CASCADE' });

module.exports=sentConnection;