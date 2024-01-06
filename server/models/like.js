const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const Page = require('./pages');
const post = require('./post');

const like = sequelize.define('like', {
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
});


post.hasMany(like, { foreignKey: 'postId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
like.belongsTo(post, { foreignKey: 'postId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});

User.hasMany(like, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE',onUpdate : 'CASCADE'});
like.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE',onUpdate : 'CASCADE'});

Page.hasMany(like, { foreignKey: 'pageId', onDelete: 'CASCADE' , onUpdate: 'CASCADE',onUpdate : 'CASCADE'});
like.belongsTo(Page, { foreignKey: 'pageId', onDelete: 'CASCADE' , onUpdate: 'CASCADE' ,onUpdate : 'CASCADE'});

module.exports = like;