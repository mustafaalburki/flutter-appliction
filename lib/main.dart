import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: Colors.blue.shade700,
          secondary: Colors.blue.shade300,
          background: Colors.grey.shade100,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.blue.shade200,
          secondary: Colors.blue.shade500,
          background: Colors.grey.shade900,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        toggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
        isDarkMode: isDarkMode,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String userInput = "";
  String passwordInput = "";

  @override
  void dispose() {
    textController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<String> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return "تم تحميل البيانات بنجاح 🎉";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "الصفحة الرئيسية",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: widget.isDarkMode
                    ? [Colors.black87, Colors.black54]
                    : [Colors.blue.shade300, Colors.blue.shade900],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 80),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: widget.isDarkMode ? Colors.black54 : Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "الرجاء إدخال اسم المستخدم",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: textController,
                            decoration: const InputDecoration(
                              hintText: "USER NAME...",
                              prefixIcon: Icon(Icons.edit),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "الرجاء إدخال كلمة المرور",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: "PASSWORD...",
                              prefixIcon: Icon(Icons.lock),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                userInput = textController.text;
                                passwordInput = passwordController.text;
                              });
                              if (userInput.isNotEmpty && passwordInput.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("تم حفظ النص: $userInput و كلمة المرور"),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.send),
                            label: const Text("إرسال"),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "النص المدخل: $userInput",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (userInput.isNotEmpty && passwordInput.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecondScreen(
                              userInput: userInput,
                              passwordInput: passwordInput,
                              isDarkMode: widget.isDarkMode,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("يرجى إدخال البيانات أولاً."),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("الانتقال إلى الصفحة الثانية"),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return RotationTransition(turns: animation, child: child);
              },
              child: IconButton(
                key: ValueKey<bool>(widget.isDarkMode),
                icon: Icon(
                  widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: widget.toggleTheme,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final String userInput;
  final String passwordInput;
  final bool isDarkMode;

  const SecondScreen({
    Key? key,
    required this.userInput,
    required this.passwordInput,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'عرض البيانات المدخلة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [Colors.black87, Colors.black54]
                : [Colors.blue.shade300, Colors.blue.shade900],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.account_circle, size: 60, color: Colors.blue),
                        const SizedBox(height: 15),
                        const Text(
                          'إسم المستخدم:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          userInput.isNotEmpty ? userInput : 'لم يتم إدخال بيانات',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'كلمة المرور:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          passwordInput.isNotEmpty ? passwordInput : 'لم يتم إدخال كلمة مرور',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
