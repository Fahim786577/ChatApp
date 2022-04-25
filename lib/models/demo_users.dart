import 'package:flutter/material.dart';

// const users = [
//   userGordon,
//   userSalvatore,
//   userSacha,
//   userReuben,
//   userNash,
// ];

const users  = [userFahim,userAdiba,userAkila,userGopal,userIfti,userMehrin,userNowshin,userPranto,userPrithula,userRafi,
userRingky,userRusab,userSadat
];

const userFahim = DemoUser(
  id: 'fahim786577',
  name: 'Fahim Abedin',
  image:'assets/profilepics/Fahim.png',
);

const userAdiba = DemoUser(
  id: 'adiba299026',
  name: 'Adiba Tabassum',
  image:'assets/profilepics/Adiba.png',
);

const userAkila= DemoUser(
  id: 'akila299047',
  name: 'Akila Alam',
  image:'assets/profilepics/Akila.png',
);

const userGopal = DemoUser(
  id: 'gopal299163',
  name: 'Gopal Roy',
  image:'assets/profilepics/Gopal.png',
);

const userIfti = DemoUser(
  id: 'ifti299179',
  name: 'Ifti Abir',
  image:'assets/profilepics/Ifti.png',
);

const userMehrin = DemoUser(
  id: 'mehrin299457',
  name: 'Mehrin Newaz',
  image:'assets/profilepics/Mehrin.png',
);

const userNowshin= DemoUser(
  id: 'nowshin299555',
  name: 'Nowshin Sharmily',
  image:'assets/profilepics/Nowshin.png',
);

const userPranto = DemoUser(
  id: 'pranto299469',
  name: 'Mir Pranto',
  image:'assets/profilepics/Pranto.png',
);

const userPrithula = DemoUser(
  id: 'prithula299194',
  name: 'Johayra Prithula',
  image:'assets/profilepics/Prithula.png',
);

const userRafi = DemoUser(
  id: 'rafi299386',
  name: 'Sazzad Rafi',
  image:'assets/profilepics/Rafi.png',
);

const userRingky = DemoUser(
  id: 'ringky299625',
  name: 'Samia Ringky',
  image:'assets/profilepics/Ringky.png',
);

const userRusab = DemoUser(
  id: 'rusab299575',
  name: 'Rusab Sarmun',
  image:'assets/profilepics/Rusab.png',
);

const userSadat = DemoUser(
  id: 'sadat299581',
  name: 'Sadat Islam',
  image:'assets/profilepics/Sadat.png',
);

// const userGordon = DemoUser(
//   id: 'gordon',
//   name: 'Gordon Hayes',
//   image:
//       'https://pbs.twimg.com/profile_images/1262058845192335360/Ys_-zu6W_400x400.jpg',
// );

// const userSalvatore = DemoUser(
//   id: 'salvatore',
//   name: 'Salvatore Giordano',
//   image:
//       'https://pbs.twimg.com/profile_images/1252869649349238787/cKVPSIyG_400x400.jpg',
// );

// const userSacha = DemoUser(
//   id: 'sacha',
//   name: 'Sacha Arbonel',
//   image:
//       'https://pbs.twimg.com/profile_images/1199684106193375232/IxA9XLuN_400x400.jpg',
// );

// // const userDeven = DemoUser(
// //   id: 'deven',
// //   name: 'Deven Joshi',
// //   image:
// //       'https://pbs.twimg.com/profile_images/1371411357459832832/vIy8TO9F_400x400.jpg',
// // );

// // const userSahil = DemoUser(
// //   id: 'sahil',
// //   name: 'Sahil Kumar',
// //   image:
// //       'https://pbs.twimg.com/profile_images/1324766105127153664/q96TpY8I_400x400.jpg',
// // );

// const userReuben = DemoUser(
//   id: 'reuben',
//   name: 'Reuben Turner',
//   image:
//       'https://pbs.twimg.com/profile_images/1370571324578480130/UxBBI30i_400x400.jpg',
// );

// const userNash = DemoUser(
//   id: 'nash',
//   name: 'Nash Ramdial',
//   image:
//       'https://pbs.twimg.com/profile_images/1436372495381172225/4wDDMuD8_400x400.jpg',
// );

@immutable
class DemoUser {
  final String id;
  final String name;
  final String image;

  const DemoUser({
    required this.id,
    required this.name,
    required this.image,
  });
}