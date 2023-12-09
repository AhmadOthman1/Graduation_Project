const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const Page = require('./pages');
const post = require('./post');

const comment = sequelize.define('comment', {
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
    commentContent: {
        type: Sequelize.STRING(10000),
        allowNull: true,
    },
    Date: {
        type: Sequelize.DATE,
        allowNull: false,
    }
});


post.hasMany(comment, { foreignKey: 'postId', onDelete: 'CASCADE' });
comment.belongsTo(post, { foreignKey: 'postId', onDelete: 'CASCADE' });

User.hasMany(comment, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});
comment.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});

Page.hasMany(comment, { foreignKey: 'pageId', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});
comment.belongsTo(Page, { foreignKey: 'pageId', onDelete: 'CASCADE' , onUpdate: 'CASCADE' });

module.exports = comment;