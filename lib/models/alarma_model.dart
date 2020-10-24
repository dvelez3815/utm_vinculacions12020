
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:utm_vinculacion/providers/alarms_provider.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';

class AlarmModel {
  int _id;
  String title;
  String description;
  DateTime time;
  bool active;
  int interval;

  static final DateTime referenceDateId = new DateTime(2020, 1, 1, 1, 1, 1);

  static DBProvider db = DBProvider.db;

  AlarmModel(this.time, {this.title, this.description}) {
    _id = generateID();
    print("$id");
    interval = 7;
    active=true;
  }


  static Future<void> showAlarm(int id) async {

    // buscando la alarma en la DB
    AlarmModel alarm = await db.getAlarma(id);

    if(alarm == null) return;

    final localNotification = FlutterLocalNotificationsPlugin();
    await localNotification.show(
      alarm.id, alarm.title, alarm.description, 
      NotificationDetails(AlarmProvider.androidChannel, AlarmProvider.iOSChannel),
      payload: id.toString()
    );
    await AlarmProvider.playSong();
  }

  ///
  /// _interval_ es cada cuanto tiempo sonara la alarma
  /// En caso de desastre, tocara reiniciar el celular :'(
  Future<void> save({int interval=7})async{

    this.interval = interval ?? this.interval;

    await reactivate();
    await db.nuevaAlarma(this);
  }

  Future<void> updateState({bool state})async{
    if((state ?? this.active)){
      await this.reactivate();
    }else{
      await this.cancelAlarm();
    }
    await db.updateAlarmState(_id, (state ?? this.active)? 1:0);
  }

  Future<void> reactivate() async {
    print("${DateTime.now().day}");
    await AndroidAlarmManager.periodic(
      // Duration(days: interval), 
      Duration(minutes: this.interval), 
      _id,
      showAlarm,
      startAt: this.time,
      rescheduleOnReboot: false // no poner true hasta estar seguros de que funciona
    );
  }

  // Cancelando la alarma (no implementada aun)
  Future<void> cancelAlarm()async{
    await AndroidAlarmManager.cancel(_id);
  }

  int generateID() {
    return secondsFromDate(DateTime.now()) - 62832762060;
  }

  int secondsFromDate(DateTime date){
    return date.year*31104000+date.month*2592000+date.day*86400+date.hour*3600+date.minute*60+date.second+date.microsecond;
  }

  Map<String, dynamic> toJson()=>{
    "id":    _id,
    "title": title,
    "body":  description,
    "active": (active ?? true)? 1:0,
    "date": "${time.year}/${time.month}/${time.day}",
    "time": "${time.hour}:${time.minute}"
  };

  AlarmModel.fromJson(Map<String, dynamic> json) {
    this._id = json["id"];
    this.title = json["title"];
    this.description = json["body"];
    this.active = json["active"]==1;

    List<int> date = json["date"].toString().split("/").map((i)=>int.parse(i)).toList();
    List<int> time = json["time"].toString().split(":").map((i)=>int.parse(i)).toList();

    this.time = new DateTime(date[0], date[1], date[2], time[0], time[1]);
    this.interval = 7;
  }

  int get id =>_id;

}