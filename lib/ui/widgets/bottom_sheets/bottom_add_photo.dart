import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scale_button/scale_button.dart';
import 'package:y_storiers/services/constants.dart';
import 'package:y_storiers/ui/add_post/add_post.dart';
import 'package:y_storiers/ui/settings/settings.dart';

class AddPhotoBottom extends StatefulWidget {
  bool account;
  AddPhotoBottom({Key? key, required this.account}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<AddPhotoBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: const BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            margin: const EdgeInsets.all(17),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      if (widget.account) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SettingsPage(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => const AddPostPage(
                              photoType: PhotoType.account,
                            ),
                          ),
                        ).then((value) {
                          Navigator.pop(context, value);
                        });
                      }
                    },
                    child: const SizedBox(
                      height: 47,
                      child: Center(
                        child: Text('?????????? ???????? ??????????????'),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: greyClose.withOpacity(0.21),
                ),
                Material(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      if (widget.account) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SettingsPage(
                              delete: true,
                            ),
                          ),
                        );
                      } else {
                        Navigator.pop(context, 'delete');
                      }
                    },
                    child: const SizedBox(
                      height: 47,
                      child: Center(
                        child: Text(
                          '?????????????? ????????',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 17, right: 17, bottom: 20),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const SizedBox(
                  height: 47,
                  child: Center(
                    child: Text(
                      '????????????',
                      style: TextStyle(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
