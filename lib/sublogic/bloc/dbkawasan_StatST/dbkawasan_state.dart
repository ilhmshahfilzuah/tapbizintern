import 'package:meta/meta.dart';

@immutable
abstract class DbKawasanState {}

class InitialDbKawasanState extends DbKawasanState {}

class GetDbKawasanWaiting extends DbKawasanState {}

//---------------
class GetDbKawasanError extends DbKawasanState {
  final String errorMessage;
  GetDbKawasanError({
    required this.errorMessage,
  });
}
//---------------
//---------------
class GetDbKawasanSuccess extends DbKawasanState {
  final String listDbKawasan;
  //----
  final int JumNegeri;
  final int JumParlimen;
  final int JumDUN;
  final int JumDM;
  final int JumLokaliti;
  final int JumPemilih;
  final int JumPemilihLelaki;
  final int JumPemilihPerempuan;

  final int JumPemilihM;
  final int JumPemilihC;
  final int JumPemilihI;
  final int JumPemilihL;

  final int JumPemilihU0;
  final int JumPemilihU1;
  final int JumPemilihU2;
  final int JumPemilihU3;
  final int JumPemilihU4;
  final int JumPemilihU5;
  final int JumPemilihU6;
  final int JumPemilihU7;

  //  final int JumPemilihU0L;
  //  final int JumPemilihU0LM;
  //  final int JumPemilihU0LC;
  //  final int JumPemilihU0LI;
  //  final int JumPemilihU0LL;
  //  final int JumPemilihU0P;
  //  final int JumPemilihU0PM;
  //  final int JumPemilihU0PC;
  //  final int JumPemilihU0PI;
  //  final int JumPemilihU0PL;

  //  final int JumPemilih01L;
  //  final int JumPemilih01LM;
  //  final int JumPemilih01LC;
  //  final int JumPemilih01LI;
  //  final int JumPemilih01LL;
  //  final int JumPemilih01P;
  //  final int JumPemilih01PM;
  //  final int JumPemilih01PC;
  //  final int JumPemilih01PI;
  //  final int JumPemilih01PL;

  //  final int JumPemilih02L;
  //  final int JumPemilih02LM;
  //  final int JumPemilih02LC;
  //  final int JumPemilih02LI;
  //  final int JumPemilih02LL;
  //  final int JumPemilih02P;
  //  final int JumPemilih02PM;
  //  final int JumPemilih02PC;
  //  final int JumPemilih02PI;
  //  final int JumPemilih02PL;

  //  final int JumPemilih03L;
  //  final int JumPemilih03LM;
  //  final int JumPemilih03LC;
  //  final int JumPemilih03LI;
  //  final int JumPemilih03LL;
  //  final int JumPemilih03P;
  //  final int JumPemilih03PM;
  //  final int JumPemilih03PC;
  //  final int JumPemilih03PI;
  //  final int JumPemilih03PL;

  //  final int JumPemilih04L;
  //  final int JumPemilih04LM;
  //  final int JumPemilih04LC;
  //  final int JumPemilih04LI;
  //  final int JumPemilih04LL;
  //  final int JumPemilih04P;
  //  final int JumPemilih04PM;
  //  final int JumPemilih04PC;
  //  final int JumPemilih04PI;
  //  final int JumPemilih04PL;

  //  final int JumPemilih05L;
  //  final int JumPemilih05LM;
  //  final int JumPemilih05LC;
  //  final int JumPemilih05LI;
  //  final int JumPemilih05LL;
  //  final int JumPemilih05P;
  //  final int JumPemilih05PM;
  //  final int JumPemilih05PC;
  //  final int JumPemilih05PI;
  //  final int JumPemilih05PL;

  //  final int JumPemilih06L;
  //  final int JumPemilih06LM;
  //  final int JumPemilih06LC;
  //  final int JumPemilih06LI;
  //  final int JumPemilih06LL;
  //  final int JumPemilih06P;
  //  final int JumPemilih06PM;
  //  final int JumPemilih06PC;
  //  final int JumPemilih06PI;
  //  final int JumPemilih06PL;

