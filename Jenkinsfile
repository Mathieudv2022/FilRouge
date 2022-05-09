pipeline {
  agent none
  environment {
    ID_DOCKER = "matt2022dockertp"
    IMAGE_NAME = "django"
    // IMAGE_TAG = "nightly"
    DOCKERHUB_PASSWORD = credentials('dockerhubpassword')
    IMAGE_POSTGRES = "docker.io/postgres:14.2-alpine"
  }

  stages {
    stage('Init vars') {
      agent any
      steps{
        script {
          sh 'echo start init vars'
          if ($GIT_BRANCH == 'origin/main'){
            echo 'main'
            IMAGE_TAG = "staging"
          } 
          if ($GIT_BRANCH == 'origin/release') {
            echo 'release'
            IMAGE_TAG = "latest"
          }
        }
      }
    }

    stage('Build image - Front End Django only') {
      agent any
      steps {
        script {
          sh 'docker build -t ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG ./'
        }
      }
    }

    stage('Run container based on builded image (Django only-no DB)') {
      agent any
      steps {
        script {
          sh '''
            docker rm -f $IMAGE_NAME
            docker run --rm --name $IMAGE_NAME -d -p 8000:8000 ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG
            sleep 5
          '''
        }
      }
    }

    stage('Test Successfull: Django is active and NOK on Access- cause missing-Database') {
      agent any
      steps {
        script {
          sh '''
            docker logs django > filelog
            if grep -q Retry filelog; then echo "Successfully failed: no db response!"; else exit 1; fi;
            docker stop $IMAGE_NAME
          '''
        }
      }
    }

    stage('Test Fonctionnel: Database Postgres only') {
      agent any
      steps {
        script {
          sh '''
            docker rm -f postgres
            docker run -tdi --rm --name postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres $IMAGE_POSTGRES
            sleep 5
            docker exec postgres psql --username=postgres
            docker stop postgres
          '''
        }
      }
    }

    stage('Build & Run Appli Django complète = 2 running containers') {
      agent any
      steps {
        script {
          sh '''
            docker-compose up -d
            sleep 10
          '''
        }
      }
    }

     stage('Test image Appli Django complète (avec sa DB Postgres)') {
       agent any
       steps {
         script {
          sh '''
            curl http://localhost:8000 | grep -i "album"
          '''
         }
       }
     }

     stage('Clean Container de Django only') {
       agent any
       steps {
         script {
           sh '''
            docker-compose down
          '''
         }
       }
     }

      stage('Login and Push de Django Image (only) on Docker hub') {
        agent any
        steps {
          script {
            sh '''
              echo $DOCKERHUB_PASSWORD | docker login -u $ID_DOCKER --password-stdin
              docker push ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG
            '''
         }
       }
     }

  }
}