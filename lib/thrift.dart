import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'goldtop.dart';
import 'bottom.dart';
import 'buy.dart';
import 'sell.dart';

class ThriftPage extends StatefulWidget {
  @override
  _ThriftPageState createState() => _ThriftPageState();
}

class _ThriftPageState extends State<ThriftPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isChewieInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.asset('assets/thriftvid.mp4');
    try {
      await _videoPlayerController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
        aspectRatio: 16 / 9, // Adjust aspect ratio as per your video's dimensions
      );
      setState(() {
        _isChewieInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error initializing video player: $e");
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Goldtop(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _isChewieInitialized
                      ? Chewie(controller: _chewieController)
                      : Center(child: Text('Error loading video')),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Text(
                    'Welcome to the Thrift Shop!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gabriela-Regular',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'The Thrift page offers a community-driven marketplace where users can buy and sell pre-owned clothing items. It promotes sustainable fashion by encouraging the reuse of clothes, making unique and affordable styles accessible to all.',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily:'Gabriela-Regular',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SellPage()),
                          );
                        },
                        icon: Icon(Icons.sell),
                        label: Text(
                          'Sell',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Gabriela-Regular',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          backgroundColor: Color(0xFFB99A45),
                          foregroundColor: Colors.black,
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BuyPage()),
                          );
                        },
                        icon: Icon(Icons.shopping_cart),
                        label: Text(
                          'Buy',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Gabriela-Regular',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          backgroundColor: Color(0xFFB99A45),
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(pageBackgroundColor: Colors.white, currentIndex: 0),
    );
  }
}