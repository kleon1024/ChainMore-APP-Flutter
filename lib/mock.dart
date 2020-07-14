import 'package:chainmore/json/collection_bean.dart';
import 'package:chainmore/json/domain_bean.dart';
import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/json/resource_media_bean.dart';

class Mock {
  static Future getResourceBeans(int num) async {
    List<ResourceBean> beans = [];
    for (int i = 0; i < num; i++) {
      beans.add(ResourceBean(
        id: 1,
        title: "《汉密尔顿》 Hamilton (2020) 英文字幕 音乐剧",
        url: "https://www.bilibili.com/video/BV1vT4y17725",
        external: true,
        free: true,
        resource_type_id: 1,
        media_type_id: 1,
        author_id: 1,
        create_time: "Sat, 04 Jul 2020 04:34:57 GMT",
        modify_time: "Sat, 04 Jul 2020 04:34:57 GMT",
        deleted: false,
        /// Local
        dirty_modify: false,
        dirty_collect: false,
        collected: false,
      ));
    }

    await Future.delayed(Duration(milliseconds: 1));
    return beans;
  }

  static Future getCollectionBeans(int num) async {
    List<CollectionBean> beans = [];
    for (int i = 0; i < num; i++) {
      beans.add(CollectionBean(
        id: 1,
        title: "音乐剧 资源 推荐第一弹(2020) 英文字幕 音乐剧",
        author_id: 1,
        head_id: 1,
        reply_id: null,
        domain_id: 1,
        create_time: "Sat, 04 Jul 2020 04:34:57 GMT",
        modify_time: "Sat, 04 Jul 2020 04:34:57 GMT",
        deleted: false,
        /// Local
        local_id: 1,
        dirty: false,
        update_time: "",
        collected: false,
      ));
    }

    await Future.delayed(Duration(milliseconds: 1));
    return beans;
  }

  static Future getDomainBeans(int num) async {
    List<DomainBean> beans = [];
    for (int i = 0; i < num; i++) {
      beans.add(DomainBean(
        id: 1,
        title: "音乐小站",
        intro: "和我一起做个安静听歌的美子",
        creator_id: 1,
        create_time: "Sat, 04 Jul 2020 04:34:57 GMT",
        modify_time: "Sat, 04 Jul 2020 04:34:57 GMT",
        deleted: false,
        deleting: false,
        /// Local
        local_id: 1,
        dirty: false,
        update_time: "",
        marked: false,
      ));
    }

    await Future.delayed(Duration(milliseconds: 1));
    return beans;
  }

  static Future getResourceMediaTypeMap() async {
    await Future.delayed(Duration(milliseconds: 10));

    return [
      ResourceMediaBean(
        resource_id: 1,
        resource_name: "article",
        media_id: 1,
        media_name: "text",
      ),
      ResourceMediaBean(
        resource_id: 1,
        resource_name: "article",
        media_id: 2,
        media_name: "image",
      ),
      ResourceMediaBean(
        resource_id: 1,
        resource_name: "article",
        media_id: 3,
        media_name: "audio",
      ),
      ResourceMediaBean(
        resource_id: 1,
        resource_name: "article",
        media_id: 4,
        media_name: "video",
      ),
    ];
  }
}
