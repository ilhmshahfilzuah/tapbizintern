import 'package:meta/meta.dart';

@immutable
abstract class DbPetugasJRJPMEvent {}

class GetDbPetugasJR extends DbPetugasJRJPMEvent {
  // final String flag;

  GetDbPetugasJR();
}
class GetDbPetugasJPMPemuda extends DbPetugasJRJPMEvent {
  // final String flag;

  GetDbPetugasJPMPemuda();
}
class GetDbPetugasJPMPuteri extends DbPetugasJRJPMEvent {
  // final String flag;

  GetDbPetugasJPMPuteri();
}
