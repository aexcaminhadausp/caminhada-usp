import 'package:latlong2/latlong.dart';
import 'package:app/screens/campus_route_service.dart';

class CampusManualRoutes {
  static List<LatLng>? getManualRoute(LatLng start, LatLng end) {
    //Rota biblioteca -> bandeco
    if (_samePoint(start, CampusRouteService.bibliotecaCentral) &&
        _samePoint(end, CampusRouteService.restauranteCentral)) {
      return [
        CampusRouteService.bibliotecaCentral,
        LatLng(-21.16708558837592, -47.85161960013685),
        LatLng(-21.16624516798954, -47.85188782101593),
        LatLng(-21.165514798750014, -47.85161423569864),
        LatLng(-21.16547477841503, -47.851018785347094),
        LatLng(-21.163759105095448, -47.850676750695946),
        LatLng(-21.161067681483804, -47.84897623019528),
        CampusRouteService.restauranteCentral,
      ];
    }
    // Rota bilioteca -> CEFER
    if (_samePoint(start, CampusRouteService.bibliotecaCentral) &&
        _samePoint(end, CampusRouteService.centroEsportivo)) {
      return [
        CampusRouteService.bibliotecaCentral,
        LatLng(-21.167869970398776, -47.851724025816935),
        LatLng(-21.168435247476975, -47.85179912766602),
        LatLng(-21.16890047389469, -47.852158543658035),
        CampusRouteService.centroEsportivo,
      ];
    }
    // Rota biblioteca -> Exatas
    if (_samePoint(start, CampusRouteService.bibliotecaCentral) &&
    _samePoint(end, CampusRouteService.faculdadeFilosofiaExatas)){
      return [
        CampusRouteService.bibliotecaCentral,
        LatLng(-21.167342090170678, -47.85114088157722),
        LatLng(-21.167332085211505, -47.85060980421589),
        LatLng(-21.167577206516714, -47.850035811512214),
        LatLng(-21.16728206040224, -47.84975149731493),
        LatLng(-21.1674871619996, -47.848973656735176),
        CampusRouteService.faculdadeFilosofiaExatas,
      ];
    }

    //Rota biblioteca -> Humanas
    if (_samePoint(start, CampusRouteService.bibliotecaCentral) &&
        _samePoint(end, CampusRouteService.faculdadeFilosofiaHumanas)){
      return [
        CampusRouteService.bibliotecaCentral,
        LatLng(-21.166973540798246, -47.85305054096569),
        LatLng(-21.167763932404572, -47.85395176315463),
        LatLng(-21.166353230504708, -47.85691292177545),
        LatLng(-21.16545277545157, -47.8571918715006),
        LatLng(-21.165122607225896, -47.857975076498136),
        LatLng(-21.16416211365366, -47.85879046800242),
        CampusRouteService.faculdadeFilosofiaHumanas,
      ];
    }

    //Rota Bandeco -> Biblioteca
    if (_samePoint(start, CampusRouteService.restauranteCentral) &&
        _samePoint(end, CampusRouteService.bibliotecaCentral)){
      return [
        CampusRouteService.restauranteCentral,
        LatLng(-21.160805775940585, -47.84879795354346),
        LatLng(-21.161165969928884, -47.848926699565425),
        LatLng(-21.163764181242858, -47.850643231292686),
        LatLng(-21.165037999988964, -47.85098663599653),
        LatLng(-21.165828401946488, -47.85170546801792),
        LatLng(-21.166903942115713, -47.85163573058936),
        CampusRouteService.bibliotecaCentral,
      ];
    }
    //Rota bandeco -> Cefer
    if (_samePoint(start, CampusRouteService.restauranteCentral) &&
        _samePoint(end, CampusRouteService.centroEsportivo)){
      return [
        CampusRouteService.restauranteCentral,
        LatLng(-21.160805775940585, -47.84879795354346),
        LatLng(-21.161165969928884, -47.848926699565425),
        LatLng(-21.163764181242858, -47.850643231292686),
        LatLng(-21.165037999988964, -47.85098663599653),
        LatLng(-21.16716037940614, -47.851744350050936),
        LatLng(-21.16833617813206, -47.851668244223),
        LatLng(-21.16884642672517, -47.85180771908012),
        CampusRouteService.centroEsportivo,
      ];
    }
    //Rota bandeco -> Exatas
    if (_samePoint(start, CampusRouteService.restauranteCentral) &&
        _samePoint(end, CampusRouteService.faculdadeFilosofiaExatas)){
      return [
        CampusRouteService.restauranteCentral,
        LatLng(-21.160805775940585, -47.84879795354346),
        LatLng(-21.161165969928884, -47.848926699565425),
        LatLng(-21.16298746779293, -47.85023729000318),
        LatLng(-21.16352024657229, -47.84958551324372),
        LatLng(-21.16421310624952, -47.848767439559836),
        LatLng(-21.164653333117567, -47.84825245536712),
        LatLng(-21.165323676030038, -47.84735123320894),
        CampusRouteService.faculdadeFilosofiaExatas,
      ];
    }
    //Rota bandeco -> Humanas
    if (_samePoint(start, CampusRouteService.restauranteCentral) &&
        _samePoint(end, CampusRouteService.faculdadeFilosofiaHumanas)){
      return [
        CampusRouteService.restauranteCentral,
        LatLng(-21.160696068401414, -47.84867700670414),
        LatLng(-21.16343752482807, -47.850586739587314),
        LatLng(-21.16407785769972, -47.852367726427005),
        LatLng(-21.163677649976925, -47.85464223948155),
        LatLng(-21.164337992139178, -47.85562929231655),
        LatLng(-21.16435800248998, -47.8572493466557),
        LatLng(-21.164161369505734, -47.85899595791284),
        CampusRouteService.faculdadeFilosofiaHumanas,
      ];
    }
    //Rota Exatas -> Biblioteca
    if (_samePoint(start, CampusRouteService.faculdadeFilosofiaExatas) &&
        _samePoint(end, CampusRouteService.bibliotecaCentral)){
      return [
        CampusRouteService.faculdadeFilosofiaExatas,
        LatLng(-21.167617231135512, -47.84873493918681),
        LatLng(-21.16727706277633, -47.84965761901083),
        LatLng(-21.16754719653725, -47.849941933142645),
        LatLng(-21.167362104939432, -47.85059639208758),
        LatLng(-21.167342095020807, -47.851047003176994),
        LatLng(-21.167387117325628, -47.851443970120165),
        CampusRouteService.bibliotecaCentral,
      ];
    }
    //Rota Exatas -> Cefer
    if (_samePoint(start, CampusRouteService.faculdadeFilosofiaExatas) &&
    _samePoint(end, CampusRouteService.centroEsportivo)){
      return [
        CampusRouteService.faculdadeFilosofiaExatas,
        LatLng(-21.167573776267744, -47.84877488335124),
        LatLng(-21.167243612763638, -47.84969756330438),
        LatLng(-21.168384174443304, -47.85077044686552),
        LatLng(-21.169034490760758, -47.85143563470482),
        LatLng(-21.169284611659517, -47.851972076462964),
        CampusRouteService.centroEsportivo,
      ];
    }
    //Rota Exatas -> Humanas
    if (_samePoint(start, CampusRouteService.faculdadeFilosofiaExatas) &&
        _samePoint(end, CampusRouteService.faculdadeFilosofiaHumanas)){
      return [
        CampusRouteService.faculdadeFilosofiaExatas,
        LatLng(-21.167623882789258, -47.84876551055937),
        LatLng(-21.16732373429089, -47.851158040968386),
        LatLng(-21.16698356525699, -47.85305704479223),
        LatLng(-21.167603872903914, -47.85364713090642),
        LatLng(-21.166643395436893, -47.85666193358722),
        LatLng(-21.165562850834434, -47.85719837534536),
        LatLng(-21.16439333256036, -47.85832360363666),
        CampusRouteService.faculdadeFilosofiaHumanas,
      ];
    }
    //Rota Exatas -> Bandeco
    if (_samePoint(start,CampusRouteService.faculdadeFilosofiaExatas) &&
        _samePoint(end, CampusRouteService.restauranteCentral)){
      return [
        CampusRouteService.faculdadeFilosofiaExatas,
        LatLng(-21.165323676030038, -47.84735123320894),
        LatLng(-21.164653333117567, -47.84825245536712),
        LatLng(-21.16421310624952, -47.848767439559836),
        LatLng(-21.16352024657229, -47.84958551324372),
        LatLng(-21.16298746779293, -47.85023729000318),
        LatLng(-21.161165969928884, -47.848926699565425),
        LatLng(-21.160805775940585, -47.84879795354346),
        CampusRouteService.restauranteCentral,
      ];
    }

    //Rota Humanas -> Bandeco
    if (_samePoint(start, CampusRouteService.faculdadeFilosofiaHumanas) &&
        _samePoint(end, CampusRouteService.restauranteCentral)){
      return [
        CampusRouteService.faculdadeFilosofiaHumanas,
        LatLng(-21.164161369505734, -47.85899595791284),
        LatLng(-21.16435800248998, -47.8572493466557),
        LatLng(-21.164337992139178, -47.85562929231655),
        LatLng(-21.163677649976925, -47.85464223948155),
        LatLng(-21.16407785769972, -47.852367726427005),
        LatLng(-21.16343752482807, -47.850586739587314),
        LatLng(-21.160696068401414, -47.84867700670414),
        CampusRouteService.restauranteCentral,
      ];
    }
    //Rota Humanas -> Biblioteca
    if (_samePoint(start, CampusRouteService.faculdadeFilosofiaHumanas) &&
        _samePoint(end, CampusRouteService.bibliotecaCentral)){
      return [
        CampusRouteService.faculdadeFilosofiaHumanas,
        LatLng(-21.16416211365366, -47.85879046800242),
        LatLng(-21.165122607225896, -47.857975076498136),
        LatLng(-21.16545277545157, -47.8571918715006),
        LatLng(-21.166353230504708, -47.85691292177545),
        LatLng(-21.167763932404572, -47.85395176315463),
        LatLng(-21.166973540798246, -47.85305054096569),
        CampusRouteService.bibliotecaCentral,
      ];
    }
    //Rota Humanas -> Exatas
    if (_samePoint(start, CampusRouteService.faculdadeFilosofiaHumanas) &&
        _samePoint(end, CampusRouteService.faculdadeFilosofiaExatas)){
      return [
        CampusRouteService.faculdadeFilosofiaHumanas,
        LatLng(-21.16439333256036, -47.85832360363666),
        LatLng(-21.165562850834434, -47.85719837534536),
        LatLng(-21.166643395436893, -47.85666193358722),
        LatLng(-21.167603872903914, -47.85364713090642),
        LatLng(-21.16698356525699, -47.85305704479223),
        LatLng(-21.16732373429089, -47.851158040968386),
        LatLng(-21.167623882789258, -47.84876551055937),
        CampusRouteService.faculdadeFilosofiaExatas,
      ];
    }
    //Rota Humanas -> Cefer
    if (_samePoint(start, CampusRouteService.faculdadeFilosofiaHumanas) &&
        _samePoint(end, CampusRouteService.centroEsportivo)){
      return [
        CampusRouteService.faculdadeFilosofiaHumanas,
        LatLng(-21.164704206820996, -47.857361403002145),
        LatLng(-21.165204462835284, -47.857533064364745),
        LatLng(-21.16542457494582, -47.857157555134044),
        LatLng(-21.16620496979051, -47.85698589377144),
        LatLng(-21.16768570766969, -47.853735056717056),
        LatLng(-21.168536124783945, -47.852179375403225),
        LatLng(-21.169236464593865, -47.8520399005461),
        CampusRouteService.centroEsportivo,
      ];
    }

    //Rota Cefer -> Biblioteca
    if (_samePoint(start, CampusRouteService.centroEsportivo) &&
        _samePoint(end, CampusRouteService.bibliotecaCentral)) {
      return [
        CampusRouteService.centroEsportivo,
        LatLng(-21.16890047389469, -47.852158543658035),
        LatLng(-21.168435247476975, -47.85179912766602),
        LatLng(-21.167869970398776, -47.851724025816935),
        CampusRouteService.bibliotecaCentral,
      ];
    }
    //Rota Cefer -> Bandeco
    if (_samePoint(start, CampusRouteService.centroEsportivo) &&
        _samePoint(end,CampusRouteService.restauranteCentral)){
      return [
        CampusRouteService.centroEsportivo,
        LatLng(-21.16884642672517, -47.85180771908012),
        LatLng(-21.16833617813206, -47.851668244223),
        LatLng(-21.16716037940614, -47.851744350050936),
        LatLng(-21.165037999988964, -47.85098663599653),
        LatLng(-21.163764181242858, -47.850643231292686),
        LatLng(-21.161165969928884, -47.848926699565425),
        LatLng(-21.160805775940585, -47.84879795354346),
        CampusRouteService.restauranteCentral,
      ];
    }
    //Rota Cefer -> Humanas
    if (_samePoint(start, CampusRouteService.centroEsportivo) &&
        _samePoint(end,CampusRouteService.faculdadeFilosofiaHumanas)){
      return [
        CampusRouteService.centroEsportivo,
        LatLng(-21.169236464593865, -47.8520399005461),
        LatLng(-21.168536124783945, -47.852179375403225),
        LatLng(-21.16768570766969, -47.853735056717056),
        LatLng(-21.16620496979051, -47.85698589377144),
        LatLng(-21.16542457494582, -47.857157555134044),
        LatLng(-21.165204462835284, -47.857533064364745),
        LatLng(-21.164704206820996, -47.857361403002145),
        CampusRouteService.faculdadeFilosofiaHumanas,
      ];
    }
    //Rota Cefer -> Exatas
    if (_samePoint(start, CampusRouteService.centroEsportivo) &&
        _samePoint(end, CampusRouteService.faculdadeFilosofiaExatas)){
      return [
        CampusRouteService.centroEsportivo,
        LatLng(-21.169284611659517, -47.851972076462964),
        LatLng(-21.169034490760758, -47.85143563470482),
        LatLng(-21.168384174443304, -47.85077044686552),
        LatLng(-21.167243612763638, -47.84969756330438),
        LatLng(-21.167573776267744, -47.84877488335124),
        CampusRouteService.faculdadeFilosofiaExatas,
      ];
    }
    return null;
  }

  static bool _samePoint(LatLng a, LatLng b) {
    return (a.latitude - b.latitude).abs() < 0.0001 &&
        (a.longitude - b.longitude).abs() < 0.0001;
  }
}