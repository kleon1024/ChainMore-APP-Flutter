import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/logic/resource_creation_page_logic.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ResourceMode {
  CREATE,
  MODIFY,
}

enum ResourceCheckStatus {
  NOT_EXIST,
  EXISTED,
  NET_ERR,
  UNCHECK,
  CHECKED,
  URL_ILLEGAL,
}

class ResourceCreationPageModel extends ChangeNotifier {
  ResourceCreationPageLogic logic;
  BuildContext context;

  GlobalModel globalModel;

  ResourceCreationPageModel() {
    logic = ResourceCreationPageLogic(this);
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController uriEditingController = TextEditingController();
  final TextEditingController titleEditingController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode uriFocusNode = FocusNode();
  double padding;
  final int maxUriLength = 512;
  final int maxTitleLength = 64;
  final Map<ResourceCheckStatus, String> checkStatusStrMap = {
    ResourceCheckStatus.UNCHECK : 'url_uncheck',
    ResourceCheckStatus.EXISTED : 'url_existed',
    ResourceCheckStatus.NET_ERR : 'net_err',
    ResourceCheckStatus.NOT_EXIST: 'url_checked',
    ResourceCheckStatus.CHECKED: '',
    ResourceCheckStatus.URL_ILLEGAL: 'url_illegal',
  };

  ResourceMode mode = ResourceMode.CREATE;

  final cancelToken = CancelToken();

  Widget topResource = VEmptyView(0);

  // Check Duplication
  ResourceBean existedResource;
  // Resource
  ResourceBean resource;

  bool isPaid = false;

  bool isLoading = false;
  bool isChecking = false;
  bool isSubmitting = false;
  bool isCollecting = false;

  ResourceCheckStatus checkStatus = ResourceCheckStatus.UNCHECK;

  String lastCheckedUrl = "";
  String lastDetectedUrl = "";

  int selectedMediaTypeId = 1;
  int selectedResourceTypeId = 1;

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this.globalModel = globalModel;
      this.uriFocusNode.addListener(logic.onUriFocusNodeChanged);
      this.uriEditingController.addListener(logic.onUriValueChanged);
      this.padding = ScreenUtil().setWidth(15);

      Future.wait([]).then((value) {
        refresh();
      });
    }
  }

  void setResource(ResourceBean resource) {
    this.resource = resource;
    this.mode = ResourceMode.MODIFY;
    this.uriEditingController.text = resource.url;
    this.titleEditingController.text = resource.title;
    this.selectedResourceTypeId = resource.resource_type_id;
    this.selectedMediaTypeId = resource.media_type_id;
    this.checkStatus = ResourceCheckStatus.CHECKED;
    this.lastCheckedUrl = resource.url;
    this.lastDetectedUrl = resource.url;
    this.isPaid = !resource.free;
    this.isCollecting = false;
    this.isSubmitting = false;
    this.isChecking = false;
    this.isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
    scaffoldKey?.currentState?.dispose();
    globalModel.homePageModel = null;
    if (!cancelToken.isCancelled) cancelToken.cancel();
    debugPrint("Home Page Model Destroyed");
  }

  void refresh() {
    notifyListeners();
  }
}
