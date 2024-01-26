const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const post = require('./post');

const postPhotos = sequelize.define('postPhotos', {
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
    photo: {
        type: Sequelize.STRING(2000),
        allowNull: false,
    },
});


post.hasMany(postPhotos, { foreignKey: 'postId', onDelete: 'CASCADE',onUpdate : 'CASCADE' });
postPhotos.belongsTo(post, { foreignKey: 'postId', onDelete: 'CASCADE',onUpdate : 'CASCADE' });

module.exports = postPhotos;