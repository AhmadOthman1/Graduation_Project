const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const pageJobs = require('./pageJobs');


const jobApplication = sequelize.define('jobApplication', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    pageJobId:{
        type: Sequelize.INTEGER,
        allowNull: false,
    },
    username:{
        type:Sequelize.STRING,
        allowNull:false,
    },
    note:{
        type: Sequelize.STRING(2000), 
        allowNull: true
    },
    cv:{
        type: Sequelize.STRING(2000), 
        allowNull: true
    },
});

// Define foreign key constraint
User.hasMany(jobApplication, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});
jobApplication.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});
pageJobs.hasMany(jobApplication, { foreignKey: 'pageJobId', onDelete: 'CASCADE' , onUpdate: 'CASCADE' });
jobApplication.belongsTo(pageJobs, { foreignKey: 'pageJobId', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});

module.exports = jobApplication;