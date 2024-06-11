import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/notification_bloc.dart';
import 'blocs/reader_bloc.dart';
import 'blocs/settings_bloc.dart';
import 'common/constants.dart';
import 'common/layout_constants.dart';
import 'localizations/app_localizations.dart';
import 'models/app_settings.dart';
import 'navigation/reader_navigation_observer.dart';
import 'services/data_service.dart';
import 'services/notification_service.dart';
import 'widgets/common/responsive_layout.dart';
import 'widgets/loading_indicator.dart';
import 'widgets/pages/main_page.dart';
import 'widgets/pages/reminders_page.dart';
import 'widgets/pages/ruku_reader_page.dart';
import 'widgets/pages/settings_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataService().initialize();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _settings = AppSettings();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(

      providers: [
        BlocProvider<SettingsBloc>(
          create: (BuildContext context) => SettingsBloc()..add(ReadSettingsBlocEvent())
        ),
        BlocProvider<ReaderBloc>(
          create: (BuildContext context) => ReaderBloc()
        ),
        BlocProvider<NotificationBloc>(
          create: (BuildContext context) => NotificationBloc()..add(InitializeEvent())
        ),
      ],

      child: LayoutBuilder(
        builder: (context, constraints) {
          return ResponsiveLayoutProvider(

            constraints: constraints,
            breakpoints:  ResponsiveValue.from(small: 600, medium: 1200),
            provider: (layout) {
              // if (!kIsWeb && layout.isSmall) {
              //   _setPortraitOnlyMode();
              // }
              layout.provideAll(AppLayoutConstants.layout);
              layout.provideAll(DialogLayoutConstants.layout);
            },

            child: BlocListener<SettingsBloc, SettingsBlocState>(
              listener: (BuildContext context, state) {
                log("Main> listener SettingsBloc: $state");
                if(state is SettingsReadBlocState) {
                  log("Main> SettingsReadBlocState: ${state.settings}");
                  setState(() {
                    _settings = state.settings;
                  });
                }
              },
              child: _buildApp(context, _settings),
            ),
          );
        }
      ),
    );
  }

  MaterialApp _buildApp(BuildContext context, AppSettings settings) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) => context.localizations.translate("app_title"),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: Constants.locales.map((locale) => Locale(locale, '')),
      locale: Locale(settings.locale),
      localeResolutionCallback: (locale, supportedLocales) {
        return supportedLocales.firstWhere(
          (l) => l.languageCode == locale?.languageCode,
          orElse: () => supportedLocales.first
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InitialRouteHandler(),
      navigatorObservers: [ReaderNavigationObserver(context: context)],
      routes: {
        KnownRouteNames.main: (context) => const MainPage(),
        KnownRouteNames.readruku: (context) => const RukuReaderPage(),
        KnownRouteNames.reminders: (context) => const RemindersPage(),
        KnownRouteNames.settings: (context) => const SettingsPage(),
      },
    );
  }
}

class InitialRouteHandler extends StatelessWidget {
  const InitialRouteHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationBlocState>(
      builder: (context, state) {

        if (state is NotificationInitializedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(_getInitialRoute(state.appLaunchInfo));
          });
        }

        return const Scaffold(
          body: Center(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: LoadingIndicator(message: "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ")
            )
          )
        );
      }
    );
  }

  String _getInitialRoute(AppLaunchInfo info) {
    return info.isNotificationLaunch ? KnownRouteNames.readruku : KnownRouteNames.main;
  }
}