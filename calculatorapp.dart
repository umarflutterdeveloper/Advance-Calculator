import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/calculator_controller.dart';

class CalculatorScreen extends StatelessWidget {
  final CalculatorController controller = Get.put(CalculatorController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Calculator', style: TextStyle(fontSize: width * 0.05,fontWeight: FontWeight.bold)),
        actions: [
          Obx(() => Switch(
            value: controller.isDegreeMode.value,
            onChanged: (value) {
              controller.toggleDegreeMode();
            },
            activeColor: Colors.white,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey[600],
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              controller.isDegreeMode.value ? 'DEG' : 'RAD',
              style: TextStyle(fontSize: width * 0.018),
            ),
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.expression.value,
                    style: TextStyle(fontSize: width * 0.06, color: Colors.white54),
                  ),
                  Text(
                    controller.result.value,
                    style: TextStyle(
                        fontSize: width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              )),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildButtonRow(['7', '8', '9', '/']),
                  buildButtonRow(['4', '5', '6', '*']),
                  buildButtonRow(['1', '2', '3', '-']),
                  buildButtonRow(['0', '.', '=', '+']),
                  buildButtonRow(['C', 'DEL', '(', ')']),
                  buildButtonRow(['sin', 'cos', 'tan', 'log']),
                  buildButtonRow(['ln', 'exp', '√', '^']), // Added new advanced functions
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons.map((text) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: ElevatedButton(
                onPressed: () {
                  if (text == 'C') {
                    controller.clear();
                  } else if (text == 'DEL') {
                    controller.delete();
                  } else if (text == '=') {
                    controller.calculate();
                  } else {
                    controller.addCharacter(text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade400, // Use backgroundColor instead of primary
                  foregroundColor: Colors.white, // Use foregroundColor instead of onPrimary
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  textStyle: TextStyle(fontSize: 24),
                  shadowColor: Colors.tealAccent,
                  elevation: 5,
                ),
                child: Text(text),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
