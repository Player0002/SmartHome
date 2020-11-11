const appTitle = "조家네 가정집";
const serverIp = "http://192.168.10.190:8080/";

const String defaultSvg = 'assets/svgs/sun.svg';
const Map<String, String> assetLocation = {
  'led': 'assets/svgs/led.svg',
  'room': 'assets/svgs/home.svg',
  'dust': 'assets/svgs/dust.svg',
  'dth': 'assets/svgs/humidity.svg',
  'waterStatus': 'assets/svgs/pump.svg',
  'neoPixel': 'assets/svgs/rgb.svg',
  'gate': 'assets/svgs/gate.svg',
  'servo': 'assets/svgs/gate.svg',
  'camera': 'assets/svgs/cam.svg',
};
final cams = {
  1: '${serverIp.substring(0, serverIp.length - 6)}:8000/live/ROOM1.flv',
  2: '${serverIp.substring(0, serverIp.length - 6)}:8000/live/ROOM2.flv',
  3: '${serverIp.substring(0, serverIp.length - 6)}:8000/live/ROOM3.flv',
  4: '${serverIp.substring(0, serverIp.length - 6)}:8000/live/ROOM4.flv',
  5: '${serverIp.substring(0, serverIp.length - 6)}:8000/live/ROOM5.flv',
};
