const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const pageGroup = require('./pageGroup');

const groupTask = sequelize.define('groupTask', {
  taskId: {
    type: Sequelize.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    allowNull: false,
  },
  groupId: {
    type: Sequelize.INTEGER,
    allowNull: false,
  },
  username: {
    type: Sequelize.STRING,
    allowNull: false,
  },
  taskName: {
    type: Sequelize.STRING(2000),
    allowNull: false,
  },
  description: {
    type: Sequelize.STRING(2000),
    allowNull: false,
  },
  status: {
    type: Sequelize.STRING,
    allowNull: false,
  },
  startTime: {
    type: Sequelize.TIME,
    allowNull: false,
  },
  startDate: {
    type: Sequelize.DATEONLY,
    allowNull: false,
  },
  endTime: {
    type: Sequelize.TIME,
    allowNull: false,
  },
  endDate: {
    type: Sequelize.DATEONLY,
    allowNull: false,
  },
});

pageGroup.hasMany(groupTask, { foreignKey: 'groupId', onDelete: 'CASCADE', onUpdate: 'CASCADE' });
groupTask.belongsTo(pageGroup, { foreignKey: 'groupId', onDelete: 'CASCADE', onUpdate: 'CASCADE' });
User.hasMany(groupTask, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
groupTask.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});

// Define foreign key constraint
module.exports = groupTask;