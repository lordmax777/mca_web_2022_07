import '../../theme/theme.dart';

class TablePaginationWidget extends StatelessWidget {
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final int currentPage;
  final int limit;
  const TablePaginationWidget(
      {Key? key,
      required this.totalPages,
      this.limit = 7,
      required this.onPageChanged,
      required this.currentPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If list of numbers are more than 8, then show 3 dots in the middle;
    // If list of numbers are less than 8, then show all numbers;

    return SpacedRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      horizontalSpace: 1.0,
      children: [
        _PreviousNextButton(onTap: _onPreviousPage),
        const SizedBox(width: 7.0),
        ..._builder(),
        const SizedBox(width: 7.0),
        _PreviousNextButton(isNext: true, onTap: _onNextPage),
      ],
    );
  }

  List<Widget> _builder() {
    final tp = totalPages;
    final cp = currentPage;
    final int lim = limit;
    int t = totalPages;
    List<Widget> pages = [];

    if (tp > lim) {
      if (cp == 1 || cp == 2) {
        // 1 2 ... 8
        if (1 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(1));
        }
        if (2 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(2));
        }
        if (3 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(3));
        }
        if (4 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(4));
        }
        if (5 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(5));
        }
        pages.add(_dots());
        if (tp == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(tp));
        }
      }
      if (cp > 2 && cp < tp - 1) {
        // 1 ... 3 ... 8
        if (1 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(1));
        }
        pages.add(_dots());
        if (cp - 1 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(cp - 1));
        }
        if (cp == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(cp));
        }
        if (cp + 1 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(cp + 1));
        }
        pages.add(_dots());
        if (tp == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(tp));
        }
      }
      if (cp == tp - 1 || cp == tp) {
        // 1 ... 7 8
        if (1 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(1));
        }
        pages.add(_dots());
        if (tp - 4 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(tp - 4));
        }
        if (tp - 3 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(tp - 3));
        }
        if (tp - 2 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(tp - 2));
        }
        if (tp - 1 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(tp - 1));
        }
        if (tp == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(tp));
        }
      }
    } else {
      for (int i = 1; i <= tp; i++) {
        if (i == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(i));
        }
      }
    }

    return pages;
  }

  Widget _dots() {
    return Row(
      children: [
        const SizedBox(width: 14.0),
        KText(
          text: "...",
          isSelectable: false,
          fontSize: 16.0,
          textColor: Colors.black,
          fontWeight: FWeight.bold,
        ),
        const SizedBox(width: 14.0),
      ],
    );
  }

  Widget _isSelectedBtn() {
    return TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0)),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            return ThemeColors.blue3;
          }),
        ),
        onPressed: null,
        child: KText(
            text: currentPage.toString(),
            textColor: ThemeColors.white,
            fontWeight: FWeight.medium,
            fontSize: 16.0,
            isSelectable: false));
  }

  Widget _isUnSelectedBtn(int i) {
    return TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0)),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            return ThemeColors.transparent;
          }),
        ),
        child: KText(
            text: i.toString(),
            textColor: ThemeColors.gray2,
            fontWeight: FWeight.medium,
            fontSize: 16.0,
            isSelectable: false),
        onPressed: () => _onNumberTap(i));
  }

  void _onNumberTap(int i) {
    onPageChanged(i);
  }

  void _onPreviousPage() {
    //If currentPage is 1, then do nothing;
    //If currentPage is > 1, then set currentPage to currentPage - 1;
    if (currentPage == 1) {
      return;
    }
    onPageChanged(currentPage - 1);
  }

  void _onNextPage() {
    final int lastPage = totalPages;

    //If currentPage is lastPage, then do nothing;
    //If currentPage is < lastPage, then set currentPage to currentPage + 1;

    if (currentPage == lastPage) {
      return;
    }
    onPageChanged(currentPage + 1);
  }
}

class _PreviousNextButton extends StatelessWidget {
  final bool isNext;
  final VoidCallback? onTap;
  const _PreviousNextButton({Key? key, this.isNext = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isNext) {
      return TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0)),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return ThemeColors.transparent;
            }),
          ),
          onPressed: onTap,
          child: SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 8.0,
            children: [
              KText(
                  isSelectable: false,
                  text: "Next",
                  fontSize: 16.0,
                  textColor: ThemeColors.gray2,
                  fontWeight: FWeight.medium),
              const HeroIcon(HeroIcons.right,
                  size: 15, color: ThemeColors.gray2),
            ],
          ));
    }
    return TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0)),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            return ThemeColors.transparent;
          }),
        ),
        onPressed: onTap,
        child: SpacedRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          horizontalSpace: 8.0,
          children: [
            const HeroIcon(HeroIcons.left, size: 15, color: ThemeColors.gray2),
            KText(
                text: "Prev",
                textColor: ThemeColors.gray2,
                fontWeight: FWeight.medium,
                fontSize: 16.0,
                isSelectable: false),
          ],
        ));
  }
}
