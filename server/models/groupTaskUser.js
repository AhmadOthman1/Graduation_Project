const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const groupTask = require('./groupTask');


const groupTaskUser = sequelize.define('groupTaskUser', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    taskId: {
        type: Sequelize.INTEGER,
        allowNull: false,
    },
    username:{
        type:Sequelize.STRING,
        allowNull:false,

    },
});

// Define foreign key constraint
groupTask.hasMany(groupTaskUser, { foreignKey: 'taskId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
groupTaskUser.belongsTo(groupTask, { foreignKey: 'taskId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
User.hasMany(groupTaskUser, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
groupTaskUser.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
module.exports = groupTaskUser;