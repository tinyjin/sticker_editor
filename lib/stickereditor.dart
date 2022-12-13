library sticker_editor;

import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stickereditor/constants_value.dart';
import 'package:stickereditor/src/widgets/custom_button.dart';
import 'src/model/picture_model.dart';
import 'src/model/text_model.dart';
import 'src/widgets/sticker_widget/sticker_box.dart';
import 'src/widgets/text_widget/text_box.dart';

export 'src/model/picture_model.dart';
export 'src/model/text_model.dart';
export 'package:stickereditor/constants_value.dart';
export 'src/widgets/sticker_widget/sticker_box.dart';
export 'src/widgets/text_widget/text_box.dart';

typedef SaveCallback = void Function(
  List<TextModel> texts,
  List<PictureModel> pictures,
);

/// Sticker editor view
/// A flutter widget that rotate, zoom and edit text and Sticker
///
/// You can pass your fonts
/// and then get the edited Text Widget
// ignore: must_be_immutable
class StickerEditingView extends StatefulWidget {
  /// Editor's font families
  final List<String> fonts;

  /// Editor's PalletColor List
  List<Color>? palletColor;

  /// Editor's assetsList List
  List<String>? assetList;

  /// Editor's image type
  bool isnetwork;

  /// Choose whether view only
  bool viewOnly;

  /// Editor's background color
  Color? backgroundColor;

  /// Editor's image
  Widget child;

  /// StickerEditor View Height
  double? height;

  /// StickerEditor View Width
  double? width;

  /// Callback for saving
  SaveCallback? onSave;

  /// Initial Text List
  List<TextModel> texts;

  /// Initial Picture List
  List<PictureModel> pictures;

  /// Button specific UIs
  String textButtonText;
  Color textButtonColor;

  String stickerButtonText;
  Color stickerButtonColor;

  String saveButtonText;
  Color saveButtonColor;

  /// Create a [StickerEditingBox] widget
  ///
  StickerEditingView(
      {Key? key,
      required this.fonts,
      required this.child,
      this.palletColor,
      this.height,
      this.width,
      this.onSave,
      this.backgroundColor,
      this.viewOnly = false,
      this.texts = const [],
      this.pictures = const [],
      this.textButtonText = 'Add Text',
      this.textButtonColor = Colors.blue,
      this.stickerButtonText = 'Add Stickers',
      this.stickerButtonColor = Colors.blue,
      this.saveButtonText = 'Save',
      this.saveButtonColor = Colors.blue,
      required this.isnetwork,
      required this.assetList})
      : super(key: key);

  @override
  _StickerEditingViewState createState() => _StickerEditingViewState();
}

class _StickerEditingViewState extends State<StickerEditingView> {
  // offset
  double x = 120.0;
  double y = 160.0;
  double x1 = 100.0;
  double y1 = 50.0;

  // selected text perameter
  double selectedFontSize = 18;
  TextStyle selectedTextstyle =
      const TextStyle(color: Colors.black, fontSize: 18, fontFamily: "Lato");
  String selectedFont = "Lato";
  TextAlign selectedtextAlign = TextAlign.left;
  int selectedTextIndex = -1;
  String selectedtextToShare = "Happy ${weekDays[today - 1]}!";

  // new String and Image List
  RxList<TextModel> newStringList = <TextModel>[].obs;
  RxList<PictureModel> newimageList = <PictureModel>[].obs;

  @override
  void initState() {
    loadInitialResources();
    super.initState();
  }

