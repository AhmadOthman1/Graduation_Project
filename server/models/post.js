const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const Page = require('./pages');

const post = sequelize.define('post', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    postContent: {
        type: Sequelize.STRING(10000),
        allowNull: true,
    },
    selectedPrivacy: {
        type: Sequelize.STRING,
        allowNull: false,
    },
    photo: {
        type: Sequelize.STRING(2000),
        allowNull: true
    },
    video: {
        type: Sequelize.STRING(2000),
        allowNull: true
    },
    postDate: {
        type: Sequelize.DATE,
        allowNull: false,
    }
});

User.hasMany(post, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});
post.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});

Page.hasMany(post, { foreignKey: 'pageId', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});
post.belongsTo(Page, { foreignKey: 'pageId', onDelete: 'CASCADE' , onUpdate: 'CASCADE' });

// Define foreign key constraint
module.exports = post;