const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const Page = require('./pages');

const reportedPages = sequelize.define('reportedPages', {
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
    text: {
        type: Sequelize.STRING(2000),
        allowNull: true,
    },

});


Page.hasMany(reportedPages, { foreignKey: 'pageId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
reportedPages.belongsTo(Page, { foreignKey: 'pageId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});

User.hasMany(reportedPages, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});
reportedPages.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});

module.exports = reportedPages;