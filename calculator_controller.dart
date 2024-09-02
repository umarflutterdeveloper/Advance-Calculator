import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

class CalculatorController extends GetxController {
  var expression = ''.obs;
  var result = '0'.obs;
  var isDegreeMode = true.obs; // Toggle for Degree/Radian mode

  void addCharacter(String character) {
    expression.value += character;
  }

  void clear() {
    expression.value = '';
    result.value = '0';
  }

  void delete() {
    if (expression.value.isNotEmpty) {
      expression.value = expression.value.substring(0, expression.value.length - 1);
    }
  }

  void calculate() {
    try {
      String expr = expression.value;

      // Handle degree mode for sin, cos, tan without requiring parentheses
      if (isDegreeMode.value) {
        expr = expr.replaceAllMapped(
          RegExp(r'(sin|cos|tan)(\d+(\.\d+)?)'),
              (Match m) => '${m[1]}(${m[2]} * ${math.pi} / 180)',
        );
      } else {
        // For radian mode, just add the missing parentheses
        expr = expr.replaceAllMapped(
          RegExp(r'(sin|cos|tan)(\d+(\.\d+)?)'),
              (Match m) => '${m[1]}(${m[2]})',
        );
      }

      // Handle log (base 10), ln, exp, and √ (square root) without requiring parentheses
      expr = expr.replaceAllMapped(
        RegExp(r'(log|ln|exp|√)(\d+(\.\d+)?)'),
            (Match m) {
          if (m[1] == '√') {
            return 'sqrt(${m[2]})';
          } else if (m[1] == 'log') {
            return '(log(${m[2]}) / log(10))'; // log base 10
          } else if (m[1] == 'ln') {
            return 'log(${m[2]})'; // natural log (base e)
          } else if (m[1] == 'exp') {
            return 'exp(${m[2]})'; // exponential function
          } else {
            return m[0]!;
          }
        },
      );

      Parser parser = Parser();
      Expression exp = parser.parse(expr);
      ContextModel cm = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, cm);
      result.value = eval.toString();
    } catch (e) {
      result.value = "Error";
    }
  }

  void toggleDegreeMode() {
    isDegreeMode.value = !isDegreeMode.value;
  }
}
