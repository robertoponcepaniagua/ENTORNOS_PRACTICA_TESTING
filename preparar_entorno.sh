#!/bin/bash

# ==========================================
# Script de Preparación de Entorno (Sin Código)
# Práctica: TDD y SonarQube
# ==========================================

DIR="practica-testing"

echo "🚀 Preparando el entorno de la práctica en la carpeta '$DIR'..."

# 1. Crear estructura de directorios vacía
mkdir -p $DIR/{src/main,src/tests,bin,lib,reportes}
cd $DIR

# 2. Descargar librerías necesarias (.jar)
echo "📦 Descargando librerías (JUnit, Hamcrest, JaCoCo)..."
curl -s -o lib/junit.jar https://repo1.maven.org/maven2/junit/junit/4.13.2/junit-4.13.2.jar
curl -s -o lib/hamcrest.jar https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar
curl -s -o lib/jacocoagent.jar https://repo1.maven.org/maven2/org/jacoco/org.jacoco.agent/0.8.11/org.jacoco.agent-0.8.11-runtime.jar
curl -s -o lib/jacococli.jar https://repo1.maven.org/maven2/org/jacoco/org.jacoco.cli/0.8.11/org.jacoco.cli-0.8.11-nodeps.jar

# 3. Crear archivo Docker Compose
echo "🐳 Creando docker-compose.yml..."
cat << 'EOF' > docker-compose.yml
version: '3.8'
services:
  db:
    image: postgres:14
    environment:
      - POSTGRES_USER=sonar
      - POSTGRES_PASSWORD=sonar
      - POSTGRES_DB=sonarqube
  sonarqube:
    image: sonarqube:community
    ports:
      - "9000:9000"
    environment:
      - SONAR_JDBC_URL=jdbc:postgresql://db:5432/sonarqube
      - SONAR_JDBC_USERNAME=sonar
      - SONAR_JDBC_PASSWORD=sonar
    depends_on:
      - db
EOF

# 4. Crear archivo de propiedades para SonarQube
echo "📝 Creando sonar-project.properties..."
cat << 'EOF' > sonar-project.properties
sonar.projectKey=banco-java-puro
sonar.projectName=Sistema Bancario Java
sonar.projectVersion=1.0

# Credenciales por defecto
sonar.login=admin
sonar.password=admin

# Rutas del proyecto
sonar.sources=src/main
sonar.tests=src/tests
sonar.java.binaries=bin
sonar.coverage.jacoco.xmlReportPaths=reportes/jacoco.xml
EOF

# 5. Crear el script de análisis que usarán los alumnos
echo "⚙️ Generando script de análisis (run_analisis.sh)..."
cat << 'EOF' > run_analisis.sh
#!/bin/bash

echo "🧹 1. Limpiando compilaciones anteriores..."
rm -rf bin/* reportes/*

echo "☕ 2. Compilando código fuente y tests..."
javac -d bin -cp lib/junit.jar src/main/*.java src/tests/*.java

echo "🧪 3. Ejecutando Pruebas Unitarias con JaCoCo..."
java -javaagent:lib/jacocoagent.jar=destfile=reportes/jacoco.exec -cp bin:lib/junit.jar:lib/hamcrest.jar org.junit.runner.JUnitCore CuentaBancariaTest

echo "📊 4. Generando reporte XML de cobertura..."
java -jar lib/jacococli.jar report reportes/jacoco.exec --classfiles bin --sourcefiles src/main --xml reportes/jacoco.xml

echo "🚀 5. Escaneando código y enviando a SonarQube..."
docker run --rm \
    --network host \
    -e SONAR_HOST_URL="http://localhost:9000/" \
    -v "$(pwd):/usr/src" \
    sonarsource/sonar-scanner-cli

echo "✅ ¡Análisis Terminado! Ve a http://localhost:9000"
EOF

chmod +x run_analisis.sh

echo "======================================================"
echo "✅ ¡Entorno listo en la carpeta '$DIR'!"
echo "======================================================"
echo "📂 Estructura generada para el alumno:"
echo "  - src/main/   -> (Vacía. Aquí deben crear CuentaBancaria.java)"
echo "  - src/tests/  -> (Vacía. Aquí deben crear CuentaBancariaTest.java)"
echo "  - lib/        -> (Librerías descargadas)"
echo "  - docker-compose.yml"
echo "  - sonar-project.properties"
echo "  - run_analisis.sh"
echo "======================================================"