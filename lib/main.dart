import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/order_provider.dart';
import 'screens/menu_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/admin_dashboard.dart';
import 'services/db_helper.dart';
import 'services/network_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize DB in background to not block UI
  DBHelper.instance.initDB().catchError((error) {
    debugPrint('DB initialization error: $error');
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => NetworkService()),
      ],
      child: MaterialApp(
        title: "Mallang's Momos POS",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        initialRoute: '/',
        routes: {
          '/': (_) => const MenuScreen(),
          '/cart': (_) => const CartScreen(),
          '/orders': (_) => const OrderHistoryScreen(),
          '/admin': (_) => const AdminDashboard(),
        },
      ),
    );
  }
}
