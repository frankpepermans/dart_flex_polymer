library dart_flex.components.list_renderer.dart;

import 'dart:async';
import 'dart:core';
import 'dart:html';
import 'dart:math';

import 'package:polymer/polymer.dart';

import 'package:dart_flex/dart_flex.dart';
import 'package:dart_flex/src/components/group.dart';
import 'package:dart_flex/src/components/list_base.dart';

import 'package:template_binding/template_binding.dart';

@CustomTag('flex-list-renderer')
class ListRenderer extends ListBase {

  Group _scrollTarget;
  
  bool _hasScrolled = false;
  int _firstIndex = 0, _previousFirstIndex = -1, _itemRendererLen = 0;

  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
  
  //---------------------------------
  // inactiveHandler
  //---------------------------------
  
  set inactiveHandler(InactiveHandler value) {
    if (
        (value != inactiveHandler)
    ) control.children.forEach(
      (IItemRenderer renderer) => renderer.inactiveHandler = value    
    );
    
    super.inactiveHandler = value;
  }
  
  //---------------------------------
  // dataProvider
  //---------------------------------
  
  @override
  @published set dataProvider(List value) {
    _previousFirstIndex = -1;
    _firstIndex = 0;
    
    super.dataProvider = value;
  }

  //---------------------------------
  // width
  //---------------------------------
  
  @override
  @published void set width(int value) {
    if (value != super.width) {
      super.width = value;

      if (dataProvider != null) updateAfterScrollPositionChanged();
      
      _forceRefresh();
    }
  }

  //---------------------------------
  // height
  //---------------------------------
  
  @override
  @published void set height(int value) {
    if (value != super.height) {
      super.height = value;

      if (dataProvider != null) updateAfterScrollPositionChanged();
      
      _forceRefresh();
    }
  }
  
  //---------------------------------
  // labelField
  //---------------------------------
  
  @override
  set field(Symbol value) {
    if (value != field) {
      super.field = value;
      
      later > updateVisibleItemRenderers;
    }
  }
  
  //---------------------------------
  // labelFunction
  //---------------------------------
  
  @override
  set labelFunction(Function value) {
    if (value != labelFunction) {
      super.labelFunction = value;
      
      later > updateVisibleItemRenderers;
    }
  }

  //---------------------------------
  // orientation
  //---------------------------------
  
  static const EventHook<FrameworkEvent> onOrientationChangedEvent = const EventHook<FrameworkEvent>('orientationChanged');
  Stream<FrameworkEvent> get onOrientationChanged => ListRenderer.onOrientationChangedEvent.forTarget(this);

  String _orientation;
  bool _isOrientationChanged = false;

  @published String get orientation => _orientation;
  @published set orientation(String value) {
    if (value != _orientation) {
      _orientation = value;
      _isOrientationChanged = true;
      _firstIndex = -1;
      
      scrollPosition = 0;
      
      if (control != null) control.scrollLeft = control.scrollTop = 0;

      notify(
        new FrameworkEvent(
          'orientationChanged'
        )
      );

      invalidateProperties();
      
      later > updateAfterScrollPositionChanged;
    }
  }
  
  //---------------------------------
  // autoManageScrollBars
  //---------------------------------
  
  static const EventHook<FrameworkEvent> onAutoManageScrollBarsChangedEvent = const EventHook<FrameworkEvent>('autoManageScrollBarsChanged');
  Stream<FrameworkEvent> get onAutoManageScrollBarsChanged => ListRenderer.onAutoManageScrollBarsChangedEvent.forTarget(this);

  bool _autoManageScrollBars = true;

  bool get autoManageScrollBars => _autoManageScrollBars;
  set autoManageScrollBars(bool value) {
    if (value != _autoManageScrollBars) {
      _autoManageScrollBars = value;
      _isOrientationChanged = true;

      notify(
        new FrameworkEvent(
          'autoManageScrollBarsChanged'
        )
      );

      invalidateProperties();
    }
  }
  
  //---------------------------------
  // useSelectionEffects
  //---------------------------------
  
  static const EventHook<FrameworkEvent> onUseSelectionEffectsChangedEvent = const EventHook<FrameworkEvent>('useSelectionEffectsChanged');
  Stream<FrameworkEvent> get onUseSelectionEffectsChanged => ListRenderer.onUseSelectionEffectsChangedEvent.forTarget(this);

  bool _useSelectionEffects = true;
  bool _isUseSelectionEffectsChanged = false;

