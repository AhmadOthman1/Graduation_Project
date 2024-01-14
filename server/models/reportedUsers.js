const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');

const reportedUsers = sequelize.define('reportedUsers', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    userId: {
        type: Sequelize.STRING,
        allowNull: false,
    },
    text: {
        type: Sequelize.STRING(2000),
        allowNull: true,
    },

});


User.hasMany(reportedUsers, { foreignKey: 'userId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
reportedUsers.belongsTo(User, { foreignKey: 'userId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});

User.hasMany(reportedUsers, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});
reportedUsers.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});

module.exports = reportedUsers;