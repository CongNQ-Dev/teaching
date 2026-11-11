# Giáo án: Xây dựng Expense Tracker với Flutter

> Bám theo khoá Academind — section **05 Interactivity & Theming** (24 snapshot):
> https://github.com/academind/flutter-complete-guide-course-resources/tree/main/Code%20Snapshots/05%20Interactivity%20%26%20Theming
>
> Dạy live code trong `lib/live/`, đáp án đối chiếu ở `lib/solution/` (tương đương snapshot **24 Finished**). Chuyển qua lại bằng nút `LIVE ⇄ / SOLUTION ⇄` ở góc dưới trái (debug mode).

## 1. Thông tin buổi học

| Mục | Nội dung |
| --- | --- |
| Đối tượng | Học viên đã biết Dart cơ bản + widget cơ bản (`Text`, `Column`, `Row`), đã làm `quiz_app` |
| Thời lượng gợi ý | ~3 giờ nếu dạy hết (có thể tách **Buổi A: Bước 1–9**, **Buổi B: Bước 10–12**) |
| Sản phẩm cuối | App quản lý chi tiêu: danh sách, thêm mới, xoá + Undo, theme sáng/tối, biểu đồ cột |
| Công cụ | Flutter SDK, VS Code / Android Studio, emulator hoặc Chrome |
| Không dạy hôm nay | Responsive (`MediaQuery` width/`viewInsets`) |

### Mục tiêu học tập (học viên làm được sau buổi học)
1. Thiết kế **model** với `class`, `enum`, getter; dùng package `uuid`, `intl`.
2. Phân biệt `StatelessWidget` / `StatefulWidget`, dùng `setState` đúng chỗ.
3. Hiển thị danh sách bằng `ListView.builder`; tách widget nhỏ, truyền dữ liệu bằng constructor.
4. Làm form: `TextField` + `TextEditingController`, `showDatePicker` (Future), `DropdownButton`, validate, `AlertDialog`.
5. Truyền hàm **callback** từ con lên cha (lifting state up).
6. Xoá bằng `Dismissible` + `SnackBar` Undo.
7. Theming với `ColorScheme.fromSeed`, `textTheme`, dark mode.
8. Vẽ biểu đồ tự làm bằng `FractionallySizedBox`.

### Chuẩn bị trước giờ học
- [ ] `flutter pub get` (đã có `intl`, `uuid` trong `pubspec.yaml`)
- [ ] Chạy thử `flutter run` ở LIVE: thấy chữ *"Let's build an Expense Tracker!"*
- [ ] Reset `lib/live/` chỉ còn `live_app.dart` (xem README)
- [ ] Mở sẵn 2 cửa sổ: editor + emulator cạnh nhau, tăng cỡ chữ editor
- [ ] Chạy thử SOLUTION một lần để biết trước kết quả cuối
- [ ] (Tuỳ chọn) clone repo Academind để mở từng snapshot khi cần đối chiếu

---

## 2. Tổng quan tiến trình và đối chiếu snapshot

| # | Nội dung | Snapshot Academind | Thời gian | Khái niệm chính |
| --- | --- | --- | --- | --- |
| 0 | Mở đầu, demo SOLUTION | 24 | 10' | Giới thiệu sản phẩm, cấu trúc thư mục |
| 1 | Model | 01–02 | 15' | `class`, `enum`, `uuid` |
| 2 | Dữ liệu mẫu + màn hình chính | 02–03 | 10' | `StatefulWidget`, `List<Expense>` |
| 3 | Danh sách | 04 | 10' | `ListView.builder`, `Expanded` |
| 4 | Item, icon, format ngày | 05 | 15' | `Card`, `Row`, `Spacer`, `intl` |
| 5 | AppBar + modal sheet | 06–07 | 10' | `AppBar.actions`, `showModalBottomSheet` |
| 6 | TextField: onChanged → controller | 08–10 | 20' | `TextEditingController`, `dispose` |
| 7 | Bài tập nhỏ: ô Amount | 11 | 5' | `keyboardType`, `prefixText` |
| 8 | Ngày: Future + date picker | 12 | 15' | `async/await`, `DateTime?` |
| 9 | Dropdown category | 13 | 10' | `DropdownButton`, `enum.values` |
| — | Nghỉ giải lao | | 10' | |
| 10 | Validate + lưu expense | 14–15 | 20' | `double.tryParse`, `AlertDialog`, callback |
| 11 | Xoá + Undo | 16–17 | 20' | `Dismissible`, `SnackBar` |
| 12 | Theming + dark mode | 18–21 | 25' | `ColorScheme.fromSeed`, `copyWith`, `textTheme` |
| 13 | Chart | 22–24 | 25' | named constructor, `FractionallySizedBox` |
| 14 | Tổng kết + bài tập | — | 10' | |