  bool get useSelectionEffects => _useSelectionEffects;
  set useSelectionEffects(bool value) {
    if (value != _useSelectionEffects) {
      _useSelectionEffects = value;
      _isUseSelectionEffectsChanged = true;

      notify(
        new FrameworkEvent(
          'useSelectionEffectsChanged'
        )
      );

      invalidateProperties();
    }
  }

  //---------------------------------
  // colWidth
  //---------------------------------

  static const EventHook<FrameworkEvent> onColWidthChangedEvent = const EventHook<FrameworkEvent>('colWidthChanged');
  Stream<FrameworkEvent> get onColWidthChanged => ListRenderer.onColWidthChangedEvent.forTarget(this);
  int _colWidth = 0;

  int get colWidth => _colWidth;
  set colWidth(int value) {
    if (value != _colWidth) {
      _colWidth = value;

      notify(
        new FrameworkEvent(
          'colWidthChanged'
        )
      );
      
      _forceRefresh();
    }
  }

  //---------------------------------
  // colPercentWidth
  //---------------------------------

  static const EventHook<FrameworkEvent> onColPercentWidthChangedEvent = const EventHook<FrameworkEvent>('colPercentWidthChanged');
  Stream<FrameworkEvent> get onColPercentWidthChanged => ListRenderer.onColPercentWidthChangedEvent.forTarget(this);
  double _colPercentWidth = .0;

  double get colPercentWidth => _colPercentWidth;
  set colPercentWidth(double value) {
    if (value != _colPercentWidth) {
      _colPercentWidth = value;

      notify(
        new FrameworkEvent(
          'colPercentWidthChanged'
        )
      );
      
      _forceRefresh();
    }
  }

  //---------------------------------
  // rowHeight
  //---------------------------------

  static const EventHook<FrameworkEvent> onRowHeightChangedEvent = const EventHook<FrameworkEvent>('rowHeightChanged');
  Stream<FrameworkEvent> get onRowHeightChanged => ListRenderer.onRowHeightChangedEvent.forTarget(this);
  int _rowHeight = 0;

  @published int get rowHeight => _rowHeight;
  @published set rowHeight(int value) {
    if (value != _rowHeight) {
      _rowHeight = value;

      notify(
        new FrameworkEvent(
          'rowHeightChanged'
        )
      );
      
      _forceRefresh();
    }
  }

  //---------------------------------
  // rowPercentHeight
  //---------------------------------

  static const EventHook<FrameworkEvent> onRowPercentHeightChangedEvent = const EventHook<FrameworkEvent>('rowPercentHeightChanged');
  Stream<FrameworkEvent> get onRowPercentHeightChanged => ListRenderer.onRowPercentHeightChangedEvent.forTarget(this);
  double _rowPercentHeight = .0;

  @published double get rowPercentHeight => _rowPercentHeight;
  @published set rowPercentHeight(double value) {
    if (value != _rowPercentHeight) {
      _rowPercentHeight = value;

      notify(
        new FrameworkEvent(
          'rowPercentHeightChanged'
        )
      );
      
      _forceRefresh();
    }
  }

  //---------------------------------
  // scrollPosition
  //---------------------------------

  static const EventHook<FrameworkEvent> onListScrollPositionChangedEvent = const EventHook<FrameworkEvent>('listScrollPositionChanged');
  Stream<FrameworkEvent> get onListScrollPositionChanged => ListRenderer.onListScrollPositionChangedEvent.forTarget(this);
  int _scrollPosition = 0;
  
  void setScrollPositionExternally(int value) {
    if (value != _scrollPosition) {
      _scrollPosition = value;
      
      if (layout is VerticalLayout) control.scrollTop = _scrollPosition;
      else control.scrollLeft = _scrollPosition;

      updateAfterScrollPositionChanged();
    }
  }

  int get scrollPosition => _scrollPosition;
  set scrollPosition(int value) {
    if (value != _scrollPosition) {
      _scrollPosition = value;
      
      notify(
        new FrameworkEvent(
          'listScrollPositionChanged'
        )
      );

      updateAfterScrollPositionChanged();
    }
  }
  
  //---------------------------------
  // headerScrollPosition
  //---------------------------------

  static const EventHook<FrameworkEvent> onHeaderScrollPositionChangedEvent = const EventHook<FrameworkEvent>('headerScrollPositionChanged');
  Stream<FrameworkEvent> get onHeaderScrollPositionChanged => ListRenderer.onHeaderScrollPositionChangedEvent.forTarget(this);
  int _headerScrollPosition = 0;

  int get headerScrollPosition => _headerScrollPosition;
  set headerScrollPosition(int value) {
    if (value != _headerScrollPosition) {
      _headerScrollPosition = value;

      notify(
        new FrameworkEvent(
          'headerScrollPositionChanged'
        )
      );
    }
  }

