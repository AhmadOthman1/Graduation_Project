const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const pages = require('./pages');


const pageAdmin = sequelize.define('pageAdmin', {
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
    adminType:{
        type: Sequelize.STRING, allowNull: false
    },
});

// Define foreign key constraint
pages.hasMany(pageAdmin, { foreignKey: 'pageId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
pageAdmin.belongsTo(pages, { foreignKey: 'pageId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
User.hasMany(pageAdmin, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
pageAdmin.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
module.exports = pageAdmin;