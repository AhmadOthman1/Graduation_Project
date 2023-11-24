const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');

const WorkExperience = sequelize.define('workExperience', {
  id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    allowNull: false,
  },
  username: {
    type: Sequelize.STRING,
    allowNull: false,
    references: {
      model: User,
      key: 'username',
    },
  },
  specialty: {
    type: Sequelize.STRING,
    allowNull: false,
  },
  company: {
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

// Define foreign key constraint

module.exports = WorkExperience;