  //---------------------------------
  // rowSpacing
  //---------------------------------

  int _rowSpacing = 0;

  @published int get rowSpacing => _rowSpacing;
  @published set rowSpacing(int value) {
    if (value != _rowSpacing) {
      _rowSpacing = value;

      invalidateProperties();
    }
  }
  
  //---------------------------------
  // autoScrollSelectionIntoView
  //---------------------------------

  bool _autoScrollSelectionIntoView = true;

  bool get autoScrollSelectionIntoView => _autoScrollSelectionIntoView;
  set autoScrollSelectionIntoView(bool value) {
    if (value != _autoScrollSelectionIntoView) {
      _autoScrollSelectionIntoView = value;

      if (value) later > scrollSelectionIntoView;
    }
  }
  
  //---------------------------------
  // selectedIndex
  //---------------------------------
  
  set selectedIndex(int value) {
    super.selectedIndex = value;
    
    _forceRefresh();
  }
  
  //---------------------------------
  // selectedIndices
  //---------------------------------
  
  set selectedIndices(ObservableList<int> value) {
    super.selectedIndices = value;
    
    _forceRefresh();
  }

  //---------------------------------
  // selectedItem
  //---------------------------------
  
  set selectedItem(dynamic value) {
    super.selectedItem = value;
    
    _forceRefresh();
  }
  
  //---------------------------------
  // selectedItems
  //---------------------------------
  
  set selectedItems(ObservableList<dynamic> value) {
    super.selectedItems = value;
    
    _forceRefresh();
  }

  //---------------------------------
  //
  // Constructor
  //
  //---------------------------------

  ListRenderer.created() : super.created() {
  	className = 'ListRenderer';
	
    this.orientation = 'vertical';
  }

  //---------------------------------
  //
  // Public methods
  //
  //---------------------------------
  
  TemplateElement template;
  
  @override
  void attached() {
    super.attached();
    
    template = this.querySelector('template');
    
    streamSubscriptionManager.add(
        'list_base_containerScroll', 
        control.onScroll.listen(_container_scrollHandler)
    );

    _scrollTarget = shadowRoot.querySelector('#scrollTarget');
    
    addComponent(_scrollTarget);
  }
  
  @override
  void commitProperties() {
    _updateOrientationIfNeeded();

    if (layout != null) layout.gap = _rowSpacing;
    
    if (
        _isUseSelectionEffectsChanged
    ) {
      _isUseSelectionEffectsChanged = false;
      
      control.children.forEach(
        (IItemRenderer renderer) => renderer.autoDrawBackground = _useSelectionEffects    
      );
    }

    super.commitProperties();
  }
  
  void scrollSelectionIntoView() {
    if (
        (selectedIndex >= 0)
    ) {
      final int pageItemSize = getPageItemSize();
      final int startIndex = (pageItemSize > 0) ? (_scrollPosition ~/ pageItemSize) : 0;
      final int endIndex = startIndex + control.children.length;
      int offset, target;
      
      if (
          (selectedIndex < startIndex) || 
          (selectedIndex >= endIndex)
      ) {
        if (layout is VerticalLayout) control.scrollTop = selectedIndex * _rowHeight;
        else control.scrollLeft = selectedIndex * _colWidth;
      }
    }
  }
  
  void setScrollPosition({int horizontalScrollValue: null, int verticalScrollValue: null}) {
    if (horizontalScrollValue != null)  control.scrollLeft = horizontalScrollValue;
    if (verticalScrollValue != null)    control.scrollTop = verticalScrollValue;
  }

  //---------------------------------
  //
  // Protected methods
  //
  //---------------------------------

  void _removeAllElements() {
    int i = control.children.length;
    
    while (i > 0) removeComponent(control.children[--i]);
  }

  void _updateRenderer(IItemRenderer renderer) {
    if (_colWidth > 0) renderer.width = _colWidth;
    else if (_colPercentWidth > .0) renderer.percentWidth = _colPercentWidth;

    if (_rowHeight > 0) renderer.height = _rowHeight;
    else if (_rowPercentHeight > .0) renderer.percentHeight = _rowPercentHeight;
  }

  static const EventHook<FrameworkEvent> onRendererAddedEvent = const EventHook<FrameworkEvent>('rendererAdded');
  Stream<FrameworkEvent> get onRendererAdded => ListRenderer.onRendererAddedEvent.forTarget(this);
  
  static const EventHook<FrameworkEvent> onRendererRemovedEvent = const EventHook<FrameworkEvent>('rendererRemoved');
  Stream<FrameworkEvent> get onRendererRemoved => ListRenderer.onRendererRemovedEvent.forTarget(this);
  
