const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const Page = require('./pages');
const post = require('./post');

const postHistory = sequelize.define('postHistory', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    postId: {
        type: Sequelize.INTEGER,
        allowNull: false,
    },
    PreviousText: {
        type: Sequelize.STRING(10000),
        allowNull: true,
    },
});


post.hasMany(postHistory, { foreignKey: 'postId', onDelete: 'CASCADE',onUpdate : 'CASCADE' });
postHistory.belongsTo(post, { foreignKey: 'postId', onDelete: 'CASCADE',onUpdate : 'CASCADE' });

module.exports = postHistory;