Cấu trúc file cuối cùng trong `lib/live/`:

```
lib/live/
├── live_app.dart
├── models/expense.dart
└── widgets/
    ├── expenses.dart
    ├── new_expense.dart
    ├── expenses_list/
    │   ├── expenses_list.dart
    │   └── expense_item.dart
    └── chart/
        ├── chart.dart
        └── chart_bar.dart
```

> Khác biệt nhỏ so với khoá Academind: khoá tạo `expenses.dart` ở `lib/` rồi mới chuyển vào `widgets/` (snapshot 05). Ở đây ta tạo thẳng trong `widgets/` để khỏi phải di chuyển file; nội dung code giống nhau. Phần theme nằm ở `live_app.dart` thay vì `main.dart`.

---

## Bước 0 — Mở đầu (10')

**Nói:** "Hôm nay mình xây app ghi chi tiêu. Trước khi code, xem kết quả cuối."
**Làm:** Bấm nút chuyển sang `SOLUTION`, demo: thêm chi tiêu, vuốt xoá, Undo, đổi dark mode. Bấm lại sang `LIVE`.
**Hỏi nhanh:** "App này gồm những phần nào? Dữ liệu nằm ở đâu?" → dẫn tới việc cần **model** trước.

---

## Bước 1 — Model (15') · snapshot 01–02

**Mục tiêu:** Tạo class `Expense` mô tả 1 khoản chi.

**Giải thích:** UI chỉ là cách hiển thị dữ liệu, nên định nghĩa dữ liệu trước. Mỗi expense cần: `id`, `title`, `amount`, `date`, `category`.

**Code** — tạo `lib/live/models/expense.dart` (bản đầu, chưa có icon/format):

```dart
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Category { food, travel, leisure, work }

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
}
```

**Điểm nhấn khi giảng:**
- `enum` giới hạn giá trị hợp lệ (không gõ nhầm `"fod"`).
- `: id = uuid.v4()` là **initializer list** — `id` không nhận từ ngoài mà tự sinh.
- `required` + named parameters để gọi rõ ràng.

**Checkpoint:** Học viên giải thích được vì sao `id` không nằm trong constructor.

---

## Bước 2 — Dữ liệu mẫu + màn hình chính (10') · snapshot 02–03

**2a.** Tạo `lib/live/widgets/expenses.dart` (khung đơn giản):

```dart
import 'package:expense_tracker/live/models/expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('The chart'),
          Text('Expenses list... (${_registeredExpenses.length})'),
        ],
      ),
    );
  }
}
```

**2b.** Sửa `lib/live/live_app.dart` để `home` trỏ tới `Expenses()`:

```dart
import 'package:expense_tracker/live/widgets/expenses.dart';
import 'package:flutter/material.dart';

class LiveApp extends StatelessWidget {
  const LiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Expenses(),
    );
  }
}
```

**Điểm nhấn:** Vì sao `StatefulWidget`? (danh sách sẽ thay đổi khi thêm/xoá). `State` tách khỏi widget để sống qua các lần rebuild.

**Checkpoint:** Hot restart thấy "The chart" và "Expenses list... (2)".

---

## Bước 3 — Danh sách (10') · snapshot 04

Tạo `lib/live/widgets/expenses_list/expenses_list.dart` (tạm dùng `Text`):

```dart
import 'package:expense_tracker/live/models/expense.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Text(expenses[index].title),
    );
  }
}
```

Trong `expenses.dart`: thêm import `.../widgets/expenses_list/expenses_list.dart` và thay `Text('Expenses list...')` bằng:

