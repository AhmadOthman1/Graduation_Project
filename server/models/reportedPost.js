const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const post = require('./post');

const reportedPost = sequelize.define('reportedPost', {
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
    text: {
        type: Sequelize.STRING(2000),
        allowNull: true,
    },

});


post.hasMany(reportedPost, { foreignKey: 'postId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
reportedPost.belongsTo(post, { foreignKey: 'postId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});

User.hasMany(reportedPost, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});
reportedPost.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});

module.exports = reportedPost;