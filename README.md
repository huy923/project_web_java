# How to setup and run the project

```bash
git clone https://github.com/huy923/project_web_java.git
cd project_web_java
code .
# open the terminal and run the command
mvn clean compile
mvn tomcat7:run
```

Open your browser and go to http://localhost:8082/ to see the result. 
You can change the port number in the [pom.xml](pom.xml) file.
And the next time you run the project you just run the command `mvn tomcat7:run` again.


# How to deploy the project to the server

```bash
mvn clean compile
mvn tomcat7:deploy
```

Then you can see the result at http://localhost:8082/

# How to deploy the project to the server with the command line

```bash
scp -P 2222 target/my-web-app.war root@localhost:/var/www/html
```

Then you can see the result at http://localhost:8082/
