const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const pages = require('./pages');


const pageEmployees = sequelize.define('pageEmployees', {
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
    field:{
        type: Sequelize.STRING(2000), 
        allowNull: true
    },
});

// Define foreign key constraint
pages.hasMany(pageEmployees, { foreignKey: 'pageId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
pageEmployees.belongsTo(pages, { foreignKey: 'pageId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
User.hasMany(pageEmployees, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
pageEmployees.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
module.exports = pageEmployees;