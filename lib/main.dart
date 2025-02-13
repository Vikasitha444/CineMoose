import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cine Moose',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}





class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Background color
    Color backgroundColor = Color(0xFFF7FCFB); // #fcf7fb

    return Scaffold(
      appBar: AppBar(
        title: const Text('CINE MOOSE'),
      ),
      body: Container(
        color: backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.purple.shade300,
                          Colors.purple.shade500,
                        ],
                        radius: 0.5,
                        center: Alignment(0.0, 0.0),
                      ),
                    ),
                  ),
                  Icon(Icons.movie, size: 80, color: const Color.fromARGB(255, 255, 255, 255)), // Icon color
                ],
              ),
              SizedBox(height: 20),
              Text(
                'We Recommend \nThe Best Movies!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat', // Replace with your custom font if needed
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GenreSelectionPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF1E96F0), // Button text color
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  "Let's Go!",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Button text color
                  ),
                ),
              ),
              SizedBox(height: 20), // Spacer between button and credits
              Text(
                '',
                style: TextStyle(
                  color: Colors.black, // Credits text color
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class GenreSelectionPage extends StatefulWidget {
  const GenreSelectionPage({Key? key}) : super(key: key);

  @override
  _GenreSelectionPageState createState() => _GenreSelectionPageState();
}

class _GenreSelectionPageState extends State<GenreSelectionPage> {
  List<String> selectedGenres = [];
  List<String> userGenres = [];

  static const List<String> genres = [
    'Comedy',
    'Action',
    'Drama',
    'Horror',
    'Sci-Fi',
    'Romance',
    'Thriller',
    'Adventure',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Genres'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Let's See What \nYour Taste Is Like",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Center(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  String genre = genres[index];
                  bool isSelected = selectedGenres.contains(genre);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedGenres.remove(genre);
                          userGenres.remove(genre);
                        } else {
                          selectedGenres.add(genre);
                          userGenres.add(genre);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          genre,
                          style: TextStyle(
                            fontSize: 15.2,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                print('Selected genres: $userGenres');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MovieSearchPage(
                            selectedGenres: userGenres,
                          )),
                );
              },
              child: Text('This is my choice'),
            ),
          ),
        ],
      ),
    );
  }
}

class MovieSearchPage extends StatefulWidget {
  final List<String> selectedGenres;

  MovieSearchPage({required this.selectedGenres});

  @override
  _MovieSearchPageState createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  List<dynamic> _suggestions = [];
  TextEditingController _controller = TextEditingController();
  dynamic _selectedMovie;

