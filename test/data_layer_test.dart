import 'package:flutter_test/flutter_test.dart';

import 'package:redux/redux.dart';

final class IncrementAction {
  const IncrementAction();
}

void main() {
  //setup
  final store = Store<int>((int state, dynamic action) {
    return state + 1;
  }, initialState: 0);

  //group test, I will have a lot of actions
  group('Test Redux', () {
    test('Test increment', () {
      print('Test increment START');
      print(store.state);

      //act
      store.dispatch(const IncrementAction());

      //assert
      expect(store.state, 1);
      print(store.state);
      print('Test increment END');
    });
  });
}
