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
const pageGroup= require('./pageGroup');



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
for (let field of systemFieldsList) {
    systemFields.create({
        Field:field
    });
}
User.create({
    firstname: "Ahmad",
    lastname: "Othman",
    username: "AhmadOthman",
    email: "ahmadmajed20188@gmail.com",
    password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
    Gender:"Male",
    Fields: "Computer Engineering,Other,Computer science",
    photo: "AhmadOthmanNaN1700761827122-645531203.jpg",
    cv: "AhmadOthman-1701032805374-381183524.pdf",
    phone: "0569929734",
    dateOfBirth: "2001-05-18",
});
User.create({
    firstname: "Ahmad",
    lastname: "Majed",
    username: "AhmadMajed",
    email: "ahmadmajed201999@gmail.com",
    password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
    photo: "AhmadOthmanNaN1700761827122-645531203.jpg",
    phone: "0569929734",
    dateOfBirth: "2001-05-18",
});
User.create({
    firstname: "mohammad",
    lastname: "Othman",
    username: "MohammadOthman",
    email: "mohammadothman@gmail.com",
    password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
    phone: "0569929734",
    dateOfBirth: "2001-05-18",
});
User.create({
    firstname: "omar",
    lastname: "mohammad",
    username: "omarmohammad",
    email: "omarmohammad@gmail.com",
    password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
    phone: "0569929734",
    dateOfBirth: "2001-05-18",
});
for (let i = 0; i < iLimit; i++) {
    User.create({
        firstname: "Ahmad",
        lastname: "Othman"+i,
        username: "ahmad" + i,
        email: "ahmad" + i + "@gmail.com",
        password: "$2b$10$onKV7UBFIShgI466b6bd2O4qAtMFFtoObF.QQrJcO7l4lNoBmFMxq",
        phone: "0569929734",
        dateOfBirth: "2001-05-18",
    });
}
for (let i = 0; i < iLimit / 4; i++) {
    sentConnection.create({
        senderUsername: "ahmad" + i,
        receiverUsername: "AhmadOthman",
        date: new Date(),
    });
    notifications.create({
        username: "AhmadOthman",
        notificationType: 'connection',
        notificationContent: "sent you a connection request",
        notificationPointer: "ahmad" + i,
    });
}
for (let i = iLimit / 4; i < iLimit / 2; i++) {
    sentConnection.create({
        senderUsername: "AhmadOthman",
        receiverUsername: "ahmad" + i,
        date: new Date(),
    });
}
for (let i = iLimit / 2; i < iLimit * (3 / 4); i++) {
    connections.create({
        senderUsername: "AhmadOthman",
        receiverUsername: "ahmad" + i,
        date: new Date(),
    });
}
for (let i = iLimit / 2; i < iLimit * (3 / 4); i++) {
    const currentDate = new Date();
    currentDate.setSeconds(i);
    messages.create({
        senderUsername: "AhmadOthman",
        receiverUsername: "ahmad" + i,
        text: "message from AhmadOthman",
        createdAt: currentDate,
    });
    const currentDate2 = new Date();
    currentDate2.setSeconds(i - 2);
    messages.create({
        senderUsername: "ahmad" + i,
        receiverUsername: "AhmadOthman",
        text: "message from ahmad" + i,
        createdAt: currentDate2,
    });
}
for (let i = 0; i < 57; i++) {
    const currentDate = new Date();
    currentDate.setSeconds(i);
    messages.create({
        senderUsername: "AhmadOthman",
        receiverUsername: "ahmad59",
        text: "message from AhmadOthman",
        createdAt: currentDate,
    });
    messages.create({
        senderUsername: "AhmadOthman",
        receiverUsername: "ahmad59",
        text: "message from AhmadOthman: " + i,
        createdAt: currentDate,
    });
    const currentDate2 = new Date();
    currentDate2.setSeconds(i + 2);
    messages.create({
        senderUsername: "ahmad59",
        receiverUsername: "AhmadOthman",
        text: "message from ahmad59: " + i,
        createdAt: currentDate2,
    });
}
for (let i = 0; i < iLimit; i++) {
    post.create({
        postContent: "post " + i,
        selectedPrivacy: "Any One",
        postDate: new Date(),
        username: "AhmadOthman",
        date: new Date(),
    });
}
for (let i = iLimit / 2; i < iLimit * (3 / 4); i++) {
    for (let j = 1; j < iLimit; j++)
        like.create({
            postId: j,
            username: "ahmad" + i,
        });
}
for (let i = iLimit / 2; i < iLimit * (3 / 4); i++) {
    for (let j = 1; j < iLimit; j++)
        comment.create({
            postId: j,
            username: "ahmad" + i,
            commentContent: "ahmad" + i,
            Date: new Date()
        });
}
for (let i = 0; i < iLimit; i++) {
    for (let j = 0; j < 10; j++)
        post.create({
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
    pages.create(pageData);


}
for (let i = 1; i < 20; i++) {
    pageAdmin.create({
        pageId: "page " + i,
        username: "AhmadOthman",
        adminType: 'A',
    });
    for (let j = 0; j < 20; j++) {
        pageFollower.create({
            pageId: "page " + i,
            username: "ahmad" + j,
        });
    }
    for (let j = 1; j < 80; j++) {
        post.create({
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
            like.create({
                postId: j,
                username: "ahmad" + k,
            });
            comment.create({
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
        pageJobs.create({
            pageId: "page " + i,
            title: j % 2 ? "Frontend developer " + j : "Backend developer" + j,
            interest: j % 2 ? "Frontend" : "Backend",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            endDate: j % 3 == 0 ? new Date("2024-2-1") : new Date("2024-1-1"),
            Fields:'Other',
        });
}
for (let i = 1; i < 20; i++) {
    for (let j = 1; j < 20; j++)
        jobApplication.create({
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

    userTasks.create({
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
pageGroup.create({
    pageId: "page 1",
    name: "Main Group",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    memberSendMessage:true,
})
pageGroup.create({
    pageId: "page 1",
    name: "Main Group2",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    memberSendMessage:true,
})
for(let i= 0;i<1000;i++);
for(let i = 2;i<20 ; i++){
    pageGroup.create({
        pageId: "page 1",
        name: "Group " + i,
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        parentGroup: i%2 ? i-2 : i-1,
        memberSendMessage:i%2 ? true :false,
    })
}