  void _getSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=066cd3debd494d2f7c93fc8983d23039&query=$input',
      ),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNjZjZDNkZWJkNDk0ZDJmN2M5M2ZjODk4M2QyMzAzOSIsInN1YiI6IjY2NmNhYjAwOWMwODMwNDU1ZTVhMGYzYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.fxc-p1ocRidzXVIHN_iNHswSEalX7jPHIOQOCSuAK-s',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _suggestions = json
            .decode(response.body)['results']
            .where((result) => result['poster_path'] != null)
            .toList();
      });
    } else {
      setState(() {
        _suggestions = [];
      });
    }
  }

  Widget _buildRatingStars(double rating) {
    int numberOfStars = (rating / 2).round();
    List<Widget> stars = List.generate(
      numberOfStars,
      (index) => Icon(
        Icons.star,
        color: Colors.amber,
        size: 20,
      ),
    );
    return Row(children: stars);
  }

  void _navigateToEmotionsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EmotionsPage(selectedGenres: widget.selectedGenres),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search That Movie'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "What is the best movie you have ever seen?",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    onChanged: _getSuggestions,
                    decoration: InputDecoration(
                      hintText: 'Search for a movie...',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          _getSuggestions(_controller.text);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _selectedMovie == null
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return ListTile(
                        leading: Image.network(
                          'https://image.tmdb.org/t/p/w185${suggestion['poster_path']}',
                          fit: BoxFit.cover,
                        ),
                        title: Text(suggestion['title']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(suggestion['release_date'] ??
                                'No release date'),
                            Row(
                              children: [
                                _buildRatingStars(
                                    suggestion['vote_average'].toDouble()),
                                SizedBox(width: 5),
                                Text(
                                  '${suggestion['vote_average']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            _selectedMovie = suggestion;
                            _controller.clear();
                          });
                        },
                      );
                    },
                  )
                : Card(
                    margin: const EdgeInsets.all(16.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15.0)),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${_selectedMovie['poster_path']}',
                            fit: BoxFit.cover,
                            height: 500,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedMovie['title'],
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                _selectedMovie['release_date'] ??
                                    'No release date',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  _buildRatingStars(
                                      _selectedMovie['vote_average']
                                          .toDouble()),
                                  SizedBox(width: 5),
                                  Text(
                                    '${_selectedMovie['vote_average']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                _selectedMovie['overview'],
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: _navigateToEmotionsPage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(
                                        255, 248, 242, 251), // Background color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          18), // Adjust border radius as needed
                                      side: BorderSide(
                                        color: Colors.black,
                                        width: .1, // Border width
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'This is it',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: const Color.fromARGB(
                                          255, 127, 109, 170), // Text color
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class EmotionsPage extends StatelessWidget {
  final List<String> selectedGenres;

  EmotionsPage({required this.selectedGenres});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emotions'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AnimatedEmoji(),
            SizedBox(height: 20),
            Text(
              'In What Mood Are You In Now?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            EmotionSelector(),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await showLoadingDialog(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MovieRecommendationPage(
                            selectedGenres: selectedGenres,
                          )),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showLoadingDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Searching for the best movie...'),
              ],
            ),
          ),
        );
      },
    );

    await Future.delayed(Duration(seconds: 3)); // Simulate a delay
    Navigator.of(context).pop(); // Dismiss the loading dialog
  }
}

class AnimatedEmoji extends StatefulWidget {
  @override
  _AnimatedEmojiState createState() => _AnimatedEmojiState();
}

class _AnimatedEmojiState extends State<AnimatedEmoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _colorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.yellow,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void animateToYellow() {
    _controller.forward();
  }

  void resetAnimation() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        var data = '';
        return Text(
          data,
          style: TextStyle(fontSize: 64, color: _colorAnimation.value),
        );
      },
    );
  }
}

class EmotionSelector extends StatefulWidget {
  @override
  _EmotionSelectorState createState() => _EmotionSelectorState();
}

class _EmotionSelectorState extends State<EmotionSelector> {
  String? selectedEmoji;

  void selectEmoji(String emoji) {
    setState(() {
      selectedEmoji = emoji;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmotionButton(
              emoji: '😄',
              label: 'Happy',
              isSelected: selectedEmoji == '😄',
              onPressed: () {
                selectEmoji('😄');
              },
            ),
            SizedBox(width: 20),
            EmotionButton(
              emoji: '😢',
              label: 'Sad',
              isSelected: selectedEmoji == '😢',
              onPressed: () {
                selectEmoji('😢');
              },
            ),
            SizedBox(width: 20),
            EmotionButton(
              emoji: '😐',
              label: 'Neutral',
              isSelected: selectedEmoji == '😐',
              onPressed: () {
                selectEmoji('😐');
              },
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmotionButton(
              emoji: '😡',
              label: 'Angry',
              isSelected: selectedEmoji == '😡',
              onPressed: () {
                selectEmoji('😡');
              },
            ),
            SizedBox(width: 20),
            EmotionButton(
              emoji: '😊',
              label: 'Excited',
              isSelected: selectedEmoji == '😊',
              onPressed: () {
                selectEmoji('😊');
              },
            ),
          ],
        ),
      ],
    );
  }
}

