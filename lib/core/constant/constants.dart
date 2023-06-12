import 'package:footgal/features/home/screens/Tv/tv.dart';
import 'package:footgal/features/home/screens/accueil/accueil_body.dart';
import 'package:footgal/features/home/screens/matchs/match_body.dart';
import 'package:footgal/features/home/screens/profil/profil_body.dart';

class Constants {
  static const logoPath = 'assets/images/logo.png';
  static const googlePath = 'assets/images/google.png';
  static const facebookPath = 'assets/images/facebook.png';
  static const applePath = 'assets/images/apple.png';
  static const casaPath = 'assets/images/casa.jpg';
  static const dscPath = 'assets/images/dsc.jpg';
  static const footballIconPath = 'assets/images/icons/football.png';

  static final tabWidgets = [
    AccueilBody(),
    const MatchBody(),
    const TV(),
    const ProfilBody(),
  ];

  static const amicalPath =
      'https://firebasestorage.googleapis.com/v0/b/footgal-aa376.appspot.com/o/competitions%2Famical.jpg?alt=media&token=dc75dda7-01ec-4597-86a5-de278fac6fd3';
  static const lsfpPath =
      'https://firebasestorage.googleapis.com/v0/b/footgal-aa376.appspot.com/o/lsfp.jpg?alt=media&token=b79fad3a-398c-4f40-a762-cfb4ef9ee9b8';
  static const path =
      'https://firebasestorage.googleapis.com/v0/b/footgal-aa376.appspot.com/o/asd.jpg?alt=media&token=f19e9f3d-df05-4a19-a9b3-255afe02ad99';

  static const teams = [
    'Casa Sport',
    'Guediawaye FC',
    'Diambar',
    'Teungueth FC',
    'AS Douane',
    'AS Pikine',
    'Dakar Sacre Coeur',
    'Generation Foot',
    'Jaraaf FC',
    'Sonacos',
    'ASSE La Linguere',
    'Stade de Mbour',
    'CNEPS Excellence',
    'US Goree'
  ];

  static final players = [
    [
      'Alioune Badara Faty', // name
      DateTime(1999, 5, 3), // age
      'Senegal', // nationalite
      'Gardien', // position
    ],
    [
      'Pape Moussa Sene', // name
      DateTime(2000, 11, 24), // age
      'Senegal', // nationalite
      'Gardien', // position
    ],
    [
      'Babacar Foune', // name
      DateTime(1999, 1, 1), // age
      'Senegal', // nationalite
      'Gardien', // position
    ],
    [
      'Mouctar Ndiaye', // name
      DateTime(2003, 10, 31), // age
      'Senegal', // nationalite
      'Defenseur', // position
    ],
    [
      'Antoine Eugene Ndy', // name
      DateTime(2000, 6, 26), // age
      'Senegal', // nationalite
      'Defenseur', // position
    ],
    [
      'Alassane Coulibaly', // name
      DateTime(2000, 1, 27), // age
      'Senegal', // nationalite
      'Defenseur', // position
    ],
    [
      'Mohamed Camara', // name
      DateTime(2005, 1, 12), // age
      'Senegal', // nationalite
      'Defenseur', // position
    ],
    [
      'Abdoulaye Djiba', // name
      DateTime(1995, 6, 26), // age
      'Senegal', // nationalite
      'Defenseur', // position
    ],
    [
      'Abdoulaye Diédhiou', // name
      DateTime(2000, 7, 12), // age
      'Senegal', // nationalite
      'Defenseur', // position
    ],
    [
      'Pape Abasse Badji', // name
      DateTime(2003, 12, 27), // age
      'Senegal', // nationalite
      'Milieu', // position
    ],
    [
      'Etane Junior Aimé Tendeng', // name
      DateTime(2001, 1, 1), // age
      'Senegal', // nationalite
      'Milieu', // position
    ],
    [
      'Faty Dialy Bamba', // name
      DateTime(1999, 1, 15), // age
      'Senegal', // nationalite
      'Milieu', // position
    ],
    [
      'Baidy Diallo', // name
      DateTime(2002, 5, 10), // age
      'Senegal', // nationalite
      'Milieu', // position
    ],
    [
      'Yaya Sane', // name
      DateTime(2001, 8, 10), // age
      'Senegal', // nationalite
      'Milieu', // position
    ],
    [
      'Mamadou Coly', // name
      DateTime(2002, 12, 25), // age
      'Senegal', // nationalite
      'Milieu', // position
    ],
    [
      'Jules Goudiaby', // name
      DateTime(1999, 1, 1), // age
      'Senegal', // nationalite
      'Milieu', // position
    ],
    [
      'Christopher Serge Simon', // name
      DateTime(1999, 12, 6), // age
      'Senegal', // nationalite
      'Milieu', // position
    ],
    [
      'Moctar Diallo', // name
      DateTime(2004, 11, 23), // age
      'Senegal', // nationalite
      'Attaquant', // position
    ],
    [
      'Lamana Dicko', // name
      DateTime(2004, 1, 30), // age
      'Senegal', // nationalite
      'Attaquant', // position
    ],
    [
      'Abdoulie Kassama', // name
      DateTime(2000, 1, 20), // age
      'Senegal', // nationalite
      'Attaquant', // position
    ],
    [
      'Raymond Diémé Ndour', // name
      DateTime(2001, 2, 12), // age
      'Senegal', // nationalite
      'Attaquant', // position
    ],
  ];
}
