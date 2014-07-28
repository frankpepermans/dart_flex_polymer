library dart_flex;

import 'dart:async';
import 'dart:core';
import 'dart:html';

import 'package:polymer/polymer.dart';

part "src/core/class_factory.dart";
part "src/core/event_hook.dart";
part "src/core/invalidation.dart";
part "src/core/layout.dart";
part "src/core/function_equality_util.dart";
part "src/core/reflow_manager.dart";
part "src/core/scroll_policy.dart";
part "src/core/stream_subscription_manager.dart";
part "src/core/update_manager.dart";

part "src/events/collection_event.dart";
part "src/events/framework_event.dart";
part "src/events/framework_event_dispatcher.dart";
part "src/events/view_stack_event.dart";

part "src/layout/absolute_layout.dart";
part "src/layout/base_layout.dart";
part "src/layout/horizontal_layout.dart";
part "src/layout/scroll_binder.dart";
part "src/layout/tile_layout.dart";
part "src/layout/vertical_layout.dart";

typedef bool InactiveHandler(dynamic data);
typedef bool InvalidHandler(dynamic data);
typedef String SortHandler(dynamic data, Symbol propertySymbol);
typedef int CompareHandler(dynamic dataA, dynamic dataB);
typedef void HeaderMouseHandler(IItemRenderer header);
//typedef IItemRenderer ItemRendererHandler(DataGridItemRenderer rowRenderer, DataGridColumn column, int index, Function defaultHandler);

class NullTreeSanitizer implements NodeTreeSanitizer {
  void sanitizeTree(Node node) {}
}

class Skin {
  
  final String src;
  
  const Skin(this.src);
  
}

int _NEXT_GUID = 1;

String getNextGUID() => 'uid_${_NEXT_GUID++}';

abstract class IUIWrapper implements PolymerElement, IFlexLayout, IFrameworkEventDispatcher, ILifeCycle, ICallLater {
  
  //---------------------------------
  //
  // Events
  //
  //---------------------------------
  
  Stream<FrameworkEvent> get onStylePrefixChanged;
  Stream<FrameworkEvent> get onCSSClassesChanged;
  Stream<FrameworkEvent> get onVisibleChanged;
  Stream<FrameworkEvent> get onInheritsDefaultCSSChanged;
  Stream<FrameworkEvent<Element>> get onControlChanged;
  Stream<FrameworkEvent> get onInitializationComplete;
  Stream<FrameworkEvent> get onOwnerChanged;
  
  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
  
  ReflowManager get reflowManager;
  
  StreamSubscriptionManager get streamSubscriptionManager;

  bool get visible;
  set visible(bool value);
  
  bool get disableRemoveComponents;
  set disableRemoveComponents(bool value);
  
  bool get useMatrixTransformations;
  set useMatrixTransformations(bool value);
  
  bool get enabled;
  set enabled(bool value);
  
  bool get inheritsDefaultCSS;
  set inheritsDefaultCSS(bool value);

  IUIWrapper get owner;

  List<IUIWrapper> get childWrappers;
  
  String get className;
  set className(String value);
  
  List<String> get cssClasses;
  set cssClasses(List<String> value);

  Element get control;
  
  //---------------------------------
  //
  // Public methods
  //
  //---------------------------------
  
  void addComponent(IUIWrapper element, {bool prepend: false});
  void removeComponent(IUIWrapper element);
  void removeAll();
  void flushHandler();
  void transportComponents(IUIWrapper target);

  void operator []=(String type, Function eventHandler) => observeEventType(type, eventHandler);

}

abstract class IItemRenderer<D> implements IUIWrapper {
  
  Stream<FrameworkEvent> get onDataChanged;
  Stream<FrameworkEvent> get onFieldChanged;
  Stream<FrameworkEvent> get onFieldsChanged;
  Stream<FrameworkEvent> get onRendererClick;
  Stream<FrameworkEvent> get onRendererMouseOver;
  Stream<FrameworkEvent> get onRendererMouseOut;
  Stream<FrameworkEvent> get onDataPropertyChanged;

  int get index;
  set index(int value);

  String get state;
  set state(String value);

  bool get selected;
  set selected(bool value);
  
  bool get notApplicable;
  set notApplicable(bool value);
  
  bool get showAsEditable;
  set showAsEditable(bool value);
  
  InactiveHandler get inactiveHandler;
  set inactiveHandler(InactiveHandler value);
  
  InvalidHandler get validationHandler;
  set validationHandler(InvalidHandler value);
  
  bool get inactive;
  
  bool get editable;
  set editable(bool value);
  
  bool get enableHighlight;
  set enableHighlight(bool value);

  D get data;
  set data(D value);
  
  Symbol get field;
  set field(Symbol value);
  
  List<Symbol> get fields;
  set fields(List<Symbol> value);

  Function get labelHandler;
  set labelHandler(Function value);

  bool get autoDrawBackground;
  set autoDrawBackground(bool value);

  int get gap;
  set gap(int value);

  String get interactionStyle;

  void invalidateData();
  void invalidateDataChangesListener();
  void updateAfterInteraction();
  void highlight();

}