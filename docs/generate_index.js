const fs = require('fs');

// Read the list of folders in the current directory
const folders = fs.readdirSync('.', { withFileTypes: true })
  .filter(dirent => dirent.isDirectory())
  .map(dirent => dirent.name)
  .filter(dirname => dirname != "latest")
  .sort((a, b) => {
    const aVersion = getVersionNumber(a);
    const bVersion = getVersionNumber(b);
    if (aVersion === bVersion) {
      return a.localeCompare(b, undefined, { numeric: true, sensitivity: 'base' });
    } else {
      return compareVersions(aVersion, bVersion);
    }
  });

// Helper function to extract the version number from a folder name
function getVersionNumber(folder) {
  const matches = folder.match(/^(\d+\.\d+\.\d+)/);
  return matches ? matches[1] : '';
}

// Helper function to compare two version numbers
function compareVersions(a, b) {
  const aParts = a.split('.').map(part => parseInt(part, 10));
  const bParts = b.split('.').map(part => parseInt(part, 10));
  for (let i = 0; i < Math.min(aParts.length, bParts.length); i++) {
    if (aParts[i] < bParts[i]) {
      return -1;
    } else if (aParts[i] > bParts[i]) {
      return 1;
    }
  }
  return aParts.length - bParts.length;
}

// Construct the HTML content
let html = '<!DOCTYPE html>\n<html>\n<head>\n<title>DLDirectSDK for iOS</title>\n</head>\n<body>\n<h1>API Reference</h1>\n<ul>\n';
for (let i = 0; i < folders.length; i++) {
  const folder = folders[i];
  html += `<li><a href="${folder}/documentation/dldirectsdk">${folder}</a></li>\n`;
}
html += '</ul>\n</body>\n</html>';

// Write the HTML content to a file named "folder-list.html"
fs.writeFileSync('index.html', html);
