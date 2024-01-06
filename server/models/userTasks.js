const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');

const userTasks = sequelize.define('userTasks', {
  id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
    autoIncrement: true,
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
  status:{
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

User.hasMany(userTasks, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
userTasks.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
// Define foreign key constraint
module.exports = userTasks;