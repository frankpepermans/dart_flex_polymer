part of xml;

/**
 * Abstract XML node.
 */
abstract class XmlNode extends Object with XmlWritable, XmlParent {

  /**
   * Return the attribute nodes of this node.
   */
  List<XmlAttribute> get attributes => [];

  /**
   * Return the direct children of this node.
   */
  List<XmlNode> get children => [];

  /**
   * Return an iterable over the sub-tree below this node.
   *
   * This method is deprecated and will soon be removed, instead use the
   * more descriptive [descendants] iterator.
   */
  @deprecated
  Iterable<XmlNode> get iterable => descendants;

  /**
   * Return an interable of the nodes preceding the opening tag of this node
   * in document order.
   */
  Iterable<XmlNode> get preceding => new _XmlPrecedingIterable(this);

  /**
   * Return an iterable over the descendants of this node (children, grandchildren,
   * ...) in document order.
   */
  Iterable<XmlNode> get descendants => new _XmlDescendantsIterable(this);

  /**
   * Return an iterable of the nodes following the closing tag of this node
   * in document order.
   */
  Iterable<XmlNode> get following => new _XmlFollowingIterable(this);

  /**
   * Return an iterable over the ancestors of this node (parent, grandparent,
   * ...) in reverse document order.
   */
  Iterable<XmlNode> get ancestors => new _XmlAncestorsIterable(this);

  /**
   * Return the node type of this node.
   */
  XmlNodeType get nodeType;

  /**
   * Return the document that contains this node, or `null` if the node is
   * not part of a document.
   */
  XmlDocument get document => parent == null ? null : parent.document;

  /**
   * Return the first child of this node, or `null` if there are no children.
   */
  XmlNode get firstChild => children.isEmpty ? null : children.first;

  /**
   * Return the last child of this node, or `null` if there are no children.
   */
  XmlNode get lastChild => children.isEmpty ? null : children.last;

  /**
   * Return the text contents of this node and all its descendents.
   */
  String get text {
    return descendants.where((node) => node is XmlText).map((node) => node.text).join();
  }

  /**
   * Return the next sibling of this node or `null`.
   */
  XmlNode get nextSibling {
    if (parent != null) {
      var siblings = parent.children;
      for (var i = 0; i < siblings.length - 1; i++) {
        if (siblings[i] == this) {
          return siblings[i + 1];
        }
      }
    }
    return null;
  }

  /**
   * Return the previous sibling of this node or `null`.
   */
  XmlNode get previousSibling {
    if (parent != null) {
      var siblings = parent.children;
      for (var i = siblings.length - 1; i > 0; i--) {
        if (siblings[i] == this) {
          return siblings[i - 1];
        }
      }
    }
    return null;
  }

}
