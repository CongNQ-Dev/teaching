# Expense Tracker — Teaching Project

Project này có **2 phiên bản chạy song song** trong cùng một app:

| Thư mục          | Mục đích                                       |
| ---------------- | ---------------------------------------------- |
| `lib/live/`      | Nơi giảng viên code live cùng học viên         |
| `lib/solution/`  | Đáp án hoàn chỉnh (không sửa khi đang dạy)     |
| `lib/main.dart`  | `TeachingRoot` — chọn và chuyển giữa 2 chế độ  |

## Cách chuyển giữa LIVE và SOLUTION

1. **Ngay khi app đang chạy**: bấm nút `LIVE ⇄` / `SOLUTION ⇄` ở góc dưới bên trái.
   State của mỗi bên được reset khi chuyển. Nút chỉ hiện ở debug mode.
2. **Chọn chế độ khi khởi động**:
   - VS Code: tab Run & Debug → chọn `LIVE` hoặc `SOLUTION`
   - Android Studio: dropdown run config → `LIVE` hoặc `SOLUTION`
   - CLI: `flutter run --dart-define=MODE=solution` (mặc định là `live`)

Hot reload hoạt động bình thường ở cả 2 chế độ.

Giáo án chi tiết (code từng bước): [GIAO_AN.md](GIAO_AN.md). Nội dung bám theo
[Academind — 05 Interactivity & Theming](https://github.com/academind/flutter-complete-guide-course-resources/tree/main/Code%20Snapshots/05%20Interactivity%20%26%20Theming) (24 snapshot).

## Lộ trình bài giảng (gợi ý, theo thứ tự file trong `lib/solution/`)

1. **Model** — `models/expense.dart`: class `Expense`, `enum Category`, `uuid`, `intl` (format ngày)
2. **Màn hình chính** — `widgets/expenses.dart`: `StatefulWidget`, `Scaffold`, `AppBar` + nút thêm
3. **Danh sách** — `expenses_list/expenses_list.dart`: `ListView.builder`
4. **Item** — `expenses_list/expense_item.dart`: `Card`, `Row`, `Spacer`, icon theo category
5. **Form thêm mới** — `widgets/new_expense.dart`: `showModalBottomSheet`, `TextEditingController`,
   `showDatePicker`, `DropdownButton`, validate + `AlertDialog`
6. **Xoá + Undo** — `Dismissible`, `SnackBar` với `SnackBarAction`
7. **Theming** — `solution_app.dart`: `ColorScheme.fromSeed`, `copyWith`, dark mode
8. **Chart** — `widgets/chart/`: `ExpenseBucket`, `FractionallySizedBox`

Mẹo: khi học viên bí, chuyển sang `SOLUTION` để demo kết quả, rồi mở file tương ứng trong
`lib/solution/` để so sánh với code đang viết ở `lib/live/`.

## Reset phần live cho lớp mới

Chỉ cần đưa `lib/live/` về trạng thái chỉ còn `live_app.dart` khởi đầu
(ví dụ `git checkout -- lib/live && git clean -fd lib/live` nếu đã commit bản khởi đầu).
