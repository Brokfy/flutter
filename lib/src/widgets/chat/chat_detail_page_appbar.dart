import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../providers/admin_chat_provider.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/admin_model.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ChatDetailPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String nombre;
  final String img;
  final String bearer;
  final bool isNew;

  ChatDetailPageAppBar(
      {@required this.nombre,
      @required this.img,
      @required this.isNew,
      this.bearer});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFF0079DE),
      flexibleSpace: SafeArea(
        child: this.isNew
            ? _appBarChatNuevo(context)
            : _appBarChatAntiguo(context),
      ),
    );
  }

  Widget _appBarChatAntiguo(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2, // 20%
              child: SizedBox(
                height: 45.0,
                width: 45.0,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.all(0.0),
                    icon: Image.asset(
                      'images/icons/Chat_Back@3x.png',
                      filterQuality: FilterQuality.high,
                    )),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    this.nombre,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    "Asesor de seguros",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2, // 20%
              child: SizedBox(
                  height: 45.0,
                  width: 45.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {},
                          padding: EdgeInsets.all(0.0),
                          icon: Image.asset(
                            'images/icons/Chat_Call@3x.png',
                            filterQuality: FilterQuality.high,
                          )),
                    ],
                  )),
            ),
            Expanded(
              flex: 2, // 20%
              child: SizedBox(
                  height: 45.0,
                  width: 45.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {},
                          padding: EdgeInsets.all(0.0),
                          icon: Image.asset(
                            'images/icons/Chat_Profile@3x.png',
                            filterQuality: FilterQuality.high,
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBarChatNuevo(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 16),
      child: FutureBuilder(
        future: ApiService.getAdminChat(this.bearer),
        builder: (BuildContext context, AsyncSnapshot<AdminModel> snapshot) {
          if (!snapshot.hasData) {
            return _animacionSkeleton(context);
          } else {
            final admin = Provider.of<AdminChatProvider>(context);
            admin.id = snapshot.data.id;
            admin.foto = snapshot.data.image;
            admin.nombre = snapshot.data.nombre +
                ' ' +
                snapshot.data.apellidoPaterno +
                ' ' +
                snapshot.data.apelldioMaterno;
            return Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(admin.foto),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        admin.nombre,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_vert,
                  color: Colors.grey.shade700,
                ),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Widget _animacionSkeleton(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: SkeletonAnimation(
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: Colors.grey[300],
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
              child: SkeletonAnimation(
                child: Container(
                  height: 15,
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[300]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: SkeletonAnimation(
                  child: Container(
                    width: 60,
                    height: 13,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[300]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
