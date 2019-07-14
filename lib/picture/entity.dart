class CardEntity {
  int views;
  int ncos;
  int rank;
  List tag;
  String wp;
  bool xr;
  bool cr;
  int favs;
  double atime;
  String id;
  String desc;
  String thumb;
  String img;
  List cid;
  List url;
  String rule;
  String preview;
  String store;

  CardEntity(int views, int ncos, int rank, List tag, String wp, bool xr, bool cr,
             int favs, double atime, String id, String desc, String thumb, String img,
             List cid, List url, String rule, String preview, String store) {
    this.views = views;
    this.ncos = ncos;
    this.rank = rank;
    this.tag = tag;
    this.wp = wp;
    this.xr = xr;
    this.cr = cr;
    this.favs = favs;
    this.atime = atime;
    this.id = id;
    this.desc = desc;
    this.thumb = thumb;
    this.img = img;
    this.cid = cid;
    this.url = url;
    this.rule = rule;
    this.preview = preview;
    this.store = store;
  }
}

class ToolBarEntity {
  int count;
  String ename;
  String rname;
  String cover_temp;
  String name;
  String cover;
  int rank;
  List filter;
  int sn;
  String icover;
  double atime;
  int type;
  String id;
  String picasso_cover;

  ToolBarEntity(int count, String ename, String rname, String cover_temp, String name, String cover,
      int rank, List filter, int sn, String icover, double atime, int type, String id, String picasso_cover) {
    this.count = count;
    this.ename = ename;
    this.rname = rname;
    this.cover_temp = cover_temp;
    this.name = name;
    this.cover = cover;
    this.rank = rank;
    this.filter = filter;
    this.sn = sn;
    this.icover = icover;
    this.atime = atime;
    this.type = type;
    this.id = id;
    this.picasso_cover = picasso_cover;
  }
}