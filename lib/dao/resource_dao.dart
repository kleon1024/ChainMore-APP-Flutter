import 'dart:math';

import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/database/database.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/mock.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/types.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class ResourceDao extends ChangeNotifier {
  /// Model
  BuildContext context;
  GlobalModel _globalModel;

  CancelToken cancelToken = CancelToken();

  List<ResourceBean> resources = [];

  List<ChangeNotifierCallBack> callbacks = [];

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this._globalModel = globalModel;
      Future.wait([
        this.initResources(),
      ]).then((value) {
        refresh();
      });
    }
  }

  syncResources() {
    updateCreatedResources();
  }

  @override
  void dispose() {
    super.dispose();
    if (!cancelToken.isCancelled) cancelToken.cancel();
    _globalModel.homePageModel = null;
    debugPrint("Resource Model Destroyed");
  }

  /// Logic
  Future initResources() async {
    List<ResourceBean> rawResources;

    if (Utils.isMocking) {
      rawResources = await Mock.getResourceBeans(3);
    } else {
      rawResources = await DBProvider.db.getCollectedResources();
    }

    /// Fake Data
    if (rawResources == null) return;
    resources.clear();
    resources.addAll(rawResources);
    refresh();
    debugPrint("Resource Bean Inited");
  }

  getAllResources() {
    return resources;
  }

  updateCollectedResources() async {
    final userId = _globalModel.userDao.id;
    final options = _globalModel.userDao.buildOptions();

    ApiService.instance.getCollectedResources(
        options: options,
        success: (List<ResourceBean> beans) async {
          final locals = await DBProvider.db.getAllResources();
          Map<int, ResourceBean> resourceMap = {};
          locals.forEach((bean) {
            resourceMap[bean.id] = bean;
          });

          List<ResourceBean> localUpdates = [];
          List<ResourceBean> localCreates = [];
          List<ResourceBean> localDeletes = [];
          List<ResourceBean> remoteUncollects = [];
          List<ResourceBean> remoteCollects = [];
          beans.forEach((remote) {
            if (resourceMap.containsKey(remote.id)) {
              final local = resourceMap[remote.id];

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
                  /// Synced
                }
              }
              resourceMap.remove(remote.id);
            } else {
              remote.collected = true;
              localCreates.add(remote);
            }
          });

          resourceMap.values.forEach((local) {
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

          await DBProvider.db.createResources(localCreates);
          await DBProvider.db.updateResources(localUpdates);
          await DBProvider.db.removeResources(localDeletes);

          initResources().then((value) {
            refresh();
          });

          remoteCollects.forEach((local) {
            ApiService.instance.collectResource(
                options: options,
                params: {'id': local.id},
                success: (ResourceBean remote) {
                  local.dirty_collect = false;
                  DBProvider.db.updateResource(local);
                });
          });

          remoteUncollects.forEach((local) {
            ApiService.instance.unCollectResource(
                options: options,
                params: {'id': local.id},
                success: (ResourceBean remote) {
                  local.dirty_collect = false;
                  DBProvider.db.updateResource(local);
                });
          });
//          updateAllResources();
        });
  }

  updateCreatedResources() {
    final userId = _globalModel.userDao.id;
    final options = _globalModel.userDao.buildOptions();

    ApiService.instance.getCreatedResources(
        options: options,
        success: (List<ResourceBean> beans) async {
          final locals = await DBProvider.db.getCreatedResources(userId);
          Map<int, ResourceBean> resourceMap = {};
          locals.forEach((bean) {
            resourceMap[bean.id] = bean;
          });

          List<ResourceBean> remoteUpdates = [];
          List<ResourceBean> localCreates = [];
          List<ResourceBean> remoteCreates = [];
          List<ResourceBean> localDeletes = [];
          List<ResourceBean> localUpdates = [];

          beans.forEach((remote) {
            if (resourceMap.containsKey(remote.id)) {
              final local = resourceMap[remote.id];

              if (local.dirty_modify) {
                remoteUpdates.add(local);
              } else {
                final localTime = Utils.toDateTime(local.modify_time);
                final remoteTime = Utils.toDateTime(remote.modify_time);
                if (localTime.isBefore(remoteTime)) {
                  localUpdates.add(remote);
                } else if (localTime.isAfter(remoteTime)) {
                  /// Server Error
                } else {
                  /// Synced
                }
              }
              resourceMap.remove(remote.id);
            } else {
              localCreates.add(remote);
            }
          });

          resourceMap.values.forEach((local) {
            if (local.dirty_modify) {
              remoteCreates.add(local);
            } else {
              localDeletes.add(local);
            }
          });

          await DBProvider.db.createResources(localCreates);
          await DBProvider.db.updateResources(localUpdates);
          await DBProvider.db.removeResources(localDeletes);

          initResources().then((value) {
            refresh();
          });

          remoteUpdates.forEach((local) {
            ApiService.instance.updateResource(
                options: options,
                params: local.toJson(),
                success: (ResourceBean remote) {
                  local.dirty_modify = false;
                  DBProvider.db.updateResource(local);
                });
          });

          remoteCreates.forEach((local) {
            ApiService.instance.createResource(
                options: options,
                params: local.toJson(),
                success: (ResourceBean remote) {
                  ApiService.instance.collectResource(
                      options: options,
                      params: {'id': remote.id},
                      success: (ResourceBean remote) {
                        remote.collected = true;
                        DBProvider.db.updateResource(remote);
                      });
                });
          });

          updateCollectedResources();
        });


  }

  updateAllResources() async {
    final locals = await DBProvider.db.getAllResources();

    locals.forEach((local) {
      if (!local.dirty_modify) {
        ApiService.instance.getResource(
            params: {'id': local.id},
            success: (ResourceBean remote) {
              final localTime = Utils.toDateTime(local.modify_time);
              final remoteTime = Utils.toDateTime(remote.modify_time);
              if (localTime.isBefore(remoteTime)) {
                remote.collected = local.collected;
                remote.dirty_collect = local.dirty_collect;
                remote.dirty_modify = local.dirty_modify;
                DBProvider.db.updateResource(remote);
              }
            });
      }
    });
  }

  void refresh() {
    notifyListeners();
  }
}
