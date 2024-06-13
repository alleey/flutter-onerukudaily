
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/constants.dart';
import '../models/ruku.dart';
import '../models/statistics.dart';
import '../services/app_data_service.dart';
import '../services/asset_service.dart';

////////////////////////////////////////////

abstract class ReaderBlocEvent {}

class ReadRukuBlocEvent extends ReaderBlocEvent {
  ReadRukuBlocEvent({ this.index, this.goNext = true  });
  final int? index;
  final bool goNext;
}

class ClearReaderStateBlocEvent extends ReaderBlocEvent {}

class ResetBlocEvent extends ReaderBlocEvent {
  ResetBlocEvent({ this.userInitiated = false  });
  final bool userInitiated;
}

////////////////////////////////////////////

class ReaderBlocState {
  ReaderBlocState();
}

class RukuAvailableState extends ReaderBlocState {
  RukuAvailableState({ required this.ruku });
  final Ruku ruku;
}

class RukuIndexExhaustedState extends ReaderBlocState {
  RukuIndexExhaustedState();
}

////////////////////////////////////////////

class ReaderBloc extends Bloc<ReaderBlocEvent, ReaderBlocState>
{
  final _assetService = AssetService();
  final _appDataService = AppDataService();
  Statistics _statistics = Statistics();

  ReaderBloc() : super(ReaderBlocState())
  {
    _appDataService.putIfAbsent("statistics", _statistics.toJsonStriing());

    on<ClearReaderStateBlocEvent>((event, emit) async {
      emit(ReaderBlocState());
    });

    on<ResetBlocEvent>((event, emit) async {
      add(ClearReaderStateBlocEvent());
      _appDataService.setRukuIndex(1);
      add(ReadRukuBlocEvent(goNext: true));
    });

    on<ReadRukuBlocEvent>((event, emit) async {

      int rukuNum = event.index ?? _appDataService.rukuIndex;
      _statistics = StatisticsExtensions.fromJsonString(_appDataService.get("statistics", ""));

      try {
          emit(RukuIndexExhaustedState());
          return;

        if (rukuNum < 1) {
          return;
        }

        if (rukuNum > Ruku.lastRukuIndex) {
          emit(RukuIndexExhaustedState());
          return;
        }

        log("Loading ruku $rukuNum");

        final ruku = await _assetService.loadRuku(rukuNum);
        if (event.goNext) {
          _statistics = _statistics.update(rukuNum: rukuNum);
          _appDataService.setRukuIndex(rukuNum + 1);
        }

        _appDataService.put("statistics", _statistics.toJsonStriing());

        log("Loaded ruku $ruku");
        emit(RukuAvailableState(ruku: ruku!));
      }
      catch(e)
      {
        log("Exception ruku $e");
        emit(RukuIndexExhaustedState());
      }
    });
  }
}

extension QuranBlocContextExtensions on BuildContext {
  ReaderBloc get readerBloc => BlocProvider.of<ReaderBloc>(this);
}
