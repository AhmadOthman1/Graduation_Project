const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const comment = require('./comment');

const reportedComment = sequelize.define('reportedComment', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    commentId: {
        type: Sequelize.INTEGER,
        allowNull: false,
    },
    text: {
        type: Sequelize.STRING(2000),
        allowNull: true,
    },

});


comment.hasMany(reportedComment, { foreignKey: 'commentId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});
reportedComment.belongsTo(comment, { foreignKey: 'commentId', onDelete: 'CASCADE' ,onUpdate : 'CASCADE'});

User.hasMany(reportedComment, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});
reportedComment.belongsTo(User, { foreignKey: 'username', onDelete: 'CASCADE' , onUpdate: 'CASCADE'});

module.exports = reportedComment;