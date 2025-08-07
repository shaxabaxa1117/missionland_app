import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:missionland_app/feature/posts/data/datasource/image_upload_service.dart';
import 'package:missionland_app/feature/posts/data/model/post_model.dart';
import 'package:missionland_app/feature/posts/domain/entity/post_entity.dart';
import 'package:missionland_app/feature/posts/presentation/bloc/post_bloc.dart';
import 'package:missionland_app/feature/posts/presentation/bloc/post_event.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  int _selectedVideoIndex = 1; // 기본값을 1로 설정

  List<double> confidenceList = [];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> fetchDetectionData(String imageUrl) async {
    setState(() {
      confidenceList = []; // 새 요청 시 초기화
    });

    try {
      final response = await http.get(
        Uri.parse('http://13.209.81.192:5000/run?imageUrl=$imageUrl'),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final detections = jsonData['detection'];

        setState(() {
          confidenceList =
              detections
                  .map<double>((item) => item['confidence'] as double)
                  .toList();
        });
      } else {
        throw Exception('Failed to load detection data');
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  void _submitPost() async {
    print("Submit start");
    if (_imageFile != null && _descriptionController.text.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final post = PostModel(
          id: const Uuid().v4(),
          imageUrl: _imageFile!.path,
          description: _descriptionController.text,
          createdAt: DateTime.now(),
          userId: user.uid,
          userEmail: user.email ?? 'unknown',
          likedBy: [],
          thumbsUpBy: [],
        );
        if (_selectedVideoIndex == 9) {}
        _clearInputs();

        final imageUploadService = ImageUploadService();
        final imageUrl = await imageUploadService.uploadImage(
          filePath: post.imageUrl,
          userId: user.uid,
        );

        final postWithImage = post.copyWith(imageUrl: imageUrl);

        await fetchDetectionData(imageUrl);

        print(confidenceList);

        context.read<PostBloc>().add(AddPostEvent(postWithImage));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to publish.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image and enter a description.'),
        ),
      );
    }
  }

  void _clearInputs() {
    _descriptionController.clear();
    setState(() {
      _imageFile = null;
      _selectedVideoIndex = 1; // 초기화 시 비디오 번호도 1로 리셋
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: const Text('Add post')),
        backgroundColor: Colors.white,
      ),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child:
                    _imageFile == null
                        ? Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green.shade300),
                          ),
                          child: const Center(
                            child: Text(
                              'Choose an image',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            _imageFile!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  fillColor: Colors.green.shade50,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // video number selection
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Video Number',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(10, (index) {
                        final videoNumber = index + 1;
                        final isSelected = _selectedVideoIndex == videoNumber;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedVideoIndex = videoNumber;
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.green : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.green
                                        : Colors.green.shade300,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$videoNumber',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected ? Colors.white : Colors.green,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _submitPost,
                icon: const Icon(Icons.upload),
                label: const Text('Publish Post'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
