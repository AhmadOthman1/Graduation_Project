const Sequelize = require('sequelize');
const sequelize = require('../util/database');

const systemFields = sequelize.define('systemFields', {
  Field: {
    type: Sequelize.STRING,
    primaryKey: true,
    allowNull: false,
  },
  
});

// Define foreign key constraint
module.exports = systemFields;