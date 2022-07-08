/*
 * Copyright © 2020, Simform Solutions
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import 'package:flutter/material.dart';
import 'package:showcaseview/get_position.dart';
import 'package:showcaseview/measure_size.dart';
import 'package:showcaseview/showcase-button.dart';

class ToolTipWidget extends StatefulWidget {
  final GetPosition? position;
  final Offset? offset;
  final Size? screenSize;
  final String? title;
  final String? description;
  final Animation<double> animationOffset;
  final TextStyle? titleTextStyle;
  final TextStyle? descTextStyle;
  final Widget? container;
  final Color? tooltipColor;
  final Color? textColor;
  final bool showArrow;
  final double? contentHeight;
  final double? contentWidth;
  static bool isArrowUp = false;
  final VoidCallback? onTooltipTap;
  final EdgeInsets? contentPadding;
  //final Border border;
  final BorderRadius? showcaseShape;
  final List<ShowCaseButton> buttons;

  ToolTipWidget({
      this.position,
      this.offset,
      this.screenSize,
      this.title,
      this.description,
      required this.animationOffset,
      this.titleTextStyle,
      this.descTextStyle,
      this.container,
      this.tooltipColor,
      this.textColor,
      this.showArrow = false,
      this.contentHeight,
      this.contentWidth,
      this.onTooltipTap,
      this.contentPadding,
      //this.border,
      this.showcaseShape,
      this.buttons = const <ShowCaseButton>[]
  });

  @override
  _ToolTipWidgetState createState() => _ToolTipWidgetState();
}

class _ToolTipWidgetState extends State<ToolTipWidget> {
  final GlobalKey _key = GlobalKey();

  Offset position = Offset(0,0);

  bool isCloseToTopOrBottom(Offset position, GlobalKey key) {
    double height;
    try {
      final keyContext = key.currentContext;
      final box = keyContext?.findRenderObject() as RenderBox?;
      height = box?.size.height ?? 0;
      height += height*.1;
      if (height == 0) throw Exception();
    } catch(e) {
      height = MediaQuery.of(context).size.height/2;
    }
    height = widget.contentHeight ?? height;
    final sHeight = MediaQuery.of(context).size.height;
    return (sHeight - position.dy) <= height;
  }

  String findPositionForContent(Offset position, GlobalKey key) {
    if (isCloseToTopOrBottom(position, key)) {
      return 'ABOVE';
    } else {
      return 'BELOW';
    }
  }

  double _getTooltipWidth() {
    /*double titleLength = widget.title == null ? 0 : widget.title.length * 14.0;
    double descriptionLength = widget.description.length * (widget.buttons.isNotEmpty ? 12.0 : 10.0);
    var maxTextWidth = max(titleLength, descriptionLength);
    if (maxTextWidth > widget.screenSize.width - 20) {
      return widget.screenSize.width;
    } else {
      return maxTextWidth + 15;
    }*/
    return MediaQuery.of(context).size.width;
  }

  bool _isLeft() {
    double screenWidth = (widget.screenSize?.width ?? 0) / 3;
    return !(screenWidth <= (widget.position?.getCenter() ?? 0));
  }

  bool _isRight() {
    double screenWidth = (widget.screenSize?.width ?? 0) / 3;
    return ((screenWidth * 2) <= (widget.position?.getCenter() ?? 0));
  }

  double _getLeft() {
    if (_isLeft()) {
      double leftPadding = (widget.position?.getCenter() ?? 0) - (_getTooltipWidth() * 0.1);
      if (leftPadding + _getTooltipWidth() > (widget.screenSize?.width ?? 0)) {
        leftPadding = ((widget.screenSize?.width ?? 0) - 20) - _getTooltipWidth();
      }
      if (leftPadding < 20) {
        leftPadding = 14;
      }
      return leftPadding;
    } else if (!(_isRight())) {
      return (widget.position?.getCenter() ?? 0) - (_getTooltipWidth() * 0.5);
    } else {
      return .0;
    }
  }

  double _getRight() {
    if (_isRight()) {
      double rightPadding = (widget.position?.getCenter() ?? .0)
          + (_getTooltipWidth() / 2);
      if (rightPadding + _getTooltipWidth() > (widget.screenSize?.width ?? .0)) {
        rightPadding = 0;
      }
      return rightPadding;
    } else if (!(_isLeft())) {
      return (widget.position?.getCenter() ?? .0) - (_getTooltipWidth() * 0.5);
    } else {
      return .0;
    }
  }

  double _getSpace() {
    double space = (widget.position?.getCenter() ?? .0)
        - ((widget.contentWidth ?? 0) / 2);
    if (space + (widget.contentWidth ?? 0) > (widget.screenSize?.width ?? 0)) {
      space = (widget.screenSize?.width ?? .0) - (widget.contentWidth ?? 0) - 8;
    } else if (space < ((widget.contentWidth ?? 0) / 2)) {
      space = 16;
    }
    return space;
  }

  @override
  void initState() {
    super.initState();
    position = widget.offset ?? Offset(0,0);
  }

  @override
  Widget build(BuildContext context) {
    position = widget.offset ?? Offset(0, 0);
    final _position = widget.position;
    final offset = Offset(0, _position?.getBottom() ?? 0);
    final contentOrientation = findPositionForContent(offset, _key);
    final contentOffsetMultiplier = contentOrientation == "BELOW" ? 1.0 : -1.0;
    ToolTipWidget.isArrowUp = contentOffsetMultiplier == 1.0;

    final contentY = ToolTipWidget.isArrowUp
        ? (widget.position?.getBottom() ?? 0) + (contentOffsetMultiplier * 3)
        : (widget.position?.getTop() ?? 0) + (contentOffsetMultiplier * 3);

    final contentFractionalOffset = contentOffsetMultiplier.clamp(-1.0, 0.0);

    double paddingTop = ToolTipWidget.isArrowUp ? 22 : 0;
    double paddingBottom = ToolTipWidget.isArrowUp ? 0 : 22;

    if (!widget.showArrow) {
      paddingTop = 0;
      paddingBottom = 0;
    }

    if (widget.container == null) {
      return Stack(
        children: <Widget>[
          widget.showArrow ? _getArrow(contentOffsetMultiplier) : Container(),
          Positioned(
            top: contentY,
            left: _getLeft(),
            right: _getRight(),
            child: FractionalTranslation(
              translation: Offset(0.0, contentFractionalOffset),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.0, contentFractionalOffset / 14),
                  end: Offset(0.0, 0.05),
                ).animate(widget.animationOffset),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding:
                        EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
                    child: ClipRRect(
                      borderRadius: widget.showcaseShape ?? BorderRadius.circular(0),
                      child: GestureDetector(
                        onTap: widget.onTooltipTap,
                        child: Container(
                          key: _key,
                          width: _getTooltipWidth(),
                          padding: widget.contentPadding,
                          decoration: BoxDecoration(
                              //border: widget.border ?? Border.all(width: 0),
                              borderRadius: widget.showcaseShape ?? BorderRadius.circular(0),
                              color: widget.tooltipColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              widget.title != null
                                  ? Text(
                                widget.title ?? '',
                                style: widget.titleTextStyle ??
                                    Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .merge(TextStyle(
                                        color:
                                        widget.textColor)),
                              )
                                  : SizedBox.shrink(),
                              Padding(
                                padding: EdgeInsets.only(right:0),
                                child: Text(
                                  widget.description ?? '',
                                  style: widget.descTextStyle ??
                                      Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .merge(TextStyle(
                                          color: widget.textColor)),
                                ),
                              ),
                              widget.buttons.isEmpty ?
                              SizedBox.shrink() :
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: widget.buttons,
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          //widget.showArrow ? _getArrow(contentOffsetMultiplier) : Container(),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Positioned(
            left: _getSpace(),
            top: contentY - 10,
            child: FractionalTranslation(
              translation: Offset(0.0, contentFractionalOffset),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.0, contentFractionalOffset / 10),
                  end: !widget.showArrow && !ToolTipWidget.isArrowUp
                      ? Offset(0.0, 0.0)
                      : Offset(0.0, 0.100),
                ).animate(widget.animationOffset),
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: widget.buttons.isEmpty ? null : widget.onTooltipTap,
                    child: Container(
                      key: _key,
                      padding: EdgeInsets.only(
                        top: paddingTop,
                      ),
                      color: Colors.transparent,
                      child: Center(
                        child: MeasureSize(
                          widget.container ?? const SizedBox.shrink(),
                          (size) {
                              setState(() {
                                Offset tempPos = position;
                                tempPos = Offset(
                                    position.dx, position.dy + size.height);
                                position = tempPos;
                              });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _getArrow(contentOffsetMultiplier) {
    final contentFractionalOffset = contentOffsetMultiplier.clamp(-1.0, 0.0);
    /*var offset = widget.border?.top?.width ??
        widget.border?.bottom?.width ??
        widget.border?.right?.width ??
        widget.border?.left?.width ?? 0;
    var color = widget.border?.top?.color ??
        widget.border?.bottom?.color ??
        widget.border?.left?.color ??
        widget.border?.right?.color ?? null;*/
    return Positioned(
      top: ToolTipWidget.isArrowUp
          ? (widget.position?.getBottom() ?? .0)
          : (widget.position?.getTop() ?? .0) - 1,
      left: (widget.position?.getCenter() ?? .0) - 24,
      child: /*Stack(
        children: [
          FractionalTranslation(
            translation: Offset(0.0, contentFractionalOffset),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.0, contentFractionalOffset / 5),
                end: Offset(0.0, 0.150),
              ).animate(widget.animationOffset),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  ClipRRect(
                    
                    child: Icon(
                      ToolTipWidget.isArrowUp
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: color ?? widget.tooltipColor,
                      size: 50 + (offset ?? 0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: offset%2 == 1 ? offset + 1: offset
                    ),
                    child: Icon(
                      ToolTipWidget.isArrowUp
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: widget.tooltipColor,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )*/
      FractionalTranslation(
        translation: Offset(0.0, contentFractionalOffset),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0.0, contentFractionalOffset / 5),
            end: Offset(0.0, widget.buttons.isEmpty ? 0.160 : 0.270),
          ).animate(widget.animationOffset),
          child: Icon(
            ToolTipWidget.isArrowUp
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down,
            color: widget.tooltipColor,
            size: 50,
          ),
        ),
      ),
    );
  }
}
