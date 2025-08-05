// restriction_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/restriction_service.dart';
import 'package:missionland_app/app/home_page.dart';

class RestrictionScreen extends StatefulWidget {
  final String appName;
  final double currentEmission;
  final double limit;

  const RestrictionScreen({
    Key? key,
    required this.appName,
    required this.currentEmission,
    required this.limit,
  }) : super(key: key);

  @override
  State<RestrictionScreen> createState() => _RestrictionScreenState();
}

class _RestrictionScreenState extends State<RestrictionScreen> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  final TextEditingController _quoteController = TextEditingController();
  final FocusNode _quoteFocusNode = FocusNode();
  bool _isQuoteValid = false;
  String _errorMessage = '';
  bool _showQuoteInput = false;

  // Famous environmental quotes database
  final List<String> _environmentalQuotes = [
    "The Earth does not belong to us; we belong to the Earth",
    "What we are doing to the forests of the world is but a mirror reflection of what we are doing to ourselves and to one another",
    "The environment is where we all meet; where we all have a mutual interest; it is the one thing all of us share",
    "Climate change is no longer some far-off problem; it is happening here, it is happening now",
    "The greatest threat to our planet is the belief that someone else will save it",
    "We do not inherit the Earth from our ancestors; we borrow it from our children",
    "The Earth is what we all have in common",
    "Nature is not a place to visit, it is home",
    "There are no passengers on spaceship Earth, we are all crew",
    "The climate crisis has already been solved. We already have the facts and solutions",
    "We are the first generation to feel the effect of climate change and the last generation who can do something about it",
    "Act as if what you do makes a difference. It does",
  ];

  @override
  void initState() {
    super.initState();
    
    // 전체화면 설정
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    // 애니메이션 설정
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();
    
    // Quote input listener
    _quoteController.addListener(_validateQuote);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _quoteController.dispose();
    _quoteFocusNode.dispose();
    // 시스템 UI 복원
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _validateQuote() {
    final input = _quoteController.text.trim().toLowerCase();
    
    if (input.isEmpty) {
      setState(() {
        _isQuoteValid = false;
        _errorMessage = '';
      });
      return;
    }

    // Check if input matches any of the environmental quotes (case insensitive, flexible matching)
    bool isValid = _environmentalQuotes.any((quote) {
      final normalizedQuote = quote.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
      final normalizedInput = input.replaceAll(RegExp(r'[^\w\s]'), '');
      
      // Allow partial matches (at least 70% of the quote)
      final words = normalizedQuote.split(' ');
      final inputWords = normalizedInput.split(' ');
      
      if (inputWords.length < words.length * 0.7) return false;
      
      int matchingWords = 0;
      for (String word in inputWords) {
        if (normalizedQuote.contains(word) && word.length > 2) {
          matchingWords++;
        }
      }
      
      return matchingWords >= words.length * 0.7;
    });

    setState(() {
      _isQuoteValid = isValid;
      _errorMessage = isValid ? '' : 'Please enter a valid environmental quote';
    });
  }

  String _getRandomQuote() {
    _environmentalQuotes.shuffle();
    return _environmentalQuotes.first;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // 뒤로가기 차단
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: SingleChildScrollView(
                child: _buildContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 제목
          const Text(
            'CARBON LIMIT REACHED',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 20),
          
          // 앱 이름
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.black.withOpacity(0.3)),
            ),
            child: Text(
              widget.appName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // 배출량 정보
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.withOpacity(0.5), width: 2),
            ),
            child: Column(
              children: [
                const Text(
                  'Today\'s Carbon Emission',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${widget.currentEmission.toStringAsFixed(1)}g / ${widget.limit.toStringAsFixed(1)}g',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const Text(
                  'CO₂',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // 메시지
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Take a break and help save the planet! 🌍',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Environmental Quote Challenge Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.format_quote,
                  size: 40,
                  color: Colors.green,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Climate Challenge',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'To continue, please type a famous environmental quote to reflect on our planet\'s future',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                
                if (!_showQuoteInput) ...[
                  // Show random quote as hint
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Example:',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '"${_getRandomQuote()}"',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontStyle: FontStyle.italic,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showQuoteInput = true;
                      });
                      Future.delayed(const Duration(milliseconds: 100), () {
                        _quoteFocusNode.requestFocus();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Start Challenge',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ] else ...[
                  // Quote input field
                  TextField(
                    controller: _quoteController,
                    focusNode: _quoteFocusNode,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Type an environmental quote here...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: _isQuoteValid ? Colors.green : Colors.orange,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(15),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Validation message
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  
                  if (_isQuoteValid)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 5),
                        Text(
                          'Great! Valid environmental quote',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 15),
                  
                  // Hint button
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Need a hint?'),
                          content: Text(
                            'Here\'s another example:\n\n"${_getRandomQuote()}"',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Got it!'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'Need a hint?',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          // 닫기 버튼 (only enabled when quote is valid or quote input not shown)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: (!_showQuoteInput || _isQuoteValid) ? _closeRestriction : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (!_showQuoteInput || _isQuoteValid) 
                      ? Colors.green 
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  _showQuoteInput && !_isQuoteValid ? 'Complete the Challenge' : 'Continue',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _closeRestriction() async {
    if (_showQuoteInput && !_isQuoteValid) {
      // Show error if trying to close without valid quote
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete the climate challenge first!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 제한 해제
    RestrictionService.dismissRestriction();

    // 시스템 UI 복원
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Show completion message if quote was entered
    if (_isQuoteValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for reflecting on our planet\'s future! 🌍'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }

    // 현재 화면을 모두 종료하고 홈 화면으로 이동
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage())
    );
  }
}