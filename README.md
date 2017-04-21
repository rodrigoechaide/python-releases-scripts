# release-me-python

Scripts para facilitar la liberación de unidades en Python

## Qué hace?
* Genera instaladores
* Genera paquetes de código fuente
* Automatiza liberaciones, actualizando versiones y realizando tags


## Cómo usarlo en mi unidad?

### Configurar
En el repositorio de la unidad:
* Crear un `requirements.txt`
* Asegurar que el archivo `setup.py` tenga la versión especificada
* (Opcional) En caso de tener más de un archivo que tenga la versión, crear un archivo `.bumpversion.cfg` especificando el mismo:

```
[bumpversion]
current_version = <versión-actual-de-desarrollo>-rc1

[bumpversion:file:setup.py]
[bumpversion:file:otro-archivo-con-version.py]
```

### Usar

**Preferentemente las liberaciones se deben hacer desde Jenkins** para eso se debe agregar un job en [python-units_seed](http://jenkins.ascentio.com.ar/jenkins/job/JobsSeeds/job/python-units_seed/)


#### Uso local

