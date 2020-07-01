import 'package:chainmore/config/keys.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/shared_util.dart';

class GlobalLogic {
  final GlobalModel _model;

  GlobalLogic(this._model);

  Future getCurrentLanguageCode() async {
    final languageCode =
        await SharedUtil.instance.getString(Keys.currentLanguageCode);
    if (languageCode == null) return;
    if (languageCode == _model.currentLanguageCode) return;
    _model.currentLanguageCode = languageCode;
  }

  Future getCurrentCountryCode() async {
    final countryCode =
    await SharedUtil.instance.getString(Keys.currentCountryCode);
    if (countryCode == null) return;
    if (countryCode == _model.currentLanguageCode) return;
    _model.currentLanguageCode = countryCode;
  }

  Future getAppName() async {
    final appName = await SharedUtil.instance.getString(Keys.appName);
    if (appName == null) return;
    if (appName == _model.appName) return;
    _model.appName = appName;
  }
}
