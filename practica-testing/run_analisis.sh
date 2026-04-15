#!/bin/bash

echo "🧹 1. Limpiando compilaciones anteriores..."
rm -rf bin/* reportes/*

echo "☕ 2. Compilando código fuente y tests..."
javac -d bin -cp lib/junit.jar src/main/*.java src/tests/*.java

echo "🧪 3. Ejecutando Pruebas Unitarias con JaCoCo..."
java -javaagent:lib/jacocoagent.jar=destfile=reportes/jacoco.exec -cp bin:lib/junit.jar:lib/hamcrest.jar org.junit.runner.JUnitCore tests.CuentaBancariaTest

echo "📊 4. Generando reporte XML de cobertura..."
java -jar lib/jacococli.jar report reportes/jacoco.exec --classfiles bin --sourcefiles src/main --xml reportes/jacoco.xml

echo "🚀 5. Escaneando código y enviando a SonarQube..."
docker run --rm \
    --network host \
    -e SONAR_HOST_URL="http://localhost:9000/" \
    -v "$(pwd):/usr/src" \
    sonarsource/sonar-scanner-cli

echo "✅ ¡Análisis Terminado! Ve a http://localhost:9000"
