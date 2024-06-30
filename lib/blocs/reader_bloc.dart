
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/ruku.dart';
import '../models/statistics.dart';
import '../services/app_data_service.dart';
import '../services/asset_service.dart';

////////////////////////////////////////////

abstract class ReaderBlocEvent {}

class GetNextDailyRukuBlocEvent extends ReaderBlocEvent {}

// Only view the Ruku without updating the daily ruku marker or statistics
class ViewRukuBlocEvent extends ReaderBlocEvent {
  ViewRukuBlocEvent({ required this.index  });
  final int index;
}

class SetDailyRukuBlocEvent extends ReaderBlocEvent {
  SetDailyRukuBlocEvent({ required this.index  });
  final int index;
}


class ClearReaderStateBlocEvent extends ReaderBlocEvent {}

class StartNewReadingBlocEvent extends ReaderBlocEvent {
  StartNewReadingBlocEvent({ this.userInitiated = false  });
  final bool userInitiated;
}

////////////////////////////////////////////

class ReaderBlocState {
  ReaderBlocState();
}

class RukuLoadedBlocState extends ReaderBlocState {
  RukuLoadedBlocState({ required this.ruku, required this.statistics });
  final Ruku ruku;
  final Statistics statistics;
}

class NoMoreRukuBlocState extends ReaderBlocState {
  NoMoreRukuBlocState({ required this.statistics });
  final Statistics statistics;
}


class SetDailyRukuBlocState extends ReaderBlocState {
  SetDailyRukuBlocState({ required this.index  });
  final int index;
}

class RukuErrorState extends ReaderBlocState {}

////////////////////////////////////////////

class ReaderBloc extends Bloc<ReaderBlocEvent, ReaderBlocState>
{
  final _assetService = AssetService();
  final _appDataService = AppDataService();
  var _statistics = Statistics();

  int get dailyRukuNumber => _appDataService.dailyRukuNumber;
  Statistics get statistics => _statistics;

  ReaderBloc() : super(ReaderBlocState())
  {
    _appDataService.putIfAbsent("statistics", _statistics.toJsonStriing());
    _statistics = StatisticsExtensions.fromJsonString(_appDataService.get("statistics", ""));

    on<ClearReaderStateBlocEvent>((event, emit) async {
      emit(ReaderBlocState());
    });

    on<StartNewReadingBlocEvent>((event, emit) async {
      add(ClearReaderStateBlocEvent());
      _appDataService.setDailyRukuNumber(1);
      add(GetNextDailyRukuBlocEvent());
    });

    on<SetDailyRukuBlocEvent>((event, emit) async {
      if (event.index < 1 || event.index > Ruku.lastRukuIndex) {
        return;
      }

      log("SetDailyRukuBlocEvent index ${event.index}");
      _appDataService.setDailyRukuNumber(event.index);

      emit(SetDailyRukuBlocState(index: event.index));
      add(ViewRukuBlocEvent(index: event.index));
    });

    on<ViewRukuBlocEvent>(_onViewRuku);
    on<GetNextDailyRukuBlocEvent>(_onGetNextDailyRuku);
  }

  Future<void> _onViewRuku(ViewRukuBlocEvent event, emit) async {

    if (event.index < 1 || event.index > Ruku.lastRukuIndex) {
      return;
    }

    try {

      final ruku = await _assetService.loadRuku(event.index);
      log("ViewRuku ruku ${event.index}, dailyRukuNumber: $dailyRukuNumber");
      emit(RukuLoadedBlocState(ruku: ruku!, statistics: _statistics));
    }
    catch(e)
    {
      log("Exception ruku $e");
      emit(RukuErrorState());
    }
  }

  Future<void> _onGetNextDailyRuku(GetNextDailyRukuBlocEvent event, emit) async {

    int rukuNum = dailyRukuNumber + 1;
    if (rukuNum > Ruku.lastRukuIndex) {
      emit(NoMoreRukuBlocState(statistics: _statistics));
      return;
    }

    try {

      final ruku = await _assetService.loadRuku(rukuNum);
      log("DailyRuku ruku $rukuNum, dailyRukuNumber: $dailyRukuNumber");

      _statistics = _statistics.update(rukuNum: rukuNum);
      //log("statistics $_statistics");

      _appDataService.setDailyRukuNumber(rukuNum);
      _appDataService.put("statistics", _statistics.toJsonStriing());

      log("Loaded ruku $ruku");
      emit(RukuLoadedBlocState(ruku: ruku!, statistics: _statistics ));
    }
    catch(e)
    {
      log("Exception ruku $e");
      emit(RukuErrorState());
    }
  }
}

extension QuranBlocContextExtensions on BuildContext {
  ReaderBloc get readerBloc => BlocProvider.of<ReaderBloc>(this);
}
