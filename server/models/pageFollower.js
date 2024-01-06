const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const pages = require('./pages');


const pageFollower = sequelize.define('pageFollower', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    pageId: {
        type: Sequelize.STRING,
        allowNull: false,
    },
    username:{
        type:Sequelize.STRING,
        allowNull:false,

    },
});

// Define foreign key constraint
pages.hasMany(pageFollower, { foreignKey: 'pageId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
pageFollower.belongsTo(pages, { foreignKey: 'pageId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
User.hasMany(pageFollower, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
pageFollower.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE',onUpdate : 'CASCADE' });
module.exports = pageFollower;