const crypto = require("crypto");

class CryptoUtils {
    static decrypt(data) {
        let decrypted = Buffer.alloc(data.length);
        for (let i = 0; i < data.length; i++) {
            decrypted[i] = data[i] ^ 0x37;
        }
        return decrypted;
    }

    static md5(str) {
        return crypto.createHash("md5").update(str).digest("hex");
    }

    static generateSessions(password) {
        const singleMD5 = this.md5(password);
        const doubleMD5 = this.md5(singleMD5);
        return { singleMD5, doubleMD5 };
    }
}

module.exports = CryptoUtils;
