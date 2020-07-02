import 'package:chainmore/database/database.dart';
import 'package:chainmore/json/resource.dart';
import 'package:chainmore/model/resource_model.dart';

class ResourceLogic {
  final ResourceModel _model;

  ResourceLogic(this._model);

  Future getResources() async {
    var resources = await DBProvider.db.getAllResources();
    /// Fake Data

    if (resources == null) return;
    _model.resources.clear();
    _model.resources.addAll(resources);
    _model.traverseCallbacks();
  }
}