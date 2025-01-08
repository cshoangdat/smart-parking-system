// Copyright 2024 VinCSS JSC. All rights reserved.
//
// Filename: lib/widget/common.dart
// Author: datht
// Created: 12/07/2024 13:00:00 +07:00

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_car_parking_app/constants/size.dart';

Color? colorGrey = Colors.grey[600];

Widget customButton(
  double width, 
  double height, 
  String text, 
  Function func,
  BuildContext context,
  {
    bool isButtonDisabled = false,
    Color buttonColor = Colors.blue
  }
){
  return ElevatedButton(
        onPressed: () {
          if (isButtonDisabled == true) {
            null;
          } else {
            func();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              (isButtonDisabled == false) ? buttonColor : colorGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          minimumSize: Size(width, height),
          enabledMouseCursor: isButtonDisabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground,fontSize: 20.sp),
        ));
}

Widget submitButton(Function func, BuildContext context){
  return customButton(170.w, 42.h, "SUBMIT", func, context, buttonColor: Colors.green);
}

Widget cancelButton(Function func, BuildContext context){
  return Center(child: customButton(120.w, 42.h, "CANCEL", func, context, buttonColor: Colors.red));
}

Widget successButton(Function func, BuildContext context){
  return Center(child: customButton(120.w, 42.h, "OKAY", func, context, buttonColor: Colors.green));
}

// ignore: must_be_immutable
class InputOneTextDialog extends StatefulWidget {
  final String label;
  final String hintText;
  final Function(String text) submitFunc;
  TextEditingController controller;
  InputOneTextDialog({
    super.key,
    required this.label,
    required this.hintText,
    required this.submitFunc,
    required this.controller
  });

  @override
  State<InputOneTextDialog> createState() => _InputOneTextDialogState();
}

class _InputOneTextDialogState extends State<InputOneTextDialog> {
  @override
  void initState() {
    super.initState();
    widget.controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // elevation: 2,
      // backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          // side: BorderSide(
          //   width: 1,
          //   color: Colors.black54,
          // )
        ),
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                    horizontal: hPadding, vertical: vPadding),
            margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            height: 153.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
            ),
            child: SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                    children: [
                      const Icon(Icons.bluetooth),
                      SizedBox(width: 2.w,),
                      Text(widget.label),
                    ],
                  ),
                  Gap(gapSizeMedium),
                  RichText(
                    text: TextSpan(
                      children: <InlineSpan>[
                        // flexible text field
                        WidgetSpan(
                            child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    minWidth: double.infinity),
                                child: IntrinsicWidth(
                                  child: TextField(
                                    controller: widget.controller,
                                    maxLines: 1,
                                    cursorColor: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsets
                                                .symmetric(
                                                vertical: 2.h),
                                        hintText: widget.hintText,
                                        hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground
                                                .withOpacity(0.3),
                                            fontWeight:
                                                FontWeight.w400),
                                        focusedBorder:
                                            UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(
                                                            context)
                                                        .colorScheme
                                                        .onBackground))),
                                  ),
                                ))),
                      ],
                    ),
                  ),
                  Gap(gapSizeLarge + gapSizeMin),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 110.w,
                        height: 40.h,
                        child: cancelButton((){
                          Navigator.of(context).pop();
                        }, context),
                      ),
                      SizedBox(
                        width: 110.w,
                        height: 40.h,
                        child: submitButton((){
                          widget.submitFunc(widget.controller.text);
                          Navigator.of(context).pop();
                        }, context),
                      ),
                    ],
                  )            
                ],),
              ],
                  ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              height: 22.h,
              width: 22.w,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close_rounded,
                  size: 16.w,
                  color: Colors.white,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          )
        ] 
      )
    );
  }
}

Widget confimationDialog(IconData icon, Color color, String label, String subText, Function submitFunc, BuildContext context){
return Dialog(
      elevation: 2,
      // backgroundColor: Colors.white,
      // shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(16)),
      //     side: BorderSide(
      //       width: 1,
      //       color: Colors.black54,
      //     )),
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                    horizontal: hPadding, vertical: vPadding),
            margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            // height: 234.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
            ),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 80.h,),
                  Text(label, style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: headSize
                  ),),
                  Text(subText, textAlign: TextAlign.center),
                Gap(gapSizeLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 110.w,
                      height: 40.h,
                      child: cancelButton((){
                        Navigator.of(context).pop();
                      }, context),
                    ),
                    SizedBox(
                      width: 110.w,
                      height: 40.h,
                      child: submitButton((){
                        Navigator.of(context).pop();
                        submitFunc();
                      }, context),
                    ),
                  ],
                )                  
              ],),
            ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              height: 22.h,
              width: 22.w,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close_rounded,
                  size: 16.w,
                  color: Colors.white,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          )
        ] 
      )
    );
}

Widget resultDialog(
  IconData icon, 
  Color color, 
  String label, 
  String subText, 
  Widget button, 
  BuildContext context,
){
return Dialog(
      elevation: 2,
      // backgroundColor: Colors.white,
      // shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(16)),
      //     side: BorderSide(
      //       width: 1,
      //       color: Colors.black54,
      //     )),
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                    horizontal: hPadding, vertical: vPadding),
            margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
            ),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 80.h,),
                  Text(label, style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: headSize
                  ),),
                  Text(subText, textAlign: TextAlign.center),
                Gap(gapSizeMedium),
                Center(child: button)                
              ],),
            ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              height: 22.h,
              width: 22.w,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close_rounded,
                  size: 16.w,
                  color: Colors.white,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          )
        ] 
      )
    );
}

Widget successDialog(
  String subText, 
  Function func, 
  BuildContext context,
){
  return resultDialog(Icons.check_circle, Colors.green, "Success", subText, successButton(func, context), context);
}

Widget failedDialog(
  String subText, 
  Function func, 
  BuildContext context,
){
  return resultDialog(Icons.check_circle, Colors.red, "Failed", subText, cancelButton(func, context), context);
}

Widget infoDialog(
  String subText, 
  Function func, 
  BuildContext context,
){
  return resultDialog(Icons.check_circle, Colors.blue, "Info", subText, successButton(func, context), context);
}

Widget warningDialog(
  String subText, 
  Function func, 
  BuildContext context,
){
  return resultDialog(Icons.check_circle, Colors.yellow, "Warning", subText, cancelButton(func, context), context);
}

int rgb888ToRgb565(int r, int g, int b) {
  // Ensure the RGB values are within the 0-255 range
  r = r.clamp(0, 255);
  g = g.clamp(0, 255);
  b = b.clamp(0, 255);
  
  // Convert RGB888 to RGB565
  int rgb565 = ((r >> 3) << 11) | ((g >> 2) << 5) | (b >> 3);
  
  return rgb565;
}