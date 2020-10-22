import 'dart:convert';

import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/json/resource_media_bean.dart';
import 'package:chainmore/mock.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'api_strategy.dart';
export 'package:dio/dio.dart';

///这里存放所有的网络请求接口
class ApiService {
  factory ApiService() => _getInstance();

  static ApiService get instance => _getInstance();
  static ApiService _instance;

  static final int requestSucceed = 0;
  static final int requestFailed = 1;

  ApiService._internal() {}

  static ApiService _getInstance() {
    if (_instance == null) {
      _instance = new ApiService._internal();
    }
    return _instance;
  }

  void getResourceMediaType({
    Function(List<ResourceMediaBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceMediaTypeMap().then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/type',
      (data) {
        final List items = data["items"];
        final List<ResourceMediaBean> beans =
            items.map((e) => ResourceMediaBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void checkResourceUrlExists({
    Function(List<ResourceBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) async {
    if (Utils.isMocking) {
      final r = await Mock.getResourceBeans(1);
      success(r);
      return;
    }

    ApiStrategy.getInstance().post(
      '/resource/exist',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void getCollectedResources({
    Function(List<ResourceBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(3).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/resource/stared',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void getMarkedDomains({
    Function(List<DomainBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getDomainBeans(3).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/domain/marked',
      (data) {
        final List items = data["items"];
        final List<DomainBean> beans =
            items.map((e) => DomainBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void getCreatedResources({
    Function(List<ResourceBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(3).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/resource/created',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void getResourceCollections({
    Function(List<CollectionBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getCollectionBeans(1).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/resource/collections',
          (data) {
        final List items = data["items"];
        final List<CollectionBean> beans =
        items.map((e) => CollectionBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void getCreatedDomains({
    Function(List<DomainBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getDomainBeans(3).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/domain/created',
      (data) {
        final List items = data["items"];
        final List<DomainBean> beans =
            items.map((e) => DomainBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void getResource({
    Function(ResourceBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/resource',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void getDomain({
    Function(DomainBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getDomainBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/domain',
          (data) {
        final List items = data["items"];
        final List<DomainBean> beans =
        items.map((e) => DomainBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void getAllDomains({
    Function(List<DomainBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getDomainBeans(1).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/domain/all',
          (data) {
        final List items = data["items"];
        final List<DomainBean> beans =
        items.map((e) => DomainBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void getDomainAggregators({
    Function(List<DomainBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getDomainBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/domain/i/aggregators',
          (data) {
        final List items = data["items"];
        final List<DomainBean> beans =
        items.map((e) => DomainBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void getDomainDependeds({
    Function(List<DomainBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getDomainBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/domain/i/dependeds',
          (data) {
        final List items = data["items"];
        final List<DomainBean> beans =
        items.map((e) => DomainBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void updateResource({
    Function(ResourceBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().put(
      '/resource',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void createResource({
    Function(ResourceBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().post(
      '/resource',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void collectResource({
    Function(ResourceBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().post(
      '/resource/star',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void unCollectResource({
    Function(ResourceBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().delete(
      '/resource/star',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void checkCollectResource({
    Function(List<ResourceBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(1).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/resource/star',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void markDomain({
    Function(DomainBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getDomainBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().post(
      '/domain/mark',
      (data) {
        final List items = data["items"];
        final List<DomainBean> beans =
            items.map((e) => DomainBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void unMarkDomain({
    Function(DomainBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getDomainBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().delete(
      '/domain/mark',
      (data) {
        final List items = data["items"];
        final List<DomainBean> beans =
            items.map((e) => DomainBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void checkMarkDomain({
    Function(List<DomainBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getDomainBeans(1).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/domain/mark',
      (data) {
        final List items = data["items"];
        final List<DomainBean> beans =
            items.map((e) => DomainBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void createCollection({
    Function(CollectionBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getCollectionBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().post(
      '/collection',
      (data) {
        final List items = data["items"];
        final List<CollectionBean> beans =
            items.map((e) => CollectionBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void updateCollection({
    Function(CollectionBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getCollectionBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().put(
      '/collection',
          (data) {
        final List items = data["items"];
        final List<CollectionBean> beans =
        items.map((e) => CollectionBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void collectCollection({
    Function(CollectionBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getCollectionBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().post(
      '/collection/collect',
      (data) {
        final List items = data["items"];
        final List<CollectionBean> beans =
            items.map((e) => CollectionBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void unCollectCollection({
    Function(CollectionBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getCollectionBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().delete(
      '/collection/collect',
      (data) {
        final List items = data["items"];
        final List<CollectionBean> beans =
            items.map((e) => CollectionBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void checkCollectCollection({
    Function(List<CollectionBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getCollectionBeans(1).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/collection/collect',
      (data) {
        final List items = data["items"];
        final List<CollectionBean> beans =
            items.map((e) => CollectionBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void getCollectedCollections({
    Function(List<CollectionBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getCollectionBeans(1).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/collection/collected',
      (data) {
        final List items = data["items"];
        final List<CollectionBean> beans =
            items.map((e) => CollectionBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void refreshAccessToken({
    Function(Map<String, String>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getAccessToken().then((data) {
        success(data);
      });

      return;
    }

    ApiStrategy.getInstance().delete(
      '/auth/refresh',
      (data) {
        success(data);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void createDomain({
    Function(DomainBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getDomainBeans(1).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().post(
      '/domain',
      (data) {
        final List items = data["items"];
        final List<DomainBean> beans =
            items.map((e) => DomainBean.fromJson(e)).toList();
        if (beans.length == 1) {
          success(beans[0]);
        } else {
          if (failed != null) {
            failed(beans);
          }
        }
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void updateDomain({
    Function(DomainBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getDomainBeans(1).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().put(
      '/domain',
          (data) {
        final List items = data["items"];
        final List<DomainBean> beans =
        items.map((e) => DomainBean.fromJson(e)).toList();
        if (beans.length == 1) {
          success(beans[0]);
        } else {
          if (failed != null) {
            failed(beans);
          }
        }
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void getDomainCollections({
    Function(List<CollectionBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getCollectionBeans(1).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/domain/collections',
      (data) {
        final List items = data["items"];
        final List<CollectionBean> beans =
            items.map((e) => CollectionBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }

  void getCollectionResources({
    Function(List<ResourceBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(1).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/collection/referenceds',
          (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
        items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: error,
      token: token,
      options: options,
    );
  }
}
