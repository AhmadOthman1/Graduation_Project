const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');

const notifications = sequelize.define('notifications', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    username:{
        type:Sequelize.STRING,
        allowNull:false,
    },
    notificationType: {
        type: Sequelize.STRING(2000),
        allowNull: false,
        /*
        connection => receive connection, connection get accepted
        post => new like/ comment
        meessage => new message
        call => new call
        job =>new job
        */
    },
    notificationContent: {
        type: Sequelize.STRING(2000),
        allowNull: false,
    },
    notificationPointer: {
        type: Sequelize.STRING(2000),
        allowNull: false,
    },
});

User.hasMany(notifications, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});
notifications.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});

// Define foreign key constraint
module.exports = notifications;