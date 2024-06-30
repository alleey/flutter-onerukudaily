import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/notification_bloc.dart';
import 'blocs/reader_bloc.dart';
import 'blocs/settings_bloc.dart';
import 'common/constants.dart';
import 'common/layout_constants.dart';
import 'common/native.dart';
import 'localizations/app_localizations.dart';
import 'models/app_settings.dart';
import 'navigation/reader_navigation_observer.dart';
import 'services/data_service.dart';
import 'services/notification_service.dart';
import 'services/prompt_serivce.dart';
import 'widgets/common/responsive_layout.dart';
import 'widgets/loading_indicator.dart';
import 'widgets/pages/about_page.dart';
import 'widgets/pages/main_page.dart';
import 'widgets/pages/reminders_page.dart';
import 'widgets/pages/ruku_reader_page.dart';
import 'widgets/pages/settings_page.dart';
import 'widgets/pages/stats_page.dart';
import 'widgets/settings_aware_builder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataService().initialize();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _settings = AppSettings();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

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
          create: (BuildContext context) => NotificationBloc()..add(InitializeNotificationsEvent())
        ),
      ],

      child: LayoutBuilder(
        builder: (context, constraints) {
          return ResponsiveLayoutProvider(

            constraints: constraints,
            breakpoints:  ResponsiveValue.from(small: 600, medium: 1200),
            provider: (layout) {

              if (!kIsWeb && layout.isSmall) {
                _setPortraitOnlyMode();
              }

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
      navigatorObservers: [ReaderNavigationObserver(context: context)],
      routes: {
        KnownRouteNames.about: (context) => const AboutPage(),
        KnownRouteNames.main: (context) => const MainPage(),
        KnownRouteNames.readruku: (context) => const RukuReaderPage(),
        KnownRouteNames.reminders: (context) => const RemindersPage(),
        KnownRouteNames.settings: (context) => const SettingsPage(),
        KnownRouteNames.statistics: (context) => const StatisticsPage(),
      },
      home: const InitialRouteHandler(),
    );
  }

  Future<void> _setPortraitOnlyMode() async
    => SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class InitialRouteHandler extends StatelessWidget {
  const InitialRouteHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsAwareBuilder(
      builder: (context, settingsNotifier) => ValueListenableBuilder(
        valueListenable: settingsNotifier,
        builder: (context, settings, child) =>  _buildContents(context, settings)
      ),
    );
  }

  Widget _buildContents(BuildContext context, AppSettings settings) {
    final scheme = settings.currentScheme;
    return BlocListener<NotificationBloc, NotificationBlocState>(
      listener: (context, state) async {

        if (state is NotificationInitializedState) {

          context.notificationBloc.add(ScheduleNotifications(
            PromptSerivce(localizations: context.localizations)
          ));

          // Hack neded on Android TV for autofocus effects
          await setTraditionalFocusHighlightStrategy();

          WidgetsBinding.instance.addPostFrameCallback((_)  {
            Navigator.of(context, rootNavigator: true).pushReplacementNamed(_getInitialRoute(state.appLaunchInfo));
          });
        }
      },
      child: Scaffold(
        body: Container(
          color: scheme.page.background,
          child: const Center(
            child: LoadingIndicator(message: Constants.loaderText, direction: TextDirection.rtl)
          ),
        )
      )
    );
  }

  String _getInitialRoute(AppLaunchInfo info) {
    return info.isNotificationLaunch ? KnownRouteNames.readruku : KnownRouteNames.main;
  }
}