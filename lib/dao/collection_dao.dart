import 'dart:math';

import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/database/database.dart';
import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/mock.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/types.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class CollectionDao extends ChangeNotifier {
  /// Model
  BuildContext context;
  GlobalModel _globalModel;

  CancelToken cancelToken = CancelToken();

  List<CollectionBean> collections = [];

  List<ChangeNotifierCallBack> callbacks = [];

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this._globalModel = globalModel;
      Future.wait([
        this.initCollections(),
      ]).then((value) {
        refresh();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!cancelToken.isCancelled) cancelToken.cancel();
    _globalModel.homePageModel = null;
    debugPrint("Resource Model Destroyed");
  }

  /// Logic
  Future initCollections() async {
    List<CollectionBean> rawCollections;

    if (Utils.isMocking) {
      rawCollections = await Mock.getCollectionBeans(3);
    } else {
      rawCollections = await DBProvider.db.getCollectedCollections();
    }

    rawCollections.sort((CollectionBean a, CollectionBean b) {
      return -(Utils.toDateTime(a.modify_time).millisecondsSinceEpoch -
          Utils.toDateTime(b.modify_time).millisecondsSinceEpoch);
    });

    /// Fake Data
    if (rawCollections == null) return;
    collections.clear();
    collections.addAll(rawCollections);

    refresh();
    debugPrint("Collection Bean Inited");
  }

  syncCollections() {
    syncCollectedCollections();
  }

  syncCollectedCollections() async {
    final userId = _globalModel.userDao.id;
    final options = await _globalModel.userDao.buildOptions();

    ApiService.instance.getCollectedCollections(
        options: options,
        success: (List<CollectionBean> beans) async {
          final locals = await DBProvider.db.getAllCollections();
          Map<int, CollectionBean> collectionMap = {};
          locals.forEach((bean) {
            collectionMap[bean.id] = bean;
          });

          List<CollectionBean> localUpdates = [];
          List<CollectionBean> localCreates = [];
          List<CollectionBean> localDeletes = [];
          List<CollectionBean> remoteUncollects = [];
          List<CollectionBean> remoteCollects = [];
          beans.forEach((remote) {
            debugPrint(remote.toJson().toString());
            if (collectionMap.containsKey(remote.id)) {
              final local = collectionMap[remote.id];

              if (local.dirty_collect) {
                if (!local.collected) {
                  remoteUncollects.add(local);
                  if (local.author_id != userId) {
                    localDeletes.add(local);
                  } else {
                    local.dirty_collect = false;
                    localUpdates.add(local);
                  }
                } else {
                  local.dirty_collect = false;
                  localUpdates.add(local);
                }
              } else {
                if (!local.collected) {
                  local.collected = true;
                  localUpdates.add(local);
                } else {
                  remote.collected = true;
                  localUpdates.add(remote);
                }
              }
              collectionMap.remove(remote.id);
            } else {
              remote.collected = true;
              localCreates.add(remote);
            }
          });

          collectionMap.values.forEach((local) {
            if (local.dirty_collect) {
              if (local.collected) {
                remoteCollects.add(local);
              } else {
                if (local.author_id != userId) {
                  localDeletes.add(local);
                } else {
                  local.dirty_collect = false;
                  localUpdates.add(local);
                }
              }
            } else {
              if (local.collected) {
                if (local.author_id != userId) {
                  localDeletes.add(local);
                } else {
                  local.collected = false;
                  localUpdates.add(local);
                }
              } else {
                if (local.author_id != userId) {
                  localDeletes.add(local);
                } else {
                  /// Created
                }
              }
            }
          });

          await DBProvider.db.createCollections(localCreates);
          await DBProvider.db.updateCollections(localUpdates);
          await DBProvider.db.removeCollections(localDeletes);

          initCollections().then((value) {
            refresh();
          });

          remoteCollects.forEach((local) {
            ApiService.instance.collectCollection(
                options: options,
                params: {'id': local.id},
                success: (CollectionBean remote) {
                  local.dirty_collect = false;
                  DBProvider.db.updateCollection(local);
                });
          });

          remoteUncollects.forEach((local) {
            ApiService.instance.unCollectCollection(
                options: options,
                params: {'id': local.id},
                success: (CollectionBean remote) {
                  local.dirty_collect = false;
                  DBProvider.db.updateCollection(local);
                });
          });
        });
  }

  getAllCollections() {
    return collections;
  }

  void refresh() {
    notifyListeners();
  }
}
