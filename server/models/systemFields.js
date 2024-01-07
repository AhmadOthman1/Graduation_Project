const Sequelize = require('sequelize');
const sequelize = require('../util/database');

const systemFields = sequelize.define('systemFields', {
  id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    allowNull: false,
  },
  Field: {
    type: Sequelize.STRING,
    allowNull: false,
  },
  
});

// Define foreign key constraint
module.exports = systemFields;