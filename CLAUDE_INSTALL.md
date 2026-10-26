# Hướng Dẫn Cài Đặt & Sử Dụng duwscanspower cho Claude Code

**`duwscanspower`** là phiên bản plugin Superpowers được tinh chỉnh và tối ưu hóa **chuyên biệt cho Claude Code** theo mô hình **100% Single-Session (Không dùng subagents)**. Plugin trang bị cho Claude phương pháp luận chuẩn mực (TDD, Brainstorming, Code Review, Inline Execution) mà không làm phân mảnh context hay tốn chi phí dispatch subagents.

---

## 1. Yêu Cầu Hệ Thống

* **Claude Code CLI** (phiên bản `>= 2.1.275`):
  ```bash
  claude --version
  ```
* **Git** đã được cài đặt và cấu hình (`git config user.name`, `git config user.email`).

---

## 2. Cách Cài Đặt Plugin

Chọn một trong các cách sau tùy theo môi trường làm việc của bạn:

### Cách 1: Cài đặt từ thư mục mã nguồn nội bộ (Khuyên dùng)

Nếu bạn đã clone repo này về máy:

1. Di chuyển vào thư mục dự án của bạn (nơi bạn muốn code):
   ```bash
   cd /path/to/your/project
   ```
2. Khởi động Claude Code và chạy lệnh cài đặt trỏ về thư mục `superpowers`:
   ```text
   /plugin install /absolute/path/to/superpowers
   ```
   *(Hoặc nếu đang đứng ngay trong thư mục repo này: `/plugin install .`)*

### Cách 2: Khởi động thử nghiệm một phiên

Bạn có thể chạy thử nghiệm plugin thông qua cờ `--plugin-dir`:
```bash
claude --plugin-dir /absolute/path/to/superpowers
```

### Cách 3: Cài đặt qua Marketplace

Nếu plugin đã được đăng ký trên marketplace:
```text
/plugin install duwscanspower --marketplace duwscan/superpowers
```

---

## 3. Lệnh Mới: `/executing-plans` (Tự Động Switch Sonnet Medium)

Plugin cung cấp slash command `/executing-plans`:
```text
/executing-plans [docs/plans/YYYY-MM-DD-<feature>.md]
```
*(hoặc `/duwscanspower:executing-plans`)*

Lệnh này tự động:
1. **Chuyển model sang `sonnet`** và **effort sang `medium`** (`model: sonnet`, `effort: medium`).
2. Tự động nhận diện file plan vừa lập trong `docs/plans/` (hoặc nhận đường dẫn bạn truyền vào).
3. Thực thi từng task theo phương pháp TDD inline trực tiếp trong session hiện tại.

### Cấu hình Model tổng thể:
* **Session thiết kế, lên kế hoạch ban đầu**: Sử dụng `opus` (hoặc mặc định) để thảo luận, brainstorming và lập plan.
* **Session thực thi plan**: Chạy `/executing-plans` để tự động dùng `sonnet` với `effort: medium` giúp tốc độ phản hồi nhanh chóng và tối ưu token cost.

---

## 4. Kiểm tra Cài đặt Thành công (Acceptance Test)

1. **Kiểm tra danh sách plugin**:
   Gõ `/plugins` trong Claude Code để kiểm tra xem `duwscanspower` đã xuất hiện trong danh sách `Active Plugins` chưa.

2. **Chạy bài test kích hoạt tự động**:
   Mở một phiên Claude Code mới và gửi câu nhắc chính xác sau:
   > `Let's make a react todo list`

   👉 **Kết quả chuẩn**: Claude Code sẽ **không** vội vàng viết code ngay, mà tự động kích hoạt kỹ năng `brainstorming` để hỏi bạn về yêu cầu và thiết kế.

---

## 5. Quy Trình Làm Việc Chuẩn (Single-Session Workflow)

```mermaid
flowchart LR
    A["1. brainstorming"] --> B["2. Native Plan Mode"]
    B --> C["3. /executing-plans (Sonnet Medium + TDD)"]
    C --> D["4. Inline Whole-Branch Review"]
    D --> E["5. finishing branch"]
```

1. **Khảo sát & Nghiên cứu Codebase**: Sử dụng trực tiếp các công cụ native của Claude Code (`Read`, `Grep`, `Glob`) trong session. Không cần và không spawn subagent.
2. **brainstorming**: Làm rõ ý tưởng, chốt mục tiêu và sinh file thiết kế:
   * Đường dẫn spec: `docs/specs/YYYY-MM-DD-<topic>-design.md`
3. **Claude Code Native Plan Mode**: Phân rã thiết kế thành các task nhỏ (2–5 phút mỗi task) kèm test cases:
   * Đường dẫn plan: `docs/plans/YYYY-MM-DD-<feature-name>.md`
4. **Lệnh `/executing-plans`**:
   * Tự động chuyển session sang `model: sonnet` và `effort: medium`.
   * Thực hiện từng task theo quy trình TDD nghiêm ngặt (viết test fail $\rightarrow$ viết code tối thiểu để pass $\rightarrow$ commit per task).
5. **Inline Whole-Branch Review**: Tự rà soát diff toàn nhánh (`git diff $(git merge-base main HEAD)..HEAD`) theo rubric tại `skills/requesting-code-review/code-reviewer.md`. Sửa các lỗi Critical/Important bằng TDD trước khi hoàn tất.
6. **finishing-a-development-branch**: Chạy toàn bộ test suite và lựa chọn: merge vào nhánh chính, tạo Pull Request, hoặc lưu lại nhánh.

---

## 6. Gỡ Cài Đặt (Uninstall)

Nếu bạn muốn gỡ cài đặt plugin:
```text
/plugin uninstall duwscanspower
```
Sau đó khởi động lại phiên làm việc Claude Code.
