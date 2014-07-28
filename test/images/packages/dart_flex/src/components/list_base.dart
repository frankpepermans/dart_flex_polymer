library dart_flex.components.list_base.dart;

import 'dart:async';
import 'dart:core';

import 'package:polymer/polymer.dart';

import 'package:dart_flex/dart_flex.dart';
import 'package:dart_flex/src/components/group.dart';

abstract class ListBase extends Group {

  bool _isElementUpdateRequired = false;
  bool _skipPresentationUpdate = false;

  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
  
  //---------------------------------
  // inactiveHandler
  //---------------------------------

  InactiveHandler _inactiveHandler;

  InactiveHandler get inactiveHandler => _inactiveHandler;
  set inactiveHandler(InactiveHandler value) {
    if (value != _inactiveHandler) {
      _inactiveHandler = value;
    }
  }

  //---------------------------------
  // dataProvider
  //---------------------------------

  static const EventHook<FrameworkEvent> onDataProviderChangedEvent = const EventHook<FrameworkEvent>('dataProviderChanged');
  Stream<FrameworkEvent> get onDataProviderChanged => ListBase.onDataProviderChangedEvent.forTarget(this);
  List<dynamic> _dataProvider;

  @published List<dynamic> get dataProvider => _dataProvider;
  @published set dataProvider(List<dynamic> value) {
    if (value != _dataProvider) {
      _dataProvider = value;
      _isElementUpdateRequired = true;
      
      if (value is ObservableList) streamSubscriptionManager.add(
          'list_base_dataProviderChanges', 
          value.listChanges.listen(dataProvider_collectionChangedHandler),
          flushExisting: true
      );
      else streamSubscriptionManager.flushIdent('list_base_dataProviderChanges');
      
      notify(
          new FrameworkEvent(
            'dataProviderChanged',
            relatedObject: value
          )
      );
      
      invalidatePresentation();

      invalidateProperties();
    }
  }
  
  //---------------------------------
  // presentationHandler
  //---------------------------------

  CompareHandler _presentationHandler;
  
  CompareHandler get presentationHandler => _presentationHandler;
  set presentationHandler(CompareHandler value) {
    if (value != _presentationHandler) {
      _presentationHandler = value;
      
      invalidatePresentation();
    }
  }
  
  //---------------------------------
  // labelField
  //---------------------------------

  static const EventHook<FrameworkEvent> onFieldChangedEvent = const EventHook<FrameworkEvent>('fieldChanged');
  Stream<FrameworkEvent> get onFieldChanged => ListBase.onFieldChangedEvent.forTarget(this);
  Symbol _field;

  Symbol get field => _field;
  set field(Symbol value) {
    if (value != _field) {
      _field = value;
      
      notify(
          new FrameworkEvent(
            'fieldChanged'
          )
      );
    }
  }

  //---------------------------------
  // labelFunction
  //---------------------------------

  static const EventHook<FrameworkEvent> onLabelFunctionChangedEvent = const EventHook<FrameworkEvent>('labelFunctionChanged');
  Stream<FrameworkEvent> get onLabelFunctionChanged => ListBase.onLabelFunctionChangedEvent.forTarget(this);
  Function _labelFunction;

  Function get labelFunction => _labelFunction;
  set labelFunction(Function value) {
    if (value != _labelFunction) {
      _labelFunction = value;
      
      notify(
          new FrameworkEvent(
            'labelFunctionChanged'
          )
      );
    }
  }
  
  //---------------------------------
  // allowMultipleSelection
  //---------------------------------
  
  static const EventHook<FrameworkEvent<bool>> onAllowMultipleSelectionChangedEvent = const EventHook<FrameworkEvent<bool>>('allowMultipleSelectionChanged');
  Stream<FrameworkEvent<bool>> get onAllowMultipleSelectionChanged => ListBase.onAllowMultipleSelectionChangedEvent.forTarget(this);
  bool _allowMultipleSelection = false;
  
  bool get allowMultipleSelection => _allowMultipleSelection;
  set allowMultipleSelection(bool value) {
    if (value != _allowMultipleSelection) {
      _allowMultipleSelection = value;
      
      notify(
          new FrameworkEvent<bool>(
            'allowMultipleSelectionChanged',
            relatedObject: value
          )
      );
    }
  }

  //---------------------------------
  // selectedIndex
  //---------------------------------

