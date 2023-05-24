// ==UserScript==
// @name         Numeric Value Popup
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Displays a pop-up window when the numeric value 12312312 is found on a website. Only closes when the "Acknowledge" button is clicked.
// @author       Your Name
// @match        https://example.com/*  // Replace with the website URL where you want to search for the value
// @grant        GM_addStyle
// ==/UserScript==

(function() {
    'use strict';

    // Search for the numeric value 12312312
    var numericValue = 12312312;  // Change this value if needed
    var pageContent = document.body.innerHTML;

    if (pageContent.includes(numericValue)) {
        displayPopup();
    }

    // Display the pop-up window
    function displayPopup() {
        var popupContainer = document.createElement('div');
        popupContainer.id = 'numericValuePopup';

        var popupMessage = document.createElement('p');
        popupMessage.textContent = 'Read important information';

        var acknowledgeButton = document.createElement('button');
        acknowledgeButton.textContent = 'Acknowledge';
        acknowledgeButton.addEventListener('click', closePopup);

        popupContainer.appendChild(popupMessage);
        popupContainer.appendChild(acknowledgeButton);
        document.body.appendChild(popupContainer);

        // Styling for the pop-up window
        GM_addStyle(`
            #numericValuePopup {
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background-color: white;
                padding: 20px;
                border: 1px solid black;
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
                z-index: 9999;
            }
        `);
    }

    // Close the pop-up window
    function closePopup() {
        var popupContainer = document.getElementById('numericValuePopup');
        popupContainer.remove();
    }
})();
