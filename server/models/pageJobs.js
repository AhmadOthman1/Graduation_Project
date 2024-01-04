const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const pages = require('./pages');


const pageJobs = sequelize.define('pageJobs', {
    pageJobId: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    pageId: {
        type: Sequelize.STRING,
        allowNull: false,
    },
    title:{
        type:Sequelize.STRING(2000),
        allowNull:false,

    },
    interest:{
        type:Sequelize.STRING(2000),
        allowNull:false,
    },
    description:{
        type:Sequelize.STRING(2000),
        allowNull:false,

    },
    endDate:{
        type:Sequelize.DATEONLY,
        allowNull:false

    },
});

// Define foreign key constraint
pages.hasMany(pageJobs, { foreignKey: 'pageId', onDelete: 'CASCADE' });
pageJobs.belongsTo(pages, { foreignKey: 'pageId', onDelete: 'CASCADE' });
module.exports = pageJobs;