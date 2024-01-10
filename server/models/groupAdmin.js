const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const pageGroup = require('./pageGroup');


const groupAdmin = sequelize.define('groupAdmin', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    groupId: {
        type: Sequelize.INTEGER,
        allowNull: false,
    },
    username:{
        type:Sequelize.STRING,
        allowNull:false,

    },
});

// Define foreign key constraint
pageGroup.hasMany(groupAdmin, { foreignKey: 'groupId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
groupAdmin.belongsTo(pageGroup, { foreignKey: 'groupId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
User.hasMany(groupAdmin, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
groupAdmin.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
module.exports = groupAdmin;