  @override
  void registerRenderer(IItemRenderer renderer) {
    renderer.index = childWrappers.length;
    renderer.enableHighlight = true;
    renderer.autoDrawBackground = _useSelectionEffects;
    
    renderer.streamSubscriptionManager.add(
        'list_base_rendererControlChanged', 
        renderer.onControlChanged.listen(
          (FrameworkEvent event) {
            final target = event.currentTarget as IItemRenderer;
            
            target.streamSubscriptionManager.flushIdent('list_base_rendererControlChanged');
            
            target.streamSubscriptionManager.add(
                'list_base_rendererMouseDown', 
                event.relatedObject.onMouseDown.listen(_handleMouseInteraction)
            );
          }
        )
    );

    _updateRenderer(renderer);
    
    addComponent(renderer);

    notify(
        new FrameworkEvent<IItemRenderer>(
            'rendererAdded',
            relatedObject: renderer
        )
    );
    
    later > _forceRefresh;
  }
  
  void _forceRefresh() {
    _previousFirstIndex = -1;

    updateAfterScrollPositionChanged();
  }
  
  @override
  int getPageItemSize() {
    if (
        (dataProvider == null) ||
        (dataProvider.length == 0)
    ) return super.getPageItemSize();

    return (layout is VerticalLayout) ? _rowHeight : _colWidth;
  }
  
  @override
  int getPageOffset() => _scrollPosition;
  
  @override
  int getPageSize() => (dataProvider != null) ? ((dataProvider.length * getPageItemSize())) : 0;
  
  @override
  void removeComponent(IUIWrapper element, {bool flush: true}) {
    super.removeComponent(element, flush:flush);
    
    notify(
      new FrameworkEvent<IUIWrapper>(
          'rendererRemoved',
          relatedObject: element
      )    
    );
  }
  
  int getNumElementsRequired() {
    final bool isVerticalLayout = (layout is VerticalLayout);
    
    if (isVerticalLayout) {
      if (
          (height == 0) || 
          (_rowHeight == 0)
      ) {
        return 0;
      } else {
        return min(
            (height ~/ _rowHeight + 2),
            dataProvider.length
        );
      }
    } else {
      if (
          (width == 0) || 
          (_colWidth == 0)
      ) {
        return 0;
      } else {
        return min(
            (width ~/ _colWidth + 2),
            dataProvider.length
        );
      }
    }
    
    return 0;
  }

  @override
  bool updateElements() {
    if (dataProvider == null) return false;
    
    final bool hasWidth = ((_colWidth > 0) || (_colPercentWidth > .0));
    final bool hasHeight = ((_rowHeight > 0) || (_rowPercentHeight > .0));

    if (
        hasWidth &&
        hasHeight
    ) {
      final bool isVerticalLayout = (layout is VerticalLayout);
      final int elementsRequired = getNumElementsRequired();

      dynamic element;
      final int existingLen = control.children.length;
      final int len = elementsRequired - existingLen;
      int i;
      
      if (_scrollTarget != null) {
        if (isVerticalLayout) {
          _scrollTarget.width = 1;

          if (_rowHeight > 0) _scrollTarget.height = dataProvider.length * _rowHeight;
        } else {
          if (_colWidth > 0) _scrollTarget.width = dataProvider.length * _colWidth;

          _scrollTarget.height = 1;
        }
      }
    }

    return false;
  }
  
  @override
  void updateAfterScrollPositionChanged() {
    if (dataProvider != null) {
      if (updateElements()) return;
      
      updateVisibleItemRenderers();
    }
    
    later > updateLayout;
  }
  
  ObservableList<_ListEntry> _templateDataProvider;
  
  void updateVisibleItemRenderers({bool ignorePreviousIndex: false}) {
    if (
        (dataProvider == null)
    ) return;
    
    final int pageItemSize = getPageItemSize();
    
    _firstIndex = (pageItemSize > 0) ? (_scrollPosition ~/ pageItemSize) : 0;
    
    if (
        ignorePreviousIndex ||
        (_firstIndex != _previousFirstIndex)
    ) {
      final int elementsRequired = getNumElementsRequired();
      final int len = _firstIndex + elementsRequired;
      
      _itemRendererLen = elementsRequired;

      dynamic data;
      int i, rendererIndex = 0;
      
      _previousFirstIndex = _firstIndex;
      
      if (template != null && (elementsRequired > 0)) {
        final List<dynamic> list = dataProvider.sublist(_firstIndex, min(len, dataProvider.length));
        int index = 0;
        
        if (_templateDataProvider == null) {
          _templateDataProvider = new ObservableList<_ListEntry>(list.length);
          
          for (int i=0; i<list.length; _templateDataProvider[i++] = new _ListEntry());
        }
        
        list.forEach(
          (dynamic D) => _templateDataProvider[index++]._set(D)
        );
        
        templateBind(template).model = _templateDataProvider;
            
        template.attributes['repeat'] = '';
        
        later > () => control.children.forEach(
          (IUIWrapper C) {
            if (C is IItemRenderer) C.selected = (C.data == selectedItem);
          }
        );
      }
    }
  }