```dart
Expanded(child: ExpensesList(expenses: _registeredExpenses)),
```

**Điểm nhấn:**
- `builder` chỉ dựng item đang hiển thị (lazy). So sánh với `ListView(children: [...])`.
- Cha truyền dữ liệu xuống con qua constructor.
- **Demo lỗi (cố ý, 1 phút):** bỏ `Expanded` → lỗi "Vertical viewport was given unbounded height" → giải thích lỗi layout hay gặp.

---

## Bước 4 — Item, icon, format ngày (15') · snapshot 05

**4a.** Bổ sung vào `models/expense.dart` (thêm import + `formatter` + `categoryIcons` + getter):

```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  // ... như cũ ...

  String get formattedDate => formatter.format(date);
}
```

**4b.** Tạo `lib/live/widgets/expenses_list/expense_item.dart`:

```dart
import 'package:expense_tracker/live/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Text(expense.title),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}'),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(width: 8),
                    Text(expense.formattedDate),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

**4c.** Trong `expenses_list.dart` đổi `itemBuilder`:

```dart
import 'package:expense_tracker/live/widgets/expenses_list/expense_item.dart';
// ...
itemBuilder: (ctx, index) => ExpenseItem(expenses[index]),
```

**Điểm nhấn:** `Spacer()` đẩy 2 nhóm ra hai đầu; `\$` để escape `$` trong chuỗi Dart; `toStringAsFixed(2)`; `Map<Category, IconData>` tra icon theo category. Title đang bị canh giữa — **cố ý để đó**, ta sẽ sửa bằng `crossAxisAlignment.start` ở Bước 12.

**Checkpoint:** Thấy 2 card với icon, tiền, ngày.

---

## Bước 5 — AppBar + modal sheet (10') · snapshot 06–07

Trong `_ExpensesState` thêm hàm mở modal và `AppBar`:

```dart
void _openAddExpenseOverlay() {
  showModalBottomSheet(
    context: context,
    builder: (ctx) => const Text('Modal bottom sheet'),
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Flutter ExpenseTracker'),
      actions: [
        IconButton(
          onPressed: _openAddExpenseOverlay,
          icon: const Icon(Icons.add),
        ),
      ],
    ),
    body: Column(
      children: [
        const Text('The chart'),
        Expanded(child: ExpensesList(expenses: _registeredExpenses)),
      ],
    ),
  );
}
```

**Điểm nhấn:** `AppBar.actions` nhận list widget; truyền **tên hàm** (`_openAddExpenseOverlay`), không phải gọi hàm (`_openAddExpenseOverlay()`); `context` có sẵn trong `State`.

**Checkpoint:** Bấm `+` → thấy modal hiện lên (chỉ có dòng chữ).

---

## Bước 6 — TextField: onChanged → controller (20') · snapshot 08–10

Mục tiêu: lấy giá trị người dùng nhập. Đi qua **2 cách** để học viên thấy vì sao dùng controller.

**6a. Khung `NewExpense`** — tạo `lib/live/widgets/new_expense.dart`:

```dart
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            maxLength: 50,
            decoration: InputDecoration(label: Text('Title')),
          ),
        ],
      ),
    );
  }
}
```

Trong `expenses.dart` đổi modal: `builder: (ctx) => const NewExpense()` (+ import). Thêm `isScrollControlled: true` ở `showModalBottomSheet` để modal cao hơn khi có bàn phím.

**6b. Cách 1 — `onChanged`** (snapshot 09), sửa `_NewExpenseState`:

```dart
var _enteredTitle = '';

void _saveTitleInput(String inputValue) {
  _enteredTitle = inputValue;
}

// TextField:
//   onChanged: _saveTitleInput,
// và thêm dưới TextField:
Row(
  children: [
    ElevatedButton(
      onPressed: () => print(_enteredTitle),
      child: const Text('Save Expense'),
    ),
  ],
),
```

Gõ chữ, bấm Save → xem console in ra. (Bỏ `const` ở `Padding/Column`/`InputDecoration` nếu IDE báo.)

**6c. Cách 2 — `TextEditingController`** (snapshot 10), thay cách 1:

```dart
final _titleController = TextEditingController();

