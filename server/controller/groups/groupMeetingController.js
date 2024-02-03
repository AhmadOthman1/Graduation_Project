const User = require("../../models/user");
const userPages = require("../../models/pages");
const pageAdmin = require("../../models/pageAdmin");
const pageEmployees = require("../../models/pageEmployees");
const { Op } = require('sequelize');
const validator = require('../validator');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer')
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const jwt = require('jsonwebtoken');
const post = require('../../models/post');
const comment = require('../../models/comment');
const like = require('../../models/like');
const moment = require('moment');
const pageGroup = require("../../models/pageGroup");
const { notifyUser, deleteNotification } = require('../notifyUser');
const groupAdmin = require("../../models/groupAdmin");
const groupMember = require("../../models/groupMember");
const groupMeeting = require("../../models/groupMeeting");
const getChildGroups = async (groupId, childGroups = []) => {
    const groups = await pageGroup.findAll({
        where: {
            parentGroup: groupId,
        },
    });

    for (const group of groups) {
        childGroups.push(group.groupId);
        await getChildGroups(group.groupId, childGroups);
    }

    return childGroups;
};
const getUserAdminGroupsAndChildren = async (userUsername) => {
    const adminGroups = await groupAdmin.findAll({
        where: {
            username: userUsername,
        },
    });

    let allGroups = [];

    for (const adminGroup of adminGroups) {
        const groupId = adminGroup.groupId;
        const childGroups = await getChildGroups(groupId);
        allGroups.push(groupId, ...childGroups);
    }

    return [...new Set(allGroups)]; // Remove duplicates
};
exports.createGroupMeeting = async (req, res, next) => {
    try {
        const { meetingId, groupId } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername,
                status: null,
            },
        });
        if (existingUsername != null) {
            const group = await pageGroup.findOne({
                where: {
                    groupId: groupId,
                }
            });
            if (group == null) {
                return res.status(500).json({
                    message: 'group not found',
                    body: req.body
                });
            }
            const isAdmin = await pageAdmin.findOne({
                where: {
                    username: userUsername,
                    pageId: group.pageId,
                    adminType: "A"
                }
            });
            if (isAdmin != null) {
                var isMeetingExist = await groupMeeting.findOne({
                    where: {
                        groupId: groupId,
                        meetingId: meetingId,
                    }
                });
                if (isMeetingExist != null) {
                    await groupMeeting.update(
                        {
                            users: 0,
                        },
                        {
                            where: {
                                groupId: groupId,
                                meetingId: meetingId,
                            }
                        }
                    )
                    await groupMeeting.create({
                        groupId: groupId,
                        meetingId: meetingId,
                        users: 1,
                    });
                    return res.status(200).json({
                        message: 'meeting created',
                    });
                } else {
                    await groupMeeting.create({
                        groupId: groupId,
                        meetingId: meetingId,
                        users: 1,
                    });
                    return res.status(200).json({
                        message: 'meeting created',
                    });
                }
            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    var isMeetingExist = await groupMeeting.findOne({
                        where: {
                            groupId: groupId,
                            meetingId: meetingId,
                        }
                    });
                    if (isMeetingExist != null) {
                        await groupMeeting.update(
                            {
                                users: 0,
                            },
                            {
                                where: {
                                    groupId: groupId,
                                    meetingId: meetingId,
                                }
                            }
                        )
                        await groupMeeting.create({
                            groupId: groupId,
                            meetingId: meetingId,
                            users: 1,
                        });
                        return res.status(200).json({
                            message: 'meeting created',
                        });
                    } else {
                        await groupMeeting.create({
                            groupId: groupId,
                            meetingId: meetingId,
                            users: 1,
                        });
                        return res.status(200).json({
                            message: 'meeting created',
                        });
                    }
                } else {
                    // The user is not authorized to update the group info
                    return res.status(403).json({
                        message: 'You are not allowed to create a meeting',
                    });
                }
            }
        } else {
            return res.status(500).json({
                message: 'user not found',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }

}
exports.joinGroupMeeting = async (req, res, next) => {
    try {
        const { meetingId, groupId } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername,
                status: null,
            },
        });
        if (existingUsername != null) {
            const group = await pageGroup.findOne({
                where: {
                    groupId: groupId,
                }
            });
            if (group == null) {
                return res.status(500).json({
                    message: 'group not found',
                    body: req.body
                });
            }
            const isAdmin = await pageAdmin.findOne({
                where: {
                    username: userUsername,
                    pageId: group.pageId,
                    adminType: "A"
                }
            });
            if (isAdmin != null) {
                var isMeetingExist = await groupMeeting.findAll({
                    where: {
                        groupId: groupId,
                        meetingId: meetingId,
                        users: {
                            [Op.ne]: 0 // meeting did not end
                        }
                    },
                    order: [['createdAt', 'DESC']],
                    limit: 1
                });
                if (isMeetingExist[0] != null && isMeetingExist != [] && isMeetingExist.length != 0) {
                    var meetingUsers = isMeetingExist[0].users + 1;
                    await groupMeeting.update({ users: meetingUsers }, {
                        where: {
                            id: isMeetingExist[0].id,
                        }
                    })
                    return res.status(200).json({
                        message: 'joined',
                    });
                } else {
                    var isMeetingEnded = await groupMeeting.findAll({
                        where: {
                            groupId: groupId,
                            meetingId: meetingId,
                            users: 0
                        },
                        order: [['createdAt', 'DESC']],
                        limit: 1,
                    });
                    if (isMeetingEnded != null && isMeetingEnded != [] && isMeetingEnded.length != 0) {
                        return res.status(500).json({
                            message: 'meeting ended',
                        });
                    }
                    return res.status(500).json({
                        message: 'invalid meeting id',
                    });
                }
            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    var isMeetingExist = await groupMeeting.findAll({
                        where: {
                            groupId: groupId,
                            meetingId: meetingId,
                            users: {
                                [Op.ne]: 0 // meeting did not end
                            }
                        },
                        order: [['createdAt', 'DESC']],
                        limit: 1
                    });
                    if (isMeetingExist[0] != null && isMeetingExist != [] && isMeetingExist.length != 0) {
                        var meetingUsers = isMeetingExist[0].users + 1;
                        await groupMeeting.update({ users: meetingUsers }, {
                            where: {
                                id: isMeetingExist[0].id,
                            }
                        })
                        return res.status(200).json({
                            message: 'joined',
                        });
                    } else {
                        var isMeetingEnded = await groupMeeting.findAll({
                            where: {
                                groupId: groupId,
                                meetingId: meetingId,
                                users: 0
                            },
                            order: [['createdAt', 'DESC']],
                            limit: 1,
                        });
                        if (isMeetingEnded != null && isMeetingEnded != [] && isMeetingEnded.length != 0) {
                            return res.status(500).json({
                                message: 'meeting ended',
                            });
                        }
                        return res.status(500).json({
                            message: 'invalid meeting id',
                        });
                    }
                } else {
                    var groupMembers = await groupMember.findOne({
                        where: {
                            username: userUsername
                        }
                    })
                    if (groupMembers == null) {
                        return res.status(500).json({
                            message: 'you are not allowed to join this meeting ',
                            body: req.body
                        });
                    }
                    var isMeetingExist = await groupMeeting.findAll({
                        where: {
                            groupId: groupId,
                            meetingId: meetingId,
                            users: {
                                [Op.ne]: 0 // meeting did not end
                            }
                        },
                        order: [['createdAt', 'DESC']],
                        limit: 1
                    });
                    if (isMeetingExist[0] != null && isMeetingExist != [] && isMeetingExist.length != 0) {
                        var meetingUsers = isMeetingExist[0].users + 1;
                        await groupMeeting.update({ users: meetingUsers }, {
                            where: {
                                id: isMeetingExist[0].id,
                            }
                        })
                        return res.status(200).json({
                            message: 'joined',
                        });
                    } else {
                        var isMeetingEnded = await groupMeeting.findAll({
                            where: {
                                groupId: groupId,
                                meetingId: meetingId,
                                users: 0
                            },
                            order: [['createdAt', 'DESC']],
                            limit: 1,
                        });
                        if (isMeetingEnded != null && isMeetingEnded != [] && isMeetingEnded.length != 0) {
                            return res.status(500).json({
                                message: 'meeting ended',
                            });
                        }
                        return res.status(500).json({
                            message: 'invalid meeting id',
                        });
                    }
                }
            }
        } else {
            return res.status(500).json({
                message: 'user not found',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }


}
exports.leaveGroupMeeting = async (req, res, next) => {
    try {
        const { meetingId, groupId } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername != null) {
            const group = await pageGroup.findOne({
                where: {
                    groupId: groupId,
                }
            });
            if (group == null) {
                return res.status(500).json({
                    message: 'group not found',
                    body: req.body
                });
            }
            const isAdmin = await pageAdmin.findOne({
                where: {
                    username: userUsername,
                    pageId: group.pageId,
                    adminType: "A"
                }
            });
            if (isAdmin != null) {
                var isMeetingExist = await groupMeeting.findAll({
                    where: {
                        groupId: groupId,
                        meetingId: meetingId,
                        users: {
                            [Op.ne]: 0 // meeting did not end
                        }
                    },
                    order: [['createdAt', 'DESC']],
                    limit: 1
                });
                if (isMeetingExist[0] != null && isMeetingExist != [] && isMeetingExist.length != 0) {
                    var meetingUsers = isMeetingExist[0].users - 1;
                    await groupMeeting.update({ users: meetingUsers }, {
                        where: {
                            id: isMeetingExist[0].id,
                        }
                    })
                    return res.status(200).json({
                        message: 'leaved',
                    });
                } else {
                    var isMeetingEnded = await groupMeeting.findAll({
                        where: {
                            groupId: groupId,
                            meetingId: meetingId,
                            users: 0
                        },
                        order: [['createdAt', 'DESC']],
                        limit: 1,
                    });
                    if (isMeetingEnded != null && isMeetingEnded != [] && isMeetingEnded.length != 0) {
                        return res.status(500).json({
                            message: 'meeting ended',
                        });
                    }
                    return res.status(500).json({
                        message: 'invalid meeting id',
                    });
                }
            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    var isMeetingExist = await groupMeeting.findAll({
                        where: {
                            groupId: groupId,
                            meetingId: meetingId,
                            users: {
                                [Op.ne]: 0 // meeting did not end
                            }
                        },
                        order: [['createdAt', 'DESC']],
                        limit: 1
                    });
                    if (isMeetingExist[0] != null && isMeetingExist != [] && isMeetingExist.length != 0) {
                        var meetingUsers = isMeetingExist[0].users - 1;
                        await groupMeeting.update({ users: meetingUsers }, {
                            where: {
                                id: isMeetingExist[0].id,
                            }
                        })
                        return res.status(200).json({
                            message: 'leaved',
                        });
                    } else {
                        var isMeetingEnded = await groupMeeting.findAll({
                            where: {
                                groupId: groupId,
                                meetingId: meetingId,
                                users: 0
                            },
                            order: [['createdAt', 'DESC']],
                            limit: 1,
                        });
                        if (isMeetingEnded != null && isMeetingEnded != [] && isMeetingEnded.length != 0) {
                            return res.status(500).json({
                                message: 'meeting ended',
                            });
                        }
                        return res.status(500).json({
                            message: 'invalid meeting id',
                        });
                    }
                } else {
                    var isMeetingExist = await groupMeeting.findAll({
                        where: {
                            groupId: groupId,
                            meetingId: meetingId,
                            users: {
                                [Op.ne]: 0 // meeting did not end
                            }
                        },
                        order: [['createdAt', 'DESC']],
                        limit: 1
                    });
                    if (isMeetingExist[0] != null && isMeetingExist != [] && isMeetingExist.length != 0) {
                        var meetingUsers = isMeetingExist[0].users - 1;
                        await groupMeeting.update({ users: meetingUsers }, {
                            where: {
                                id: isMeetingExist[0].id,
                            }
                        })
                        return res.status(200).json({
                            message: 'leaved',
                        });
                    } else {
                        var isMeetingEnded = await groupMeeting.findAll({
                            where: {
                                groupId: groupId,
                                meetingId: meetingId,
                                users: 0
                            },
                            order: [['createdAt', 'DESC']],
                            limit: 1,
                        });
                        if (isMeetingEnded != null && isMeetingEnded != [] && isMeetingEnded.length != 0) {
                            return res.status(500).json({
                                message: 'meeting ended',
                            });
                        }
                        return res.status(500).json({
                            message: 'invalid meeting id',
                        });
                    }
                }
            }
        } else {
            return res.status(500).json({
                message: 'user not found',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }

}
function calculateDuration(startDateTime, endDateTime) {
    const start = moment(startDateTime);
    const end = moment(endDateTime);

    const duration = moment.duration(end.diff(start));

    const days = duration.days();
    const hours = duration.hours();
    const minutes = duration.minutes();
    const seconds = duration.seconds();

    const parts = [];

    if (days > 0) {
        parts.push(`${days}d`);
    }

    if (hours > 0) {
        parts.push(`${hours}h`);
    }

    if (minutes > 0) {
        parts.push(`${minutes}m`);
    }

    if (seconds > 0) {
        parts.push(`${seconds}s`);
    }

    return parts.join(' ');
}

exports.meetingHistory = async (req, res, next) => {
    try {
        const groupId = req.query.groupId;
        var page = req.query.page || 1;
        var pageSize = req.query.pageSize || 10;
        const offset = (page - 1) * pageSize;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername,
                status: null,
            },
        });
        if (existingUsername != null) {
            const group = await pageGroup.findOne({
                where: {
                    groupId: groupId,
                }
            });
            if (group == null) {
                return res.status(500).json({
                    message: 'group not found',
                    body: req.body
                });
            }
            const isAdmin = await pageAdmin.findOne({
                where: {
                    username: userUsername,
                    pageId: group.pageId,
                    adminType: "A"
                }
            });
            if (isAdmin != null) {
                var Meetings = await groupMeeting.findAll({
                    where: {
                        groupId: groupId,
                    },
                    limit: parseInt(pageSize),
                    offset: parseInt(offset),
                    order: [['updatedAt', 'DESC']],
                });
                if (Meetings != null) {
                    var allMeetings = await Promise.all(Meetings.map(async (meeting) => {
                        var period;
                        if (meeting.users <= 0) {
                            period = calculateDuration(meeting.createdAt, meeting.updatedAt);

                        } else {
                            period = "Meeting is taking place now"
                        }

                        return {
                            'groupId': groupId.toString(),
                            'meetingId': meeting.meetingId,
                            "startedAt": meeting.createdAt,
                            'period': period,
                        };
                    }));
                    console.log(allMeetings)
                    return res.status(200).json({
                        message: 'meetings history',
                        meetings: allMeetings
                    });
                } else {
                    return res.status(200).json({
                        message: 'no meetings found',
                    });
                }
            } else {
                const adminGroupsAndChildren = await getUserAdminGroupsAndChildren(userUsername);
                if (adminGroupsAndChildren.includes(parseInt(groupId))) {
                    var Meetings = await groupMeeting.findAll({
                        where: {
                            groupId: groupId,
                        },
                        limit: parseInt(pageSize),
                        offset: parseInt(offset),
                        order: [['updatedAt', 'DESC']],
                    });
                    if (Meetings != null) {
                        var allMeetings = await Promise.all(Meetings.map(async (meeting) => {
                            var period;
                            if (meeting.users <= 0) {
                                period = calculateDuration(meeting.createdAt, meeting.updatedAt);

                            } else {
                                period = "Meeting is taking place now"
                            }

                            return {
                                'groupId': groupId.toString(),
                                'meetingId': meeting.meetingId,
                                "startedAt": meeting.createdAt,
                                'period': period,
                            };
                        }));
                        console.log(allMeetings)
                        return res.status(200).json({
                            message: 'meetings history',
                            meetings: allMeetings
                        });
                    } else {
                        return res.status(200).json({
                            message: 'no meetings found',
                        });
                    }
                } else {
                    var groupMembers = await groupMember.findOne({
                        where: {
                            username: userUsername
                        }
                    })
                    if (groupMembers == null) {
                        return res.status(500).json({
                            message: 'you are not allowed to join this meeting ',
                            body: req.body
                        });
                    }

                    var Meetings = await groupMeeting.findAll({
                        where: {
                            groupId: groupId,
                        },
                        limit: parseInt(pageSize),
                        offset: parseInt(offset),
                        order: [['updatedAt', 'DESC']],
                    });
                    if (Meetings != null) {
                        var allMeetings = await Promise.all(Meetings.map(async (meeting) => {
                            var period;
                            if (meeting.users <= 0) {
                                period = calculateDuration(meeting.createdAt, meeting.updatedAt);

                            } else {
                                period = "Meeting is taking place now"
                            }

                            return {
                                'groupId': groupId.toString(),
                                'meetingId': meeting.meetingId,
                                "startedAt": meeting.createdAt,
                                'period': period,
                            };
                        }));
                        console.log(allMeetings)
                        return res.status(200).json({
                            message: 'meetings history',
                            meetings: allMeetings
                        });
                    } else {
                        return res.status(200).json({
                            message: 'no meetings found',
                        });
                    }
                }
            }
        } else {
            return res.status(500).json({
                message: 'user not found',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }


}