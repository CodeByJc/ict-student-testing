import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

class CareerGuidanceScreen extends StatefulWidget {
  const CareerGuidanceScreen({super.key});

  @override
  State<CareerGuidanceScreen> createState() => _CareerGuidanceScreenState();
}

class _CareerGuidanceScreenState extends State<CareerGuidanceScreen> {
  // Inline API key as requested (do not move to API.dart)
  static const String _geminiApiKey = "AIzaSyDgmslsS8QSiemqfT9B-FHWpKUq_gGLjbQ";

  final List<String> _domains = const [
    'Software',
    'Hardware',
  ];

  final Map<String, List<String>> _subdomainsByDomain = const {
    'Software': [
      'Web Development',
      'Mobile App Development',
      'Data Science',
      'Machine Learning / AI',
      'Cybersecurity',
      'Cloud / DevOps',
      'Game Development',
      'UI/UX Engineering',
      'Blockchain',
    ],
    'Hardware': [
      'Embedded Systems',
      'IoT (Internet of Things)',
      'VLSI / Chip Design',
      'Robotics',
      'Networking & Telecom',
      'Hardware Security',
    ],
  };

  final List<String> _semesters =
      List<String>.generate(8, (index) => (index + 1).toString());

  String? _selectedDomain;
  String? _selectedSubdomain;
  String? _selectedSemester;