class EmotionButton extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const EmotionButton({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    isSelected ? Color.fromARGB(255, 88, 85, 85) : Colors.grey,
                width: 3.0,
              ),
              color: isSelected ? Colors.blue.withOpacity(0.9) : Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ]
                  : [],
            ),
            padding: EdgeInsets.all(16.0),
            child: Text(
              emoji,
              style: TextStyle(fontSize: 40),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

class MovieRecommendationPage extends StatefulWidget {
  final List<String> selectedGenres;
  MovieRecommendationPage({required this.selectedGenres});

  @override
  _MovieRecommendationPageState createState() =>
      _MovieRecommendationPageState();
}

class _MovieRecommendationPageState extends State<MovieRecommendationPage> {
  Map<String, dynamic>? _recommendedMovie;

  @override
  void initState() {
    super.initState();
    _fetchRandomMovie();
  }

  Future<void> _fetchRandomMovie() async {
    final apiKey = '066cd3debd494d2f7c93fc8983d23039';
    final accessToken =
        'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNjZjZDNkZWJkNDk0ZDJmN2M5M2ZjODk4M2QyMzAzOSIsInN1YiI6IjY2NmNhYjAwOWMwODMwNDU1ZTVhMGYzYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.fxc-p1ocRidzXVIHN_iNHswSEalX7jPHIOQOCSuAK-s';

    final genreMap = {
      'Comedy': 35,
      'Action': 28,
      'Drama': 18,
      'Horror': 27,
      'Sci-Fi': 878,
      'Romance': 10749,
      'Thriller': 53,
      'Adventure': 12,
    };

    List<int> genreIds = widget.selectedGenres
        .where((genre) => genreMap.containsKey(genre))
        .map((genre) => genreMap[genre]!)
        .toList();

    if (genreIds.isEmpty) return;

    final random = Random();
    int page = random.nextInt(100) + 1; // Random page number

    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=${genreIds.join(',')}&page=$page'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final results = json.decode(response.body)['results'];
      if (results.isNotEmpty) {
        setState(() {
          _recommendedMovie = results[random.nextInt(results.length)];
        });
      } else {
        _fetchRandomMovie(); // Try again if no results found
      }
    } else {
      setState(() {});
    }
  }

  Future<Map<String, dynamic>> _fetchMovieDetails(int movieId) async {
    final apiKey = '066cd3debd494d2f7c93fc8983d23039';
    final accessToken =
        'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNjZjZDNkZWJkNDk0ZDJmN2M5M2ZjODk4M2QyMzAzOSIsInN1YiI6IjY2NmNhYjAwOWMwODMwNDU1ZTVhMGYzYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.fxc-p1ocRidzXVIHN_iNHswSEalX7jPHIOQOCSuAK-s';

    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&append_to_response=credits'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  void _showCopyrightDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Copyright Notice"),
          content: Text("Due to copyright issues we cannot provide any external links."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFakeStreamingButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: _showCopyrightDialog,
            icon: Icon(Icons.movie),
            label: Text('Stream on CineSubz'),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieDetails() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchMovieDetails(_recommendedMovie!['id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              strokeWidth: 5,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load movie details'));
        } else {
          final movieDetails = snapshot.data!;
          final genres = (movieDetails['genres'] as List)
              .map<Widget>((genre) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      genre['name'],
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ))
              .toList();
          final runtime = movieDetails['runtime'];
          final imdbRating = movieDetails['vote_average'].toString();
          final voteCount = movieDetails['vote_count'];
          final cast = movieDetails['credits']['cast'].take(3).toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '🎬 Movie of the Day 🎬\n\n${movieDetails['title']} ',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${movieDetails['poster_path']}',
                        height: 300,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: _buildFakeStreamingButtons(),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Genres',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(children: genres),
                  SizedBox(height: 10),
                  Text(
                    'Release Year',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    movieDetails['release_date'].substring(0, 4),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'IMDb Rating',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  RatingBar.builder(
                    initialRating: double.parse(imdbRating) / 2,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                    ignoreGestures: true, // Make the RatingBar non-editable
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Number of Ratings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$voteCount',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Runtime',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Runtime: $runtime mins',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Overview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    movieDetails['overview'],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Cast',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: cast.map<Widget>((actor) {
                      return Column(
                        children: [
                          ClipOval(
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w200${actor['profile_path']}',
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            actor['name'],
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: _fetchRandomMovie,
                      label: Text('Next Choice'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        textStyle: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Recommendations'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 231, 231, 231),
              Color.fromARGB(255, 255, 255, 255)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: _recommendedMovie == null
              ? Center(child: Text(''))
              : _buildMovieDetails(),
        ),
      ),
    );
  }
}