  static const EventHook<FrameworkEvent> onSelectedIndexChangedEvent = const EventHook<FrameworkEvent>('selectedIndexChanged');
  Stream<FrameworkEvent> get onSelectedIndexChanged => ListBase.onSelectedIndexChangedEvent.forTarget(this);
  int _selectedIndex = -1;

  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) {
    if (value != _selectedIndex) {
      _selectedIndex = value;
      
      if (
          (_dataProvider != null) &&
          (value >= 0) &&
          (value < _dataProvider.length)
      ) {
        _selectedItem = _dataProvider[value];
        
        notify(
            new FrameworkEvent<dynamic>(
                'selectedItemChanged',
                relatedObject: _selectedItem
            )
        );
      }

      notify(
          new FrameworkEvent(
            'selectedIndexChanged',
            relatedObject: value
          )
      );

      later > updateSelection;
    }
  }
  
  //---------------------------------
  // selectedIndices
  //---------------------------------

  static const EventHook<FrameworkEvent<ObservableList<int>>> onSelectedIndicesChangedEvent = const EventHook<FrameworkEvent<ObservableList<int>>>('selectedIndicesChanged');
  Stream<FrameworkEvent<ObservableList<int>>> get onSelectedIndicesChanged => ListBase.onSelectedIndicesChangedEvent.forTarget(this);
  ObservableList<int> _selectedIndices = new ObservableList<int>();

  ObservableList<int> get selectedIndices => _selectedIndices;
  set selectedIndices(ObservableList<int> value) {
    if (value != _selectedIndices) {
      _selectedIndices = value;
      _selectedItems.clear();
      
      if (_dataProvider != null && value != null) {
        int len = _dataProvider.length, i;
        
        for (i=0; i<len; i++) {
          if (value.contains(i)) _selectedItems.add(_dataProvider[i]);
        }
      }
      
      notify(
          new FrameworkEvent<Iterable<dynamic>>(
              'selectedItemsChanged',
              relatedObject: _selectedItems
          )
      );

      notify(
          new FrameworkEvent<Iterable<int>>(
            'selectedIndicesChanged',
            relatedObject: value
          )
      );

      later > updateSelection;
    }
  }

  //---------------------------------
  // selectedItem
  //---------------------------------

  static const EventHook<FrameworkEvent> onSelectedItemChangedEvent = const EventHook<FrameworkEvent>('selectedItemChanged');
  Stream<FrameworkEvent> get onSelectedItemChanged => ListBase.onSelectedItemChangedEvent.forTarget(this);
  dynamic _selectedItem;

  dynamic get selectedItem => _selectedItem;
  set selectedItem(dynamic value) {
    if (value != _selectedItem) {
      _selectedItem = value;
      
      if (_dataProvider != null) {
        _selectedIndex = _dataProvider.indexOf(value);
        
        notify(
            new FrameworkEvent(
                'selectedIndexChanged',
                relatedObject: _selectedIndex
            )
        );
      }

      notify(
          new FrameworkEvent<dynamic>(
            'selectedItemChanged',
            relatedObject: value
          )
      );

      later > updateSelection;
    }
  }
  
  //---------------------------------
  // selectedItems
  //---------------------------------
  
  static const EventHook<FrameworkEvent<ObservableList<dynamic>>> onSelectedItemsChangedEvent = const EventHook<FrameworkEvent<ObservableList<dynamic>>>('selectedItemsChanged');
  Stream<FrameworkEvent<ObservableList<dynamic>>> get onSelectedItemsChanged => ListBase.onSelectedItemsChangedEvent.forTarget(this);
  ObservableList<dynamic> _selectedItems = new ObservableList<dynamic>();
  
  ObservableList<dynamic> get selectedItems => _selectedItems;
  set selectedItems(ObservableList<dynamic> value) {
    if (value != _selectedItems) {
      _selectedItems = value;
      _selectedIndices.clear();
      
      if (_dataProvider != null && value != null) {
        int len = _dataProvider.length, i;
        
        for (i=0; i<len; i++) {
          if (value.contains(_dataProvider[i])) _selectedIndices.add(i);
        }
      }
      
      notify(
          new FrameworkEvent<Iterable<int>>(
              'selectedIndicesChanged',
              relatedObject: _selectedIndices
          )
      );
  
      notify(
          new FrameworkEvent<Iterable<dynamic>>(
            'selectedItemsChanged',
            relatedObject: value
          )
      );
  
      later > updateSelection;
    }
  }

  //---------------------------------
  //
  // Constructor
  //
  //---------------------------------

  ListBase.created() : super.created() {
  	className = 'ListWrapper';
  }

  //---------------------------------
  //
  // Operator overloads
  //
  //---------------------------------

  int operator +(dynamic item) {
    if (_dataProvider == null) dataProvider = new ObservableList<dynamic>();
    
    _dataProvider.add(item);

    return item;
  }

  int operator -(dynamic item) {
    if (_dataProvider == null) dataProvider = new ObservableList<dynamic>();
    else _dataProvider.remove(item);

    return item;
  }
  
  //---------------------------------
  //
  // Public methods
  //
  //---------------------------------
  
  void registerRenderer(IItemRenderer renderer);
  
  @override
  void commitProperties() {
    super.commitProperties();

    if (_isElementUpdateRequired) {
      _isElementUpdateRequired = false;
      
      if (!_skipPresentationUpdate) _updatePresentation();
      
      _skipPresentationUpdate = false;
      
      updateElements();
      updateAfterScrollPositionChanged();
      
      if (_dataProvider != null) selectedIndex = _dataProvider.indexOf(_selectedItem);
    }
  }
  
  void invalidatePresentation() {
    _isElementUpdateRequired = true;
    
    invalidateProperties();
  }
  
  @override
  void attached() {
    super.attached();
    
    _isElementUpdateRequired = true;
  }

  //---------------------------------
  //
  // Protected methods
  //
  //---------------------------------
  
  void _updatePresentation() {
    if (
        (_dataProvider != null) &&
        (_presentationHandler != null)
    ) _dataProvider.sort(_presentationHandler);
  }

  void _removeAllElements() {
    while (control.children.length > 0) control.children.removeLast();

    clearChildWrappers();
  }
  
  void updateAfterScrollPositionChanged() {}

  void updateElements() {
    if (_dataProvider == null) return;
    
    int len = _dataProvider.length;
    int i;

    _removeAllElements();

    for (i=0; i<len; i++) _createElement(_dataProvider[i], i);

    updateSelection();
  }

  void updateSelection() {}

  void _createElement(dynamic item, int index) {}

  void dataProvider_collectionChangedHandler(List<ListChangeRecord> changes) {
    _isElementUpdateRequired = true;
    _skipPresentationUpdate = true;

    invalidateProperties();
  }
}

