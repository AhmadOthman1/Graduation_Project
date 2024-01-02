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
        primaryKey: true
    },
    username:{
        type:Sequelize.STRING,
        allowNull:false,
        primaryKey:true

    },
});

// Define foreign key constraint
pages.hasMany(pageFollower, { foreignKey: 'pageId', onDelete: 'CASCADE' });
pageFollower.belongsTo(pages, { foreignKey: 'pageId', onDelete: 'CASCADE' });
User.hasMany(pageFollower, { foreignKey: 'username', onDelete: 'CASCADE' });
pageFollower.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' });
module.exports = pageFollower;