@override
void dispose() {
  _titleController.dispose();
  super.dispose();
}

// TextField: controller: _titleController,
// Button:    onPressed: () => print(_titleController.text),
```

**Điểm nhấn:** `onChanged` gọi mỗi lần gõ phím (lưu thủ công); controller giữ nội dung và đọc khi cần (`.text`). Controller **phải `dispose()`** để tránh rò rỉ bộ nhớ → nhắc lại vòng đời `State`.

**Câu hỏi kiểm tra:** Khi nào `dispose()` được gọi? (khi modal bị đóng, widget bị gỡ khỏi cây)

---

## Bước 7 — Bài tập nhỏ: ô Amount (5') · snapshot 11

**Cho học viên tự làm 3 phút**, giảng viên đi quanh: thêm `_amountController` + `TextField` số tiền + nút Cancel.

Đáp án:

```dart
final _amountController = TextEditingController();
// dispose: _amountController.dispose();

TextField(
  controller: _amountController,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
    prefixText: '\$ ',
    label: Text('Amount'),
  ),
),
// Row nút:
TextButton(onPressed: () {}, child: const Text('Cancel')),
```

**Điểm nhấn:** `keyboardType: TextInputType.number`, `prefixText`; nhắc lại phải `dispose` cả 2 controller.

---

## Bước 8 — Ngày: Future + date picker (15') · snapshot 12

Thêm import `models/expense.dart` (để dùng `formatter`), biến và hàm vào `State`:

```dart
DateTime? _selectedDate;

void _presentDatePicker() async {
  final now = DateTime.now();
  final firstDate = DateTime(now.year - 1, now.month, now.day);
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: firstDate,
    lastDate: now,
  );
  setState(() {
    _selectedDate = pickedDate;
  });
}
```

Đặt Amount và ngày trên cùng một `Row`:

```dart
Row(
  children: [
    Expanded(
      child: TextField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          prefixText: '\$ ',
          label: Text('Amount'),
        ),
      ),
    ),
    const SizedBox(width: 16),
    Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _selectedDate == null
                ? 'No date selected'
                : formatter.format(_selectedDate!),
          ),
          IconButton(
            onPressed: _presentDatePicker,
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
    ),
  ],
),
```

Nút Cancel: `onPressed: () => Navigator.pop(context)`.

**Điểm nhấn:**
- `showDatePicker` trả về `Future` — kết quả **chưa có ngay**, dùng `await` trong hàm `async`.
- `DateTime?` nullable, `!` khẳng định không null (đã kiểm tra bằng `== null`).
- `TextField` trong `Row` **bắt buộc bọc `Expanded`** (demo lỗi "unbounded width" nếu thiếu).
- Người dùng bấm Cancel trong picker → `pickedDate == null`.

**Checkpoint:** Chọn ngày → ngày hiển thị cạnh icon lịch.

---

## Bước 9 — Dropdown category (10') · snapshot 13

```dart
Category _selectedCategory = Category.leisure;
```

Chèn `const SizedBox(height: 16)` trước `Row` nút, rồi thêm `DropdownButton` vào **đầu** `Row` nút (trước Cancel) cùng một `Spacer`:

```dart
DropdownButton(
  value: _selectedCategory,
  items: Category.values
      .map(
        (category) => DropdownMenuItem(
          value: category,
          child: Text(category.name.toUpperCase()),
        ),
      )
      .toList(),
  onChanged: (value) {
    if (value == null) return;
    setState(() {
      _selectedCategory = value;
    });
  },
),
const Spacer(),
```

**Điểm nhấn:** `Category.values` → `map` → `toList()` (biến enum thành danh sách widget); `value` hiển thị lựa chọn hiện tại nên phải `setState`; `onChanged` có thể trả `null` → kiểm tra.

---

## Giải lao 10'

---

## Bước 10 — Validate + lưu expense (20') · snapshot 14–15

**10a. Validate** (snapshot 14) — thêm vào `State`, nút Save đổi thành `onPressed: _submitExpenseData`:

```dart
void _submitExpenseData() {
  final enteredAmount = double.tryParse(_amountController.text);
  // tryParse('Hello') => null, tryParse('1.12') => 1.12
  final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

  if (_titleController.text.trim().isEmpty ||
      amountIsInvalid ||
      _selectedDate == null) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invalid input'),
        content: const Text(
          'Please make sure a valid title, amount, date and category was entered.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Okay'),
          ),
        ],
      ),
    );
    return;
  }

  // ... (bước 10b)
}
```

**10b. Callback lưu dữ liệu** (snapshot 15).

Trong `new_expense.dart`:

```dart
import 'package:expense_tracker/live/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;
  // ...
}

