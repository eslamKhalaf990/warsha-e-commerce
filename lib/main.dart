import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warsha_commerce/services/products_service.dart';
import 'package:warsha_commerce/view_models/product_v_m.dart';
import 'package:warsha_commerce/views/home.dart';
import 'package:warsha_commerce/views/shopping_cart.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        //providers used for dependency injection
        Provider<ProductService>(create: (_) => ProductService()),


        //injecting product with api services
        ChangeNotifierProvider<ProductVM>(
          create: (context) => ProductVM(
            context.read<ProductService>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Warsha',
      debugShowCheckedModeBanner: false,
        // Use settings model locale, fallback to 'en'
        locale: Locale('ar', 'AE'),
        supportedLocales: const [
          Locale('ar', 'AE'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      theme: ThemeData(
        fontFamily: 'cairo',
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black.withAlpha(200),
          selectionColor: Colors.black.withAlpha(50),
          selectionHandleColor: Colors.black.withAlpha(50),
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey.shade300,
        ),
        colorScheme: ColorScheme.light(
          onPrimary: Colors.white,
          onTertiary: Colors.white,
          secondary: Colors.black87,
          onSurface: Colors.grey.shade700,
          surface: Colors.grey.shade50,
          primary: Colors.grey.shade300,
        ),
      ),
      home: const Home(),
      routes: {
        '/home': (context) => const Home(),
        '/shopping_cart': (context) => const ShoppingCart(),
      }
    );
  }
}