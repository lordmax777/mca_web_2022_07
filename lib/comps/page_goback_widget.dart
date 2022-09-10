import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/app.dart';

import '../manager/redux/sets/app_state.dart';
import '../theme/theme.dart';

class PageGobackWidget extends StatelessWidget {
  final String? text;
  const PageGobackWidget({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          final user = state.usersState.selectedUser;
          final String _title =
              user == null ? 'New User' : "${user.fullname} (${user.username})";
          return SpacedRow(
            horizontalSpace: 16.0,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const HeroIcon(
                  HeroIcons.arrowLeft,
                  size: 32.0,
                ),
                onPressed: () => appRouter.navigateBack(),
              ),
              KText(
                  text: text ?? _title,
                  fontWeight: FWeight.bold,
                  isSelectable: true,
                  fontSize: 24.0,
                  textColor: ThemeColors.black),
            ],
          );
        });
  }
}
