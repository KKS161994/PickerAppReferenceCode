import 'package:scoped_model/scoped_model.dart';

class EachTote extends Model {
  String order_id = "";
  String assigned_tote_title = "";

  EachTote({
    this.order_id,
    this.assigned_tote_title,
  });
}