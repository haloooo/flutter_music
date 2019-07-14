class GankApi{
  static const String API_GANK_HOST = 'http://gank.io';
  static const String API_CATEGORIES = '$API_GANK_HOST/api/xiandu/categories';  //获取闲读的主分类
  static const String API_CATEGORY = '$API_GANK_HOST/api/xiandu/category';
  static const String API_CATEGORY_DATA = '$API_GANK_HOST/api/xiandu/data/id/';
  static const String API_GANK_TODAY = '$API_GANK_HOST/api/today'; //获取最新一天的干货
  static const String API_GANK_PICTURE = '$API_GANK_HOST/api/data/福利/10/'; //获取图片
  static const String API_GANK_DAY = '$API_GANK_HOST/api/day/'; //获取某天干货
  static const String API_GANK_NEWS = 'https://www.apiopen.top/satinApi?type=4&page='; //随机推荐段子（包含文字、图片、GIF、视频
  static const String API_GANK_MUSIC_RECOMMEND = 'http://www.mxnzp.com/api/music/recommend/list'; //音乐日推
  static const String API_GANK_MUSIC_ORDER = 'http://www.mxnzp.com/api/music/order/list'; //获取每日音乐推荐列表
  static const String API_GANK_MUSIC_DETAIL = 'http://www.mxnzp.com/api/music/song/detail?songId='; //根据歌曲id获取歌曲详情
  static const String API_GANK_MUSIC_ORDER_LIST = 'http://www.mxnzp.com/api/music/order/song/list?'; //获取指定榜单的歌曲列表
  static const String API_GANK_MUSIC_SEARCH_SINGER = 'http://www.mxnzp.com/api/music/singer/search?keyWord='; //搜索歌手信息
  static const String API_GANK_MUSIC_GET_SINGER_DETAIL = 'http://www.mxnzp.com/api/music/singer/detail?singerId='; //搜索歌手信息
  static const String API_GANK_MUSIC_GET_SINGER_SONGS = 'http://www.mxnzp.com/api/music/singer/song/list?singerId='; //获取歌手所有的歌曲列表
  static const String API_GANK_PICTURE_MEITU = 'https://www.apiopen.top/meituApi?page='; //美图获取接口
  static const String API_GANK_PICTURE_TYPE = 'http://service.picasso.adesk.com/v1/vertical/category'; //获取手机壁纸类别
  static const String API_EYEOPEN_CATEGPRIES = 'http://baobab.kaiyanapp.com/api/v4/categories'; //分类
}