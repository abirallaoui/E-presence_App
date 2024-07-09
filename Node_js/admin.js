const express = require('express');
const router = express.Router();
const db = require('./db.js');

// router.get('/:id', (req, res) => {
//     const adminId = req.params.id;
  
//     // Requête SQL pour sélectionner les données de l'utilisateur par son ID
//     const sql = 'SELECT * FROM user WHERE id = ?';
  
//     // Exécuter la requête SQL avec l'ID de l'utilisateur
//     db.query(sql, [adminId], (err, result) => {
//       if (err) {
//         console.error('Erreur lors de l\'exécution de la requête SQL : ' + err.stack);
//         res.status(500).json({ success: false, message: 'Erreur lors de la récupération des données de l\'utilisateur' });
//         return;
//       }
  
//       // Vérifier si des données ont été trouvées pour l'utilisateur
//       if (result.length === 0) {
//         res.status(404).json({ success: false, message: 'Utilisateur non trouvé' });
//         return;
//       }
  
//       // Envoyer les données de l'utilisateur au format JSON
//       res.json({ success: true, user: result[0] });
//     });
//   });

// router.get('/:id', (req, res) => {
//   const userId = req.params.userId;

//   // Effectuez une requête à la base de données pour récupérer les détails de l'utilisateur avec l'ID spécifié
//   const sql = "SELECT id, nom, prenom, email FROM user WHERE id = ?";
//   db.query(sql, [userId], (err, data) => {
//       if (err) {
//           // En cas d'erreur lors de la récupération des données
//           res.status(500).json({ success: false, message: err.message });
//       } else {
//           // Vérifiez si des données ont été trouvées pour l'ID de l'utilisateur spécifié
//           if (data && data.length > 0) {
//               // Envoi des données de l'utilisateur en tant que réponse
//               res.status(200).json({ success: true, user: data[0] });
//           } else {
//               // Si aucun utilisateur n'a été trouvé pour l'ID spécifié, renvoyer un message d'erreur
//               res.status(404).json({ success: false, message: 'Utilisateur non trouvé' });
//           }
//       }
//   });
// });

// Route pour obtenir le nombre d'utilisateurs
// Route pour obtenir le nombre d'utilisateurs
router.get('/dashboard-stats', (req, res) => {
    console.log('Début de la récupération des statistiques');
  
    const queries = [
      'SELECT COUNT(*) as count FROM user',
      'SELECT COUNT(*) as count FROM user WHERE role = "prof"',
      'SELECT COUNT(*) as count FROM user WHERE role = "student"'
    ];
  
    const results = {};
  
    function runQuery(index) {
      if (index >= queries.length) {
        console.log('Réponse préparée:', results);
        return res.json(results);
      }
  
      db.query(queries[index], (error, result) => {
        if (error) {
          console.error('Erreur dans la requête:', error);
          return res.status(500).json({ error: 'Erreur lors de la récupération des statistiques', details: error.message });
        }
  
        const count = result[0].count;
        const keys = ['user', 'prof', 'student'];
        results[keys[index]] = count;
  
        console.log(`Résultat de la requête ${keys[index]}:`, count);
  
        runQuery(index + 1);
      });
    }
  
    runQuery(0);
  });
  

  module.exports = router; 
  