# OverlayFS RW

<p align="center">
  <a href="https://github.com/Zenlua/Overlayfs/actions/workflows/build.yml">
    <img src="https://github.com/Zenlua/Overlayfs/actions/workflows/build.yml/badge.svg" alt="Build module">
  </a>
  <a href="https://github.com/Zenlua/Overlayfs/releases">
    <img src="https://img.shields.io/github/v/release/Zenlua/Overlayfs?color=blue&logo=github" alt="Latest Release">
  </a>
</p>

Một mô-đun hỗ trợ mount **OverlayFS** với quyền Đọc/Ghi (RW) dành cho Android. Giải pháp tối ưu và cực kỳ cần thiết cho các thiết bị sử dụng phân vùng định dạng **`erofs`**.

---

## 📌 Phím tắt nhanh

*   🚀 **[Tải về bản mới nhất (Release)](https://github.com/Zenlua/Overlayfs/releases)**
*   📜 **[Nhật ký thay đổi (Changelog)](./module/log.md)**

---

## ⚡ Yêu cầu hệ thống

*   Thiết bị đã cài đặt **Magisk**, **KernelSU (KSU)** hoặc các trình quản lý Root tương đương.
*   Khuyên dùng cho các phân vùng hệ thống dạng **`erofs`**.

---

## 🛠 Phân loại phiên bản

### 1. Phiên bản Tiêu chuẩn (Basic Version)

*   **Ẩn root:** Không hỗ trợ sẵn (tuy nhiên có thể chuyển đổi thủ công sang ẩn root).
*   **Cơ chế mount:** Chỉ hỗ trợ **Mount Overlay**, không hỗ trợ Mount Bind.
*   **Cấu hình:** Có thể chỉnh sửa trực tiếp cấu hình tại đường dẫn:
    ```path
    /data/adb/overlayfs
    ```
*   **Dung lượng:** Phụ thuộc hoàn toàn vào dung lượng trống của bộ nhớ `/data`.

### 2. Phiên bản Ẩn Root (Hidden Root Version)

*   **Ẩn root:** Tích hợp sẵn tính năng ẩn Root hệ thống.
*   **Cơ chế mặc định:** Sử dụng Mount Overlay với dung lượng lưu trữ cố định **4GB**.
*   **Chế độ Mount Bind:** Tổng dung lượng file thực tế cộng thêm **5GB** bộ nhớ trống. Chế độ này chỉ kích hoạt khi:
    *   Chế độ Mount Overlay không hoạt động trên thiết bị.
    *   Hoặc bạn chủ động tạo một file trống tại đường dẫn: `/data/adb/overlayfs/bind` 🌟
*   **Tùy chỉnh phân vùng RW:** Chỉnh sửa danh sách các phân vùng muốn mở khóa RW tại: `/data/adb/overlayfs/partition.txt` 🌟
*   **Thêm System Prop:** Chỉnh sửa tại `/data/adb/overlayfs/system.prop`.

> ⚠️ **Lưu ý:** Tất cả các tính năng có đánh dấu **🌟** yêu cầu bạn phải flash file `module.zip` để các thay đổi có hiệu lực.

---

## 🚑 Xử lý sự cố & Khôi phục (Recovery)

Nếu thiết bị của bạn gặp lỗi (Bootloop, treo logo...), bạn hoàn toàn có thể mount `overlayfs.img` để chỉnh sửa hoặc xóa các file lỗi trực tiếp thông qua **TWRP** hoặc **OrangeFox**:

1. Vào chế độ Recovery, mở công cụ **Terminal** (Dòng lệnh).
2. Nhập và chạy lệnh sau để tiến hành mount phân vùng:
   ```bash
   /data/adb/overlayfs/mount.sh
