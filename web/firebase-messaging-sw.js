// firebase-messaging-sw.js
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

// Your Firebase config
const firebaseConfig = {
    apiKey: "AIzaSyDxQIIWI3cXsXyQtOhfTZ5NfnE-rIXPqNI",
    authDomain: "quick-bee-app.firebaseapp.com",
    projectId: "quick-bee-app",
    storageBucket: "quick-bee-app.firebasestorage.app",
    messagingSenderId: "699843477834",
    appId: "1:699843477834:web:b68340aee753561e76c1b3",
    measurementId: "G-GFR3NV7859"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

// Retrieve Firebase Messaging instance
const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log('Received background message:', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/firebase-logo.png' // Optional: add an icon
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});