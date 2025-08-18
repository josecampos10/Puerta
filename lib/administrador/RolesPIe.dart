import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RolesPieChart extends StatefulWidget {
  final Map<String, int> data;

  const RolesPieChart({super.key, required this.data});

  @override
  State<RolesPieChart> createState() => _RolesPieChartState();
}

class _RolesPieChartState extends State<RolesPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.data.values.fold(0, (sum, count) => sum + count);
    Size size = MediaQuery.of(context).size;

    List<PieChartSectionData> sections = widget.data.entries.mapIndexed((i, entry) {
      final isTouched = i == touchedIndex;
      final double percentage = (entry.value / total) * 100;
      final double radius = isTouched ? 70 : 60;
      final double fontSize = isTouched ? 18 : 14;

      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        color: _getColorForRole(entry.key),
        radius: radius,
        titleStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
  setState(() {
    if (!event.isInterestedForInteractions ||
        pieTouchResponse?.touchedSection == null) {
      touchedIndex = -1;
      print('No section touched');
      return;
    }

    touchedIndex = pieTouchResponse!.touchedSection!.touchedSectionIndex;
    print('Touched index: $touchedIndex');
  });
},

        ),
        sections: sections,
        centerSpaceRadius: 30,
        sectionsSpace: 2,
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Color _getColorForRole(String role) {
    switch (role) {
      case 'Estudiantes':
        return const Color(0xFF2196F3);
      case 'Voluntarios':
        return const Color(0xFFFF9900);
      case 'Staff':
        return const Color(0xFF4CAF50);
      case 'Profesores':
        return const Color(0xFFAF4C66);
      default:
        return Colors.grey;
    }
  }
  
}

// Añade esto si estás usando `mapIndexed`:
extension MapIndexed<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E item) f) sync* {
    int i = 0;
    for (final item in this) {
      yield f(i++, item);
    }
  }
}



