
import 'package:chainmore/json/resource_bean.dart';

class Mock {
  static Future getResourceBeans(int num) async {
    List<ResourceBean> beans = [];
    for (int i = 0; i < num; i++) {
      beans.add(ResourceBean(
        id : 1,
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

        local_id: 1,
        dirty: false,
        update_time: "",
        collected: false,
      ));
    }

    await Future.delayed(Duration(milliseconds: 300));
    return beans;
  }
}