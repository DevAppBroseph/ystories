import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:y_storiers/services/constants.dart';
import 'package:y_storiers/services/objects/get_post.dart';
import 'package:y_storiers/services/objects/post.dart';
import 'package:y_storiers/services/objects/user_info.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

class PostImage extends StatelessWidget {
  PostImage({
    Key? key,
    required this.post,
    required this.index,
  }) : super(key: key);
  GetPost post;
  int index;

  @override
  Widget build(BuildContext context) {
    return _postImage(
      post.mediaUrl[index].media,
      context,
    );
  }

  Widget _postImage(String image, BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: ZoomOverlay(
          minScale: 0.5, // Optional
          maxScale: 3.0, // Optional
          twoTouchOnly: true,
          child:
              // Image.network(
              //   apiUrl + image,
              //   fit: BoxFit.cover,
              //   width: MediaQuery.of(context).size.width,
              //   height: MediaQuery.of(context).size.width,
              //   // loadingBuilder: (context, child, loadingProgress) {
              //   //   if (loadingProgress == null) return child;
              //   //   return Container(
              //   //     color: Colors.grey[100],
              //   //     child: Center(
              //   //       child: CircularProgressIndicator.adaptive(
              //   //         backgroundColor: Colors.grey[500],
              //   //       ),
              //   //     ),
              //   //   );
              //   // },
              // ),
              OctoImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
              apiUrl + image,
            ),
            progressIndicatorBuilder: (context, progress) {
              double? value;
              if (progress != null && progress.expectedTotalBytes != null) {
                value = progress.cumulativeBytesLoaded /
                    progress.expectedTotalBytes!;
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // margin: EdgeInsets.all(175),
                    height: 70,
                    width: 70,
                    child: CircleProgressBar(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey[400],
                      strokeWidth: 2,
                      value: value ?? 0.8,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
