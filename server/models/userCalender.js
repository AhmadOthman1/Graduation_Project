const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');

const userCalender = sequelize.define('userCalender', {
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
  subject: {
    type: Sequelize.STRING,
    allowNull: false,
  },
  description: {
    type: Sequelize.STRING(2000),
    allowNull: false,
  },
  date: {
    type: Sequelize.DATEONLY,
    allowNull: false,
  },
  time: {
    type: Sequelize.TIME,
    allowNull: false,
  },
});

User.hasMany(userCalender, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
userCalender.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
// Define foreign key constraint
module.exports = userCalender;