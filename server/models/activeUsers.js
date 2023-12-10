const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');

const activeUsers = sequelize.define('activeUsers', {
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
});

User.hasMany(activeUsers, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});
activeUsers.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});

// Define foreign key constraint
module.exports = activeUsers;