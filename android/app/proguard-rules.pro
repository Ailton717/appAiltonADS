# Room carga la implementacion generada de cada base de datos (<Clase>_Impl)
# por reflexion y la crea con su constructor sin argumentos. Como ninguna
# llamada del codigo referencia ese constructor, R8 lo elimina aunque conserve
# el nombre de la clase, y la creacion falla en ejecucion con
# "Failed to create an instance of ...".
-keep class * extends androidx.room.RoomDatabase {
    <init>();
}

# WorkManager guarda su estado en una base de datos Room y se inicializa a
# traves de androidx.startup, antes de que arranque el motor de Flutter. El
# SDK de Google Mobile Ads depende de WorkManager, de modo que si esa creacion
# falla la aplicacion se cierra sin llegar a dibujar nada.
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
