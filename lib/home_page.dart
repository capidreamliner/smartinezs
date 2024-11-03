import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Content extends StatefulWidget {
  const Content({Key? key}) : super(key: key);

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  int _currentIndex = 0;

  void _changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: width > 900 ? const EdgeInsets.symmetric(horizontal: 300) : const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentIndex == 0)
                  _HomeContent(onPortfolioPressed: () => _changeIndex(1))
                else
                  _PortfolioContent(onBackButtonPressed: () => _changeIndex(0)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final VoidCallback onPortfolioPressed;

  const _HomeContent({Key? key, required this.onPortfolioPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About me',
          style: GoogleFonts.leagueSpartan(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'I am Sebastián Martínez Santos, a student from Mendoza, Argentina with experience in robotics, software development and multimedia production. Feel free to contact me!',
          style: GoogleFonts.leagueSpartan(
            fontSize: width > 900 ? 30:25,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              buildLargeStyledButton(
                icon: Icons.phone,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ContactDialog(),
                  );
                },
                title: "Contact me",
                subtitle: "Hit me up!",
                width: width,
              ),
              buildLargeStyledButton(
                icon: FontAwesomeIcons.plane,
                onPressed: onPortfolioPressed,
                title: "Portfolio",
                subtitle: "Planespotting",
                width: width,
              ),
              
            ],
          ),
        ),
      ],
    );
  }
}

class _PortfolioContent extends StatelessWidget {
  @override
  final VoidCallback onBackButtonPressed;

  const _PortfolioContent({Key? key, required this.onBackButtonPressed})
      : super(key: key);
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBackButtonPressed,
                icon: Icon(Icons.arrow_back),
                iconSize: 50,
              ),
              Text(
                'Contact',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            height: 1000,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('photos').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final images = snapshot.data!.docs
                    .map((doc) => doc['url'] as String)
                    .toList();

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: StaggeredGridView.countBuilder(
                    padding: const EdgeInsets.all(12.0),
                    crossAxisCount: width > 900? 4: 1,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 12,
                    itemCount: images.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImagePage(
                                imageUrl: images[index],
                              ),
                            ),
                          );
                        },
                        child: ImageTile(imageUrl: images[index]),
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
    );
  }
}

Widget buildStyledButton({
  required IconData icon,
  required VoidCallback onPressed,
  bool isFaIcon = false,
}) {
  return Container(
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      border: Border.all(
        color: Colors.black.withOpacity(0.15),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: Offset(4, 4),
          blurRadius: 8,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Colors.white,
          offset: Offset(-4, -4),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: isFaIcon ? FaIcon(icon) : Icon(icon),
        iconSize: 30,
        onPressed: onPressed,
        color: Colors.black,
      ),
    ),
  );
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

Widget buildLargeStyledButton({
  required IconData icon,
  required VoidCallback onPressed,
  required String title,
  required String subtitle,
  required double width,
}) {
  
  return Container(
    width: width > 900 ? 300:150,
    height: width > 900 ? 200:150,
    margin: EdgeInsets.all(width > 900 ? 10:5),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(width > 900? 16:0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: width > 900? 40:20, color: Colors.black),
          SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.leagueSpartan(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.leagueSpartan(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}

class ContactDialog extends StatelessWidget {
  const ContactDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Contact Me',
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                buildStyledButton(
                  icon: Icons.phone,
                  onPressed: () => launchUrlString('callto:+5492617148982'),
                ),
                buildStyledButton(
                  icon: Icons.email,
                  onPressed: () =>
                      launchUrlString('mailto:contact@smartinezs.com'),
                ),
                buildStyledButton(
                  icon: FontAwesomeIcons.whatsapp,
                  onPressed: () => launchUrlString('https://wa.link/3028h0'),
                  isFaIcon: true,
                ),
                buildStyledButton(
                  icon: FontAwesomeIcons.linkedin,
                  onPressed: () =>
                      launchUrlString('https://www.linkedin.com/in/smartinezs'),
                  isFaIcon: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
