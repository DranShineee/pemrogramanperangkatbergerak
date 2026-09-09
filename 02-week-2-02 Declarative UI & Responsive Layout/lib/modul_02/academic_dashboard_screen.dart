import 'package:flutter/material.dart';
import 'models/course.dart';
import 'widgets/course_card.dart';
import 'widgets/header_banner.dart';

class AcademicDashboardScreen extends StatefulWidget {
  const AcademicDashboardScreen({super.key});

  @override
  State<AcademicDashboardScreen> createState() => _AcademicDashboardScreenState();
}

class _AcademicDashboardScreenState extends State<AcademicDashboardScreen> {
  final List<Course> _courses = Course.getSampleCourses();
  bool _isDarkMode = false;
  
  // 1. Tambahkan variabel state untuk melacak kategori yang dipilih
  String _selectedCategory = 'Semua';

  void _toggleDarkMode() {  
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 2. Filter daftar mata kuliah berdasarkan kategori yang dipilih
    final filteredCourses = _selectedCategory == 'Semua'
        ? _courses
        : _courses.where((course) => course.category == _selectedCategory).toList();

    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0284C7),
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Dashboard Akademik TRPL',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF0284C7),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
              tooltip: _isDarkMode ? 'Mode Terang' : 'Mode Gelap',
              onPressed: _toggleDarkMode,
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            
            // 3. Ekstrak Widget Filter agar bisa dipanggil di layout tablet maupun HP
            Widget categoryFilter = Wrap(
              spacing: 8.0,
              children: ['Semua', 'Teori', 'Praktikum'].map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    }
                  },
                );
              }).toList(),
            );

            // Breakpoint 600dp: Tablet / Landscape menggunakan 2 kolom
            if (constraints.maxWidth >= 600) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kolom kiri: banner profil
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        // PERBAIKAN: Masukkan parameter courses dan hapus const
                        child: HeaderBanner(courses: _courses), 
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Kolom kanan: grid 2 kolom daftar mata kuliah
                    Expanded(
                      flex: 3,
                      // Bungkus GridView dengan Column agar Filter bisa diletakkan di atasnya
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          categoryFilter, // Tambahkan Filter di sini
                          const SizedBox(height: 16),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.4,
                              ),
                              itemCount: filteredCourses.length, // Gunakan filteredCourses
                              itemBuilder: (context, index) {
                                // Gunakan filteredCourses
                                return CourseCard(course: filteredCourses[index]);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            // Default (smartphone): tata letak 1 kolom vertikal
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // PERBAIKAN: Masukkan parameter courses dan hapus const
                HeaderBanner(courses: _courses),
                const SizedBox(height: 16),
                
                // Tambahkan Filter di sini (di atas teks daftar)
                categoryFilter,
                const SizedBox(height: 16),
                
                Text(
                  // Update jumlah terdaftar berdasarkan data yang sudah difilter
                  'Mata Kuliah Semester 5 (${filteredCourses.length} Terdaftar)',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                // Gunakan filteredCourses
                ...filteredCourses.map((course) => CourseCard(course: course)),
              ],
            );
          },
        ),
      ),
    );
  }
}