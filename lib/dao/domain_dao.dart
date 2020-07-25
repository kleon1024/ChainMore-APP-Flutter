import 'dart:math';

import 'package:chainmore/config/api_service.dart';
import 'package:chainmore/database/database.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/mock.dart';
import 'package:chainmore/model/global_model.dart';
import 'package:chainmore/utils/types.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';


/// TODO Update Sync Policy: No Network No Upload
class DomainDao extends ChangeNotifier {
  /// Model
  BuildContext context;
  GlobalModel _globalModel;

  CancelToken cancelToken = CancelToken();

  List<DomainBean> domains = [];

  List<ChangeNotifierCallBack> callbacks = [];

  void setContext(BuildContext context, {GlobalModel globalModel}) {
    if (this.context == null) {
      this.context = context;
      this._globalModel = globalModel;
      Future.wait([
        this.initDomains(),
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
  Future initDomains() async {
    List<DomainBean> rawDomains;

    if (Utils.isMocking) {
      rawDomains = await Mock.getDomainBeans(3);
    } else {
      rawDomains = await DBProvider.db.getMarkedDomains();
    }

    /// Fake Data
    if (rawDomains == null) return;
    domains.clear();
    domains.addAll(rawDomains);
    refresh();
    debugPrint("Domain Bean Inited");
  }

  getMarkedDomains() {
    return domains;
  }

  syncDomains() {
    updateMarkedDomain();
  }

  updateMarkedDomain() async {
    final userId = _globalModel.userDao.id;
    final options = await _globalModel.userDao.buildOptions();

    ApiService.instance.getMarkedDomains(
        options: options,
        success: (List<DomainBean> beans) async {
          final locals = await DBProvider.db.getAllDomains();
          Map<int, DomainBean> domainMap = {};
          locals.forEach((bean) {
            domainMap[bean.id] = bean;
          });

          List<DomainBean> localUpdates = [];
          List<DomainBean> localCreates = [];
          List<DomainBean> localDeletes = [];
          List<DomainBean> remoteUnmarks = [];
          List<DomainBean> remoteCollects = [];
          beans.forEach((remote) {
            debugPrint(remote.toJson().toString());
            if (domainMap.containsKey(remote.id)) {
              final local = domainMap[remote.id];

              if (local.dirty_mark) {
                if (!local.marked) {
                  remoteUnmarks.add(local);
                  if (local.creator_id != userId) {
                    localDeletes.add(local);
                  } else {
                    local.dirty_mark = false;
                    localUpdates.add(local);
                  }
                } else {
                  local.dirty_mark = false;
                  localUpdates.add(local);
                }
              } else {
                if (!local.marked) {
                  local.marked = true;
                  localUpdates.add(local);
                } else {
                  remote.marked = true;
                  localUpdates.add(remote);
                }
              }
              domainMap.remove(remote.id);
            } else {
              remote.marked = true;
              localCreates.add(remote);
            }
          });

          domainMap.values.forEach((local) {
            if (local.dirty_mark) {
              if (local.marked) {
                remoteCollects.add(local);
              } else {
                if (local.creator_id != userId) {
                  localDeletes.add(local);
                } else {
                  local.dirty_mark = false;
                  localUpdates.add(local);
                }
              }
            } else {
              if (local.marked) {
                if (local.creator_id != userId) {
                  localDeletes.add(local);
                } else {
                  local.marked = false;
                  localUpdates.add(local);
                }
              } else {
                if (local.creator_id != userId) {
                  localDeletes.add(local);
                } else {
                  /// Created
                }
              }
            }
          });

          await DBProvider.db.createDomains(localCreates);
          await DBProvider.db.updateDomains(localUpdates);
          await DBProvider.db.removeDomains(localDeletes);

          initDomains().then((value) {
            refresh();
          });

          remoteCollects.forEach((local) {
            ApiService.instance.markDomain(
                options: options,
                params: {'id': local.id},
                success: (DomainBean remote) {
                  local.dirty_mark = false;
                  DBProvider.db.updateDomain(local);
                });
          });

          remoteUnmarks.forEach((local) {
            ApiService.instance.unMarkDomain(
                options: options,
                params: {'id': local.id},
                success: (DomainBean remote) {
                  local.dirty_mark = false;
                  DBProvider.db.updateDomain(local);
                });
          });
        });
  }

  void refresh() {
    notifyListeners();
  }
}
