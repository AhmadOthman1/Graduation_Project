const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');

const EducationLevel = sequelize.define('educationLevel', {
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
  specialty: {
    type: Sequelize.STRING,
    allowNull: false,
  },
  School: {
    type: Sequelize.STRING,
    allowNull: false,
  },
  description: {
    type: Sequelize.STRING(2000),
  },
  startDate: {
    type: Sequelize.DATE,
    allowNull: false,
  },
  endDate: {
    type: Sequelize.DATE,
  },
});

User.hasMany(EducationLevel, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
EducationLevel.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
// Define foreign key constraint
module.exports = EducationLevel;