import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import './screens/splash_screen.dart';
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
// import './providers/auth.dart';
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
          create: (_) => ProductsProvider(
              // auth.token,
              // auth.userId,
              // previousProducts == null ? [] : previousProducts.items,
              ),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Order(
              // auth.token,
              // auth.userId,
              // previousData == null ? [] : previousData.orders,
              ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.deepOrange,
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
                    // :
                    // FutureBuilder(
                    //     future: authData.tryAutoLogin(),
                    //     builder: (ctx, authDataSnapshot) =>
                    //         authDataSnapshot.connectionState ==
                    //                 ConnectionState.waiting
                    //             ? const SplashScreen()
                    : const AuthScreen(),
                // ),
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
