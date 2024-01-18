import 'package:flutter/material.dart';

class Toolbar extends StatefulWidget {
  final bool create;
  final bool edit;
  final bool remove;
  final String context;
  final int? idCurrentElement;

  Toolbar({this.create = true, this.edit = true, this.remove = true, required this.context, this.idCurrentElement});

  @override
  _ToolbarState createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  bool isValidId() {
    return widget.idCurrentElement != null && widget.idCurrentElement != 0;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (widget.create) {
      children.add(
        GestureDetector(

          child: Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (isValidId()) {
                    // Votre logique ici lorsque idCurrentElement est différent de 0
                    print('idCurrentElement is valid');
                  }
                },
              ),
            ),
          ),
        ),
      );
    }

    if (widget.edit) {
      children.add(
        GestureDetector(

          child: Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  if (isValidId()) {
                    // Votre logique ici lorsque idCurrentElement est différent de 0
                    print('idCurrentElement is valid');
                  }
                },
              ),
            ),
          ),
        ),
      );
    }

    if (widget.remove) {
      children.add(
        GestureDetector(

          child: Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  if (isValidId()) {
                    // Votre logique ici lorsque idCurrentElement est différent de 0
                    print('idCurrentElement is valid');
                  }
                },
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }
}


