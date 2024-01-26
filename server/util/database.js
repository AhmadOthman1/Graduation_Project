const Sequelize = require('sequelize');

const sequelize = new Sequelize('growify', 'root', '123456', {
  dialect: 'mysql',
  host: 'localhost',
  pool: {
    max: 20,
    min: 0,
    acquire: 200000,
  }
});



module.exports = sequelize;