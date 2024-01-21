const Sequelize = require('sequelize');
const sequelize = require('../util/database');
const User = require('./user');
const sentConnection = require('./sentConnection');
const connections = require('./connections');
const post = require('./post');
const like = require('./like');
const comment = require('./comment');
const notifications = require("../models/notifications");
const messages = require("../models/messages");
const pages = require("./pages");
const pageAdmin = require("./pageAdmin");
const pageFollower = require("./pageFollower");
const bcrypt = require('bcrypt');
const pageJobs = require('./pageJobs');
const jobApplication = require('./jobApplication');
const userTasks = require('./userTasks');
const systemFields = require('./systemFields');
const pageGroup = require('./pageGroup');
const pageEmployees = require('./pageEmployees');
const groupAdmin = require('./groupAdmin');
const groupMember = require('./groupMember');
const groupMessage = require('./groupMessage');
const userCalender = require('./userCalender');



var iLimit = 80;
var systemFieldsList = ['Life Sciences',
    'Biology Biotechnology',
    'mathematics',
    'Mathematics and Data Science',
    'Statistics',
    'Physics',
    'Physics and electronics minor',
    'Chemistry',
    'Applied Chemistry',
    'Arabic language and its literature',
    'English language and literature',
    'American Studies',
    'French language',
    'Tourism and Antiquities',
    'Jurisprudence and Legislation',
    'Religion basics',
    'Sharia and Islamic banking',
    'lower basic stage teacher',
    'Upper Basic Stage Teacher_Teaching Mathematics',
    'Upper Basic Stage Teacher_Science Education',
    'Higher basic stage teacher - teaching Arabic language',
    'Upper Basic Stage Teacher_English Language Teaching',
    'Upper Basic Stage Teacher - Social Studies Teaching',
    'Upper Basic Stage Teacher_Technology Education',
    'physical education',
    'Sports training',
    'Physical Education - Sports Training',
    'Diploma in Educational Qualification',
    'civil engineering',
    'Geomatics Engineering',
    'architecture',
    'Construction Engineering',
    'Urban Planning Engineering',
    'Planning Engineering and City Technology',
    'mechanical engineering',
    'Chemical Engineering',
    'the industrial engineering',
    'Computer Engineering',
    'electrical engineering',
    'Communications Engineering',
    'Mechatronics Engineering',
    'Energy and Environmental Engineering',
    'Materials Engineering',
    'Computer science',
    'Computer Science in the Job Market',
    'Management Information Systems',
    'Computer Information Systems',
    'Networks and Information Security',
    'Biomedical Sciences Track',
    'Human Medicine',
    'Remedial Biomedical Sciences',
    'the pharmacy',
    'Pharmacist',
    'optics',
    'Nursing',
    'Midwifery',
    'Medical laboratory sciences',
    'Medical Imaging',
    'Hearing and speech sciences',
    'natural therapy',
    'cardiac perfusion',
    'Anesthesia and technical resuscitation',
    'Respiratory care',
    'Cosmetics and skin care',
    'Doctor of Dental Medicine and Surgery',
    'Health Information Management',
    'Teeth health',
    'Dental laboratory technology',
    'Economy',
    'Geography',
    'Sociology and Social Work',
    'Social Service',
    'Psychology_ Minor Psychological Counseling',
    'Written and electronic press',
    'Communication and digital media',
    'Radio and television',
    'Multimedia journalism',
    'Public Relations and Communication',
    'Accounting',
    'Business Management',
    'Major Business Administration / Minor Leadership and Innovation',
    'Banking and Finance',
    'FinTech',
    'Marketing',
    'Communication and Digital Marketing',
    'Real estate',
    'Business Intelligence',
    'Veterinary Medicine',
    'Plant production and prevention',
    'agricultural engineering',
    'Animal production and animal health',
    'Nutrition and food processing.',
    'the law',
    'Political Science',
    'Political Sciences and State Administration',
    'Music',
    'Interior Design (Decor)',
    'painting and photography',
    'graphic design',
    'Ceramic Art',
    'Game Design',
    'Fashion design',
    'Therapeutic Expressive Art',
    'Education, lower basic stage teacher',
    'Inclusive education and special education',
    'Kindergarten',
    'Education, Upper Basic Stage Teacher - Mathematics Education',
    'Education, Upper Basic Stage Teacher - Science Education',
    'Education, Upper Basic Stage Teacher - Teaching the Arabic Language',
    'Education, Upper Basic Stage Teacher - Teaching the English Language',
    'Education, upper basic stage teacher - teaching social studies',
    'Education, Upper Primary School Teacher - Technology Education',
    'Physical and health education',
    'Psychology - Minor Psychological Counseling',
    'Major Geography/Minor Geomatics',
    'History',
    'Major History / Minor Education',
    'Other'
];
exports.createText = async () => {


    for (let field of systemFieldsList) {
        await systemFields.create({
            Field: field
        });
    }
    await User.create({
        firstname: "Ahmad",
        lastname: "Othman",
        username: "AhmadOthman",
        email: "ahmadmajed20188@gmail.com",
        password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
        Gender: "Male",
        Fields: "Computer Engineering,Other,Computer science",
        photo: "AhmadOthmanNaN1701555844569-371932458.jpg",
        cv: "AhmadOthman-1701032805374-381183524.pdf",
        phone: "0569929734",
        dateOfBirth: "2001-05-18",
    });
    await User.create({
        firstname: "Ahmad",
        lastname: "Majed",
        username: "AhmadMajed",
        email: "ahmadmajed201999@gmail.com",
        password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
        photo: "AhmadOthmanNaN1701555844569-371932458.jpg",
        phone: "0569929734",
        dateOfBirth: "2001-05-18",
    });
    await User.create({
        firstname: "mohammad",
        lastname: "Othman",
        username: "MohammadOthman",
        email: "mohammadothman@gmail.com",
        password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
        phone: "0569929734",
        dateOfBirth: "2001-05-18",
    });
    await User.create({
        firstname: "omar",
        lastname: "mohammad",
        username: "omarmohammad",
        email: "omarmohammad@gmail.com",
        password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
        phone: "0569929734",
        dateOfBirth: "2001-05-18",
    });
    for (let i = 0; i < iLimit; i++) {
        await User.create({
            firstname: "Ahmad",
            lastname: "Othman" + i,
            username: "ahmad" + i,
            email: "ahmad" + i + "@gmail.com",
            password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
            phone: "0569929734",
            dateOfBirth: "2001-05-18",
        });
    }

    for (let i = 1; i <= 500; i++) {
        const currentDate = new Date();
        const randomDays = Math.floor(Math.random() * 50);
        currentDate.setDate(currentDate.getDate() + randomDays);
        const randomHour = Math.floor(Math.random() * 24);
        const randomMinute = Math.floor(Math.random() * 60);
        const randomSecond = Math.floor(Math.random() * 60);
        const formattedHour = String(randomHour).padStart(2, '0');
        const formattedMinute = String(randomMinute).padStart(2, '0');
        const formattedSecond = String(randomSecond).padStart(2, '0');

        await userCalender.create({
            username: "AhmadOthman",
            subject: "subject " + i,
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            date: currentDate,
            time: `${formattedHour}:${formattedMinute}:${formattedSecond}`,
        })
    }
    for (let i = 0; i < iLimit / 4; i++) {
        await sentConnection.create({
            senderUsername: "ahmad" + i,
            receiverUsername: "AhmadOthman",
            date: new Date(),
        });
        await notifications.create({
            username: "AhmadOthman",
            notificationType: 'connection',
            notificationContent: "sent you a connection request",
            notificationPointer: "ahmad" + i,
        });
    }
    for (let i = iLimit / 4; i < iLimit / 2; i++) {
        await sentConnection.create({
            senderUsername: "AhmadOthman",
            receiverUsername: "ahmad" + i,
            date: new Date(),
        });
    }
    for (let i = iLimit / 2; i < iLimit * (3 / 4); i++) {
        await connections.create({
            senderUsername: "AhmadOthman",
            receiverUsername: "ahmad" + i,
            date: new Date(),
        });
    }
    for (let i = iLimit / 2; i < iLimit * (3 / 4); i++) {
        const currentDate = new Date();
        currentDate.setSeconds(i);
        await messages.create({
            senderUsername: "AhmadOthman",
            receiverUsername: "ahmad" + i,
            text: "message from AhmadOthman",
            createdAt: currentDate,
        });
        const currentDate2 = new Date();
        currentDate2.setSeconds(i - 2);
        await messages.create({
            senderUsername: "ahmad" + i,
            receiverUsername: "AhmadOthman",
            text: "message from ahmad" + i,
            createdAt: currentDate2,
        });
    }
    for (let i = 0; i < 57; i++) {
        const currentDate = new Date();
        currentDate.setSeconds(i);
        await messages.create({
            senderUsername: "AhmadOthman",
            receiverUsername: "ahmad59",
            text: "message from AhmadOthman",
            createdAt: currentDate,
        });
        await messages.create({
            senderUsername: "AhmadOthman",
            receiverUsername: "ahmad59",
            text: "message from AhmadOthman: " + i,
            createdAt: currentDate,
        });
        const currentDate2 = new Date();
        currentDate2.setSeconds(i + 2);
        await messages.create({
            senderUsername: "ahmad59",
            receiverUsername: "AhmadOthman",
            text: "message from ahmad59: " + i,
            createdAt: currentDate2,
        });
    }
    for (let i = 0; i < iLimit; i++) {
        await post.create({
            postContent: "post " + i,
            selectedPrivacy: "Any One",
            postDate: new Date(),
            username: "AhmadOthman",
            date: new Date(),
        });
    }
    for (let i = iLimit / 2; i < iLimit * (3 / 4); i++) {
        for (let j = 1; j < iLimit; j++)
        await like.create({
                postId: j,
                username: "ahmad" + i,
            });
    }
    for (let i = iLimit / 2; i < iLimit * (3 / 4); i++) {
        for (let j = 1; j < iLimit; j++)
        await comment.create({
                postId: j,
                username: "ahmad" + i,
                commentContent: "ahmad" + i,
                Date: new Date()
            });
    }
    for (let i = 0; i < iLimit; i++) {
        for (let j = 0; j < 10; j++)
        await post.create({
                postContent: "my post : ahmad" + i + "post " + i,
                selectedPrivacy: "Any One",
                postDate: new Date(),
                username: "ahmad" + i,
                date: new Date(),
            });
    }
    for (let i = 1; i < 20; i++) {
        const pageData = {
            id: "page " + i, // Generate a unique ID
            name: "company " + i,
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            address: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            contactInfo: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            specialty: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            pageType: "public",
        };
        await pages.create(pageData);


    }
    for (let i = 1; i < 20; i++) {
        await pageAdmin.create({
            pageId: "page " + i,
            username: "AhmadOthman",
            adminType: 'A',
        });
        for (let j = 0; j < 20; j++) {
            await pageFollower.create({
                pageId: "page " + i,
                username: "ahmad" + j,
            });
        }
        for (let j = 1; j < 80; j++) {
            await post.create({
                postContent: "post " + j,
                selectedPrivacy: "Any One",
                postDate: new Date(),
                pageId: "page " + i,
            });
        }

    }
    for (let i = 1; i < 20; i++) {
        for (let j = 881 + ((i - 1) * 79); j < 960 + ((i - 1) * 79); j++) {
            for (let k = 1; k < 20; k++) {
                await like.create({
                    postId: j,
                    username: "ahmad" + k,
                });
                await comment.create({
                    postId: j,
                    username: "ahmad" + k,
                    commentContent: "ahmad" + k,
                    Date: new Date()
                });
            }

        }
    }
    for (let i = 1; i < 20; i++) {
        for (let j = 1; j < 20; j++)
        await pageJobs.create({
                pageId: "page " + i,
                title: j % 2 ? "Frontend developer " + j : "Backend developer" + j,
                interest: j % 2 ? "Frontend" : "Backend",
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                endDate: j % 3 == 0 ? new Date("2024-2-1") : new Date("2024-1-1"),
                Fields: 'Other',
            });
    }
    for (let i = 1; i < 20; i++) {
        for (let j = 1; j < 20; j++)
        await jobApplication.create({
                pageJobId: i,
                username: "ahmad" + j,
                note: j % 3 == 0 ? null : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            });
    }
    function getRandomDate(start, end) {
        return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
    }

    // Function to generate a random time
    function getRandomTime() {
        const hours = Math.floor(Math.random() * 24);
        const minutes = Math.floor(Math.random() * 60);
        return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
    }
    for (let i = 0; i < 80; i++) {
        var s = ['ToDo', 'Doing', 'Done', 'Archived'];
        const startDate = getRandomDate(new Date(2024, 1, 1), new Date(2023, 1, 6));
        const endDate = getRandomDate(startDate, new Date(2024, 2, 1));
        const startTime = getRandomTime();
        const endTime = getRandomTime();

        await userTasks.create({
            username: "AhmadOthman",
            taskName: "task " + i,
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            status: s[i % 4],
            startTime: startTime,
            startDate: startDate,
            endTime: endTime,
            endDate: endDate,
        });
    }
    await pageGroup.create({
        pageId: "page 1",
        name: "Main Group",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        memberSendMessage: true,
    })
    await pageGroup.create({
        pageId: "page 1",
        name: "Main Group2",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        memberSendMessage: true,
    })
    for (let i = 0; i < 1000; i++);
    for (let i = 2; i < 20; i++) {
        await pageGroup.create({
            pageId: "page 1",
            name: "Group " + i,
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            parentGroup: i % 2 ? i - 2 : i - 1,
            memberSendMessage: i % 2 ? true : false,
        })
    }
    for (let i = 80; i <= 500; i++) {
        await User.create({
            firstname: "Ahmad",
            lastname: "Othman" + i,
            username: "ahmad" + i,
            email: "ahmad" + i + "@gmail.com",
            password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
            phone: "0569929734",
            dateOfBirth: "2001-05-18",
        });
    }
    for (let i = 80; i <= 400; i++) {
        await pageEmployees.create({
            pageId: "page 1",
            username: "ahmad" + i,
            field: systemFieldsList[i % systemFieldsList.length],
        })
    }
    for (let i = 100; i <= 140; i++) {
        await groupMember.create({
            groupId: i % 21 ? i % 21 : 1,
            username: "ahmad" + i,
        })
    }
    for (let i = 100; i <= 140; i++) {
        await groupAdmin.create({
            groupId: i % 21 ? i % 21 : 1,
            username: "ahmad" + i,
        })
    }
    for (let i = 100; i <= 140; i++) {
        await groupMessage.create({
            groupId: i % 21 ? i % 21 : 1,
            senderUsername: "ahmad" + i,
            text: "message from ahmad" + i,
        })
    }
    for (let i = 141; i <= 500; i++) {
        await groupMember.create({
            groupId: i % 21 ? i % 21 : 1,
            username: "ahmad" + i,
        })
    }
    for (let i = 141; i <= 500; i++) {
        await groupMessage.create({
            groupId: i % 21 ? i % 21 : 1,
            senderUsername: "ahmad" + i,
            text: "message from ahmad" + i,
        })
    }
}