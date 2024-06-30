
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/reader_bloc.dart';
import '../models/ruku.dart';
import '../models/statistics.dart';


class ReaderState {
  final int rukuNumber;
  final Statistics statistics;
  final Ruku? ruku;

  ReaderState({
    required this.rukuNumber,
    required this.statistics,
    this.ruku
  });

  bool get isDailyRuku => rukuNumber == (ruku?.index ?? -1);
}

class ReaderListenerBuilder extends StatefulWidget {

  const ReaderListenerBuilder({
    super.key,
    required this.builder,
    this.onStateChange,
    this.onStateAvailable,
    this.onQuranCompleted,
    this.onBlocState,
  });

  final Widget Function(BuildContext context, ValueNotifier<ReaderState> stateProvider) builder;
  final void Function(ReaderState newState)? onStateChange;
  final void Function(ReaderState state)? onStateAvailable;
  final void Function(ReaderState state)? onQuranCompleted;
  final void Function(ReaderBlocState state)? onBlocState;

  @override
  State<ReaderListenerBuilder> createState() => _ReaderListenerBuilderState();
}

class _ReaderListenerBuilderState extends State<ReaderListenerBuilder> {

  late ValueNotifier<ReaderState> _changeNotifier;

  @override
  void initState() {
    super.initState();
    _changeNotifier  = ValueNotifier<ReaderState>(
      ReaderState(
        rukuNumber: context.readerBloc.dailyRukuNumber,
        statistics: context.readerBloc.statistics,
      )
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onStateAvailable?.call(_changeNotifier.value);
      }
    });
  }

  @override
  void dispose() {
    _changeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<ReaderBloc, ReaderBlocState>(
      listener: (BuildContext context, state) {

        if(state is NoMoreRukuBlocState) {
          widget.onQuranCompleted?.call(_changeNotifier.value);
        }

        if(state is RukuLoadedBlocState) {

          _changeNotifier.value = ReaderState(
            rukuNumber: context.readerBloc.dailyRukuNumber,
            statistics: state.statistics,
            ruku: state.ruku
          );
          widget.onStateAvailable?.call(_changeNotifier.value);
          widget.onStateChange?.call(_changeNotifier.value);
        }

        widget.onBlocState?.call(state);

      },
      child: widget.builder(context, _changeNotifier),
    );
  }
}