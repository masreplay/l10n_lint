import 'package:analyzer/dart/ast/ast.dart';
import 'package:l10n_lint/src/ast_extensions.dart';

part 'base_specifications.dart';

/// Specification: ast is any type of directive: import, export, part
class ImportSpecification extends LintSpecification {
  @override
  bool isSatisfiedBy(AstNode element) => element is Directive;
}

/// Specification: used in a Widget constructor
class ConstructorSpecification extends LintSpecification {
  @override
  bool isSatisfiedBy(AstNode element) => element.isWidgetConstructor;
}

/// Specification used in a function returning a Widget
class ClassSpecification extends LintSpecification {
  @override
  bool isSatisfiedBy(AstNode element) => element.isWidgetClass;
}

/// Specification used in a function returning a Widget
class InsideWidgetSpecification extends LintSpecification {
  @override
  bool isSatisfiedBy(AstNode element) => element.isWithinWidget;
}

class StringLiteralIsNotEmptySpecification extends LintSpecification {
  @override
  bool isSatisfiedBy(AstNode element) {
    return element is StringLiteral &&
        element.stringValue != null &&
        element.stringValue!.isNotEmpty;
  }
}

/// Specification used in a function returning a Widget

class AssertionSpecification extends LintSpecification {
  @override
  bool isSatisfiedBy(AstNode element) =>
      element is Assertion ||
      element.childEntities.any((e) => e is AstNode && isSatisfiedBy(e));
}

/// Specification: ast is a string literal used inside the definition of a
/// widget class or in a widget class constructor, or function that returns a
/// widget
class StringLiteralInsideWidgetSpecification extends LintSpecification {
  final _isNotImport = ImportSpecification().not();
  final _isConstructor = ConstructorSpecification();
  final _isClass = ClassSpecification();
  final _isNotAssertion = AssertionSpecification().not();
  final _isCompilationUnit = InsideWidgetSpecification();

  late final _specification = _isNotAssertion.and(_isNotImport).and(
        AnySpecification(
          [
            _isConstructor,
            _isClass,
            _isCompilationUnit,
          ],
        ),
      );

  @override
  bool isSatisfiedBy(AstNode element) {
    // print('$element ${element.runtimeType}');
    return _specification.isSatisfiedBy(element);
  }

  @override
  String toString() => '$_specification';
}
