import 'package:equatable/equatable.dart';

class Course extends Equatable {
  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.rating,
    required this.totalRatings,
    required this.durationMinutes,
    required this.moduleCount,
    required this.level,
    required this.tags,
    this.thumbnailUrl,
  });

  final String id;
  final String title;
  final String description;
  final String author;
  final double rating;
  final int totalRatings;
  final int durationMinutes;
  final int moduleCount;
  final String level; // 'Начинающий' | 'Средний' | 'Продвинутый'
  final List<String> tags;
  final String? thumbnailUrl;

  /// Demo seed data — the course from the issue requirements.
  static const demoCourse = Course(
    id: 'python-1h',
    title: 'Выучи Python за 1 час',
    description:
        'Быстрый и увлекательный курс по Python с эмоциональными анимациями. '
        'Переменные, циклы, функции — всё через 2D-персонажей, которые объясняют сложное просто.',
    author: 'AnimaLearn Team',
    rating: 4.8,
    totalRatings: 1240,
    durationMinutes: 60,
    moduleCount: 6,
    level: 'Начинающий',
    tags: ['Python', 'Программирование', 'Анимация', '2D'],
  );

  /// What-you-will-learn checklist items for the demo course.
  static const demoLearningOutcomes = [
    'Установить Python и настроить среду',
    'Понять переменные и типы данных',
    'Использовать циклы for и while',
    'Писать собственные функции',
    'Работать со списками и словарями',
    'Создать первую мини-программу',
  ];

  /// Course modules for the demo course.
  static const demoModules = [
    CourseModule(
      id: 'python-1h-m1',
      title: 'Привет, Python!',
      durationMinutes: 8,
      emotionScript: '''
[EMOTION:excited] Привет! Я Пайтоша — твой проводник в мир Python.
[EMOTION:curious] Python — это язык, который читается почти как обычный текст.
[EMOTION:happy] Давай напишем твою первую программу!
[CODE:python]
print("Привет, мир!")
[/CODE]
[EMOTION:proud] Отлично! Ты только что написал первую программу на Python!
''',
    ),
    CourseModule(
      id: 'python-1h-m2',
      title: 'Переменные и типы',
      durationMinutes: 12,
      emotionScript: '''
[EMOTION:thinking] Переменная — это коробочка для хранения данных.
[EMOTION:explaining] В Python есть несколько основных типов данных.
[CODE:python]
name = "Алиса"      # строка (str)
age = 25            # целое число (int)
height = 1.68       # дробное число (float)
is_student = True   # булево значение (bool)
[/CODE]
[EMOTION:excited] Python сам определяет тип! Это называется динамическая типизация.
''',
    ),
    CourseModule(
      id: 'python-1h-m3',
      title: 'Циклы',
      durationMinutes: 10,
      emotionScript: '''
[EMOTION:energetic] Циклы позволяют повторять действия много раз!
[CODE:python]
for i in range(5):
    print(f"Шаг {i + 1}")
[/CODE]
[EMOTION:celebrating] Цикл for прошёл 5 раз автоматически. Магия!
''',
    ),
    CourseModule(
      id: 'python-1h-m4',
      title: 'Функции',
      durationMinutes: 12,
      emotionScript: '''
[EMOTION:wise] Функция — это именованный блок кода, который можно вызывать снова и снова.
[CODE:python]
def greet(name: str) -> str:
    return f"Привет, {name}!"

print(greet("Алиса"))
print(greet("Боб"))
[/CODE]
[EMOTION:proud] Ты только что создал переиспользуемый код. Это важный навык!
''',
    ),
    CourseModule(
      id: 'python-1h-m5',
      title: 'Списки и словари',
      durationMinutes: 10,
      emotionScript: '''
[EMOTION:curious] Списки хранят много элементов. Словари — пары ключ-значение.
[CODE:python]
fruits = ["яблоко", "банан", "вишня"]
person = {"имя": "Алиса", "возраст": 25}

print(fruits[0])        # яблоко
print(person["имя"])    # Алиса
[/CODE]
[EMOTION:happy] Эти структуры данных ты будешь использовать каждый день!
''',
    ),
    CourseModule(
      id: 'python-1h-m6',
      title: 'Мини-проект: Калькулятор',
      durationMinutes: 8,
      emotionScript: '''
[EMOTION:excited] Финальный урок! Создадим простой калькулятор.
[CODE:python]
def calculator(a: float, b: float, op: str) -> float:
    if op == "+": return a + b
    if op == "-": return a - b
    if op == "*": return a * b
    if op == "/" and b != 0: return a / b
    raise ValueError(f"Неизвестная операция: {op}")

result = calculator(10, 3, "+")
print(f"10 + 3 = {result}")
[/CODE]
[EMOTION:celebrating] Поздравляю! Ты прошёл курс и написал свой первый проект!
''',
    ),
  ];

  @override
  List<Object?> get props => [id, title, author, rating];
}

class CourseModule extends Equatable {
  const CourseModule({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.emotionScript,
  });

  final String id;
  final String title;
  final int durationMinutes;

  /// Emotion-script text used to drive the animation + narration.
  final String emotionScript;

  @override
  List<Object?> get props => [id, title];
}