  //  final int JumPemilih07L;
  //  final int JumPemilih07LM;
  //  final int JumPemilih07LC;
  //  final int JumPemilih07LI;
  //  final int JumPemilih07LL;
  //  final int JumPemilih07P;
  //  final int JumPemilih07PM;
  //  final int JumPemilih07PC;
  //  final int JumPemilih07PI;
  //  final int JumPemilih07PL;

  //----
  GetDbKawasanSuccess({
    required this.listDbKawasan,
    //----
    required this.JumNegeri,
    required this.JumParlimen,
    required this.JumDUN,
    required this.JumDM,
    required this.JumLokaliti,
    required this.JumPemilih,
    required this.JumPemilihLelaki,
    required this.JumPemilihPerempuan,
    required this.JumPemilihM,
    required this.JumPemilihC,
    required this.JumPemilihI,
    required this.JumPemilihL,
    required this.JumPemilihU0,
    required this.JumPemilihU1,
    required this.JumPemilihU2,
    required this.JumPemilihU3,
    required this.JumPemilihU4,
    required this.JumPemilihU5,
    required this.JumPemilihU6,
    required this.JumPemilihU7,

    // required this.JumPemilihU0L,
    // required this.JumPemilihU0LM,
    // required this.JumPemilihU0LC,
    // required this.JumPemilihU0LI,
    // required this.JumPemilihU0LL,
    // required this.JumPemilihU0P,
    // required this.JumPemilihU0PM,
    // required this.JumPemilihU0PC,
    // required this.JumPemilihU0PI,
    // required this.JumPemilihU0PL,

    // required this.JumPemilih01L,
    // required this.JumPemilih01LM,
    // required this.JumPemilih01LC,
    // required this.JumPemilih01LI,
    // required this.JumPemilih01LL,
    // required this.JumPemilih01P,
    // required this.JumPemilih01PM,
    // required this.JumPemilih01PC,
    // required this.JumPemilih01PI,
    // required this.JumPemilih01PL,

    // required this.JumPemilih02L,
    // required this.JumPemilih02LM,
    // required this.JumPemilih02LC,
    // required this.JumPemilih02LI,
    // required this.JumPemilih02LL,
    // required this.JumPemilih02P,
    // required this.JumPemilih02PM,
    // required this.JumPemilih02PC,
    // required this.JumPemilih02PI,
    // required this.JumPemilih02PL,

    // required this.JumPemilih03L,
    // required this.JumPemilih03LM,
    // required this.JumPemilih03LC,
    // required this.JumPemilih03LI,
    // required this.JumPemilih03LL,
    // required this.JumPemilih03P,
    // required this.JumPemilih03PM,
    // required this.JumPemilih03PC,
    // required this.JumPemilih03PI,
    // required this.JumPemilih03PL,

    // required this.JumPemilih04L,
    // required this.JumPemilih04LM,
    // required this.JumPemilih04LC,
    // required this.JumPemilih04LI,
    // required this.JumPemilih04LL,
    // required this.JumPemilih04P,
    // required this.JumPemilih04PM,
    // required this.JumPemilih04PC,
    // required this.JumPemilih04PI,
    // required this.JumPemilih04PL,

    // required this.JumPemilih05L,
    // required this.JumPemilih05LM,
    // required this.JumPemilih05LC,
    // required this.JumPemilih05LI,
    // required this.JumPemilih05LL,
    // required this.JumPemilih05P,
    // required this.JumPemilih05PM,
    // required this.JumPemilih05PC,
    // required this.JumPemilih05PI,
    // required this.JumPemilih05PL,

    // required this.JumPemilih06L,
    // required this.JumPemilih06LM,
    // required this.JumPemilih06LC,
    // required this.JumPemilih06LI,
    // required this.JumPemilih06LL,
    // required this.JumPemilih06P,
    // required this.JumPemilih06PM,
    // required this.JumPemilih06PC,
    // required this.JumPemilih06PI,
    // required this.JumPemilih06PL,

    // required this.JumPemilih07L,
    // required this.JumPemilih07LM,
    // required this.JumPemilih07LC,
    // required this.JumPemilih07LI,
    // required this.JumPemilih07LL,
    // required this.JumPemilih07P,
    // required this.JumPemilih07PM,
    // required this.JumPemilih07PC,
    // required this.JumPemilih07PI,
    // required this.JumPemilih07PL,
    //----
  });
}
//---------------