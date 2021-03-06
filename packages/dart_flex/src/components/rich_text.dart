library dart_flex.components.rich_text.dart;

import 'dart:async';
import 'dart:core';
import 'dart:html';

import 'package:polymer/polymer.dart';

import 'package:dart_flex/dart_flex.dart';
import 'package:dart_flex/src/components/ui_wrapper.dart';

@CustomTag('flex-text')
class RichText extends UIWrapper {
 
  //---------------------------------
  //
  // Private properties
  //
  //---------------------------------
 
  bool _isWidthAutoScaled = false;
  bool _isHeightAutoScaled = false;
 
  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
 
  static const EventHook<FrameworkEvent> onClickEvent = const EventHook<FrameworkEvent>('click');
  Stream<FrameworkEvent> get onRendererClick => RichText.onClickEvent.forTarget(this);
 
  //---------------------------------
  // label
  //---------------------------------
 
  Element _label;
 
  Element get label => _label;
 
  //---------------------------------
  // text
  //---------------------------------
 
  static const EventHook<FrameworkEvent> onTextChangedEvent = const EventHook<FrameworkEvent>('textChanged');
  Stream<FrameworkEvent> get onTextChanged => RichText.onTextChangedEvent.forTarget(this);
  String _text;
 
  String get text => _text;
  set text(String value) {
    if (value != _text) {
      _text = value;
 
      notify(
        new FrameworkEvent(
          'textChanged'
        )
      );
 
      _commitText();
    }
  }
 
  //---------------------------------
  // richText
  //---------------------------------
 
  static const EventHook<FrameworkEvent> onRichTextChangedEvent = const EventHook<FrameworkEvent>('richTextChanged');
  Stream<FrameworkEvent> get onRichTextChanged => RichText.onRichTextChangedEvent.forTarget(this);
  String _richText;
 
  String get richText => _richText;
  set richText(String value) {
    if (value != _richText) {
      _richText = value;
 
      notify(
        new FrameworkEvent(
          'richTextChanged'
        )
      );
 
      _commitText();
    }
  }
 
  //---------------------------------
  // align
  //---------------------------------
 
  static const EventHook<FrameworkEvent> onAlignChangedEvent = const EventHook<FrameworkEvent>('alignChanged');
  Stream<FrameworkEvent> get onAlignChanged => RichText.onAlignChangedEvent.forTarget(this);
  String _align = 'left';
 
  String get align => _align;
  set align(String value) {
    if (value != _align) {
      _align = value;
 
      notify(
        new FrameworkEvent(
          'alignChanged'
        )
      );
 
      _commitTextAlign();
    }
  }
 
  //---------------------------------
  // verticalAlign
  //---------------------------------
 
  static const EventHook<FrameworkEvent> onVerticalAlignChangedEvent = const EventHook<FrameworkEvent>('verticalAlignChanged');
  Stream<FrameworkEvent> get onVerticalAlignChanged => RichText.onVerticalAlignChangedEvent.forTarget(this);
  String _verticalAlign = 'text-top';
 
  String get verticalAlign => _verticalAlign;
  set verticalAlign(String value) {
    if (value != _verticalAlign) {
      _verticalAlign = value;
 
      notify(
        new FrameworkEvent(
          'verticalAlignChanged'
        )
      );
 
      _commitTextVerticalAlign();
    }
  }
 
  //---------------------------------
  // autoTruncate
  //---------------------------------
 
  static const EventHook<FrameworkEvent> onAutoTruncateChangedEvent = const EventHook<FrameworkEvent>('autoTruncateChangedEvent');
  Stream<FrameworkEvent> get onAutoTruncateChanged => RichText.onAutoTruncateChangedEvent.forTarget(this);
  bool _autoTruncate = false;
 
  bool get autoTruncate => _autoTruncate;
  set autoTruncate(bool value) {
    if (value != _autoTruncate) {
       _autoTruncate = value;
 
      notify(
        new FrameworkEvent(
          'autoTruncateChangedEvent'
        )
      );
 
      _commitTextAutoTruncate();
    }
  }
 
  //---------------------------------
  //
  // Constructor
  //
  //---------------------------------
 
  RichText.created() : super.created() {
       className = 'RichText';
      
       autoSize = false;
  }
 
  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
 
  @override
  void attached() {
    super.attached();
   
    _label = control as LabelElement;
 
    _commitTextAlign();
    _commitTextVerticalAlign();
    _commitTextAutoTruncate();
    _commitText();
  }
 
  //---------------------------------
  //
  // Protected methods
  //
  //---------------------------------
 
  void _commitTextAlign() {
    if (_label != null) reflowManager.invalidateCSS(control, 'text-align', _align);
  }
 
  void _commitTextVerticalAlign() {
    if (_label != null) reflowManager.invalidateCSS(control, 'vertical-align', _verticalAlign);
  }
 
  void _commitTextAutoTruncate() {
       if (_autoTruncate) {
      if (_label != null) reflowManager.invalidateCSS(control, 'text-overflow', 'ellipsis');
      if (_label != null) reflowManager.invalidateCSS(control, 'white-space', 'nowrap');
       }
       else {
      if (_label != null) reflowManager.invalidateCSS(control, 'text-overflow', 'clip');
      if (_label != null) reflowManager.invalidateCSS(control, 'white-space', 'normal');
       }
  }
 
  void _commitText() {
    if (_label != null) reflowManager.scheduleMethod(this, _commitTextOnReflow, []);
  }
 
  void _commitTextOnReflow() {
    final String newText = (_richText != null) ? _richText : (_text != null) ? _text : '';
   
    if (_richText != null) {
      _label.setInnerHtml(newText, treeSanitizer: new NullTreeSanitizer());
    } else {
      _label.text = newText;
    }
   
    control.title = newText.replaceAll(new RegExp(r'<[^>]+>'), '');
  }
}