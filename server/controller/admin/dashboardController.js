const User = require("../../models/user");
const post = require('../../models/post');
const Page = require("../../models/pages");
const pageJobs = require("../../models/pageJobs");
const jobApplication = require("../../models/jobApplication");
const pageGroup = require("../../models/pageGroup");
const messages = require("../../models/messages");
const activeUsers = require("../../models/activeUsers");
const groupMeeting = require("../../models/groupMeeting");



exports.getDashboard = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where:{
            username:username,
            type:"Admin"
        }
    });
    if(existingUsername!=null){
        var usersCount = await User.count();
        var activeUsersCount = await activeUsers.count();
        var pagesCount = await Page.count();
        var jobsCount = await pageJobs.count();
        var jobsApplicationsCount = await jobApplication.count();
        var groupsCount = await pageGroup.count();
        var groupMeetingsCount = await groupMeeting.count();
        var messagesCount = await messages.count();
        var postsCount = await post.count();
        return res.status(200).json({
            message: 'Dashboard',
            usersCount: usersCount,
            activeUsersCount: activeUsersCount,
            pagesCount: pagesCount,
            jobsCount: jobsCount,
            jobsApplicationsCount: jobsApplicationsCount,
            groupsCount: groupsCount,
            groupMeetingsCount: groupMeetingsCount,
            messagesCount: messagesCount,
            postsCount: postsCount,
        });
    }else{
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}