// cuối _submitExpenseData, thay "// ...":
widget.onAddExpense(
  Expense(
    title: _titleController.text,
    amount: enteredAmount,
    date: _selectedDate!,
    category: _selectedCategory,
  ),
);
Navigator.pop(context);
```

Trong `expenses.dart`:

```dart
void _addExpense(Expense expense) {
  setState(() {
    _registeredExpenses.add(expense);
  });
}

// builder của modal:
builder: (ctx) => NewExpense(onAddExpense: _addExpense),
```

Khi đã làm xong form, đổi `padding: EdgeInsets.all(16)` thành `EdgeInsets.fromLTRB(16, 48, 16, 16)` (modal không bị che bởi status bar; bỏ `const` ở `Padding` nếu cần).

**Điểm nhấn:**
- **Lifting state up / callback:** con (`NewExpense`) không sở hữu danh sách; nó gọi `onAddExpense` do cha truyền xuống.
- `widget.onAddExpense` — truy cập thuộc tính của widget từ `State`.
- Hai `context` khác nhau: `ctx` của dialog vs `context` của bottom sheet.

**Câu hỏi kiểm tra:** Vì sao dùng `double.tryParse` thay vì `double.parse`? Vì sao `setState` nằm ở `Expenses` chứ không ở `NewExpense`?

**Checkpoint (test cả luồng):** bỏ trống → thấy dialog; nhập đúng → expense xuất hiện trong list, modal tự đóng.

> Mốc kết thúc **Buổi A**.

---

## Bước 11 — Xoá + Undo (20') · snapshot 16–17

**11a. Dismissible** (snapshot 16) — `expenses_list.dart`:

```dart
class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]),
        onDismissed: (direction) => onRemoveExpense(expenses[index]),
        child: ExpenseItem(expenses[index]),
      ),
    );
  }
}
```

`expenses.dart`:

```dart
void _removeExpense(Expense expense) {
  setState(() {
    _registeredExpenses.remove(expense);
  });
}

// truyền vào: ExpensesList(expenses: ..., onRemoveExpense: _removeExpense)
```

**11b. SnackBar Undo** (snapshot 17) — thay `_removeExpense`:

```dart
void _removeExpense(Expense expense) {
  final expenseIndex = _registeredExpenses.indexOf(expense);
  setState(() {
    _registeredExpenses.remove(expense);
  });
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Expense deleted.'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        },
      ),
    ),
  );
}
```

**11c. Trạng thái rỗng** — trong `build` của `_ExpensesState`:

```dart
Widget mainContent = const Center(
  child: Text('No expenses found. Start adding some!'),
);

if (_registeredExpenses.isNotEmpty) {
  mainContent = ExpensesList(
    expenses: _registeredExpenses,
    onRemoveExpense: _removeExpense,
  );
}
// body: Column(children: [const Text('The chart'), Expanded(child: mainContent)])
```

**Điểm nhấn:** `Dismissible` bắt buộc có `key` duy nhất; lưu `index` trước khi xoá để Undo chèn lại đúng chỗ; `clearSnackBars()` tránh dồn nhiều snackbar; biến `mainContent` thay vì lồng `if` trong cây widget.

**Checkpoint:** Vuốt xoá → snackbar → Undo khôi phục đúng vị trí; xoá hết → thấy thông báo rỗng.

---

## Bước 12 — Theming + dark mode (25') · snapshot 18–21

Cho học viên thấy app còn "xấu": màu mặc định, title canh giữa, item chưa đẹp. Ta sửa tất cả **từ một chỗ**: `live_app.dart`.

**12a. Color scheme** (snapshot 18):

```dart
final kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

