import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(FitnessApp());
}

class FitnessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WorkoutTypeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Замените на ваше изображение
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', width: 200, height: 200),
              SizedBox(height: 20),
              Text(
                'VanVas Fitness',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              Toolbar(),
            ],
          ),
        ),
      ),
    );
  }
}

class Toolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.home),
          label: Text('Тренировка дома'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(workoutType: 'home')),
            );
          },
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.fitness_center),
          label: Text('Тренировка в зале'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(workoutType: 'gym')),
            );
          },
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.person),
          label: Text('Профиль'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
        ),
      ],
    );
  }
}

class WorkoutTypeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выберите тип тренировки'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Замените на ваше изображение
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.home),
                label: Text('Тренировка дома'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen(workoutType: 'home')),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.fitness_center),
                label: Text('Тренировка в зале'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen(workoutType: 'gym')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String workoutType;

  HomeScreen({required this.workoutType});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  double _totalCaloriesBurned = 0.0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Тренировки', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Календарь', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Питание', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Профиль', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutType == 'home' ? 'Тренировка дома' : 'Тренировка в зале'),
        actions: [
          IconButton(
            icon: Icon(Icons.local_fire_department),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Сожжено калорий'),
                  content: Text('${_totalCaloriesBurned.toStringAsFixed(2)} ккал'),
                  actions: [
                    TextButton(
                      child: Text('Закрыть'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Замените на ваше изображение
            fit: BoxFit.cover,
          ),
        ),
        child: _selectedIndex == 0
            ? WorkoutList(workoutType: widget.workoutType, onCaloriesBurned: _updateCaloriesBurned)
            : _selectedIndex == 1
                ? CalendarScreen()
                : _selectedIndex == 2
                    ? NutritionScreen()
                    : ProfileScreen(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Тренировки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Календарь',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Питание',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _updateCaloriesBurned(double calories) {
    setState(() {
      _totalCaloriesBurned += calories;
    });
  }
}

class WorkoutList extends StatelessWidget {
  final String workoutType;
  final Function(double) onCaloriesBurned;

  WorkoutList({required this.workoutType, required this.onCaloriesBurned});

  final List<Workout> homeWorkouts = [
    Workout(
      name: 'Приседания',
      sets: 3,
      reps: 15,
      caloriesBurned: 3.5,
      description:
          'Встаньте прямо, ноги на ширине плеч.\nМедленно опускайтесь, сгибая колени и отводя таз назад, как будто садитесь на стул.\nВернитесь в исходное положение, выпрямляя ноги.',
      muscleGroup: 'Ноги',
    ),
    Workout(
      name: 'Отжимания',
      sets: 3,
      reps: 15,
      caloriesBurned: 3.0,
      description:
          'Примите упор лежа, руки на ширине плеч.\nСгибайте руки в локтях, опускаясь к полу, затем выпрямляйте руки, возвращаясь в исходное положение.',
      muscleGroup: 'Руки',
    ),
    Workout(
      name: 'Планка',
      sets: 3,
      reps: 15,
      caloriesBurned: 2.5,
      description:
          'Примите упор лежа, но удерживайте тело в прямой линии, опираясь на предплечья и пальцы ног.\nУдерживайте это положение в течение 15 секунд (или дольше, если можете).',
      muscleGroup: 'Пресс',
    ),
    Workout(
      name: 'Выпады вперед',
      sets: 3,
      reps: 15,
      caloriesBurned: 3.2,
      description:
          'Встаньте прямо, сделайте шаг вперед одной ногой.\nОпуститесь вниз, сгибая обе ноги в коленях, затем вернитесь в исходное положение.\nПовторите с другой ногой.',
      muscleGroup: 'Ноги',
    ),
    Workout(
      name: 'Подъемы ног лежа',
      sets: 3,
      reps: 15,
      caloriesBurned: 2.8,
      description:
          'Лягте на спину, руки вдоль тела.\nПоднимайте прямые ноги вверх, затем опускайте их обратно, не касаясь пола.',
      muscleGroup: 'Ноги',
    ),
    Workout(
      name: 'Скручивания',
      sets: 3,
      reps: 15,
      caloriesBurned: 2.7,
      description:
          'Лягте на спину, согните ноги в коленях, руки за головой.\nПоднимайте верхнюю часть тела, напрягая мышцы пресса, затем опускайтесь обратно.',
      muscleGroup: 'Пресс',
    ),
    Workout(
      name: 'Мостик',
      sets: 3,
      reps: 15,
      caloriesBurned: 3.0,
      description:
          'Лягте на спину, согните ноги в коленях, стопы на полу.\nПоднимайте таз вверх, напрягая ягодицы и мышцы бедер, затем опускайтесь обратно.',
      muscleGroup: 'Ноги',
    ),
    Workout(
      name: 'Боковые выпады',
      sets: 3,
      reps: 15,
      caloriesBurned: 3.1,
      description:
          'Встаньте прямо, сделайте шаг в сторону одной ногой.\nОпуститесь вниз, сгибая одну ногу в колене, затем вернитесь в исходное положение.\nПовторите с другой ногой.',
      muscleGroup: 'Ноги',
    ),
    Workout(
      name: 'Подъемы на носки',
      sets: 3,
      reps: 15,
      caloriesBurned: 2.5,
      description:
          'Встаньте прямо, ноги вместе.\nПоднимайтесь на носки, затем опускайтесь обратно.',
      muscleGroup: 'Ноги',
    ),
    Workout(
      name: 'Супермен',
      sets: 3,
      reps: 15,
      caloriesBurned: 2.8,
      description:
          'Лягте на живот, руки и ноги вытянуты.\nПоднимайте одновременно руки и ноги вверх, затем опускайте их обратно.',
      muscleGroup: 'Спина',
    ),
  ];

  final List<Workout> gymWorkouts = [
    Workout(
      name: 'Жим лежа',
      sets: 3,
      reps: 10,
      caloriesBurned: 4.0,
      description:
          'Лягте на скамью, ноги на полу.\nВозьмите штангу и опустите её к груди, затем поднимите обратно.',
      muscleGroup: 'Грудь',
    ),
    Workout(
      name: 'Тяга верхнего блока',
      sets: 3,
      reps: 10,
      caloriesBurned: 3.8,
      description:
          'Сядьте на тренажер, возьмитесь за рукоятку.\nТяните рукоятку к груди, затем верните её обратно.',
      muscleGroup: 'Спина',
    ),
    Workout(
      name: 'Приседания со штангой',
      sets: 3,
      reps: 10,
      caloriesBurned: 4.5,
      description:
          'Встаньте прямо, штанга на плечах.\nПриседайте, затем вернитесь в исходное положение.',
      muscleGroup: 'Ноги',
    ),
    Workout(
      name: 'Жим ногами',
      sets: 3,
      reps: 10,
      caloriesBurned: 4.2,
      description:
          'Сядьте на тренажер, ноги на платформе.\nНадавите ногами на платформу, затем верните её обратно.',
      muscleGroup: 'Ноги',
    ),
    Workout(
      name: 'Подтягивания',
      sets: 3,
      reps: 10,
      caloriesBurned: 4.0,
      description:
          'Возьмитесь за турник, руки на ширине плеч.\nПодтягивайтесь, затем опускайтесь обратно.',
      muscleGroup: 'Спина',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<Workout> workouts = workoutType == 'home' ? homeWorkouts : gymWorkouts;
    Map<String, List<Workout>> groupedWorkouts = {};

    for (var workout in workouts) {
      if (!groupedWorkouts.containsKey(workout.muscleGroup)) {
        groupedWorkouts[workout.muscleGroup] = [];
      }
      groupedWorkouts[workout.muscleGroup]!.add(workout);
    }

    return ListView(
      children: groupedWorkouts.entries.map((entry) {
        String muscleGroup = entry.key;
        List<Workout> groupWorkouts = entry.value;
        double totalCaloriesBurned = groupWorkouts.fold(0.0, (sum, workout) => sum + workout.caloriesBurned * workout.sets * workout.reps);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                muscleGroup,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            LinearProgressIndicator(
              value: totalCaloriesBurned / 100, // Пример: 100 калорий - максимум
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            ...groupWorkouts.map((workout) {
              return ListTile(
                title: Text(workout.name, style: TextStyle(color: Colors.white)),
                subtitle: Text('${workout.sets} подходов по ${workout.reps} раз', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimerScreen(workout: workout, onCaloriesBurned: onCaloriesBurned),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        );
      }).toList(),
    );
  }
}

class Workout {
  final String name;
  final int sets;
  final int reps;
  final double caloriesBurned;
  final String description;
  final String muscleGroup;

  Workout({required this.name, required this.sets, required this.reps, required this.caloriesBurned, required this.description, required this.muscleGroup});
}

class TimerScreen extends StatefulWidget {
  final Workout workout;
  final Function(double) onCaloriesBurned;

  TimerScreen({required this.workout, required this.onCaloriesBurned});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with SingleTickerProviderStateMixin {
  int _remainingTime = 20;
  int _currentSet = 1;
  bool _isRunning = false;
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _animation;
  final TextEditingController _timeController = TextEditingController(text: '20');
  double _totalCaloriesBurned = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _remainingTime = int.parse(_timeController.text);
    });

    _controller.duration = Duration(seconds: _remainingTime);
    _controller.forward(from: 0);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isRunning = false;
        });
        // Показать диалоговое окно по окончании подхода
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Время вышло!'),
            content:
                Text('Вы завершили подход $_currentSet из ${widget.workout.sets}.'),
            actions: [
              TextButton(
                child: Text('Следующий подход'),
                onPressed: () {
                  Navigator.pop(context);
                  if (_currentSet < widget.workout.sets) {
                    setState(() {
                      _currentSet++;
                      _remainingTime = int.parse(_timeController.text); // Сбросить таймер на следующий подход
                      _startTimer(); // Запустить следующий таймер
                    });
                  } else {
                    // Завершение всех подходов
                    Navigator.pop(context); // Закрыть диалог
                    Navigator.pop(context); // Вернуться на главный экран
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Тренировка завершена!'),
                        content:
                            Text('Вы завершили все подходы для ${widget.workout.name}.\nСожжено калорий: ${_totalCaloriesBurned.toStringAsFixed(2)}'),
                        actions: [
                          TextButton(
                            child: Text('ОК'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    if (_isRunning) {
      _timer.cancel();
    }
    _controller.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(widget.workout.name),
                  content:
                      SingleChildScrollView(child: Text(widget.workout.description)),
                  actions: [
                    TextButton(
                      child: Text('Закрыть'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Замените на ваше изображение
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Описание упражнения:',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    widget.workout.description,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Установите время (секунды):',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _timeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Время',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Осталось времени:',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    painter: TimerPainter(_animation.value),
                    child: SizedBox(
                      width: 200,
                      height: 200,
                    ),
                  ),
                  Text(
                    '$_remainingTime',
                    style: TextStyle(fontSize: 48, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Подход $_currentSet из ${widget.workout.sets}',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isRunning ? null : _startTimer,
                child: Text('Начать упражнение'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final double animationValue;

  TimerPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    // Рисуем круг
    final startAngle = -pi / 2; // Начинаем с верхней точки
    final sweepAngle = 2 * pi * animationValue;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Календарь'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Замените на ваше изображение
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: (day) {
                return _events[day] ?? [];
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _events[_selectedDay]?.length ?? 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_events[_selectedDay]![index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addEvent(DateTime day, String event) {
    setState(() {
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    });
  }
}

class NutritionScreen extends StatefulWidget {
  @override
  _NutritionScreenState createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final List<String> daysOfWeek = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
  final Map<String, List<String>> nutritionPlan = {
    'Понедельник': ['Завтрак: Овсянка', 'Обед: Курица с рисом', 'Ужин: Салат'],
    'Вторник': ['Завтрак: Йогурт', 'Обед: Рыба с овощами', 'Ужин: Фрукты'],
    'Среда': ['Завтрак: Омлет', 'Обед: Суп', 'Ужин: Мясо с гарниром'],
    'Четверг': ['Завтрак: Смузи', 'Обед: Паста', 'Ужин: Овощное рагу'],
    'Пятница': ['Завтрак: Хлопья', 'Обед: Салат с курицей', 'Ужин: Рыба'],
    'Суббота': ['Завтрак: Блины', 'Обед: Борщ', 'Ужин: Фрукты'],
    'Воскресенье': ['Завтрак: Творог', 'Обед: Шашлык', 'Ужин: Салат'],
  };

  final Map<String, String> recipes = {
    'Овсянка': '1 стакан овсянки, 2 стакана воды, сахар по вкусу. Варить 5 минут.',
    'Курица с рисом': '200г куриного филе, 1 стакан риса, соль, перец по вкусу. Готовить 30 минут.',
    'Салат': 'Огурцы, помидоры, зелень, оливковое масло. Смешать и заправить.',
    'Йогурт': '1 стакан йогурта, фрукты по вкусу.',
    'Рыба с овощами': '200г рыбы, овощи по вкусу. Готовить 20 минут.',
    'Фрукты': 'Яблоки, бананы, апельсины.',
    'Омлет': '2 яйца, молоко, соль, перец по вкусу. Жарить 5 минут.',
    'Суп': 'Куриный бульон, овощи по вкусу. Варить 40 минут.',
    'Мясо с гарниром': '200г мяса, картофель, овощи по вкусу. Готовить 30 минут.',
    'Смузи': 'Банан, молоко, мед. Смешать в блендере.',
    'Паста': 'Паста, томатный соус, сыр. Варить 10 минут.',
    'Овощное рагу': 'Овощи по вкусу, томатный соус. Тушить 20 минут.',
    'Хлопья': 'Хлопья, молоко, сахар по вкусу.',
    'Салат с курицей': 'Куриное филе, огурцы, помидоры, зелень, оливковое масло. Смешать и заправить.',
    'Рыба': '200г рыбы, лимон, соль, перец по вкусу. Готовить 20 минут.',
    'Блины': 'Мука, молоко, яйца, сахар. Жарить на сковороде.',
    'Борщ': 'Куриный бульон, свекла, капуста, картофель, морковь. Варить 1 час.',
    'Творог': 'Творог, сахар, фрукты по вкусу.',
    'Шашлык': 'Мясо, маринад по вкусу. Жарить на гриле.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Питание'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Замените на ваше изображение
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: daysOfWeek.length,
          itemBuilder: (context, index) {
            final day = daysOfWeek[index];
            return ListTile(
              title: Text(day, style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NutritionDetailScreen(day: day, nutritionPlan: nutritionPlan[day]!, recipes: recipes),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class NutritionDetailScreen extends StatelessWidget {
  final String day;
  final List<String> nutritionPlan;
  final Map<String, String> recipes;

  NutritionDetailScreen({required this.day, required this.nutritionPlan, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Питание на $day'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Замените на ваше изображение
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: nutritionPlan.length,
          itemBuilder: (context, index) {
            final meal = nutritionPlan[index];
            final mealName = meal.split(': ')[1];
            return ListTile(
              title: Text(meal, style: TextStyle(color: Colors.white)),
              trailing: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Рецепт: $mealName'),
                      content: Text(recipes[mealName] ?? 'Рецепт не найден'),
                      actions: [
                        TextButton(
                          child: Text('Закрыть'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('Подробнее'),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Profile> profiles = [];
  Profile? selectedProfile;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  void _loadProfiles() {
    // Загрузка профилей из локального хранилища или базы данных
    // Для примера, используем заглушки
    profiles = [
      Profile(name: 'John Doe', gender: 'Мужской', weight: 70, height: 175),
      Profile(name: 'Jane Smith', gender: 'Женский', weight: 60, height: 165),
    ];
    selectedProfile = profiles.first;
  }

  void _addProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProfileScreen(
          onProfileAdded: (profile) {
            setState(() {
              profiles.add(profile);
              selectedProfile = profile;
            });
          },
        ),
      ),
    );
  }

  void _selectProfile(Profile profile) {
    setState(() {
      selectedProfile = profile;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Замените на ваше изображение
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            if (profiles.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    final profile = profiles[index];
                    return ListTile(
                      title: Text(profile.name),
                      subtitle: Text('Пол: ${profile.gender}, Вес: ${profile.weight} кг, Рост: ${profile.height} см'),
                      onTap: () => _selectProfile(profile),
                    );
                  },
                ),
              ),
            ElevatedButton(
              onPressed: _addProfile,
              child: Text('Добавить профиль'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddProfileScreen extends StatefulWidget {
  final Function(Profile) onProfileAdded;

  AddProfileScreen({required this.onProfileAdded});

  @override
  _AddProfileScreenState createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _gender = 'Мужской';
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  void _saveProfile() {
    final name = _nameController.text;
    final weight = double.tryParse(_weightController.text) ?? 0.0;
    final height = double.tryParse(_heightController.text) ?? 0.0;

    if (name.isNotEmpty && weight > 0 && height > 0) {
      final profile = Profile(name: name, gender: _gender, weight: weight, height: height);
      widget.onProfileAdded(profile);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ошибка'),
          content: Text('Пожалуйста, заполните все поля корректно.'),
          actions: [
            TextButton(
              child: Text('ОК'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Имя (обязательно)'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: InputDecoration(labelText: 'Пол'),
              items: ['Мужской', 'Женский'].map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Вес (кг)'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Рост (см)'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}

class Profile {
  final String name;
  final String gender;
  final double weight;
  final double height;

  Profile({required this.name, required this.gender, required this.weight, required this.height});
}
