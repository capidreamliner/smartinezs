import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF59F42),
      appBar: AppBar(
        title: const Text(""),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/noise.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height/2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/logo2.png"),
                        fit: BoxFit.contain,
                        width: 50,
                      ),
                      Text(
                        'MY PHOTOS',
                        style: GoogleFonts.bagelFatOne(
                          fontSize: 80,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                
                      
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Gallery',
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: 500,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('photos')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                              
                                  final images = snapshot.data!.docs
                                      .map((doc) => doc['url'] as String)
                                      .toList();
                              
                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: StaggeredGridView.countBuilder(
                                      padding: const EdgeInsets.all(12.0),
                                      crossAxisCount: 4,
                                      mainAxisSpacing: 24,
                                      crossAxisSpacing: 12,
                                      itemCount: images.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FullScreenImagePage(
                                                  imageUrl: images[index],
                                                ),
                                              ),
                                            );
                                          },
                                          child:
                                              ImageTile(imageUrl: images[index]),
                                        );
                                      },
                                      staggeredTileBuilder: (int index) =>
                                          const StaggeredTile.fit(2),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageTile extends StatelessWidget {
  final String imageUrl;

  const ImageTile({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Full-Screen Image Page
class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // Close on tap
            },
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
