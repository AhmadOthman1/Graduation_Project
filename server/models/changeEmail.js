const Sequelize=require('sequelize');

const sequelize=require('../util/database');

const changeEmail=sequelize.define('changeEmail',{
    username:{
        type:Sequelize.STRING,
        allowNull:false,
        primaryKey:true

    },
    email: {
        type: Sequelize.STRING,
        allowNull:false,
        unique: true,
    },
    code:{
        type:Sequelize.STRING,
        allowNull:false
    },
});

module.exports=changeEmail;