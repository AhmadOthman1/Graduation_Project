const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const post = require('./post');

const postVideos = sequelize.define('postVideos', {
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
    video: {
        type: Sequelize.STRING(2000),
        allowNull: false,
    },
});


post.hasMany(postVideos, { foreignKey: 'postId', onDelete: 'CASCADE',onUpdate : 'CASCADE' });
postVideos.belongsTo(post, { foreignKey: 'postId', onDelete: 'CASCADE',onUpdate : 'CASCADE' });

module.exports = postVideos;