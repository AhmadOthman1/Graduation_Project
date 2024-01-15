const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const pageGroup = require('./pageGroup');


const groupMeeting = sequelize.define('groupMeeting', {
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
    meetingId: {
        type: Sequelize.STRING,
        allowNull: false,
    },
    users:{
        type:Sequelize.INTEGER,
        allowNull:true,
    },
});

// Define foreign key constraint
pageGroup.hasMany(groupMeeting, { foreignKey: 'groupId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
groupMeeting.belongsTo(pageGroup, { foreignKey: 'groupId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
module.exports = groupMeeting;