const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const pages = require('./pages');


const pageGroup = sequelize.define('pageGroup', {
    groupId: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    pageId: {
        type: Sequelize.STRING,
        allowNull: false,
    },
    name:{
        type:Sequelize.STRING(2000),
        allowNull:false,

    },
    description:{
        type:Sequelize.STRING(2000),
        allowNull:true
    },
    parentGroup:{
        type:Sequelize.INTEGER,
        allowNull:true,
    },
    memberSendMessage:{
        type:Sequelize.BOOLEAN,
        allowNull:true,
    }
});

// Define foreign key constraint
pages.hasMany(pageGroup, { foreignKey: 'pageId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
pageGroup.belongsTo(pages, { foreignKey: 'pageId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});

//pageGroup.hasOne(pageGroup, { foreignKey: 'groupId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
pageGroup.belongsTo(pageGroup, { foreignKey: 'parentGroup', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
module.exports = pageGroup;