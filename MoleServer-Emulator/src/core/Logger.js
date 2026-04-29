
class Logger {
    static log(type, message) {
        const time = new Date().toLocaleTimeString();
        switch (type) {
            case "INFO": console.log(`\x1b[34m[INFO] ${message}\x1b[0m`); break; // Blue
            case "ERROR": console.log(`\x1b[31m[ERROR] ${message}\x1b[0m`); break; // Red
            case "PACKET": console.log(`\x1b[90m[PACKET] ${message}\x1b[0m`); break; // Gray
            case "DEBUG": console.log(`\x1b[35m[DEBUG] ${message}\x1b[0m`); break; // Magenta
            case "ACTION": console.log(`\x1b[32m[ACTION] ${message}\x1b[0m`); break; // Green
            case "RESPONSE": console.log(`\x1b[36m[RESPONSE] ${message}\x1b[0m`); break; // Cyan
            case "CHAT": console.log(`\x1b[33m[CHAT] ${message}\x1b[0m`); break; // Yellow
            default: console.log(`[${type}] ${message}`); break;
        }
        
        try {
            require('fs').appendFileSync(require('path').join(__dirname, '../../server_debug_log.txt'), `[${time}] [${type}] ${message}\n`);
        } catch(e) {}
    }
}

module.exports = Logger;
