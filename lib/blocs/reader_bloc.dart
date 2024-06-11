
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/constants.dart';
import '../models/ruku.dart';
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
  final assetService = AssetService();
  final appDataService = AppDataService();

  ReaderBloc() : super(ReaderBlocState())
  {
    on<ClearReaderStateBlocEvent>((event, emit) async {
        emit(ReaderBlocState());
    });

    on<ReadRukuBlocEvent>((event, emit) async {

      int index = event.index ?? appDataService.currentRukuIndex;
      try {

        if (index < 1) {
          return;
        }

        if (index > Ruku.lastRukuIndex) {
          emit(RukuIndexExhaustedState());
          return;
        }

        log("Loading ruku $index");

        final ruku = await assetService.loadRuku(index);
        if (event.goNext) {
          appDataService.put(KnownSettingsNames.rukuIndex, index + 1);
        }

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