  void _handleMouseInteraction(Event event) {
    if (event.type == 'mousedown') {
      final Element target = event.currentTarget as Element;
      final IItemRenderer itemRenderer = control.children.firstWhere(
          (IUIWrapper C) => (C.control == target),
          orElse: () => null
      );
      
      if (itemRenderer != null) {
        final int pageItemSize = getPageItemSize();
        
        if (pageItemSize is int && pageItemSize <= 0) return;
        
        final int index = (_scrollPosition ~/ getPageItemSize()) + control.children.indexOf(itemRenderer);
        
        if (allowMultipleSelection) {
          selectedIndex = -1;
          selectedItem = null;
          
          if (selectedIndices.contains(index)) {
            selectedIndices.remove(index);
            selectedItems.remove(dataProvider[index]);
          } else {
            selectedIndices.add(index);
            selectedItems.add(dataProvider[index]);
          }
          
          notify(
              new FrameworkEvent<Iterable<int>>(
                  'selectedIndicesChanged',
                  relatedObject: selectedIndices
              )
          );
      
          notify(
              new FrameworkEvent<Iterable<dynamic>>(
                'selectedItemsChanged',
                relatedObject: selectedItems
              )
          );
          
          later > updateSelection;
          
          _forceRefresh();
        } else {
          selectedIndex = index;
          selectedItem = dataProvider[index];
          
          selectedIndices.clear();
          selectedItems.clear();
        }
      }
    }
  }

  void _container_scrollHandler(Event event) => _updateScrollPosition();
  
  void _updateScrollPosition() {
    _hasScrolled = true;
    
    if (layout is VerticalLayout) {
      scrollPosition = control.scrollTop;
      headerScrollPosition = control.scrollLeft;
    } else {
      scrollPosition = control.scrollLeft;
      headerScrollPosition = control.scrollTop;
    }
  }
  
  @override
  void updateSelection() {
    updateVisibleItemRenderers(ignorePreviousIndex: true);
    
    if (_autoScrollSelectionIntoView) later > scrollSelectionIntoView;
  }
  
  void _updateOrientationIfNeeded() {
    if (_isOrientationChanged) {
      ILayout defaultLayout;
      
      _isOrientationChanged = false;
      
      if (orientation == 'horizontal') {
        defaultLayout = new HorizontalLayout();

        _rowHeight = 0;
        _rowPercentHeight = 100.0;
        
        if (_autoManageScrollBars) {
          horizontalScrollPolicy = ScrollPolicy.AUTO;
          verticalScrollPolicy = ScrollPolicy.NONE;
        }
      } else if (orientation == 'vertical') {
        defaultLayout = new VerticalLayout();

        _colWidth = 0;
        _colPercentWidth = 100.0;
        
        if (_autoManageScrollBars) {
          horizontalScrollPolicy = ScrollPolicy.NONE;
          verticalScrollPolicy = ScrollPolicy.AUTO;
        }
      } else if (orientation == 'grid') {
        defaultLayout = new VerticalLayout(constrainToBounds: false);

        _colWidth = 0;
        _colPercentWidth = 100.0;
        
        if (_autoManageScrollBars) verticalScrollPolicy = ScrollPolicy.AUTO;
      }

      defaultLayout.useVirtualLayout = true;
      defaultLayout.gap = _rowSpacing;

      layout = defaultLayout;
    }
  }
  
  @override
  void dataProvider_collectionChangedHandler(List<ListChangeRecord> changes) => _forceRefresh();
}

class _ListEntry extends ChangeNotifier {
  
  static const Symbol _DATA = const Symbol('dart_flex.components.list_renderer.dart._ListEntry.data');
  
  void _set(dynamic V) {
    if (V != _data[_DATA]) {
      final dynamic O = _data[_DATA];
      
      _data[_DATA] = V;
      
      notifyPropertyChange(_DATA, O, V);
    }
  }
  
  Map<Symbol, dynamic> _data = <Symbol, dynamic>{_DATA: null};
  
  dynamic get entry => _data[_DATA];
  
  String toString() => _data[_DATA].toString();
  
}