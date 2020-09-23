import 'package:flutter/material.dart';
import 'package:utm_vinculacion/providers/db_provider.dart';
import 'package:utm_vinculacion/vistas/mobile/widgets_reutilizables.dart';

class Actividades extends StatefulWidget {
  Actividades({Key key}) : super(key: key);

  @override
  _ActividadesState createState() => _ActividadesState();
}

class _ActividadesState extends State<Actividades> {

  final DBProvider dbProvider = DBProvider.db;

  @override
  void initState() {
    dbProvider.getActividades();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,title: Text('Nombre de la app'), actions: <Widget>[
        tresPuntos()        
      ],),      
      body: listaContenido()
    );
  }

  Widget listaContenido(){
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Mis Actividades",
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.add), 
                  onPressed: (){},
                )
              ],
            ),
            StreamBuilder(
              stream: dbProvider.actividadStream,
              builder: (BuildContext context, AsyncSnapshot<List<Actividad>> snapshot){
                
                if(!snapshot.hasData) return sinDatos();

                final List<Widget> widgets = new List<Widget>();

                widgets.addAll(snapshot.data.map((item)=>ListTile(
                  onTap: (){},  
                  // Suspendido hasta que se agreguen imagenes 
                  // leading: Container(
                  //   width: MediaQuery.of(context).size.width*0.2,
                  //   child: item.rutaImagen != null?Image.asset(item.rutaImagen):Container()
                  // ),
                  subtitle: Text(item.hora),
                  title: Text(item.nombre),
                  trailing: Text(item.estado? "Activo":"Inactivo"),
                )).toList());

                return Column(
                  children: widgets,
                );

              },
            ),
          ],
        )
      ),
      
    );
  }
}