const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const Page = require('./pages');

const pageCalender = sequelize.define('pageCalender', {
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

Page.hasMany(pageCalender, { foreignKey: 'pageId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
pageCalender.belongsTo(Page, { foreignKey: 'pageId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
// Define foreign key constraint
module.exports = pageCalender;