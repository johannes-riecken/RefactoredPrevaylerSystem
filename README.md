# Refactored Prevayler System

This project is a refactored version of the Prevayler system, which is a simple, powerful, and efficient system for transparent persistence of Java objects.

## Usage Instructions

### Installing Dependencies

To install the necessary dependencies, use Maven. Run the following command in the project directory:

```sh
mvn clean install
```

### Running the Project

To run the project and view the output, use the following command:

```sh
mvn exec:java -Dexec.mainClass="org.prevayler.demos.demo1.Main"
```

### Generating and Viewing PlantUML Diagrams

To generate and view the PlantUML diagrams, follow these steps:

1. Ensure you have PlantUML installed. You can download it from [PlantUML's website](http://plantuml.com/).
2. Navigate to the `diagrams` directory.
3. Run the following command to generate the diagrams:

```sh
plantuml demo1.puml
plantuml demo2_business.puml
```

4. Open the generated PNG files to view the diagrams.
