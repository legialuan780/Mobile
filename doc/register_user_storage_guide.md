# Tài liệu lưu User khi đăng ký

## 1. Mục tiêu

Ứng dụng của bạn có chủ đề chia sẻ địa điểm học tập và học liệu. Ở màn hình đăng ký, người dùng nhập:

- Họ và tên
- Email
- Mật khẩu
- Nhập lại mật khẩu

Mục tiêu của phần đăng ký là:

- Tạo tài khoản đăng nhập bằng Firebase Authentication
- Lưu hồ sơ người dùng để dùng trong app
- Đồng bộ dữ liệu online bằng Firebase
- Hỗ trợ lưu cục bộ bằng SQLite để dùng lại khi offline hoặc tải nhanh hơn

Lưu ý:

- Trường `nhập lại mật khẩu` chỉ dùng để kiểm tra hợp lệ ở giao diện
- Không lưu trường `nhập lại mật khẩu` vào database
- Không tự lưu mật khẩu thô vào SQLite hoặc Firebase

---

## 2. Nên lưu user ở đâu?

Với yêu cầu của bạn, nên chia dữ liệu user thành 3 phần:

### 2.1. Firebase Authentication

Dùng để lưu:

- `email`
- `password` đã được Firebase mã hóa và quản lý
- `uid` của user

Vai trò:

- Xác thực tài khoản
- Đăng nhập, đăng xuất
- Quên mật khẩu
- Kiểm tra email đã xác minh hay chưa

### 2.2. Firebase Firestore hoặc Realtime Database

Dùng để lưu hồ sơ user mở rộng, ví dụ:

- `uid`
- `fullName`
- `email`
- `avatarUrl`
- `createdAt`
- `updatedAt`
- `role`
- `isActive`

Vai trò:

- Lưu thông tin hồ sơ để hiển thị trong app
- Dễ mở rộng sau này cho bài đăng, địa điểm, học liệu, bình luận, yêu thích

Khuyến nghị:

- Nếu app mới và cần dữ liệu dạng document, nên dùng `Cloud Firestore`

### 2.3. SQLite

Dùng để lưu bản sao cục bộ của user, ví dụ:

- `uid`
- `full_name`
- `email`
- `avatar_url`
- `last_login_at`

Vai trò:

- Hiển thị nhanh khi mở app
- Hỗ trợ offline
- Cache hồ sơ người dùng hiện tại

SQLite không nên là nơi lưu thông tin xác thực chính.

---

## 3. Luồng lưu user khi đăng ký

Khi người dùng bấm `Đăng ký`, luồng nên đi như sau:

### Bước 1. Validate dữ liệu ở giao diện

Kiểm tra:

- Họ tên không được rỗng
- Email đúng định dạng
- Mật khẩu đủ mạnh
- Mật khẩu nhập lại phải trùng với mật khẩu

Nếu sai thì báo lỗi ngay trên form.

### Bước 2. Tạo tài khoản bằng Firebase Authentication

Gửi:

- `email`
- `password`

Kết quả nhận được:

- `uid`
- `email`

Đây là định danh chính của user trong toàn bộ hệ thống.

### Bước 3. Cập nhật hồ sơ cơ bản trên Firebase

Sau khi tạo tài khoản thành công, lưu hồ sơ user lên Firebase database với `uid` làm khóa chính.

Ví dụ cấu trúc document:

```json
{
  "uid": "abc123",
  "fullName": "Nguyen Van A",
  "email": "a@gmail.com",
  "avatarUrl": "",
  "role": "user",
  "isActive": true,
  "createdAt": "server timestamp",
  "updatedAt": "server timestamp"
}
```

Gợi ý:

- Collection: `users`
- Document id: chính là `uid`

Ví dụ:

- `users/abc123`

### Bước 4. Lưu bản cache vào SQLite

Sau khi lưu thành công trên Firebase, lưu tiếp 1 bản local vào SQLite.

Mục đích:

- Lần sau mở app có thể đọc nhanh hồ sơ hiện tại
- Nếu mất mạng vẫn còn dữ liệu cơ bản để hiển thị

### Bước 5. Gửi email xác minh

Vì bạn đang có luồng `quên mật khẩu` và auth bằng email, nên nên gửi email xác minh ngay sau đăng ký.

### Bước 6. Điều hướng người dùng

Có 2 cách phổ biến:

- Chuyển về màn hình đăng nhập và yêu cầu xác minh email
- Hoặc vào app nhưng chặn một số chức năng cho đến khi email được xác minh

Với app sinh viên hoặc cộng đồng học tập, cách 1 thường dễ kiểm soát hơn.

---

## 4. Dữ liệu nào cần lưu?

### 4.1. Dữ liệu từ form đăng ký

Người dùng nhập:

- `fullName`
- `email`
- `password`
- `confirmPassword`

### 4.2. Dữ liệu thực sự cần lưu

Nên lưu:

- `uid`
- `fullName`
- `email`
- `avatarUrl`
- `createdAt`
- `updatedAt`
- `isActive`

Không nên lưu:

- `confirmPassword`
- `password` dạng thô

---

