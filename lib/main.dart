
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const NoirApp());
}

// APP COLORS
class AppColors {
  static const background = Color(0xFF100D18);
  static const surface = Color(0xFF1B1626);
  static const card = Color(0xFF241D32);
  static const purple = Color(0xFF9B75C9);
  static const lightPurple = Color(0xFFC6A9E8);
  static const gold = Color(0xFFE6C98A);
  static const white = Color(0xFFF8F2EA);
  static const muted = Color(0xFFAA9DB8);
  static const border = Color(0xFF3A3048);
}

// QUOTE MODEL
class Quote {
  final String text;
  final String author;
  final String category;

  const Quote({
    required this.text,
    required this.author,
    required this.category,
  });
}

// MAIN APP
class NoirApp extends StatelessWidget {
  const NoirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOIR - Daily Inspiration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        fontFamily: 'Roboto',

        // Global color scheme: prevent default black text/icons on dark surfaces.
        colorScheme: const ColorScheme.dark(
          primary: AppColors.lightPurple,
          onPrimary: Colors.white,
          secondary: AppColors.gold,
          onSecondary: Color(0xFF211A30),
          surface: AppColors.surface,
          onSurface: AppColors.white,
          error: Color(0xFFFF8A9A),
          onError: Color(0xFF241018),
        ),

        // Default text and icon colors.
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.white),
          bodyMedium: TextStyle(color: AppColors.white),
          bodySmall: TextStyle(color: AppColors.muted),
          titleLarge: TextStyle(color: AppColors.white),
          titleMedium: TextStyle(color: AppColors.white),
          titleSmall: TextStyle(color: AppColors.white),
          labelLarge: TextStyle(color: AppColors.white),
          labelMedium: TextStyle(color: AppColors.white),
          labelSmall: TextStyle(color: AppColors.muted),
        ),
        iconTheme: const IconThemeData(color: AppColors.lightPurple),

        // Buttons.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purple,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.card,
            disabledForegroundColor: AppColors.muted,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.gold,
            disabledForegroundColor: AppColors.muted,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.lightPurple,
            side: const BorderSide(color: AppColors.lightPurple),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: AppColors.gold,
            disabledForegroundColor: AppColors.muted,
          ),
        ),

        // Navigation bar labels and icons.
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.purple.withValues(alpha: 0.28),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: AppColors.gold,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              );
            }
            return const TextStyle(
              color: AppColors.lightPurple,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.gold);
            }
            return const IconThemeData(color: AppColors.lightPurple);
          }),
        ),

        // Input fields, chips, dialogs and bottom sheets.
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: AppColors.muted),
          labelStyle: const TextStyle(color: AppColors.lightPurple),
          prefixIconColor: AppColors.gold,
          suffixIconColor: AppColors.lightPurple,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.lightPurple),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.card,
          selectedColor: AppColors.purple,
          labelStyle: const TextStyle(color: AppColors.white),
          secondaryLabelStyle: const TextStyle(color: Colors.white),
          side: const BorderSide(color: AppColors.border),
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: AppColors.surface,
          titleTextStyle: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: TextStyle(color: AppColors.lightPurple),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surface,
          modalBackgroundColor: AppColors.surface,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.card,
          contentTextStyle: TextStyle(color: AppColors.white),
          actionTextColor: AppColors.gold,
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const NoirHome(),
    );
  }
}

// MAIN SCREEN
class NoirHome extends StatefulWidget {
  const NoirHome({super.key});

  @override
  State<NoirHome> createState() => _NoirHomeState();
}

class _NoirHomeState extends State<NoirHome> {
  final Random random = Random();

  int selectedTab = 0;
  int currentQuoteIndex = 0;

  final Set<int> favorites = {};

