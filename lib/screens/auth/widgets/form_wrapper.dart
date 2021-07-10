import 'package:auth_demo/common/providers/async_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ResponsiveAsyncFormWrapper extends ConsumerWidget {
  const ResponsiveAsyncFormWrapper({
    Key key,
    @required Widget child,
  })  : _child = child,
        super(key: key);

  final Widget _child;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ModalProgressHUD(
          inAsyncCall: watch(asyncStateProvider),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: _child,
              ),
            ),
          ),
        );
      },
    );
  }
}
