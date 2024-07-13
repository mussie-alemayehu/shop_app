import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './firebase_options.dart';
import './screens/auth_screen.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_products_screen.dart';
import './providers/cart_provider.dart';
import './providers/products_provider.dart';
import './providers/order_provider.dart';
import './helpers/custom_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Order(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color.fromARGB(255, 244, 244, 244),
          colorScheme: ColorScheme.light(
            // primary: const Color.fromARGB(255, 39, 60, 176),
            secondary: Colors.grey.shade800,
          ),
          canvasColor: const Color.fromARGB(235, 255, 239, 254),
          fontFamily: 'Lato',
          inputDecorationTheme: InputDecorationTheme(
            focusColor: Theme.of(context).primaryColor,
          ),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionsBuilder(),
              TargetPlatform.iOS: CustomPageTransitionsBuilder(),
            },
          ),
        ),
        routes: {
          '/': (_) => StreamBuilder(
                stream: firebaseAuth.authStateChanges(),
                builder: (ctx, snapshot) => snapshot.hasData
                    ? const ProductOverviewScreen()
                    : const AuthScreen(),
              ),
          ProductDetailsScreen.routeName: (_) => const ProductDetailsScreen(),
          CartScreen.routeName: (_) => const CartScreen(),
          OrdersScreen.routeName: (_) => const OrdersScreen(),
          UserProductsScreen.routeName: (_) => const UserProductsScreen(),
          EditProductsScreen.routeName: (_) => const EditProductsScreen(),
        },
      ),
    );
  }
}
