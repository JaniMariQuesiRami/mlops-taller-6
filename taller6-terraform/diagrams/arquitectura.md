```mermaid
graph TD
  subgraph Docker_Network[Docker Network]
    DE[Data Eng Container\n(pandas + CSV writer)] --> V[(Shared Volume)]
    DS[Data Science Container\n(FastAPI + pandas)] --> V
  end
  V --- Storage[(Host Docker Volume)]
```

La arquitectura mantiene dos contenedores especializados: ingeniería de datos genera datasets y los escribe en el volumen compartido, mientras ciencia de datos los consume para exponer métricas vía API. Ambos servicios se comunican únicamente a través del volumen y pertenecen a la misma red Docker para facilitar observabilidad y pruebas coordinadas.
