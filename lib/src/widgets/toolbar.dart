import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/documents/attribute.dart';
import 'controller.dart';
import 'toolbar/arrow_indicated_button_list.dart';
import 'toolbar/clear_format_button.dart';
import 'toolbar/color_button.dart';
import 'toolbar/history_button.dart';
import 'toolbar/image_button.dart';
import 'toolbar/indent_button.dart';
import 'toolbar/insert_embed_button.dart';
import 'toolbar/link_style_button.dart';
import 'toolbar/select_header_style_button.dart';
import 'toolbar/toggle_check_list_button.dart';
import 'toolbar/toggle_style_button.dart';

export 'toolbar/clear_format_button.dart';
export 'toolbar/color_button.dart';
export 'toolbar/history_button.dart';
export 'toolbar/image_button.dart';
export 'toolbar/indent_button.dart';
export 'toolbar/insert_embed_button.dart';
export 'toolbar/link_style_button.dart';
export 'toolbar/quill_dropdown_button.dart';
export 'toolbar/quill_icon_button.dart';
export 'toolbar/select_header_style_button.dart';
export 'toolbar/toggle_check_list_button.dart';
export 'toolbar/toggle_style_button.dart';

typedef OnImagePickCallback = Future<String> Function(File file);
typedef ImagePickImpl = Future<String?> Function(ImageSource source);
typedef FilePickImpl = Future<String?> Function(BuildContext context);

// The default size of the icon of a button.
const double kDefaultIconSize = 18;

// The factor of how much larger the button is in relation to the icon.
const double kIconButtonFactor = 1.77;

class QuillToolbar extends StatelessWidget implements PreferredSizeWidget {
  const QuillToolbar({
    required this.children,
    this.toolBarHeight = 36,
    this.color,
    this.filePickImpl,
    Key? key,
  }) : super(key: key);

