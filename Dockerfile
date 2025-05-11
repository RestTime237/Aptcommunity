FROM openjdk:17-jdk-slim

# 작업 디렉토리 설정
WORKDIR /app

# 환경 변수 설정
ENV JAVA_HOME=/usr/local/openjdk-17

# 프로젝트 파일 복사
COPY . .

# 실행 권한 부여
RUN chmod +x ./gradlew

# Gradle 빌드 시 gradle.properties 생성
RUN mkdir -p ~/.gradle && \
    echo "org.gradle.java.home=/usr/local/openjdk-17" > ~/.gradle/gradle.properties

# Gradle을 사용하여 프로젝트 빌드
RUN ./gradlew build -x test

# WAR 파일 실행 명령
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "build/libs/AptCommunitySB.war"]