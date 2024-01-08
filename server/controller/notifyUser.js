const axios = require('axios');
exports.deleteNotification = async (username, notification) => { 
    try {
        const server2Url = 'http://localhost:4000';
        const response = await axios.post(`${server2Url}/userNotifications/deleteNotification`, {
            username,
            notification,
        },

            {
                headers: {
                    'Content-Type': 'application/json',
                },
                timeout: 9000,
                maxContentLength: Infinity,
            }
        );
        console.log(response.status);
        return response.status == 200 ? true : false;
    } catch (error) {
        console.error('Error notifying user:', error);
        return false;
    }
}

exports.notifyUser = async (username, notification) => {
    try {
        const server2Url = 'http://localhost:4000';
        const response = await axios.post(`${server2Url}/userNotifications/notify`, {
            username,
            notification,
        },

            {
                headers: {
                    'Content-Type': 'application/json',
                },
                timeout: 9000,
                maxContentLength: Infinity,
            }
        );
        console.log(response.status);
        return response.status == 200 ? true : false;
    } catch (error) {
        console.error('Error notifying user:', error);
        return false;
    }
};