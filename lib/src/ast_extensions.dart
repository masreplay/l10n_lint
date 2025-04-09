import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

/// this adds some custom methods to the AstNode class
extension AstParser on AstNode {
  /// checks if it is an Expression with a static type that is a Widget
  bool get isWidgetClass {
    // https://github.com/invertase/dart_custom_lint/issues/42
    return this is Expression &&
        ((this as Expression).staticType?.isWidget ?? false);
  }

  /// checks if it is a FormalParameter with a static type that is a Widget
  bool get isWidgetConstructor {
    return this is ConstructorDeclaration &&
        ((this as ConstructorDeclaration)
                .declaredElement
                ?.returnType
                .allSupertypes
                .any((element) => element.isWidget) ??
            false);
  }

  /// checks if it is a FormalParameter with a static type that is a Widget
  bool get isWithinWidget {
    return this is VariableDeclaration &&
            ((this as VariableDeclaration)
                    .declaredElement
                    ?.enclosingElement3
                    ?.isWidgetClass ??
                false) ||
        _isWithinWidgetRecursively;
  }

  bool get _isWithinWidgetRecursively {
    return this is VariableDeclaration &&
        ((this as VariableDeclaration)
                .declaredElement
                ?.enclosingElement3
                ?._recursiveEnclosingElementIsWidget ??
            false);
  }
}

extension _DartTypeParser on DartType {
  bool get isWidget => element?.isWidgetClass ?? false;
}

/// if it is not "Widget", then use recursion to check if supertype is widget
extension ElementParser on Element {
  bool get _recursiveEnclosingElementIsWidget {
    if (enclosingElement3 == null) {
      return false;
    }
    if (enclosingElement3!.isWidgetClass) {
      return true;
    }
    return enclosingElement3!._recursiveEnclosingElementIsWidget;
  }

  bool get _hasBuildMethod =>
      // is interface (every class has an interface)
      (this is InterfaceElement) &&
      // has a build method
      (this as InterfaceElement).methods.any(
            (element) => element._isBuildMethod,
          );

  bool get _isBuildMethod =>
      // is method (or any other function)
      this is FunctionTypedElement &&
      // is named build
      (name == 'build' &&
          // returns Widget
          (this as FunctionTypedElement)
                  .returnType
                  // ignore: deprecated_member_use
                  .getDisplayString(withNullability: false) ==
              'Widget');

  bool get _hasCreateStateMethod =>
      // is interface (every class has an interface)
      (this is InterfaceElement) &&
      // has a build method
      (this as InterfaceElement).methods.any(
            (element) => element._isCreateStateMethod,
          );

  bool get _isCreateStateMethod =>
      // is method (or any other function)
      this is FunctionTypedElement &&
      // is named build
      name == 'createState' &&
      // returns Widget
      // (
      ((this as FunctionTypedElement)
              .returnType
              .element
              ?.children
              .any((element) => element._isBuildMethod) ??
          false);

  /// verifies if element has a build method and extends Widget or State
  bool get isWidgetClass => _hasBuildMethod || _hasCreateStateMethod;
}
