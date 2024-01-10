const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const pageGroup = require('./pageGroup');


const groupMember = sequelize.define('groupMember', {
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
pageGroup.hasMany(groupMember, { foreignKey: 'groupId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
groupMember.belongsTo(pageGroup, { foreignKey: 'groupId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
User.hasMany(groupMember, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
groupMember.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
module.exports = groupMember;