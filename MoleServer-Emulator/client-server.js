const http = require('http');
const fs = require('fs').promises;
const path = require('path');
const url = require('url');

const PORT = 3000;

const mimeTypes = {
    '.html': 'text/html',
    '.js': 'text/javascript',
    '.css': 'text/css',
    '.json': 'application/json',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.gif': 'image/gif',
    '.swf': 'application/x-shockwave-flash',
    '.ico': 'image/x-icon',
    'default': 'application/octet-stream'
};

const server = http.createServer(async (req, res) => {
    let pathname, filePath, extname;
    try {
        const parsedUrl = url.parse(req.url);
        pathname = parsedUrl.pathname === '/' ? '/index.html' : parsedUrl.pathname;
        filePath = path.join(__dirname, '..', pathname);
        extname = path.extname(filePath);
        const contentType = (mimeTypes[extname] || mimeTypes['default']) + '; charset=utf-8';
        const content = await fs.readFile(filePath);
        res.writeHead(200, { 
            'Content-Type': contentType,
            'Content-Length': content.length
        });
        res.end(content);
    } catch (err) {
        if (err.code === 'ENOENT') {
            const remoteUrl = `http://mole.61.com.tw${pathname}`;
            console.log(`[Proxy] Fetching from remote: ${remoteUrl}`);
            
            const client = remoteUrl.startsWith('https') ? require('https') : require('http');
            client.get(remoteUrl, (remoteRes) => {
                if (remoteRes.statusCode === 200) {
                    const extname = path.extname(filePath);
                    const contentType = remoteRes.headers['content-type'] || (mimeTypes[extname] || mimeTypes['default']);
                    const headers = { 'Content-Type': contentType };
                    if (remoteRes.headers['content-length']) {
                        headers['Content-Length'] = remoteRes.headers['content-length'];
                    }
                    res.writeHead(200, headers);
                    
                    const dir = path.dirname(filePath);
                    fs.mkdir(dir, { recursive: true }).then(() => {
                        const fileStream = require('fs').createWriteStream(filePath);
                        remoteRes.pipe(fileStream);
                    }).catch(e => console.error(e));
                    
                    remoteRes.pipe(res);
                } else {
                    console.log(`[HTTP ${remoteRes.statusCode}] Remote Error: ${remoteUrl}`);
                    res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
                    res.end('404 找不到檔案');
                }
            }).on('error', (fetchErr) => {
                console.error(`[Proxy Error] ${fetchErr}`);
                res.writeHead(500);
                res.end(`伺服器錯誤`);
            });
        } else {
            console.error(`伺服器錯誤: ${err}`);
            res.writeHead(500);
            res.end(`伺服器錯誤`);
        }
    }
});
server.listen(PORT, () => {
    console.log(`伺服器正在 http://localhost:${PORT} 上運行`);
}); 