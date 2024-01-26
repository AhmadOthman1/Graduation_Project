const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const Page = require('./pages');
const post = require('./post');

const loginAttempts = sequelize.define('loginAttempts', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    ipAddress:{
        type: Sequelize.STRING,
        allowNull: false,
    },
    counter: {
        type: Sequelize.INTEGER,
        allowNull: false,
    },
});



User.hasOne(loginAttempts, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE',onUpdate : 'CASCADE'});
loginAttempts.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE',onUpdate : 'CASCADE'});

module.exports = loginAttempts;