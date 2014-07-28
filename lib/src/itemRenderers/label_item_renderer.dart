library dart_flex.itemRenderers.label_item_renderer.dart;

import 'dart:core';

import 'package:polymer/polymer.dart';

import 'package:dart_flex/dart_flex.dart';
import 'package:dart_flex/src/components/item_renderer.dart';
import 'package:dart_flex/src/components/rich_text.dart';

@CustomTag('flex-label-item-renderer')
class LabelItemRenderer extends ItemRenderer {

  //---------------------------------
  //
  // Protected properties
  //
  //---------------------------------

  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
  
  //---------------------------------
  // label
  //---------------------------------
  
  RichText _label;
  
  RichText get label => _label;
  set label(RichText value) => _label = value;

  //---------------------------------
  //
  // Constructor
  //
  //---------------------------------

  LabelItemRenderer.created() : super.created() {
    layout = new HorizontalLayout();
  }

  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
  
  @override
  void attached() {
    super.attached();
    
    _label = control as RichText;
  }
  
  @override
  void invalidateData() {
    super.invalidateData();
    
    if (_label != null) _label.text = itemToLabel();
  }
  
  String obtainValue() {
    dynamic value = data;
    
    if (value != null) {
      if (fields != null) {
        fields.forEach(
          (Symbol subField) {
            if (value != null) value = value[subField];
          }
        );
      }
      
      if (value != null) value = (field != null) ? value[field] : value;
      
      if (labelHandler != null) return labelHandler(value) as String;
      
      return (value != null) ? value.toString() : '';
    }
    
    return '';
  }
  
  String itemToLabel() => obtainValue();
}