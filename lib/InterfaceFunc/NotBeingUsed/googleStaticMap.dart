

 // not being used!

class StaticMapHelper {
  static const GOOGLE_API_KEY = "AIzaSyBvcmqHZD5H9EO_JzbwRNXAvBv0NYtDegA";

  static String generateLocationPreviewImage({double? longitude, double? latitude}){
    return "https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=18&size=1920x1080&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY";
  }
}