// MaterialApp(
//   theme: ThemeData().copyWith(
//     colorScheme: kColorScheme,
//     appBarTheme: const AppBarTheme().copyWith(
//       backgroundColor: kColorScheme.onPrimaryContainer,
//       foregroundColor: kColorScheme.primaryContainer,
//     ),
//   ),
//   home: const Expenses(),
// )
```

(`LiveApp.build` trả về `MaterialApp(...)` không còn `const`.)

**12b. Card / button / text theme** (snapshot 19–20) — thêm vào `theme`:

```dart
cardTheme: const CardThemeData().copyWith(
  color: kColorScheme.secondaryContainer,
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
),
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: kColorScheme.primaryContainer,
  ),
),
textTheme: ThemeData().textTheme.copyWith(
  titleLarge: TextStyle(
    fontWeight: FontWeight.bold,
    color: kColorScheme.onSecondaryContainer,
    fontSize: 16,
  ),
),
```

**12c. Dùng theme trong widget** (snapshot 20) — `expense_item.dart`: thêm `crossAxisAlignment: CrossAxisAlignment.start` cho `Column` và

```dart
Text(expense.title, style: Theme.of(context).textTheme.titleLarge),
```

`expenses_list.dart`: thêm nền đỏ khi vuốt xoá (đến đây `cardTheme.margin` mới có giá trị nên không bị null):

```dart
background: Container(
  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.75),
  margin: EdgeInsets.symmetric(
    horizontal: Theme.of(context).cardTheme.margin!.horizontal,
  ),
),
```

**12d. Dark mode** (snapshot 21):

```dart
final kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