  void loadInitialResources() {
    if (widget.texts.isNotEmpty) {
      newStringList.addAll(widget.texts);
    }

    if (widget.pictures.isNotEmpty) {
      newimageList.addAll(widget.pictures);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: widget.backgroundColor ?? Colors.white,
      body: Obx(
        () => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                height: widget.height ?? height * .8,
                width: widget.width ?? width * .8,
                child: Stack(
                  children: [
                    widget.viewOnly ?
                    Container()
                    :
                    InkWell(
                      onTap: () {
                        setState(() {
                          for (var element in newStringList) {
                            element.isSelected = false;
                          }
                          for (var e in newimageList) {
                            e.isSelected = false;
                          }
                        });
                      },
                    ),
                    ...newStringList.map((v) {
                      return TextEditingBox(
                          isSelected: !widget.viewOnly && v.isSelected,
                          viewOnly: widget.viewOnly,
                          onTap: () {
                            if (widget.viewOnly) {
                              return;
                            }

                            if (!v.isSelected) {
                              setState(() {
                                for (var element in newStringList) {
                                  element.isSelected = false;
                                }
                                for (var e in newimageList) {
                                  e.isSelected = false;
                                }
                                v.isSelected = true;
                              });
                            } else {
                              setState(() {
                                v.isSelected = false;
                              });
                            }
                          },
                          onCancel: () {
                            int index = newStringList
                                .indexWhere((element) => v == element);

                            newStringList.removeAt(index);
                          },
                          palletColor: widget.palletColor,
                          fonts: widget.fonts,
                          newText: v,
                          boundWidth: width * .90 - width * .20,
                          boundHeight: height * .70 - height * .07);
                    }).toList(),
                    ...newimageList.map((v) {
                      return StickerEditingBox(
                          viewOnly: widget.viewOnly,
                          onCancel: () {
                            int index = newimageList
                                .indexWhere((element) => v == element);

                            newimageList.removeAt(index);
                          },
                          onTap: () {
                            if (widget.viewOnly) {
                              return;
                            }

                            if (!v.isSelected) {
                              setState(() {
                                for (var element in newStringList) {
                                  element.isSelected = false;
                                }
                                for (var e in newimageList) {
                                  e.isSelected = false;
                                }
                                v.isSelected = true;
                              });
                            } else {
                              setState(() {
                                v.isSelected = false;
                              });
                            }
                          },
                          boundWidth: width * .90,
                          boundHeight: height * .70,
                          pictureModel: v);
                    }),
                    widget.viewOnly ?
                    widget.child
                    :
                    IgnorePointer(
                      child: widget.child,
                    )
                  ],
                ),
              ),
            ),
            widget.viewOnly ?
            Container()
            :
            Positioned(
              bottom: 24,
              child: SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomeWidgets.customButton(
                      btnName: widget.textButtonText,
                      color: widget.textButtonColor,
                      onPressed: () async {
                        await showEditBox(
                          context: context,
                          textModel: TextModel(
                              name: selectedtextToShare,
                              textStyle: const TextStyle(),
                              top: 50,
                              isSelected: false,
                              textAlign: TextAlign.center,
                              scale: 1,
                              left: 50),
                        );
                      },
                    ),
                    CustomeWidgets.customButton(
                      btnName: widget.stickerButtonText,
                      color: widget.stickerButtonColor,
                      onPressed: () {
                        selectedTextIndex = -1;

                        stickerWidget(context);
                      },
                    ),
                    CustomeWidgets.customButton(
                      btnName: widget.saveButtonText,
                      color: widget.saveButtonColor,
                      onPressed: () async {
                        setState(() {
                          for (var e in newStringList) {
                            e.isSelected = false;
                          }
                          for (var e in newimageList) {
                            e.isSelected = false;
                          }
                        });

                        if (widget.onSave != null) {
                          widget.onSave!(
                            newStringList.toList(),
                            newimageList.toList(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showEditBox({BuildContext? context, TextModel? textModel}) {
    return showDialog(
        context: context!,
        builder: (context) {
          final dailogTextController =
              TextEditingController(text: selectedtextToShare);
          return AlertDialog(
            backgroundColor: const Color.fromARGB(240, 200, 200, 200),
            title: const Text('Edit Text'),
            content: TextField(
                controller: dailogTextController,
                maxLines: 6,
                minLines: 1,
                autofocus: true,
                decoration: InputDecoration(hintText: selectedtextToShare)),
            actions: [
              ElevatedButton(
                  child: const Text('Done'),
                  onPressed: () {
                    setState(() {
                      for (var e in newimageList) {
                        e.isSelected = false;
                      }
                      for (var e in newStringList) {
                        e.isSelected = false;
                      }
                      textModel!.isSelected = true;
                      textModel.name = dailogTextController.text.trim();
                      newStringList.add(textModel);
                    });
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  // Sticker widget
  Future stickerWidget(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    selectedTextIndex = -1;
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Material(
            elevation: 15,
            child: SizedBox(
              height: height * .4,
              width: width,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemCount: widget.assetList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        for (var e in newimageList) {
                          e.isSelected = false;
                        }
                        for (var e in newStringList) {
                          e.isSelected = false;
                        }
                        newimageList.add(PictureModel(
                            isNetwork: false,
                            stringUrl: widget.assetList![index],
                            top: y1 + 10 < 300 ? y1 + 10 : 300,
                            isSelected: true,
                            angle: 0.0,
                            scale: 1,
                            left: x1 + 10 < 300 ? x1 + 10 : 300));
                        x1 = x1 + 10 < 200 ? x1 + 10 : 200;
                        y1 = y1 + 10 < 200 ? y1 + 10 : 200;
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Image.asset(widget.assetList![index],
                          height: 50, width: 50),
                    );
                  }),
            ),
          );
        });
  }
}
