import 'package:get/get.dart';

class LastPeriodController extends GetxController {
  Rxn<DateTime> lastPeriodDate = Rxn<DateTime>();

  void setLastPeriodDate(DateTime date) {
    lastPeriodDate.value = date;
  }
}