  final TextEditingController searchController =
      TextEditingController();

  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Motivation',
    'Success',
    'Self Love',
    'Discipline',
    'Life',
    'Dreams',
  ];

  final List<Quote> quotes = const [
    Quote(
      text: 'It always seems impossible until it is done.',
      author: 'Nelson Mandela',
      category: 'Motivation',
    ),
    Quote(
      text: 'The secret of getting ahead is getting started.',
      author: 'Mark Twain',
      category: 'Success',
    ),
    Quote(
      text: 'Believe you can and you are halfway there.',
      author: 'Theodore Roosevelt',
      category: 'Motivation',
    ),
    Quote(
      text: 'Act as if what you do makes a difference. It does.',
      author: 'William James',
      category: 'Life',
    ),
    Quote(
      text: 'You yourself, as much as anybody in the entire universe, deserve your love and affection.',
      author: 'Buddha',
      category: 'Self Love',
    ),
    Quote(
      text: 'Great things are done by a series of small things brought together.',
      author: 'Vincent van Gogh',
      category: 'Success',
    ),
    Quote(
      text: 'Dream big and dare to fail.',
      author: 'Norman Vaughan',
      category: 'Dreams',
    ),
    Quote(
      text: 'Discipline is the bridge between goals and accomplishment.',
      author: 'Jim Rohn',
      category: 'Discipline',
    ),
    Quote(
      text: 'Your time is limited, so do not waste it living someone else’s life.',
      author: 'Steve Jobs',
      category: 'Life',
    ),
    Quote(
      text: 'You are never too old to set another goal or to dream a new dream.',
      author: 'C. S. Lewis',
      category: 'Dreams',
    ),
    Quote(
      text: 'The future depends on what you do today.',
      author: 'Mahatma Gandhi',
      category: 'Motivation',
    ),
    Quote(
      text: 'Success is not final, failure is not fatal: it is the courage to continue that counts.',
      author: 'Winston Churchill',
      category: 'Success',
    ),
    Quote(
      text: 'Knowing yourself is the beginning of all wisdom.',
      author: 'Aristotle',
      category: 'Self Love',
    ),
    Quote(
      text: 'Well done is better than well said.',
      author: 'Benjamin Franklin',
      category: 'Discipline',
    ),
    Quote(
      text: 'Do what you can, with what you have, where you are.',
      author: 'Theodore Roosevelt',
      category: 'Motivation',
    ),
    Quote(
      text: 'Life is really simple, but we insist on making it complicated.',
      author: 'Confucius',
      category: 'Life',
    ),
    Quote(
      text: 'Everything you can imagine is real.',
      author: 'Pablo Picasso',
      category: 'Dreams',
    ),
    Quote(
      text: 'It is never too late to be what you might have been.',
      author: 'George Eliot',
      category: 'Motivation',
    ),
    Quote(
      text: 'If you want to lift yourself up, lift up someone else.',
      author: 'Booker T. Washington',
      category: 'Life',
    ),
    Quote(
      text: 'You miss 100% of the shots you do not take.',
      author: 'Wayne Gretzky',
      category: 'Success',
    ),
    Quote(
      text: 'Nothing will work unless you do.',
      author: 'Maya Angelou',
      category: 'Discipline',
    ),
    Quote(
      text: 'Love yourself first and everything else falls into line.',
      author: 'Lucille Ball',
      category: 'Self Love',
    ),
    Quote(
      text: 'The only way to do great work is to love what you do.',
      author: 'Steve Jobs',
      category: 'Success',
    ),
    Quote(
      text: 'A journey of a thousand miles begins with a single step.',
      author: 'Lao Tzu',
      category: 'Motivation',
    ),
    Quote(
      text: 'You have within you right now, everything you need to deal with whatever the world can throw at you.',
      author: 'Brian Tracy',
      category: 'Self Love',
    ),
    Quote(
      text: 'Great minds have purposes, others have wishes.',
      author: 'Washington Irving',
      category: 'Dreams',
    ),
    Quote(
      text: 'Small daily improvements are the key to staggering long-term results.',
      author: 'Unknown',
      category: 'Discipline',
    ),
    Quote(
      text: 'The best way out is always through.',
      author: 'Robert Frost',
      category: 'Life',
    ),
  ];

  @override
  void initState() {
    super.initState();
    currentQuoteIndex = random.nextInt(quotes.length);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Quote get currentQuote => quotes[currentQuoteIndex];

  void generateQuote() {
    setState(() {
      int newIndex = random.nextInt(quotes.length);

      while (quotes.length > 1 &&
          newIndex == currentQuoteIndex) {
        newIndex = random.nextInt(quotes.length);
      }

      currentQuoteIndex = newIndex;
    });
  }

  void toggleFavorite(int index) {
    setState(() {
      if (favorites.contains(index)) {
        favorites.remove(index);
      } else {
        favorites.add(index);
      }
    });

    showMessage(
      favorites.contains(index)
          ? 'Added to your favorites ♡'
          : 'Removed from favorites',
    );
  }

  Future<void> copyQuote(Quote quote) async {
    await Clipboard.setData(
      ClipboardData(
        text: '"${quote.text}" — ${quote.author}',
      ),
    );

    if (!mounted) return;
    showMessage('Quote copied successfully!');
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.card,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void openQuoteDetail(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        final quote = quotes[index];

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 35),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 45,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 28),
                const Icon(
                  Icons.format_quote_rounded,
                  size: 48,
                  color: AppColors.gold,
                ),
                const SizedBox(height: 20),
                Text(
                  quote.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '— ${quote.author}',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 16),
                Chip(
                  label: Text(quote.category),
                  backgroundColor: AppColors.card,
                  labelStyle: const TextStyle(
                    color: AppColors.lightPurple,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          copyQuote(quote);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text('Copy'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          toggleFavorite(index);
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          favorites.contains(index)
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        label: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHomePage(),
      buildExplorePage(),
      buildFavoritesPage(),
      buildAboutPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: KeyedSubtree(
            key: ValueKey(selectedTab),
            child: pages[selectedTab],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 72,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.purple.withValues(alpha: 0.28),
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'About',
          ),
        ],
      ),
    );
  }

  // HOME PAGE
  Widget buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const NoirLogo(size: 48),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOIR',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                    Text(
                      'DAILY INSPIRATION',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 9,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedTab = 2;
                  });
                },
                icon: const Icon(
                  Icons.favorite_border_rounded,
                  color: AppColors.gold,
                ),
                tooltip: 'Saved quotes',
              ),
            ],
          ),

          const SizedBox(height: 38),

          const Text(
            'YOUR DAILY DOSE',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 11,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Become the best\nversion of yourself.',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 32,
              height: 1.25,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.7,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'A little inspiration can change your entire day.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 30),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF352544),
                  Color(0xFF211A30),
                  Color(0xFF191524),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.25),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withValues(alpha: 0.12),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '✦  QUOTE OF THE MOMENT',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        toggleFavorite(currentQuoteIndex);
                      },
                      icon: Icon(
                        favorites.contains(currentQuoteIndex)
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: AppColors.gold,
                      ),
                      tooltip: 'Save quote',
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: Text(
                    '“${currentQuote.text}”',
                    key: ValueKey(currentQuoteIndex),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      height: 1.55,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Container(
                  width: 42,
                  height: 2,
                  color: AppColors.gold,
                ),

                const SizedBox(height: 14),

                Text(
                  '— ${currentQuote.author}',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  currentQuote.category.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: generateQuote,
                        icon: const Icon(Icons.auto_awesome_rounded),
                        label: const Text('New Quote'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filledTonal(
                      onPressed: () => copyQuote(currentQuote),
                      icon: const Icon(Icons.copy_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.card,
                        foregroundColor: AppColors.gold,
                        padding: const EdgeInsets.all(16),
                      ),
                      tooltip: 'Copy quote',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Explore your mood',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedTab = 1;
                  });
                },
                child: const Text(
                  'See all',
                  style: TextStyle(color: AppColors.gold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 112,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                categoryCard('Motivation', Icons.bolt_rounded),
                categoryCard('Success', Icons.trending_up_rounded),
                categoryCard('Self Love', Icons.favorite_rounded),
                categoryCard('Discipline', Icons.flag_rounded),
                categoryCard('Dreams', Icons.nightlight_round),
              ],
            ),
          ),

          const SizedBox(height: 28),

          Container(
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.gold,
                  size: 30,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'A reminder for you',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Your journey is yours. Keep going, one step at a time.',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // CATEGORY CARD
  Widget categoryCard(String name, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = name;
          selectedTab = 1;
        });
      },
      child: Container(
        width: 108,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.gold, size: 27),
            const SizedBox(height: 10),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // EXPLORE PAGE
  Widget buildExplorePage() {
    final filteredQuotes = quotes.asMap().entries.where((entry) {
      final quote = entry.value;

      final matchesCategory = selectedCategory == 'All' ||
          quote.category == selectedCategory;

      final search = searchController.text.toLowerCase();

      final matchesSearch = quote.text.toLowerCase().contains(search) ||
          quote.author.toLowerCase().contains(search) ||
          quote.category.toLowerCase().contains(search);

      return matchesCategory && matchesSearch;
    }).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Discover',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Find the words your heart needs today.',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 22),

          TextField(
            controller: searchController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: AppColors.white),
            decoration: InputDecoration(
              hintText: 'Search quotes, authors, moods...',
              hintStyle: const TextStyle(
                color: AppColors.muted,
                fontSize: 12,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.gold,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.close),
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((category) {
                final isSelected = selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.purple,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.muted,
                      fontSize: 12,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.purple
                          : AppColors.border,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Inspirational quotes',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${filteredQuotes.length} quotes',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Expanded(
            child: filteredQuotes.isEmpty
                ? const Center(
                    child: Text(
                      'No quotes found.\nTry another search.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.muted,
                        height: 1.7,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredQuotes.length,
                    itemBuilder: (context, index) {
                      final entry = filteredQuotes[index];
                      final quoteIndex = entry.key;
                      final quote = entry.value;

                      return QuoteTile(
                        quote: quote,
                        isFavorite: favorites.contains(quoteIndex),
                        onTap: () => openQuoteDetail(quoteIndex),
                        onFavorite: () => toggleFavorite(quoteIndex),
                        onCopy: () => copyQuote(quote),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // FAVORITES PAGE
  Widget buildFavoritesPage() {
    final savedQuotes = favorites.toList()..sort();

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 25, 22, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Collection',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'All the words you want to keep close.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 25),

          Expanded(
            child: savedQuotes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite_border_rounded,
                          color: AppColors.purple,
                          size: 65,
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Your collection is waiting',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 9),
                        const Text(
                          'Save the quotes that inspire you.',
                          style: TextStyle(color: AppColors.muted),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedTab = 1;
                            });
                          },
                          child: const Text('Explore quotes'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: savedQuotes.length,
                    itemBuilder: (context, index) {
                      final quoteIndex = savedQuotes[index];
                      final quote = quotes[quoteIndex];

                      return QuoteTile(
                        quote: quote,
                        isFavorite: true,
                        onTap: () => openQuoteDetail(quoteIndex),
                        onFavorite: () => toggleFavorite(quoteIndex),
                        onCopy: () => copyQuote(quote),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ABOUT PAGE
  Widget buildAboutPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 35, 24, 30),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const NoirLogo(size: 100),
          const SizedBox(height: 22),
          const Text(
            'NOIR',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 8,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'DAILY INSPIRATION',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 11,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 35),

          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: AppColors.gold,
                  size: 35,
                ),
                SizedBox(height: 17),
                Text(
                  'A space for your growth.',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'NOIR is your personal space for motivation, '
                  'self-love, discipline and positive thinking. '
                  'Discover meaningful words, save your favorites '
                  'and take a little inspiration with you every day.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.muted,
                    height: 1.8,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          aboutFeature(
            Icons.format_quote_rounded,
            'Daily inspiration',
            'Discover motivational thoughts whenever you need them.',
          ),
          aboutFeature(
            Icons.favorite_rounded,
            'Your own collection',
            'Keep your favorite quotes in one place.',
          ),
          aboutFeature(
            Icons.search_rounded,
            'Explore and discover',
            'Find quotes by mood, category or author.',
          ),

          const SizedBox(height: 30),

          const Text(
            'Made with ♡ for dreamers and doers.',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'NOIR • Version 1.0',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget aboutFeature(
    IconData icon,
    String title,
    String description,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 25),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// CUSTOM LOGO
class NoirLogo extends StatelessWidget {
  final double size;

  const NoirLogo({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFB18BD7),
            Color(0xFF68458C),
            Color(0xFF352442),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.32),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.6),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        Icons.auto_awesome_rounded,
        color: AppColors.gold,
        size: size * 0.52,
      ),
    );
  }
}

// REUSABLE QUOTE CARD
class QuoteTile extends StatelessWidget {
  final Quote quote;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onCopy;

  const QuoteTile({
    super.key,
    required this.quote,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 13),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.gold,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    quote.category.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 9,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  visualDensity: VisualDensity.compact,
                  onPressed: onFavorite,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.purple.withValues(alpha: 0.22),
                    foregroundColor: isFavorite
                        ? const Color(0xFFFF8EAD)
                        : AppColors.gold,
                  ),
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 20,
                  ),
                  tooltip: 'Save quote',
                ),
                const SizedBox(width: 5),
                IconButton.filledTonal(
                  visualDensity: VisualDensity.compact,
                  onPressed: onCopy,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.card,
                    foregroundColor: AppColors.lightPurple,
                  ),
                  icon: const Icon(
                    Icons.copy_rounded,
                    size: 19,
                  ),
                  tooltip: 'Copy quote',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '“${quote.text}”',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 15,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '— ${quote.author}',
              style: const TextStyle(
                color: AppColors.lightPurple,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
