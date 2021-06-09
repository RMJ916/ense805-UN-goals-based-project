import 'package:flutter/material.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';

class PrimaryButton extends StatefulWidget {
  String title;
  Function onPressed;
  bool isloading;
  double width;
  Color foregroundColor, backgroundColor;
  double fontsize;
  double height;
  double borderRadius;

  PrimaryButton(
      {this.title,
      this.width,
      this.onPressed,
      this.foregroundColor,
      this.backgroundColor,
      this.fontsize,
      this.height,
      this.borderRadius,
      this.isloading});
  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: widget.isloading ? null : widget.onPressed,
        child: Container(
          decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius == null
                  ?buttonRadius
                  : widget.borderRadius)),
          height: widget.height == null ? 50 : widget.height,
          width: widget.width != null
              ? widget.width
              : MediaQuery.of(context).size.width,
          child: Center(
            child: widget.isloading
                ? Center(
                    child: Container(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          widget.foregroundColor),
                      backgroundColor: widget.backgroundColor,
                    ),
                  ))
                : Text(
                    widget.title,
                    style: TextStyle(
                        color: widget.foregroundColor,
                        fontSize: widget.fontsize == null ? 24 : widget.fontsize,
                        fontWeight: FontWeight.w700),
                  ),
          ),
        ),
      ),
    );
  }
}