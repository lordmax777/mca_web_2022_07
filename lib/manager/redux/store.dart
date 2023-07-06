import 'package:redux/redux.dart';
import 'redux.dart';

final appStore = Store<AppState>(
  appReducer,
  middleware: [
    GeneralMiddleware(),
  ],
  initialState: AppState.initial(),
);
