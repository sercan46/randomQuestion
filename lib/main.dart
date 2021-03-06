import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:random_question/add_favorite.dart';
import 'package:random_question/core/constants/app/app_constants.dart';
import 'package:random_question/core/constants/navigation/navigation_constants.dart';
import 'package:random_question/core/init/lang/language_manager.dart';
import 'package:random_question/core/init/navigation/navigation_route.dart';
import 'package:random_question/core/init/navigation/navigation_service.dart';
import 'package:random_question/core/init/notifier/provider_list.dart';
import 'core/init/theme/custom_theme.dart';

late Box box;
Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(AddFavoriteAdapter());
  box = await Hive.openBox('box');
}

Future<void> main() async {
  await _init();

  runApp(
    MultiProvider(
      providers: [...ApplicationProvider.instance.dependItems],
      child: EasyLocalization(
        child: const MyApp(),
        supportedLocales: LanguageManager.instance.supportedLocales,
        path: AppConstants.LANG_ASSET_PATH,
        startLocale: LanguageManager.instance.trLocale,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Question',
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      initialRoute: NavigationConstants.DEFUALT,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateRoute: NavigationRoute.instance.generateRoute,
      navigatorKey: NavigationService.instance.navigatorKey,
    );
  }
}
