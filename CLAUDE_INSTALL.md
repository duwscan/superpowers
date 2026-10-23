# Hướng Dẫn Cài Đặt & Sử Dụng duwscanspower cho Claude Code

**`duwscanspower`** là phiên bản plugin Superpowers được tinh chỉnh và tối ưu hóa **chuyên biệt cho Claude Code**. Plugin trang bị cho Claude phương pháp luận phát triển phần mềm chuẩn mực (TDD, Brainstorming, Code Review, Subagent-driven Development) cùng cơ chế tối ưu chi phí token vượt trội.

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

### Cách 1: Cài đặt từ thư mục mã nguồn nội bộ (Local Install - Khuyên dùng)

Nếu bạn đã clone hoặc fork repo này về máy:

1. Di chuyển vào thư mục dự án của bạn (nơi bạn muốn code):
   ```bash
   cd /path/to/your/project
   ```
2. Khởi động Claude Code và chạy lệnh cài đặt trỏ về thư mục `superpowers`:
   ```text
   /plugin install /absolute/path/to/superpowers
   ```
   *(Hoặc nếu đang đứng ngay trong thư mục repo này: `/plugin install .`)*

### Cách 2: Khởi động thử nghiệm (Không cần cài đặt cố định)

Bạn có thể chạy thử nghiệm plugin cho một phiên duy nhất thông qua cờ `--plugin-dir`:
```bash
claude --plugin-dir /absolute/path/to/superpowers
```

### Cách 3: Cài đặt qua Marketplace

Nếu plugin đã được đăng ký trên marketplace:
```text
/plugin install duwscanspower --marketplace duwscan/superpowers
```

---

## 3. Cấu hình Model & Effort tối ưu

Quy tắc phân tầng thông minh của `duwscanspower`:
* **Session chính (Nhạc trưởng / Kiến trúc sư)**: Cần tư duy sâu nhất $\rightarrow$ dùng **`opus`** với **`effort: high`**.
* **Các Subagent được dispatch**: Tự động phân bổ **`sonnet`** (cho code logic/review) hoặc **`haiku`** (cho research/explore) với trần **`effort: medium`** (hoặc `low`).

### Thiết lập khi mở phiên Claude Code:
Khởi động phiên làm việc với cờ model & effort chuẩn:
```bash
claude --model opus --effort high
```
Hoặc trong cửa sổ chat Claude Code:
```text
/model opus
/effort high
```

---

## 4. Kiểm tra Cài đặt Thành công (Acceptance Test)

1. **Kiểm tra danh sách plugin**:
   Gõ `/plugins` trong Claude Code để kiểm tra xem `duwscanspower` đã xuất hiện trong danh sách `Active Plugins` chưa.

2. **Chạy bài test kích hoạt tự động**:
   Mở một phiên Claude Code mới và gửi câu nhắc chính xác sau:
   > `Let's make a react todo list`

   👉 **Kết quả chuẩn**: Claude Code sẽ **không** vội vàng viết code ngay, mà tự động kích hoạt kỹ năng `brainstorming` để hỏi bạn về yêu cầu và thiết kế.

---

## 5. Quy Trình Làm Việc Chuẩn (The New Workflow)

```mermaid
flowchart LR
    A["1. brainstorming"] --> B["2. Native Plan Mode"]
    B --> C["3. subagent-driven (TDD)"]
    C --> D["4. Final Review"]
    D --> E["5. finishing branch"]
```

1. **Khảo sát codebase**: Khi cần tìm kiếm file/symbol hoặc đọc code diện rộng, Claude Code ưu tiên dispatch subagent `Explore` (`model: haiku`, `effort: 0`) để gom thông tin nhanh mà không làm tràn context chính.
2. **brainstorming**: Làm rõ ý tưởng, chốt mục tiêu và sinh file thiết kế:
   * Đường dẫn spec: `docs/specs/YYYY-MM-DD-<topic>-design.md`
3. **Claude Code Native Plan Mode**: Phân rã thiết kế thành các task nhỏ (2–5 phút mỗi task) kèm test cases:
   * Đường dẫn plan: `docs/plans/YYYY-MM-DD-<feature-name>.md`
4. **subagent-driven-development**: Tự động dispatch các worker subagent làm từng task theo TDD:
   * Task đơn giản / boilerplate: `model: sonnet / haiku`, `effort: low`.
   * Task tiêu chuẩn / task review: `model: sonnet`, `effort: medium`.
   * Task phức tạp / concurrency: `model: sonnet`, `effort: medium`.
5. **Final Whole-Branch Review**: Rà soát lại toàn bộ nhánh trước khi merge với `model: sonnet`, `effort: medium`.
6. **finishing-a-development-branch**: Chạy toàn bộ test suite và lựa chọn: merge vào nhánh chính, tạo Pull Request, hoặc lưu lại nhánh.

---

## 6. Gỡ Cài Đặt (Uninstall)

Nếu bạn muốn gỡ cài đặt plugin:
```text
/plugin uninstall duwscanspower
```
Sau đó khởi động lại phiên làm việc Claude Code.
