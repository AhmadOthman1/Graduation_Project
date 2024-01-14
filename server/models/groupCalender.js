const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const pageGroup = require('./pageGroup');

const groupCalender = sequelize.define('groupCalender', {
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

pageGroup.hasMany(groupCalender, { foreignKey: 'groupId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
groupCalender.belongsTo(pageGroup, { foreignKey: 'groupId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
// Define foreign key constraint
module.exports = groupCalender;