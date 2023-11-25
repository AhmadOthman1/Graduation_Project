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
        primaryKey: true
    },
    username:{
        type:Sequelize.STRING,
        allowNull:false,
        primaryKey:true

    },
    adminType:{
        type: Sequelize.STRING, allowNull: false
    },
});

// Define foreign key constraint
pageAdmin.belongsTo(pages, { foreignKey: 'pageId', onDelete: 'CASCADE' });
pageAdmin.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' });
module.exports = pageAdmin;