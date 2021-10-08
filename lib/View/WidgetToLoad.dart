import 'package:flutter/material.dart';
import 'package:together/Core/SnapshotLoader.dart';

class WidgetToLoad extends StatelessWidget {
  const WidgetToLoad(
      {Key key,
      @required this.viewModel,
      this.placeholder,
      @required this.child})
      : super(key: key);

  final SnapshotLoader viewModel;
  final Widget placeholder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: false,
      stream: viewModel.isLoading,
      builder: (context, snapshot) {
        return snapshot.data == true
            ? placeholder == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : placeholder
            : child;
      },
    );
  }
}
