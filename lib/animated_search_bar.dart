import 'package:flutter/material.dart';

///*********************************************
/// Created by ukietux on 22/09/20 with ♥
/// (>’_’)> email : ukie.tux@gmail.com
/// github : https://www.github.com/ukieTux <(’_’<)
///*********************************************
/// © 2020 | All Right Reserved
class AnimatedSearchBar extends StatefulWidget {
  AnimatedSearchBar({
    Key key,
    this.label,
    this.onChanged,
    this.labelStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    this.searchDecoration = const InputDecoration(
        labelText: "Search",
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)), gapPadding: 4)),
    this.animationDuration = 350,
    this.searchStyle = const TextStyle(color: Colors.black),
    this.cursorColor,
  }) : super(key: key);

  final String label;
  final Function(String) onChanged;
  final TextStyle labelStyle;
  final InputDecoration searchDecoration;
  final int animationDuration;
  final TextStyle searchStyle;
  final Color cursorColor;

  @override
  _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  bool _isSearch = false;
  var _fnSearch = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Handle Animated Change view for Title and TextField Search
        Expanded(
            flex: 85,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: widget.animationDuration),
              transitionBuilder: (Widget child, Animation<double> animation) {
                //animated from right to left
                final inAnimation = Tween<Offset>(
                        begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                    .animate(animation);
                //animated from left to right
                final outAnimation = Tween<Offset>(
                        begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
                    .animate(animation);

                if (child.key == ValueKey("textF")) {
                  return ClipRect(
                    child: SlideTransition(position: inAnimation, child: child),
                  );
                } else {
                  return ClipRect(
                    child:
                        SlideTransition(position: outAnimation, child: child),
                  );
                }
              },
              child: _isSearch
                  ? Container(
                      key: ValueKey("textF"),
                      height: 60,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            focusNode: _fnSearch,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search,
                            textAlign: TextAlign.start,
                            style: widget.searchStyle,
                            minLines: 1,
                            maxLines: 1,
                            cursorColor:
                                widget.cursorColor ?? ThemeData().primaryColor,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: widget.searchDecoration,
                            onChanged: widget.onChanged,
                          )),
                    )
                  : SizedBox(
                      key: ValueKey("align"),
                      height: 60,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.label,
                          style: widget.labelStyle,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
            )),
        // Handle Animated Change view for Search Icon and Close Icon
        Expanded(
          flex: 10,
          child: IconButton(
            icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 350),
              transitionBuilder: (Widget child, Animation<double> animation) {
                //animated from top to bottom
                final inAnimation = Tween<Offset>(
                        begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                    .animate(animation);
                //animated from bottom to top
                final outAnimation = Tween<Offset>(
                        begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                    .animate(animation);

                if (child.key == ValueKey("close")) {
                  return ClipRect(
                    child: SlideTransition(
                      position: inAnimation,
                      child: child,
                    ),
                  );
                } else {
                  return ClipRect(
                    child:
                        SlideTransition(position: outAnimation, child: child),
                  );
                }
              },
              child: _isSearch
                  ? Icon(
                      Icons.close,
                      key: ValueKey("close"),
                    )
                  : Icon(Icons.search, key: ValueKey("search")),
            ),
            onPressed: () {
              setState(() {
                _isSearch = !_isSearch;
                if (!_isSearch) widget.onChanged("");
                if (_isSearch) _fnSearch.requestFocus();
              });
            },
          ),
        )
      ],
    );
  }
}