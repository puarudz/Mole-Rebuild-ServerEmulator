# Mole Rebuild - Server Emulator

Chào mừng bạn đến với dự án **Mole Rebuild - Server Emulator**. Đây là dự án giả lập máy chủ (Server Emulator) cho tựa game Mole (Vương Quốc Chuột Chũi), được phát triển bằng Node.js.

## 🚀 Tính năng nổi bật
- Giả lập máy chủ TCP cho client Mole 51.
- Hỗ trợ kết nối, đăng nhập và tương tác cơ bản trong game.
- Quản lý dữ liệu người chơi, túi đồ, bản đồ qua cơ sở dữ liệu MySQL.

## 🛠 Yêu cầu hệ thống
Để chạy được server, bạn cần cài đặt các phần mềm sau trên máy tính:
1. **Node.js**: (Khuyến nghị bản LTS mới nhất) - [Tải tại đây](https://nodejs.org/).
2. **MySQL Server**: (Hoặc các phần mềm giả lập server như XAMPP, WAMP, Laragon) để chạy cơ sở dữ liệu MySQL ở cổng mặc định `3306`.

## 📥 Hướng dẫn cài đặt

### Bước 1: Thiết lập Cơ sở dữ liệu (Database)
1. Bật MySQL Server của bạn lên.
2. Mở công cụ quản lý MySQL (như phpMyAdmin, Navicat, DBeaver,...).
3. Tạo một database mới có tên là `mole51`.
4. Import file `mole51.sql` nằm trong thư mục `MoleServer-Emulator` vào database vừa tạo.
5. *(Tùy chọn)* Nếu MySQL của bạn có mật khẩu cho user `root` hoặc dùng cấu hình khác, hãy mở file `MoleServer-Emulator/src/config/database.js` và chỉnh sửa lại thông tin cho phù hợp:
   ```javascript
   const pool = mysql.createPool({
       host: 'localhost',
       port: 3306,
       user: 'root',
       password: 'mật-khẩu-của-bạn', // <-- Thay đổi ở đây nếu cần
       database: 'mole51',
       // ...
   });
   ```

### Bước 2: Cài đặt và khởi chạy Server
1. Mở Terminal (hoặc Command Prompt, PowerShell).
2. Di chuyển vào thư mục chứa server:
   ```bash
   cd MoleServer-Emulator
   ```
3. Cài đặt các thư viện (dependencies) cần thiết:
   ```bash
   npm install
   ```
4. Khởi chạy server:
   ```bash
   node app.js
   ```
5. Nếu thấy dòng log thông báo `Mole TCP Server khởi động tại 0.0.0.0:7777`, tức là server của bạn đã chạy thành công!

### Bước 3: Thiết lập Client
1. Tải Client (đã được bypass kết nối tới localhost) tại link: [Tải Client Mole-Bypass](https://drive.google.com/file/d/1UKmulGXEiS0SNMB3hrXn9MOfnI7qs3sU/view?usp=sharing).
2. Giải nén thư mục Client vừa tải.
3. Vì game sử dụng Flash, bạn cần sử dụng phần mềm giả lập **Ruffle** để chạy file `Client.swf`:
   - Tải Ruffle tại: [https://ruffle.rs/#downloads](https://ruffle.rs/#downloads) (Chọn bản Desktop/Windows).
   - Giải nén Ruffle và mở ứng dụng `ruffle.exe`.
   - Bấm **Open** (hoặc kéo thả) và chọn file `Client.swf` nằm trong thư mục Client đã giải nén ở bước 2.
4. Đăng nhập và bắt đầu trải nghiệm game!

---

## 💖 Donate ủng hộ tác giả
Nếu bạn thấy dự án này thú vị và muốn ủng hộ công sức phát triển, bạn có thể donate cho tác giả thông qua mã QR dưới đây. Mọi sự ủng hộ dù lớn hay nhỏ đều là động lực to lớn để dự án tiếp tục được duy trì và hoàn thiện hơn!

<img src="./stk.jpg" alt="Donate QR Code" width="250" />

Cảm ơn bạn đã quan tâm và đồng hành cùng dự án! Chúc bạn có những giây phút trải nghiệm vui vẻ!
