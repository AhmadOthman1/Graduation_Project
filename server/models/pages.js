const Sequelize = require('sequelize');
const sequelize = require('../util/database');



const pages = sequelize.define('pages', {
    id: {
        type: Sequelize.STRING,
        allowNull: false,
        primaryKey: true
    },
    name: { type: Sequelize.STRING, allowNull: false },
    description: {
        type: Sequelize.STRING(2000),
        allowNull: true
    },
    country: {
        type: Sequelize.STRING,
        allowNull: true
    },
    address: {
        type: Sequelize.STRING(2000),
        allowNull: true
    },
    contactInfo: {
        type: Sequelize.STRING(2000),
        allowNull: false
    },
    specialty: {
        type: Sequelize.STRING,
        allowNull: false,
    },
    pageType:{
        type: Sequelize.STRING, allowNull: false
    }
});

// Define foreign key constraint

module.exports = pages;