## 5. Gợi ý theo đúng cấu trúc thư mục của bạn

Bạn đang dùng cấu trúc:

- `app`
- `models`
- `utils`
- `repositories`
- `services`
- `views`
- `widgets`

Có thể phân chia trách nhiệm như sau:

## 5.1. `models`

Tạo model user, ví dụ:

- `app_user.dart`

Model này nên chứa:

- `uid`
- `fullName`
- `email`
- `avatarUrl`
- `emailVerified`
- `createdAt`

## 5.2. `views`

Màn hình đăng ký chỉ làm nhiệm vụ:

- Hiển thị form
- Validate dữ liệu
- Gọi service đăng ký
- Hiển thị thông báo thành công hoặc lỗi

`confirmPassword` chỉ nên tồn tại ở tầng `view`.

## 5.3. `services`

`auth_service.dart` nên chịu trách nhiệm:

- Nhận dữ liệu từ form
- Gọi repository để tạo tài khoản Firebase Auth
- Gọi repository để lưu profile user
- Gọi repository SQLite để cache local
- Trả kết quả cho giao diện

## 5.4. `repositories`

Nên tách thành 3 repository:

- `auth_repository.dart`
  - làm việc với Firebase Auth
- `user_repository.dart`
  - làm việc với Firestore hoặc Realtime Database
- `local_user_repository.dart`
  - làm việc với SQLite

Như vậy code sẽ dễ bảo trì hơn so với dồn toàn bộ vào một file auth.

## 5.5. `utils`

Chứa:

- Validator email
- Validator password
- Validator confirm password
- Hàm xử lý thông báo lỗi

---

## 6. Thiết kế bảng SQLite đề xuất

Bạn có thể tạo bảng local như sau:

### Bảng `users`

Các cột đề xuất:

- `uid` TEXT PRIMARY KEY
- `full_name` TEXT NOT NULL
- `email` TEXT NOT NULL
- `avatar_url` TEXT
- `email_verified` INTEGER NOT NULL DEFAULT 0
- `created_at` TEXT
- `last_login_at` TEXT

Mục đích:

- Chỉ cache thông tin cần hiển thị
- Không lưu password trong SQLite

---

## 7. Thiết kế collection Firebase đề xuất

### Collection `users`

Document:

- `users/{uid}`

Field đề xuất:

- `uid`
- `fullName`
- `email`
- `avatarUrl`
- `emailVerified`
- `role`
- `isActive`
- `createdAt`
- `updatedAt`

Nếu sau này mở rộng app, user còn có thể có:

- `favoritePlacesCount`
- `sharedMaterialsCount`
- `savedPostsCount`

---

## 8. Luồng xử lý lỗi cần nghĩ trước

Khi đăng ký có thể gặp các lỗi:

- Email đã tồn tại
- Email sai định dạng
- Mật khẩu quá yếu
- Mất kết nối mạng
- Tạo Firebase Auth thành công nhưng lưu hồ sơ Firestore thất bại

Khuyến nghị:

- Ưu tiên tạo tài khoản ở Firebase Auth trước
- Nếu bước lưu profile thất bại, cần báo lỗi rõ cho người dùng
- Có thể thêm cơ chế thử lưu lại profile khi user đăng nhập lần đầu

---

## 9. Quy trình đăng ký đề xuất cho dự án này

Đây là quy trình phù hợp với app hiện tại của bạn:

1. User nhập `họ tên`, `email`, `mật khẩu`, `nhập lại mật khẩu`
2. `view` kiểm tra hợp lệ
3. `auth_service` gọi `auth_repository` tạo tài khoản bằng Firebase Auth
4. Lấy `uid` vừa tạo
5. `user_repository` lưu hồ sơ user lên Firestore
6. `local_user_repository` lưu cache user vào SQLite
7. Gửi email xác minh
8. Thông báo đăng ký thành công
9. Chuyển sang màn hình đăng nhập

---

## 10. Kết luận

Với màn hình đăng ký của bạn:

- `email` và `password` nên lưu qua Firebase Authentication
- `họ tên` và thông tin hồ sơ nên lưu ở Firestore
- SQLite chỉ nên dùng để cache local
- `nhập lại mật khẩu` không lưu vào bất kỳ database nào

Nếu làm theo hướng này, kiến trúc sẽ rõ ràng, an toàn và dễ mở rộng cho các tính năng tiếp theo như:

- chia sẻ địa điểm học tập
- đăng học liệu
- lưu địa điểm yêu thích
- quản lý hồ sơ cá nhân

---

## 11. Hướng triển khai tiếp theo

Sau tài liệu này, bước tiếp theo nên là:

1. Chuẩn hóa model `AppUser`
2. Thiết kế collection `users` trên Firebase
3. Thiết kế bảng `users` trong SQLite
4. Cập nhật luồng `register` trong `auth_service`
5. Bổ sung kiểm tra `confirmPassword` ở màn hình đăng ký

Khi bạn cần, mình có thể làm tiếp cho bạn một tài liệu thứ hai:

- sơ đồ luồng đăng ký
- thiết kế model `AppUser`
- hoặc code từng phần theo đúng cấu trúc thư mục của bạn