  factory QuillToolbar.basic({
    required QuillController controller,
    double toolbarIconSize = kDefaultIconSize,
    bool showBoldButton = true,
    bool showItalicButton = true,
    bool showUnderLineButton = true,
    bool showStrikeThrough = true,
    bool showColorButton = true,
    bool showBackgroundColorButton = true,
    bool showClearFormat = true,
    bool showHeaderStyle = true,
    bool showListNumbers = true,
    bool showListBullets = true,
    bool showListCheck = true,
    bool showCodeBlock = true,
    bool showQuote = true,
    bool showIndent = true,
    bool showLink = true,
    bool showHistory = true,
    bool showHorizontalRule = false,
    OnImagePickCallback? onImagePickCallback,
    FilePickImpl? filePickImpl,
    Key? key,
  }) {
    final isButtonGroupShown = [
      showHistory ||
          showBoldButton ||
          showItalicButton ||
          showUnderLineButton ||
          showStrikeThrough ||
          showColorButton ||
          showBackgroundColorButton ||
          showClearFormat ||
          onImagePickCallback != null,
      showHeaderStyle,
      showListNumbers || showListBullets || showListCheck || showCodeBlock,
      showQuote || showIndent,
      showLink || showHorizontalRule
    ];

    return QuillToolbar(
      key: key,
      toolBarHeight: toolbarIconSize * 2,
      children: [
        if (showHistory)
          HistoryButton(
            icon: Icons.undo_outlined,
            iconSize: toolbarIconSize,
            controller: controller,
            undo: true,
          ),
        if (showHistory)
          HistoryButton(
            icon: Icons.redo_outlined,
            iconSize: toolbarIconSize,
            controller: controller,
            undo: false,
          ),
        if (showBoldButton)
          ToggleStyleButton(
            attribute: Attribute.bold,
            icon: Icons.format_bold,
            iconSize: toolbarIconSize,
            controller: controller,
          ),
        if (showItalicButton)
          ToggleStyleButton(
            attribute: Attribute.italic,
            icon: Icons.format_italic,
            iconSize: toolbarIconSize,
            controller: controller,
          ),
        if (showUnderLineButton)
          ToggleStyleButton(
            attribute: Attribute.underline,
            icon: Icons.format_underline,
            iconSize: toolbarIconSize,
            controller: controller,
          ),
        if (showStrikeThrough)
          ToggleStyleButton(
            attribute: Attribute.strikeThrough,
            icon: Icons.format_strikethrough,
            iconSize: toolbarIconSize,
            controller: controller,
          ),
        if (showColorButton)
          ColorButton(
            icon: Icons.color_lens,
            iconSize: toolbarIconSize,
            controller: controller,
            background: false,
          ),
        if (showBackgroundColorButton)
          ColorButton(
            icon: Icons.format_color_fill,
            iconSize: toolbarIconSize,
            controller: controller,
            background: true,
          ),
        if (showClearFormat)
          ClearFormatButton(
            icon: Icons.format_clear,
            iconSize: toolbarIconSize,
            controller: controller,
          ),
        if (onImagePickCallback != null)
          ImageButton(
            icon: Icons.image,
            iconSize: toolbarIconSize,
            controller: controller,
            imageSource: ImageSource.gallery,
            onImagePickCallback: onImagePickCallback,
            filePickImpl: filePickImpl,
          ),
        if (onImagePickCallback != null)
          ImageButton(
            icon: Icons.photo_camera,
            iconSize: toolbarIconSize,
            controller: controller,
            imageSource: ImageSource.camera,
            onImagePickCallback: onImagePickCallback,
            filePickImpl: filePickImpl,
          ),
        if (isButtonGroupShown[0] &&
            (isButtonGroupShown[1] ||
                isButtonGroupShown[2] ||
                isButtonGroupShown[3] ||
                isButtonGroupShown[4]))
          VerticalDivider(
            indent: 12,
            endIndent: 12,
            color: Colors.grey.shade400,
          ),
        if (showHeaderStyle)
          SelectHeaderStyleButton(
            controller: controller,
            iconSize: toolbarIconSize,
          ),
        if (isButtonGroupShown[1] &&
            (isButtonGroupShown[2] ||
                isButtonGroupShown[3] ||
                isButtonGroupShown[4]))
          VerticalDivider(
            indent: 12,
            endIndent: 12,
            color: Colors.grey.shade400,
          ),
        if (showListNumbers)
          ToggleStyleButton(
            attribute: Attribute.ol,
            controller: controller,
            icon: Icons.format_list_numbered,
            iconSize: toolbarIconSize,
          ),
        if (showListBullets)
          ToggleStyleButton(
            attribute: Attribute.ul,
            controller: controller,
            icon: Icons.format_list_bulleted,
            iconSize: toolbarIconSize,
          ),
        if (showListCheck)
          ToggleCheckListButton(
            attribute: Attribute.unchecked,
            controller: controller,
            icon: Icons.check_box,
            iconSize: toolbarIconSize,
          ),
        if (showCodeBlock)
          ToggleStyleButton(
            attribute: Attribute.codeBlock,
            controller: controller,
            icon: Icons.code,
            iconSize: toolbarIconSize,
          ),
        if (isButtonGroupShown[2] &&
            (isButtonGroupShown[3] || isButtonGroupShown[4]))
          VerticalDivider(
            indent: 12,
            endIndent: 12,
            color: Colors.grey.shade400,
          ),
        if (showQuote)
          ToggleStyleButton(
            attribute: Attribute.blockQuote,
            controller: controller,
            icon: Icons.format_quote,
            iconSize: toolbarIconSize,
          ),
        if (showIndent)
          IndentButton(
            icon: Icons.format_indent_increase,
            iconSize: toolbarIconSize,
            controller: controller,
            isIncrease: true,
          ),
        if (showIndent)
          IndentButton(
            icon: Icons.format_indent_decrease,
            iconSize: toolbarIconSize,
            controller: controller,
            isIncrease: false,
          ),
        if (isButtonGroupShown[3] && isButtonGroupShown[4])
          VerticalDivider(
            indent: 12,
            endIndent: 12,
            color: Colors.grey.shade400,
          ),
        if (showLink)
          LinkStyleButton(
            controller: controller,
            iconSize: toolbarIconSize,
          ),
        if (showHorizontalRule)
          InsertEmbedButton(
            controller: controller,
            icon: Icons.horizontal_rule,
            iconSize: toolbarIconSize,
          ),
      ],
    );
  }

  final List<Widget> children;
  final double toolBarHeight;

  /// The color of the toolbar.
  ///
  /// Defaults to [ThemeData.canvasColor] of the current [Theme] if no color
  /// is given.
  final Color? color;

  final FilePickImpl? filePickImpl;

  @override
  Size get preferredSize => Size.fromHeight(toolBarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightFor(height: preferredSize.height),
      color: color ?? Theme.of(context).canvasColor,
      child: ArrowIndicatedButtonList(buttons: children),
    );
  }
}
