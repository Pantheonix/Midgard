import 'package:rive/rive.dart';

mixin RiveBear {
  //* State Machine Input -> SMI Input bool to trigger actions
  late final SMITrigger? successTrigger;
  late final SMITrigger? failTrigger;

  //* SMI Bool for eyes
  late final SMIBool? isChecking;
  late final SMIBool? isHandsUp;

  //* SMI for numbers of chars in text field
  late final SMINumber? lookNum;

  //* Art Board
  late final Artboard? artboard;

  //* State Machine Controller
  late final StateMachineController? stateMachineController;

  //to stay idle
  void idle() {
    isChecking?.change(false);
    isHandsUp?.change(false);
  }

  //to see eyes on the start of the text
  void lookAround() {
    isChecking?.change(true);
    isHandsUp?.change(false);
    lookNum?.change(0);
  }

  //to roll eyes according to the text
  void moveEyes(String value) {
    lookNum?.change(value.length.toDouble());
  }

  //to hide the eyes with hands
  void handsUpOnEyes() {
    isHandsUp?.change(true);
    isChecking?.change(false);
  }
}