// MaterialApp(
//   darkTheme: ThemeData.dark().copyWith(
//     colorScheme: kDarkColorScheme,
//     cardTheme: const CardThemeData().copyWith(
//       color: kDarkColorScheme.secondaryContainer,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: kDarkColorScheme.primaryContainer,
//         foregroundColor: kDarkColorScheme.onPrimaryContainer,
//       ),
//     ),
//   ),
//   theme: ...,
//   // themeMode: ThemeMode.system, // mặc định
// )
```

**Demo:** đổi `seedColor` → cả app đổi màu; đổi dark mode của emulator/OS → app đổi theo.

**Điểm nhấn:** đặt style ở một nơi (theme), dùng ở mọi nơi (`Theme.of(context)`); `copyWith` = copy object và ghi đè vài thuộc tính; `ColorScheme.fromSeed` sinh cả bảng màu từ một màu gốc; `themeMode` mặc định theo hệ thống.

> Ghi chú phiên bản: khoá Academind dùng `CardTheme` và `withOpacity`; Flutter mới dùng `CardThemeData` và `withValues(alpha: ...)`. Code trong giáo án này đã theo API mới.

---

## Bước 13 — Chart (25') · snapshot 22–24

**13a. `ExpenseBucket`** (snapshot 22) — thêm vào cuối `models/expense.dart`:

```dart
class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount; // sum = sum + expense.amount
    }
    return sum;
  }
}
```

**Giải thích:** "bucket" = nhóm các expense cùng category + tổng tiền. Named constructor `forCategory` lọc bằng `where`.

**13b. `ChartBar`** (snapshot 23) — `lib/live/widgets/chart/chart_bar.dart`:

```dart
import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({super.key, required this.fill});

  final double fill; // 0.0 → 1.0

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FractionallySizedBox(
          heightFactor: fill,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              color: isDarkMode
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary.withValues(
                      alpha: 0.65,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
```

**13c. `Chart`** — `lib/live/widgets/chart/chart.dart`:

```dart
import 'package:expense_tracker/live/models/expense.dart';
import 'package:expense_tracker/live/widgets/chart/chart_bar.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;

  List<ExpenseBucket> get buckets => [
        ExpenseBucket.forCategory(expenses, Category.food),
        ExpenseBucket.forCategory(expenses, Category.leisure),
        ExpenseBucket.forCategory(expenses, Category.travel),
        ExpenseBucket.forCategory(expenses, Category.work),
      ];

  double get maxTotalExpense {
    double maxTotalExpense = 0;
    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }
    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets)
                  ChartBar(
                    fill: bucket.totalExpenses == 0
                        ? 0
                        : bucket.totalExpenses / maxTotalExpense,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        categoryIcons[bucket.category],
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary.withValues(
                                alpha: 0.7,
                              ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
```

**13d. Gắn vào màn hình chính** (snapshot 24, `expenses.dart`): thay `const Text('The chart')` bằng

```dart
import 'package:expense_tracker/live/widgets/chart/chart.dart';
// ...
Chart(expenses: _registeredExpenses),
```

**Điểm nhấn:** `FractionallySizedBox(heightFactor)` — chiều cao theo tỉ lệ (0–1) của cha; chuẩn hoá bằng `total / max`; collection-`for` trong list so với `map().toList()`; getter tính lại mỗi lần build (đơn giản, đủ cho app nhỏ).

**Checkpoint:** Thêm expense → cột tương ứng thay đổi; xoá → cột co lại; đổi dark mode → màu cột đổi.

---

## Bước 14 — Tổng kết & bài tập (10')

**Tổng kết (hỏi học viên trả lời, không đọc slide):**
1. Dữ liệu của app nằm ở đâu? Ai được phép sửa nó? (`_registeredExpenses` ở `_ExpensesState`; con gọi callback)
2. Khi nào dùng `Stateless`, khi nào `Stateful`?
3. Vì sao phải `dispose` controller?
4. Khác nhau giữa `ListView` và `ListView.builder`?
5. Vì sao đặt màu/style trong `ThemeData` thay vì từng widget?

**Bài tập về nhà (chọn theo trình độ):**
- ⭐ Thêm category mới (ví dụ `health`) + icon; kiểm tra chart vẫn đúng (gợi ý: `buckets` đang liệt kê tay, hãy đổi thành `Category.values.map(...)`).
- ⭐⭐ Hiển thị **tổng chi tiêu** trên AppBar hoặc dưới chart.
- ⭐⭐ Cho phép **sửa** expense khi tap vào item (tái sử dụng `NewExpense`).
- ⭐⭐⭐ Lưu dữ liệu bền vững bằng `shared_preferences` hoặc SQLite để mở lại app vẫn còn.

---

## Phụ lục: Lỗi thường gặp khi live code

| Triệu chứng | Nguyên nhân | Cách sửa |
| --- | --- | --- |
| "Vertical viewport was given unbounded height" | `ListView` trong `Column` không có `Expanded` | Bọc `Expanded` |
| "InputDecorator ... unbounded width" | `TextField` trong `Row` không có `Expanded` | Bọc `Expanded` |
| IDE báo "Invalid constant value" | Có biến/hàm không-const nằm trong widget đánh dấu `const` | Bỏ `const` ở widget cha |
| Hot reload không thấy thay đổi ở biến toàn cục | Biến global không reset khi hot reload | Hot restart (`Shift+R`) |
| Dismissible báo "still part of the tree" | Thiếu/trùng `key` | `key: ValueKey(expense)` |
| `cardTheme.margin!` null | Dùng trước khi khai báo `cardTheme` (Bước 12) | Làm đúng thứ tự: thêm background xoá **sau** `cardTheme` |
| Vừa đổi `_registeredExpenses` mà UI không đổi | Quên `setState` | Bọc thay đổi trong `setState` |
| `withOpacity` / `CardTheme` báo deprecated | Flutter mới | Dùng `withValues(alpha: ...)` / `CardThemeData` |

## Mẹo vận hành lớp
- Mỗi bước: **nói mục tiêu → gõ code → hot reload → hỏi 1 câu kiểm tra**.
- Cố ý gây 1–2 lỗi quen thuộc (thiếu `Expanded`) để học viên biết đọc thông báo lỗi.
- Học viên bí → chuyển `SOLUTION`, mở file tương ứng so sánh với `lib/live/`; hoặc mở snapshot Academind cùng số bước (bảng ở mục 2).
- Sau mỗi bước lớn, `git commit` ở `lib/live/` để dễ quay lại / reset cho lớp sau.
