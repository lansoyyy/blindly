import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/colors.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imagePath;
  final String userName;
  final bool isNetworkImage;

  const FullScreenImageViewer({
    Key? key,
    required this.imagePath,
    required this.userName,
    this.isNetworkImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: textLight,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          userName,
          style: const TextStyle(
            color: textLight,
            fontFamily: 'Bold',
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 3.0,
          child: isNetworkImage
              ? Image.network(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.image,
                              color: textGrey,
                              size: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Failed to load image',
                              style: TextStyle(
                                color: textGrey,
                                fontSize: 16,
                                fontFamily: 'Regular',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.image,
                              color: textGrey,
                              size: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Failed to load image',
                              style: TextStyle(
                                color: textGrey,
                                fontSize: 16,
                                fontFamily: 'Regular',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
