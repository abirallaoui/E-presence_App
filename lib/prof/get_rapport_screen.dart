import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../nodejs/rest_api.dart';
import 'StudentsTable.dart';

class GetRapportScreen extends StatefulWidget {
  final Map<String, dynamic>? user;
  final String? staticData1;
  final String? staticData2;
  final String? staticData3;
  final String? staticData4;
  final String? niveauName;
  final String? moduleName;

  GetRapportScreen({
    Key? key,
    this.staticData1,
    this.staticData2,
    this.staticData3,
    this.staticData4,
    this.niveauName,
    this.moduleName,
    required this.user,
  }) : super(key: key);

  @override
  _RapportPdfScreenState createState() => _RapportPdfScreenState();
}

class _RapportPdfScreenState extends State<GetRapportScreen> {
  late TextEditingController _salleController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _salleController = TextEditingController(text: widget.staticData3);
    _dateController = TextEditingController();
    _timeController = TextEditingController();
    _initializeDateTime();
    _handleInputChange();
  }

  @override
  void dispose() {
    _salleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _initializeDateTime() {
  if (widget.staticData4 != null) {
    try {
      final dateTimePart = widget.staticData4!.split('Selected Date & Time: ')[1].trim();
      final parts = dateTimePart.split(' ');
      
      if (parts[0].contains('/')) {
        // Format: "2024/6/23 14:52"
        _dateController.text = parts[0];
        _timeController.text = parts[1];
      } else if (parts[0].contains('-')) {
        // Format: "2024-06-23 13:53:11.219"
        _dateController.text = parts[0];
        _timeController.text = parts[1].split('.')[0];
      }
    } catch (e) {
      print('Erreur lors de la conversion de la date et de l\'heure: $e');
    }
  }
}
  void _handleInputChange() {
    setState(() {
      _isButtonEnabled = widget.niveauName != null &&
          widget.moduleName != null &&
          _salleController.text.isNotEmpty &&
          _dateController.text.isNotEmpty &&
          _timeController.text.isNotEmpty;
    });
  }

  void _handleSubmit() async {
  if (_isButtonEnabled) {
    try {
      DateTime parsedDateTime;
      String dateString = _dateController.text;
      String timeString = _timeController.text;
      
      // Convertir le format de date si nécessaire
      if (dateString.contains('/')) {
        List<String> dateParts = dateString.split('/');
        dateString = "${dateParts[0]}-${dateParts[1].padLeft(2, '0')}-${dateParts[2].padLeft(2, '0')}";
      }
      
      // Combiner la date et l'heure
      String dateTimeString = "$dateString $timeString";
      
      // Utiliser un format personnalisé pour le parsing
      parsedDateTime = DateFormat("yyyy-MM-dd HH:mm").parse(dateTimeString);

      List<Map<String, dynamic>> studentsData = await fetchStudentsData(
          widget.niveauName!, widget.moduleName!, parsedDateTime);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentsTableScreen(
            studentsData: studentsData,
            dateTime: parsedDateTime,
            module: widget.moduleName!,
            niveau: widget.niveauName!,
          ),
        ),
      );
    } catch (e) {
      print('Erreur détaillée: $e'); // Ajoutez cette ligne pour le débogage
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la récupération des données des étudiants: $e'),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tous les champs sont obligatoires!'),
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    bool isDataEmpty = widget.staticData1 == '' ||
        widget.staticData2 == '' ||
        widget.staticData3 == '' ||
        widget.staticData4 == '' ||
        widget.niveauName == '' ||
        widget.moduleName == '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Rapport'),
      ),
      body: isDataEmpty
          ? Center(
        child: Text(
          'Pas encore de rapport à cet instant',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Rapport Généré',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: widget.niveauName,
              decoration: InputDecoration(
                labelText: 'Niveau',
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              enabled: false,
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: widget.moduleName,
              decoration: InputDecoration(
                labelText: 'Module',
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              enabled: false,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _salleController,
              decoration: InputDecoration(
                labelText: 'Salle',
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              enabled: false,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    enabled: false,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      labelText: 'Heure',
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    enabled: false,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _handleSubmit : null,
              child: Text('Envoyer'),
            ),
          ],
        ),
      ),
    );
  }
}