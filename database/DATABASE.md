# Structure de la Base de Données E-presence

## Tables

### module
- id (INT, Primary Key, Auto Increment)
- nom (VARCHAR(50), NOT NULL)
- email_prof (VARCHAR(30), NOT NULL)
- id_niveau (INT, NOT NULL)

### niveau
- id (INT, Primary Key, Auto Increment)
- nom (VARCHAR(50), NOT NULL)

### prof
- id (INT, Primary Key, Auto Increment)
- nom (VARCHAR(50), NOT NULL)
- prenom (VARCHAR(50), NOT NULL)
- email (VARCHAR(50), NOT NULL)

### scanner
- id (INT, Primary Key, Auto Increment)
- id_codeqr (INT, NOT NULL)
- id_student (INT, NOT NULL)

### student
- id (INT, Primary Key, Auto Increment)
- nom (VARCHAR(50), NOT NULL)
- prenom (VARCHAR(50), NOT NULL)
- email (VARCHAR(50), NOT NULL)
- niveau (VARCHAR(50), NOT NULL)

### codeqr

- id (INT, Primary Key, Auto Increment)
- id_prof (INT, NOT NULL)
- id_module (INT, NOT NULL)
- date (DATETIME, NOT NULL)
- id_niveau (INT, NOT NULL)
- salle (VARCHAR(20), NOT NULL)

### user
- id (INT, Primary Key, Auto Increment)
- nom (VARCHAR(20), NOT NULL)
- prenom (VARCHAR(20), NOT NULL)
- email (VARCHAR(30), NOT NULL)
- password (VARCHAR(20), NOT NULL)
- role (VARCHAR(20), NOT NULL)

### user_devices
- id (INT, Primary Key, Auto Increment)
- user_id (INT, NOT NULL)
- device_name (VARCHAR(50), NOT NULL)

### logout_timestamps
- user_id (INT, Primary Key)
- device_id (VARCHAR(255), Primary Key)
- logout_time (DATETIME)


## Contraintes et Relations

- Chaque module est associé à un niveau et à un professeur.
- Chaque code QR est associé à un professeur, un module et un niveau.
- Les présences (scanner) sont enregistrées pour chaque étudiant pour chaque code QR.
- Un utilisateur peut avoir plusieurs appareils enregistrés.
- La table 'user' est une table générique pour tous les types d'utilisateurs (étudiants, professeurs, administrateurs).
- La colonne 'role' dans la table 'user' détermine le type d'utilisateur.
- Il existe une contrainte d'unicité sur l'email du professeur.
- La table `logout_timestamps` enregistre les temps de déconnexion pour chaque utilisateur et appareil.
- Chaque code QR est associé à un professeur, un module, un niveau et une salle.
- La table codeqr est liée aux tables prof, module, et niveau.

## Clés étrangères

- `module.email_prof` fait référence à `prof.email`
- `module.id_niveau` fait référence à `niveau.id`
- `scanner.id_codeqr` fait référence à `codeqr.id`
- `scanner.id_student` fait référence à `student.id`
- `user_devices.user_id` fait référence à `user.id`
- codeqr.id_prof fait référence à prof.id
- codeqr.id_module fait référence à module.id
- codeqr.id_niveau fait référence à niveau.id

## Notes supplémentaires

- Toutes les tables utilisent le moteur InnoDB et le jeu de caractères utf8mb4_general_ci.
- Les suppressions et mises à jour en cascade sont activées pour certaines relations (voir le script SQL pour plus de détails).