  bool _isLoading = false;
  String? _guidanceText;
  String? _errorText;
  final Map<String, String> _guidanceCache = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Career Guidance',
          style: TextStyle(fontFamily: 'mu_reg'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Answer a few questions to get tailored guidance:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'mu_reg',
              ),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Which domain do you like?',
              value: _selectedDomain,
              items: _domains,
              onChanged: (val) {
                setState(() {
                  _selectedDomain = val;
                  _selectedSubdomain = null; // reset subdomain on domain change
                });
              },
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              label: 'Which subdomain interests you?',
              value: _selectedSubdomain,
              items: _selectedDomain == null
                  ? const []
                  : _subdomainsByDomain[_selectedDomain!] ?? const [],
              onChanged: (val) {
                setState(() {
                  _selectedSubdomain = val;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              label: 'Which semester are you in?',
              value: _selectedSemester,
              items: _semesters,
              onChanged: (val) {
                setState(() {
                  _selectedSemester = val;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSubmit() ? _onGetGuidancePressed : null,
                child: const Text(
                  'Get Guidance',
                  style: TextStyle(fontFamily: 'mu_reg'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading) ...[
              const Center(child: CircularProgressIndicator()),
            ] else if (_errorText != null) ...[
              _buildCard(
                child: Text(
                  _errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontFamily: 'mu_reg',
                  ),
                ),
              ),
            ] else if (_guidanceText != null) ...[
              _buildCard(
                child: Html(
                  data: _markdownToBasicHtml(_guidanceText!),
                  style: {
                    "body": Style(fontSize: FontSize(15), fontFamily: 'mu_reg'),
                    "h1": Style(
                        fontSize: FontSize(22),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'mu_reg'),
                    "h2": Style(
                        fontSize: FontSize(20),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'mu_reg'),
                    "h3": Style(
                        fontSize: FontSize(18),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'mu_reg'),
                    "li": Style(fontSize: FontSize(15), fontFamily: 'mu_reg'),
                    "strong": Style(
                        fontWeight: FontWeight.w700, fontFamily: 'mu_reg'),
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _markdownToBasicHtml(String md) {
    final lines = md.split('\n');
    final buffer = StringBuffer();
    bool inUl = false;
    bool inOl = false;

    String lineToHtml(String line) {
      String html = line
          .replaceAllMapped(
              RegExp(r'\*\*(.+?)\*\*'), (m) => '<strong>${m[1]}</strong>')
          .replaceAllMapped(RegExp(r'\*(.+?)\*'), (m) => '<em>${m[1]}</em>');
      return html;
    }

    void closeLists() {
      if (inUl) {
        buffer.writeln('</ul>');
        inUl = false;
      }
      if (inOl) {
        buffer.writeln('</ol>');
        inOl = false;
      }
    }

    for (final raw in lines) {
      final line = raw.trimRight();

      final bulletMatch = RegExp(r'^[\s]*([\*\-•])\s+').firstMatch(line);
      final orderedMatch = RegExp(r'^[\s]*(\d+)[\.)]\s+').firstMatch(line);

      if (line.startsWith('### ')) {
        closeLists();
        buffer.writeln('<h3>${lineToHtml(line.substring(4))}</h3>');
      } else if (line.startsWith('## ')) {
        closeLists();
        buffer.writeln('<h2>${lineToHtml(line.substring(3))}</h2>');
      } else if (line.startsWith('# ')) {
        closeLists();
        buffer.writeln('<h1>${lineToHtml(line.substring(2))}</h1>');
      } else if (bulletMatch != null) {
        if (!inUl) {
          closeLists();
          buffer.writeln('<ul>');
          inUl = true;
        }
        final content = line.substring(bulletMatch.end);
        buffer.writeln('<li>${lineToHtml(content)}</li>');
      } else if (orderedMatch != null) {
        if (!inOl) {
          closeLists();
          buffer.writeln('<ol>');
          inOl = true;
        }
        final content = line.substring(orderedMatch.end);
        buffer.writeln('<li>${lineToHtml(content)}</li>');
      } else if (line.isEmpty) {
        closeLists();
        buffer.writeln('<br/>');
      } else {
        closeLists();
        buffer.writeln('<p>${lineToHtml(line.trimLeft())}</p>');
      }
    }

    closeLists();
    return buffer.toString();
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'mu_reg',
          ),
        ),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: const Text('Select'),
              items: items
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  bool _canSubmit() {
    return _selectedDomain != null &&
        _selectedSubdomain != null &&
        _selectedSemester != null &&
        !_isLoading;
  }

  Future<void> _onGetGuidancePressed() async {
    final key = _buildKey(
      domain: _selectedDomain!,
      subdomain: _selectedSubdomain!,
      semester: _selectedSemester!,
    );

    if (_guidanceCache.containsKey(key)) {
      setState(() {
        _guidanceText = _guidanceCache[key];
        _errorText = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _guidanceText = null;
      _errorText = null;
    });

    try {
      final prompt = _buildPrompt(
        domain: _selectedDomain!,
        subdomain: _selectedSubdomain!,
        semester: _selectedSemester!,
      );

      final guidance = await _generateWithGemini(prompt);
      setState(() {
        _guidanceText = guidance;
      });
      _guidanceCache[key] = guidance;
    } catch (e) {
      setState(() {
        _errorText = 'Failed to fetch guidance. Please try again.\n$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _buildPrompt({
    required String domain,
    required String subdomain,
    required String semester,
  }) {
    return ('You are an expert career counselor for university students. Respond in clean GitHub-flavored Markdown.\n'
        'Student details:\n'
        '- Domain: $domain\n'
        '- Subdomain: $subdomain\n'
        '- Current Semester: $semester (out of 8)\n\n'
        'Provide a concise, step-by-step career roadmap tailored to the student.\n'
        'Include:\n'
        '1) Skills to learn now (semester-aligned),\n'
        '2) Recommended projects and their brief descriptions,\n'
        '3) Certifications/courses (free and paid),\n'
        '4) Communities, events, or competitions,\n'
        '5) Internship/job search tips and resume/portfolio guidance,\n'
        '6) Mistakes to avoid.\n\n'
        'Use clear headings and bullet points. Keep it practical for a student.');
  }

  String _buildKey({
    required String domain,
    required String subdomain,
    required String semester,
  }) {
    return '${domain.trim()}|${subdomain.trim()}|${semester.trim()}';
  }

  Future<String> _generateWithGemini(String prompt) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_geminiApiKey',
    );

    final body = {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': prompt}
          ]
        }
      ]
    };

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Gemini API error: ${response.statusCode} ${response.body}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    final candidates = data['candidates'];
    if (candidates == null || candidates.isEmpty) {
      throw Exception('No guidance generated.');
    }

    final content = candidates[0]['content'];
    final parts = content != null ? content['parts'] as List<dynamic>? : null;
    if (parts == null || parts.isEmpty) {
      throw Exception('Empty response content.');
    }

    final text = parts[0]['text'];
    if (text is String && text.trim().isNotEmpty) {
      return text;
    }

    // Fallback: try from promptFeedback or other fields if structure differs
    return jsonEncode(data);
  }
}
