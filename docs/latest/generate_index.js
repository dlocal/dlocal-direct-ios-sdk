const fs = require('fs');
const path = require('path');

function generateRedirectHTML(version) {
    const htmlContent = `<!DOCTYPE html>
    <html>
    <head>
        <title>Redirecting...</title>
        <script>
            window.onload = function() {
                window.location.href = "https://dlocal.github.io/dlocal-direct-ios-sdk/${version}/documentation/dldirectsdk";
            };
        </script>
    </head>
    <body>
        <h1>Redirecting...</h1>
        <p>If you are not redirected automatically, <a href="https://dlocal.github.io/dlocal-direct-ios-sdk/${version}/documentation/dldirectsdk">click here</a>.</p>
    </body>
    </html>`;

    const fileName = `index.html`;
    const filePath = path.join(__dirname, fileName);

    fs.writeFile(filePath, htmlContent, (err) => {
        if (err) {
            console.error('Error writing HTML file:', err);
        } else {
            console.log(`HTML file (${fileName}) with redirect to version ${version} has been generated successfully.`);
        }
    });
}

// Read the version from command-line argument
const version = process.argv[2];

if (!version) {
    console.error('Please provide a version number as a command-line argument.');
} else {
    generateRedirectHTML(version);
}
