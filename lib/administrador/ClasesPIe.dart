import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ClasesPieChart extends StatefulWidget {
  const ClasesPieChart({super.key});

  @override
  State<ClasesPieChart> createState() => _ClasesPieChartState();
}

class _ClasesPieChartState extends State<ClasesPieChart> {
  final List<String> clases = [
    'Corte1',
    'Corte2',
    'ESLam',
    'ESLam2',
    'ESLchick',
    'ESLclifton',
    'ESLpm',
    'ESLpm2',
    'GEDam',
    'GEDpm',
    'ciudadania',
    'cosmetologia',
    'costuraAM',
  ];

  Map<String, int> claseCounts = {};
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchInscritosPorClase();
  }

  Future<void> fetchInscritosPorClase() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    Map<String, int> tempCounts = {for (var clase in clases) clase: 0};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      for (var clase in clases) {
        if (data[clase]?.toString().toLowerCase() == 'inscrito') {
          tempCounts[clase] = tempCounts[clase]! + 1;
        }
      }
    }

    setState(() {
      claseCounts = tempCounts;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (claseCounts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final total = claseCounts.values.fold(0, (sum, count) => sum + count);

    List<PieChartSectionData> sections = claseCounts.entries
        .where((entry) => entry.value > 0)
        .mapIndexed((i, entry) {
      final isTouched = i == touchedIndex;
      final double percentage = (entry.value / total) * 100;
      final double radius = isTouched ? 70 : 60;
      final double fontSize = isTouched ? 18 : 14;

      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        color: _getColorForClass(entry.key),
        radius: radius,
        titleStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      );
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse?.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse!
                        .touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: sections,
              centerSpaceRadius: 30,
              sectionsSpace: 2,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: claseCounts.entries
              .where((entry) => entry.value > 0)
              .map((entry) => Chip(
                    label: Text('${entry.key} (${entry.value})'),
                    backgroundColor: _getColorForClass(entry.key),
                    labelStyle: const TextStyle(color: Colors.white),
                  ))
              .toList(),
        )
      ],
    );
  }

  Color _getColorForClass(String className) {
    // Asigna colores únicos (puedes personalizar más)
    final colorList = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.cyan,
      Colors.amber,
      Colors.indigo,
      Colors.brown,
      Colors.pink,
      Colors.deepOrange,
      Colors.lime,
    ];

    final index = clases.indexOf(className);
    return colorList[index % colorList.length];
  }
}

// Extensión para mapIndexed
extension MapIndexed<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E item) f) sync* {
    int i = 0;
    for (final item in this) {
      yield f(i++, item);
    }
  }
}



