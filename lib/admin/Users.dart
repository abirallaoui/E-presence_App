import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pfa/nodejs/utils.dart';

class UserScreen extends StatefulWidget {
  final Map<String, dynamic>? user;

  UserScreen({Key? key, this.user}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Map<String, int> stats = {'Users': 0, 'Professeur': 0, 'Etudiants(e)': 0};

  @override
  void initState() {
    super.initState();
    fetchDashboardStats();
  }

  Future<void> fetchDashboardStats() async {
    try {
      final response = await http.get(Uri.parse('${Utils.baseUrl}/admin/dashboard-stats'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          stats['Users'] = data['user'] ?? 0;
          stats['Professeur'] = data['prof'] ?? 0;
          stats['Etudiants(e)'] = data['student'] ?? 0;
        });
      } else {
        print('Erreur lors de la récupération des statistiques. Status code: ${response.statusCode}');
        print('Réponse du serveur: ${response.body}');
      }
    } catch (e) {
      print('Exception lors de la récupération des statistiques: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          Text(
            "Dashboard",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * 0.8,
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.2,
                      children: [
                        _buildCard("Users", stats['Users'] ?? 0, Icons.people, Colors.blue),
                        _buildCard("Professeur", stats['Professeur'] ?? 0, Icons.school, Colors.green),
                        _buildCard("Etudiants(e)", stats['Etudiants(e)'] ?? 0, Icons.person, Colors.orange),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, int count, IconData icon, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          print('Tapped on $title');
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: color),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}